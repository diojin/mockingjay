
#                 Scala for the Impatient 
###                   Cay S. Horstmann

######                    Second printing, June 2013

___

##Contents
---
* [1. The Basics](#basics)
    * [The apply Method](#the-apply-method)
* [2. Control Structures and Functions](#control-structures-and-functions)
    * [for comprehension](#for-comprehension)
    * [function](#function)
    * [argument sequence](#argument-sequence)
    * [procedure](#procedure)
* [3. Working with Arrays](#working-with-arrays)
    * [for if yield or filter map](#for-if-yield-or-filter-map)
    * [array sorting](#array-sorting)
    * [multidimensional arrays](#multidimensional-arrays)
    * [Interoperating with Java](#interoperating-with-java)
* [4. Maps and Tuples](#maps-and-tuples)

Basics
---
As you can see, the Scala interpreter reads an expression, evaluates it, prints it, and reads the next expression. This is called
the read-eval-print loop, or **REPL**.
Technically speaking, the scala program is not an interpreter. Behind the scenes, your input is quickly compiled into bytecode,
and the bytecode is executed by the Java virtual machine. For that reason, most Scala programmers prefer to call it “the
REPL”.

Note that you need not specify the type of a value or variable. It is inferred from the type of the expression with which you
initialize it. (It is an error to declare a value or variable without initializing it.)
However, you can specify the type if necessary.

`In Scala, you use methods, not casts, to convert between numeric types. For example, 99.44.toInt is 99, and 99.toChar is 'c'.
(PS: what about asInstanceOf
MessageFormat.format("the answer is {0} to {1}", "everything", 42.asInstanceOf[AnyRef]))
`



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

`Scala allows you to define operators`

To use a package that starts with scala., you can omit the scala prefix. For example, import math._ is equivalent to import
scala.math._, and math.sqrt(2) is the same as scala.math.sqrt(2).

`Scala doesn’t have static methods`, but it has a similar feature, called __singleton objects__, which we will discuss in detail in
Chapter 6. Often, a class has a __companion object__ whose methods act just like static methods do in Java. For example, the
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

####The apply Method
In Scala, it is common to use a syntax that looks like a function call. For example, if s is a string, then s(i) is the ith character of the string. (In C++, you would write s[i]; in Java, s.charAt(i).) Try it out in the REPL:
"Hello"(4) // Yields 'o'
`You can think of this as an overloaded form of the () operator. It is implemented as a method with the name apply.` For example,
in the documentation of the StringOps class, you will find a method
def apply(n: Int): Char
That is, "Hello"(4) is a shortcut for "Hello".apply(4)
When you look at the documentation for the BigInt companion object, you will see apply methods that let you convert strings or
numbers to BigInt objects. For example, the call
BigInt("1234567890") is a shortcut for BigInt.apply("1234567890")
It yields a new BigInt object, without having to use new

`Using the apply method of a companion object is a common Scala idiom for constructing objects.` For example, Array(1, 4, 9, 16)
returns an array, thanks to the apply method of the Array companion object.

`A method tagged as implicit is an automatic conversion.` For example, the BigInt object has conversions from int and long to BigInt that are automatically called when needed. 

`Methods can have functions as parameters.` For example, the count method in StringOps requires a function that returns true or false for a Char, specifying which characters should be counted:
```scala
def count(p: (Char) => Boolean) : Int
```
You supply a function, often in a very compact notation, when you call the method. As an example, the call **s.count(_.isUpper)** counts the number of uppercase characters. 

Control Structures and Functions
---
You will encounter a fundamental difference between Scala and other programming languages. In Java or C++, we differentiate between expressions (such as 3 + 4) and statements (for example, an if statement). `An expression has a value; a statement carries out an action. In Scala, almost all constructs have values.`
Here are the highlights of this chapter:  
`• An if expression has a value.`  
`• A block has a value—the value of its last expression.`  
• The Scala for loop is like an “enhanced” Java for loop.  
• Semicolons are (mostly) optional.  
`• The void type is Unit.`  
• Avoid using return in a function.  
• Beware of missing = in a function definition.  
• Exceptions work just like in Java or C++, but you use a “pattern matching” syntax for catch.  
`• Scala has no checked exceptions.`

If the else part is omitted, for example in
if(x>0) 1
then it is possible that the if statement yields no value. However, in Scala, every expression is supposed to have some value. `This is finessed by introducing a class Unit that has one value, written as ().` The if statement without an else is equivalent to

if (x>0) 1 else ()
`Think of () as a placeholder for “no useful value,” and think of Unit as the analog of void in Java or C++.`

In Scala, a { } block contains a sequence of expressions, and the result is also an expression. The value of the block is the value of the last expression.
This feature can be useful if the initialization of a val takes more than one step. For example,
```scala
val distance = { val dx = x - x0; val dy = y - y0; sqrt(dx * dx + dy * dy) }
```

`In Scala, assignments have no value—or, strictly speaking, they have a value of type Unit.`

A block that ends with an assignment statement, such as {r=r*n; n-=1}has a Unit value.
```scala
for(i <- 1 to n) 
    r=r*i
```
The call 1 to n returns a Range of the numbers from 1 to n (inclusive). 
The construct for **(i <- expr)**
makes the variable i traverse all values of the expression to the right of the <-. Exactly how that traversal works depends on the type of the expression. For a Scala collection, such as a Range, the loop makes i assume each value in turn.
There is no val or var before the variable in the for loop. The type of the variable is the element type of the collection. The scope of the loop variable extends until the end of the loop.

When traversing a string or array, you often need a range from 0 to n – 1. In that case, use the until method instead of the to method. It returns a range that doesn’t include the upper bound.
```scala
val s = "Hello"
var sum = 0
for (i <- 0 until s.length) // Last value for i is s.length - 1
  sum += s(i)
```

In this example, there is actually no need to use indexes. You can directly loop over the characters:
```scala
var sum = 0
for (ch <- "Hello") 
    sum += ch
println(sum)
```

In Scala, loops are not used as often as in other languages. As you will see in Chapter 12, you can often process the values in a sequence by applying a function to all of them, which can be done with a single method call.

`Scala has no break or continue statements to break out of a loop`. What to do if you need a break? Here are a few options: 
    1. Use a Boolean control variable instead.
    2. Use nested functions—you can return from the middle of a function.
    3. Use the break method in the Breaks object:

```scala
import scala.util.control.Breaks._
breakable {
  for (...) {
    if (...) break; // Exits the breakable block ...
   } 
}
```

`Here, the control transfer is done by throwing and catching an exception, so you should avoid this mechanism when time is of the essence.`

###for comprehension
When the body of the for loop starts with yield, then the loop constructs a collection of values, one for each iteration: 
```scala
for(i<-1 to 10) yield i%3
    // Yields Vector(1, 2, 0, 1, 2, 0, 1, 2, 0, 1)
```
This type of loop is called a **for comprehension**.
`The generated collection is compatible with the first generator.`

```scala
for (c <- "Hello"; i <- 0 to 1) yield (c + i).toChar 
    // Yields "HIeflmlmop"

for (i <- 0 to 1; c <- "Hello") yield (c + i).toChar
    // Yields Vector('H', 'e', 'l', 'l', 'o', 'I', 'f', 'm', 'm', 'p')
```

###function
Scala has functions in addition to methods. A method operates on an object, but a function doesn’t. C++ has functions as well, but in Java, you have to imitate them with static methods.

While there is nothing wrong with using return in a named function (except the waste of seven keystrokes), it is a good idea to get used to life without return. Pretty soon, you will be using lots of anonymous functions, and there, return doesn’t return a value to the caller. It breaks out to the enclosing named function. **Think of return as a kind of break statement for functions, and only use it when you want that breakout functionality.**

###argument sequence

```scala
println( recursiveSum(1, 2, 3, 4, 5) )
    
println( recursiveSum(1 to 5:_*))

def recursiveSum(args: Int*) : Int = {
  if ( args.length== 0 ) 
    0
  else
    args.head + recursiveSum(args.tail:_*)
}
```

Here, the head of a sequence is its initial element, and tail is a sequence of all other elements. **That’s again a Seq, and we have to use : _* to convert it to an argument sequence.**

`When you call a Java method with variable (number of )arguments of type Object, such as PrintStream.printf or MessageFormat.format, you need to convert any primitive types by hand.` For example,

```scala
val str = MessageFormat.format("The answer to {0} is {1}", "everything", 42.asInstanceOf[AnyRef])
```
This is the case for any Object parameter, but I mention it here because it is most common with **varargs** methods.

###procedure
Scala has a special notation for a function that returns no value. If the function body is enclosed in braces `without a preceding =
symbol, then the return type is Unit.` Such a function is called a procedure. A procedure returns no value, and you only call it for
its side effect.

Some people (not me) dislike this concise syntax for procedures and suggest that you always use an explicit return type of Unit:
def box(s : String): Unit = {
	...
}

The concise procedure syntax can be a surprise for Java and C++ programmers. It is a common error to accidentally
omit the = in a function definition. You then get an error message at the point where the function is called, and you are
told that Unit is not acceptable at that location.

When a val is declared as lazy, its initialization is deferred until it is accessed for the first time. For example,
```scala
lazy val words = scala.io.Source.fromFile("/usr/share/dict/words").mkString
```

`Laziness is not cost-free. Every time a lazy value is accessed, a method is called that checks, in a threadsafe manner,
whether the value has already been initialized.`

Scala exceptions work the same way as in Java or C++.
However, unlike Java, Scala has `no “checked” exceptions`—you never have to declare that a function or method might throw an exception.

`A throw expression has the special type Nothing. That is useful in if/else expressions. If one branch has type Nothing, the type of the if/else expression is the type of the other branch.` For example, consider
```scala
if (x >= 0) {
      sqrt(x)
} else throw new IllegalArgumentException("x should not be negative")
```
The first branch has type Double, the second has type Nothing. Therefore, the if/else expression also has type Double.

The syntax for catching exceptions is modeled after the pattern matching syntax (see Chapter 14).
```scala
    val url = new URL("http://horstmann.com/fred-tiny.gif")
    try {
      process(url)
    } catch {
      case _: MalformedURLException => println("Bad URL: " + url)
      case ex: IOException => ex.printStackTrace()
    }
```

As in Java or C++, the more general exception types should come after the more specific ones.
Note that you can use _ for the variable name if you don’t need it.
The try/finally statement lets you dispose of a resource whether or not an exception has occurred. For example:
```scala
    var in = new URL("http://horstmann.com/fred.gif").openStream()
    try {
      process(in)
    } finally {
      in.close()
    }
```
The finally clause is executed whether or not the process function throws an exception. The reader is always closed.
It is possible to combine them into a single try/catch/finally statement:
try { ... } catch { ... } finally { ... }

Working with Arrays
---
• Use an **Array** if the length is fixed, and an **ArrayBuffer** if the length can vary.  
• Don’t use new when supplying initial values.  
• Use () to access elements.  
• Use for (elem <- arr) to traverse the elements.  
`• Use for (elem <- arr if . . . ) . . . yield . . . to transform into a new array.`  
• Scala and Java arrays are interoperable; with ArrayBuffer, use **scala.collection.JavaConversions**.

```scala
// A string array with ten elements, all initialized with null
val a = new Array[String](10)
val s = Array("Hello", "World")
s(0) = "Goodbye"
// Array("Goodbye", "World")
```

**Inside the JVM, a Scala Array is implemented as a Java array.**

```scala
import scala.collection.mutable.ArrayBuffer
val b = ArrayBuffer[Int]()
// Or new ArrayBuffer[Int]
// An empty array buffer, ready to hold integers
b += 1
// ArrayBuffer(1)
// Add an element at the end with +=

b += (1, 2, 3, 5)
// ArrayBuffer(1, 1, 2, 3, 5)
// Add multiple elements at the end by enclosing them in parentheses
b ++= Array(8, 13, 21)
// ArrayBuffer(1, 1, 2, 3, 5, 8, 13, 21)

b ++= 22 to 23
// ArrayBuffer(1, 1, 2, 3, 5, 8, 13, 21, 22, 23)
// You can append any collection with the ++= operator

//    b += 4 to 10        // failed due to type mismatch
//    b += Array(11, 12)  // failed due to type mismatch

b.trimEnd(5)
// ArrayBuffer(1, 1, 2)
// Removes the last five elements
```

Sometimes, you want to build up an Array, but you don’t yet know how many elements you will need. In that case, first make an
array buffer, then call
**b.toArray**
// Array(1, 1, 2)
Conversely, call **a.toBuffer** to convert the array a to an array buffer.

It is very easy to take an array (or array buffer) and transform it in some way. Such transformations don’t modify the original array, but they **yield a new one.**

###for if yield or filter map
Oftentimes, when you traverse a collection, you only want to process the elements that match a particular condition. This is
achieved with a guard: an if inside the for. Here we double every even element, dropping the odd ones:
```scala
for (elem <- a if elem % 2 == 0) yield 2 * elem
```
Alternatively, you could write
```scala
a.filter(_ % 2 == 0).map(2 * _)
a filter { _ % 2 == 0 } map { 2 * _ }
b.filter { _ % 2 == 0 }.map { 2 * _ }
```
Some programmers with experience in functional programming prefer filter and map to guards and yield. That’s just a
matter of style—the for loop does exactly the same work. Use whichever you find easier.
Keep in mind that **the result is a new collection**—the original collection is not affected.
```scala
var first = false
// notice: condition here must involve each element, such as a(i) >= 0
// otherwise it will be applied once per entire input collection, but rather
// many times per each element
val indexes = for (i <- 0 until a.length if first || a(i) >= 0) yield {
	if (a(i) < 0) first = false; i
}
```

evidence is as below:
```scala
println("ignore the 1st element")
val input = Array(1, 2, 3, 4, 5, 6)
var first = true
var res = for ( i <- 0 until input.length if !first || i % 2 == 1 ) yield {
  if ( first ) {
    first = false
  }
  input(i)
}
println(res)  // Vector(2, 3, 4, 5, 6)

first = true
res = for ( i <- 0 until input.length if !first ) yield {
  if ( first ) {
    first = false
  }
  input(i)
}
println(res)  // Vector()
```

###array sorting
```scala
var a1 = ArrayBuffer(1, 3,  1, 2, 8, 5)
val aRes = a1.sortBy(x => -x)
val aRes2 = a1.sortWith(_ > _)
println(aRes)        // ArrayBuffer(8, 5, 3, 2, 1, 1)
println(aRes2)       // ArrayBuffer(8, 5, 3, 2, 1, 1)
```

`You can sort an array, but not an array buffer, in place:`

```scala
val a = Array(1, 7, 2, 9)
scala.util.Sorting.quickSort(a)
// a is now Array(1, 2, 7, 9)
```
For the min, max, and quickSort methods, the element type must have a comparison operation. This is the case for numbers
strings, and other types with the Ordered trait.

###multidimensional arrays
Like in Java, multidimensional arrays are implemented as arrays of arrays. For example, a two-dimensional array of Double values has the type Array[Array[Double]]. To construct such an array, use the ofDim method:
```scala
val matrix = Array.ofDim[Int](3,4) // Three rows, four columns

val raggerArray = new Array[Array[Int]](5)
for (i <- 0 until raggerArray.length ){
  raggerArray(i) = new Array[Int](i+2)      
}
```

To access an element, use two pairs of parentheses:
`matrix(row)(column) = 42`

###Interoperating with Java

Since Scala arrays are implemented as Java arrays, you can pass them back and forth between Java and Scala.
If you call a Java method that receives or returns a java.util.List, you could, of course, use a Java ArrayList in your Scala code— but that is unattractive. Instead, import the implicit conversion methods in scala.collection.JavaConversions. Then you can use Scala buffers in your code, and they automatically get wrapped into Java lists when calling a Java method.

```scala
import scala.collection.JavaConversions.bufferAsJavaList 
import scala.collection.mutable.ArrayBuffer
val command = ArrayBuffer("ls", "-al", "/home/cay")
val pb = new ProcessBuilder(command) // Scala to Java
                                     // java.lang.ProcessBuilder, plain java class, one of constructor takes java.util.List as parameter
```

The Scala buffer is wrapped into an object of a Java class that implements the java.util.List interface.
Conversely, when a Java method returns a java.util.List, you can have it automatically converted into a Buffer:
```scala
import scala.collection.JavaConversions.asScalaBuffer 
import scala.collection.mutable.Buffer
val cmd : Buffer[String] = pb.command() // Java to Scala
// You can't use ArrayBuffer—the wrapped object is only guaranteed to be a Buffer
```


```scala
val command = ArrayBuffer("ls", "-al", "/home/cay")
val pb = new ProcessBuilder(command)
val cmd: Buffer[String] = pb.command()
println(cmd)      // ArrayBuffer(ls, -al, /home/cay)
```

Maps and Tuples
---

• Scala has a pleasant syntax for creating, querying, and traversing maps.   
• You need to choose between mutable and immutable maps.  
`• By default, you get a hash map, but you can also get a tree map.`  
`• You can easily convert between Scala and Java maps.`  
• **Tuples** are useful for aggregating values.

You can construct a map as
val scores = Map("Alice" -> 10, "Bob" -> 3, "Cindy" -> 8)
This constructs an immutable Map[String, Int] whose contents can’t be changed. If you want a mutable map, use

val scores = scala.collection.mutable.Map("Alice" -> 10, "Bob" -> 3, "Cindy" -> 8)
If you want to start out with a blank map, you have to supply type parameters:

val scores = new scala.collection.mutable.HashMap[String, Int]
In Scala, a map is a collection of pairs. A pair is simply a grouping of two values, not necessarily of the same type, such as ("Alice", 10).

The -> operator makes a pair. 
The value of "Alice" -> 10 is
res16: (String, Int) = (Alice,10)
PS: it is not a Range

You could have equally well defined the map as
val scores = Map(("Alice", 10), ("Bob", 3), ("Cindy", 8))

In Scala, the analogy between functions and maps is particularly close because you use the () notation to look up key values.
Click here to view code image
val bobsScore = scores("Bob") // Like scores.get("Bob") in Java
If the map doesn’t contain a value for the requested key, an exception is thrown.

Since this call combination is so common, there is a shortcut:
Click here to view code image
val bobsScore = scores.getOrElse("Bob", 0)
// If the map contains the key "Bob", return the value; otherwise, return 0.
Finally, the call map.get(key) returns an Option object that is either Some(value for key) or None. 

You can’t update an immutable map, but you can do something that’s just as useful—obtain a new map that has the desired
update:
val newScores = scores + ("Bob" -> 10, "Fred" -> 7) // New map with update
The newScores map contains the same associations as scores, except that "Bob" has been updated and "Fred" added.
Instead of saving the result as a new value, you can update a var:
var scores = ...
scores = scores + ("Bob" -> 10, "Fred" -> 7)
Similarly, to remove a key from an immutable map, use the - operator to obtain a new map without the key:
scores = scores - "Alice"
You might think that it is inefficient to keep constructing new maps, but that is not the case. The old and new maps share most of their structure. (This is possible because they are immutable.)

When working with a map, you need to choose an implementation—a hash table or a balanced tree. By default, Scala gives
you a hash table. You might want a tree map if you don’t have a good hash function for the keys, or if you need to visit the keys
in sorted order.

Unfortunately, there is (as of Scala 2.9) no mutable tree map. Your best bet is to adapt a Java TreeMap,

If you want to visit the keys in insertion order, use a LinkedHashMap.

Interoperating with Java
If you get a Java map from calling a Java method, you may want to convert it to a Scala map so that you can use the pleasant
Scala map API. This is also useful if you want to work with a mutable tree map, which Scala doesn’t provide.

For example, the code

val symbols = Array("<", "-", ">") val counts = Array(2, 10, 2)
val pairs = symbols.zip(counts)
   yields an array of pairs
   Array(("<", 2), ("-", 10), (">", 2))

The toMap method turns a collection of pairs into a map.
If you have a collection of keys and a parallel collection of values, then zip them up and turn them into a map like this:
keys.zip(values).toMap


• Fields in classes automatically come with getters and setters.
• You can replace a field with a custom getter/setter without changing the client of a class—that is the “uniform access principle.”
• Use the @BeanProperty annotation to generate the JavaBeans getXxx/setXxx methods.
• Every class has a primary constructor that is “interwoven” with the class definition. Its parameters turn into the fields of
the class. The primary constructor executes all statements in the body of the class.
• Auxiliary constructors are optional. They are called this.

It is considered good style to use () for a mutator method (a method that changes the object state),
and to drop the () for an accessor method (a method that does not change the object state).

Scala provides getter and setter methods for every field. Here, we define a public field:
class Person { 
    var age=0
}
Scala generates a class for the JVM with a private age field and getter and setter methods. These methods are public because
we did not declare age as private. (For a private field, the getter and setter methods are private.) 
In Scala, the getter and setter methods are called age and age_=. 
For example,
println(fred.age) // Calls the method fred.age() 
fred.age = 21 // Calls fred.age_=(21)


Bertrand Meyer, the inventor of the influential Eiffel language, formulated the Uniform Access Principle that states: “All services offered by a module should be available through a uniform notation, which does not betray whether they are implemented through storage or through computation.” In Scala, the caller of fred.age doesn’t know whether age is implemented through a field or a method. (Of course, in the JVM, the service is always implemented through a method, either synthesized or programmer-supplied.)


To summarize, you have four choices for implementing properties:
1. var foo: Scala synthesizes a getter and a setter. 2. val foo: Scala synthesizes a getter.
3. You define methods foo and foo_=.
4. You define a method foo.

In Scala, you cannot have a write-only property (that is, a property with a setter and no getter).

Object-Private Fields
Scala allows an even more severe access restriction, with the private[this] qualifier: Click here to view code image
private[this] var value = 0 // Accessing someObject.value is not allowed

With a class-private field, Scala generates private getter and setter methods. However, for an object-private field, no getters and setters are generated at all.


The primary constructor executes all statements in the class definition

class PrimaryConstructorTester(var name: String, var age: Int) {
  println("about to start primary constuctor")
  def description = name + "is\t" + age + " years old"
  private val props = new Properties
  props.load(new FileReader("myproperties.properties"))
  
}

When you think of the primary constructor’s parameters as class parameters, parameters without val or var become easier to understand. The scope of such a parameter is the entire class. Therefore, you can use the parameter in methods. If you do, it is the compiler’s job to save it in a field.


In scala, inner class belongs to instance of outer class, this is different from Java, where an inner class belongs to the outer class.
Tow ways to resolve,
1, move inner class to outer class's companion object
2, to use a type projection OuterClass#InnerClass, which means “a InnerClass of any OuterClass.”

In a nested class, you can access the this reference of the enclosing class as EnclosingClass.this, like in Java. If you like, you can establish an alias for that reference with the following syntax:

class Network(val name: String) { outer => 
    class Member(val name: String) {
        ...
        def description = name + " inside " + outer.name }
}
The class Network { outer => syntax makes the variable outer refer to Network.this. You can choose any name for this variable.
The name self is common, but perhaps confusing when used with nested classes.


In this short chapter, you will learn when to use the object construct in Scala. Use it when you need a class with a single instance, or when you want to find a home for miscellaneous values or functions.
The key points of this chapter are:
• Use objects for singletons and utility methods.
• A class can have a companion object with the same name.
• Objects can extend classes or traits.
• The apply method of an object is usually used for constructing new instances of the companion class. • To avoid the main method, use an object that extends the App trait.
• You can implement enumerations by extending the Enumeration object.

Scala has no static methods or fields. Instead, you use the object construct. An object defines a single instance of a class with the features that you want.

An object can have essentially all the features of a class—it can even extend other classes or traits (see Section 6.3, “Objects Extending a Class or Trait,” on page 67). There is just one exception: You cannot provide constructor parameters.
You use an object in Scala whenever you would have used a singleton object in Java or C++:
• As a home for utility functions or constants
• When a single immutable instance can be shared efficiently
• When a single instance is required to coordinate some service (the singleton design pattern)

Companion Objects
In Java or C++, you often have a class with both instance methods and static methods. In Scala, you achieve this by having a class and a “companion” object of the same name. 

The class and its companion object can access each other’s private features. They must be located in the same source file.

Objects Extending a Class or Trait
An object can extend a class and/or one or more traits. The result is an object of a class that extends the given class and/or traits, and in addition has all of the features specified in the object definition.


