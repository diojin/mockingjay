

##目录

*   [StartMe](#StartMe)

*   [Somewhere](#Somewhere)





---

----

-----

para1
---
para1.1
-----

para2
********

para3
________

*** adasdf

___adasdadfs


StartMe
-----------



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


















ada



























Somewhere
-----------










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
