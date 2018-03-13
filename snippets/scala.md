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
        + [call by name notation](#call-by-name-notation)
        + [Pattern Matching](#pattern-matching) 
        + [XML Processing](#xml-processing)
        + [Structural Types](#structural-types)
        + [Actor](#actor)
* [Collection Operations](#collection-operations) 
    - [Scala Streams](#scala-streams)
    - [Lazy view](#lazy-view)
    - [Parallel Collections](#parallel-collections)
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
```scala
      val reducePartition: Iterator[T] => Option[T] = iter => {
        if (iter.hasNext) {
          Some(iter.reduceLeft(cleanF))
        } else {
          None
        }
      }
```

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

#### call by name notation
```scala
def runInThread(block: () => Unit) {
  new Thread {
    override def run() { block() }
  }.start()
}

runInThread { () => println("Hi"); Thread.sleep(10000); println("Bye") }
```

```scala
def runInThread(block: => Unit) {
  new Thread {
    override def run() { block }
  }.start()
}

runInThread { println("Hi"); Thread.sleep(10000); println("Bye") }
```
The technical term for such a function parameter is a **call-by-name** parameter. Unlike a regular (or **call-by-value**) parameter, the parameter expression is not evaluated when the function is called.

```scala
def until(condition: => Boolean)(block: => Unit) {
  if (!condition) {
    block
    until(condition)(block)
  }
}

var x = 10
until ( x == 0 ){
  x -= 1
  println(x)
}

```

#### Pattern Matching
```scala
var sign = 0
val ch: Char = '+'
var digit: Int = 0 
ch match {
  case _ if Character.isDigit(ch) => digit = Character.digit(ch, 10)
  case _ => sign = 0
}

val obj: Any = 1
obj match {
  case x: Int => x
  case s: String => Integer.parseInt(s)
  case _: BigInt => Int.MaxValue
  case _ => 0
} 

val arr = Array(0, 1, 3, 6)
arr match {
  case Array(0) => "0"
  case Array(x, y) => x + " " + y
  case Array(0, _*) => "0 ..."
  case _ => "something else"
}

val pattern = "([0-9]+) ([a-z]+)".r
  "99 bottles" match {
  case pattern(num, item) => ...
  // Sets num to "99", item to "bottles"
}

9 :: (4 :: (2 :: Nil))

def sum(lst: List[Int]): Int = lst match {
  case Nil => 0
  case h :: t => h + sum(t) // h is lst.head, t is lst.tail
}

// ~ case class for combining pairs of parse results.
result match { case p ~ q => ... } // Same as case ~(p, q)
result match { case p ~ q ~ r => ... } // is nicer than ~(~(p, q), r).


// Matching Nested Structures
abstract class Item
case class Article(description: String, price: Double) extends Item
case class Bundle(description: String, discount: Double, items: Item*) extends Item

val item = 
Bundle("Father's day special", 20.0,
  Article("Scala for the Impatient", 39.95),
  Bundle(  "Anchor Distillery Sampler", 10.0,
           Article("Old Potrero Straight Rye Whiskey", 79.95),
           Article("Junípero Gin", 32.95)))

item match {
  case Bundle(_, _, Article(descr, _), _*) => println(descr)
  // You can bind a nested value to a variable with the @ notation
  case Bundle(_, _, art @ Article(_, _), rest @ _*) => println(art.description)
  case _ => println("no match")
}

def priceCalc(it: Item): Double = it match {
  case Article(_, p) => p
  case Bundle(_, disc, its @ _*) => its.map(priceCalc _).sum - disc
}

val f: PartialFunction[Char, Int] = { case '+' => 1 ; case '-' => -1 }
f('-') // Calls f.apply('-'), returns -1
f.isDefinedAt('0') // false
f('0') // Throws MatchError

// the **collect** method of the GenTraversable trait applies a partial function to all elements where it is defined, and returns a sequence of the results
"-3+4".collect { case '+' => 1 ; case '-' => -1 } // Vector(-1, 1)

// XML literals in pattern matching expressions
node match {
  case <img/> => ...
  ...
}
```

### XML Processing
```scala
// of type scala.xml.Elem
val doc = <html><head><title>Fred's Memoirs</title></head><body>...</body></html>

// scala.xml.NodeSeq
val items = <li>Fred</li><li>Wilma</li>

// Embedded Expressions
<ul><li>{items(0)}</li><li>{items(1)}</li></ul>

// xpath
val list = <dl><dt>Java</dt><dd>Gosling</dd><dt>Scala</dt><dd>Odersky</dd></dl>
val languages = list \ "dt"
//<dt>Java</dt> 
//<dt>Scala</dt>

```

You can use XML literals in pattern matching expressions. For example,
```scala
node match {
  case <img/> => ...
  ...
}
```

```scala
val list = <ul><li>Fred</li><li>Wilma</li></ul>
val list2 = list.copy(label = "ol")
val list1 = <ul><li>Fred</li><li>Wilma</li></ul>
val list2 = list1.copy(label = "ol")
// To add a child, make a call to copy like this:
list1.copy(child = list1.child ++ <li>Another item</li>)
// To add or change an attribute, use the % operator:
val image = <img src="hamster.jpg"/>
val image2 = image % Attribute(null, "alt", "An image of a hamster", Null)
val image3 = image % Attribute(null, "alt", "An image of a frog",
  Attribute(null, "src", "frog.jpg", Null))


val rule1 = new RewriteRule {
  override def transform(n: Node) = n match {
    case e @ <ul>{ _* }</ul> => e.asInstanceOf[Elem].copy(label = "ol")
    case _ => n
  }
}
val transformed = new RuleTransformer(rule1).transform(root)

import scala.xml.XML
val root = XML.loadFile("myfile.xml")
val root2 = XML.load(new FileInputStream("myfile.xml"))
val root3 = XML.load(new InputStreamReader(new FileInputStream("myfile.xml"), "UTF-8"))
val root4 = XML.load(new URL("http://horstmann.com/index.html"))

XML.save("myfile.xml", root)

// You can also save to a java.io.Writer, but then you must specify all parameters.
XML.write(writer, root, "UTF-8", false, null)

// to generate like <img src="hamster.jpg"/>
val str = xml.Utility.toXML(node, minimizeTags = true)

val printer = new PrettyPrinter(width = 100, step = 4)
val str = printer.formatNodes(nodeSeq)
```

#### Structural Types
A “structural type” is a specification of abstract methods, fields, and types that a conforming type should possess. For example, this method has a structural type parameter:  
```scala
def appendLines(target: { def append(str: String): Any },
                  lines: Iterable[String]) {
  for (l <- lines) { target.append(l); target.append("\n") }
}
```
You can call the appendLines method with an instance of any class that has an append method. This is more flexible than defining a Appendable trait, because you might not always be able to add that trait to the classes you are using.

### Actor
```scala
import scala.actors.Actor
class HiActor extends Actor {
  def act() {
    while (true) {
      receive {
        case "Hi" => println("Hello")
      }
    }
  }
}

// To start an actor
val actor1 = new HiActor
actor1.start()

actor1 ! "Hi"

import scala.actors.Actor._
val actor2 = actor {
  while (true) {
    receive {
      case "Hi" => println("Hello")
    }
  }
}

receive {
  case Deposit(amount) => ...
  case Withdraw(amount) => ...
}

actor ! Compute(data, continuation)



case class Compute(input: Seq[Int], result: OutputChannel[Int])

class Computer extends Actor {
  public void act() {
    while (true) {
      receive {
        case Compute(input, out) => { val answer = ...; out ! answer }
      }
    }
  }
}

actor {
  val channel = new Channel[Int]
  val computeActor: Computer = ...
  val input: Seq[Double] = ...
  computeActor ! Compute(input, channel)
  channel.receive {
    case x => ... // x is known to be an Int
  }
}

// An actor can send a message and wait for a reply, by using the !? operator. For example,

val reply = account !? Deposit(1000)
reply match {
  case Balance(bal) => println("Current Balance: " + bal)
}

// For this to work, the recipient must return a message to the sender:
receive {
  case Deposit(amount) => { balance += amount; sender ! Balance(balance) }
  ...
}

actor {
  worker ! Task(data, self)
  receiveWithin(seconds * 1000) {
    case Result(data) => ...
    case TIMEOUT => log(...)
  }
}


val replyFuture = account !! Deposit(1000)
val reply = replyFuture()

react { // Partial function f1
  case Withdraw(amount) =>
  react { // Partial function f2
    case Confirm() =>
      println("Confirming " + amount)
  }
}

override def act() {
  trapExit = true
  link(worker)
  while (...) {
    receive {
      ...
      case Exit(linked, UncaughtException(_, _, _, _, cause)) => ...
      case Exit(linked, reason) => ...
    }
  }
}

```




## Collection Operations

### Scala Streams
The #:: operator is like the :: operator for lists, but it constructs a stream
```scala
def numsFrom(n: BigInt): Stream[BigInt] = n #:: numsFrom(n + 1)
val tenOrMore = numsFrom(10)        // Stream(10, ?)
println(tenOrMore)                  // Stream(10, ?)
// The tail is unevaluated.
tenOrMore.tail.tail.tail            // Stream(13, ?)    
println(tenOrMore)                  // Stream(10, 11, 12, 13, ?)
tenOrMore.tail.tail                 // Stream(12, 13, ?)
tenOrMore.tail                      // Stream(11, 12, 13, ?)
println(tenOrMore)                  // Stream(10, 11, 12, 13, ?)
tenOrMore.take(3).force             // Stream(10, 11, 12)
println(tenOrMore)                  // Stream(10, 11, 12, 13, ?)
tenOrMore.take(5).force             // Stream(10, 11, 12, 13, 14)
println(tenOrMore)                  // Stream(10, 11, 12, 13, 14, ?)
tenOrMore.tail.tail                 // Stream(12, 13, 14, ?)
// Stream methods are executed lazily.
val squares = numsFrom(2).map { x => x * x }    // Stream(4, ?)
// You have to call squares.tail to force evaluation of the next entry.
squares.tail                        // Stream(9, ?)
println(squares)                    // Stream(4, 9, ?)
// If you want to get more than one answer, you can invoke take followed by force, 
// which forces evaluation of all values.
squares.take(5).force               // Stream(4, 9, 16, 25, 36)
```
Stream methods are executed lazily.  
Of course, you don’t want to call  
```scala
squares.force // No!
```
That call would attempt to evaluate all members of an infinite stream, causing an `OutOfMemoryError`.

`You can construct a stream from an iterator`. For example, the Source.getLines method returns an Iterator[String]. With that iterator, you can only visit the lines once. A stream caches the visited lines so you can revisit them:  
```scala
val words = scala.io.Source.fromFile("src/main/scala/outerhaven/sfti/definition/testfile1.txt")
              .getLines().toStream
println(words)          // Stream(Alpha, ?)
println(words(5))       // Nari
println(words)          // Stream(Alpha, Boy, Cat, Dio, Edin, Nari, ?)
// revisit lines
println(words(2))       // Cat
```

### Lazy view
Lazy views can be beneficial if a large collection is transformed in multiple ways, because it `avoids building up large intermediate collections`. For example, compare  
```scala
(0 to 1000).map(pow(10, _)).map(1 / _)
```
with  
```scala
(0 to 1000).view.map(pow(10, _)).map(1 / _).force
```
The former computes a collection of the powers of 10, then applies the reciprocal to all of them. The latter computes a view that remembers both map operations. When evaluation is forced, both operations are applied to each element, `without building an intermediate collection.`

### Parallel Collections
```scala
coll.par.count(_ % 2 == 0)

for (i <- (0 until 100).par) print(i + " ")
```
Try it out—the numbers are printed in the order they are produced by the threads working on the task.
In a for/yield loop, the results are assembled in order. Try this:
```scala
for (i <- (0 until 100).par) yield i + " "
```

`Not all methods can be parallelized`. For example, reduceLeft and reduceRight require that each operator is applied in sequence. There is an alternate method, **reduce**, that operates on parts of the collection and combines the results. For this to work, `the operator must be associative`—it must fulfill (a op b) op c = a op (b op c).   
For example, addition is associative but subtraction is not: (a – b) – c ≠ a – (b – c).  
Similarly, there is a **fold** method that operates on parts of the collection. Unfortunately, it is not as flexible as foldLeft or foldRight—`both arguments of the operator must be elements`. That is, you can do coll.par.fold(0)(_ + _), but you cannot do a more complex fold such as the one at the end of Section 13.10, “Reducing, Folding, and Scanning,” on page 168.  
To solve this problem, there is an even more general **aggregate** that applies an operator to parts of the collection, and then uses another operator to combine the results. For example, 
```scala
str.par.aggregate(Set[Char]())(_ + _, _ ++ _) 
```
is the equivalent of  
```scala
str.foldLeft(Set[Char]())(_ + _)
```
forming a set of all distinct characters in str.

`You can sort an array, but not an array buffer, in place`:  
```scala
val a = Array(1, 7, 2, 9)
scala.util.Sorting.quickSort(a)
// a is now Array(1, 2, 7, 9)

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

Note that :: is right-associative. With the :: operator, lists are constructed from the end.
```scala
9 :: (4 :: (2 :: Nil))

def sum(lst: List[Int]): Int = lst match {
  case Nil => 0
  case h :: t => h + sum(t) // h is lst.head, t is lst.tail
}
```

```scala
// For example, this loop changes all negative values to zero
val lst = scala.collection.mutable.LinkedList(1, -2, 7, -9)
var cur = lst
while (cur != Nil) {
  if (cur.elem < 0) cur.elem = 0
  cur = cur.next
}

// This loop removes every second element from the list
cur = lst
while (cur != Nil && cur.next != Nil) {
  cur.next = cur.next.next
  cur = cur.next
}
```

* flatMap  
If the function yields a collection instead of a single value, you may want to concatenate all results. In that case, use **flatMap** instead of map. For example, consider  
```scala
val names = List("Peter", "Paul", "Mary")
def ulcase( s: String ) = Vector( s.toUpperCase(), s.toLowerCase() )
println(names.map(ulcase))      // List(Vector(PETER, peter), Vector(PAUL, paul), Vector(MARY, mary))
println(names.flatMap(ulcase))  // List(PETER, peter, PAUL, paul, MARY, mary)
```

* collect  
The **collect** method works with partial functions—functions that may not be defined for all inputs. It yields a collection of all function values of the arguments on which it is defined. For example,  
```scala
"-3+4".collect { case '+' => 1 ; case '-' => -1 } // Vector(-1, 1)
```

*fold  
Often, it is useful to start the computation with an initial element other than the initial element of a collection. The call
```scala
coll.foldLeft(init)(op)

List(1, 7, 2, 9).foldLeft(0)(_-_)
(0 /: List(1, 7, 2, 9))(_ - _)
```

```scala
val freq = scala.collection.mutable.Map[Char, Int]()
for (c <- "Mississippi") freq(c) = freq.getOrElse(c, 0) + 1
// Now freq is Map('i' -> 4, 'M' -> 1, 's' -> 4, 'p' -> 2)

//  with folding, it turns to
val foldingRes1 = ( Map[Char, Int]() /: "Mississippi" ) {  
  ( map, newchar ) => map + ( newchar -> (map.getOrElse(newchar, 0) + 1) ) 
}    // Map(M -> 1, i -> 4, s -> 4, p -> 2)
```

* zip  
If one collection is shorter than the other, the result has as many pairs as the shorter collection. For example,
```scala
List(5.0, 20.0, 9.95) zip List(10, 2)    // List((5.0, 10), (20.0, 2))
List(5.0, 20.0, 9.95).zipAll(List(10, 2), 0.0, 1)  // List((5.0, 10), (20.0, 2), (9.95, 1))

"Scala".zipWithIndex          // Vector(('S', 0), ('c', 1), ('a', 2), ('l', 3), ('a', 4))
"Scala".zipWithIndex.max      // ('l', 3)
"Scala".zipWithIndex.max._2   // 3
```

## Micellaneous



---
[scala_collection_binary_operation_img_1]:/resources/img/java/scala_collection_binary_operation_1.png "scala_collection_binary_operation_1"