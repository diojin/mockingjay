解决 Git 在 windows 下中文乱码的问题
https://gist.github.com/nightire/5069597
Git for windows 中文乱码解决方案
https://segmentfault.com/a/1190000000578037


lombok官网 https://projectlombok.org/download.html
1.官网下载lombok.jar
2. 找到Eclipse应用（在Mac上就是Eclipse.app文件），选择打开包内容，找到eclipse.ini
3.将lombok.jar拷贝至eclipse.ini所在目录下，并在eclipse.ini文件最后加上如下两行
-Xbootclasspath/a:lombok.jar
-javaagent:/Users/abc/Eclipse/eclipse-jee-mars-1-macosx-cocoa-         
     x86_64/Eclipse.app/Contents/Eclipse/lombok.jar
4.重启eclipse

Mac下lombok无法安装到eclipse mars
http://www.cnblogs.com/taojintianxia/p/4828263.html

Scala resources

Stack Overflow Scala Tutorial, also recommending other learning staffs
http://stackoverflow.com/tags/scala/info

Programming in Scala 3rd edition        best so far, Scala创建者Martin Ordersky等的大作，是最权威的Scala入门书箱

Programming In Scala。Scala创建者Martin Ordersky等的大作，是最权威的Scala入门书箱，不过书中讲解的Scala版本有点老，这本书整体给我的感觉还可以，只是有些例子举得感觉不适合初学者。这部大作有中文版，但翻译得真实太烂，ZTMD烂。
Scala In Action. 一般来讲，In Action系列的书都还可以，这本书整体也还不错，但对Scala 的内容覆盖面太小，很多重要内容里面没有涉及，个人感觉它不适合初学者，建议初学者不要看。
Scala In Depth。这本书比较适合初学者看，Scala中的重要语法内容都有所覆盖
Scala Cookbook。这本书按Scala的知识点来讲解Scala语法，大多数语法都有涉及，适合初学者
Scala For the Impatient。这本书推荐初学者也一定要看，整体内容在我看来还是比较到位的，这本书也有中文版，不过我个人觉得翻译得也是让人有种淡淡的忧伤，很多地方都是字面翻译。


有趣的blog, scala akka spark
http://blog.csdn.net/lovehuangjiaju


快学Scala(《Java核心技术》的作者Cay S. Horstmann最新力作)      Martin Odersky 作序

Scala for the Impatient

Cay Horstmann

“Currently the best compact introduction to Scala” —Martin Odersky

“The book is a joy to read. Probably the most concise reference for Scala available on the market, this deserves to be on every programmers bookshelf”—James Sugrue