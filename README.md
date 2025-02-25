# Eval Class for AutoHotkey v2
This class allows for strings containing basic math expressions to be mathematically evaluated.  
Passing in a string like this: `"2 + 2"`  
Will return a number like this: `4`  

I may expand on its operator and number supporter later, but for now it's functional for basic expressions.

## Properties:  

There is only one property to set.  

* `decimal_type`: Allows for setting the type of decimal place used in the expression, such as `.` or `,`.

## Use:

To evaluate something, pass the string directly to the class.

    str := '3+8/4+1'
    num := Eval(str)

    ; Shows 3+8/4+1 = 6
    MsgBox(str ' = ' num)

Currently, the only operators supported are:

  * `( ... )` : Parentheses or sub-expressions
  * `**` : Powers / Exponentiation
  * `//` : Integer division
  * `/` : True division
  * `+` : Addition
  * `-` : Subtraction

Floats are allowed.  
Negative numbers are allowed.  
Scientific notation is not supported.
