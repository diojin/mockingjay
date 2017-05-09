## Distributed
---

* [NoSql](#nosql)
    - [NoSql Categories](#nosql-categories)
    - [NoSql Characteristics](#nosql-characteristics)
* [Hadoop](#hadoop)
    - [Hive](#hive)
    - [HBase](#hbase)
    - [Misc](#hadoop-misc)
        + [MapReduce](#mapreduce)
* [Cluster](#cluster)
    - [Cluster types](#cluster-types)
    - [Load Balance Algorithm](#load-balance-algorithm)
* [SOA](#soa)
    - [Misc](#soa-misc)
        + [PROs and Cons](#soa-pros-and-cons)
        + [Differences between SOA and Web Service](#differences-between-soa-and-web-service)
* [Book Recommendation](#book-recommendation)
* [Miscellaneous](#miscellaneous)
    - [NoSql](#nosql)
        + [NoSql Categories](#nosql-categories)
        + [NoSql Characteristics](#nosql-characteristics)
    - [software transactional memory (STM)](#software-transactional-memorystm)
    - [Big Data open source trendy technologies](#big-data-open-source-trendy-technologies)
    - [Cloud computing](#cloud-computing)
    - [Data streaming](#data-streaming)
    - [peer-to-peer vs client-server](#peer-to-peer-vs-client-server)

### Hadoop

Hadoop 是一个实现了MapReduce 计算模型的开源分布式并行编程框架，程序员可以借助Hadoop 编写程序，将所编写的程序运行于计算机机群上，从而实现对海量数据的处理

 此外，Hadoop 还提供一个分布式文件系统(HDFS）及分布式数据库（HBase）用来将数据存储或部署到各个计算节点上。所以，你可以大致认为：Hadoop=HDFS（文件系统，数据存储技术相关）+HBase（数据库）+MapReduce（数据处理）。Hadoop 框架如图所示：
![hadoop_1]

我们已经知道，Hadoop是Google的MapReduce一个Java实现。MapReduce是一种简化的分布式编程模式，让程序自动分布到一个由普通机器组成的超大集群上并发执行。Hadoop主要由HDFS、MapReduce和HBase等组成。具体的hadoop的组成如下图：
![hadoop_2]

__The project includes these modules:__  
* Hadoop Common: The common utilities that support the other Hadoop modules.
* Hadoop Distributed File System (HDFS™): A distributed file system that provides high-throughput access to application data.
* Hadoop YARN: A framework for job scheduling and cluster resource management.
* Hadoop MapReduce: A YARN-based system for parallel processing of large data sets.

__Other Hadoop-related projects at Apache include:__  
* Ambari™: A web-based tool for provisioning, managing, and monitoring Apache Hadoop clusters which includes support for Hadoop HDFS, Hadoop MapReduce, Hive, HCatalog, HBase, ZooKeeper, Oozie, Pig and Sqoop. Ambari also provides a dashboard for viewing cluster health such as heatmaps and ability to view MapReduce, Pig and Hive applications visually alongwith features to diagnose their performance characteristics in a user-friendly manner.
* Avro™: A data serialization system.
* Cassandra™: A scalable multi-master database with no single points of failure.
* Chukwa™: A data collection system for managing large distributed systems.
* HBase™: A scalable, distributed database that `supports structured data storage` for large tables.
* Hive™: A data warehouse infrastructure that provides data summarization and ad hoc querying.
* Mahout™: A Scalable machine learning and data mining library.
* Pig™: A high-level data-flow language and execution framework for parallel computation.
* Spark™: A fast and general compute engine for Hadoop data. Spark provides a simple and expressive programming model that supports a wide range of applications, including ETL, machine learning, stream processing, and graph computation.
* Tez™: A generalized data-flow programming framework, built on Hadoop YARN, which provides a powerful and flexible engine to execute an arbitrary DAG of tasks to process data for both batch and interactive use-cases. Tez is being adopted by Hive™, Pig™ and other frameworks in the Hadoop ecosystem, and also by other commercial software (e.g. ETL tools),` to replace Hadoop™ MapReduce as the underlying execution engine`.
* ZooKeeper™: A high-performance coordination service for distributed applications.


#### Hive
Hive是基于Hadoop的一个数据仓库工具，处理能力强而且成本低廉。

__主要特点：__  
存储方式是将结构化的数据文件映射为一张数据库表。提供类SQL语言，实现完整的SQL查询功能。可以将SQL语句转换为MapReduce任务运行，十分适合数据仓库的统计分析。

__不足之处：__  
* 采用行存储的方式（SequenceFile）来存储和读取数据, 效率低
* 当要读取数据表某一列数据时需要先取出所有数据然后再提取出某一列的数据，效率很低。
* 同时，它还占用较多的磁盘空间

由于以上的不足，有人（查礼博士）介绍了一种将分布式数据处理系统中以记录为单位的存储结构变为以列为单位的存储结构，进而减少磁盘访问数量，提高查询处理性能。这样，由于相同属性值具有相同数据类型和相近的数据特性，以属性值为单位进行压缩存储的压缩比更高，能节省更多的存储空间。

#### HBase
HBase是一个分布式的、面向列的开源数据库，它不同于一般的关系数据库,是一个适合于非结构化数据存储的数据库。另一个不同的是HBase基于列的而不是基于行的模式。HBase使用和 BigTable非常相同的数据模型。用户存储数据行在一个表里。一个数据行拥有一个可选择的键和任意数量的列，一个或多个列组成一个ColumnFamily，一个Fmaily下的列位于一个HFile中，易于缓存数据。表是疏松的存储的，因此用户可以给行定义各种不同的列。在HBase中数据按主键排序，同时表按主键划分为多个HRegion

#### Hadoop Misc
##### MapReduce
![mapreduce_1]

原始状态下，输入–Map — Shuffle — Reduce — 输出
![mapreduce_2]

首先，让我们以WordCount为例来解释MapReduce是怎么工作的.
![mapreduce_example_1]


map数据输入
Hadoop针对文本文件缺省使用LineRecordReader类来实现读取，一行一个key/value对，key取偏移量，value为行内容。
如下是map1的输入数据： 
Key1                  Value1 
0         Hello World Bye World
如下是map2的输入数据： 
Key1                Value1 
0         Hello Hadoop GoodBye Hadoop


### Cluster

[For more information][cluster_1]

__幂等方法(Idempotent methods)__  
幂等函数，或幂等方法，是指可以使用相同参数重复执行，并能获得相同结果的函数。这些函数不会影响系统状态，也不用担心重复执行会对系统造成改变。例如，“getUsername()”函数就是一个幂等函数，“deleteFile()”函数就不是。“幂等”是HTTP Session和EJB Failover的一个重要概念。

__负载均衡(load balance)__  
负载均衡是集群技术中重要的一部分。通过将请求分发到不同的服务器，它提供了可同时获得高可用性和更高性能的服务的方法。简单的负载均衡器可以是一个Servlet或一些插件，复杂的负载均衡器可能是高级的嵌入了SSL加速器的硬件设备。
除了分发请求之外，负载均衡器还负责执行一些重要的任务：
1. `“会话持久”`用来确保用户会话生命周期在一台服务器上的完整性。
2. `“心跳检查”`来检查失败的服务器。
3. Session Sticky ?
4. 在某些情况下，负载均衡器需要参与“失败转移”的过程，下文中会提及

__HTTPSession Failover__  
主流的Java EE供应商都实现了HTTPSession失败转移。当浏览器在访问有状态的Web应用时，在该服务器的内存中会创建会话对象。与此同时将能唯一确定会话对象的HTTPSession ID发送至浏览器。浏览器将该ID作为cookie存储，并在下次请求该Web应用时将此cookie发送至Web服务器。
为了支持会话失败转移，Web服务器中的`会话对象将被备份下来`，以备服务器失败时防止会话信息丢失。负载均衡器将检测到实例的失败，并将后续请求分发到其他服务器实例上。由于会话对象已经被备份下来了，处理请求的新服务器实例就能恢复该会话的信息，继续正确处理会话。

要实现上述功能，需要引入以下内容：
__全局HTTPSession ID__  
上面已经讲过，HTTPSession ID用来标识特定服务器实例中的内存会话对象。在Java EE中，HTTPSession ID根据JVM实例来产生。每个JVM实例能驻留多个Web应用，每个应用能为不同的用户保存HTTPSession。HTTPSession ID是在当前JVM实例中访问相关会话对象的关键。在会话失败转移的实现中，不同的JVM实例不能生成相同的HTTPSession ID。如若不然，在失败转移发生时，就不知道哪个对象是应该恢复的对象。所以，需要引入全局HTTPSession ID机制。

__会话持久的方法__  
* 数据库持久化办法
    一些的Java EE集群产品都支持使用JDBC通过关系型数据库备份会话状态。
    通常，执行数据库的事务会造成一些额外的开销，所以本方法的主要缺陷在于当并发数据量较大时可能无法提供需要的可扩展性。大部分采用数据库会话持久化方法的应用服务器供应商都建议尽量减少HTTPSession存储的对象.
* 内存复制办法
    Tomcat、JBoss、WebLogic、Websphere之流的Java EE服务器都提供了另一种实现：内存复制。在上图中描述了使用内存复制技术来实现会话状态备份的场景。本方法的性能很好。对比数据库持久化技术，在原服务器和一台或多台备份服务器之间进行直接内存复制对网络通信的影响很小。但是，不同厂商的服务器对内存复制技术的应用方式不同(在下面有具体描述)，有的厂商采用的技术就不再需要“恢复”的过程了，即会话数据备份时已驻留在备份服务器的内存中，当备份服务器接管时，所有的数据已经存在。

#### Cluster types
There are 4 major types of clusters:
* Storage
* High availability
* Load balancing
* High performance

[For more information][cluster_types_1]

__Storage clusters__ provide a consistent file system image across servers in a cluster, allowing the servers to simultaneously read and write to a single shared file system. A storage cluster simplifies storage administration by limiting the installation and patching of applications to one file system. Also, with a cluster-wide file system, a storage cluster eliminates the need for redundant copies of application data and `simplifies backup and disaster recovery`. __Red Hat Cluster Suite__ provides storage clustering through Red Hat GFS.

__High-availability clusters__ provide continuous availability of services by `eliminating single points of failure` and by `failing over` services from one cluster node to another in case a node becomes inoperative. Typically, services in a high-availability cluster read and write data (via read-write mounted file systems). Therefore, a high-availability cluster must maintain data integrity as one cluster node takes over control of a service from another cluster node. Node failures in a high-availability cluster are not visible from clients outside the cluster. (High-availability clusters are sometimes referred to as failover clusters.) Red Hat Cluster Suite provides high-availability clustering through its High-availability Service Management component.
常说的双机热备、双机互备等都属于高可用集群的范畴

__Load-balancing clusters__ dispatch network service requests to multiple cluster nodes to balance the request load among the cluster nodes. Load balancing provides cost-effective scalability because you can match the number of nodes according to load requirements. If a node in a load-balancing cluster becomes inoperative, the load-balancing software detects the failure and redirects requests to other cluster nodes. Node failures in a load-balancing cluster are not visible from clients outside the cluster. Red Hat Cluster Suite provides load-balancing through LVS (Linux Virtual Server).

__High-performance clusters(高性能计算集群)__ use cluster nodes to perform concurrent calculations. A high-performance cluster allows applications to work in parallel, therefore enhancing the performance of the applications. (High performance clusters are also referred to as computational clusters or __grid computing__.)

__按集群层次划分__  
1. Web级集群，是J2EE集群中最重要和基础的功能。web层集群技术包括：Web负载均衡和HTTPSession Failover。web负载均衡，基本的是在浏览器和web服务器之间放置负载均衡器。
2. 应用级集群，是ejb集群，EJB是J2EE应用平台的核心，EJB是用于开发和部署具多层结构的、分布式的、面向组件的Java应用系统跨平台的构件体系结构。主要是业务应用，部署在EJB容器上。
3. 数据库级集群，比如在oracle数据库设置多个数据库实例，全部映射到数据库。

__Load Balance Algorithm__  

[For more information 1][cluster_load_balance_algorithm_1]
[For more information 2][cluster_load_balance_algorithm_2]

* Static算法
负载均衡的石器时代，为一个服务指定多个IP:PORT，(其他的IP作为)备份模式，其总是返回服务器组的第一个服务器（只要第一个服务器可用），当第一个服务器没有用的时候，才会返回后续可用的服务器。这种情况下，每台机器都包括全量的数据，查询通常会落到第一台机器上，第一台机器上Cache命中率高，但是当失败的时候，落到第二胎机器上，那就杯具了，Cache命中率那个低啊

* Random算法
idx=rand()%M
在实际使用中，跟Static算法一样，都是模块维护全量数据，这个还好每台机器的cache命中率理论上应该差不多，但是都不高，为啥呢？因为同样一个请求一会落到机器A，一会落到机器B上。浪费内存啊，内存有限，Cache会被淘汰，频繁淘汰，当然使得命中率低下啊

随机：负载均衡方法随机的把负载分配到各个可用的服务器上，通过随机数生成算法选取一个服务器，然后把连接发送给它。虽然许多均衡产品都支持该算法，但是它的有效性一直受到质疑，除非把服务器的可运行时间看的很重。
While it is available on many load balancing products, its usefulness is questionable except where uptime is concerned – and then only if you detect down machines.

* Round robin算法
idx=(idx+1)%M
同样的模块维护全量数据

Round Robin passes each new connection request to the next server in line, eventually distributing connections evenly across the array of machines being load balanced. `Round Robin works well in most configurations, but could be better if the equipment that you are load balancing is not roughly equal in processing speed, connection speed, and/or memory.`

There are 3 variants of this algorithm:  
1. 轮询：轮询算法按顺序把每个新的连接请求分配给下一个服务器，最终把所有请求平分给所有的服务器。轮询算法在大多数情况下都工作的不错，但是如果负载均衡的设备在处理速度、连接速度和内存等方面不是完全均等，那么效果会更好。
2. 加权轮询：该算法中，每个机器接受的连接数量是按权重比例分配的。这是对普通轮询算法的改进，比如你可以设定：第三台机器的处理能力是第一台机器的两倍，那么负载均衡器会把两倍的连接数量分配给第3台机器。Weighted Round Robin (called Ratio on the BIG-IP)
3. 动态轮询：类似于加权轮询，但是，权重值基于对各个服务器的持续监控，并且不断更新。这是一个动态负载均衡算法，基于服务器的实时性能分析分配连接，比如每个节点的当前连接数或者节点的最快响应时间等。
    __Dynamic Round Robin__ (Called Dynamic Ratio on the BIG-IP)
    This is a dynamic load balancing method, distributing connections based on various aspects of real-time server performance analysis, such as the current number of connections per node or the fastest node response time. 

* Hash算法
又叫取余算法，将query key做hash之后，按照机器数量取余，选取中一个机器进行连接服务。
idx=hash(query_key)%M
余数计算的方法简单，数据的分散性也相当优秀，`但也有其缺点。那就是当添加或移除服务器时，缓存重组的代价相当巨大。添加服务器后，余数就会产生巨变，这样就无法获取与保存时相同的服务器，从而影响缓存的命中率`

* Consistent hash算法
一致性hash算法是：首先求出服务器（节点）的哈希值，并将其配置到0～2^32的圆（continuum）上。然后用同样的方法求出存储数据的键的哈希值，并映射到圆上。然后从数据映射到的位置开始顺时针查找，将数据保存到找到的第一个服务器上。如果超过2^32仍然找不到服务器，就会保存到第一台服务器上。另外, 通过使用虚拟节点来实现数据均匀分布.
idx=FirstMaxServerIdx(hash(query_key))

* CARP算法
CARP准确的说不是一个算法，而是一个协议，Cache Array Routing Protocol，Cache群组路由协议。
计算全部服务器的idx_key=hash(query_key+server_idx)，其中计算得到idx_key最大的server_idx就是需要的idx。

假设开始3台后端服务器，请求用标志串 req = "abcd" 来标志，服务器用 S1, S2, S3来标志， 那么，通过对 req + Sx 合并起来计算签名就可以对每个服务器得到一个数值：
(req = "abcd" + S1) = K1
(req = "abcd" + S2) = K2
(req = "abcd" + S3) = K3
计算的方法可以使用crc，也可以使用MD5，目的的得到一个*散列*的数字，这样在K1,K2,K3中 必定有一个最大的数值，假设是K2，那么可以将请求req扔给S2，这样，以后对相同的请求， 相同的服务器组，计算出来的结果必定是K2最大，从而达到HASH分布的效果。
`巧妙的地方在于，新增或者删除一台服务器的时候，不会引起已有服务器的cache大规模失效`， 假设新增一台服务器S4，那么对S1,S2,S3计算的K值都完全相同，那么对S4可以计算得到一个新值K4，如果计算K的算法足够散列，那么原先计算到S1,S2,S3的请求，理论上都会有1/4的请求新计算得到的K4比原先的K大， 那么这1/4的请求会转移到S4，从而新增的S4服务器会负担1/4的请求，原先的S1,S2,S3也只会负担原先的3/4。

* 最快算法：最快算法基于所有服务器中的最快响应时间分配连接。`该算法在服务器跨不同网络的环境中特别有用`。
Fastest: The Fastest method passes a new connection based on the fastest response time of all servers. This method may be particularly useful in environments where servers are distributed across different logical networks. On the BIG-IP, only servers that are active will be selected.

**The Long Term Resource Monitoring algorithms** are the best choice if you have a significant number of persistent connections. **Fastest** works okay in this scenario also if you don’t have access to any of the dynamic solutions.

* 最少连接：系统把新连接分配给当前连接数目最少的服务器。`该算法在各个服务器运算能力基本相似的环境中非常有效。`
Least Connections: With this method, the system passes a new connection to the server that has the least number of current connections. Least Connections methods work best in environments where the servers or other equipment you are load balancing have similar capabilities. This is a dynamic load balancing method, distributing connections based on various aspects of real-time server performance analysis, such as the current number of connections per node or the fa`stest node response time. This Application Delivery Controller method is rarely available in a simple load balancer.
最少连接数均衡算法对内部中需负载的每一台服务器都有一个数据记录，记录当前该服务器正在处理的连接数量，当有新的服务连接请求时，将把当前请求分配给连接数最少的服务器，使均衡更加符合实际情况，负载更加均衡。`此种均衡算法适合长时处理的请求服务，如FTP。

* 观察算法：该算法同时利用最小连接算法和最快算法来实施负载均衡。服务器根据当前的连接数和响应时间得到一个分数，分数较高代表性能较好，会得到更多的连接。
Observed: The Observed method uses a combination of the logic used in the Least Connections and Fastest algorithms to load balance connections to servers being load-balanced. With this method, servers are ranked based on a combination of the number of current connections and the response time. Servers that have a better balance of fewest connections and fastest response time receive a greater proportion of the connections. This Application Delivery Controller method is rarely available in a simple load balancer.

* 预判算法：该算法使用观察算法来计算分数，但是预判算法会分析分数的变化趋势来判断某台服务器的性能正在改善还是降低。具有改善趋势的服务器会得到更多的连接。`该算法适用于大多数环境`。
Predictive: The Predictive method uses the ranking method used by the Observed method, however, with the Predictive method, the system analyzes the trend of the ranking over time, determining whether a servers performance is currently improving or declining. The servers in the specified pool with better performance rankings that are currently improving, rather than declining, receive a higher proportion of the connections. The Predictive methods work well in any environment. This Application Delivery Controller method is rarely available in a simple load balancer.

You can see with some of these algorithms that persistent connections would cause problems. Like Round Robin, if the connections persist to a server for as long as the user session is working, some servers will build a backlog of persistent connections that slow their response time. **The Long Term Resource Monitoring algorithms** are the best choice if you have a significant number of persistent connections. **Fastest** works okay in this scenario also if you don’t have access to any of the dynamic solutions.

### SOA

__Service-Oriented Architecture__ is `anapplication architecture` in which all functions, or services, are `defined using a description language` and `have invokable interfaces` that are called to perform business processes. Each interaction is `independent `of each and every other interaction and the interconnect protocols of the communicating devices (i.e., the infrastructure components that determine the communication system do not affect the interfaces).

SOA架构，是一种`粗粒度`、开放式、`松耦合`的服务结构，要求软件产品在开发过程中，按照相关的标准或协议，进行`分层开发`。通过这种分层设计或架构体系可以使软件产品变得更加弹性和灵活，且尽可能的与第三方软件产品互补兼容，以达到快速扩展，满足或响应市场或客户需求的多样化、多变性。

>This definition of SOA was produced by the SOA Definition team of The Open Group SOA Working Group.

__Service-Oriented Architecture (SOA)__ is an `architectural style` that supports service-orientation.

Service-orientation is a way of thinking in terms of services and service-based development and the outcomes of services.

__A service:__  
* Is a logical representation of a repeatable business activity that has a specified outcome (e.g., check customer credit, provide weather data, consolidate drilling reports)
* Is self-contained
* May be composed of other services
* Is a “black box” to consumers of the service

__SOA Architectural Style__  
The SOA architectural style has the following distinctive features:
* It is based on `the design of the services` – which mirror real-world business activities – `comprising the enterprise (or inter-enterprise) business processes.`
* `Service representation utilizes business descriptions` to provide `context` (i.e., business process, goal, rule, policy, service interface, and service component) and `implements services using service orchestration.`
* It places unique requirements on the infrastructure – it is recommended that implementations `use open standards(PS: XML and SOAP, etc) to realize interoperability and location transparency`.
* Implementations are `environment-specific` – they are constrained or enabled by `context` and must be described within that context.
* It requires `strong governance` of service representation and implementation.
* It requires a `“Litmus Test”`, which determines a “good service”.

#### SOA Misc

##### SOA PROs and Cons

__In all, PROs are:__  
* platform-independent
* improved information flow(due to coarse-grained services)
* better data translation
* internal software organization(reducing round trips between clients and service providers)
* reusable, easy to maintain and change

__Cons are:__  
* applications with GUI functionality become more complex when using SOA.
* had to be customized
* need strong governance of business flow, service description and implentation, otherwise, it raise secure problem

Details are as below, 

SOA provides a strategic capability for integrating business processes, data, and organizational knowledge. Because interfaces are `platform-independent`, a client from any device using any operating system in any language can use the service. In a service-oriented architecture, clients consume services, rather than invoking discreet method calls directly. 

__There are many benefits of SOA, including__  
* improved information flow
* location transparency
* internal software organization
* better data translation

__The most commonly discussed disadvantage of SOA__ is for applications with GUI functionality. These types of applications become more complex when using SOA.

SOA体系架构带来的主要观点是`业务驱动IT`，即业务驱动和业务更加紧密地联系在一起。
* 以`粗粒度的业务服务作为基础`来对公司业务进行建模，这样就可以产生`简洁的业务和系统视图`
* 以业务服务为基础来实现的IT系统`更灵活、更易于重用`、也更快地应对企业业务需求的变化
* 以业务服务为基础，通过`显式地方式来定义、描述`、实现和管理业务层次的粗粒度服务(包括业务流程)，提供了业务服务模型和相关IT业务之间提供了更好的"可追溯性"，缩小了它们之间的差距，使得业务服务的变化更容易传递到IT。

(粗粒度性：粗粒度服务提供一项特定的业务功能，采用粗粒度服务接口的优点在于使用者和服务层之间不必再进行多次的往复，一次往复就足够了)

利用SOA架构开发的时候，其基于松耦合的特性能给企业带来诸多的好处:  
* 更易维护
　　业务服务提供者和业务服务使用者的松散耦合关系及对开放标准的采用确保了该特性的实现。建立在以 SOA基础上的信息系统，当需求发生变化的时候，不需要修改提供业务服务的接口，只需要调整业务服务流程或者修改操作即可，整个应用系统也更容易被维护。
* 更高的可用性
　　该特点是在于服务提供者和服务使用者的松散耦合关系上得以发挥与体现。使用者无须了解提供者的具休实现细节
* 更好的伸缩性
　　依靠业务服务设计、开发和部署等所采用的架构模型实现伸缩性。使得服务提供者可以互相彼此独立地进行调整，以满足新的服务需求。

现在，国内许多企业已经使用了SOA架构，但是是否它就真的没有缺点，答案显然不是：  
* 安全问题。SOA做为一种基于服务的架构，其面向的是流程。这样，当企业真正实施基于SOA的应用软件以后，表面看来，企业的业务流程得到了梳理，内控的能力提高了，但SOA架构要求必须有一个类似于流程管理的程序，来统一管理这些流程。
　　这就带来一个问题，如果这个架构出现问题，那么将导致所有的业务瘫痪。而现在企业信息化的发展趋势是IT和业务结合得越来越紧密，或者可以说业务对IT的依赖程度越来越高，相信如果SOA不能很好地解决安全问题，将会极大地限制其发展。
* 个性化问题。SOA通过所谓粗粒度服务接口和分级，确实提高了效率。实现流程化以后，也确实简化了开发难度。如果这个流程不适合我这个企业的实际情况，我还是需要个性化开发。国内的中小企业占到了企业总量的70%，他们的需求很具个性化，而且比较在意价格的因素。实际上这和SOA高度集成的性质是不相符的。

##### Differences between SOA and Web Service
SOA是一种软件设计准则，一种实现松耦合，高可复用性和粗粒度的web服务的设计模式。开发者可以选择任意协议实现SOA，例如，HTTP、HTTPS、JMS、SMTP、RMI、IIOP（例如，采用IIOP的EJB）、RPC等。消息可以采用XML或者数据传输对象（Data Transfer Objects，DTOs）。

`Web Service是实现SOA的技术之一`。也可以不用Web service来实现SOA应用：例如，用一些传统的技术，像Java RMI，EJB，JMS消息等。但是Web service提供的是标准的平台无关的服务，这些服务采用HTTP、XML、SOAP、WSDL和UDDI技术，因此可以带来J2EE和.NET这些异构技术（heterogeneous technologies）之间的互操作性。

### Book Recommendation

#### <大型网站系统与Java中间件开发实践> 

本人入门水平，看此书的目的是想初步了解分布式系统。
主要内容：此书以淘宝某些系统为原型，以淘宝某些网站的演进为引子，主要介绍了Java中间件，消息中间件，数据层应用层的分布式处理。
从系统的演进可以一窥分布式系统的发展与进化：
单机系统--> 应用与数据库分机--> 数据库读写分离--> 分布式存储的引入--> 数据的水平垂直拆分--> 应用的分布式部署--> 应用服务化。

在我看来，无非是三种方式去解决大型网站遇到的问题：  
* 拆应用
* 拆数据库
* 优化应用及应用间的交互

1. 拆应用：有两种拆法，一个是水平扩展，即将应用部署在多台机器上，要解决的实现难点是session的同步、时间同步问题、分布式事务处理。另一个是按功能垂直拆，一个个模块都独立部署，这样一个个模块又都是一个新系统，又可以将它们做水平扩展。
2. 拆数据库：也有两种拆法，一个是水平，另一个是垂直。拆数据库明显比拆应用难的多，一方面要解决技术难题，另一方面要优化代码。要解决的问题也都很棘手。
    1. 跨库事务的处理 （提交协议：两阶段提交、Paxos协议）
    2. 跨库多表的查询
    3. 查询的分页及排序
    4. 同表跨库的sequence问题
3. 优化应用及应用间的交互：一般优化应用的方法有像引入cache模型、cache系统；引入NOSQL；引入分布式文件系统；引入多线程处理等。另一种方式是优化其之间的交互，引入消息中间件，构建一些Java中间件更好的支持多系统的交互等。
 
扩展阅读：Java的多线程编程。Java NIO。负载均衡器的了解。分布式事物。JMS。NOSQL。

总结：是一本较入门的书，很多东西并没有太深入，但面也算全。适合做为一本分布式的入门书来读。

### Miscellaneous

CAP theorem

#### NoSql

A NoSQL (originally referring to "non SQL" or "non relational") database provides a mechanism for storage and retrieval of data which is modeled in means other than the tabular relations used in relational databases. 

Such databases have existed since the late 1960s, but did not obtain the "NoSQL" moniker until a surge of popularity in the early twenty-first century, triggered by the needs of Web 2.0 companies such as Facebook,Google and Amazon.com. NoSQL databases are increasingly used in big data and real-time web applications. 

NoSQL systems are also sometimes called "Not only SQL" to emphasize that they `may support SQL-like query languages`.

Motivations for this approach include: simplicity of design, `simpler "horizontal" scaling to clusters of machines (which is a problem for relational databases)`, and finer control over availability. The data structures used by NoSQL databases (e.g. __key-value__, __wide column__, __graph__, or __document__) are different from those used by default in relational databases, making some operations faster in NoSQL. The particular suitability of a given NoSQL database depends on the problem it must solve. Sometimes the data structures used by NoSQL databases are also viewed as "more flexible" than relational database tables.

Many NoSQL stores __compromise consistency__ (in the sense of the __CAP theorem__) in favor of availability, partition tolerance, and speed. `Barriers to the greater adoption of NoSQL stores` include `the use of low-level query languages (instead of SQL, for instance the lack of ability to perform ad-hoc JOINs across tables)`, `lack of standardized interfaces`, and `huge previous investments in existing relational databases`.` Most NoSQL stores lack true ACID transactions`, although a few databases, such as MarkLogic, Aerospike, FairCom c-treeACE, Google Spanner (though technically a NewSQLdatabase), Symas LMDB and OrientDB have made them central to their designs. (See ACID and JOIN Support.)
Instead, most NoSQL databases offer a concept of `"eventual consistency"` in which database changes are propagated to all nodes "eventually" (typically within milliseconds) so queries for data might not return updated data immediately or might result in reading data that is not accurate, a problem known as stale reads. Additionally, `some NoSQL systems may exhibit lost writes and other forms of data loss`. Fortunately, some NoSQL systems provide concepts such as write-ahead logging to avoid data loss. `For distributed transaction processing across multiple databases`, data consistency is an even bigger challenge that is difficult for both NoSQL and relational databases. Even current relational databases "do not allow referential integrity constraints to span databases." There are few systems that maintain both ACID transactions and X/Open XA standards for distributed transaction processing.

##### NoSql Categories

分类  |Examples举例  |典型应用场景  |数据模型    |优点  |缺点
---------|-------------|---------------------|-----------------|--------|------
key-value(键值)|Tokyo Cabinet/Tyrant, __Redis__, Voldemort, __Oracle BDB__|`内容缓存`，主要用于`处理大量数据的高访问负载`，也用于一些日志系统等等| [Key 指向 Value 的键值对，通常用hash table来实现| 查找速度快|  `数据无结构化`，`通常只被当作字符串或者二进制数据`. 如果DBA只对部分值进行查询或更新的时候，Key/value就显得效率低下了
wide column(列存储数据库)|__Cassandra__, __HBase__, Riak|`分布式的文件系统`|    以列簇式存储，将同一列数据存在一起|   查找速度快，可扩展性强，`更容易进行分布式扩展`|  功能相对局限
document(文档型数据库)|__CouchDB__, __MongoDb__|Web应用(与Key-Value类似，Value是`结构化的`，不同的是数据库能够了解Value的内容)| Key-Value对应的键值对，`Value为结构化数据`, 比如JSON|  `数据结构要求不严格，表结构可变`，不需要像关系型数据库一样需要预先定义表结构|  `查询性能不高，而且缺乏统一的查询语法`
graph(图形)数据库|Neo4J, InfoGrid, Infinite Graph|`社交网络，推荐系统`等, 专注于构建关系图谱|图结构|利用图结构相关算法。比如最短路径寻址，N度关系查找等|很多时候需要对整个图做计算才能得出需要的信息，而且这种结构不太好做分布式的集群方案

>而且文档型数据库比键值数据库的查询效率更高??

##### NoSql Characteristics
对于NoSQL并没有一个明确的范围和定义，但是他们都普遍存在下面一些共同特征:  
1. 不需要预定义模式：不需要事先定义数据模式，预定义表结构。数据中的每条记录都可能有不同的属性和格式。当插入数据时，并不需要预先定义它们的模式
2. 无共享架构：相对于将所有数据存储的存储区域网络中的全共享架构。NoSQL往往将数据划分后存储在各个本地服务器上。因为从本地磁盘读取数据的性能往往好于通过网络传输读取数据的性能，从而提高了系统的性能。
3. 弹性可扩展：可以在系统运行的时候，动态增加或者删除结点。不需要停机维护，数据可以自动迁移
4. 分区：相对于将数据存放于同一个节点，NoSQL数据库需要将数据进行分区，将记录分散在多个节点上面。并且通常分区的同时还要做复制。这样既提高了并行性能，又能保证没有单点失效的问题。
5. 异步复制: 和RAID存储系统不同的是，NoSQL中的复制，往往是基于日志的异步复制。这样，数据就可以尽快地写入一个节点，而不会被网络传输引起迟延。缺点是并不总是能保证一致性，这样的方式在出现故障的时候，可能会丢失少量的数据。
6. 最终一致性和软事务-BASE：相对于事务严格的ACID特性，NoSQL数据库保证的是BASE特性。BASE是最终一致性和软事务

NoSQL数据库并没有一个统一的架构，两种NoSQL数据库之间的不同，甚至远远超过两种关系型数据库的不同。可以说，NoSQL各有所长，成功的NoSQL必然`特别适用于某些场合或者某些应用`，在这些场合中会远远胜过关系型数据库和其他的NoSQL。

#### software transactional memory (STM)
[For more information][stm_1]
`In computer science, software transactional memory (STM) is a concurrency control mechanism analogous to database transactions for controlling access to shared memory in concurrent computing.` It is `an alternative to lock-based synchronization`. STM is a strategy `implemented in software`, rather than as a hardware component. A transaction in this context occurs when a piece of code executes a series of reads and writes to shared memory. These reads and writes logically occur at a single instant in time; intermediate states are not visible to other (successful) transactions. 

Unlike the locking techniques used in most modern multithreaded applications, STM is `very optimistic`: a thread completes modifications to shared memory without regard for what other threads might be doing, `recording every read and write that it is performing in a log`. Instead of placing the onus on the writer to make sure it does not adversely affect other operations in progress, it is placed on the` reader, who after completing an entire transaction verifies that other threads have not concurrently made changes to memory that it accessed in the past`. This final operation, in which the changes of a transaction are validated and, if validation is successful, made permanent, is called a commit. A transaction may also abort at any time, causing all of its prior changes to be rolled back or undone. `If a transaction cannot be committed due to conflicting changes, it is typically aborted and re-executed from the beginning until it succeeds.`

The benefit of this optimistic approach is increased concurrency: no thread needs to wait for access to a resource, and different threads can safely and simultaneously modify disjoint parts of a data structure that would normally be protected under the same lock.

`However, in practice STM systems also suffer a performance hit compared to fine-grained lock-based systems on small numbers of processors (1 to 4 depending on the application)`. This is due primarily to the overhead associated with maintaining the log and the time spent committing transactions. `Even in this case performance is typically no worse than twice as slow.`[5] Advocates of STM believe this penalty is justified by the conceptual benefits of STM[citation needed].

In 2005, Tim Harris, Simon Marlow, Simon Peyton Jones, and Maurice Herlihy described an STM system built on Concurrent Haskell that enables arbitrary atomic operations to be composed into larger atomic operations, a useful concept impossible with lock-based programming. 

STM can be implemented as a lock-free algorithm or it can use locking.

#### Big Data open source trendy technologies
[For more informtaion][big-data-open-source-tech-1]

* Storm and Kafka
Storm and Kafka are the future of stream processing, and they are already in use at a number of high-profile companies including Groupon, Alibaba, and The Weather Channel.
Born inside of Twitter, Storm is a “distributed real-time computation system”. `Storm does for real-time processing what Hadoop did for batch processing.` Kafka for its part is a `messaging system` developed at LinkedIn to serve as the foundation for their activity stream and the data processing pipeline behind it.
When paired together, you get the stream, you get it in-real time, and you get it at linear scale.

Why should you care?
`With Storm and Kafka, you can conduct stream processing at linear scale`, assured that every message gets processed in real-time, reliably. In tandem, Storm and Kafka can handle data velocities of tens of thousands of messages every second.
Stream processing solutions like Storm and Kafka have caught the attention of many enterprises due to their superior approach to ETL (extract, transform, load) and data integration.
Storm and Kafka are also great at `in-memory analytics`, and `real-time decision support`. Companies are quickly realizing that batch processing in Hadoop does not support real-time business needs. Real-time streaming analytics is a must-have component in any enterprise Big Data solution or stack, because of how elegantly they handle the “three V’s” — volume, velocity and variety.
Storm and Kafka are the two technologies on the list that we’re most committed to at Infochimps, and it is reasonable to expect that they’ll be a formal part of our platformsoon.

* Drill and Dremel
Drill and Dremel make `large-scale, ad-hoc querying of data` possible, with radically lower latencies that are especially apt for `data exploration`. `They make it possible to scan over petabytes of data in seconds`, to answer ad hoc queries and presumably, power compelling visualizations.
Drill and Dremel `put power in the hands of business analysts, and not just data engineers`. The business side of the house will love Drill and Dremel.
Drill is the open source version of what Google is doing with Dremel (Google also offers Dremel-as-a-Service with its BigQuery offering). Companies are going to want to make the tool their own, which why Drill is the thing to watch mostly closely. Although it’s not quite there yet, strong interest by the development community is helping the tool mature rapidly.

Why should you care?
Drill and Dremel compare favorably to Hadoop for `anything ad-hoc`. Hadoop is all about batch processing workflows, which creates certain disadvantages.
The Hadoop ecosystem worked very hard to make MapReduce an approachable tool for ad hoc analyses. `From Sawzall to Pig and Hive, many interface layers have been built on top of Hadoop to make it more friendly, and business-accessible.` Yet, for all of the SQL-like familiarity, these abstraction layers ignore one fundamental reality – MapReduce (and thereby Hadoop) is purpose-built for organized data processing (read: running jobs, or “workflows”).
What if you’re not worried about running jobs? What if you’re more concerned with asking questions and getting answers — slicing and dicing, looking for insights?
That’s “ad hoc exploration” in a nutshell — if you assume data that’s been processed already, how can you optimize for speed? You shouldn’t have to run a new job and wait, sometimes for considerable lengths of time, every time you want to ask a new question.
In stark contrast to workflow-based methodology, most business-driven BI and analytics queries are fundamentally ad hoc, interactive, low-latency analyses. Writing Map Reduce workflows is prohibitive for many business analysts. Waiting minutes for jobs to start and hours for workflows to complete is not conducive to an interactive experience of data, the comparing and contrasting, and the zooming in and out that ultimately creates fundamentally new insights.
Some data scientists even speculate that Drill and Dremel may actually be better than Hadoop in the wider sense, and a potential replacement, even. That’s a little too edgy a stance to embrace right now, but there is merit in an approach to analytics that is more query-oriented and low latency.

At Infochimps we like the **Elasticsearch full-text search engine** and database for doing high-level data exploration, but for truly capable Big Data querying at the (relative) seat level, we think that Drill will become the de facto solution.

* R
R is an `open source statistical programming language`. It is incredibly powerful. `Over two million (and counting) analysts` use R. It’s been around `since 1997` if you can believe it. It is a modern version of the S language for statistical computing that originally came out of the Bell Labs. Today, R is quickly becoming the new standard for statistics.
R performs complex data science at a much smaller price (both literally and figuratively). R is making serious headway in ousting SAS and SPSS from their thrones, and has become the tool of choice for the world’s best statisticians (and data scientists, and analysts too).

Why should you care?
Because it has `an unusually strong community around it`, you can find R libraries for almost anything under the sun — making virtually any kind of data science capability accessible without new code. R is exciting because of who is working on it, and how much net-new innovation is happening on a daily basis. the R community is one of the most thrilling places to be in Big Data right now.
R is a also wonderful way to future-proof your Big Data program. In the last few months, literally thousands of new features have been introduced, replete with publicly available knowledge bases for every analysis type you’d want to do as an organization.
`Also, R works very well with Hadoop`, making it an ideal part of an integrated Big Data approach.
`To keep an eye on: Julia is an interesting and growing alternative to R, because it combats R’s notoriously slow language interpreter problem. The community around Julia isn’t nearly as strong right now, but if you have a need for speed`
   
* Gremlin and Giraph
Gremlin and Giraph help empower `graph analysis`, and are `often used coupled with graph databases like Neo4j or InfiniteGraph`, or `in the case of Giraph, working with Hadoop`. Golden Orb is another high-profile example of a graph-based project picking up steam.
Graph databases are pretty cutting edge. They have interesting differences with relational databases, which mean that sometimes you might want to take a graph approach rather than a relational approach from the very beginning.
`The common analogue for graph-based approaches is Google’s Pregel, of which Gremlin and Giraph are open source alternatives`. In fact, here’s a great read on how mimicry of Google technologies is a cottage industry unto itself.

Why should you care?
Graphs do a great job of `modeling computer networks`, and `social networks`, too — anything that links data together. Another common use is mapping, and `geographic pathways` — calculating shortest routes for example, from place A to place B (or to return to the social case, tracing the proximity of stated relationships from person A to person B).
Graphs are also popular for `bioscience and physics` use cases for this reason — they can chart molecular structures unusually well, for example.

`Big picture, graph databases and analysis languages and frameworks` are a great illustration of how the world is starting to realize that Big Data is not about having one database or one programming framework that accomplishes everything. Graph-based approaches are a killer app, so to speak, for anything that involves large networks with many nodes, and many linked pathways between those nodes.
The most innovative scientists and engineers know to apply the right tool for each job, making sure everything plays nice and can talk to each other (the glue in this sense becomes the core competence).

* SAP Hana
SAP Hana is an `in-memory analytics platform` that includes an `in-memory database and a suite of tools` and software for creating analytical processes and moving data in and out, in the right formats.

Why should you care?
SAP is going against the grain of most entrenched enterprise mega-players by providing a very powerful product, free for development use. And it’s not only that — SAP is also creating meaningful incentives for startups to embrace Hana as well. They are authentically fostering community involvement and there is uniformly positive sentiment around Hana as a result.
Hana highly benefits any applications with unusually fast processing needs, such as `financial modeling and decision support, website personalization, and fraud detection`, among many other use cases.
The biggest drawback of Hana is that “in-memory” means that it by definition leverages access to solid state memory, which has clear advantages, but is much more expensive than conventional disk storage.
For organizations that don’t mind the added operational cost, Hana means incredible speed for very-low latency big data processing.

* Honorable mention: D3
D3 doesn’t make the list quite yet, but it’s close, and worth mentioning for that reason.
D3 is a `javascript document visualization library` that revolutionizes how powerfully and creatively we can visualize information, and make data truly interactive. It was created by Michael Bostock and came out of his work at the New York Times, where he is the Graphics Editor.
For example, you can use D3 to generate an HTML table from an array of numbers. Or, you can use the same data to create an interactive  bar chart with smooth transitions and interaction.
Here’s an example of D3 in action, making President Obama’s 2013 budget proposal understandable, and navigable.
`With D3, programmers can create dashboards galore`. Organizations of all sizes are quickly embracing D3 as a superior visualization platform to the heads-up displays of yesteryear.

#### Cloud computing

[For more information][cloud-computing-1]

Though there is no official definition and straight forward way to explain what exactly cloud computing is, but it can be expressed in general as the following statement:
“cloud computing is such a type of computing environment, where business owners `outsource their computing needs` including application software services to a third party and when they need to use the computing power or employees need to use the application resources like database, emails etc., they access the resources `via Internet`.”

__Cloud Computing Service Architecture__  
Mainly, 3 types of services you can get from a cloud service provider.
1. __Infrastructure as a service__- service provider bears all the cost of servers, networking equipment, storage, and back-ups. You just have to pay to take the computing service. And the users build their own application softwares. `Amazon EC2` is a great example of this type of service.
2. __Platform as a service__- service provider only provide platform or a stack of solutions for your users. It helps users saving investment on hardware and software. `Google Gc engine` and `Force.com` provide this type of service.
3. __Software as a service__- service provider will give your users the service of using their software, especially any type of applications software. Example-`Google (GOOG)`, `Salesforce.com (CRM)`, `NetSuite (N)`

__Why cloud computing?__  
The main advantage of using cloud computing facility is that customers do not have to pay for infrastructure installation and maintenance cost. As a user of cloud computing you have to pay the service charges according to your usage of computing power and other networking resources. Moreover, you no more have to worry about software updates, installation, email servers, anti-viruses, backups, web servers and both physical and logical security of your data. Thus, cloud computing can help you focus more on your core business competency.

__A cloud computing architecture example__

![cloud-computing-2]

#### Data streaming

Streaming data and real-time analytics
Easily handle millions of events per second with in-stream ETL and analytics

It’s not enough anymore to simply perform historical analysis and batch reports. In situations where you need to make well-informed decisions in real-time, the data and insights must also be timely and immediately actionable. Cloud::Streams lets you process data as it flows into your application, powering `real-time dashboards` and `on-the-fly analytics` and `delivering data seamlessly to Hadoop clusters and NoSQL databases`. Single-purpose ETL solutions are rapidly being replaced with `multi-node, multi-purpose data integration platforms` — the universal glue that connects systems together and makes Big Data analytics feasible. Cloud::Streams is a linearly scalable, fault-tolerant distributed routing framework for data integration, collection, and streaming data processing. Ready-to-go integration connectors allow you to tap into virtually any internal or external data source that your application needs.

Spark是一个基于内存计算的开源的集群计算系统，用Scala语言实现，构建在HDFS上，能与Hadoop很好的结合，而且运行速度比MapReduce快100倍。

![data_streaming_1]

#### peer-to-peer vs client-server
[For more information][distributed_misc_1]




---
[distributed_misc_1]:http://www.enterprise-technology.net/network3.htm "p2p vs cs"
[hadoop_1]:/resources/img/java/hadoop_1.png "Hadoop framework"
[hadostm_1op_2]:/resources/img/java/hadoop_2.png "Hadoop product line"
[stm_1]: https://en.wikipedia.org/wiki/Software_transactional_memory#Java "Software_transactional_memory"
[cluster_types_1]:https://www.centos.org/docs/5/html/Cluster_Suite_Overview/s1-clstr-basics-CSO.html "Cluster Types"
[cluster_1]:http://www.jfox.info/java-ji-qun-ji-shu-mian-shi-de-yi-xie-zhi-shi-zhun-bei "Cluster Overview"
[cluster_load_balance_algorithm_1]:http://blog.csdn.net/guzhouke19910920/article/details/7719361 "Load balance algorithm"
[cluster_load_balance_algorithm_2]:http://www.cnblogs.com/todsong/archive/2012/02/25/2368101.html "Load balance algorithm"
[big-data-open-source-tech-1]: https://techcrunch.com/2012/10/27/big-data-right-now-five-trendy-open-source-technologies/ "big-data-open-source-tech"
[big-data-1]:http://www.infochimps.com/ "Infochimps, the #1 Big Data platform in the cloud"
[cloud-computing-1]:https://hubpages.com/technology/cloud-computing-architecture "Cloud Computing Architecture Explained"
[cloud-computing-2]:/resources/img/java/cloud_computing_1.png "A cloud computing architecture example"
[data_streaming_1]:/resources/img/java/data_streaming_1.png "Stream vs Batch"
[mapreduce_1]:/resources/img/java/mapreduce_1.png "Map Reduce Flowchart"
[mapreduce_2]:/resources/img/java/mapreduce_2.png "Map Reduce Flowchart"
[mapreduce_example_1]:/resources/img/java/mapreduce_example_1.png "Map Reduce WordCount"
