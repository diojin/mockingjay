# 			Digest of A Byte of Python
---
## Indexes
* [Recommendations](#recommendations)
* [About Python](#about-python)
    - [Features of Python](#features-of-python)
* [Installation](#installation)
    - [Choosing An Editor](#choosing-an-editor)
        + [Vim](#vim)
        + [Emacs](#emacs)
* [First Steps](#first-steps)
    - [How to Quit the Interpreter Prompt](#how-to-quit-the-interpreter-prompt)
    - [Getting Help](#getting-help)
* [Basics](#basics)
    - [Numbers](#numbers)
    - [Strings](#strings)
    - [Escape Sequences](#escape-sequences)
        + [Raw String](#raw-string)
    - [Variable](#variable)
        + [Data Types](#data-types)
    - [Indentation](#indentation)
* [Operators and Expressions](#operators-and-expressions)
    - [Evaluation Order](#evaluation-order)
* [Control Flow](#control-flow)
    - [The global statement](#the-global-statement)
    - [Default Argument Values](#default-argument-values)
    - [VarArgs parameters](#varargs-parameters)
    - [DocStrings](#docstrings)
* [Modules](#modules)
    - [Byte-compiled .pyc files](#byte-compiled-pyc-files)
    - [Making Your Own Modules](#making-your-own-modules)
    - [The dir function](#the-dir-function)
    - [Packages](#packages)
* [Data Structures](#data-structures)
    - [List](#list)
    - [Tuple](#tuple)
    - [Dictionary](#dictionary)
    - [Sequence](#sequence)
    - [Set](#set)
    - [More About Strings](#more-about-strings)
* [Problem Solving](#problem-solving)
* [Object Oriented Programming](#object-oriented-programming)
    - [The self](#the-self)
    - [Inheritance](#inheritance)
* [Input and Output](#input-and-output)
    - [Files](#files)
    - [Pickle](#pickle)
    - [Unicode](#unicode)
* [Exceptions](#exceptions)
    - [The with statement](#the-with-statement)
* [Standard Library](#standard-library)
    - [sys module](#sys-module)
    - [logging module](#logging-module)
* [More](#more)
    - [Passing tuples around](#passing-tuples-around)
    - [Special Methods](#special-methods)
    - [Single Statement Blocks](#single-statement-blocks)
    - [Lambda Forms](#lambda-forms)
    - [List Comprehension](#list-comprehension)
    - [Receiving Tuples and Dictionaries in Functions](#receiving-tuples-and-dictionaries-in-functions)
    - [The assert statement](#the-assert-statement)
    - [Decorators](#decorators)
    - [Differences between Python 2 and Python 3](#differences-between-python-2-and-python-3)
* [What Next](#what-next)
* [Miscellaneous](#miscellaneous)

## Recommendations
If you are a data scientist and don’t have much experience with Python, the books [Learning Python] and [Head First Python] (both O’Reilly) are excellent introductions. If you have some Python experience and want more, [Dive into Python] (Apress) is a great book to help you get a deeper understanding of Python.  

If you are an engineer and after reading this book you would like to expand your data analysis skills, [Machine Learning for Hackers] and [Doing Data Science] are excellent books (both O’Reilly).

## About Python

Python is one of those rare languages which can claim to be both simple and powerful.

The official introduction to Python is:  
Python is an easy to learn, powerful programming language. It has `efficient high-level data structures` and a simple but effective approach to `object-oriented programming`. Python's elegant syntax and `dynamic typing`, together with `its interpreted nature`, make it an ideal language for scripting and rapid application development in many areas on most platforms.

### Features of Python
* Simple   
Reading a good Python program feels almost like reading English, although very strict English
* Easy to Learn  
* Free and Open Source  
* High-level Language  
never need to bother about the low-level details such as managing the memory used by your program
* Portable  
Due to its open-source nature, Python has been ported to (i.e. changed to make it work on) many platforms. `All your Python programs can work on any of these platforms without requiring any changes at all if you are careful enough to avoid any system-dependent features`.  
You can use Python on GNU/Linux, Windows, FreeBSD, Macintosh, Solaris, OS/2, Amiga, AROS, AS/400, BeOS, OS/390, z/OS, Palm OS, QNX, VMS, Psion, Acorn RISC OS, `VxWorks`, `PlayStation`, Sharp Zaurus, Windows CE and PocketPC!  
You can even use a platform like [Kivy] to create games for your computer and for iPhone, iPad, and Android.  
* Interpreted  
Python converts the source code into an intermediate form called bytecodes and then translates this into the native language of your computer and then runs it.  
* Object Oriented  
* Extensible 
If you need a critical piece of code to run very fast or want to have some piece of algorithm not to be open, you can code that part of your program `in C or C++` and then use it from your Python program.
* Embeddable  
You can embed Python within your C/C++ programs to give scripting capabilities for your program's users.
* Extensive Libraries  
The Python Standard Library is huge indeed.  
Besides the standard library, there are various other high-quality libraries which you can find at the [Python Package Index].

* Eric S. Raymond is the author of "The Cathedral and the Bazaar" and is also the person who coined the term Open Source. He says that Python has become his favorite programming language. This article was the real inspiration for my first brush with Python. 
* `Bruce Eckel` is the author of the famous 'Thinking in Java' and 'Thinking in C++' books. He says that no language has made him more productive than Python. He says that Python is perhaps the only language that focuses on making things easier for the programmer. Read the complete interview for more details. 
* Peter Norvig is a well-known Lisp author and `Director of Search Quality at Google` (thanks to Guido van Rossum for pointing that out). He says that writing Python is like writing in pseudocode. `He says that Python has always been an integral part of Google. You can actually verify this statement by looking at the Google Jobs page which lists Python knowledge as a requirement for software engineers.`

## Installation
**On Windows **  
Visit https://www.python.org/downloads/ and download the latest binary version,  simple install, and set PATH varible.

### Choosing An Editor
If you have no idea where to start, I would recommend using [PyCharm Educational Edition] software which is available on Windows, Mac OS X and GNU/Linux.

#### Vim
1. Install Vim  
    * Mac OS X users should install `macvim` package via [HomeBrew]
    * Windows users should download the "self-installing executable" from [Vim] website
    * GNU/Linux users should get Vim from their distribution's software repositories, e.g. Debian and Ubuntu users can install the vim package.
2. Install [jedi-vim] plugin for autocompletion.
3. Install corresponding jedi python package : `pip install -U jedi`

#### Emacs
1. Install [Emacs 24+].  
    * Mac OS X users should get Emacs from http://emacsformacosx.com
    * Windows users should get Emacs from http://ftp.gnu.org/gnu/emacs/windows/
    * GNU/Linux users should get Emacs from their distribution's software repositories,  e.g. Debian and Ubuntu users can install the emacs24 package.
2. Install [ELPY]

**From others**:  
>ipython notebook，it is now called jupter notebook.

## First Steps
There are two ways of using Python to run your program - using the interactive interpreter prompt or using a source file.   
* Using The Interpreter Prompt  
```python
$ python3
>>> print("hello world")
hello world
```
* using a source file  
```python
$ python hello.py
hello world
```

Note that Python is `case-sensitive`. Also, `ensure there are no spaces or tabs before the first character in each line` - we will see why this is important later ([Indentation](#indentation)).

### How to Quit the Interpreter Prompt
* For Linux
[ctrl + d] or entering exit(), followed by the [enter] key.
* For Windows  
[ctrl + z] followed by the [enter] key.

### Getting Help

If you need quick information about any function or statement in Python, then you can use the built-in `help` functionality. This is very useful especially when using the interpreter prompt. For example, run  
```python
help('len')
```

## Basics  

### Numbers
Numbers are mainly of two types - integers and floats.  
Examples of floating point numbers (or floats for short) are 3.23 and 52.3E-4 . The Enotation indicates powers of 10. In this case, `52.3E-4` means `52.3 * 10^-4^`.

`There is no separate long type`. The `int` type can be an integer of any size.  

### Strings
You can specify strings using followings:  
* Single Quote  
All white space i.e. spaces and tabs, within the quotes, are preserved as-is.  
* Double Quotes  
Strings in double quotes `work exactly the same way as strings in single quotes`  
* Triple Quotes  
You can specify multi-line strings using triple quotes - ( """ or ''' ). You can use single quotes and double quotes freely within the triple quotes. An example is:  
```python
'''This is a multi-line string. This is the first line.
This is the second line.
"What's your name?," I asked.
He said "Bond, James Bond."
'''
```

Strings Are Immutable.  

>**Note for C/C++ Programmers**  
There is no separate `char` data type in Python. There is no real need for it and I am
sure you won't miss it.

#### The format method  
```python
age=20
name = 'Swaroop'

print('{0} was {1} years old when he wrote this book'.format(name, age))
# note that the numbers are optional, so it can  be written as 
print('{} was {} years old when he wrote this book'.format(name, age))

# or we can format string by ourselves
name + ' is ' + str(age) + ' years old'
name+' is ' + str(age) + ' years old'

# decimal (.) precision of 3 for float '0.333'
print('{0:.3f}'.format(1.0/3))
# fill with underscores (_) with the text centered
# (^) to 11 width '___hello___'
print('{0:_^11}'.format('hello'))
# keyword-based 'Swaroop wrote A Byte of Python'
print('{name} wrote {book}'.format(name='Swaroop', book='A Byte of Python'))
```

Since we are discussing formatting, note that `print` always ends with an invisible `"new line" character ( \n )` so that repeated calls to print will all print on a separate line each. To prevent this newline character from being printed, you can specify that it should end with a blank:  
```python
print('a', end='')
print('b', end=' ')
print('c')
# Output is:
# ab c
```

### Escape Sequences
Use the backslash '\' to escape, and other alternatives, for example,  to escape a single quote, '      
1. 'What\'s your name?'
2. "What's your name?"

One thing to note is that in a string, a single backslash at the end of the line indicates that the string is continued in the next line, but no newline is added. For example:
```python
"This is the first sentence. \
This is the second sentence."
```
is equivalent to  
```python
"This is the first sentence. This is the second sentence."
```

\n,   newline  
\t,   tab character  

#### Raw String
If you need to specify some strings where no special processing such as escape sequences are handled, then what you need is to specify a raw string by prefixing r or R to the string. An example is:  
```python
r"Newlines are indicated by \n"
```
>**Note for Regular Expression Users**  
`Always use raw strings when dealing with regular expressions`. Otherwise, a lot of backwhacking may be required. For example, backreferences can be referred to as  
'\\1' or r'\1' .

### Variable
**There are some rules you have to follow for naming identifiers**:    
* The first character of the identifier must be a letter of the alphabet (uppercase ASCII or lowercase ASCII or Unicode character) or an underscore ( _ ).
* The rest of the identifier name can consist of letters (uppercase ASCII or lowercase ASCII or Unicode character), underscores ( _ ) or digits (0-9).
* Identifier names are case-sensitive. 
* Examples of valid identifier names are `i`, `name_2_3` . Examples of invalid identifier names are `2things`, `this is spaced out`, `my-name` and `>a1b2_c3`.

PS: In short, `my-name` is invalid identifier.  
#### Data Types
The basic types are numbers and strings, and user defined types using classes.  

`Python is strongly object-oriented in the sense that everything is an object including numbers, strings and functions.`

Variables are used by just assigning them a value. No declaration or data type definition is needed/used.

### Indentation
Whitespace is important in Python. `Actually, whitespace at the beginning of the line is important`. This is called indentation. Leading whitespace (spaces and tabs) at the beginning of the logical line is used to determine the indentation level of the logical line, which in turn is used to determine the grouping of statements. 

`This means that statements which go together must have the same indentation`. `Each such set of statements is called a` **block**. We will see examples of how blocks are important in later chapters.

One thing you should remember is that wrong indentation can give rise to errors. For example:  
```python
i = 5
# Error below! Notice a single space at the start of the line
 print('Value is', i)
print('I repeat, the value is', i)
```
When you run this, you get the following error:  
```html
    File "whitespace.py", line 3
        print('Value is', i)
        ^
IndentationError: unexpected indent
```
Notice that there is a single space at the beginning of the second line. The error indicated by Python tells us that the syntax of the program is invalid i.e. the program was not properly written. `What this means to you is that you cannot arbitrarily start new blocks of statements (except for the default main block which you have been using all along, of course).` Cases where you can use new blocks will be detailed in later chapters such as the control flow.  

**How to indent**  
`Use four spaces for indentation. This is the official Python language recommendation`. Good editors will automatically do this for you. Make sure you use a consistent number of spaces for indentation, otherwise your program will not run or will have unexpected behavior. 

**Note to static language programmers**  
`Python will always use indentation for blocks and will never use braces`. Run `from __future__ import braces` to learn more.

If you want to specify more than one logical line on a single physical line, then you have to explicitly specify this using a semicolon (;) which indicates the end of a logical line/statement. For example, following are the same  
```python
# line ending
i = 5
print(i)
i = 5;
print(i);
i = 5;print(i)
```

However, I strongly recommend that you stick to writing a maximum of a single logical line on each single physical line. The idea is that you should never use the semicolon. `In fact, I have never used or even seen a semicolon in a Python program`.

Similarly,  
```python
i = \
5
```
is the same as  
```python
i = 5
```

## Operators and Expressions
```python
>>> 'la' * 3
'lalala'

>>> 2 ** 10
1024

## // (divide and floor)
## Divide x by y and round the answer down to the nearest whole number
>>> 14 // 3
4
>>> -14 // 3
-5
>>> 13 // 3
4
>>> -13 // 3
-5

>>> 13 % 3 
1 
>>> -25.5 % 2.25
1.5
```

~ (bit-wise invert), The bit-wise inversion of x is -(x+1)

### Evaluation Order
The following table gives the precedence table for Python, from the lowest precedence (least binding) to the highest precedence (most binding).   
* lambda : Lambda Expression
* if - else : Conditional expression
* ...
* x[index], x[index:index], x(arguments...), x.attribute : Subscription, slicing, call, attribute reference
* (expressions...), [expressions...], {key: value...}, {expressions...} : Binding or tuple display, list display, dictionary display, set display

## Control Flow

**if**  

```python
number = 23
guess = int(input('Enter an integer : '))
if guess == number:
    # New block starts here
    print('Congratulations, you guessed it.')
    print('(but you do not win any prizes!)')
    # New block ends here
elif guess < number:
    # Another block
    print('No, it is a little higher than that')
    # You can do whatever you want in a block ...
else:
    print('No, it is a little lower than that')
    # you must have guessed > number to reach here
    print('Done')
    # This last statement is always executed,
    # after the if statement is executed.
    
if True:
print('Yes, it is true')
```

There is `no switch statement` in Python. You can use an if..elif..else statement to do the same thing (and in some cases, use a [Dictionary](#dictionary) to do it quickly.  

**while**  
Remember that you can have an else clause for the while loop. If there is an else clause for a while loop, it is always executed unless you break out of the loop with `a break statement`.

```python
while guess >= number:
    print("loop again")
    guess -= 1
else:
    print("loop over")
```

**for**  
```python
for i in range(1, 5):
    print(i)
else:
    print("for loop is over")
```
We generate this sequence of numbers using the built-in range function.
For example, range(1,5) gives the sequence [1, 2, 3, 4]  
Note that range() generates only one number at a time, if you want the full list of numbers, call list() on the range() , for example, list(range(5)) will result in [0, 1, 2, 3, 4]  

Remember that the else part is optional. When included, it is always executed once after the for loop is over unless a break statement is encountered.  

Remember that the for..in loop works for any sequence.  

An important note is that if you break out of a for or while loop, any corresponding loop else block is not executed.

The continue statement is used to tell Python to skip the rest of the statements in the current loop block and to continue to the next iteration of the loop.

## Functions

```python
def say_hello():
    # block belonging to the function
    print('hello world')
# End of function
say_hello() # call the function

def findMax(a, b):
    if a >= b :
        return a
    else:
        return b
print(findMax(3,5))

```

### The global statement
```python
x=10

def globalTest():
    print("x is {}".format(x))
    x=20

globalTest()
print("now x is {}".format(x))
```
Code above throws `UnboundLocalError: local variable 'x' referenced before assignment`

```python
x=10

def globalTest():
    global x
    print("x is {}".format(x))
    x=20

globalTest()
print("now x is {}".format(x))
```

### Default Argument Values
Note that the default argument value should be a constant. More precisely, the default argument value should be immutable.
```python
def say(message, times=1):
    print(message * times)
say('Hello')
say('World', 5)
```

Only those parameters which are at the end of the parameter list can be given default argument values. This is because the values are assigned to the parameters by position. For example, def func(a, b=5) is valid, but def func(a=5, b) is not valid.

### Keyword Arguments
```python
def func(a, b=5, c=10):
    print('a is', a, 'and b is', b, 'and c is', c)
func(3, 7)
func(25, c=24)
func(c=50, a=100)

```

### VarArgs parameters
When we declare a starred parameter such as *param , then all the `positional arguments` from that point till the end are collected as a tuple called 'param'.  

Similarly, when we declare a double-starred parameter such as **param , then all the `keyword arguments` from that point till the end are collected as a dictionary called 'param'.

```python
def total(a=5, *numbers, **phonebook):
    print('a', a)
    #iterate through all the items in tuple
    for single_item in numbers:
        print('single_item', single_item)
    #iterate through all the items in dictionary
    for first_part, second_part in phonebook.items():
        print(first_part,second_part)

print(total(10,1,2,3,Jack=1123,John=2231,Inge=1560))
```

Note that a return statement without a value is equivalent to return **None** . **None** is a special type in Python that represents nothingness. Every function implicitly contains a return None statement at the end unless you have written your own return statement.

The **pass** statement is used in Python to indicate an empty block of statements.  
```python
def some_function():
    pass
```

### DocStrings
Python has a nifty feature called documentation strings, usually referred to by its shorter name **docstrings**. DocStrings are an important tool that you should make use of since it helps to document the program better and makes it easier to understand. Amazingly, `we can even get the docstring back from, say a function, when the program is actually running`!

Note that DocStrings also apply to modules and classes.

```python
def print_max(x, y):
    '''Prints the maximum of two numbers.

    The two values must be integers.'''
    # convert to integers, if possible
    x = int(x)
    y = int(y)
    if x > y:
        print(x, 'is maximum')
    else:
        print(y, 'is maximum')
print_max(3, 5)
# same as help(print_max)
print(print_max.__doc__)
```

```shell
$ python function_docstring.py
5 is maximum
Prints the maximum of two numbers.

    The two values must be integers.
```

`The convention followed for a docstring` is a multi-line string where the first line starts with a capital letter and ends with a dot. Then the second line is blank followed by any detailed explanation starting from the third line. You are strongly advised to follow this convention for all your docstrings for all your non-trivial functions.

`Just remember that Python treats everything as an object and this includes functions.`

If you have used `help()` in Python, then you have already seen the usage of docstrings! What it does is just fetch the __doc__ attribute of that function and displays it in a neat manner for you. You can try it out on the function above - just include `help(print_max)` in your program.  

Automated tools can retrieve the documentation from your program in this manner. Therefore, I strongly recommend that you use docstrings for any non-trivial function that you write. The **pydoc** command that comes with your Python distribution works similarly to help() using docstrings.

## Modules
What if you wanted to reuse a number of functions in other programs that you write? As you might have guessed, the answer is modules.  

There are various methods of writing modules, but the simplest way is to create a file with a .py extension that contains functions and variables.  

Another method is to `write the modules in the native language in which the Python interpreter itself was written`. For example, you can write modules in the C programming language and when compiled, they can be used from your Python code when using the standard Python interpreter.

A module can be imported by another program to make use of its functionality. This is how we can use the Python standard library as well.

The **sys** module contains functionality related to the Python interpreter and its environment i.e. the system.

When Python executes the import sys statement, it looks for the sys module. In this case, it is one of the built-in modules, and hence Python knows where to find it.

If it was not a compiled module i.e. a module written in Python, then the Python interpreter will search for it in the directories listed in its `sys.path` variable. If the module is found, then the statements in the body of that module are run and the module is made available for you to use. Note that `the initialization is done only the first time that we import a module`.

The argv variable in the sys module is accessed using the dotted notation i.e. sys.argv .

Remember, the name of the script running is always the first element in the sys.argv list. So, in this case we will have 'module_using_sys.py' as `sys.argv[0]`.

```python
import sys
print('The command line arguments are:')
for i in sys.argv:
    print(i)
print('\n\nThe PYTHONPATH is', sys.path, '\n')
```

The `sys.path` contains the list of directory names where modules are imported from. Observe that the first string in sys.path is empty - this empty string indicates that `the current directory is also part of the sys.path which is same as the` **PYTHONPATH** `environment variable`. This means that you can directly import modules located in the current directory.

Note that the current directory is the directory from which the program is launched. Run `import os; print(os.getcwd())` to find out the current directory of your program.

### Byte-compiled .pyc files
Importing a module is a relatively costly affair, so Python does some tricks to make it faster. One way is to create byte-compiled files with the extension .pyc which is an intermediate form that Python transforms the program into. Also, these byte-compiled files are platform independent.

NOTE: These .pyc files are usually created in the same directory as the corresponding .py files. If Python does not have permission to write to files in that directory, then the .pyc files will not be created.

If you want to directly import the argv variable into your program (to avoid typing the sys.everytime for it), then you can use the from sys import argv statement.
>WARNING: In general, avoid using the from..import statement, use the import statement instead. This is because your program will avoid name clashes and will be more readable.

```python
from math import sqrt
print("Square root of 16 is", sqrt(16))
```

Every module has a name and statements in a module can find out the name of their module. This is handy for the particular purpose of figuring out whether the module is being run standalone or being imported. As mentioned previously, when a module is imported for the first time, the code it contains gets executed. We can use this to make the module behave in different ways depending on whether it is being used by itself or being imported from another module. This can be achieved using the `__name__` attribute of the module.

`Example (save as module_using_name.py ):`  
```python
if __name__ == '__main__':
    print('This program is being run by itself')
else:
    print('I am being imported from another module')
```

```shell
$ python module_using_name.py
This program is being run by itself

$ python
>>> import module_using_name
I am being imported from another module
>>>
```

### Making Your Own Modules
Creating your own modules is easy, you've been doing it all along! This is because every Python program is also a module. You just have to make sure it has a .py extension. The following example should make it clear.  

`Example (save as mymodule.py )`:  
```python
def say_hi():
    print('Hi, this is mymodule speaking.')
__version__ = '0.1'
```

```python
import mymodule

mymodule.say_hi()
print('Version', mymodule.__version__)

from mymodule import say_hi, __version__
say_hi()
print('Version', __version__)
```

Notice that if there was already a __version__ name declared in the module that imports mymodule, there would be a clash. This is also likely because it is common practice for each module to declare it's version number using this name. Hence, it is always recommended to prefer the `import` statement. (PS: but rather the `from ... import ... statement` )

You could also use:  
```python
from mymodule import *
```
This will import all public names such as say_hi but would not import __version__ because it starts with double underscores.   
**WARNING**:  Remember that you should avoid using import-star.

>Zen of Python  
One of Python's guiding principles is that "Explicit is better than Implicit". Run `import this` in Python to learn more.

```shell
$ python
>>> import this
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
>>>
```

### The dir function
Built-in dir() function returns list of names defined by an object. If the object is a module, this list includes functions, classes and variables, defined inside that module.  

```python
# get names of attributes in sys module
>>> dir('sys')
['__displayhook__', '__doc__',
'argv', 'builtin_module_names',
'version', 'version_info']

# only few entries shown here
# get names of attributes for current module
>>> dir()
['__builtins__', '__doc__',
'__name__', '__package__', 'sys']
```
Notice that the list of imported modules of current modules is also part of dir().

### Packages
By now, you must have started observing the hierarchy of organizing your programs. Variables usually go inside functions. Functions and global variables usually go inside modules. What if you wanted to organize modules? That's where packages come into the picture.

Packages are just folders of modules with a special `__init__.py` file that indicates to Python that this folder is special because it contains Python modules.

Let's say you want to create a package called 'world' with subpackages 'asia', 'africa', etc. and these subpackages in turn contain modules like 'india', 'madagascar', etc.
```html
- <some folder present in the sys.path>/
    - world/
        - __init__.py
        - asia/
            - __init__.py
            - india/
                - __init__.py
                - foo.py
        - africa/
            - __init__.py
            - madagascar/
                - __init__.py
                - bar.py
```

## Data Structures
There are four built-in data structures in Python - `list, tuple, dictionary and set`.

### List
The list of items should be enclosed in square brackets so that Python understands that you are specifying a list.
```python
# This is my shopping list
shoplist = ['apple', 'mango', 'carrot', 'banana']
print('I have', len(shoplist), 'items to purchase.')
print('These items are:', end=' ')
for item in shoplist:
    print(item, end=' ')
print()
print('\nI also have to buy rice.')
shoplist.append('rice')
print('My shopping list is now', shoplist)
print('I will sort my list now')
shoplist.sort()
print('Sorted shopping list is', shoplist)

print('The first item I will buy is', shoplist[0])
olditem = shoplist[0]
del shoplist[0]
print('I bought the', olditem)
print('My shopping list is now', shoplist)
```

Then, we sort the list by using the sort method of the list. It is important to understand that this method affects the list itself and does not return a modified list - this is different from the way strings work. This is what we mean by saying that `lists are mutable` and that `strings are immutable`.

### Tuple
Tuples are used to hold together multiple objects. `Think of them as similar to lists, but without the extensive functionality that the list class gives you`. `One major feature of tuples is that they are immutable` like strings i.e. you cannot modify tuples.

Tuples are defined by specifying items separated by commas within an optional pair of parentheses.

```python
# I would recommend always using parentheses
# to indicate start and end of tuple
# even though parentheses are optional.
# Explicit is better than implicit.
zoo = ('python', 'elephant', 'penguin')
print('Number of animals in the zoo is', len(zoo))
new_zoo = 'monkey', 'camel', zoo # parentheses not required but are a good idea
print('Number of cages in the new zoo is', len(new_zoo))
print('All animals in new zoo are', new_zoo)
print('Animals brought from old zoo are', new_zoo[2])
print('Last animal brought from old zoo is', new_zoo[2][2])
print('Number of animals in the new zoo is',
        len(new_zoo)-1+len(new_zoo[2]))
```
Tuple with 0 or 1 items:  
```python
myempty = ()
singleton = (2 , )
```
You have to specify it using a comma following the first (and only) item so that Python can differentiate between a tuple and a pair of parentheses surrounding the object in an expression.

### Dictionary
Note that you can use only immutable objects (like strings) for the keys of a dictionary but you can use either immutable or mutable objects for the values of the dictionary.

The dictionaries that you will be using are instances/objects of the **dict** class.

For the list of methods of the dict class, see help(dict) .
```shell
$ python -c help(dict)
```

```python
# 'ab' is short for 'a'ddress'b'ook
ab = {
'Swaroop': 'swaroop@swaroopch.com',
'Larry': 'larry@wall.org',
    'Matsumoto': 'matz@ruby-lang.org',
    'Spammer': 'spammer@hotmail.com'
}
print("Swaroop's address is", ab['Swaroop'])

# Deleting a key-value pair
del ab['Spammer']
print('\nThere are {} contacts in the address-book\n'.format(len(ab)))

for name, address in ab.items():
    print('Contact {} at {}'.format(name, address))

# Adding a key-value pair
ab['Guido'] = 'guido@python.org'

if 'Guido' in ab:
    print("\nGuido's address is", ab['Guido'])
```

Next, we access each key-value pair of the dictionary using the items method of the dictionary which returns `a list of tuples` where each tuple contains a pair of items - the key followed by the value.

We can check if a key-value pair exists using the `in` operator.

>**Keyword Arguments and Dictionaries **  
If you have used keyword arguments in your functions, you have already used dictionaries! Just think about it - the key-value pair is specified by you in the parameter list of the function definition and when you access variables within your function, it is just a key access of a dictionary (which is called the symbol table in compiler design terminology).

### Sequence
`Lists, tuples and strings` are examples of sequences, but what are sequences and what is so special about them?

The major features are membership tests, (i.e. the `in` and `not in` expressions) and `indexing operations`, which allow us to fetch a particular item in the sequence directly.  

```python
shoplist = ['apple', 'mango', 'carrot', 'banana']
name = 'swaroop'
# Indexing or 'Subscription' operation #
print('Item 0 is', shoplist[0])
print('Item 1 is', shoplist[1])
print('Item 2 is', shoplist[2])
print('Item 3 is', shoplist[3])
print('Item -1 is', shoplist[-1])           ## banana
print('Item -2 is', shoplist[-2])
print('Character 0 is', name[0])

# Slicing on a list #
print('Item 1 to 3 is', shoplist[1:3])              ## ['mango', 'carrot']
print('Item 2 to end is', shoplist[2:])
print('Item 1 to -1 is', shoplist[1:-1])
print('Item start to end is', shoplist[:])

# Slicing on a string #
print('characters 1 to 3 is', name[1:3])
print('characters 2 to end is', name[2:])
print('characters 1 to -1 is', name[1:-1])
print('characters start to end is', name[:])
```

The index can also be a negative number, in which case, the position is calculated from the end of the sequence. Therefore, shoplist[-1] refers to the last item in the sequence and shoplist[-2] fetches the second last item in the sequence.

The slicing operation is used by specifying the name of the sequence followed by an optional pair of numbers separated by a colon within square brackets. Remember the numbers are optional but the colon isn't. ( PS: [Inclusive: exclusive) )   
**WARNING**: slicing operation returns a copy of original sequence. 

### Set
Sets are unordered collections of simple objects.  
```python
bri = set(['brazil', 'russia', 'india'])
print('brazil' in bri)                             ## True
print('brazil' not in bri)                      ## False
bric = bri.copy()                                  
bric.add('china')                                
print(bric.issuperset(bri))                 ## True
bri.remove('russia')

print(bri & bric)                               ## {'brazil', 'india'}
bri.intersection(bric)                       ## {'brazil', 'india'} 
```

### More About Strings
The strings that you use in programs are all objects of the class `str`.

```python
# This is a string object
name = 'Swaroop'
if name.startswith('Swa'):
    print('Yes, the string starts with "Swa"')
if 'a' in name:
    print('Yes, it contains the string "a"')
if name.find('war') != -1:
    print('Yes, it contains the string "war"')
delimiter = '_*_'
mylist = ['Brazil', 'Russia', 'India', 'China']
print(delimiter.join(mylist))
```

## Problem Solving

**Copy and zip files**:  
PS: import statement can be at anyplace of a source file, not only at the top  
PS: backslash is required for plus operation extending more than one line.  
On careful observation, we see that the single logical line has been split into two physical lines but we have not specified that these two physical lines belong together. Remember that we can specify that the logical line continues in the next physical line by the use of a backslash at the end of the physical line.

```python
import os
import time

# 1. The files and directories to be backed up are
# specified in a list.
# Example on Windows:
# source = ['"C:\\My Documents"']
# Example on Mac OS X and Linux:
source = ['/Users/swa/notes']
# Notice we have to use double quotes inside a string
# for names with spaces in it. We could have also used
# a raw string by writing [r'C:\My Documents'].

target_dir = '/Users/swa/backup'

# notice, the backslash \ is mandatory, otherwise, there is compile error
target = target_dir + os.sep + \
                        time.strftime('%Y%m%d%H%M%S') + '.zip'

if not os.path.exists(target_dir):
    os.mkdir(target_dir) # make directory

zip_command = 'zip -r {0} {1}'.format(target,
            ' '.join(source))

if os.system(zip_command) == 0:
    print('Successful backup to', target)
else:
    print('Backup FAILED')
```

You can use the `zipfile` or `tarfile` built-in modules to create these archives. They are part of the standard library.

## Object Oriented Programming

### The self
Class methods have only one specific difference from ordinary functions - they must have an extra first parameter that has to be added to the beginning of the parameter list, but you do not give a value for this parameter when you call the method, Python will provide it. `This particular variable refers to the object itself`, and `by convention, it is given the name` **self** .

Say you have a class called MyClass and an instance of this class called myobject . When you call a method of this object as `myobject.method(arg1, arg2)` , this is automatically converted by Python into `MyClass.method(myobject, arg1, arg2)` - this is all the special `self` is about.

```python
class  Person:
    def __init__(self, name):
        self.name = name
    def say_hi(self):
        print('Hello, my name is', self.name)

p = Person('Swaroop')
print(p)            ## <__main__.Person instance at 0x10171f518>

p.say_hi()
```
It tells us that we have an instance of the Person class in the __main__ module.

**The __init__ method**  
The __init__ method is run as soon as an object of a class is instantiated (i.e. created). The method is useful to do any initialization (i.e. passing initial values to your object) you want to do with your object.

The data part, i.e. fields, are nothing but ordinary variables that are `bound to the namespaces of the classes and objects`. This means that these names are valid within the context of these classes and objects only. That's why they are called name spaces.

There are two types of fields - class variables and object variables which are classified depending on whether the class or the object owns the variables respectively.

```python
class Robot:
        """Represents a robot, with a name."""
        # A class variable, counting the number of robots
        population = 0
        def __init__(self, name):
                """Initializes the data."""
                self.name = name
                print("(Initializing {})".format(self.name))
                Robot.population += 1

        def say_hi(self):
                """Greeting by the robot.

                Yeah, they can do that."""
                print("Greetings, my masters call me {}.".format(self.name))

        @classmethod
        def how_many(cls):
                """Prints the current population."""
                print("We have {:d} robots.".format(cls.population))

droid1 = Robot("R2-D2")
droid1.say_hi()
Robot.how_many()

droid2 = Robot("C-3PO")
droid2.say_hi()
# class method can be invoked by objects
droid2.how_many()

# following  statements  do nothing, methods are not invoked
# they are typos obviously, lack of parenthesis, but surprisingly there were no errors
droid1.say_hi
Robot.how_many
```
Also note that an object variable with the same name as a class variable will hide the class variable!

Instead of `Robot.population` , we could have also used `self.__class__.population` because every object refers to its class via the `self.__class__` attribute.

The how_many is actually a method that belongs to the class and not to the object. This means we can define it as either a `classmethod` or a `staticmethod` depending on whether we need to know which class we are part of. Since we refer to a class variable, let's use classmethod .

We have marked the how_many method as a class method using a **decorator**.

**Decorators** can be imagined to be `a shortcut to calling a wrapper function` (i.e. a function that "wraps" around another function so that it can do something before or after the inner function), so applying the @classmethod decorator is the same as calling: `how_many = classmethod(how_many)`

In this program, we also see the use of docstrings for classes as well as methods. We can access the class docstring at runtime using `Robot.__doc__` and the method docstring as `Robot.say_hi.__doc__`

`All class members are public`. One exception: If you use data members with names `using the double underscore prefix such as __privatevar` , Python uses name-mangling to effectively make it a private variable.

All class members (including the data members) are public and all the methods are virtual in Python.

### Inheritance
To use inheritance, we specify the base class names in a tuple following the class name in the class definition (for example, class Teacher(SchoolMember) ). Next, we observe that the `__init__` method of the base class is explicitly called using the self variable so that we can initialize the base class part of an instance in the subclass. Python does not automatically call the constructor of the base class.   

In contrast, if we have not defined an __init__ method in a subclass, Python will call the constructor of the base class automatically.

A note on terminology - if more than one class is listed in the inheritance tuple, then it is called `multiple inheritance`.

## Input and Output
```python
def reverse(text):
    return text[::-1]

something = input("Enter text: ")

print(something)

# slicing with step
teststr = "abcdefg"
print(teststr[2:5:2])     ## ce
print(teststr[::-1])        ## gfedcba
```

We use the slicing feature to reverse the text. We've already seen how we can make slices from sequences using the seq[a:b] code starting from position a to position b . We can also provide a third argument that determines the step by which the slicing is done. The default step is 1 because of which it returns a continuous part of the text. Giving a negative step, i.e., -1 will return the text in reverse.

### Files
```python
poem = '''\
Programming is fun
When the work is done
if you wanna make your work also fun:
use Python!
'''
# Open for 'w'riting
f = open('poem.txt', 'w')
# Write text to file
f.write(poem)
# Close the file
f.close()
# If no mode is specified,
# 'r'ead mode is assumed by default
f = open('poem.txt')
while True:
        line = f.readline()
        # Zero length indicates EOF
        if len(line) == 0:
            break
        # The `line` already has a newline
        # at the end of each line
        # since it is reading from a file.
        print(line, end='')
# close the file
f.close()
```

The mode can be a read mode ( 'r' ), write mode ( 'w' ) or append mode ( 'a' ). We can also specify whether we are reading, writing, or appending in text mode ( 't' ) or binary mode ( 'b' ). There are actually many more modes available and help(open) will give you more details about them. By default, open() considers the file to be a 't'ext file and opens it in 'r'ead mode.

We read in each line of the file using the readline method in a loop. This method returns a complete line including the newline character at the end of the line. When an empty string is returned, it means that we have reached the end of the file and we 'break' out of the loop.

### Pickle
Python provides a standard module called pickle which you can use to store any plain Python object in a file and then get it back later. This is called storing the object persistently.

```python
import pickle
# The name of the file where we will store the object
shoplistfile = 'shoplist.data'
# The list of things to buy
shoplist = ['apple', 'mango', 'carrot']
# Write to the file
f = open(shoplistfile, 'wb')
# Dump the object to a file
pickle.dump(shoplist, f)
f.close()
# Destroy the shoplist variable
del shoplist
# Read back from the storage
f = open(shoplistfile, 'rb')
# Load the object from the file
storedlist = pickle.load(f)
print(storedlist)
```

### Unicode
Python 3 by default stores string variables in Unicode.  
If you are using Python 2, and we want to be able to read and write other non-English languages, we need to use the `unicode` type, and it all starts with the character u , e.g. u"hello world"

```python
# encoding=utf-8
import io
f = io.open("abc.txt", "wt", encoding="utf-8")
f.write(u"Imagine non-English language here")
f.close()
text = io.open("abc.txt", encoding="utf-8").read()
print(text)
```

Note that we should only use encoding in the open statement when in text mode.  

Whenever we write a program that uses Unicode literals (by putting a u before the string) like we have used above, we have to make sure that Python itself is told that our program uses UTF-8, and we have to put `# encoding=utf-8` comment at the top of our program.

## Exceptions
* Errors  
```shell
>>> Print("Hello World")
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
NameError: name 'Print' is not defined
```
Observe that a `NameError` is raised and also the location where the error was detected is printed. This is what an **error handler** for this error does.
* Exceptions  


We can handle exceptions using the `try..except` statement. We basically put our usual statements within the try-block and put all our error handlers in the except-block.  
```python
class ShortInputException(Exception):
    '''A user-defined exception class.'''
    def __init__(self, length, atleast):
        Exception.__init__(self)
        self.length = length
        self.atleast = atleast

try:
    text = input('Enter something --> ')
    if len(text) < 3:
        raise ShortInputException(len(text), 3)
except EOFError:                     # Press ctrl + d
    print('Why did you do an EOF on me?')
except KeyboardInterrupt:       # Press ctrl + c
    print('You cancelled the operation.')
except ShortInputException as ex:
    print(('ShortInputException: The input was ' +
                    '{0} long, expected at least {1}')
                    .format(ex.length, ex.atleast))
else:                                           # if no exception, this is executed
    print('You entered {}'.format(text))
finally:
    print('do some clearup in finally')
```
The except clause can handle a single specified error or exception, or a parenthesized list of errors/exceptions. If no names of errors or exceptions are supplied, it will handle all errors and exceptions.  

You can also have an else clause associated with a try..except block. The else clause is executed if no exception occurs.

You can raise exceptions using the raise statement by providing the name of the error/exception and the exception object that is to be thrown.

```python
f = None
try:
    f = open("poem1.txt")
except FileNotFoundError:
    print("file doesn't exists")
finally:
    if f:
        f.close()
    print("(Cleaning up: Closed the file)")
```

Notice that a variable assigned a value of 0 or None or a variable which is an empty sequence or collection is considered False by Python. This is why we can use `if: f` in the code above.  
Also note that we use `sys.stdout.flush()` after print so that it prints to the screen immediately.

### The with statement
Acquiring a resource in the try block and subsequently releasing the resource in the finally block is a common pattern. Hence, there is also a `with` statement that enables this to be done in a clean manner:
```python
with open("poem.txt") as f:
    for line in f:
        print(line, end='')
```

**What happened if file doesn't exist?** exception is thrown.    
```python
with open("poem1.txt") as f:
    for line in f:
        print(line, end='')
```
```html
Traceback (most recent call last):
  File "doodles.py", line 476, in <module>
    with open("poem1.txt") as f:
FileNotFoundError: [Errno 2] No such file or directory: 'poem1.txt'
```
What happens behind the scenes is that there is a protocol used by the with statement. It fetches the object returned by the open statement, let's call it "thefile" in this case.

It always calls the thefile.__enter__ function before starting the block of code under it and always calls thefile.__exit__ after finishing the block of code. So the code that we would have written in a finally block should be taken care of automatically by the __exit__ method.

## Standard Library
You can find complete details for all of the modules in the Python Standard Library in the [Library Reference] section of the documentation that comes with your Python installation.  

### sys module
sys.argv list contains the command-line arguments.
```python
import sys
# the command-line arguments.
sys.argv 

>>> sys.version_info
sys.version_info(major=3, minor=6, micro=0, releaselevel='final', serial=0)
```

### logging module
```python
import os
import platform
import logging
if platform.platform().startswith('Windows'):
    logging_file = os.path.join(os.getenv('HOMEDRIVE'),
                                                os.getenv('HOMEPATH'),
                                                'test.log')
else:
    logging_file = os.path.join(os.getenv('HOME'),
                                            'test.log')
print("Logging to", logging_file)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s : %(levelname)s : %(message)s',
    filename=logging_file,
    filemode='w',
)

logging.debug("Start of the program")
logging.info("Doing something")
logging.warning("Dying now")
```

## More
### Passing tuples around
```python
def get_error_details():
    return (2, 'details')

errnum, errstr = get_error_details()
```

This also means the fastest way to swap two variables in Python is:
```python
>>> a = 5; b = 8
>>> a, b
(5, 8)
>>> a, b = b, a
>>> a, b
(8, 5)
```

### Special Methods
There are certain methods such as the `__init__` and `__del__` methods which have special significance in classes.

Special methods are used to mimic certain behaviors of built-in types. For example, if you want to use the `x[key] indexing operation` for your class (just like you use it for lists and tuples), then all you have to do is implement the `__getitem__()` method and your job is done.

Some useful special methods are listed in the following table. If you want to know about all the special methods, see the [Special method names].

* __init__(self, ...)  
This method is called just before the newly created object is returned for usage.
* __del__(self)  
Called just before the object is destroyed (`which has unpredictable timing, so avoid using this`)
* __str__(self)  
Called when we use the print function or when str() is used.
* __lt__(self, other)  
Called when the less than operator (<) is used. Similarly, there are special methods for all the operators (+, >, etc.)
* __getitem__(self, key)  
Called when x[key] indexing operation is used.
* __len__(self)  
Called when the built-in len() function is used for the sequence object.  

### Single Statement Blocks
We have seen that each block of statements is set apart from the rest by its own indentation level. Well, there is one caveat. If your block of statements contains only one single statement, then you can specify it on the same line of, say, a conditional statement or looping statement. The following example should make this clear.

```python
flag = True
if flag: print('Yes')
```

### Lambda Forms
`A lambda statement is used to create new function objects`. Essentially, the lambda takes a parameter followed by a single expression. Lambda becomes the body of the function. The value of this expression is returned by the new function.
```python
points = [{'x': 2, 'y': 3},
                    {'x': 4, 'y': 1}]
points.sort(key=lambda i: i['y'])
print(points)                   # [{'x': 4, 'y': 1}, {'x': 2, 'y': 3}]
```
Notice that the sort method of a list can take a key parameter which determines how the list is sorted (usually we know only about ascending or descending order). In our case, we want to do a custom sort, and for that we need to write a function. Instead of writing a separate def block for a function that will get used in only this one place, we use a lambda expression to create a new function.

### List Comprehension
List comprehensions are used to derive a new list from an existing list.  
```python
listone = [2, 3, 4]
listtwo = [2*i for i in listone if i > 2]
print(listtwo)
```

### Receiving Tuples and Dictionaries in Functions
There is a special way of receiving parameters to a function as a tuple or a dictionary using the * or ** prefix respectively. This is useful when taking variable number of arguments in the function.

```python
>>> def powersum(power, *args):
...     '''Return the sum of each argument raised to the specified power.'''
...     total = 0
...     for i in args:
...         total += pow(i, power)
...     return total
...
>>> powersum(2, 3, 4)
25
>>> powersum(2, 10)
100
```
Because we have a * prefix on the args variable, all extra arguments passed to the function are stored in args as a tuple. If a ** prefix had been used instead, the extra parameters would be considered to be key/value pairs of a dictionary.

### The assert statement
When the assert statement fails, an AssertionError is raised.
```python
>>> mylist = ['item']
>>> assert len(mylist) >= 1
>>> mylist.pop()
'item'
>>> assert len(mylist) >= 1
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
AssertionError
```

### Decorators
Decorators are a shortcut to applying wrapper functions. This is helpful to "wrap" functionality with the same code over and over again.  

For example, I created a retry decorator for myself that I can just apply to any function and if any exception is thrown during a run, it is retried again, till a maximum of 5 times and with a delay between each retry. This is especially useful for situations where you are trying to make a network call to a remote computer:

```python
from time import sleep
from functools import wraps
import logging
logging.basicConfig()
log = logging.getLogger("retry")
def retry(f):
    @wraps(f)
    def wrapper_function(*args, **kwargs):
        MAX_ATTEMPTS = 5
        for attempt in range(1, MAX_ATTEMPTS + 1):
            try:
                return f(*args, **kwargs)
            except:
                log.exception("Attempt %s/%s failed : %s",
                                            attempt,
                                            MAX_ATTEMPTS,
                                            (args, kwargs))
            sleep(1 * attempt)
        log.critical("All %s attempts failed : %s",
                                MAX_ATTEMPTS,
                                (args, kwargs))
    return wrapper_function
counter = 0

@retry
def save_to_database(arg):
    print("Write to a database or make a network call or etc.")
    print("This will be automatically retried if exception is thrown.")
    global counter
    counter += 1
    # This will throw an exception in the first call
    # And will work fine in the second call (i.e. a retry)
    if counter < 2:
        raise ValueError(arg)
    print("save is done")
if __name__ == '__main__':
    save_to_database("Some bad value")
```
* [https://www.ibm.com/developerworks/linux/library/l-cpdecor.html]
* [DRY Principles through Python Decorators]

### Differences between Python 2 and Python 3
* [Six: Python 2 and 3 Compatibility Library]
* [Porting to Python 3 Redux]
* [My experiences with Django and Python 3]
* [Official Django Guide to Porting to Python 3]
* [Discussion on What are the advantages to python 3.x?]

### What Next
![python_big_picture_img_1]  

* [The Elements of Python Style]
* [Python Big Picture]
* [Norvig's list of Infrequently Asked Questions]
* [Python Interview Q & A]
* [Hidden features of Python]
* [Full Stack Web Development with Flask]
* [pyvideo]

If you are stuck with a Python problem, and don't know whom to ask, then the [python-tutorlist] is the best place to ask your question.

We have been using the **CPython** software to run our programs. It is referred to as CPython because it is written in the C language and is the Classical Python interpreter. There are also other software that can run your Python programs:
* Jython
* IronPython
* PyPy
* etc

**Functional Programming**  
* [Functional Programming Howto by A.M. Kuchling]
* [Funcy library]
* [PyToolz library]
* [Functional programming chapter in 'Dive Into Python' book]

## Miscellaneous
### References
* `《Python Cookbook》`   3rd
同样很有名。本书介绍了Python应用在各个领域中的一些使用技巧和方法，从最基本的字符、文件序列、字典和排序，到进阶的面向对象编程、数据库和数据持久化、 XML处理和Web编程，再到比较高级和抽象的描述符、装饰器、元类、迭代器和生成器，均有涉及。书中还介绍了一些第三方包和库的使用，包括 Twisted、GIL、PyWin32等。本书覆盖了Python应用中的很多常见问题，并提出了通用的解决方案。书中的代码和方法具有很强的实用性，可以方便地应用到实际的项目中，并产生立竿见影的效果。
《Python CookBook》，有第二版和第三版，可以两本都买，重复度并不高；
页数: 684
In fact, if you want to really challenge yourself in Python, you should read through all of [Raymond Hettinger’s recipes]. Many of the standard library’s most popular modules started as recipes on this site, such as namedtuple and Counter!  
Anyway, the reason I am mentioning the Python recipes website is because in 2002, O’Reilly published many of `the most popular ActiveState recipes` into the book, Python Cookbook, which was edited by Alex Martelli, one of the circa-2002 Python community luminaries.  
What’s more, Beazley decided to focus his cookbook examples exclusively on Python 3 (specifically, Python 3.3, the latest version as of the time of publication). This means it’s the perfect third book to read, after Python Essential Reference and Fluent Python. Not only will it cover more advanced recipes, but it’ll cover them while also highlighting features from the newest version of the language, Python 3.   
One tip: despite its age,` I think the 2nd edition of Python Cookbook included some pretty sage explanations of Python internals by Alex Martelli`, and these were pretty much entirely edited out of the new version of the book. Therefore, if you want bonus points, also pick up a used copy of the 2nd edition of this title for historical value!  

* `《流畅的Python》` 1st
本年度最好的一本Python进阶书籍，从点到面、从最佳编程实践深入到底层实现原理。每个章节配有大量参考链接，引导读者进一步思考。
Fluent Python
For py3, very good, 进阶书, 作者20年python经验, 了解python陷阱及解决
页数: 628
Once you understand the basics of a programming language, your next level of mastery is to understand its idioms and best practices. This is where the next book, Fluent Python, comes in.
This book will try to actually get you to “see the light” and write Python in an idiomatic and tasteful way, even while teaching you the basics, and the advanced internals, of the language.  
I was particularly impressed with this book’s discussion of Python’s data structures, which is supplemented with an overview of their internal implementation. The second half of the book goes into more depth on several topics than any other book on the market: things like iterators, generators, decorators, coroutines, descriptors, and class metaprogramming. I also found some of the historical discussion included in sidebars to be illuminating. This is a book I even recommend to Python old-timers.

* `《Python基础教程(第2版 修订版)》`  
`Beginning Python From Novice to Professional (Second Edition)`  图灵书
包括Python程序设计的方方面面，内容涉及的范围较广, 改版到python 3.0
语言扩展推荐《Python基础教程 第二版》（修订版），第二版有两个版本，前一般被翻译毁了，修订版还不错
页数: 470


* `《A Byte Of Python》`  
中文《简明Python教程》  
本书采用知识共享协议免费分发，意味着任何人都可以免费获取，这本书走过了11个年头，最新版以Python3为基础同时也会兼顾到Python2的一些东西，内容非常精简。
适合有经验的程序员快速上手Python
出版社: Lulu Marketplace
副标题: 简明 Python 教程
原作名: A Byte of Python
110页

* `《Python标准库》`   
The Python 3 Standard Library by Example 2nd  
The Python Standard Library by Example  
对于程序员而言，标准库与语言本身同样重要，它好比一个百宝箱，能为各种常见的任务提供完美的解决方案，所以本书是所有Python程序员都必备的工具书！本书以案例驱动的方式讲解了标准库中一百多个模块的使用方法（如何工作）和工作原理（为什么要这样工作），比标准库的官方文档更容易理解（一个简单的示例比一份手册文档更有帮助），为Python程序员熟练掌握和使用这些模块提供了绝佳指导。

* Python源码剖析  
本书以CPython为研究对象，在C代码一级，深入细致地剖析了Python的实现。书中不仅包括了对大量Python内置对象的剖析，更将大量的篇幅用于对Python虚拟机及Python高级特性的剖析。通过此书，读者能够透彻地理解Python中的一般表达式、控制结构、异常机制、类机制、多线程机制、模块的动态加载机制、内存管理机制等核心技术的运行原理。


* 《集体智慧编程》  
一本注重实践，以机器学习与计算统计为主题背景，讲述如何挖掘和分析Web上的数据和资源的书，本书代码示例以Python为主。入门人工智能的都应该看看这本书。


* 《Python科学计算》  
高阶书，但是内容充实。本书介绍如何用Python开发科学计算的应用程序，除了介绍数值计算之外，还着重介绍如何制作交互式的2D、3D图像，如何设计精巧的程序界面，如何与C语言编写的高速计算程序结合，如何编写声音、图像处理算法等内容。书中涉及的Python扩展库包括NumPy、SciPy、SymPy、matplotlib、Traits、TraitsUI、Chaco、TVTK、Mayavi、VPython、OpenCV等，涉及的应用领域包括数值运算、符号运算、二维图表、三维数据可视化、三维动画演示、图像处理以及界面设计等。 《Python标准库》对于程序员而言，标准库与语言本身同样重要，它好比一个百宝箱，能为各种常见的任务提供完美的解决方案，所以本书是所有Python程序员都必备的工具书！本书以案例驱动的方式讲解了标准库中一百多个模块的使用方法（如何工作）和工作原理（为什么要这样工作），比标准库的官方文档更容易理解（一个简单的示例比一份手册文档更有帮助），为Python程序员熟练掌握和使用这些模块提供了绝佳指导。

* 《Python核心编程（第二版）》  
内容比较简单，这版是2.x的入门资料。·学习专业的Python风格、最佳实践和好的编程习惯；·加强对Python对象、内存模型和Python面向对象特性的深入理解；·构建更有效的Web、CGI、互联网、网络和其他客户端/服务器架构应用程序及软件；·学习如何使用Python中的Tkinter和其他工具来开发自己的GUI应用程序及软件；·通过用C等语言编写扩展来提升Python应用程序的性能，或者通过使用多线程增强I/0相关的应用程序的能力；·学习Python中有关数据库的API，以及如何在Python中使用各种不同的数据库系统，包括MySQL、Postgres和 SQLite。
页数: 822

* `《dive into python》 ` 
最后看一下《dive into python》写一些实例
页数: 500

* Learning Python, 5th Edition Powerful Object-Oriented Programming  
Pages: 1648

* Python Essential Reference, 4th Edition  
The best all-around book for Python is Python Essential Reference, 4th Edition, by David Beazley.
页数: 648
Beazley’s book is all about Python per se, not programming. The title says “reference,” and it does make a good reference, but you could sit down and read through the first half of the book. The second half of the book really is more of a reference.  

PS: just so so  

* High Performance Python  
作者: Micha Gorelick / Ian Ozsvald  
出版社: O'Reilly Media  
副标题: Practical Performant Programming for Humans  
出版年: 2014-9-10  
页数: 380  
If you're an experienced Python programmer, High Performance Python will guide you through the various routes of code optimization. You'll learn how to use smarter algorithms and leverage peripheral technologies, such as numpy, cython, cpython, and various multi-threaded and multi-node strategies. There's a lack of good learning and reference material available if you want to learn Python for highly computational tasks. Because of it, fields from physics to biology and systems infrastructure to data science are hitting barriers. They need the fast prototyping nature of Python, but too few people know how to wield it. This book will put you ahead of the curve.  

---
[Learning Python]:http://shop.oreilly.com/product/0636920028154.do "Learning Python, 5th Edition Powerful Object-Oriented Programming"
[Head First Python]:http://shop.oreilly.com/product/0636920003434.do "Head First Python A Brain-Friendly Guide"
[Dive into Python]:http://www.diveintopython.net/ "Dive Into Python"
[kivy]:https://kivy.org/#home "Kivy - Open source Python library for rapid development of applications that make use of innovative user interfaces, such as multi-touch apps."
[Python Package Index]:https://pypi.python.org/pypi "PyPI - the Python Package Index"
[PyCharm Educational Edition]:https://www.jetbrains.com/pycharm-edu/ "PyCharm Educational Edition"
[HomeBrew]:https://brew.sh/ "HomeBrew: The missing package manager for macOS"
[Vim]:http://www.vim.org/download.php "Vim website"
[jedi-vim]:https://github.com/davidhalter/jedi-vim "jedi-vim: awesome Python autocompletion with VIM"
[Emacs 24+]:http://www.gnu.org/software/emacs/ "GNU Emacs An extensible, customizable, free/libre text editor — and more."
[ELPY]:https://github.com/jorgenschaefer/elpy/wiki "Elpy, the Emacs Lisp Python Environment"
[Library Reference]:https://docs.python.org/3/library/ "Library Reference"
[Special method names]:https://docs.python.org/3/reference/datamodel.html#special-method-names "Special method names"
[https://www.ibm.com/developerworks/linux/library/l-cpdecor.html]:http://www.ibm.com/developerworks/linux/library/l-cpdecor.html "https://www.ibm.com/developerworks/linux/library/l-cpdecor.html"
[DRY Principles through Python Decorators]:http://toumorokoshi.github.io/dry-principles-through-python-decorators.html "DRY Principles through Python Decorators"
[Six: Python 2 and 3 Compatibility Library]:http://pythonhosted.org/six/ "Six: Python 2 and 3 Compatibility Library"
[Porting to Python 3 Redux]:http://lucumr.pocoo.org/2013/5/21/porting-to-python-3-redux/ "Porting to Python 3 Redux"
[My experiences with Django and Python 3]:https://www.pydanny.com/experiences-with-django-python3.html "My experiences with Django and Python 3"
[Official Django Guide to Porting to Python 3]:https://docs.djangoproject.com/en/dev/topics/python3/ "Official Django Guide to Porting to Python 3"
[Discussion on What are the advantages to python 3.x?]:https://www.reddit.com/r/Python/comments/22ovb3/what_are_the_advantages_to_python_3x/ "Discussion on What are the advantages to python 3.x?"
[Functional Programming Howto by A.M. Kuchling]:https://docs.python.org/3/howto/functional.html "Functional Programming Howto by A.M. Kuchling"
[Funcy library]:https://github.com/Suor/funcy "Funcy library"
[PyToolz library]:http://toolz.readthedocs.io/en/latest/ "PyToolz library"
[Functional programming chapter in 'Dive Into Python' book]:http://www.diveintopython.net/functional_programming/index.html "Functional programming chapter in 'Dive Into Python' book"
[The Elements of Python Style]:https://github.com/amontalenti/elements-of-python-style "The Elements of Python Style"
[python_big_picture_img_1]:/resources/img/java/python_big_picture_1 "python_big_picture_1"
[Python Big Picture]:http://slott-softwarearchitect.blogspot.ca/2013/06/python-big-picture-whats-roadmap.html "Python Big Picture"
[Norvig's list of Infrequently Asked Questions]:http://norvig.com/python-iaq.html "Norvig's list of Infrequently Asked Questions"
[Python Interview Q & A]:http://dev.fyicenter.com/Interview-Questions/Python/index.html "Python Interview Q & A"
[Hidden features of Python]:https://stackoverflow.com/questions/101268/hidden-features-of-python#168270 "Hidden features of Python"
[Full Stack Web Development with Flask]:https://github.com/realpython/discover-flask "Full Stack Web Development with Flask"
[pyvideo]:http://pyvideo.org/ "pyvideo"
[python-tutorlist]:https://mail.python.org/mailman/listinfo/tutor "python-tutorlist"