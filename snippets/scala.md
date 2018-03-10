# 					Scala Snippets
---

* [Common Operations](#common-operations)
    - [Regex](#regex)
    - [Comon Miscellaneous](#comon-miscellaneous)
        + [special control flow](#special-control-flow)
        + [type ascription](#type-ascription)
        + [Enumeration](#enumeration)
        + [File Operation](#file-operation)
        + [Scala Shell](#scala-shell)
        + [Initializing Trait Fields](#initializing-trait-fields)
        + [apply & unapplySeq](#apply--unapplyseq)
* [Collection Operations](#collection-operations) 
* [Miscellaneous](#miscellaneous)

## Common Operations

### Regex
```scala
val wsnumwsPattern = """\s+[0-9]+\s+""".r
// A bit easier to read than "\\s+[0-9]+\\s+".r

for (matchString <- numPattern.findAllIn("99 bottles, 98 bottles"))
  // process matchString


val numitemPattern = "([0-9]+) ([a-z]+)".r

val numitemPattern(num, item) = "99 bottles"
// Sets num to "99", item to "bottles"

for (numitemPattern(num, item) <- numitemPattern.findAllIn("99 bottles, 98 bottles"))
    // process num and item
```

### Comon Miscellaneous

#### special control flow
`Scala has no break or continue statements to break out of a loop`.   
What to do if you need a break? Here are a few options:   
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

#### type ascription
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

#### Enumeration

```scala
object TrafficLightColor extends Enumeration {
  val Red, Yellow, Green = Value
}

import TrafficLightColor._
def doWhat(color: TrafficLightColor.Value) = {
  if (color == Red) "stop"
  else if (color == Yellow) "hurry up"
  else "go"
}
```
or for simplicity,  
```scala
object TrafficLightColor extends Enumeration {
  type TrafficLightColor = Value
  val Red, Yellow, Green = Value
}

import TrafficLightColor._
def doWhat(color: TrafficLightColor) = {
  if (color == Red) "stop"
  else if (color == Yellow) "hurry up"
  else "go"
}
```

#### File Operation
If you want to be able to peek at a character without consuming it (like istream::peek in C++ or a PushbackInputStreamReader in Java), call the buffered method on the source object. Then you can peek at the next input character with the head method without consuming it.
```scala
val source = Source.fromFile("myfile.txt", "UTF-8")
val iter = source.buffered
while (iter.hasNext) {
  if (iter.head is nice)
    process iter.next
  else
    ...
} 
source.close()
```

#### Scala Shell
```scala
"ls -al .." #| "grep sec" !
```

#### Initializing Trait Fields
`Traits cannot have constructor parameters. Every trait has a single parameterless constructor`.  

```scala
trait Logger {
  def log(msg : String)
}
trait FileLogger extends Logger {
  val filename: String
  val out = new PrintStream(filename)
  def log(msg: String) { out.println(msg); out.flush() }
}
```

1. early definition  
```scala
val acct = new { // Early definition block after new
  val filename = "myapp.log"
} with SavingsAccount with FileLogger

// or in class
class SavingsAccount extends { // Early definition block after extends
  val filename = "savings.log"
} with Account with FileLogger {
... // SavingsAccount implementation
}

```
2. lazy value  
```scala
trait FileLogger extends Logger {
  val filename: String
  lazy val out = new PrintStream(filename)
  def log(msg: String) { out.println(msg) } // No override needed
}
```
However, lazy values are somewhat inefficient since they are checked for initialization before every use.

#### apply & unapplySeq

```scala
class Fraction(n: Int, d: Int) {
  ...
}
object Fraction {
  def apply(n: Int, d: Int) = new Fraction(n, d)
  def unapply(input: Fraction) = if (input.den == 0) None else Some((input.num, input.den))
}

var Fraction(a, b) = Fraction(3, 4) * Fraction(2, 5)
// a, b are initialized with the numerator and denominator of the result

case Fraction(a, b) => ... // a, b are bound to the numerator and denominator

Fraction(10, 20) match {
  case Fraction(a, b) => println(a + "/" + b)
  case _ => println("no match") 
}
```

PS: following example shows match is shortcut match, it matches the first pattern it meets, and the example shows how extractors test its input, or extract an sequence of values  
```scala
object IsCompound {
  def unapply(input : String) = input.contains("Wu")
}

object Name {
  def unapplySeq( input: String ): Option[Seq[String]] = 
    if ( input.trim().equals("") ) None else Some(input.trim.split("\\s+"))
}

var author = "Nari Van De Wu"      // prints "ah Nari, Van, De, Wu"
author = "Nari Wu"                 // prints "haha Nari, Wu"
author = "Nari Jin"                // prints "wow Nari, Jin"
author = "Nari De Wu"              // prints "oh Nari, De, Wu"
author match {
  case Name( first, last @ IsCompound() ) => printf("haha %s, %s\n", first, last)
  case Name( first, last ) => printf("wow %s, %s\n", first, last)
  case Name( first, middle, last ) => printf("oh %s, %s, %s\n", first, middle, last)
  case Name( first, "De", last ) => printf("err %s, %s, %s\n", first, "De", last)
  case Name( first, "Van", "De", last ) => printf("ah %s, %s, %s, %s\n", first, "Van", "De", last)
}
```


## Collection Operations
```scala
var a1 = ArrayBuffer(1, 3,  1, 2, 8, 5)
val aRes = a1.sortBy(x => -x)   //  a1.sortBy(-_)
val aRes2 = a1.sortWith(_ > _)
println(aRes)        // ArrayBuffer(8, 5, 3, 2, 1, 1)
println(aRes2)       // ArrayBuffer(8, 5, 3, 2, 1, 1)

def sortWith(lt: (T, T) ⇒ Boolean): Array[T]

"Mary had a little lamb".split(" ").sortWith(_.length < _.length) //a had Mary lamb little
```


```scala
(1 to 9).map("*" * _).foreach(println _)
// *
// **
// ***
// ****
// *****
// ******
// *******
// ********
// *********
```


```scala
// in scala.collection.Iterable
def reduceLeft[B >: A](op: (B, A) ⇒ B): B
(1 to 9).reduceLeft(_ * _)   // 362880 = (((((((1 * 2) * 3) * 4) * 5 ) * 6) * 7) * 8) * 9
```

Sometimes, you want to use currying for a function parameter so that the type inferencer has more information.  
Here is a typical example. The corresponds method can compare whether two sequences are the same under some comparison criterion. For example,  
```scala
val a = Array("Hello", "World")
val b = Array("hello", "world")
a.corresponds(b)(_.equalsIgnoreCase(_))   // true
```


## Micellaneous



---
[scala_collection_binary_operation_img_1]:/resources/img/java/scala_collection_binary_operation_1.png "scala_collection_binary_operation_1"