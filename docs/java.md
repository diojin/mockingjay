## Indexes
---


* [Collections](#collections)
    - [Misc](#collections-misc)
* [Miscellaneous](#miscellaneous)
    - [class loader](#class-loader)
    - [NIO](#nio)
    - [Stream](#stream)

### Collections

#### Collections Misc

##### STL collections references

STL容器分两种，
* 序列式容器(vector/list/deque/stack/queue/heap)
* 关联式容器  
关联式容器又分为set(集合)和map(映射表)两大类，以及这两大类的衍生体multiset(多键集合)和multimap(多键映射表)，这些容器均以`RB-tree`完成。此外，还有第3类关联式容器，如hashtable(散列表)，以及以hashtable为底层机制完成的hash_set(散列集合)/hash_map(散列映射表)/hash_multiset(散列多键集合)/hash_multimap(散列多键映射表)。也就是说，`set/map/multiset/multimap都内含一个RB-tree，(PS: is java the same?)`而hash_set/hash_map/hash_multiset/hash_multimap都内含一个hashtable。

`set，同map一样，所有元素都会根据元素的键值自动被排序`，因为set/map两者的所有各种操作，都只是转而调用RB-tree的操作行为，不过，值得注意的是，两者都不允许两个元素有相同的键值。

不同的是：set的元素不像map那样可以同时拥有实值(value)和键值(key)，set元素的键值就是实值，实值就是键值，而map的所有元素都是pair，同时拥有实值(value)和键值(key)，pair的第一个元素被视为键值，第二个元素被视为实值。

至于multiset/multimap，他们的特性及用法和set/map完全相同，唯一的差别就在于它们允许键值重复，即所有的插入操作基于RB-tree的insert_equal()而非insert_unique()。

但由于hash_set/hash_map都是基于hashtable之上，所以不具备自动排序功能。为什么?因为hashtable没有自动排序功能。

至于hash_multiset/hash_multimap的特性与上面的multiset/multimap完全相同，唯一的差别就是它们hash_multiset/hash_multimap的底层实现机制是hashtable（而multiset/multimap，上面说了，底层实现机制是RB-tree），所以它们的元素都不会被自动排序，不过也都允许键值重复。

###### set/map vs hash_set/hash_map on performance

从程序运行结果可以发现，我们自己实现的hash_table（简化版）在插入和查找的效率要远高于set。 

[![collections_1]][collections_2]

[For more information][collections_2]

可以发现在hash_table(简化实现的)中最长的链表也只有5个元素，长度为1和长度为2的链表中的数据占全部数据的89%以上。因此绝大数查询将仅仅访问哈希表1次到2次。这样的查询效率当然会比set（内部使用红黑树——类似于二叉平衡树）高的多。有了这个图示，无疑已经可以证明hash_set会比set快速高效了。

###### RB Tree vs Hashtable on performance

据朋友№邦卡猫№的做的红黑树和hash table的性能测试中发现：`当数据量基本上int型key时，hash table是rbtree的3-4倍，但hash table一般会浪费大概一半内存`。

因为hash table所做的运算就是个%，而rbtree要比较很多，比如rbtree要看value的数据 ，每个节点要多出3个指针（或者偏移量） 如果需要其他功能，比如，统计某个范围内的key的数量，就需要加一个计数成员。
    
且1s rbtree能进行大概50w+次插入，hash table大概是差不多200w次。不过很多的时候，其速度可以忍了，例如倒排索引差不多也是这个速度，而且单线程，且倒排表的拉链长度不会太大。`正因为基于树的实现其实不比hashtable慢到哪里去，所以数据库的索引一般都是用的B/B+树，而且B+树还对磁盘友好(B树能有效降低它的高度，所以减少磁盘交互次数)。比如现在非常流行的NoSQL数据库，像MongoDB也是采用的B树索引。`关于B树系列，请参考本blog内此篇文章：[从B树、B+树、B*树谈到R 树][collections_3]。更多请待后续实验论证。



### Miscellaneous

#### class loader
[For more information][misc_class_loader_1]

__Java默认提供的三个ClassLoader__
1. BootStrap ClassLoader：称为启动类加载器，是Java类加载层次中最顶层的类加载器，负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等，可通过如下程序获得该类加载器从哪些地方加载了相关的jar或class文件
2. Extension ClassLoader：称为扩展类加载器，负责加载Java的扩展类库，默认加载JAVA_HOME/jre/lib/ext/目下的所有jar。
3. App ClassLoader：称为系统类加载器，负责加载应用程序classpath目录下的所有jar和class文件。

注意： 除了Java默认提供的三个ClassLoader之外，用户还可以根据需要定义自已的ClassLoader，而这些自定义的ClassLoader都必须继承自java.lang.ClassLoader类，也包括Java提供的另外二个ClassLoader（Extension ClassLoader和App ClassLoader）在内，但是Bootstrap ClassLoader不继承自ClassLoader，因为它不是一个普通的Java类，底层由C++编写，已嵌入到了JVM内核当中，当JVM启动后，Bootstrap ClassLoader也随着启动，负责加载完核心类库后，并构造Extension ClassLoader和App ClassLoader类加载器。

__ClassLoader加载类的原理__
1. 原理介绍
ClassLoader使用的是`双亲委托模型`来搜索类的，每个ClassLoader实例都有一个父类加载器的引用（不是继承的关系，是一个包含的关系），虚拟机内置的类加载器（Bootstrap ClassLoader）本身没有父类加载器，但可以用作其它ClassLoader实例的的父类加载器。当一个ClassLoader实例需要加载某个类时，它会试图亲自搜索某个类之前，先把这个任务委托给它的父类加载器，这个过程是由上至下依次检查的，首先由最顶层的类加载器Bootstrap ClassLoader试图加载，如果没加载到，则把任务转交给Extension ClassLoader试图加载，如果也没加载到，则转交给App ClassLoader 进行加载，如果它也没有加载得到的话，则返回给委托的发起者，由它到指定的文件系统或网络等URL中加载该类。如果它们都没有加载到这个类时，则抛出ClassNotFoundException异常。否则将这个找到的类生成一个类的定义，并将它加载到内存当中，最后返回这个类在内存中的Class实例对象

2、为什么要使用双亲委托这种模型呢？
       因为这样可以避免重复加载，当父亲已经加载了该类的时候，就没有必要子ClassLoader再加载一次。考虑到安全因素，我们试想一下，如果不使用这种委托模式，那我们就可以随时使用自定义的String来动态替代java核心api中定义的类型，这样会存在非常大的安全隐患，而双亲委托的方式，就可以避免这种情况，因为String已经在启动时就被引导类加载器（Bootstrcp ClassLoader）加载，所以用户自定义的ClassLoader永远也无法加载一个自己写的String，除非你改变JDK中ClassLoader搜索类的默认算法。

3、 但是JVM在搜索类的时候，又是如何判定两个class是相同的呢？
     JVM在判定两个class是否相同时，不仅要判断两个类名是否相同，而且要判断是否由同一个类加载器实例加载的。只有两者同时满足的情况下，JVM才认为这两个class是相同的。就算两个class是同一份class字节码，如果被两个不同的ClassLoader实例所加载，JVM也会认为它们是两个不同class。比如网络上的一个Java类org.classloader.simple.NetClassLoaderSimple，javac编译之后生成字节码文件NetClassLoaderSimple.class，ClassLoaderA和ClassLoaderB这两个类加载器并读取了NetClassLoaderSimple.class文件，并分别定义出了java.lang.Class实例来表示这个类，对于JVM来说，它们是两个不同的实例对象，但它们确实是同一份字节码文件，如果试图将这个Class实例生成具体的对象进行转换时，就会抛运行时异常java.lang.ClassCaseException，提示这是两个不同的类型。现在通过实例来验证上述所描述的是否正确：

4、ClassLoader的体系架构：
 

四、定义自已的ClassLoader
既然JVM已经提供了默认的类加载器，为什么还要定义自已的类加载器呢？
      因为Java中提供的默认ClassLoader，只加载指定目录下的jar和class，如果我们想加载其它位置的类或jar时，比如：我要加载网络上的一个class文件，通过动态加载到内存之后，要调用这个类中的方法实现我的业务逻辑。在这样的情况下，默认的ClassLoader就不能满足我们的需求了，所以需要定义自己的ClassLoader。
定义自已的类加载器分为两步：
1、继承java.lang.ClassLoader
2、重写父类的findClass方法
读者可能在这里有疑问，父类有那么多方法，为什么偏偏只重写findClass方法？
      因为JDK已经在loadClass方法中帮我们实现了ClassLoader搜索类的算法，当在loadClass方法中搜索不到类时，loadClass方法就会调用findClass方法来搜索类，所以我们只需重写该方法即可。如没有特殊的要求，一般不建议重写loadClass搜索类的算法。下图是API中ClassLoader的loadClass方法：
 


http://www.blogjava.net/lhulcn618/archive/2006/05/25/48230.html


classloader 加载类用的是全盘负责委托机制。所谓全盘负责，即是当一个classloader加载一个Class的时候，这个Class所依赖的和引用的所有 Class也由这个classloader负责载入，除非是显式的使用另外一个classloader载入；委托机制则是先让parent（父）类加载器 (而不是super，它与parent classloader类不是继承关系)寻找，只有在parent找不到的时候才从自己的类路径中去寻找。此外类加载还采用了cache机制，也就是如果 cache中保存了这个Class就直接返回它，如果没有才从文件中读取和转换成Class，并存入cache，这就是为什么我们修改了Class但是必须重新启动JVM才能生效的原因

每个ClassLoader加载Class的过程是：
1.检测此Class是否载入过（即在cache中是否有此Class），如果有到8,如果没有到2
2.如果parent classloader不存在（没有parent，那parent一定是bootstrap classloader了），到4
3.请求parent classloader载入，如果成功到8，不成功到5
4.请求jvm从bootstrap classloader中载入，如果成功到8
5.寻找Class文件（从与此classloader相关的类路径中寻找）。如果找不到则到7.
6.从文件中载入Class，到8.
7.抛出ClassNotFoundException.
8.返回Class.

其中5.6步我们可以通过覆盖ClassLoader的findClass方法来实现自己的载入策略。甚至覆盖loadClass方法来实现自己的载入过程。

这里怎么又出来一个context classloader呢？它有什么用呢？我们在建立一个线程Thread的时候，可以为这个线程通过setContextClassLoader方法来指定一个合适的classloader作为这个线程的context classloader，当此线程运行的时候，我们可以通过getContextClassLoader方法来获得此context classloader，就可以用它来载入我们所需要的Class。默认的是system classloader。利用这个特性，我们可以“打破”classloader委托机制了，父classloader可以获得当前线程的context classloader，而这个context classloader可以是它的子classloader或者其他的classloader，那么父classloader就可以从其获得所需的 Class，这就打破了只能向父classloader请求的限制了。这个机制可以满足当我们的classpath是在运行时才确定,并由定制的 classloader加载的时候,由system classloader(即在jvm classpath中)加载的class可以通过context classloader获得定制的classloader并加载入特定的class(通常是抽象类和接口,定制的classloader中是其实现),例如web应用中的servlet就是用这种机制加载的.


#### NIO

[For more information][misc_nio_1]

Java NIO 由以下几个核心部分组成： 

* Channels
- Buffers
* Selectors

基本上，所有的 IO 在NIO 中都从一个Channel 开始。Channel 有点象流。 数据可以从Channel读到Buffer中，也可以从Buffer 写到Channel中。

Channel和Buffer有好几种类型。下面是JAVA NIO中的一些主要Channel的实现： 
* FileChannel
* DatagramChannel
* SocketChannel
* ServerSocketChannel

以下是Java NIO里关键的Buffer实现：
* ByteBuffer
* CharBuffer
* DoubleBuffer
* FloatBuffer
* IntBuffer
* LongBuffer
* ShortBuffer

__MappedByteBuffer__
java处理大文件，一般用BufferedReader,BufferedInputStream这类带缓冲的Io类，不过如果文件超大的话，更快的方式是采用MappedByteBuffer。MappedByteBuffer是java nio引入的文件内存映射方案，读写性能极高。NIO最主要的就是实现了对异步操作的支持。

Selector允许单线程处理多个 Channel。如果你的应用打开了多个连接（通道），但每个连接的流量都很低，使用Selector就会很方便。例如，在一个聊天服务器中。 

如果需要管理同时打开的成千上万个连接，这些连接每次只是发送少量的数据，例如聊天服务器，实现NIO的服务器可能是一个优势。同样，如果你需要维持许多打开的连接到其他计算机上，如P2P网络中，使用一个单独的线程来管理你所有出站连接，可能是一个优势。

要使用Selector，得向Selector注册Channel，然后调用它的select()方法。这个方法会一直阻塞到某个注册的通道有事件就绪。一旦这个方法返回，线程就可以处理这些事件，事件的例子有如新连接进来，数据接收等。

##### Java NIO提供了与标准IO不同的IO工作方式 

Channels and Buffers（通道和缓冲区）：标准的IO基于字节流和字符流进行操作的，而NIO是基于通道（Channel）和缓冲区（Buffer）进行操作，数据总是从通道读取到缓冲区中，或者从缓冲区写入到通道中。
__Asynchronous IO（异步IO）__：Java NIO可以让你异步的使用IO，例如：当线程从通道读取数据到缓冲区时，线程还是可以进行其他事情。当数据被写入到缓冲区时，线程可以继续处理它。从缓冲区写入通道也类似。
Selectors（选择器）：Java NIO引入了选择器的概念，选择器用于监听多个通道的事件（比如：连接打开，数据到达）。因此，单个的线程可以监听多个数据通道。

|IO|NIO
|----|----
|Stream oriented | Buffer oriented
|Blocking IO | Non blocking IO
| | Selectors


NIO可让您只使用一个（或几个）单线程管理多个通道（网络连接或文件），`但付出的代价是解析数据可能会比从一个阻塞流中读取数据更复杂。`


__面向流与面向缓冲__

Java NIO和IO之间第一个最大的区别是，IO是面向流的，NIO是面向缓冲区的。 Java IO面向流意味着每次从流中读一个或多个字节，直至读取所有字节，它们没有被缓存在任何地方。此外，它不能前后移动流中的数据。如果需要前后移动从流中读取的数据，需要先将它缓存到一个缓冲区。 Java NIO的缓冲导向方法略有不同。数据读取到一个它稍后处理的缓冲区，需要时可在缓冲区中前后移动。这就增加了处理过程中的灵活性。但是，还需要检查是否该缓冲区中包含所有您需要处理的数据。而且，需确保当更多的数据读入缓冲区时，不要覆盖缓冲区里尚未处理的数据。

__阻塞与非阻塞IO__ 

Java IO的各种流是阻塞的。这意味着，当一个线程调用read() 或 write()时，该线程被阻塞，直到有一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了。 Java NIO的非阻塞模式，使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据，如果目前没有数据可用时，就什么都不会获取。而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以继续做其他的事情。 非阻塞写也是如此。一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。 线程通常将非阻塞IO的空闲时间用于在其它通道上执行IO操作，所以一个单独的线程现在可以管理多个输入和输出通道（channel）。 



#### Stream

---
[collections_1]:/resources/img/java/collection_performance_test_1.png "performance test: set vs hash_set vs hash_table"
[collections_2]:http://blog.csdn.net/morewindows/article/details/7330323 "STL系列之九 探索hash_set"
[collections_3]:http://blog.csdn.net/v_JULY_v/article/details/6530142 "从B 树、B+ 树、B* 树谈到R 树"
[misc_nio_1]:http://www.iteye.com/magazines/132-Java-NIO "Java NIO 系列教程"
[misc_class_loader_1]:http://blog.csdn.net/xyang81/article/details/7292380 "深入分析Java ClassLoader原理"