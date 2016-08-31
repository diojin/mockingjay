解决 Git 在 windows 下中文乱码的问题
https://gist.github.com/nightire/5069597
Git for windows 中文乱码解决方案
https://segmentfault.com/a/1190000000578037

Scala resources

Stack Overflow Scala Tutorial, also recommending other learning staffs
http://stackoverflow.com/tags/scala/info

Programming in Scala 3rd edition        best so far, Scala创建者Martin Ordersky等的大作，是最权威的Scala入门书箱

Programming In Scala。Scala创建者Martin Ordersky等的大作，是最权威的Scala入门书箱，不过书中讲解的Scala版本有点老，这本书整体给我的感觉还可以，只是有些例子举得感觉不适合初学者。这部大作有中文版，但翻译得真实太烂，ZTMD烂。
Scala In Action. 一般来讲，In Action系列的书都还可以，这本书整体也还不错，但对Scala 的内容覆盖面太小，很多重要内容里面没有涉及，个人感觉它不适合初学者，建议初学者不要看。
Scala In Depth。这本书比较适合初学者看，Scala中的重要语法内容都有所覆盖
Scala Cookbook。这本书按Scala的知识点来讲解Scala语法，大多数语法都有涉及，适合初学者
Scala For the Impatient。这本书推荐初学者也一定要看，整体内容在我看来还是比较到位的，这本书也有中文版，不过我个人觉得翻译得也是让人有种淡淡的忧伤，很多地方都是字面翻译。

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
