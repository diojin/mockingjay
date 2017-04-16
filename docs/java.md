## Indexes
---

* [Concurrent](#concurrent)
    - [Misc](#concurrent-misc)
        + [Immutable Class](#immutable-class)
        + [thread dump](#thread-dump)
* [Collections](#collections)
    - [Misc](#collections-misc)
* [Web Service](#web-service)
    - [SOAP](#soap)
    - [Related Techniques](#ws-related-techniques)
        + [RMI vs IIOP](#rmi-vs-iiop)
            * [CORBA(Common Object Request Broker Architecture)](#corbacommon-object-request-broker-architecture)
            * [IIOP(Internet Inter-ORB Protocol)](#iiopinternet-inter-orb-protocol)
            * [JavaIDL](#javaidl)
            * [RMI-IIOP](#rmi-iiop)
* [JMS](#jms)
    - [Message Broker](#message-broker)
    - [AMQP(Advanced Message Queuing Protocol)](#amqpadvanced-message-queuing-protocol))
    - [Misc](#jms-misc)
        + [Relations between acknowledgement, session, transaction](#relations-between-acknowledgement-session-transaction)
* [J2EE](@j2ee)
* [Miscellaneous](#miscellaneous)
    - [Connection Pooling](#connection-pooling)
    - [class loader](#class-loader)
    - [NIO](#nio)
    - [Stream](#stream)

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

### Web Service

Web Service是基于网络的、分布式的模块化组件，它执行特定的任务，遵守具体的技术规范，这些规范使得Web Service能与其他兼容的组件进行互操作。

WSDL是一种 XML 格式??，用于将网络服务描述为一组端点，这些端点对包含面向文档信息或面向过程信息的消息进行操作。这种格式首先对操作和消息进行抽象描述，然后将其绑定到具体的网络协议和消息格式上以定义端点。相关的具体端点即组合成为抽象端点（服务）。

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

**JAXM(Java API for XML Messaging)** 是为SOAP通信提供访问方法和传输机制的API。
　
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


#### JMS Misc间件之间`异步、安全、高效`地交互。从整体来看，AMQP协议可划分为三层：


##### Relations between acknowledgement, session, transaction

**Acknowledgement mode:**  
* DUPS_OK_ACKNOWLEDGE - Automatic but a delayed acknowledgement of messages by the session that may result in duplicate messages if JMS provider fails.
* AUTO_ACKNOWLEDGE - Session automatically acknowledges when a message is delivered to application
* CLIENT_ACKNOWLEDGE - Client application explicitly acknowledges messages.

For your requirement I think you can choose CLIENT_ACKNOWLEDGE as it allows your application to explicitly acknowledge messages. But you must note that in some JMS providers, acknowledging a consumed message automatically acknowledges the receipt of all messages that have been delivered by its session. However some JMS providers do implement a per message acknowledgement.

The other option you have is to use a transacted session where acknowledge mode has no effect. In a transacted session, messages are removed from a queue only when application calls commit. If the session calls rollback or ends without calling commit, all messages that were delivered to an application since the previous commit call will reappear in the queue.


### J2EE

J2EE 是Sun公司提出的多层(multi-tiered),分布式(distributed),基于组件(component-base)的企业级应用模型 (enterpriese application model).在这样的一个应用系统中，可按照功能划分为不同的组件，这些组件又可在不同计算机上，并且处于相应的层次(tier)中。所属层次包括客户层(clietn tier)组件,web层和组件,Business层和组件,企业信息系统(EIS)层。

### Miscellaneous

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

classloader 加载类用的是`全盘负责委托机制`。所谓`全盘负责`，即是当一个classloader加载一个Class的时候，这个Class所依赖的和引用的所有 Class也由这个classloader负责载入，除非是显式的使用另外一个classloader载入；`委托机制`则是先让parent（父）类加载器 (而不是super，它与parent classloader类不是继承关系)寻找，只有在parent找不到的时候才从自己的类路径中去寻找。此外类加载还`采用了cache机制`，也就是如果 cache中保存了这个Class就直接返回它，如果没有才从文件中读取和转换成Class，并存入cache，这就是为什么我们修改了Class但是必须重新启动JVM才能生效的原因


定义自已的类加载器分为两步：  
1、继承java.lang.ClassLoader
2、重写父类的findClass方法
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

加载Class的默认规则比较简单，有两个：  
1. 双亲委托机制。
2. 同一个加载器：类A引用到类B，则由类A的加载器去加载类B，保证引用到的类由同一个加载器加载。

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
[jms-message-broker-1]:https://en.wikipedia.org/wiki/Message_broker "Message broker"
[misc-connection-pooling-1]:http://www.snaq.net/java/DBPool/ "DBPool : Java Database Connection Pooling"
[jms_amqp_1]:/resources/img/java/jms_amqp_1.png "layers of AMQP"