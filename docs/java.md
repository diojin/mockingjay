## Indexes
---

* [Concurrent](#concurrent)
    - [Misc](#concurrent-misc)
        + [Immutable Class](#immutable-class)
        + [thread dump](#thread-dump)
        + [Linux Thread Model](#linux-thread-model)
        + [How to safely interrupt a thread](#how-to-safely-interrupt-a-thread)
* [Servlet & JSP](#servlet--jsp)
    - [Lifecycle of Servlet](#lifecycle-of-servlet)
    - [Servlet single thread model](#servlet-single-thread-model)
    - [forward vs redirect](#forward-vs-redirect)
    - [JSP build-in objects and methods](#jsp-build-in-objects-and-methods)
    - [JSP dynamic INCLUDE and static INCLUDE](jsp-dynamic-include-and-static-include)
    - [JSP common directives](#jsp-common-directives)
    - [JSP "commands"](#jsp-commands)
* [Collections](#collections)
    - [Misc](#collections-misc)
        + [STL collections references](#stl-collections-references)
        + [ArrayList vs Vector vs LinkedList](#arraylist-vs-vector-vs-linkedlist)
        + [HashMap vs HashTable vs ConcurrentHashMap](#hashmap-vs-hashtable-vs-concurrenthashmap)
        + [Object#clone](#objectclone)
* [Gabage Collector](#gabage-collector)
* [Web Service](#web-service)
    - [SOAP](#soap)
    - [Related Techniques](#ws-related-techniques)
        + [RMI vs IIOP](#rmi-vs-iiop)
            * [CORBA(Common Object Request Broker Architecture)](#corbacommon-object-request-broker-architecture)
            * [IIOP(Internet Inter-ORB Protocol)](#iiopinternet-inter-orb-protocol)
            * [JavaIDL](#javaidl)
            * [RMI-IIOP](#rmi-iiop)
    - [Different ways of implement web service](#different-ways-of-implement-web-service)
* [JMS](#jms)
    - [Message Broker](#message-broker)
    - [AMQP(Advanced Message Queuing Protocol)](#amqpadvanced-message-queuing-protocol))
    - [Misc](#jms-misc)
        + [Relations between acknowledgement, session, transaction](#relations-between-acknowledgement-session-transaction)
* [Java SE](#java-se)
    - [Instrumentation](#instrumenmtation)
    - [Misc](#java-se-misc)
        + [hashcode](#java-hashcode)
        + [differences between logic operator and condition operator](#differences-between-logic-operator-and-condition-operator)
        + [String#intern](#stringintern)
        + [I/O](#java-io)
        + [Exception](#java-exception)
* [Java EE](#java-ee)
    - [J2EE Design Pattern](#j2ee-design-pattern)
* [EJB](#ejb)
    - [EJB Misc](#ejb_misc)
        + [Differences between StatefulBean and StatelessBean](#differences-between-statefulbean-and-statelessbean)
        + [EJB lifecycle and Transaction Management](#ejb-lifecycle-and-transaction-management)
        + [EJB roles and components](#ejb-roles-and-components)
        + [Aspect fuctions provided by EJB Container](#aspect-fuctions-provided-by-ejb-container)
* [Miscellaneous](#miscellaneous)
    - [Terminologies](#terminologies)
        + [JAF(JavaBeans Activation Framework)](#jafjavabeans-activation-framework)
        + [JAT(Java Application Template)](#jatjava-application-template)
    - [Connection Pooling](#connection-pooling)
    - [class loader](#class-loader)
    - [NIO](#nio)
    - [Stream](#stream)
    - [Eclipse Shortcuts](#eclipse-shortcuts)

### Concurrent



#### Concurrent Misc

##### Immutable Class

Immutable objects offers several benefits over conventional mutable object, especially while creating concurrent Java application. Immutable object not only guarantees __safe publication__ of object’s state, but also can be __shared among other threads without any external synchronization__. In fact JDK itself contains several immutable classes like String, Integer and other wrapper classes.

__How to create an immutable class__  
1. State of immutable object can not be modified after construction, any modification should result in new immutable object.
2. All fields of Immutable class should be final.
3. Object must be properly constructed i.e. object reference must not leak during construction process.
4. Object should be final in order to restrict sub-class for altering immutability of parent class.

Apart from above advantages, immutable object has **disadvantage of creating garbage as well**. Since immutable object can not be reused and they are just a use and throw. String being a prime example, which can create lot of garbage and can potentially slow down application due to heavy garbage collection, but again that's extreme case and if used properly Immutable object adds lot of value

##### thread dump

###### thread status

1. RUNNABLE  
    1. wait for IO read, for example, BufferedReader.readLine()
    2. infinit loop
2. BLOCKED
    1. enter synchronized block
3. WAITING
    1. Object#wait()
    2. Thread#join()
    3. LockSupport.park()
4. TIMED_WAITING
    1. Thread.sleep()
    2. Object#wait(time)
    3. Thread#join(time)
    4. LockSupport.part(time)

__How to generate thread dump?__  
1. use jstack/jconsole
2. kill [-QUIT/-3] <pid>, with correct JVM parameters  
    -XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:LogFile=C: mpjvmoutput.log

##### Linux Thread Model
LINUX实现的就是基于核心轻量级进程的"一对一"线程模型，一个线程实体对应一个核心轻量级进程，而线程之间的管理在核外函数库中实现

##### How to safely interrupt a thread
因为stop，destroy，suspend都被证明是不安全的，并且已过时，那么应该用什么替代呢？  

1. interrupt(), with interrupting codes
2. flag check, with interrupting codes
```java
volatile boolean flag;
//... 
run(){
      while(flag = true){
        // ...
     }   
}
// 将flag设为flase
```
3. FutureTask#cancel(boolean) or ExecuteService#shutdown  
safest way
4. CompletionService

### Servlet & JSP

#### Lifecycle of Servlet
Servlet被服务器实例化后，容器运行其`init`方法，请求到达时运行其`service`方法，service方法自动派遣运行与请求对应的doXXX方法（`doGet，doPost`）等，当服务器决定将实例销毁的时候调用其`destroy`方法。

__init()__  

init() 被调用的时间  
Example:  
```xml
<servlet>  
 <servlet-name>initservlet</servlet-name>  
 <servlet-class>com.bb.eoa.util.initServlet</servlet-class>  
 <init-param>  
  <param-name>log4j-init-file</param-name>  
  <param-value>config/log.properties</param-value>  
 </init-param>  
 <load-on-startup>1</load-on-startup>  
</servlet>
```

The load-on-startup element indicates that this servlet should be loaded (instantiated and have its init() called) on the startup of the web application. The optional contents of these element must be an integer indicating the order in which the servlet should be loaded. If the value is a negative integer, or the element is not present, the container is free to load the servlet whenever it chooses. If the value is a positive integer or 0, the container must load and initialize the servlet as the application is deployed. The container must guarantee that servlets marked with lower integers are loaded before servlets marked with higher integers. The container may choose the order of loading of servlets with the same load-on-start-up value.

在 Servlet 的生命期中，仅执行一次 init() 方法。它是在服务器装入 Servlet 时执行的。可以配置服务器，以在启动服务器或客户机首次访问 Servlet 时装入 Servlet。 

缺省的 init() 方法设置了 Servlet 的初始化参数，并用它的 ServletConfig 对象参数来启动配置， 因此所有覆盖 init() 方法的 Servlet 应调用 super.init() 以确保仍然执行这些任务。在调用 service() 方法之前，应确保已完成了 init() 方法。

__destroy()__  
destroy() 调用时间  
Called by the servlet container to indicate to a servlet that the servlet is being taken out of service. `This method is only called once all threads within the servlet's service method have exited or after a timeout period has passed.` After the servlet container calls this method, it will not call the service method again on this servlet. 

#### forward vs redirect
* forward  
服务器请求资源，服务器直接访问目标地址的URL，把那个URL的响应内容读取过来，然后把这些内容再发给浏览器，浏览器根本不知道服务器发送的内容是从哪儿来的，所以它的地址栏中还是原来的地址。
RequestDispatcher#forward  
更加高效，在前者可以满足需要时，尽量使用forward()方法，并且，这样也有助于隐藏实际的链接。

* redirect  
就是服务器根据逻辑,发送一个状态码,告诉浏览器重新去请求那个地址，一般来说浏览器会用刚才请求的所有参数重新请求，所以session,request参数都可以获取。  
HttpServletResponse#sendRedirct  
在有些情况下，比如，需要跳转到一个其它服务器上的资源，则必须使用sendRedirect()方法。

#### Servlet single thread model
<%@ page isThreadSafe="false"%>


#### JSP build-in objects and methods
JSP共有以下9种基本内置组件（可与ASP的6种内部组件相对应）:  
1. request  
表示HttpServletRequest对象。它包含了有关浏览器请求的信息，并且提供了几个用于获取cookie, header, 和session数据的有用的方法。
2. response  
表示HttpServletResponse对象，并提供了几个用于设置送回浏览器的响应的方法（如cookies,头信息等）
3. page  
表示从该页面产生的一个servlet实例
4. session  
表示一个请求的javax.servlet.http.HttpSession对象。Session可以存贮用户的状态信息
5. application  
表示一个javax.servlet.ServletContext对象, 这有助于查找有关servlet引擎和servlet环境的信息 
6. pageContext  
表示一个javax.servlet.jsp.PageContext对象。它是用于方便存取各种范围的名字空间、servlet相关的对象的API，并且包装了通用的servlet相关功能的方法
7. config  
表示一个javax.servlet.ServletConfig对象。该对象用于存取servlet实例的初始化参数。 
8. out  
是javax.jsp.JspWriter的一个实例，并提供了几个方法使你能用于向浏览器回送输
9. exception  
针对错误网页，未捕捉的例外

#### JSP dynamic INCLUDE and static INCLUDE
* 动态INCLUDE  
用jsp:include动作实现 <jsp:include page="included.jsp" flush="true" />它总是会检查所含文件中的变化，适合用于包含动态页面，并且可以带参数。
* 静态INCLUDE  
用include伪码实现,定不会检查所含文件的变化，适用于包含静态页面<%@ include file="included.htm" %>

#### JSP common directives
```html
<%@page language="java" contenType="text/html;charset=gb2312" session="true" buffer="64kb" autoFlush="true" isThreadSafe="true" info="text" errorPage="error.jsp" isErrorPage="true" isELIgnored="true" pageEncoding="gb2312" import="java.sql.*" %>
<!-- isErrorPage(是否能使用Exception对象)，isELIgnored(是否忽略EL表达式) -->
<%@include file="filename"%>
<%@taglib prefix="c" uri="http://......"%>
```

#### JSP "commands"
JSP 共有以下6种基本动作:  
1. jsp:include  
在页面被请求的时候引入一个文件
2. jsp:useBean  
寻找或者实例化一个JavaBean
3. jsp:setProperty  
设置JavaBean的属性
4. jsp:getProperty  
输出某个JavaBean的属性
5. jsp:forward  
把请求转到一个新的页面
6. jsp:plugin  
根据浏览器类型为Java插件生成OBJECT或EMBED标记。


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

##### ArrayList vs Vector vs LinkedList
1. ArrayList  
    1. 数组方式存储数据, 索引数据快而插入数据慢  
    2. 当元素超过它的初始大小时,只增加50%的大小，有利于节约内存空间。  
2. Vector  
    1. 数组方式存储数据  
    2. 线程安全, 通常性能上较ArrayList差
    3. 当元素超过它的初始大小时,Vector会将它的容量翻倍 
    4. `Vector不进行边界检查`
3. LinkedList  
使用双向链表实现存储，按序号索引数据需要进行前向或后向遍历，但是插入数据时只需要记录本项的前后项即可，所以插入速度较快。  
LinkedList提供额外的get，remove，insert方法在LinkedList的首部或尾部。这些操作使LinkedList可被用作堆栈（stack），队列（queue）或双向队列（deque）

##### HashMap vs HashTable vs ConcurrentHashMap


1. HashMap  
Hash table based implementation of the Map interface. This implementation provides all of the optional map operations, and permits null values and the null key. (The HashMap class is roughly equivalent to Hashtable, except that it is unsynchronized and permits nulls.)  
An instance of HashMap has two parameters that affect its performance: `initial capacity` and `load factor`. The capacity is the number of buckets in the hash table, and the initial capacity is simply the capacity at the time the hash table is created. The load factor is a measure of how full the hash table is allowed to get before its capacity is automatically increased. When the number of entries in the hash table exceeds the product of the load factor and the current capacity, the hash table is rehashed (that is, internal data structures are rebuilt) so that the hash table has approximately `twice the number of buckets`.  
HashMap允许将null作为一个entry的key或者value，而Hashtable不允许
2. HashTable  
    1. thread safe  
    2. load factor  
    比如,Hashtable缺省的初始大小为101,载入因子为0.75,即如果其中的元素个数超过75个,它就必须增加大小并重新组织元素，所以,如果你 知道在创建一个新的Hashtable对象时就知道元素的确切数目如为110,那么,就应将其初始大小设为110/0.75=148,这样,就可以避免重 新组织内存并增加大小。  
    This class implements a hashtable, which maps keys to values. `Any non-null object can be used as a key or as a value`  
    An instance of Hashtable has two parameters that affect its performance: initial capacity and load factor.   
    Generally, the default load factor (.75) offers a good tradeoff between time and space costs.Higher values decrease the space overhead but increase the time cost to look up an entry (which is reflected in most Hashtable operations, including get and put).  
    按照散列函数的定义，如果两个对象相同，即obj1.equals(obj2)=true，则它们的hashCode必须相同，但如果两个对象不同，则它们的hashCode不一定不同，如果两个不同对象的hashCode相同，这种现象称为冲突，冲突会导致操作哈希表的时间开销增大
3. ConcurrentHashMap    
    1. lock striping  
    ConcurrentHashMap is a hash-based Map like HashMap, but it uses an entirely different locking strategy that offers better concurrency and scalability. Instead of synchronizing every method on a common lock, restricting access to a single thread at a time, it uses a finer-grained locking mechanism called lock striping to allow a greater degree of shared access. `Arbitrarily many reading threads can access the map concurrently`, `readers can access the map concurrently with writers`, and `a limited number of writers can modify the map concurrently`. The result is far higher throughput under concurrent access, with little performance penalty for single-threaded access.  
    ConcurrentHashMap将hash表分为16个桶（默认值），诸如get,put,remove等常用操作只锁当前需要用到的桶。试想，原来只能一个线程进入，现在却能同时16个写线程进入（写线程才需要锁定，而读线程几乎不受限制，），并发性的提升是显而易见的。  
    The allowed concurrency among update operations is guided by the optional concurrency Level constructor argument (default 16), which is used as a hint for internal sizing. The table is internally partitioned to try to permit the indicated number of concurrent updates without contention. Also, resizing this or any other kind of hash table is a relatively slow operation, so, when possible, it is a good idea to provide estimates of expected table sizes in constructors.
    2. weakly consistent iterator  
    ConcurrentHashMap, along with the other concurrent collections, further improve on the synchronized collection classes by providing iterators that do not throw ConcurrentModificationException, thus eliminating the need to lock the collection during iteration. The iterators returned by ConcurrentHashMap are weakly consistent instead of fail-fast. A weakly consistent iterator can `tolerate concurrent modification`, traverses elements as they existed when the iterator was constructed, and `may (but is not guaranteed to) reflect modifications to the collection after the construction of the iterator.`  
    我们称为弱一致迭代器。在这种迭代方式中，当iterator被创建后集合再发生改变就不再是抛出 ConcurrentModificationException，取而代之的是在改变时new新的数据从而不影响原有的数据，iterator完成后再将头指针替换为新的数据，这样iterator线程可以使用原来老的数据，而写线程也可以并发的完成改变
    3. semantics of methods that operate on the entire Map are weakened  
    As with all improvements, there are still a few tradeoffs. The semantics of methods that operate on the entire Map, such as size and isEmpty, have been slightly weakened to reflect the concurrent nature of the collection. Since the result of size could be out of date by the time it is computed, it is really only an estimate, so size is allowed to return an approximation instead of an exact count.  
    While at first this may seem disturbing, in reality methods like size and isEmpty are far less useful in concurrent environments because these quantities are moving targets. So the requirements for these operations were weakened to enable performance optimizations for the most important operations, primarily get, put, containsKey, and remove.  
    4. no client side locking  
    The one feature offered by the synchronized Map implementations but not by ConcurrentHashMap is the ability to lock the map for exclusive access. With Hashtable and synchronizedMap, acquiring the Map lock prevents any other thread from accessing it. This might be necessary in unusual cases such as adding several mappings atomically, or iterating the Map several times and needing to see the same elements in the same order. On the whole, though, this is a reasonable tradeoff: concurrent collections should be expected to change their contents continuously.  
    Because it has so many advantages and so few disadvantages compared to Hashtable or synchronizedMap, replacing synchronized Map implementations with ConcurrentHashMap in most cases results only in better scalability. Only if your application needs to lock the map for exclusive access[3] is ConcurrentHashMap not an appropriate drop-in replacement.  
    [3] Or if you are relying on the synchronization side effects of the synchronizedMap implementations.  

### Gabage Collector

__Root Set__  
大多数垃圾回收算法使用了根集(RootSet)这个概念；所谓根集就量正在执行的Java程序可以访问的引用变量的集合(包括局部变量、参数、类变量)，程序可以使用引用变量访问对象的属性和调用对象的方法。垃圾收集首选需要确定从根开始哪些是可达的和哪些是不可达的，从根集可达的对象都是活动对象，它们不能作为垃圾被回收，这也包括从根集间接可达的对象。而根集通过任意路径不可达的对象符合垃圾收集的条件，应该被回收。

GC首先要判断该对象是否是时候可以收集, 常用的方法2种  
1. 引用计数  
引用计数存储对特定对象的所有引用数，也就是说，当应用程序创建引用以及引用超出范围时，JVM必须适当增减引用数。当某对象的引用数为0时，便可以进行垃圾收集。  
基于引用计数器的垃圾收集器运行较快，不会长时间中断程序执行，适宜地必须 实时运行的程序。但引用计数器增加了程序执行的开销，因为每次对象赋给新的变量，计数器加1，而每次现有对象出了作用域生，计数器减1。  

2. Tracing算法   
Tracing算法是为了解决引用计数法的问题而提出，它使用了根集的概念。基于tracing算法的垃圾收集器从根集开始扫描，识别出哪些对象可达，哪些对象不可达，并用某种方式标记可达对象，例如对每个可达对象设置一个或多个位。

__垃圾回收算法:__  
1. 标记－清除收集器  
这种收集器首先遍历对象图并标记可到达的对象，然后扫描堆栈以寻找未标记对象并释放它们的内存。这种收集器一般使用单线程工作并停止其他操作。 

2. 标记－压缩收集器  
有时也叫标记－清除－压缩收集器，与标记－清除收集器有相同的标记阶段。在第二阶段，则把标记对象复制到堆栈的新域中以便压缩堆栈。这种收集器也停止其他操作。  
在基于Compacting算法的收集器的实现中，一般增加句柄和句柄表。

3. 复制收集器  
这种收集器将堆栈分为两个域，常称为半空间。每次仅使用一半的空间，JVM生成的新对象则放在另一半空间中。gc运行时，它把可到达对象复制到另一半空间，从而压缩了堆栈。这种方法适用于短生存期的对象，持续复制长生存期的对象则导致效率降低。 

4. 分代收集器  
复制垃圾收集器的一个缺陷是收集器必须复制所有的活动对象，这增加了程序等待时间，这是coping算法低效的原因。在程序设计中有这样的规律：多数对象存在的时间比较短，少数的存在时间比较长。因此，generation算法将堆分成两个或多个，每个子堆作为对象的一代(generation)。由于多数对象存在的时间比较短，随着程序丢弃不使用的对象，垃圾收集器将从最年轻的子堆中收集这些对象。在分代式的垃圾收集器运行后，上次运行存活下来的对象移到下一最高代的子堆中，由于老一代的子堆不会经常被回收，因而节省了时间

### Web Service

Web Service是基于网络的、分布式的模块化组件，它执行特定的任务，遵守具体的技术规范，这些规范使得Web Service能与其他兼容的组件进行互操作。

WSDL是一种 XML 格式，用于将网络服务描述为一组端点，这些端点对包含面向文档信息或面向过程信息的消息进行操作。这种格式首先对操作和消息进行抽象描述，然后将其绑定到具体的网络协议和消息格式上以定义端点。相关的具体端点即组合成为抽象端点（服务）。

WebService使用WSDL来描述自身，调用者通过WSDL即可以了解WebService的调用方法。  
因为这些特征，WEBService具有了两个很大的优势：一是提供了方便的交互，二是实现松散联接。

**优势**  
1. 跨平台。
2. SOAP协议是基于XML和HTTP这些业界的标准的，得到了所有的重要公司的支持。
3. 由于使用了SOAP，数据是以ASCII文本的方式而非二进制传输，调试很方便；并且由于这样，它的数据容易通过防火墙，不需要防火墙为了程序而单独开一个“漏洞”。
4. 此外，WebService实现的技术难度要比CORBA和DCOM小得多。
5. 要实现B2B集成，EDI比较完善与比较复杂；而用WebService则可以低成本的实现，小公司也可以用上。
6. 在C/S的程序中，WebService可以实现网页无整体刷新的与服务器打交道并取数。??

**缺点**  
1. WebService使用了XML对数据封装，会造成大量的数据要在网络中传输。
2. WebService规范没有规定任何与实现相关的细节，包括对象模型、编程语言，这一点，它不如CORBA。??


#### SOAP
SOAP协议（Simple Object Access Protocal,简单对象访问协议）,它是一个用于分散和分布式环境下网络信息交换的基于XML的通讯协议。在此协议下，软件组件或应用程序能够通过标准的HTTP协议进行通讯。它的设计目标就是简单性和扩展性，这有助于大量异构程序和平台之间的互操作性，从而使存在的应用程序能够被广泛的用户访问。

#### WS Related Techniques

**JAXP(Java API for XML Parsing)** 定义了在Java中使用DOM, SAX, XSLT的通用的接口。这样在你的程序中你只要使用这些通用的接口，当你需要改变具体的实现时候也不需要修改代码。

**JAXM(Java API for XML Messaging)** 是为SOAP通信提供访问方法和传输机制的API  
　
**WSDL**是一种 XML 格式，用于将网络服务描述为一组端点，这些端点对包含面向文档信息或面向过程信息的消息进行操作。这种格式首先对操作和消息进行抽象描述，然后将其绑定到具体的网络协议和消息格式上以定义端点。相关的具体端点即组合成为抽象端点（服务）

**UDDI**是一种规范，Universal Description Discovery and Integration, 它主要提供基于Web Service的注册和发现机制，为Web服务提供三个重要的技术支持：
1. 标准、透明、专门描述Web服务的机制
2. 调用Web服务的机制
3. 可以访问的Web服务注册中心

##### RMI vs IIOP

分布式计算系统要求运行在不同地址空间不同主机上的对象互相调用。各种分布式系统都有自己的调用协议，如CORBA的IIOP(Internet InterORB Protocol), MTS的DCOM。那么EJB组件呢？ Socket, PRC and RMI

在Java里提供了完整的Socket通讯接口，但Socket要求客户端和服务端必须进行**应用级协议**的编码交换数据，采用sockets是非常麻烦的。 

一个代替Socket的协议是RPC(Remote Procedure Call), 它抽象出了通讯接口用于过程调用，使得编程者调用一个远程过程和调用本地过程同样方便。RPC 系统采用XDR(外部数据表示)来编码远程调用的参数和返回值。 

**但RPC 并不支持对象**

RPC也要求串行化参数和返回数值数据，但由于没有涉及对象，情况比较简单。

而EJB构造的是完全面向对象的分布式系统，所以，**面向对象的远程调用RMI**(Remote Method Invocation)成为必然选择。采用RMI，调用远程对象和调用本地对象同样方便。RMI采用JRMP(Java Remote Method Protocol)通讯协议，是构建在TCP/IP协议上的一种远程调用方法。 
RMI定义了一组远程接口，可以用于生成远程对象。客户机可以象调用本地对象的方法一样用相同的语法调用远程对象。RMI API提供的类和方法可以处理所有访问远程方法的基础通信和参数引用要求的串行化。 

RPC和RMI之间的一个重要差别是RPC用快速而不够可靠的UDP协议，RMI用低速而可靠的TCP/IP协议。

###### RMI调用机制 
RMI 采用stubs 和 skeletons 来进行远程对象(remote object)的通讯。stub 充当远程对象的客户端代理，有着和远程对象相同的远程接口，远程对象的调用实际是通过调用该对象的客户端代理对象stub来完成的。 每个远程对象都包含一个代理对象stub，当运行在本地Java虚拟机上的程序调用运行在远程Java虚拟机上的对象方法时，它首先在本地创建该对象的代理对象stub, 然后调用代理对象上匹配的方法，代理对象会作如下工作： 

**Stub Processing flow**  
* 与远程对象所在的虚拟机建立连接 
* 打包(marshal)参数并发送到远程虚拟机 
* 等待执行结果 
* 解包(unmarshal)返回值或返回的错误 
* 返回调用结果给调用程序 

stub 对象负责调用参数和返回值的流化(serialization)、打包解包，以及网络层的通讯过程。 


每一个远程对象同时也包含一个skeleton对象，skeleton运行在远程对象所在的虚拟机上，接受来自stub对象的调用。当skeleton接收到来自stub对象的调用请求后，skeleton会作如下工作： 

**Skeleton processing flow**  
* 解包stub传来的参数 
* 调用远程对象匹配的方法 
* 打包返回值或错误发送给stub对象 

远程对象的stub和skeleton对象都是由`rmic编译工具`产生的

###### CORBA（Common Object Request Broker Architecture）
是OMG的Object Management Architecture（对象管理结构），它是面向对象的分布式系统建立所依据的标准。CORBA被设计成一个能供所有编程语言使用的一个开放性说明，就是说一个机器上的Java客户可以要求另一个用SmallTalk或C++的机器服务。正是由于这种语言的独立性使得CORBA这么灵活和吸引人。为了适应语言独立性，CORBA采用了非常通用的标准作为其接口。在不同的语言中，远程调用、签名和对象的引入有各自不同的定义，所以CORBA必须尽可能的中立和开放。正是这种通用性是CORBA的一个弱点。当开发人员都采用CORBA时，他们要用一种新的标准定义语言接口，它`要求开发者学习新的编程接口`，从而减小了远程模型的透明性。

###### IIOP(Internet Inter-ORB Protocol)
是CORBA的通讯协议。CORBA是由OMG(Object Management Group)组织定义的一种分布式组件标准，通过和各种编程语言相匹配的`IDL(Interface Definition Language)`，CORBA可以作到和语言无关，也就是说，用不同编程语言编写的CORBA对象可以互相调用。

它是一个用于CORBA 2.0及兼容平台上的协议。这个协议的最初阶段是要建立以下几个组件部分：一个IIOP到HTTP的网关，使用这个网关可以让CORBA客户访问WWW资源；一个HTTP到IIOP的网关，通过这个网关可以访问CORBA资源；一个为IIOP和HTTP提供资源的服务器，一个能够将IIOP作为可识别协议的浏览器。

###### JavaIDL
定义了Java语言到CORBA之间的匹配，通过JavaIDL，用Java语言编写的应用程序可以和任何CORBA对象通讯。 

###### RMI-IIOP
结合了RMI的易用性和CORBA/IIOP的语言无关性，通过RMI-IIOP，RMI对象可以采用IIOP协议和CORBA对象通讯。RMI-IIOP对RMI的调用参数作了一些很轻微的限制，在调用CORBA对象时，必须遵循这些限制。JDK1.3已经提供对RMI-IIOP的支持。 

##### Different ways of implement web service

有两种方式:  
* 契约先行（也称为自顶向下，contract-first）方式：通过XSD和WSDL来定义contract，然后根据contract生成Java类
* 契约后行（也称为自底向上，contract-last）方式：先定义Java类，然后生成约定，也就是从Java类得到WSDL文件。

__上面两种方式各有什么优缺点吗？你更推荐哪种？__  

ways|coupling client side with server side|  learning curve
-----------|--------------------------------------|----------------
contract-first| no | long
contract-last| yes | short

### JMS
#### Message Broker
[For more information][jms-message-broker-1]
Message broker is an intermediary program module that translates a message from the formal messaging protocol of the sender to the formal messaging protocol of the receiver. Message brokers are elements in telecommunication networks where software applications communicate by exchanging formally-defined messages. Message brokers are a building block of Message oriented middleware.

A message broker is an architectural pattern for message **validation, transformation and routing**.[1] It mediates communication amongst applications, minimizing the mutual awareness that applications should have of each other in order to be able to exchange messages, effectively implementing **decoupling**.
The purpose of a broker is to take incoming messages from applications and perform some action on them. The following are examples of actions that might be taken in by the broker:
* Route messages to one or more of many destinations
* Transform messages to an alternative representation
* Perform message aggregation, decomposing messages into multiple messages and sending them to their destination, then recomposing the responses into one message to return to the user
* Interact with an external repository to augment a message or store it
* Invoke Web services to retrieve data
* Respond to events or errors
* Provide content and topic-based message routing using the publish–subscribe pattern

Message broker transforms messages from one format to another (e.g. JMS to MQ) or routes a message to another place/broker/queue depending on content or topic; where as MQ is the queue the message ending up on, where it's held until it's consumed by some other app. 

#### AMQP(Advanced Message Queuing Protocol)

高级消息队列协议

AMQP，一个提供`统一消息服务`的应用层标准高级消息队列协议,是`应用层协议的一个开放标准`,为面向消息的中间件设计。基于此协议的客户端与消息中间件可传递消息，并`不受客户端/中间件不同产品，不同的开发语言等条件的限制`。Erlang中的实现有 RabbitMQ等。

AMQP的原始用途只是为金融界提供一个可以彼此协作的消息协议，而现在的目标则是为通用消息队列架构提供通用构建工具。因此，`面向消息的中间件（MOM）`系统，例如发布/订阅队列，没有作为基本元素实现。反而`通过发送简化的AMQ实体`，用户被赋予了构建例如这些实体的能力。这些实体也是规范的一部分，形成了在线路层协议顶端的一个层级：`AMQP模型`。`这个模型统一了消息模式，诸如之前提到的发布/订阅，队列，事务以及流数据，并且添加了额外的特性，例如更易于扩展，基于内容的路由。`

当然这种降低耦合的机制是基于与上层产品，语言无关的协议。AMQP协议是一种`二进制协议`，提供客户端应用与消息中间件之间`异步、安全、高效地交互`。

从整体来看，AMQP协议可划分为三层:  
![jms_amqp_1]

上面是对AMQP协议的大致说明。下面会以我们对消息服务的需求来理解AMQP所提供的域模型。消息中间件的主要功能是`消息的路由(Routing)和缓存(Buffering)`。在AMQP中提供类似功能的两种域模型：`Exchange` 和 `Message queue`

Exchange接收消息生产者(Message Producer)发送的消息根据不同的路由算法将消息发送往Message queue。Message queue会在消息不能被正常消费时缓存这些消息，具体的缓存策略由实现者决定，当message queue与消息消费者(Message consumer)之间的连接通畅时，Message queue有将消息转发到consumer的责任。

一个broker中会存在多个Message queue，Exchange怎样知道它要把消息发送到哪个Message queue中去呢? 这就是上图中所展示`Binding`的作用。Message queue的创建是由client application控制的，在创建Message queue后需要确定它来接收并保存哪个Exchange路由的结果。Binding是用来关联Exchange与Message queue的域模型。Client application控制Exchange与某个特定Message queue关联，并将这个queue接受哪种消息的条件绑定到Exchange，这个条件也叫Binding key或是 Criteria。

在与多个Message queue关联后，Exchange中就会存在一个路由表，这个表中存储着每个Message queue所需要消息的限制条件。Exchange就会检查它接受到的每个Message的Header及Body信息，来决定将Message路由到哪个queue中去。Message的Header中应该有个属性叫Routing Key，它由Message发送者产生，提供给Exchange路由这条Message的标准。Exchange根据不同路由算法有不同有Exchange Type。比如有Direct类似，需要Binding key等于Routing key；也有Binding key与Routing key符合一个模式关系；也有根据Message包含的某些属性来判断。一些基础的路由算法由AMQP所提供，client application也可以自定义各种自己的`扩展路由算法`。


#### JMS Misc

##### Relations between acknowledgement, session, transaction

**Acknowledgement mode:**  
* DUPS_OK_ACKNOWLEDGE - Automatic but a delayed acknowledgement of messages by the session that may result in duplicate messages if JMS provider fails.
* AUTO_ACKNOWLEDGE - Session automatically acknowledges when a message is delivered to application
* CLIENT_ACKNOWLEDGE - Client application explicitly acknowledges messages.

For your requirement I think you can choose CLIENT_ACKNOWLEDGE as it allows your application to explicitly acknowledge messages. But you must note that in some JMS providers, acknowledging a consumed message automatically acknowledges the receipt of all messages that have been delivered by its session. However some JMS providers do implement a per message acknowledgement.

The other option you have is to use a transacted session where acknowledge mode has no effect. In a transacted session, messages are removed from a queue only when application calls commit. If the session calls rollback or ends without calling commit, all messages that were delivered to an application since the previous commit call will reappear in the queue.

### Java SE

#### Instrumentation

利用 java.lang.instrument 做动态 Instrumentation 是 Java SE 5 的新特性，使用 Instrumentation，开发者可以构建一个独立于应用程序的代理程序（Agent），用来监测和协助运行在 JVM 上的程序，甚至能够替换和修改某些类的定义。这样的特性实际上提供了一种虚拟机级别支持的 AOP 实现方式，使得开发者无需对 JDK 做任何升级和改动，就可以实现某些 AOP 的功能了。

在 Java SE 6 里面，instrumentation 包被赋予了更强大的功能：
* 运行时的 instrument
* 本地代码（native code）instrument
* 动态改变 classpath 等等

在 Java SE6 里面，最大的改变使运行时的 Instrumentation 成为可能。在 Java SE 5 中，Instrument 要求在运行前利用命令行参数或者系统参数来设置代理类，在实际的运行之中，虚拟机在初始化之时（在绝大多数的 Java 类库被载入之前），instrumentation 的设置已经启动，并在虚拟机中设置了回调函数，检测特定类的加载情况，并完成实际工作。但是在实际的很多的情况下，我们没有办法在虚拟机启动之时就为其设定代理，这样实际上限制了 instrument 的应用。而 Java SE 6 的新特性改变了这种情况，通过 Java Tool API 中的 attach 方式，我们可以很方便地在运行过程中动态地设置加载代理类，以达到 instrumentation 的目的。

另外，对 native 的 Instrumentation 也是 Java SE 6 的一个崭新的功能，这使以前无法完成的功能 —— 对 native 接口的 instrumentation 可以在 Java SE 6 中，通过一个或者一系列的 prefix 添加而得以完成。

最后，Java SE 6 里的 Instrumentation 也增加了动态添加 class path 的功能。

有两种方式来获取Instrumentation接口实例：  
* 命令行参数. 启动JVM时指定agent类。这种方式，Instrumentation的实例通过agent class的premain方法被传入。
* 运行时. JVM提供一种当JVM启动完成后开启agent机制。这种情况下，Instrumention实例通过agent代码中的的agentmain传入。

java agent 在JDK package specification中解释：一个agent 是被作为Jar 文件形式来部署的。在Jar文件中manifest中指定哪个类作为agent类。

__Example:__  

1. 命令行方法  
```java
import java.lang.instrument.ClassFileTransformer;
public class PeopleClassFileTransformer implements ClassFileTransformer {
    @Override
    public byte[] transform(ClassLoader loader, String className, Class<?> classBeingRedefined, ProtectionDomain protectionDomain, byte[] classfileBuffer) throws IllegalClassFormatException {
        System.out.println("load class:"+className);
        if("com.yao.intrumentation.People".equals(className)){
            try {
                //通过javassist修改sayHello方法字节码
                CtClass ctClass= ClassPool.getDefault().get(className.replace('/','.'));
                CtMethod sayHelloMethod=ctClass.getDeclaredMethod("sayHello");
                sayHelloMethod.insertBefore("System.out.println(\"before sayHello----\");");
                sayHelloMethod.insertAfter("System.out.println(\"after sayHello----\");");
                return ctClass.toBytecode();
            } catch (NotFoundException e) {
                e.printStackTrace();
            } catch (CannotCompileException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return classfileBuffer;
    }
}

// to-be-agent codes
public class People {

    public void sayHello(){
        System.out.println("hello !!!!");
    }
}

// Agent class
public class MyAgent {
    public static void premain(String agentArgs,Instrumentation inst){
        //PeopleClassFileTransformer
        inst.addTransformer(new PeopleClassFileTransformer());
    }
}
```

* in META-INF/MANIFEST
```java
Premain-Class: com.yao.intrumentation.MyAgent
```

* pack PeopleClassFileTransformer and MyAgent into a separate jar file, myagent.jar
jar -cvfm myagent.jar META-INF/MANIFEST.MF *

* test class, launch it with VM parameters "-javaagent:/Users/yao/workspace/private/JavaSPI/target/classes/myagent.jar"
```java
public class TestMain {
    public static void main(String[]args){
        People people=new People();
        people.sayHello();
    }
}
```

result is like:  
load class:java/lang/invoke/MethodHandleImpl
load class:java/lang/invoke/MethodHandleImpl$1
load class:java/lang/invoke/MethodHandleImpl$2
load class:java/util/function/Function
load class:java/lang/invoke/MethodHandleImpl$3
load class:java/lang/invoke/MethodHandleImpl$4
load class:java/lang/ClassValue
load class:java/lang/ClassValue$Entry
load class:java/lang/ClassValue$Identity
load class:java/lang/ClassValue$Version
load class:java/lang/invoke/MemberName$Factory
load class:java/lang/invoke/MethodHandleStatics
load class:java/lang/invoke/MethodHandleStatics$1
load class:sun/misc/PostVMInitHook
load class:sun/launcher/LauncherHelper
load class:com/yao/intrumentation/TestMain
load class:sun/launcher/LauncherHelper$FXHelper
load class:java/lang/Class$MethodArray
load class:java/lang/Void
load class:com/yao/intrumentation/People
before sayHello----
hello !!!!
after sayHello----
load class:java/lang/Shutdown
load class:java/lang/Shutdown$Lock

2. 运行时方法

put agent class into a separate jar, similiar as the 1st way
```java
// agent class
public class MainAgent {
    public static void agentmain(String args, Instrumentation inst){
        Class[] classes = inst.getAllLoadedClasses();
        for(Class cls :classes){
            System.out.println(cls.getName());
        }

    }
}
// in META-INF/MANIFEST.MF
Agent-Class: com.yao.intrumentation.MainAgent
```

```java
// to-be-agent codes
public class RunningApp {
    public static void main(String[]args) throws InterruptedException {
        People people=new People();
        Thread.sleep(1000*1000);
    }
}

// test class
public class TestMainAgent {
    public static void main(String[]args) throws InterruptedException, IOException, AgentLoadException, AgentInitializationException, AttachNotSupportedException {
        VirtualMachine vm = VirtualMachine.attach(args[0]); //正在运行的java 程序 pid of RunningApp
        vm.loadAgent("/Users/yao/workspace/private/JavaSPI/target/classes/agentmain.jar");
        //刚刚编译好的agent jar 位置
    }
}

```

#### Java SE Misc

##### Java Hashcode

What’s the default implementation of hashcode, will hashcode change during runtime?  
PS: Memory address, will change. Need to go deeper.

In the mark & sweep algorithm, the objects are moved of course. But the running program doesn't contain refrences to the objects directly. The variable in the thread of execution contains a reference to an object which in turn contains a reference to the actual object (that the thread actually created). So during GC when the object is moved, the indirect reference is updated. 

----------       -----------      ----------------      -----------  
| Thread |------>|Reference|----->| Intermediate |----->|  Actual |    
|        |       |   Var   |      |   Reference  |      |  Object |  
----------       -----------      ----------------      -----------  

Object.hashcode() is a native method.  
public native int hashCode();  
That means it's implemented in platform specific code and is exposed as a native method. code for the same will be a compiled code and not available withing JDK

The method in java.lang.Object is declared as native, which means the implementation is provided by the JVM and may vary depending on your runtime environment.

##### differences between logic operator and condition operator
逻辑操作(&,|,^)与条件操作(&&,||)的区别  
1. 条件操作只能操作布尔型的,而逻辑操作不仅可以操作布尔型,而且可以操作数值型
2. 逻辑操作不会产生短路

##### Object#clone
Clone有缺省行为，super.clone();他负责产生正确大小的空间，并逐位复制。

##### String#intern

>public String intern()
>>Returns a canonical representation for the string object.  
A pool of strings, initially empty, is maintained privately by the class String.  
When the intern method is invoked, if the pool already contains a string equal to this String object as determined by the equals(Object) method, then the string from the pool is returned. Otherwise, this String object is added to the pool and a reference to this String object is returned.  
>>It follows that for any two strings s and t, s.intern() == t.intern() is true if and only if s.equals(t) is true.

Basically doing String.intern() on a series of strings will ensure that all strings having same contents share same memory. So if you have list of names where 'john' appears 1000 times, by interning you ensure only one 'john' is actually allocated memory.

This can be useful to reduce memory requirements of your program. But be aware that the cache is maintained by JVM in permanent memory pool which is usually limited in size compared to heap so you should not use intern if you don't have too many duplicate values.

On one hand, it is true that you can remove String duplicates by internalizing them. The problem is that the internalized strings go to the Permanent Generation, which is an area of the JVM that is reserved for non-user objects, like Classes, Methods and other internal JVM objects. The size of this area is limited, and is usually much smaller than the heap. `Calling intern() on a String has the effect of moving it out from the heap into the permanent generation`, and you risk running out of PermGen space.

`From JDK 7 (I mean in HotSpot), something has changed.` 

`In JDK 7, interned strings are no longer allocated in the permanent generation of the Java heap,` but are instead allocated in the main part of the Java heap (known as the young and old generations), along with the other objects created by the application. This change will result in more data residing in the main Java heap, and less data in the permanent generation, and thus may require heap sizes to be adjusted. Most applications will see only relatively small differences in heap usage due to this change, but larger applications that load many classes or make heavy use of the String.intern() method will see more significant differences.

常量池(constant pool)指的是在编译期被确定，并被保存在已编译的.class文件中的一些数据。它包括了关于类、方法、接口等中的常量，也包括字符串常量。

```java
String s0=”kvill”;   
String s1=”kvill”;   
String s2=”kv” + “ill”;   
System.out.println( s0==s1 );   // true 
System.out.println( s0==s2 );   // true

// 因为例子中的s0和s1中的”kvill”都是字符串常量，它们在编译期就被确定了，所以s0==s1为true；而”kv”和”ill”也都是字符串常量，当一个字符串由多个字符串常量连接而成时，它自己肯定也是字符串常量，所以s2也同样在编译期就被解析为一个字符串常量，所以s2也是常量池中”kvill”的一个引用。

// 用new String() 创建的字符串不是常量，不能在编译期就确定，所以new String() 创建的字符串不放入常量池中，它们有自己的地址空间。   

String s0=”kvill”;   
String s1=new String(”kvill”);   
String s2=”kv” + new String(“ill”);   
System.out.println( s0==s1 );   // false 
System.out.println( s0==s2 );   // false  
System.out.println( s1==s2 );   // false   


String s0= “kvill”;   
String s1=new String(”kvill”);   
String s2=new String(“kvill”);   
s1.intern();   
s2=s2.intern(); //把常量池中“kvill”的引用赋给s2   
System.out.println( s0==s1);                    // false
System.out.println( s0==s1.intern() );          // true  
System.out.println( s0==s2 );                   // true
```

##### Java I/O 
Class hierarchies of major classes.
![javase_io_hierarchy_1]  
![javase_io_hierarchy_2]  
![javase_io_hierarchy_3]  
![javase_io_hierarchy_4]  

##### Java Exception
![javase_exception_1]  

将派生于Error或者RuntimeException的异常称为unchecked异常，所有其他的异常成为checked异常

### Java EE

J2EE 是Sun公司提出的多层(multi-tiered),分布式(distributed),基于组件(component-base)的企业级应用模型 (enterpriese application model).在这样的一个应用系统中，可按照功能划分为不同的组件，这些组件又可在不同计算机上，并且处于相应的层次(tier)中。所属层次包括客户层(clietn tier)组件,web层和组件,Business层和组件,企业信息系统(EIS)层。

#### J2EE Design Pattern

![j2ee_core_design_pattern_1]

[For more information][j2ee_core_design_pattern_2]

Some common used patterns,

**Intercepting Filter** Facilitates preprocessing and post-processing of a request.

**Transfer Object** Carries data across a tier

**Data Access Object** Abstracts and encapsulates access to persistent store.

**Business Delegate** Encapsulates access to a business service.
 
**Session Façade** Encapsulates business-tier components and exposes a coarse-grained service to remote clients.

**Front Controller** You want a centralized access point for presentation-tier request handling. 

**View Helper** You want to separate a view from its processing logic.
Use Views to encapsulate formatting code and Helpers to encapsulate view-processing logic. A View delegates its processing responsibilities to its helper classes, `implemented as POJOs, custom tags, or tag files`. Helpers serve as adapters between the view and the model, and perform processing related to formatting logic, such as generating an HTML table.

### EJB

EJB包括Session Bean、Entity Bean、Message Driven Bean，基于JNDI、RMI、JTA等技术实现。

Session Bean又可分为有状态(stateful)和无状态(stateless)两种  
Entity bean可分为bean管理的持续性(bmp)和容器管理的持续性(cmp)两种

__3 Components:__  
* remote(local)接口
* home(localhome)接口
* bean类 

remote接口定义了业务方法，用于ejb客户端调用业务方法.   
home接口是ejb工厂用于创建和移除查找ejb实例 

__Typical calling flow:__  
* 设置jndi服务工厂以及jndi服务地址系统属性，查找home接口
* 从home接口调用create方法创建remote接口
* 通过remote接口调用其业务方法

#### EJB Misc

##### Differences between StatefulBean and StatelessBean
这两种的 Session Bean都可以将系统逻辑放在method之中执行，
不同的是 Stateful Session Bean 可以`记录呼叫者的状态`，因此通常来说，一个使用者会有一个相对应的 Stateful Session Bean 的实体。

Stateless Session Bean 虽然也是逻辑组件，但是他却不负责记录使用者状态，也就是说当使用者呼叫 Stateless Session Bean 的时候，EJB Container 并不会找寻特定的 Stateless Session Bean 的实体来执行这个 method。换言之，很可能数个使用者在执行某个 Stateless Session Bean 的 methods 时，会是同一个 Bean 的 Instance 在执行。

从内存方面来看， Stateful Session Bean 与 Stateless Session Bean 比较， Stateful Session Bean 会消耗 J2EE Server 较多的内存，然而 Stateful Session Bean 的优势却在于他可以维持使用者的状态。

对于stateless session bean、entity bean、message driven bean一般存在缓冲池管理，而对于entity bean和statefull session bean存在cache管理，通常包含创建实例，设置上下文、创建ejb object(create)、业务方法调用、remove等过程，对于存在缓冲池管理的bean，在create之后实例并不从内存清除，而是采用缓冲池调度机制不断重用实例，而对于存在cache管理的bean则通过激活和去激活机制保持bean的状态并限制内存中实例数量。

以Stateful Session Bean 为例：其Cache大小决定了内存中可以同时存在的Bean实例的数量，根据MRU或NRU算法，实例在激活和去激活状态之间迁移，激活机制是当客户端调用某个EJB实例业务方法时，如果对应EJB Object发现自己没有绑定对应的Bean实例则从其去激活Bean存储中（通过序列化机制存储实例）回复（激活）此实例。状态变迁前会调用对应的 ejbActivate和ejbPassivate方法。

##### EJB lifecycle and Transaction Management

sessionbean：  
stateless session bean 的生命周期是由容器决定的，当客户机发出请求要建立一个bean的实例时，ejb容器不一定要创建一个新的bean的实例供客户机调用，而是随便找一个现有的实例提供给客户机。  

当客户机第一次调用一个stateful session bean 时，容器必须立即在服务器中创建一个新的bean实例，并关联到客户机上，以后此客户机调用stateful session bean 的方法时容器会把调用分派到与此客户机相关联的bean实例。 

entity beans能存活相对较长的时间，并且状态是持续的。只要数据库中的数据存在，entity beans就一直存活。而不是按照应用程序或者服务进程来说的。即使ejb容器崩溃了，entity beans也是存活的。entity beans生命周期能够被容器或者 beans自己管理。

**ejb通过以下技术管理事务**  
对象管理组织(omg)的对象事务服务(ots)，SUN microsystems的transaction service(jts)、java transaction api(jta)，开发组(x/open)的xa接口。

##### EJB roles and components
一个完整的基于ejb的分布式计算结构由六个角色组成，这六个角色可以由不同的开发商提供，每个角色所作的工作必须遵循sun公司提供的ejb规范，以保证彼此之间的兼容性。这六个角色分别是`ejb组件开发者(enterprise bean provider)`, `ejb 容器提供者(ejb container provider)`, `ejb 服务器提供者(ejb server provider)`, `应用组合者(application assembler)`, `部署者(deployer)`, `系统管理员(system administrator)`

__3 Components:__  
* remote(local)接口
* home(localhome)接口
* bean类 

##### Aspect fuctions provided by EJB Container

主要提供生命周期管理、代码产生、持续性管理、安全、事务管理、锁和并发行管理等服务。 

Messaging, Directory, Logging, Context

##### Prohabited functions by EJB specification

1. 不能操作线程和线程api(线程api指非线程对象的方法如notify,wait等)。
2. 不能操作awt
3. 不能实现服务器功能
4. 不能对静态属性存取
5. 不能使用io操作直接存取文件系统
6. 不能加载本地库
7. 不能将this作为变量和返回
8. 不能循环调用。 

### Miscellaneous

#### Terminologies

##### JAF(JavaBeans Activation Framework)
JavaBeans Activation Framework (JAF) is a standard extension to the Java platform that lets you take advantage of standard services to: determine the type of an arbitrary piece of data; encapsulate access to it; discover the operations available on it; and instantiate the appropriate bean to perform the operation(s).

##### JAT(Java Application Template)

JAT is an easy to extend Java Open Source framework. It supplies modular and flexible basic functionality to develop Java applications, improving application start-up time. Jat Portal is an enhanced version for building a complete Web Application.
[For more information][misc-terminologies-jat-1]

JAT is a flexible Java base-framework which can be easily extended to improve projects start-up time. JAT allows to build Web applications (J2EE) or standalone application (server, batch, etc.). JAT supplies the main basic functionalities of any Java application, such as: 

* High Business Object abstraction 
* Integration facilities (provided for DBMS, LDAP and open to any software product) 
* Authentication and user privileges management 
* MVC pattern implementation (with privileges management and page flow control) 
* HTML layout structure management (header, footer, menu, etc.) 
* HTML dynamic contents and facilities (form, report, paging) 
* Logging feautures 
* Help on-line utility 
* High configuration of all described functionalities 
* Administration and configuration GUI


#### Connection Pooling

Frequently used connection pool, 
* BasicDataSource
* DBPool (used in GMARRS)

##### BasicDataSource

##### DBPool
[For more information][misc-connection-pooling-1]


#### class loader
[For more information][misc_class_loader_1]

__Java默认提供的三个ClassLoader__
1. BootStrap ClassLoader：称为启动类加载器，是Java类加载层次中最顶层的类加载器，负责加载JDK中的核心类库，如：rt.jar、resources.jar、charsets.jar等，可通过如下程序获得该类加载器从哪些地方加载了相关的jar或class文件
2. Extension ClassLoader：称为扩展类加载器，负责加载Java的扩展类库，默认加载JAVA_HOME/jre/lib/ext/目下的所有jar。
3. App ClassLoader(System ClassLoader)：称为系统类加载器，负责加载应用程序classpath目录下的所有jar和class文件。

注意： 除了Java默认提供的三个ClassLoader之外，用户还可以根据需要定义自已的ClassLoader，而这些自定义的ClassLoader都必须继承自java.lang.ClassLoader类，也包括Java提供的另外二个ClassLoader（Extension ClassLoader和App ClassLoader）在内，但是Bootstrap ClassLoader不继承自ClassLoader，因为它不是一个普通的Java类，底层由C++编写，已嵌入到了JVM内核当中，当JVM启动后，Bootstrap ClassLoader也随着启动，负责加载完核心类库后，并构造Extension ClassLoader和App ClassLoader类加载器。

__ClassLoader加载类的原理__
1. 原理介绍  
ClassLoader使用的是`双亲委托模型`来搜索类的，每个ClassLoader实例都有一个父类加载器的引用（不是继承的关系，是一个包含的关系），虚拟机内置的类加载器（Bootstrap ClassLoader）本身没有父类加载器，但可以用作其它ClassLoader实例的的父类加载器。当一个ClassLoader实例需要加载某个类时，它会试图亲自搜索某个类之前，先把这个任务委托给它的父类加载器，这个过程是由上至下依次检查的，首先由最顶层的类加载器Bootstrap ClassLoader试图加载，如果没加载到，则把任务转交给Extension ClassLoader试图加载，如果也没加载到，则转交给App ClassLoader 进行加载，如果它也没有加载得到的话，则返回给委托的发起者，由它到指定的文件系统或网络等URL中加载该类。如果它们都没有加载到这个类时，则抛出ClassNotFoundException异常。否则将这个找到的类生成一个类的定义，并将它加载到内存当中，最后返回这个类在内存中的Class实例对象

2. 为什么要使用双亲委托这种模型呢？  
因为这样可以避免重复加载，当父亲已经加载了该类的时候，就没有必要子ClassLoader再加载一次。考虑到安全因素，我们试想一下，如果不使用这种委托模式，那我们就可以随时使用自定义的String来动态替代java核心api中定义的类型，这样会存在非常大的安全隐患，而双亲委托的方式，就可以避免这种情况，因为String已经在启动时就被引导类加载器（Bootstrcp ClassLoader）加载，所以用户自定义的ClassLoader永远也无法加载一个自己写的String，除非你改变JDK中ClassLoader搜索类的默认算法。

3. 但是JVM在搜索类的时候，又是如何判定两个class是相同的呢？  
JVM在判定两个class是否相同时，`不仅要判断两个类名是否相同，而且要判断是否由同一个类加载器实例加载的`。只有两者同时满足的情况下，JVM才认为这两个class是相同的。`就算两个class是同一份class字节码，如果被两个不同的ClassLoader实例所加载，JVM也会认为它们是两个不同class`。

定义自已的类加载器分为两步:  
1. 继承java.lang.ClassLoader
2. 重写父类的findClass方法
读者可能在这里有疑问，父类有那么多方法，为什么偏偏只重写findClass方法？
因为JDK已经在loadClass方法中帮我们实现了ClassLoader搜索类的算法，当在loadClass方法中搜索不到类时，loadClass方法就会调用findClass方法来搜索类，所以我们只需重写该方法即可。如没有特殊的要求，一般不建议重写loadClass搜索类的算法。下图是JAVA 8 API中ClassLoader的loadClass方法：

>From JDK 8 
protected Class<?> loadClass(String name,boolean resolve)                      throws ClassNotFoundException

>>Loads the class with the specified binary name. The default implementation of this method searches for classes in the following order:  
1 Invoke findLoadedClass(String) to check if the class has already been loaded.  
2 Invoke the loadClass method on the parent class loader. If the parent is null the class loader built-in to the virtual machine is used, instead.  
3 Invoke the findClass(String) method to find the class.  

>>If the class was found using the above steps, and the resolve flag is true, this method will then invoke the resolveClass(Class) method on the resulting Class object.

>>Subclasses of ClassLoader are encouraged to override findClass(String), rather than this method.

>>Unless overridden, this method synchronizes on the result of getClassLoadingLock method during the entire class loading process.

其中5.6步我们可以通过覆盖ClassLoader的findClass方法来实现自己的载入策略。甚至覆盖loadClass方法来实现自己的载入过程。

__Context ClassLoader__
这里怎么又出来一个context classloader呢？它有什么用呢？我们在建立一个线程Thread的时候，可以为这个线程通过setContextClassLoader方法来指定一个合适的classloader作为这个线程的context classloader，当此线程运行的时候，我们可以通过getContextClassLoader方法来获得此context classloader，就可以用它来载入我们所需要的Class。默认的是System classloader。

>From JDK 8
If not set, the default is the ClassLoader context of the parent Thread. The context ClassLoader of the primordial thread is typically set to the class loader used to load the application. 

加载Class的默认规则比较简单，有3个：  
1. 双亲委托机制。
2. 同一个加载器：类A引用到类B,则由类A的加载器去加载类B,保证引用到的类由同一个加载器加载
3. Cache 机制

classloader 加载类用的是`全盘负责委托机制`。所谓`全盘负责`，即是当一个classloader加载一个Class的时候，这个Class所依赖的和引用的所有 Class也由这个classloader负责载入，除非是显式的使用另外一个classloader载入；`委托机制`则是先让parent（父）类加载器 (而不是super，它与parent classloader类不是继承关系)寻找，只有在parent找不到的时候才从自己的类路径中去寻找。此外类加载还`采用了cache机制`，也就是如果 cache中保存了这个Class就直接返回它，如果没有才从文件中读取和转换成Class，并存入cache，这就是为什么我们修改了Class但是必须重新启动JVM才能生效的原因

这其实是因为加载Class的默认规则在某些情况下不能满足要求。比如jdk中的jdbc API 和具体数据库厂商的实现类SPI的类加载问题。在jdbc API的类是由BootStrap加载的，那么如果在jdbc API需要用到spi的实现类时，根据默认规则2，则实现类也会由BootStrap加载，但是spi实现类却没法由BootStrap加载，只能由Ext或者App加载，如何解决这个问题？牛人们就想出了ContextClassLoader的方法。

具体的实现过程如下：在类Thread定义一个属性classLoader，用来供用户保存一个classLoader（默认是App），并公开setter和getter方法，使得此线程的任何语句都可以得到此classLoader，然后用它来加载类，以此来打破默认规则2。说白了，ContextClassLoader就是Thread的一个属性而已，没什么复杂的。只不过这个属性和底层的加载体系联系紧密。
那么我们看看ContextClassLoader是如何解决上面的问题的呢？以jdbc为例，当DriverManager需要加载SPI中的实现类是，可以获取ContextClassLoader(默认是App)，然后用此classLoader来加载spi中的类。很简单的过程。当然不使用ContextClassLoader，自己找个地方把classLoader保存起来，在其他地方能得到此classLoader就可以。Tomcat就是这么做的。比如StandardContext是由Common加载的，而StandardContext要用到项目下的类时怎么办，显然不能用Common来加载，而只能用WebAppClassLoader来加载，怎么办？当然可以采用ContextClassLoader的方式来解决，但是tomcat不是这样解决的，而是为每个App创建一个Loader，里面保存着此WebApp的ClassLoader。需要加载WebApp下的类时，就取出ClassLoader来使用，原理和ContextClassLoader是一样的。至于tomcat为什么要这么做呢？因为tomcat中有关类加载的问题，是由一个main线程来处理的，而并没有为每个WebApp单独创建一个线程，故没办法用ContextClassLoader的方式来解决，而是用自己的属性来解决。
 
既然规则2已经被打破了，那么规则1：双亲委托机制能被打破吗？规则1是因为安全问题而设置的，如果我自己能控制类加载的安全问题，是否可以违反规则1呢？答案是肯定的。同样的Tomcat也打破了此规则。Tomcat中WebAppClassLoader加载项目的类时，可以决定是否先在项目本地的路径中查找class文件。而不是自动使用父加载器Common在tomcat下的common目录查找。这是怎么实现的呢？
要回答这个问题，就要先明白双亲委托机制是如何实现的。只有明白了如何实现，才有办法改变它。双亲委托机制是在类ClassLoader的loadClass里面实现的。那么继承ClassLoader的WebAppClassLoader，只要覆盖loadClass方法，实现自己的加载策略，即可避开双亲委托机制。

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

以下是Java NIO里关键的Buffer实现:
* ByteBuffer
* CharBuffer
* DoubleBuffer
* FloatBuffer
* IntBuffer
* LongBuffer
* ShortBuffer

__MappedByteBuffer__  
java处理大文件, 一般用BufferedReader,BufferedInputStream这类带缓冲的Io类, 不过如果文件超大的话, 更快的方式是采用MappedByteBuffer。MappedByteBuffer是java nio引入的文件内存映射方案, 读写性能极高。NIO最主要的就是实现了对异步操作的支持。

Selector允许单线程处理多个Channel。如果你的应用打开了多个连接（通道），但每个连接的流量都很低，使用Selector就会很方便。例如，在一个聊天服务器中。 

如果需要管理同时打开的成千上万个连接，这些连接每次只是发送少量的数据，例如聊天服务器，实现NIO的服务器可能是一个优势。同样，如果你需要维持许多打开的连接到其他计算机上，如P2P网络中，使用一个单独的线程来管理你所有出站连接，可能是一个优势。

要使用Selector，得向Selector注册Channel，然后调用它的select()方法。这个方法会一直阻塞到某个注册的通道有事件就绪。一旦这个方法返回，线程就可以处理这些事件，事件的例子有如新连接进来，数据接收等。

##### Java NIO提供了与标准IO不同的IO工作方式 

Channels and Buffers(通道和缓冲区): 标准的IO基于字节流和字符流进行操作的，而NIO是基于通道（Channel）和缓冲区（Buffer）进行操作，数据总是从通道读取到缓冲区中，或者从缓冲区写入到通道中  

__Asynchronous IO（异步IO）__： Java NIO可以让你异步的使用IO，例如：当线程从通道读取数据到缓冲区时，线程还是可以进行其他事情。当数据被写入到缓冲区时，线程可以继续处理它。从缓冲区写入通道也类似
Selectors(选择器): Java NIO引入了选择器的概念，选择器用于监听多个通道的事件（比如：连接打开，数据到达）。因此，单个的线程可以监听多个数据通道

|IO|NIO
|----|----
|Stream oriented | Buffer oriented
|Blocking IO | Non blocking IO
| | Selectors

NIO可让您只使用一个（或几个）单线程管理多个通道（网络连接或文件），`但付出的代价是解析数据可能会比从一个阻塞流中读取数据更复杂。`

__面向流与面向缓冲__

Java NIO和IO之间第一个最大的区别是，IO是面向流的，NIO是面向缓冲区的。 Java IO面向流意味着每次从流中读一个或多个字节，直至读取所有字节，它们没有被缓存在任何地方。此外，它不能前后移动流中的数据。如果需要前后移动从流中读取的数据，需要先将它缓存到一个缓冲区。 Java NIO的缓冲导向方法略有不同。数据读取到一个它稍后处理的缓冲区，需要时可在缓冲区中前后移动。这就增加了处理过程中的灵活性。但是，还需要检查是否该缓冲区中包含所有您需要处理的数据。而且，需确保当更多的数据读入缓冲区时，不要覆盖缓冲区里尚未处理的数据

__阻塞与非阻塞IO__ 

Java IO的各种流是阻塞的。这意味着，当一个线程调用read() 或 write()时，该线程被阻塞，直到有一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了。 Java NIO的非阻塞模式，使一个线程从某通道发送请求读取数据，但是它仅能得到目前可用的数据，如果目前没有数据可用时，就什么都不会获取。而不是保持线程阻塞，所以直至数据变的可以读取之前，该线程可以继续做其他的事情。 非阻塞写也是如此。一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。 线程通常将非阻塞IO的空闲时间用于在其它通道上执行IO操作，所以一个单独的线程现在可以管理多个输入和输出通道(channel) 

#### Stream

#### Eclipse Shortcuts

* 全局 打开外部javadoc Shift+F2 
* Java编辑器 打开结构(all inheritant properties) Ctrl+F3 
* 全局 打开资源 Ctrl+Shift+R 
* 全局 打开类型 Ctrl+Shift+T 
* 全局 打开类型层次结构 F4 / Ctrl + T
* 全局 打开声明 F3 
* 全局 在层次结构中打开类型 Ctrl+Shift+H 

* 全局 转至匹配的括号 Ctrl+Shift+P

* 全局 转至上一个编辑位置 Ctrl+Q  

* 全局 快速修正 Ctrl+1 
* 全局 内容辅助 Alt+/ 
* 全局 上下文信息/智能提示  Alt+ / 
Alt+Shift+/
Ctrl+Shift+Space 

* ctrl + shift + o：导入类
* ctrl + shift + f：格式化代码 

* 查找当前元素的声明 Ctrl+G
* 查找当前元素的所有引用 Ctrl+Shift+G

---
[collections_1]:/resources/img/java/collection_performance_test_1.png "performance test: set vs hash_set vs hash_table"
[collections_2]:http://blog.csdn.net/morewindows/article/details/7330323 "STL系列之九 探索hash_set"
[collections_3]:http://blog.csdn.net/v_JULY_v/article/details/6530142 "从B 树、B+ 树、B* 树谈到R 树"
[misc_nio_1]:http://www.iteye.com/magazines/132-Java-NIO "Java NIO 系列教程"
[misc_class_loader_1]:http://blog.csdn.net/xyang81/article/details/7292380 "深入分析Java ClassLoader原理"
[jms-message-broker-1]:https://en.wikipedia.org/wiki/Message_broker "Message broker"
[misc-connection-pooling-1]:http://www.snaq.net/java/DBPool/ "DBPool : Java Database Connection Pooling"
[jms_amqp_1]:/resources/img/java/jms_amqp_1.png "layers of AMQP"
[j2ee_core_design_pattern_1]:/resources/img/java/Core_J2EE_Pattern_Catalog.png "Core_J2EE_Pattern_Catalog"
[j2ee_core_design_pattern_2]:http://www.corej2eepatterns.com/index.htm "Core J2EE Pattern Catalog"
[misc-terminologies-jat-1]:https://sourceforge.net/projects/javappstemplate/ "Jat - Java Application Template"
[javase_io_hierarchy_1]:/resources/img/java/java_io_input_1.png "input hierarchy 1"
[javase_io_hierarchy_2]:/resources/img/java/java_io_output_1.png "output hierarchy 1"
[javase_io_hierarchy_3]:/resources/img/java/java_io_input_2.png "input hierarchy 2"
[javase_io_hierarchy_4]:/resources/img/java/java_io_output_2.png "output hierarchy 2"
[javase_exception_1]:/resources/img/java/java_misc_exception_1.png "Java Exception hierarchy"

