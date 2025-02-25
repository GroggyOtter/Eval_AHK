/************************************************************************
 * @description Eval Class for AutoHotkey v2
 * @author GroggyOtter
 * @date 2025/02/22
 * @version 1.0.0
 ***********************************************************************/

/**
 * @classdesc Used to evaluate expressions in string form.
 * Order of operations followed:
 * 
 * `( ... )` - Parentheses/SubExp  
 * `**` - Exponents  
 * `//` - Integer division  
 * `/` - Division  
 * `*` - Multiplication  
 * `+` - Addition  
 * `-` - Subtraction  
 * @example
 * str := '12 + 2 * (3 ** 2) - 2 / 2'
 * MsgBox(Eval(str))
 */
class eval {
    #Requires AutoHotkey v2.0.19+
    ; Set decimal type to whatever you use e.g. '.' or ','
    static decimal_type := '.'
    
    static Call(str) {
        ; Strip out all whitespace
        for ws in [' ', '`t', '`n', '`r']                                                           ; Loop through each type of white space
            str := StrReplace(str, ws)                                                              ;   Strip all white space from string
        
        ; Loop until all sub-expressions are resolved
        while subex := this.get_subexp(str)                                                         ; While there is still a sub-exp to process
            value := this.resolve(subex)                                                            ;   Resolve sub-exp to a single value
            ,str := StrReplace(str, '(' subex ')', value)                                           ;   Update string by replacing sub-exp with value
        return this.resolve(str)                                                                    ; Resolve final expression and return
    }
    
    static resolve(str) {                                                                           ; Resolves an expression to a single value
        for op in ['**', '*', '//', '/', '+', '-'] {                                                ; Respect operator precedence
            while (op_pos := InStr(str, op, 1, 2)) {                                                ;   While operator exists
                left := this.get_num(str, op_pos, 0)                                                ;     Get number left of operator
                right := this.get_num(str, op_pos+StrLen(op)-1, 1)                                  ;     Get number right of operator
                switch op {
                    case '**' : value := left ** right                                              ;     Exponentiation
                    case '*' : value := left * right                                                ;     Multiplication
                    case '//' : value := Integer(left) // Integer(right)                            ;     Integer division
                    case '/' : value := left / right                                                ;     True division
                    case '+' : value := left + right                                                ;     Addition
                    case '-' : value := left - right                                                ;     Subtraction
                    default: this.throw_error(2, A_ThisFunc, 'Operator: ' op)                       ;     Symbol not supported. Error notification
                }
                str := StrReplace(str, left op right, value)                                        ;     Update expression with new resolved value
            }
        }
        return str
    }
    
    static get_num(str, start, right) {                                                             ; Get number left of operator
        update := right ? 1 : -1
        decimal := 0                                                                                ; Track number of decimals encountered
        req_num := 0                                                                                ; Track required number after decimal
        pos := start + update                                                                       ; Set pos to current operator + offset
        loop {                                                                                      ; Loop backward through chars
            char := SubStr(str, pos, 1)                                                             ;   Get next previous char
            if req_num                                                                              ;   If post-decimal number check required
                if is_num(char)                                                                     ;     If char is a digit
                    req_num := 0                                                                    ;       Reset decimal requirement check
                else this.throw_error(req_num, A_ThisFunc, str)                                     ;     Else Error notification
                        
            switch char {                                                                           ;   Check char
                case '0','1','2','3','4','5','6','7','8','9': pos_update()                          ;   CASE: Number check. Update for next char
                case this.decimal_type:                                                             ;   CASE: Decimal check
                    if !is_num(char_next())
                        this.throw_error(1, A_ThisFunc, str)
                    pos_update()
                    decimal++
                    req_num := 1                                                                    ;     Update pos, decimal count, and require number
                    if (decimal > 1)                                                                ;     If there is more than one decimal in the number
                        this.throw_error(3, A_ThisFunc, str)                                        ;       Error notification
                case '-':                                                                           ;   CASE: Negation check
                    next := char_next()                                                             ;     Get next char from sequence
                    if (right) {                                                                    ;     If getting right side number
                        if (A_Index = 1)                                                            ;       If first char after -
                            if is_num(next)                                                         ;         If number
                                pos_update()                                                        ;           Update pos as normal
                            else this.throw_error(7, A_ThisFunc, str)                               ;         Else error notification 7 (number after -)
                        else {                                                                      ;       Else found next opeartor or number
                            pos_reverse()                                                           ;         Go back a pos
                            break                                                                   ;         And end of number
                        }
                    } else {                                                                        ;     Else getting left side number
                        if (A_Index = 1)                                                            ;       If first (last) character
                            this.throw_error(7, A_ThisFunc, str)                                    ;         Error notification
                        else if (next = '')                                                         ;       Else if next is nothing
                            break                                                                   ;         Start of number
                        else if is_num(next)                                                        ;       Else if number, too far
                            pos_reverse()                                                           ;         Minus is subtraction, not negation
                        break                                                                       ;     
                    }
                default:                                                                            ;   CASE: Default (No char present or other)
                    pos_reverse()                                                                   ;     Final position update
                    break                                                                           ;     End search
            }
        }
        ; Get number based on left/right side and return
        if right
            result := SubStr(str, start+1, pos-start)
        else result := SubStr(str, pos, start-pos)
        return result
        
        is_num(n) => InStr('0123456789', n)                                                         ; Value is a number
        pos_update() => pos += update                                                               ; Move to next position
        pos_reverse() => pos -= update                                                              ; Move back a position
        char_next() => SubStr(str, pos+update, 1)                                                   ; Get next char in sequence
    }
    
    static error_codes := Map(
        1, 'A decimal must have numbers on both sides of it.', 
        2, 'Unsupported symbol found.',
        3, 'A number cannot have more than one decimal.',
        4, 'Parenthesis mismatch. There are too many of one kind.',
        5, 'A number must come after a negation sign.',
        6, 'Parentheses out of order.',
        7, 'The negative sign must be the first character of the number.'
    )
    
    static throw_error(code, fn, extra?) {                                                          ; Error handler
        throw Error(this.error_codes[code], fn, extra ?? unset)
    }
        
    ; Pass in string expression
    ; Returns substring or 0 if no substring found
    ; Throws error if open and close paren count do not match
    static get_subexp(str) {
        start := InStr(str, '(', 1)                                                                 ; Confirm an opening paren
        end := InStr(str, ')', 1)                                                                   ; Confirm a closing paren
        if !start && !end                                                                           ; If neither
            return 0                                                                                ;   Return 0 for no parens found
        if (start > end)                                                                            ; Error, parens not in order
            throw Error(6, A_ThisFunc, str)                                                         ;   Error notification
        if !start || !end {                                                                         ; If one found by not other
            StrReplace(str, '(', '(', 1, &o)                                                        ;   Do a count of open parens
            StrReplace(str, ')', ')', 1, &c)                                                        ;   Do a count of close parens
            this.throw_error(4, A_ThisFunc, 'Opened: ' o ', Closed: ' c)                            ;   Error notification
        }
        loop {                                                                                      ; Looking for innermost parens
            next_o := InStr(str, '(', 1, start + 1)                                                 ;   Get next opening paren after current
            
            if (!next_o || next_o > end)                                                            ;   If no more opening paren
                break                                                                               ;     Break. Sub-expression found
            if (next_o < end)                                                                       ;   else if next open paren is before closing paren
                start := next_o                                                                     ;     Update start spot to new paren
        }
        return SubStr(str, start+1, end-start-1)                                                    ; Remove expresison between innermost substring
    }
}
