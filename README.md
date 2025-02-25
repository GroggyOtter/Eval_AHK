# Eval Class for AutoHotkey v2

I created an evaluations function a couple years ago for v1.  
Someone requested eval support the other day so it prompted me to rewrite it for v2.  

This class allows for strings containing basic math expressions to be mathematically evaluated.  
Passing in a string like this: `"2 + 2"`  
Will return a number like this: `4`  

I may expand on its operator and number supporter later, but for now it's functional for basic expressions.

## Use:

To evaluate something, pass the string directly to the class.  
The evaluated number will be returned.  

    str := '3 + 8 / 4 + 1'
    num := Eval(str)

    ; Shows 3 + 8 / 4 + 1 = 6
    MsgBox(str ' = ' num)

## Properties:  

There is only one property to set.  

* `decimal_type`: Allows for setting the type of decimal place used in the expression, such as `.` or `,`.  
  Default is a period `.`

## Operator support:

Currently, the only operators supported are:

  * `( ... )` : Parentheses or sub-expressions
  * `**` : Powers / Exponentiation
  * `//` : Integer division
  * `/` : True division
  * `+` : Addition
  * `-` : Subtraction

## Number support:

Floats are allowed.  
Negative numbers are allowed.  
Scientific notation is not yet supported.

## Feature requests and bug reporting

If you would like to make a request for a feature or if you find a bug with the current setup, please let me know via the issues tab.

I'm open to any suggestions/requests if I find it to be a reasonable addition and can find the time.  

Thanks.
