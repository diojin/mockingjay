# 			Digest of Learning Spark
## 				by Holden Karau, Andy Konwinski, Patrick Wendell, and Matei Zaharia
## 				February 2015: First Edition
---
## Indexes
* [Recommendations](#recommendations)
* [Miscellaneous](#miscellaneous)

## Recommendations
If you are a data scientist and don’t have much experience with Python, the books [Learning Python] and [Head First Python] (both O’Reilly) are excellent introductions. If you have some Python experience and want more, [Dive into Python] (Apress) is a great book to help you get a deeper understanding of Python.  

If you are an engineer and after reading this book you would like to expand your data analysis skills, [Machine Learning for Hackers] and [Doing Data Science] are excellent books (both O’Reilly).

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

在学习python的过程中，之前我使用pycharm，现在我已经转到ipython notebook，现在叫jupter notebook，它的好处可能需要单独开个帖子了，这个地方只点个题，感兴趣的可以自己查查/使用


---
[Learning Python]:http://shop.oreilly.com/product/0636920028154.do "Learning Python, 5th Edition Powerful Object-Oriented Programming"
[Head First Python]:http://shop.oreilly.com/product/0636920003434.do "Head First Python A Brain-Friendly Guide"
[Dive into Python]:http://www.diveintopython.net/ "Dive Into Python"
[Machine Learning for Hackers]:http://shop.oreilly.com/product/0636920018483.do "Machine Learning for Hackers Case Studies and Algorithms to Get You Started"
[Doing Data Science]:http://shop.oreilly.com/product/0636920028529.do "Doing Data Science Straight Talk from the Frontline"
[hadoop_hbase_implementation_img_1]:/resources/img/java/hadoop_hbase_implementation_1.png "Figure 20-2. HBase cluster members"