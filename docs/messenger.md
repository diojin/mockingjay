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

geymotion      diojin premierme@sina.com                            ${new}

1, install genymotion, install sasume s5 4.4.4
					2, install charles
					Registered name: Forward Ventures LLC
					License key: a1a5ada0b610cbfd60
                    

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

