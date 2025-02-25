; Description: Eval Class for AutoHotkey v1
; Author GroggyOtter
; Date: 2023/04/02
; Version: 1.0.0


; Evaluates a string
; Operators (In order of operations)
;   Parentheses     ( ... )
;   Exponents       **
;   Multiplication  *
;   Floor division  //
;   Division        /
;   Addition        +
;   Subtraction     -
evaluate(str, first:=1) {
    Static ops := ["\*\*", "\*", "\/\/", "\/", "\+", "\-"]
    Static rgx := {"para" :"(.*?)\(([\d|\+|\-|\*|\/|\.]*?)\)(.*?)$"
                  ,"num1" :"(.*?)(-?\d+(?:\.\d+)?)"
                  ,"num2" :"(-?\d+(?:\.\d+)?)(.*?)"}

    If first {                                                      ; Only do during first time run
        StrReplace(str, "(", "(", pOpen)                            ; Count open parens
        StrReplace(str, ")", ")", pClose)                           ; Count close parens
        If (pOpen != pClose)                                        ; Error if they don't match
            Return "Error. Open/close parentheses mismatch."
        str := StrReplace(str, " ")                                 ; Remove all spaces
        While RegExMatch(str, rgx.para, m)                          ; If parens still exist
            str := m1 evaluate(m2, 0) m3                            ; Recursively eliminate them
    }

    For i, o in ops                                                 ; Loop through each operator
        While RegExMatch(str, rgx.num1 "(" o ")" rgx.num2 "$", m)   ; While "number sign number" exists
            Switch m3 {                                             ; Check sign and do appropriate operation
                case "**" : str := m1 (m2 ** m4) m5
                case "*"  : str := m1 (m2 * m4)  m5
                case "//" : str := m1 (m2 // m4) m5
                case "/"  : str := m1 (m2 / m4)  m5
                case "+"  : str := m1 (m2 + m4)  m5
                case "-"  : str := m1 (m2 - m4)  m5
            }

    While InStr(str, ".") && (SubStr(str, 0) = 0)                   ; If decimal and ends in 0
        str := SubStr(str, 1, -1)                                   ; Remove the zero
    return RTrim(str, ".")                                          ; Return after removing trailing decimal
}
