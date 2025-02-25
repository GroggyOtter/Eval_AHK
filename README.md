# Eval Class for AutoHotkey v2
- [Table of contents](#eval-class-for-autohotkey-v2)
- [Intro](#intro)
- [Use](#use)
- [Properties](#properties)
- [Operator support](#operator-support)
- [Number support](#number-support)
- [Example Code](#example-code)
- [v1 support](#v1-support)
- [Feature requests and bug reporting](#feature-requests-and-bug-reporting)

# Intro

I created an evaluations function a couple years ago for v1.  
Someone requested eval support the other day so it prompted me to rewrite it for v2.  

This class allows for strings containing basic math expressions to be mathematically evaluated.  
Passing in a string like this: `"2 + 2"`  
Will return a number like this: `4`  

I may expand on its [operator support](#operator-support) and [number support](#number-support) later on, but for now it's functional for basic expressions.

# Use
[`Back To Top`](#eval-class-for-autohotkey-v2)

To evaluate something, pass the string directly to the class.  
The evaluated number will be returned.  

    str := '8 + 8 / (3 + 1)'
    num := Eval(str)

    ; Shows 8 + 8 / (3 + 1) = 10.0
    MsgBox(str ' = ' num)

# Properties
[`Back To Top`](#eval-class-for-autohotkey-v2)

There is only one property to set.  

* `decimal_type`: Allows for setting the type of decimal place used in the expression, such as `.` or `,`.  
  Default is a period `.`



# Operator support
[`Back To Top`](#eval-class-for-autohotkey-v2)

Currently, the the basic math operators are supported:

  * `( ... )` : Parentheses or sub-expressions
  * `**` : Powers / Exponentiation
  * `*` : Multiplication
  * `//` : Integer division
  * `/` : True division
  * `+` : Addition
  * `-` : Subtraction

# Number support
[`Back To Top`](#eval-class-for-autohotkey-v2)

* Integers are allowed: `123`
* Floats are allowed: `3.14156`
* Negative numbers are allowed: `-22.22`
* Scientific notation is **not** supported:  `1e12`  

# Example Code

    test()

    test() {
        examples := [
            '2+2',
            '(1+2+3+4) * 10',
            '-200.5 * -100.5 + 55',
            '8**2 + 1', 
            '(2+2) * (3 * (2 + 8) + 3 ** 3 - 26.5) - 42.42 ** 2 / 4',
            '-7--7--11.5--22.5-5.5-5--5.5',
            '2 * (1 + (1 + (-200.5 * -100.5 + 55) // 5) * 10 / 5 ** 2) * 2 + 1'
        ]
        
        view := ''
        for example in examples
            MsgBox(example ' = ' eval(example))
    }

# v1 support
[`Back To Top`](#eval-class-for-autohotkey-v2)

There is a v1 version of the script in the `src` folder.  
There is no decimal type support.  
Call the eval function and pass in the string: `eval(str)`

    MsgBox, % evaluate("25+25+(50*50)")
    MsgBox, % evaluate("(4.5 + -2.5) ** (2 * (5 // 2)) - -1")
    MsgBox, % evaluate("1+8*2/0.5**2")

# Feature requests and bug reporting
[`Back To Top`](#eval-class-for-autohotkey-v2)

If you would like to make a request for a feature or if you find a bug with the current setup, please let me know via the issues tab.

I'm open to any suggestions/requests if I find it to be a reasonable addition and can find the time.  

Enjoy the code and use it in good health.
