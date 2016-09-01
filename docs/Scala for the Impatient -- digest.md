As you can see, the Scala interpreter reads an expression, evaluates it, prints it, and reads the next expression. This is called
the read-eval-print loop, or REPL.
Technically speaking, the scala program is not an interpreter. Behind the scenes, your input is quickly compiled into bytecode,
and the bytecode is executed by the Java virtual machine. For that reason, most Scala programmers prefer to call it “the
REPL”.

Note that you need not specify the type of a value or variable. It is inferred from the type of the expression with which you
initialize it. (It is an error to declare a value or variable without initializing it.)
However, you can specify the type if necessary.

In Scala, you use methods, not casts, to convert between numeric types. For example, 99.44.toInt is 99, and 99.toChar is
'c'.

The + - * / % operators do their usual job, as do the bit operators & | ^ >> <<. There is just one surprising aspect: These
operators are actually methods. For example,
a + b
is a shorthand for
a.+(b)
Here, + is the name of the method. Scala has no silly prejudice against non-alphanumeric characters in method names. You can
define methods with just about any symbols for names.

In general, you can write
a method b
as a shorthand for
a.method (b)
where method is a method with two parameters (one implicit, one explicit).

Scala allows you to define operators

To use a package that starts with scala., you can omit the scala prefix. For example, import math._ is equivalent to import
scala.math._, and math.sqrt(2) is the same as scala.math.sqrt(2).

Scala doesn’t have static methods, but it has a similar feature, called singleton objects, which we will discuss in detail in
Chapter 6. Often, a class has a companion object whose methods act just like static methods do in Java. For example, the
BigInt companion object to the BigInt class has a method probablePrime that generates a random prime number with a given
number of bits:
BigInt.probablePrime(100, scala.util.Random)
Note that the call BigInt.probablePrime is similar to a static method call in Java

Here, Random is a singleton random number generator object, defined in the scala.util package. This is one of the few
situations where a singleton object is better than a class. In Java, it is a common error to construct a new java.util.Random
object for each random number.

Scala methods without parameters often don’t use parentheses. For example, the API of the StringOps class shows a method
distinct, without (), to get the distinct letters in a string. You call it as "Hello".distinct
The rule of thumb is that a parameterless method that doesn’t modify the object has no parentheses.

The apply Method
In Scala, it is common to use a syntax that looks like a function call. For example, if s is a string, then s(i) is the ith character of the string. (In C++, you would write s[i]; in Java, s.charAt(i).) Try it out in the REPL:
"Hello"(4) // Yields 'o'
You can think of this as an overloaded form of the () operator. It is implemented as a method with the name apply. For example,
in the documentation of the StringOps class, you will find a method
def apply(n: Int): Char
That is, "Hello"(4) is a shortcut for "Hello".apply(4)
When you look at the documentation for the BigInt companion object, you will see apply methods that let you convert strings or
numbers to BigInt objects. For example, the call
BigInt("1234567890") is a shortcut for BigInt.apply("1234567890")
It yields a new BigInt object, without having to use new

Using the apply method of a companion object is a common Scala idiom for constructing objects. For example, Array(1, 4, 9, 16)
returns an array, thanks to the apply method of the Array companion object.

A method tagged as implicit is an automatic conversion. For example, the BigInt object has conversions from int and long to BigInt that are automatically called when needed. 

Methods can have functions as parameters. For example, the count method in StringOps requires a function that returns true or false for a Char, specifying which characters should be counted:
def count(p: (Char) => Boolean) : Int

You supply a function, often in a very compact notation, when you call the method. As an example, the call s.count(_.isUpper) counts the number of uppercase characters. 

You will encounter a fundamental difference between Scala and other programming languages. In Java or C++, we differentiate between expressions (such as 3 + 4) and statements (for example, an if statement). An expression has a value; a statement carries out an action. In Scala, almost all constructs have values.
Here are the highlights of this chapter:
• An if expression has a value.
• A block has a value—the value of its last expression.
• The Scala for loop is like an “enhanced” Java for loop.
• Semicolons are (mostly) optional.
• The void type is Unit.
• Avoid using return in a function.
• Beware of missing = in a function definition.
• Exceptions work just like in Java or C++, but you use a “pattern matching” syntax for catch.
• Scala has no checked exceptions.

If the else part is omitted, for example in
if(x>0)1
then it is possible that the if statement yields no value. However, in Scala, every expression is supposed to have some value. This is finessed by introducing a class Unit that has one value, written as (). The if statement without an else is equivalent to
if(x>0)1else()
Think of () as a placeholder for “no useful value,” and think of Unit as the analog of void in Java or C++.

In Scala, a { } block contains a sequence of expressions, and the result is also an expression. The value of the block is the value of the last expression.
This feature can be useful if the initialization of a val takes more than one step. For example, Click here to view code image
valdistance={valdx=x-x0;valdy=y-y0; sqrt(dx * dx + dy * dy) }


In Scala, assignments have no value—or, strictly speaking, they have a value of type Unit.

A block that ends with an assignment statement, such as {r=r*n;n-=1}has a Unit value.

for(i <- 1 to n) 
    r=r*i
The call 1 to n returns a Range of the numbers from 1 to n (inclusive). 
The construct for (i <- expr)
makes the variable i traverse all values of the expression to the right of the <-. Exactly how that traversal works depends on the type of the expression. For a Scala collection, such as a Range, the loop makes i assume each value in turn.
There is no val or var before the variable in the for loop. The type of the variable is the element type of the collection. The scope of the loop variable extends until the end of the loop.


When traversing a string or array, you often need a range from 0 to n – 1. In that case, use the until method instead of the to method. It returns a range that doesn’t include the upper bound.
val s = "Hello"
var sum = 0
for (i <- 0 until s.length) // Last value for i is s.length - 1
  sum += s(i)
  
In this example, there is actually no need to use indexes. You can directly loop over the characters:
var sum = 0
for (ch <- "Hello") 
    sum += ch
println(sum)

In Scala, loops are not used as often as in other languages. As you will see in Chapter 12, you can often process the values in a sequence by applying a function to all of them, which can be done with a single method call.

Scala has no break or continue statements to break out of a loop. What to do if you need a break? Here are a few options: 
    1. Use a Boolean control variable instead.
    2. Use nested functions—you can return from the middle of a function.
    3. Use the break method in the Breaks object:

import scala.util.control.Breaks._
breakable {
  for (...) {
    if (...) break; // Exits the breakable block ...
   } 
}
Here, the control transfer is done by throwing and catching an exception, so you should avoid this mechanism when time is of the essence.

for comprehension
When the body of the for loop starts with yield, then the loop constructs a collection of values, one for each iteration: 
for(i<-1 to 10) yield i%3
    // Yields Vector(1, 2, 0, 1, 2, 0, 1, 2, 0, 1)
This type of loop is called a for comprehension.
The generated collection is compatible with the first generator.
for (c <- "Hello"; i <- 0 to 1) yield (c + i).toChar 
    // Yields "HIeflmlmop"
for (i <- 0 to 1; c <- "Hello") yield (c + i).toChar
    // Yields Vector('H', 'e', 'l', 'l', 'o', 'I', 'f', 'm', 'm', 'p')

Scala has functions in addition to methods. A method operates on an object, but a function doesn’t. C++ has functions as well, but in Java, you have to imitate them with static methods.

While there is nothing wrong with using return in a named function (except the waste of seven keystrokes), it is a good idea to get used to life without return. Pretty soon, you will be using lots of anonymous functions, and there, return doesn’t return a value to the caller. It breaks out to the enclosing named function. Think of return as a kind of break statement for functions, and only use it when you want that breakout functionality.


def recursiveSum(args: Int*): Int = {
  if (args.length == 0) 0
  else args.head + recursiveSum(args.tail: _*)
}

Here, the head of a sequence is its initial element, and tail is a sequence of all other elements. That’s again a Seq, and we have to use : _* to convert it to an argument sequence.
	
When you call a Java method with variable (number of )arguments of type Object, such as PrintStream.printf or MessageFormat.format, you need to convert any primitive types by hand. For example,
val str = MessageFormat.format("The answer to {0} is {1}", "everything", 42.asInstanceOf[AnyRef])
This is the case for any Object parameter, but I mention it here because it is most common with varargs methods.

Scala has a special notation for a function that returns no value. If the function body is enclosed in braces without a preceding =
symbol, then the return type is Unit. Such a function is called a procedure. A procedure returns no value, and you only call it for
its side effect.

Some people (not me) dislike this concise syntax for procedures and suggest that you always use an explicit return type of Unit:
def box(s : String): Unit = {
	...
}

The concise procedure syntax can be a surprise for Java and C++ programmers. It is a common error to accidentally
omit the = in a function definition. You then get an error message at the point where the function is called, and you are
told that Unit is not acceptable at that location.

When a val is declared as lazy, its initialization is deferred until it is accessed for the first time. For example,
lazy val words = scala.io.Source.fromFile("/usr/share/dict/words").mkString

Laziness is not cost-free. Every time a lazy value is accessed, a method is called that checks, in a threadsafe manner,
whether the value has already been initialized.

Scala exceptions work the same way as in Java or C++.
However, unlike Java, Scala has no “checked” exceptions—you never have to declare that a function or method might throw an exception.

Scala exceptions work the same way as in Java or C++. However, unlike Java, Scala has no “checked” exceptions—you never have to declare that a function or method might throw an exception.

A throw expression has the special type Nothing. That is useful in if/else expressions. If one branch has type Nothing, the type of the if/else expression is the type of the other branch. For example, consider
if (x >= 0) { sqrt(x)
} else throw new IllegalArgumentException("x should not be negative")
The first branch has type Double, the second has type Nothing. Therefore, the if/else expression also has type Double.

The first branch has type Double, the second has type Nothing. Therefore, the if/else expression also has type Double.
The syntax for catching exceptions is modeled after the pattern matching syntax (see Chapter 14).
    val url = new URL("http://horstmann.com/fred-tiny.gif")
    try {
      process(url)
    } catch {
      case _: MalformedURLException => println("Bad URL: " + url)
      case ex: IOException => ex.printStackTrace()
    }

As in Java or C++, the more general exception types should come after the more specific ones.
Note that you can use _ for the variable name if you don’t need it.
The try/finally statement lets you dispose of a resource whether or not an exception has occurred. For example:
    var in = new URL("http://horstmann.com/fred.gif").openStream()
    try {
      process(in)
    } finally {
      in.close()
    }
The finally clause is executed whether or not the process function throws an exception. The reader is always closed.
It is possible to combine them into a single try/catch/finally statement:
try { ... } catch { ... } finally { ... }

• Use an Array if the length is fixed, and an ArrayBuffer if the length can vary.
• Don’t use new when supplying initial values.
• Use () to access elements.
• Use for (elem <- arr) to traverse the elements.
• Use for (elem <- arr if . . . ) . . . yield . . . to transform into a new array.
• Scala and Java arrays are interoperable; with ArrayBuffer, use scala.collection.JavaConversions.

// A string array with ten elements, all initialized with null
val a = new Array[String](10)
val s = Array("Hello", "World")
s(0) = "Goodbye"
// Array("Goodbye", "World")
Inside the JVM, a Scala Array is implemented as a Java array.

import scala.collection.mutable.ArrayBuffer
val b = ArrayBuffer[Int]()
// Or new ArrayBuffer[Int]
// An empty array buffer, ready to hold integers
b += 1
// ArrayBuffer(1)
// Add an element at the end with +=
