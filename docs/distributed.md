## Distributed
---
* [Terms](#terms)
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
* [Grid computing](#grid-computing)
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
        + [peer-to-peer](#peer-to-peer)
        + [client-server](#client-server)
    - [Master-Slave](#master-slave)
    - [Master-Master](#master-master)
    - [Consensus Protocols](#consensus-protocols)
        + [Two-phase commit protocol (2PC)](#two-phase-commit-protocol-2pc)
        + [Three-phrase commit protocol (3PC)](#three-phrase-commit-protocol-3pc)
        + [Paxos Protocol](#paxos-protocol)
        + [The Byzantine Generals Problem](#the-byzantine-generals-problem)
        + [Comparations](consensus-protocol-comparations)
        + [Two Armies Problem](#two-armies-problem)
    - [Web Security techniques](#web-security-techniques)
    - [REST-Representational state transfer](rest-representational-state-transfer)
        + [Relationship between URI and HTTP Methods](relationship-between-uri-and-http-methods)
        + [Some common mistakes about RESTful](#some-common-mistakes-about-restful)
        + [SOAP Web Service vs RESTful Web Service](#soap-web-service-vs-restful-web-service)
    - [CAP theorem](#cap-theorem)
    - [Quorum NRW](#quorum-nrw)
    - [Consistency Model](#consistency-model)
    - [Fallacies of distributed computing](#fallacies-of-distributed-computing)
    - [3 results of distribute computing](#3-results-of-distribute-computing)
    - [Mobile Agent](#mobile-agent)
    - [Cache](#cache)

## Terms

**Personally identifiable information (PII)** is any data that could potentially identify a specific individual. Any information that can be used to distinguish one person from another and can be used for de-anonymizing anonymous data can be considered PII. 

The abbreviation **viz.** (or viz without a full stop), short for the Latin videlicet, is used as a synonym for "namely", "that is to say", "to wit", or "as follows".

__On-premises software__ (sometimes abbreviated as "on-prem") is installed and runs on computers on the premises (in the building) of the person or organization using the software, rather than at a remote facility such as a server farm or cloud. On-premises software is sometimes referred to as “shrinkwrap” software, and off-premises software is commonly called “software as a service” ("SaaS") or “cloud computing”.

__Fan-in__ is the number of inputs a gate can handle  
fan-in network 输入网络
fan-in factor 输入端数

__Network-attached storage (NAS)__ is a type of dedicated file storage device that provides local-area network local area network (LAN) nodes with file-based shared storage through a standard Ethernet connection. NAS devices, which typically do not have a keyboard or display, are configured and managed with a browser-based utility program. Each NAS resides on the LAN as an independent network node and has its own IP address.

__Fraud Detection Systems(FDS)__ Cases of card companies breaching their customers’ personal information are on the rise. Therefore, the Korea Financial Supervisory Service advised PG (Payment Gateway) companies, as well as card companies, to build Fraud Detection Systems (hereafter FDS), and FDS has become a necessary part of all the Korean payment systems. 

__TeraStream__ A Simplified "IP Network" Service Delivery Model

__SPOF__: Single point of failure

__C10k__: its a name given to the issue of optimizing the web server software to handle large number of requsts at one time. In the range of 10,000 requests at a time, hence the name

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

**The Long Term Resource Monitoring algorithms** are the best choice if you have a significant number of persistent connections. **Fastest** `works okay in this scenario also if you don’t have access to any of the dynamic solutions`.

* 最少连接：系统把新连接分配给当前连接数目最少的服务器。`该算法在各个服务器运算能力基本相似的环境中非常有效。`
Least Connections: With this method, the system passes a new connection to the server that has the least number of current connections. Least Connections methods work best in environments where the servers or other equipment you are load balancing have similar capabilities. This is a dynamic load balancing method, distributing connections based on various aspects of real-time server performance analysis, such as the current number of connections per node or the fastest node response time. This Application Delivery Controller method is rarely available in a simple load balancer.
最少连接数均衡算法对内部中需负载的每一台服务器都有一个数据记录，记录当前该服务器正在处理的连接数量，当有新的服务连接请求时，将把当前请求分配给连接数最少的服务器，使均衡更加符合实际情况，负载更加均衡。`此种均衡算法适合长时处理的请求服务，如FTP`。

* 观察算法：该算法同时利用最小连接算法和最快算法来实施负载均衡。服务器根据当前的连接数和响应时间得到一个分数，分数较高代表性能较好，会得到更多的连接。
Observed: The Observed method uses a combination of the logic used in the Least Connections and Fastest algorithms to load balance connections to servers being load-balanced. With this method, servers are ranked based on a combination of the number of current connections and the response time. Servers that have a better balance of fewest connections and fastest response time receive a greater proportion of the connections. This Application Delivery Controller method is rarely available in a simple load balancer.

* 预判算法：该算法使用观察算法来计算分数，但是预判算法会分析分数的变化趋势来判断某台服务器的性能正在改善还是降低。具有改善趋势的服务器会得到更多的连接。`该算法适用于大多数环境`。
Predictive: The Predictive method uses the ranking method used by the Observed method, however, with the Predictive method, the system analyzes the trend of the ranking over time, determining whether a servers performance is currently improving or declining. The servers in the specified pool with better performance rankings that are currently improving, rather than declining, receive a higher proportion of the connections. The Predictive methods work well in any environment. This Application Delivery Controller method is rarely available in a simple load balancer.

You can see with some of these algorithms that persistent connections would cause problems. Like Round Robin, if the connections persist to a server for as long as the user session is working, some servers will build a backlog of persistent connections that slow their response time. **The Long Term Resource Monitoring algorithms** are the best choice if you have a significant number of persistent connections. **Fastest** works okay in this scenario also if you don’t have access to any of the dynamic solutions.

### SOA

__Service-Oriented Architecture__ is `an application architecture` in which all functions, or services, are `defined using a description language` and `have invokable interfaces` that are called to perform business processes. Each interaction is `independent `of each and every other interaction and the interconnect protocols of the communicating devices (i.e., the infrastructure components that determine the communication system do not affect the interfaces).

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

### Grid computing
网格计算是通过Internet把分散在各处的硬件、软件、信息资源连结成为一个巨大的整体,从而使得人们能够利用地理上分散于各处的资源,完成各种大规 模的、复杂的计算和数据处理的任务。网格计算建立的是一种新型的Internet基础支撑结构,目标是将与Internet互联的计算机设施社会化。网格计算的发展非常迅速,数据网格、服务网格、计算网格等各种网格系统在全球范围内得到广泛的研究和实施。网格计算无疑是分布式计算技术通向计算时代的一个非常重要的里程碑。  

网格的体系结构是有效进行网格计算的重要基础,到目前为止比较重要的网格体系结构有两个:  
1. 一个是以Globus项目为代表的五层沙漏结构,它是一个以协议为中心的框架
2. 另一个是与Web服务相融合的开放网格服务结构OGSA(Open Grid Services Architecture),它与Web 服务一样都是以服务为中心。
 
但是,所有的网格系统都有这样一个基本的、公共的体系结构:资源层、中间件层和应用层。  
1. 网格资源层：它是构成网格系统的硬件基础。包括Internet各种计算资源,这些计算资源通过网络设备连接起来。
2. 网格中间件层:它是一系列工具和协议软件。其功能是屏蔽资源层中计算资源的分布、异构特性,向网格应用层提供透明、一致的使用接口。
3. 网格应用层:它是用户需求的具体体现。在网格操作系统的支持下,提供系统能接受的语言、Web 服务接口、二次开发环境和工具,并可配置支持工程应用、数据库访问的软件等。


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
key-value(键值)|Tokyo Cabinet/Tyrant, __Redis__, Voldemort, __Oracle BDB__|`内容缓存`，主要用于`处理大量数据的高访问负载`，也用于一些日志系统等等| Key 指向 Value 的键值对，通常用hash table来实现| 查找速度快|  `数据无结构化`，`通常只被当作字符串或者二进制数据`. 如果DBA只对部分值进行查询或更新的时候，Key/value就显得效率低下了
wide column(列存储数据库)|__Cassandra__, __HBase__, Riak|`分布式的文件系统`|    以列簇式存储，将同一列数据存在一起|   查找速度快，可扩展性强，`更容易进行分布式扩展`|  功能相对局限
document(文档型数据库)|__CouchDB__, __MongoDb__|Web应用(与Key-Value类似，Value是`结构化的`，不同的是数据库能够了解Value的内容)| Key-Value对应的键值对，`Value为结构化数据`, 比如JSON|  `数据结构要求不严格，表结构可变`，不需要像关系型数据库一样需要预先定义表结构|  `查询性能不高，而且缺乏统一的查询语法`
graph(图形)数据库|Neo4J, InfoGrid, Infinite Graph|`社交网络，推荐系统`等, 专注于构建关系图谱|图结构|利用图结构相关算法。比如最短路径寻址，N度关系查找等|很多时候需要对整个图做计算才能得出需要的信息，而且这种结构不太好做分布式的集群方案

>而且文档型数据库比键值数据库的查询效率更高??

##### NoSql Characteristics
对于NoSQL并没有一个明确的范围和定义，但是他们都普遍存在下面一些共同特征:  
1. 不需要预定义模式：不需要事先定义数据模式，预定义表结构。数据中的每条记录都可能有不同的属性和格式。当插入数据时，并不需要预先定义它们的模式
2. 无共享架构：相对于将所有数据存储的存储区域网络中的全共享架构, NoSQL往往将数据划分后存储在各个本地服务器上。因为从本地磁盘读取数据的性能往往好于通过网络传输读取数据的性能，从而提高了系统的性能。
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

`However, in practice STM systems also suffer a performance hit compared to fine-grained lock-based systems on small numbers of processors (1 to 4 depending on the application)`. This is due primarily to the overhead associated with maintaining the log and the time spent committing transactions. `Even in this case performance is typically no worse than twice as slow.`[5] Advocates of STM believe this penalty is justified by the conceptual benefits of STM.

In 2005, Tim Harris, Simon Marlow, Simon Peyton Jones, and Maurice Herlihy described an STM system built on Concurrent Haskell that enables arbitrary atomic operations to be composed into larger atomic operations, a useful concept impossible with lock-based programming. 

STM can be implemented as a lock-free algorithm or it can use locking.

#### Big Data open source trendy technologies
[For more informtaion][big-data-open-source-tech-1]

* Storm and Kafka  
Storm and Kafka are the future of stream processing, and they are already in use at a number of high-profile companies including Groupon, Alibaba, and The Weather Channel.  
Born inside of Twitter, Storm is a “distributed real-time computation system”. `Storm does for real-time processing what Hadoop did for batch processing.` Kafka for its part is a `messaging system` developed at LinkedIn to serve as the foundation for their activity stream and the data processing pipeline behind it.  
When paired together, you get the stream, you get it in-real time, and you get it at linear scale.  
Why should you care?  
`With Storm and Kafka, you can conduct stream processing at linear scale`, assured that every message gets processed in real-time, reliably. In tandem, Storm and Kafka can handle data velocities of tens of thousands of messages every second.  
Stream processing solutions like Storm and Kafka have caught the attention of many enterprises due to their superior approach to ETL (extract, transform, load) and data integration.  
Storm and Kafka are also great at `in-memory analytics`, and `real-time decision support`. Companies are quickly realizing that batch processing in Hadoop does not support real-time business needs. Real-time streaming analytics is a must-have component in any enterprise Big Data solution or stack, because of how elegantly they handle the “three V’s” — volume, velocity and variety.  
Storm and Kafka are the two technologies on the list that we’re most committed to at Infochimps, and it is reasonable to expect that they’ll be a formal part of our platform soon.

* Drill and Dremel  
Drill and Dremel make `large-scale, ad-hoc querying of data` possible, with radically lower latencies that are especially apt for `data exploration`. `They make it possible to scan over petabytes of data in seconds`, to answer ad hoc queries and presumably, power compelling visualizations.  
Drill and Dremel `put power in the hands of business analysts, and not just data engineers`. The business side of the house will love Drill and Dremel.
`Drill is the open source version of what Google is doing with Dremel` (Google also offers Dremel-as-a-Service with its BigQuery offering). Companies are going to want to make the tool their own, which why Drill is the thing to watch mostly closely. Although it’s not quite there yet, strong interest by the development community is helping the tool mature rapidly.  
Why should you care?  
Drill and Dremel compare favorably to Hadoop for `anything ad-hoc`. Hadoop is all about batch processing workflows, which creates certain disadvantages.
The Hadoop ecosystem worked very hard to make MapReduce an approachable tool for ad hoc analyses. `From Sawzall to Pig and Hive, many interface layers have been built on top of Hadoop to make it more friendly, and business-accessible.`  
Yet, for all of the SQL-like familiarity, these abstraction layers ignore one fundamental reality – MapReduce (and thereby Hadoop) is purpose-built for organized data processing (read: running jobs, or “workflows”).  
What if you’re not worried about running jobs? What if you’re more concerned with asking questions and getting answers — slicing and dicing, looking for insights?  
That’s “ad hoc exploration” in a nutshell — if you assume data that’s been processed already, how can you optimize for speed? You shouldn’t have to run a new job and wait, sometimes for considerable lengths of time, every time you want to ask a new question.  
`In stark contrast to workflow-based methodology, most business-driven BI and analytics queries are fundamentally ad hoc, interactive, low-latency analyses.` Writing Map Reduce workflows is prohibitive for many business analysts. Waiting minutes for jobs to start and hours for workflows to complete is not conducive to an interactive experience of data, the comparing and contrasting, and the zooming in and out that ultimately creates fundamentally new insights.
Some data scientists even speculate that Drill and Dremel may actually be better than Hadoop in the wider sense, and a potential replacement, even. That’s a little too edgy a stance to embrace right now, but there is merit in an approach to analytics that is more query-oriented and low latency.  
At Infochimps we like the **Elasticsearch full-text search engine** and database for doing high-level data exploration, but for truly capable Big Data querying at the (relative) seat level, we think that Drill will become the de facto solution.

* R  
R is an `open source statistical programming language`. It is incredibly powerful. `Over two million (and counting) analysts` use R. It’s been around `since 1997` if you can believe it. It is a modern version of the S language for statistical computing that originally came out of the Bell Labs. Today, R is quickly becoming the new standard for statistics.  
R performs complex data science at a much smaller price (both literally and figuratively). `R is making serious headway in ousting SAS and SPSS from their thrones`, and has become the tool of choice for the world’s best statisticians (and data scientists, and analysts too).  
Why should you care?  
Because it has `an unusually strong community around it`, you can find R libraries for almost anything under the sun — making virtually any kind of data science capability accessible without new code. R is exciting because of who is working on it, and how much net-new innovation is happening on a daily basis. the R community is one of the most thrilling places to be in Big Data right now.  
R is a also wonderful way to future-proof your Big Data program. In the last few months, literally thousands of new features have been introduced, replete with publicly available knowledge bases for every analysis type you’d want to do as an organization.  
`Also, R works very well with Hadoop`, making it an ideal part of an integrated Big Data approach.  
`To keep an eye on: Julia is an interesting and growing alternative to R, because it combats R’s notoriously slow language interpreter problem. The community around Julia isn’t nearly as strong right now, but if you have a need for speed`

* Gremlin and Giraph  
Gremlin and Giraph help empower `graph analysis`, and are `often used coupled with graph databases like Neo4j or InfiniteGraph`, or `in the case of Giraph, working with Hadoop`. Golden Orb is another high-profile example of a graph-based project picking up steam.  
Graph databases are pretty cutting edge. They have interesting differences with relational databases, which mean that sometimes you might want to take a graph approach rather than a relational approach from the very beginning.  
`The common analogue for graph-based approaches is Google’s Pregel, of which Gremlin and Giraph are open source alternatives`. In fact, here’s a great read on how mimicry of Google technologies is a cottage industry unto itself.  
Why should you care?  
Graphs do a great job of `modeling computer networks`, and `social networks`, too — anything that links data together. Another common use is mapping, and `geographic pathways` — calculating shortest routes for example, from place A to place B (or to return to the social case, tracing the proximity of stated relationships from person A to person B).  
Graphs are also popular for `bioscience and physics` use cases for this reason — they can chart molecular structures unusually well, for example.  
`Big picture, graph databases and analysis languages and frameworks` are a great illustration of how the world is starting to realize that Big Data is not about having one database or one programming framework that accomplishes everything. Graph-based approaches are a killer app, so to speak, for anything that involves large networks with many nodes, and many linked pathways between those nodes.  
The most innovative scientists and engineers know to apply the right tool for each job, making sure everything plays nice and can talk to each other (the glue in this sense becomes the core competence).

* SAP Hana  
SAP Hana is an `in-memory analytics platform` that includes an `in-memory database and a suite of tools` and software for creating analytical processes and moving data in and out, in the right formats.  
Why should you care?  
SAP is going against the grain of most entrenched enterprise mega-players by providing a very powerful product, free for development use. And it’s not only that — SAP is also creating meaningful incentives for startups to embrace Hana as well. They are authentically fostering community involvement and there is uniformly positive sentiment around Hana as a result.  
Hana highly benefits any applications with unusually fast processing needs, such as `financial modeling and decision support, website personalization, and fraud detection`, among many other use cases.  
The biggest drawback of Hana is that “in-memory” means that it by definition leverages access to solid state memory, which has clear advantages, but is much more expensive than conventional disk storage.  
For organizations that don’t mind the added operational cost, Hana means incredible speed for very-low latency big data processing.

* Honorable mention: D3  
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

##### peer-to-peer
A peer-to-peer network is often a reasonable choice in a `home network`, or other environment where significant growth in numbers of users or quantity of computer-based work is not expected, where `security` is not a serious concern, and where there is little or no need for major `system-wide services`.

The upside of the Peer-to-peer is that it is `relatively inexpensive` and `fairly simple to set up and manage`. The flip side is that it is limited in extensibility, tends to `overburden user workstations` by having them play the role of server to other users, is `largely unsecured`, and is typically `unable to provide system-wide services` since the typical workstation will run a standard desktop operating system incapable of hosting any major service

__Upside:__  
* suitable to home network, no significant growth
* relatively inexpensive, fairly simple to set up and manage
* 分布式的
* 系统可扩充性强
* 可持续性高

__Flip side:__  
* overburden user's computer
* largely unsecured
* no system-wide services 

与Client/Server模式相比，在实施P2P的系统中，服务器与客户端的界限消失或者淡化，系统中每个参与应用的节点均可以以“平等”的方式共享其他节点的共享资源，如cpu 、存储空间等。在P2P系统中，实体一般同时扮演两种角色：客户机和服务器。

从结构上看，P2P系统是`分布式的`，目前存在两类P2P系统：`混杂P2P系统与纯粹P2P系统`，前者由客户机与中央服务器构成，其典型案例为`Napster`，后者则完全由客户机构成，其典型案例为`Gnutella`

* Napster（混杂P2P系统）的工作模式
整个系统由客户机与目录服务器（中央服务器）构成，其工作模式如下：
1. `客户机向目录服务器发送搜索数据包，请求得到目标客户机的网络地址`
2. 录服务器收到数据包后，将目标客户机的地址发送给该客户机。
3. 客户机依据这些地址，向目标客户机发送请求。
4. 对方收到请求后，对之进行处理，将结果返回给发送方。
与传统的Client/Server模式相比，在非纯粹的P2P系统中，`中央服务器即目录服务器的功能已被极大的削弱，仅为客户机的寻址提供服务`，不再承担主要的运算工作。相反的，系统中的每个客户机均可以作为服务器，接受其他客户机发送的请求，为其他客户机提供服务，整个系统对中央服务器的依赖性明显降低。
 
* Gnutella（纯粹P2P系统）的工作模式
Gnutella系统完全由客户机构成，下面将以文件下载操作为例对其工作模式进行简单描述：
1. 客户机2向所有相邻客户机1、4、3发送搜索数据包，请求客户机1、4、3为其提供文件A的下载服务。
2. 客户机1、4、3将客户机2的搜索数据包转发给各自相邻的客户机5、6、7，该转发工作将在接到数据包的后续客户机上持续进行，`直至系统中所有客户机均收到该搜索数据包`。
3. 客户机1、3、4、5、6、7对自身数据进行查找，拥有文件A资源的客户机5、7向客户机2发送响应数据包。
4. 客户机2接收到响应数据包，`依据规则（如：路径最短规则）`，选择丛客户机7下载文件A。
 
根据以上的描述可以看出，在纯粹的P2P系统中，每个客户机自身具有发现其他客户机的能力，客户机不需要通过目录服务器就可以直接获取其他客户机的网络地址，从而从根本上摆脱了对中心服务器的依赖

#####　client-server

The client-server architecture is usually the correct choice, `even in a small business`, where `growth is anticipated`, `security` matters, and sophisticated `server-based services` will be beneficial to productivity.

The upside of the Client-server is that it can extend to handle organizational growth, allows user workstations to function as `unburdened clients`, can provide sophisticated system-wide services, and is configurable for maximum security.  The downside is obvious:   `higher initial capital investment` to establish, and a greater level of technology expertise required to configure and manage, as compared to the vanilla peer-to-peer network

__Upside:__  
* usually the correct choice, even in a small business
* growth is anticipated
* secure
* server-based services
* unburdened clients

__Downside:__  
* higher initial capital investment, hard to configure and manage
* 系统可扩充性弱
* 可持续性弱, 单点故障

##### In conclusion
On balance, however, a Client-server configuration is preferable to peer-to-peer, especially in a small business environment where there is an expectation of growth.

Well, why not start off with a peer-to-peer network architecture and then move up to client-server when the time comes?  Because, unless there is some overwhelming consideration to the contrary, it is likely more cost-effective and productivity-effective to begin with client-server, despite the initial cost difference.

#### Master-Slave
首先是Master-Slave结构，对于这种加构，Slave一般是Master的备份。在这样的系统中，一般是如下设计的：  
1. 读写请求都由Master负责。
2. 写请求写到Master上后，由Master同步到Slave上。

从Master同步到Slave上，你可以使用异步，也可以使用同步，可以使用Master来push，也可以使用Slave来pull。 通常来说是Slave来周期性的pull，所以，是`最终一致性`。这个设计的问题是，如果Master在pull周期内垮掉了，那么会导致这个时间片内的数据丢失。如果你不想让数据丢掉，Slave只能成为Read-Only的方式等Master恢复。
当然，如果你可以容忍数据丢掉的话，你可以马上让Slave代替Master工作（对于只负责计算的结点来说，没有数据一致性和数据丢失的问题，Master-Slave的方式就可以解决单点问题了） 当然，Master Slave也可以是强一致性的， 比如：当我们写Master的时候，Master负责先写自己，等成功后，再写Slave，两者都成功后返回成功，整个过程是同步的，如果写Slave失败了，那么两种方法，一种是标记Slave不可用报错并继续服务（等Slave恢复后同步Master的数据，可以有多个Slave，这样少一个，还有备份，就像前面说的写三份那样），另一种是回滚自己并返回写失败。（注：一般不先写Slave，因为如果写Master自己失败后，还要回滚Slave，此时如果回滚Slave失败，就得手工订正数据了）你可以看到，如果Master-Slave需要做成强一致性有多复杂。

#### Master-Master
Master-Master，又叫Multi-master，是指一个系统存在两个或多个Master，每个Master都提供read-write服务。这个模型是Master-Slave的加强版，数据间同步一般是通过Master间的异步完成，所以是`最终一致性`。 Master-Master的好处是，一台Master挂了，别的Master可以正常做读写服务，他和Master-Slave一样，当数据没有被复制到别的Master上时，数据会丢失。很多数据库都支持Master-Master的Replication的机制。
另外，如果多个Master对同一个数据进行修改的时候，这个模型的恶梦就出现了——对数据间的冲突合并，这并不是一件容易的事情。看看Dynamo的Vector Clock的设计（记录数据的版本号和修改者）就知道这个事并不那么简单，而且Dynamo对数据冲突这个事是交给用户自己搞的。就像我们的SVN源码冲突一样，对于同一行代码的冲突，只能交给开发者自己来处理。

#### Consensus Protocols
##### Two-phase commit protocol (2PC)
__两阶段提交协议__  
In transaction processing, databases, and computer networking, the two-phase commit protocol (2PC) is a type of atomic commitment protocol (ACP). It is a distributed algorithm that coordinates` all the processes that participate in a distributed atomic transaction on whether to commit or abort(roll back) the transaction` (it is a specialized type of consensus protocol). The protocol achieves its goal even in many cases of `temporary system failure` (involving either process, network node, communication, etc. failures), and is thus widely used. However, it is not resilient to all possible failure configurations, and in rare cases, user (e.g., a system's administrator) intervention is needed to remedy an outcome. To accommodate recovery from failure (automatic in most cases) the protocol's participants `use logging of the protocol's states`. Log records, which are typically slow to generate but survive failures, are used by the protocol's recovery procedures. Many protocol variants exist that primarily differ in logging strategies and recovery mechanisms. Though usually intended to be used infrequently, recovery procedures compose a substantial portion of the protocol, due to many possible failure scenarios to be considered and supported by the protocol.

__Assumptions:__  
The protocol works in the following manner:   
* one node is designated the coordinator, which is the master site, and the rest of the nodes in the network are designated the cohorts. 
* The protocol assumes that there is `stable storage at each node with a write-ahead log`, that no node crashes forever, that the data in the write-ahead log is never lost or corrupted in a crash
* any two nodes can communicate with each other. (not restrictive)

The last assumption is not too restrictive, as network communication can typically be rerouted. The first two assumptions are much stronger; if a node is totally destroyed then data can be lost.

![distributed_2pc_1]

__Basic algorithm:__  
1. Commit request phase(or voting phase)
    1. The coordinator sends `a query to commit message` to all cohorts and waits until it has received a reply from all cohorts.
    2. The cohorts `execute the transaction up to the point where they will be asked to commit`. They each write an entry to their undo `log` and an entry to their redo log.
    3. Each cohort `replies` with an agreement `message` (cohort votes Yes to commit), if the cohort's actions succeeded, or an abort message (cohort votes No, not to commit), if the cohort experiences a failure that will make it impossible to commit.

2. Commit phase(or Completion phase)
    1. Success  
    If the coordinator received an agreement message from all cohorts during the commit-request phase:  
        1. The coordinator sends `a commit message` to all the cohorts.
        2. Each cohort completes the operation, and `releases all the locks and resources held during the transaction`.
        3. Each cohort sends an `acknowledgment` to the coordinator.
        4. The coordinator `completes the transaction` when all acknowledgments have been received.
    2. Failure  
    If any cohort votes No during the commit-request phase (or the coordinator's timeout expires):  
        1. The coordinator sends `a rollback message` to all the cohorts.
        2. Each cohort `undoes the transaction` using the undo log, and releases the resources and locks held during the transaction.
        3. Each cohort sends an `acknowledgement` to the coordinator.
        4. The coordinator `undoes the transaction` when all acknowledgements have been received.

The `greatest disadvantage` of the two-phase commit protocol is that it is a `blocking protocol`. If the coordinator fails permanently, some cohorts will never resolve their transactions: After a cohort has sent an agreement message to the coordinator, it will block until a commit or rollback is received.

点评：2PC绝对是CP的死党，是分布式情况下强一致性算法，因此缺点也是很明显:
1. blocking protocol, 吞吐量不行，一旦某个participant第一阶段投了赞成票就得在他上面加独占锁，其他事务不得介入，直到当前事务提交or回滚
2. 单点coordinator是个严重问题, 没有热备机制，coordinator节点crash或者连接它的网路坏了会阻塞该事务

##### Three-phrase commit protocol (3PC)
[For more information][distributed_3pc_1]  
[For more information][distributed_3pc_2]  

In computer networking and databases, the three-phase commit protocol (3PC)[1] is a distributed algorithm which lets `all nodes` in a distributed system agree to commit a transaction. Unlike the two-phase commit protocol (2PC) however, 3PC is `non-blocking`. Specifically, 3PC `places an upper bound on the amount of time required before a transaction either commits or aborts`. This property ensures that if a given transaction is attempting to commit via 3PC and holds some resource locks, it will release the locks after the timeout.

In describing the protocol, we use terminology similar to that used in the two-phase commit protocol. Thus we have a single coordinator site leading the transaction and a set of one or more cohorts being directed by the coordinator.

![distributed_3pc_3]  
![distributed_3pc_4]  

The Three-phase commit protocol eliminates this problem by `introducing the Prepared to commit state`. If the coordinator fails before sending preCommit messages, the cohort will unanimously agree that the operation was aborted. The coordinator will not send out a doCommit message until all cohort members have ACKed that they are Prepared to commit. This eliminates the possibility that any cohort member actually completed the transaction before all cohort members were aware of the decision to do so

PS: differences between 3pc and 2pc  
* non blocking
* introducing the Prepared to commit state before coordinator sending commit message
* Timeout cause abort in most operations

Disadvantages  
`The main disadvantage to this algorithm is that it cannot recover in the event the network is segmented in any manner`. The original 3PC algorithm assumes a fail-stop model, where processes fail by crashing and crashes can be accurately detected, and does not work with network partitions or asynchronous communication.
Keidar and Dolev's E3PC algorithm eliminates this disadvantage.
The protocol requires at least 3 round trips to complete, needing a minimum of 3 round trip times (RTTs). This is potentially a long latency to complete each transaction.

`三段提交的核心理念是：在询问的时候并不锁定资源，除非所有人都同意了，才开始锁资源`

其实，三段提交是一个很复杂的事情，`实现起来相当难`，而且也有一些问题。

##### Paxos Protocol
Paxos is a family of protocols for solving consensus in a network of unreliable processors

><分布式系统的事务处理>：
Google Chubby的作者Mike Burrows说过这个世界上只有一种一致性算法，那就是Paxos，其它的算法都是残次品

[For more information][distributed_paxos_1]  

>Paxos在原作者的《Paxos Made Simple》中内容是比较精简的：
>1. Phase 1
>    1. A proposer selects a proposal number n and sends a prepare request with number n to a majority of acceptors.
>    2. If an acceptor receives a prepare request with number n greater than that of any prepare request to which it has already responded, then it responds to the request with a promise not to accept any more proposals numbered less than n and with the highest-numbered proposal (if any) that it has accepted.
>2. Phase 2
>    1. If the proposer receives a response to its prepare requests (numbered n) from a majority of acceptors, then it sends an accept request to each of those acceptors for a proposal numbered n with a value v , where v is the value of the highest-numbered proposal among the responses, or is any value if the responses reported no proposals.
>    2. If an acceptor receives an accept request for a proposal numbered n, it accepts the proposal unless it has already responded to a prepare request having a number greater than n.

###### Basic Paxos
This protocol is the most basic of the Paxos family. Each instance of the Basic Paxos protocol decides on a single output value. The protocol proceeds over several rounds. A successful round has two phases. A Proposer should not initiate Paxos if it cannot communicate with at least a Quorum of Acceptors:  

1. Phase 1
    1. Phase 1a: Prepare  
    A Proposer (the leader) creates a proposal identified with a number N. This number must be greater than any previous proposal number used by this Proposer. Then, it sends a Prepare message containing this proposal to a Quorum of Acceptors. The Proposer decides who is in the Quorum.
    2. Phase 1b: Promise  
    If the proposal's number N is higher than any previous proposal number received from any Proposer by the Acceptor, then the Acceptor must return a promise to ignore all future proposals having a number less than N. If the Acceptor accepted a proposal at some point in the past, it must include the previous proposal number and previous value in its response to the Proposer.  
    Otherwise, the Acceptor can ignore the received proposal. It does not have to answer in this case for Paxos to work. However, for the sake of optimization, sending a denial (Nack) response would tell the Proposer that it can stop its attempt to create consensus with proposal N.
2. Phase 2
    1. Phase 2a: Accept Request  
    If a Proposer receives enough promises from a Quorum of Acceptors, it needs to set a value to its proposal. If any Acceptors had previously accepted any proposal, then they'll have sent their values to the Proposer, who now must set the value of its proposal to t`he value associated with the highest proposal number` reported by the Acceptors. If none of the Acceptors had accepted a proposal up to this point, then the Proposer may choose any value for its proposal.  
    The Proposer sends an Accept Request message to a Quorum of Acceptors with the chosen value for its proposal.
    2. Phase 2b: Accepted  
    If an Acceptor receives an Accept Request message for a proposal N, it must accept it if and only if it has not already promised to any prepare proposals having an identifier greater than N. In this case, it should register the corresponding value v and` send an Accepted message to the Proposer and every Learner.` Else, it can ignore the Accept Request.  

3. Rounds fail when multiple Proposers send conflicting Prepare messages, or when the Proposer does not receive a Quorum of responses (Promise or Accepted). In these cases, another round must be started with a higher proposal number.  

Note that an Acceptor can accept multiple proposals. These proposals may even have different values in the presence of certain failures. However, the Paxos protocol will guarantee that the Acceptors will ultimately agree on a single value.  

Notice that when Acceptors accept a request, they also acknowledge the leadership of the Proposer. Hence, `Paxos can be used to select a leader in a cluster of nodes.`

**Quorums** express the safety properties of Paxos by ensuring at least some surviving processor retains knowledge of the results.
Quorums are defined as subsets of the set of Acceptors such that any two subsets (that is, any two Quorums) share at least one member. Typically, a Quorum is any majority of participating Acceptors. For example, given the set of Acceptors {A,B,C,D}, a majority Quorum would be any three Acceptors: {A,B,C}, {A,C,D}, {A,B,D}, {B,C,D}. More generally, arbitrary positive weights can be assigned to Acceptors and a Quorum defined as any subset of Acceptors with the summary weight greater than half of the total weight of all Acceptors.

Here is a graphic representation of the Basic Paxos protocol. Note that the values returned in the Promise message are null the first time a proposal is made, since no Acceptor has accepted a value before in this round.

__Message flow: Basic Paxos__  
(first round is successful)

![distributed_paxos_img_1]
 
Vn = highest of (Va,Vb,Vc)

__Another message flow chart from other resource:__  
![distributed_paxos_img_6]  

PS: there are some notices,   
* MaxN and AcceptedN should be same thing in Basic Paxos
* in 1st flow, acceptor notices all proposers and learners, however, in 2nd flow, proposer does the job

至于Paxos中一直提到的一个全局唯一且递增的proposer number，其如何实现，引用如下：  
>如何产生唯一的编号呢？在《Paxos made simple》中提到的是让所有的Proposer都从不相交的数据集合中进行选择，例如系统有5个Proposer，则可为每一个Proposer分配一个标识j(0~4)，则每一个proposer每次提出决议的编号可以为5*i + j(i可以用来表示提出议案的次数)

[For more information][distributed_paxos_2]

paxos虽然也是分布式情况下强一致性算法，但他在2PC上至少有两点改进  
1. 无单点失败. 不存在说网路问题导致事务阻塞甚至失败, 尤其是连接coordinator的，因为paxos的角色是可以互串的，必要时participant也能充当coordinator
2. non blocking. 加在任何一个在1b2b阶段投了赞成票的participant上的锁是可以被砸开的：只要新提案的编号更大，这样就提高吞吐量了，当然频繁的产生新proposer可能会导致活锁：永远无法达成协议，最好设置一个超时机制，过了一定的时间才产生一个proposer

###### Multi-Paxos
If each command is the result of a single instance of the Basic Paxos protocol a significant amount of overhead would result. The paper Paxos Made Simple[17] defines Paxos to be what is commonly called "Multi-Paxos" which `in steady state uses a distinguished leader to coordinate an infinite stream of commands`. A typical deployment of Paxos uses a continuous stream of agreed values acting as commands to update a distributed state machine.  
`If the leader is relatively stable, phase 1 becomes unnecessary. Thus, it is possible to skip phase 1 for future instances of the protocol with the same leader.`  
To achieve this, the instance number I is included along with each value. Multi-Paxos reduces the failure-free message delay (proposal to learning) from 4 delays to 2 delays.

1. Message flow: Multi-Paxos, start
(first instance with new leader)

![distributed_paxos_img_2]

Vm = highest of (Va, Vb, Vc)  
2. Message flow: Multi-Paxos, steady-state
(subsequent instances with same leader)

![distributed_paxos_img_3]  

###### Byzantine Paxos
Paxos may also be extended to support `arbitrary failures of the participants`, including `lying`, `fabrication of messages`, `collusion with other participants`, `selective non-participation`, etc. These types of failures are called __Byzantine failures__, after the solution popularized by Lamport.
`Byzantine Paxos adds an extra message (Verify) which acts to distribute knowledge and verify the actions of the other processors:`  
__Message flow: Byzantine Multi-Paxos, steady state__  

![distributed_paxos_img_4]  

Fast Byzantine Paxos removes this extra delay, since the` client sends commands directly to the Acceptors.`

Note the Accepted message in Fast Byzantine Paxos is sent to all Acceptors and all Learners, while Fast Paxos sends Accepted messages only to Learners

__Message flow: Fast Byzantine Multi-Paxos, steady state__  
![distributed_paxos_img_5]  

###### Paxos applications

1. database replication, log replication等  
如bdb的数据复制就是使用paxos兼容的算法。`Paxos最大的用途就是保持多个节点数据的一致性`
2. naming (and directory) service  
如大型系统内部通常存在多个接口服务相互调用。通常的做法有
* static  
通常的实现是将服务的ip/hostname写死在配置中，当service发生故障时候，通过手工更改配置文件或者修改DNS指向的方法来解决。缺点是可维护性差，内部的单元越多，故障率越大
* LVS双机冗余的方式  
缺点是所有单元需要双倍的资源投入  
通过Paxos算法来管理所有的naming服务，则可保证high available分配可用的service给client。象ZooKeeper还提供watch功能，即watch的对象发生了改变会自动发notification, 这样所有的client就可以使用一致的，高可用的接口
3. config配置管理  
* 通常手工修改配置文件的方法，这样容易出错，也需要人工干预才能生效，所以节点的状态无法同时达到一致。
* 大规模的应用都会实现自己的配置服务，比如用http web服务来实现配置中心化。它的缺点是更新后所有client无法立即得知，各节点加载的顺序无法保证，造成系统中的配置不是同一状态。
4. membership用户角色/access control list  
比如在权限设置中，用户一旦设置某项权限比如由管理员变成普通身份，这时应在所有的服务器上所有远程CDN立即生效，否则就会导致不能接受的后果。
5. ID generation  
通常简单的解决方法是用数据库自增ID, 这导致数据库切分困难，或程序生成GUID, 这通常导致ID过长。更优雅的做法是`利用paxos算法在多台replicas之间选择一个作为master`, 通过master来分配号码。当master发生故障时，再用paxos选择另外一个master。

这里列举了一些常见的Paxos应用场合，对于类似上述的场合，如果用其它解决方案，一方面不能提供自动的高可用性方案，同时也远远没有Paxos实现简单及优雅。

Yahoo!开源的ZooKeeper是一个开源的类Paxos实现。它的编程接口看起来很像一个可提供强一致性保证的分布式小文件系统。`对上面所有的场合都可以适用`.但可惜的是，ZooKeeper并不是遵循Paxos协议，而是基于自身设计并优化的一个2 phase commit的协议，因此它的理论[6]并未经过完全证明。但由于ZooKeeper在Yahoo!内部已经成功应用在HBase, Yahoo! Message Broker, Fetch Service of Yahoo! crawler等系统上，因此完全可以放心采用。

这里要补充一个背景，就是要证明分布式容错算法的正确性通常比实现算法还困难，Google没法证明Chubby是可靠的，Yahoo!也不敢保证它的ZooKeeper理论正确性。大部分系统都是靠在实践中运行很长一段时间才能谨慎的表示，目前系统已经基本没有发现大的问题了。

##### The Byzantine Generals Problem

[For more information 1][distributed_byzantine_1]  
[For more information 2][distributed_byzantine_2]  
[For more information 3][distributed_byzantine_3]  

Also called __Byzantine fault tolerance__  
[For more information 4][distributed_byzantine_4]  

__关于拜占庭将军问题，一个简易的非正式描述如下：__  
拜占庭帝国想要进攻一个强大的敌人，为此派出了10支军队去包围这个敌人。这个敌人虽不比拜占庭帝国，但也足以抵御5支常规拜占庭军队的同时袭击。基于一些原因，这10支军队不能集合在一起单点突破，必须在分开的包围状态下同时攻击。他们任一支军队单独进攻都毫无胜算，除非有至少6支军队同时袭击才能攻下敌国。他们分散在敌国的四周，依靠通信兵相互通信来协商进攻意向及进攻时间。困扰这些将军的问题是，他们不确定他们中是否有叛徒，叛徒可能擅自变更进攻意向或者进攻时间。在这种状态下，拜占庭将军们能否找到一种分布式的协议来让他们能够远程协商，从而赢取战斗？这就是著名的拜占庭将军问题。

应该明确的是，拜占庭将军问题中并不去考虑通信兵是否会被截获或无法传达信息等问题，即消息传递的信道绝无问。`Lamport已经证明了在消息可能丢失的不可靠信道上试图通过消息传递的方式达到一致性是不可能的`。所以，`在研究拜占庭将军问题的时候，我们已经假定了信道是没有问题的`，并在这个前提下，去做一致性和容错性相关研究。如果需要考虑信道是有问题的，这涉及到了另一个相关问题：两军问题。

形式化条件的推演:  
定义一个变量vi，作为其他将军收到的第i个将军的命令值；j将军会将把自己的判断作为vj。可以想象，由于叛徒的存在，各个将军收到的vi值不一定是相同的。之后，定义一个函数来处理向量(v1,v2,…,vn)，代表了多数人的意见(majority(v1,v2,...,vn))，各将军用这个函数的结果作为自己最终采用的命令。至此，我们可以利用这些定义来形式化这个问题，用以匹配一致性和正确性

* 一致性  
条件1：每一个忠诚的将军必须得到相同的(v1,v2,…,vn)指令向量或者指令集合。
* 正确性  
条件2：若i将军是忠诚的，其他忠诚的将军必须以他送出的值作为vi。

可以将问题改为一系列的司令-副官模式来简化问题，即一个司令把自己的命令传递给n-1个副官，使得：
* IC1：所有忠诚的副官遵守一个命令，即一致性。
* IC2：若司令是忠诚的，每一个忠诚的副官遵守他发出的命令，即正确性。

__The problem can be restated as:__  
1. All loyal generals receive the same information upon which they will somehow get to the same decision
2. The information sent by a loyal general should be used by all the other loyal generals

__The above problem can be reduced into a series of one commanding general and multiple lieutenants problem - Byzantine Generals Problem:__  
* All loyal lieutenants obey the same order
* If the commanding general is loyal, then every loyal lieutenant obeys the order she sends

__Another variant: Reliability by Majority Voting__   
One way to achieve reliability is to have multiple replica of system (or component) and take the majority voting among them

In order for the majority voting to yield a reliable system, the following two conditions should be satisfied:  
* All non-faulty components must use the same input value
* If the input unit is non-faulty, then all non-faulty components use the value it provides as input

在经典的情形下，我们可以找到两种办法，`口头协议和书面协议`

###### Oral Messages - No Signature 口头协议
__Oral Message Requirements and their Implications__  
1. A1 - Every message that is sent is delivered correctly  
    * The failure of communication medium connecting two components is indistinguishable from component failure.  
    * Line failure just adds one more traitor component.  
2. A2 - The receiver of a message knows who sent it  
    * No switched network is allowed
    * The later requirement -- A4 nullifies this constraint
3. A3 - The absence of a message can be detected  
    * Timeout mechanism is needed

or to say in short,   
1. A1：每个被发送的消息都能够被正确的投递
2. A2：信息接收者知道是谁发送的消息
3. A3：能够知道缺少的消息

__Solution:__  
采用口头协议，若叛徒数少于1/3，则拜占庭将军问题可解。也就是说，若叛徒数为m，当将军总数n至少为3m+1时，问题可解（即满足了IC1和IC2）。

Lamport’s algorithm is a recursive definition, with a base case for m=0, and a recursive step for m > 0:  

* Algorithm OM(0)  
    1. The general sends his value to every lieutenant.
    2. Each lieutenant uses the value he receives from the general.
* Algorithm OM(m), m > 0
    1. The general sends his value to each lieutenant.
    2. Populate (v1, v2, … vn) for each lieutenant
        1. Calculate vi.  
        For each i, let vi be the value lieutenant i receives from the general. Lieutenant i acts as the general in Algorithm OM(m-1) to send the value vi to each of the n-2 other lieutenants.
        2. Calculate vj (j ≠ i).  
        For each i, and each j ≠ i, let vi(?? should be vj) be the value lieutenant i received from lieutenant j in step 2 (using Algorithm (m-1)). Lieutenant i uses the value majority (v1, v2, … vn). (PS: use it as the new vi, and send to all other lieutenants for next round)

若任何一步没有命令则默认为撤退命令

###### 书面协议
__Additional Requirements:__  
* A4:  
A loyal general's `signature` cannot be forged  
Anyone can verify the authenticity of a general's signature  

__Implication__:  
Digital signature is required

__Solution:__  
If at least two generals are loyal, this problem can be solved

Algorithm - recursive  
* Lieutenants recursively augment orders `with their signature` and forward them to all the other lieutenants
* ...

我们用集合Vi来表示i副官收到的命令集，这是一个集合，也就是满足互异性（没有重复的元素）等集合的条件。类似的，我们定义choice(V)函数来决定各个副官的选择，这个函数可以有非常多种形式，他只要满足了以下两个条件：  
1. 如果集合V只包含了一个元素v，那么choice(V)=v
2. choice(o)=RETREAT，其中o是空集  

任何满足了这两个条件的函数都可以作为choice()，例如取平均值就可以。我们只需要根据具体情形定义choice()即可

之后我们会发现SM(m)算法并不是一个递归算法，`我们只要让各个副官收到的V集相同`，choice(V)也一定能够得到相同的值。
1. 初始化Vi=空集合。
2. 将军签署命令并发给每个副官
3. 对于每个副官i  
    1. 如果副官i从发令者收到v:0的消息，且还没有收到其他命令序列  
        1. 那么他使Vi为{v}
        2. 发送v:0:i给其他所有副官。
    2. 如果副官i收到了形如v:0:j1:…:jk的消息且v不在集合Vi中  
        1. 那么他添加v到Vi
        2. 如果k\<m，那么发送v:0:j1:…:jk:i 给每个不在j1,..,jk 中的副官>
4. 对于每个副官i，当他不再收到任何消息，则遵守命令choive(Vi)

PS: in short,  
* use Set instead of vector
* message is only sent to unreached lieutenants, no duplicated messaging
* with signature

`书面协议的本质就是引入了签名系统`，这使得所有消息都可追本溯源。这一优势，`大大节省了成本`，`他化解了口头协议中1/3要求`，只要采用了书面协议，忠诚的将军就可以达到一致（实现IC1和IC2）。这个效果是惊人的，相较之下口头协议则明显有一些缺陷。

观察A1~A4，我们做了一些在现实中比较难以完成的假设，比如没考虑传输信息的延迟时间，`书面协议的签名体系难以实现`，而且签名消息记录的保存难以摆脱一个中心化机构而独立存在。事实上，`存在能够完美解决书面协议实际局限的方法，这个方法就是区块链`.

如果您感兴趣，也可以参考笔者同系列的文章《大材小用——用区块链解决拜占庭将军问题》。

###### Missing Communication Paths
Network topology or policy could keep a general sending/receiving messages to/from another general, this constraint makes Byzantine problem more general

1. Oral Message  
__Conclusion__:  
If the communication graph is 3m-regular and less than or equal to m generals are traitors, this problem can be solved.

__k regular set of neighbors of a node p__  
* the set of all neighbors of p, whose size is k 
* for any node not in the set, there exists a disjoint path, not passing through the node p, from a node in the set

`k regular graph - every node has k regular set of neighbors`

__Solution:__  
Lieutenants recursively forward orders to all its k regular neighbors

2. Signed Message  
__Conclusion:__  If the subgraph of loyal generals is connected, this problem can be solved

###### Byzantine fault tolerance in practice

* bitcoin. One example of BFT in use is `bitcoin`, a peer-to-peer digital currency system. The bitcoin network works in parallel to generate a chain of Hashcashstyle proof-of-work. The proof-of-work chain is the key to overcome Byzantine failures and to reach a coherent global view of the system state.

* Some aircraft systems, such as the Boeing 777 Aircraft Information Management System (via its ARINC 659 SAFEbus® network), the Boeing 777 flight control system, and the Boeing 787 flight control systems, use Byzantine fault tolerance. Because these are real-time systems, their Byzantine fault tolerance solutions must have very low latency. For example, SAFEbus can achieve Byzantine fault tolerance with on the order of a microsecond of added latency.

* Some spacecraft such as the SpaceX Dragon flight system and the NASA Crew Exploration Vehicle consider Byzantine fault tolerance in their design.

##### Consensus Protocol Comparations

下图来自：Google App Engine的co-founder Ryan Barrett在2009年的google i/o上的演讲《Transaction Across DataCenter》

items       |Backups        |M/S        |MM         |2PC        |Paxos
------------|---------------|-----------|-----------|-----------|------
Consistency |Weak           |Eventual   |Eventual   |Strong     |Strong
Transactions|No             |Full       |Local      |Full       |Full
Latency     |Low            |Low        |Low        |High       |High
Throughput  |High           |High       |High       |Low        |Medium
Data Loss   |Lots           |Some       |Some       |None       |None
Failover    |Down           |Read only  |Read/Write |Read/Write |Read/Write

![distributed_consensus_protocol_compare_img_1]

##### Two Armies Problem
正如前文所说，拜占庭将军问题和两军问题实质是不一样的。国内大量解释拜占庭将军问题的文章将两者混为一谈，其实是混淆了两个问题的实质，由此造成了许多误解。这两个问题看起来的确有点相似，但是问题的前提和研究方向都截然不同。

![distributed_2armies_img_1]

如图1所示，白军驻扎在沟渠里，蓝军则分散在沟渠两边。白军比任何一支蓝军都更为强大，但是蓝军若能同时合力进攻则能够打败白军。他们不能够远程的沟通，只能派遣通信兵穿过沟渠去通知对方蓝军协商进攻时间。是否存在一个能使蓝军必胜的通信协议，这就是两军问题。  
看到这里您可能发现两军问题和拜占庭将军问题有一定的相似性，但我们必须注意的是，通信兵得经过敌人的沟渠，在这过程中他可能被捕，也就是说，两军问题中信道是不可靠的，并且其中没有叛徒之说，这就是两军问题和拜占庭将军问题的根本性不同。由此可见，大量混淆了拜占庭将军问题和两军问题的文章并没有充分理解两者。  
两军问题的根本问题在于信道的不可靠，反过来说，如果传递消息的信道是可靠的，两军问题可解。然而，并不存在这样一种信道，所以两军问题在经典情境下是不可解的，为什么呢？  
倘若1号蓝军（简称1）向2号蓝军（简称2）派出了通信兵，若1要知道2是否收到了自己的信息，1必须要求2给自己传输一个回执，说“你的信息我已经收到了，我同意你提议的明天早上10点9分准时进攻”。  
然而，就算2已经送出了这条信息，2也不能确定1就一定会在这个时间进攻，因为2发出的回执1并不一定能够收到。所以，1必须再给2发出一个回执说“我收到了”，但是1也不会知道2是否收到了这样一个回执，所以1还会期待一个2的回执。  
虽然看似很可笑，但在这个系统中永远需要存在一个回执，这对于两方来说都并不一定能够达成十足的确信。更要命的是，我们还没有考虑，通信兵的信息还有可能被篡改。由此可见，经典情形下两军问题是不可解的，并不存在一个能使蓝军一定胜利的通信协议。  
不幸的是，两军问题作为现代通信系统中必须解决的问题，我们尚不能将之完全解决，这意味着你我传输信息时仍然可能出现丢失、监听或篡改的情况。但我们能不能通过一种相对可靠的方式来解决大部分情形呢？这需要谈到TCP协议。事实上，搜索“两军问题与三次握手”，您一定可以找到大量与TCP协议相关的内容。若您是通信方面的专家，权当笔者是班门弄斧，这里仅用最浅显易懂的方式科普TCP协议的原理和局限，可能存在一些毛刺，请多包涵。  

![distributed_2armies_img_2]

TCP协议中，A先向B发出一个随机数x，B收到x了以后，发给A另一个随机数y以及x+1作为答复，这样A就知道B已经收到了，因为要破解随机数x可能性并不大；然后A再发回y+1给B，这样B就知道A已经收到了。这样，A和B之间就建立一个可靠的连接，彼此相信对方已经收到并确认了信息。  
而事实上，A并不会知道B是否收到了y+1；并且，由于信道的不可靠性，x或者y都是可能被截获的，这些问题说明了即使是三次握手，也并不能够彻底解决两军问题，只是在现实成本可控的条件下，我们把TCP协议当作了两军问题的现实可解方法。

![distributed_2armies_img_3]

那么，是否能够找到一个理论方法来真正的破解两军问题呢？答案是有的，量子通讯协议，笔者并没有能力弄清这个颇为高深的问题。据我的理解，处于量子纠缠态的两个粒子，无论相隔多远都能够彼此同步，光是直观的来看，这个效应可以用来实现保密通讯。  
但是由于测不准原理，一测量粒子状态就会改变其状态，所以通讯时还必须通过不可靠信道发送另一条信息。尽管这个“另一条信息”是不可靠的，但是由于已经存在了一条绝对可靠的信道（量子纠缠），保证了另一条信道即使不可靠也能保证消息是可靠的，否则至少被窃取了一定能够被发现。  
因此我们可以相信，至少理论上两军问题是可解的，即存在一种方法，即使利用了不可靠的信道，也能保证信息传递的可靠性。所以，在确保了信道可靠的基础上，我们可以回到拜占庭将军问题上继续讨论。

#### Web Security techniques

1. 以`“保护”`为目的的第一代网络安全技术
2. 以`“保障”`为目的的第二代网络安全技术
3. 以`“生存”`为目的的第三代网络安全技术

* 第一代网络安全技术`通过划分明确的网络边界`，利用各种`保护和隔离的技术手段`，如`用户鉴别和认证`、`存取控制`、`权限管理和信息加解密`等，试图在网络边界上阻止非法入侵，达到信息安全的目的。第一代网络安全技术解决了很多安全问题，但并不是在所有情况下都有效，由于无法清晰地划分和控制网络边界，`第一代网络安全技术对一些攻击行为如计算机病毒、用户身份冒用、系统漏洞攻击等就显得无能为力`，于是出现了第二代网络安全技术。

* 第二代网络安全技术`以检测技术为核心`，`以恢复技术为后盾`，融合了保护、检测、响应、恢复四大技术。它通过检测和恢复技术，发现网络系统中异常的用户行为，根据事件的严重性，`提示系统管理员，采取相应的措施`。由于系统漏洞千差万别，攻击手法层出不穷，不可能完全正确地检测全部的攻击行为，因此，必须用新的安全技术来保护信息系统的安全。

* 第三代网络安全技术是一种信息生存技术，卡耐基梅隆大学的学者给这种生存技术下了一个定义：`所谓“生存技术”就是系统在攻击、故障和意外事故已发生的情况下，在限定时间内完成使命的能力`。它假设我们不能完全正确地检测对系统的入侵行为，当入侵和故障突然发生时，能够利用“容忍”技术来解决系统的“生存”问题，以确保信息系统的保密性、完整性、真实性、可用性和不可否认性  
无数的网络安全事件告诉我们，网络的安全仅依靠“堵”和“防”是不够的。 `入侵容忍技术`就是基于这一思想，要求系统中任何单点的失效或故障不至于影响整个系统的运转。由于任何系统都可能被攻击者占领，因此，`入侵容忍系统不相信任何单点设备`。`入侵容忍可通过对权力分散及对技术上单点失效的预防`，保证任何少数设备、任何局部网络、任何单一场点都不可能做出泄密或破坏系统的事情，任何设备、任何个人都不可能拥有特权。因而，入侵容忍技术同样能够有效地防止内部犯罪事件发生。

入侵容忍技术的实现主要有两种途径  
* 第一种方法是`攻击响应`，通过检测到局部系统的失效或估计到系统被攻击，而`加快反应时间，调整系统结构，重新分配资源`，使信息保障上升到一种在攻击发生的情况下能够继续工作的系统。可以看出，这种实现方法依赖于“入侵判决系统”是否能够及时准确地检测到系统失效和各种入侵行为
* 另一种实现方法则被称为`“攻击遮蔽”`，技术。就是待攻击发生之后，整个系统好像没什么感觉。该方法`借用了容错技术的思想，就是在设计时就考虑足够的冗余`，保证当部分系统失效时，整个系统仍旧能够正常工作。

多方安全计算的技术、门槛密码技术、Byzantine协议技术等成为入侵容忍技术的理论基础。

#### REST-Representational state transfer
[For more information][restful_1]  

In computing, __representational state transfer (REST)__ is an architectural style consisting of a coordinated set of components, connectors, and data elements within a distributed hypermedia system, where the focus is on component roles and a specific set of interactions between data elements rather than implementation details.Its purpose is to induce `performance, scalability`, `simplicity`, `modifiability`, visibility, portability, and reliability. REST is the software architectural style of the World Wide Web.

The term representational state transfer was introduced and defined in 2000 by Roy Fielding in his doctoral dissertation at UC Irvine. REST has been applied to describe desired web architecture, to identify existing problems, to compare alternative solutions and to ensure that protocol extensions would not violate the core constraints that make the web successful.` Fielding used REST to design HTTP 1.1 and Uniform Resource Identifiers (URI).`
To the extent that systems conform to the constraints of REST they can be called RESTful. `RESTful systems typically, but not always, communicate over Hypertext Transfer Protocol (HTTP) with the same HTTP verbs (GET, POST, PUT, DELETE, etc.) that web browsers use to retrieve web pages and to send data to remote servers.` `REST systems interface with external systems as web resources identified by Uniform Resource Identifiers (URIs), for example /people/tom, which can be operated upon using standard verbs such as GET /people/tom.`  
The name "Representational State" is intended to evoke an image of how a well-designed Web application behaves: `a network of web pages (a virtual state-machine)`, where the user progresses through the application by selecting links (state transitions), resulting in the next page (representing the next state of the application) being transferred to the user and rendered for their use.

Scalability to support large numbers of components and interactions among components. Roy Fielding, one of the principal authors of the HTTP specification, describes REST's effect on scalability as follows:
REST's client–server separation of concerns simplifies component implementation, reduces the complexity of connector semantics, improves the effectiveness of performance tuning, and increases the scalability of pure server components. Layered system constraints allow intermediaries—proxies, gateways, and firewalls—to be introduced at various points in the communication without changing the interfaces between components, thus allowing them to assist in communication translation or improve performance via large-scale, shared caching. REST enables intermediate processing by constraining messages to be self-descriptive: interaction is stateless between requests, standard methods and media types are used to indicate semantics and exchange information, and responses explicitly indicate cacheability.

__Architectural constraints__  
The architectural properties of REST are realized by applying specific interaction constraints to components, connectors, and data elements.One can characterise applications conforming to the REST constraints described in this section as "RESTful". If a service violates any of the required constraints, it cannot be considered RESTful. Complying with these constraints, and thus conforming to the REST architectural style, enables any kind of distributed hypermedia system to have desirable non-functional properties, such as performance, scalability, simplicity, modifiability, visibility, portability, and reliability.

__The formal REST constraints are__  

* Client–server  
A uniform interface separates clients from servers. This separation of concerns means that, for example, clients are not concerned with data storage, which remains internal to each server, so that the portability of client code is improved. Servers are not concerned with the user interface or user state, so that servers can be simpler and more scalable. Servers and clients may also be replaced and developed independently, as long as the interface between them is not altered.

* Stateless  
The client–server communication is further constrained by no client context being stored on the server between requests. `Each request from any client contains all the information necessary to service the request, and session state is held in the client.` The session state can be transferred by the server to another service such as a database to maintain a persistent state for a period and allow authentication. The client begins sending requests when it is ready to make the transition to a new state. While one or more requests are outstanding, the client is considered to be in transition. The representation of each application state contains links that may be used the next time the client chooses to initiate a new state-transition.

* Cacheable  
As on the World Wide Web, clients and intermediaries can cache responses. Responses must therefore, implicitly or explicitly, define themselves as cacheable, or not, to prevent clients from reusing stale or inappropriate data in response to further requests. Well-managed caching partially or completely eliminates some client–server interactions, further improving scalability and performance.(PS:not global caching)

* Layered system  
A client cannot ordinarily tell whether it is connected directly to the end server, or to an intermediary along the way. Intermediary servers may improve system scalability by enabling load balancing and by providing shared caches. They may also enforce security policies.

* Code on demand(optional)  
Servers can temporarily extend or customize the functionality of a client by the transfer of executable code. Examples of this may include compiled components such as `Java applets` and `client-side scripts such as JavaScript.`

* Uniform interface  
`The uniform interface constraint is fundamental to the design of any REST service.` The uniform interface simplifies and decouples the architecture, which enables each part to evolve independently. The 4 constraints for this uniform interface are:  
    1. Identification of resources  
    Individual resources are identified in requests, for example using `URI`s in web-based REST systems. The resources themselves are conceptually separate from the representations that are returned to the client. For example, the server may send data from its database as HTML, XML or JSON, none of which are the server's internal representation.
    2. Manipulation of resources through these representations  
    When a client holds a representation of a resource, including any metadata attached, it has enough information to modify or delete the resource.
    3. Self-descriptive messages  
    Each message includes enough information to describe how to process the message. For example, which parser to invoke may be specified by an `Internet media type` (previously known as a MIME type).
    4. Hypermedia as the engine of application state (HATEOAS)  
    Clients make state transitions only through actions that are dynamically identified within hypermedia by the server (`e.g., by hyperlinks` within hypertext). Except for simple fixed entry points to the application, a client does not assume that any particular action is available for any particular resources beyond those described in representations previously received from the server. There is no universally accepted format for representing links between two resources. RFC 5988 and [JSON Hypermedia API Language] (proposed) are two popular formats for specifying REST hypermedia links.

__Applied to web services__  

Web service APIs that adhere to the REST architectural constraints are called [RESTful APIs]. HTTP-based RESTful APIs are defined with the following aspects:  
* base URI, such as http://example.com/resources/
* an `Internet media type` for the data. This is often `JSON` but can be any other valid Internet media type (e.g., XML, Atom, microformats, application/vnd.collection+json, etc.)
* standard HTTP methods (e.g., OPTIONS, GET, PUT, POST, and DELETE)
* hypertext links to reference state
* hypertext links to reference-related resources

##### Relationship between URI and HTTP Methods

The following table shows how HTTP methods are typically used in a RESTful API:  

Uniform Resource Identifier (URI)   |GET |PUT |POST    |DELETE
-----------|-----------------|----------------|---------------|--------------
Collection(such as http://api.example.com/resources/)|List the URIs and perhaps other details of the collection's members.  |Replace the entire collection with another collection.  |Create a new entry in the collection. The new entry's URI is assigned automatically and is usually returned by the operation.|Delete the entire collection.
Element(such as http://api.example.com/resources/item17) |Retrieve a representation of the addressed member of the collection, expressed in an appropriate Internet media type.   |Replace the addressed member of the collection, or if it does not exist,create it.  |Not generally used. Treat the addressed member as a collection in its own right and create a new entry in it.|Delete the addressed member of the collection.

`The PUT and DELETE methods are referred to as` __idempotent__, meaning that the operation will produce the same result no matter how many times it is repeated. The `GET method` is a safe method (or nullipotent), meaning that calling it produces `no side-effects`. In other words, retrieving or accessing a record does not change it. The distinction between PUT/DELETE and GET are roughly analogous to the notion of Command-Query Separation (CQS). For example: A query operation (like GET) promises no side-effects (e.g. changes) in data being queried. Commands (like PUT/DELETE) answer no questions about the data, but compute changes applied to the data (e.g. UPDATE or INSERT to use database terms).  

`Unlike SOAP-based web services, there is no "official" standard for RESTful web APIs`. This is because REST is an architectural style, while SOAP is a protocol. Even though REST is not a standard per se, most RESTful implementations make use of standards such as HTTP, URI, JSON, and XML.

##### Some common mistakes about RESTful
1. 最常见的一种设计错误，就是URI包含动词  
因为”资源”表示一种实体，所以应该是名词，URI不应该有动词，动词应该放在HTTP协议中。

举例来说，某个URI是/posts/show/1，其中show是动词，这个URI就设计错了，正确的写法应该是/posts/1，然后用GET方法表示show.

如果某些动作是HTTP动词表示不了的，你就应该把动作做成一种资源。比如网上汇款，从账户1向账户2汇款500元，错误的URI是：
```html
POST /accounts/1/transfer/500/to/2
```

正确的写法是把动词transfer改成名词transaction，资源不能是动词，但是可以是一种服务
```html
POST /transaction HTTP/1.1
Host: 127.0.0.1
from=1&to=2&amount=500.00
```

2. 另一个设计误区，就是在URI中加入版本号  
```html
http://www.example.com/app/2.0/foo
```

因为不同的版本，可以理解成同一种资源的不同表现形式，所以应该采用同一个URI。版本号可以在HTTP请求头信息的Accept字段中进行区分（参见[Versioning REST Services][restful_2]）：  
```html
Accept: vnd.example-com.foo+json; version=1.1
```

##### SOAP Web Service vs RESTful Web Service

1. SOAP WS支持既远程过程调用（例如，RPC）又支持消息中间件（MOM）方式进行应用集成。而Restful Web Service仅支持RPC集成方式。
2. SOAP WS是传输协议无关的。它支持多种协议，比如，HTTP(S)、 Messaging、TCP、UDP SMTP等等。而REST是协议相关的`，只支持HTTP或者HTTPS协议`
3. SOAP WS仅允许使用XML数据格式。定义的操作通过POST请求发送。其重点是通过操作名来获取服务，并将应用逻辑封装为服务。而REST方式则允许多种数据格式，例如，XML、JSON、文本、HTML等等。而且由于REST方式采用标准GET、PUT、POST和DELETE方法，因此所有的浏览器都可以支持。其重点是通过资源名来获取服务，并将数据封装为服务。AJAX支持REST方式，它可以使用XMLHttpRequest对象。无状态CRUD操作（创建、读、更新和删除）更加适合这种方式。
4. 无法缓存SOAP方式读取的内容。而REST方式的则可以，而且性能和可扩展性都更好一些。  
HTTP 协议通过 HTTP HEADER 域：If-Modified-Since/Last-Modified，If-None-Match/ETag 实现带条件的 GET 请求。
REST 的应用可以充分地挖掘 HTTP 协议对缓存支持的能力。当客户端第一次发送 HTTP GET 请求给服务器获得内容后，该内容可能被缓存服务器 (Cache Server) 缓存。当下一次客户端请求同样的资源时，缓存可以直接给出响应，而不需要请求远程的服务器获得。而这一切对客户端来说都是透明的。
5. SOAP WS支持SSL和WS-security，针对企业级应用可以有更多的安全保障，例如按需提升安全指数、通过第三方来保证身份认证信息的安全性、除了点到点SSL（point to point SSL）之外，更针对消息的不同部分来提供不同的保密算法等等。而REST只支持点到点SSL。而且无论是不是敏感消息，SSL都会加密整条消息。
6. SOAP对于基于ACID的短寿命事务管理以及基于补偿事务管理的长寿命事务有深入的支持。同时，SOAP也支持分布式事务（译者：在一个分布式环境中涉及到多个资源管理器的事务）的两阶段提交（two-phase commit）方式。而REST由于基于HTTP协议，因此对于事务处理既不兼容ACID方式也不提供分布式事务的两阶段提交方式。  
WS-Security、WS-Transactions和WS-Coordination等标准提供了上下文信息与对话状态管理
7. 即便是要通过SOAP的第三方程序，SOAP通过内置的重试逻辑也可以提供端到端可靠性。REST没有一个标准的消息系统，因而寄希望于客户通过重连去解决通信失败问题。

>测试SOAP WS可以使用SoapUI，测试RESTFul service可以采用Firefox的“poster”插件。

#### CAP theorem

![distributed_cap_img_1]  

In theoretical computer science, the CAP theorem, also named Brewer's theorem after computer scientist Eric Brewer, states that it is impossible for a distributed computer system to simultaneously provide all three of the following guarantees:  
* Consistency (all nodes see the same data at the same time)
* Availability (every request receives a response about whether it succeeded or failed)
* Partition tolerance (the system continues to operate despite arbitrary partitioning due to network failures)

[A very living case study][distributed_cap_1]  
[For more information][distributed_cap_2]  

The CAP Theorem states that, in a distributed system (a collection of interconnected nodes that share data.), you can only have two out of the following three guarantees across a write/read pair: Consistency, Availability, and Partition Tolerance - one of them must be sacrificed. 

* Consistency - A read is guaranteed to return the most recent write for a given client.
* Availability - A non-failing node will return a reasonable response within a reasonable amount of time (no error or timeout).
* Partition Tolerance - The system will continue to function when network partitions occur.

Given that networks aren’t completely reliable, `you must tolerate partitions in a distributed system`, period. Fortunately, though, you get to choose what to do when a partition does occur. According to the CAP theorem, `this means we are left with two options: Consistency and Availability.`

Before moving further, we need to set one thing straight. Object Oriented Programming != Network Programming! There are assumptions that we take for granted when building applications that share memory, which break down as soon as nodes are split across space and time.

PS: In the following diagrams, C is a client trying to read latest value, supposed that value y in N1 is latest update, however, there is partition between N1 and N2, what will return if C trys to read the value? value x or an error message?

* CP - Consistency/Partition Tolerance  
Wait for a response from the partitioned node which could result in a timeout error. The system can also choose to return an error, depending on the scenario you desire. Choose Consistency over Availability when your business requirements dictate `atomic reads and writes`.

![distributed_cap_img_2]  

* AP - Availability/Partition Tolerance  
Return the most recent version of the data you have, which could be stale. This system state will also accept writes that can be processed later when the partition is resolved. Choose Availability over Consistency when your business requirements allow for some flexibility around when the data in the system synchronizes. Availability is also a compelling option when the system needs to continue to function in spite of external errors (`shopping carts`, etc.)  
现在众多的NoSQL都属于此类

![distributed_cap_img_3]  

[For more information][distributed_cap_3]  
质疑3：应该构建不可变模型避免CAP的复杂性  
【7】的文章标题就是锤死CAP，作者对CAP的不屑溢于言表！
作者认为CAP的困境在于允许数据变更，每次变更就得数据同步，保持一致性，这样系统非常复杂。
他认为数据就是客观存在的，不可变，只能增、查。传统的CURD变为CR。这个概念非常类似Cassandra中的顺序写的概念，任何的变更都是增加记录。通过对所有记录的操作进行合并，从而得到最终记录。
因此，作者认为任何的数据模型都应该抽象为：Query=Function(all data)，任何的数据试图都是查询，查询是对全体数据施加了某个函数的结果。这个定义清晰简单，完全抛弃了CAP那些繁琐而又模糊的语义。因为每次操作都是队所有数据进行全局计算，也就没有了一致性问题！
有这样的系统吗？有，Hadoop便是！作者认为，Hadoop的HDFS只支持数据增加，而Mapeduce却进行全局计算，完美地符合了他对数据处理的期望！
Hadoop也存在某个节点数据丢失的问题，但随着流式计算，丢失的数据终究会随着系统的正常而被最终合并，因此数据最终是一致的。
Hadoop不能进行实时计算咋办？作者又构建了一套基于Cassandra和ElephantDB的实时数据处理系统。。。。搞的无比复杂！

#### Quorum NRW
对于分布式系统，为了保证高可用性，一般设置N>=3。不同的N,W,R组合，是在可用性和一致性之间取一个平衡，以适应不同的应用

插入一个知识点Quorum NRW模型：  
    N: 复制的节点数量   
    R: 成功读操作的最小节点数  
    W: 成功写操作的最小节点数  
只需W + R > N，就可以保证强一致性。  

此处我们的N=3  
当需要高可写的系统时，可以设置W=1 R=3  
当需要高可读的系统时，可以设置W=3 R=1  

从服务端角度，如何尽快将更新后的数据分布到整个系统，降低达到最终一致性的时间窗口，是提高系统的可用度和用户体验非常重要的方面。对于分布式数据系统：  
* N — 数据复制的份数
* W — 更新数据是需要保证写完成的节点数
* R — 读取数据的时候需要读取的节点数

如果W+R>N，写的节点和读的节点重叠，则是强一致性(PS: 最终一致性)。例如对于典型的一主一备同步复制的关系型数据库，N=2,W=2,R=1，则不管读的是主库还是备库的数据，都是一致的。

如果W+R<=N，则是弱一致性。例如对于一主一备异步复制的关系型数据库，N=2,W=1,R=1，则如果读的是备库，就可能无法读取主库已经更新过的数据，所以是弱一致性。

场景:  
* 如果N=W,R=1，任何一个写节点失效，都会导致写失败，因此可用性会降低，但是由于数据分布的N个节点是同步写入的，因此可以保证强一致性。
* 如果N=R,W=1，只需要一个节点写入成功即可，写性能和可用性都比较高。但是读取其他节点的进程可能不能获取更新后的数据，因此是弱一致性。这种情况下，如果W<(N+1)/2，并且写入的节点不重叠的话，则会存在写冲突 

#### Consistency Model
一致型的模型主要有三种：  
1. Strong Consistency（强一致性）：新的数据一旦写入，在任意副本任意时刻都能读到新值。比如：文件系统，RDBMS，Azure Table都是强一致性的。
2. Week Consistency（弱一致性）：不同副本上的值有新有旧，需要应用方做更多的工作获取最新值。比如Dynamo。
3. Evantual Consistency（最终一致性）：一旦更新成功，各副本的数据最终将达到一致。

从这三种一致型的模型上来说，我们可以看到，Weak和Eventually一般来说是异步冗余的，而Strong一般来说是同步冗余的(多写)，异步的通常意味着更好的性能，但也意味着更复杂的状态控制。同步意味着简单，但也意味着性能下降。

当然，牺牲一致性，并不是完全不管数据的一致性，否则数据是混乱的，那么系统可用性再高分布式再好也没有了价值。牺牲一致性，只是不再要求关系型数据库中的强一致性，而是只要系统能达到最终一致性即可，考虑到客户体验，这个最终一致的时间窗口，要尽可能的对用户透明，也就是需要保障“用户感知到的一致性”。通常是通过数据的多份异步复制来实现系统的高可用和数据的最终一致性的，“用户感知到的一致性”的时间窗口则取决于数据复制到一致状态的时间。

__最终一致性(eventually consistent)__  
对于一致性，可以分为从客户端和服务端两个不同的视角。从客户端来看，一致性主要指的是多并发访问时更新过的数据如何获取的问题。从服务端来看，则是更新如何复制分布到整个系统，以保证数据最终一致。一致性是因为有并发读写才有的问题，因此在理解一致性的问题时，一定要注意结合考虑并发读写的场景。

从客户端角度，多进程并发访问时，更新过的数据在不同进程如何获取的不同策略，决定了不同的一致性。对于关系型数据库，要求更新过的数据能被后续的访问都能看到，这是强一致性。如果能容忍后续的部分或者全部访问不到，则是弱一致性。如果经过一段时间后要求能访问到更新后的数据，则是最终一致性。

`最终一致性根据更新数据后各进程访问到数据的时间和方式的不同`，又可以区分为：  
1. Causal Consistency（因果一致性）  
如果进程A通知进程B它已更新了一个数据项，那么进程B的后续访问将返回更新后的值，且一次写入将保证取代前一次写入。与进程A无因果关系的进程C的访问遵守一般的最终一致性规则。
2. Read-your-writes Consistency（读你所写一致性）  
当进程A自己更新一个数据项之后，它总是访问到更新过的值，绝不会看到旧值。这是因果一致性模型的一个特例。
3. Session Consistency（会话一致性）  
这是上一个模型的实用版本，它把访问存储系统的进程放到会话的上下文中。只要会话还存在，系统就保证“读己之所写”一致性。如果由于某些失败情形令会话终止，就要建立新的会话，而且系统的保证不会延续到新的会话。
4. Monotonic Read Consistency（单调读一致性）  
如果进程已经看到过数据对象的某个值，那么任何后续访问都不会返回在那个值之前的值。
5. 单调写一致性  
系统保证来自同一个进程的写操作顺序执行。要是系统不能保证这种程度的一致性，就非常难以编程了。

其中最重要的变体是第二条：Read-your-Writes Consistency。特别适用于数据的更新同步，用户的修改马上对自己可见，但是其他用户可以看到他老的版本。Facebook的数据同步就是采用这种原则。

上述最终一致性的不同方式可以进行组合，例如单调读一致性和读己之所写一致性就可以组合实现。并且从实践的角度来看，这两者的组合，读取自己更新的数据，和一旦读取到最新的版本不会再读取旧版本，对于此架构上的程序开发来说，会少很多额外的烦恼。  
从服务端角度，如何尽快将更新后的数据分布到整个系统，降低达到最终一致性的时间窗口，是提高系统的可用度和用户体验非常重要的方面。

#### Fallacies of distributed computing
The fallacies of distributed computing are a set of assumptions that L Peter Deutsch and others at Sun Microsystems originally asserted programmers new to distributed applications invariably make. These assumptions ultimately prove false, resulting either in the failure of the system, a substantial reduction in system scope, or in large, unplanned expenses required to redesign the system to meet its original goals.

The fallacies are:
1. The network is reliable.
2. Latency is zero.
3. Bandwidth is infinite.
4. The network is secure.
5. Topology doesn't change.
6. There is one administrator.
7. Transport cost is zero.
8. The network is homogeneous

The effects of the fallacies  
1. Software applications are written with little error-handling on networking errors. During a network outage, such applications may stall or infinitely wait for an answer packet, permanently consuming memory or other resources. When the failed network becomes available, those applications may also fail to retry any stalled operations or require a (manual) restart.
2. Ignorance of network latency, and of the packet loss it can cause, induces application- and transport-layer developers to allow unbounded traffic, greatly increasing dropped packets and wasting bandwidth.
3. Ignorance of bandwidth limits on the part of traffic senders can result in bottlenecks over frequency-multiplexed media.
4. Complacency regarding network security results in being blindsided by malicious users and programs that continually adapt to security measures.
5. Changes in network topology can have effects on both bandwidth and latency issues, and therefore similar problems.
6. Multiple administrators, as with subnets for rival companies, may institute conflicting policies of which senders of network traffic must be aware in order to complete their desired paths.
7. The "hidden" costs of building and maintaining a network or subnet are non-negligible and must consequently be noted in budgets to avoid vast shortfalls.
8. If a system assumes a homogeneous network, than it can lead to the same problems that result from the first three fallacies.

#### 3 results of distribute computing
一个网络服务会有三种状态：1）Success，2）Failure，3）Timeout，第三个绝对是恶梦，尤其在你需要维护状态的时候。

#### Mobile Agent
__移动Agent技术__  
目前还没有一个关于移动Agent的确切定义，我们一般认为`移动Agent是一类能在自己控制之下从一台计算机移动到另一台计算机的自治程序，它们能为分布式应用提供方便的、高效的执行框架。`

移动Agent是一类特殊的软件Agent，可以看成是软件Agent技术与分布式计算技术相结合的产物，它除了具有软件Agent的基本特性 ——自治性、响应性、主动性和推理性外，还具有移动性，`即它可以在网络上从一台主机自主地移动到另一台主机，代表用户完成指定的任务`。由于移动Agent 可以在异构的软、硬件网络环境中自由移动，因此这种新的计算模式能有效地降低分布式计算中的网络负载、提高通信效率、动态适应变化的网络环境，并具有很好的安全性和容错能力。但目前，`所有的移动Agent系统还都很不成熟`，存在着各种各样的缺陷。所以，我们可以把目前的众多Agent系统看成是实验室系统，它们离真正实用的产品还有很大的距离。

#### Cache

##### 缓存穿透及缓存雪崩

__什么是缓存穿透？__  

一般的缓存系统，都是按照key去缓存查询，如果不存在对应的value，就应该去后端系统查找（比如DB）。如果key对应的value是一定不存在的，并且对该key并发请求量很大，就会对后端系统造成很大的压力。这就叫做缓存穿透。
 
如何避免？  
1. 对查询结果为空的情况也进行缓存，缓存时间设置短一点，或者该key对应的数据insert了之后清理缓存。
2. 对一定不存在的key进行过滤。可以把所有的可能存在的key放到一个大的Bitmap中，查询时通过该bitmap过滤。【感觉应该用的不多吧】(最常见的则是采用布隆过滤器)

__什么是缓存雪崩？__  
当缓存服务器重启或者大量缓存集中在某一个时间段失效，这样在失效的时候，也会给后端系统(比如DB)带来很大压力。

如何避免？  
1. 在缓存失效后，通过加锁或者队列来控制读数据库写缓存的线程数量。比如对某个key只允许一个线程查询数据和写缓存，其他线程等待。
2. 不同的key，设置不同的过期时间，让缓存失效的时间点尽量均匀。
3. 做二级缓存，A1为原始缓存，A2为拷贝缓存，A1失效时，可以访问A2，A1缓存失效时间设置为短期，A2设置为长期（此点为补充）

__缓存数据的淘汰__  
缓存淘汰的策略有两种  
1. 定时去清理过期的缓存。 
2. 当有用户请求过来时，再判断这个请求所用到的缓存是否过期，过期的话就去底层系统得到新数据并更新缓存。
 
两者各有优劣，第一种的缺点是维护大量缓存的key是比较麻烦的，第二种的缺点就是每次用户请求过来都要判断缓存失效，逻辑相对比较复杂，具体用哪种方案，大家可以根据自己的应用场景来权衡。

缓存预热可以防止缓存穿透和雪崩

---
[distributed_misc_1]:http://www.enterprise-technology.net/network3.htm "p2p vs cs"
[hadoop_1]:/resources/img/java/hadoop_1.png "Hadoop framework"
[hadoop_2]:/resources/img/java/hadoop_2.png "Hadoop product line"
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
[distributed_2pc_1]:/resources/img/java/distributed_2pc_1.png "Two-Phrase Commit Protocol"
[distributed_3pc_1]:https://en.wikipedia.org/wiki/Three-phase_commit_protocol "Three-Phrase Commit Protocol"
[distributed_3pc_2]:http://coolshell.cn/articles/10910.html "Three-Phrase Commit Protocol"
[distributed_3pc_3]:/resources/img/java/distributed_3pc_1.png "Three-Phrase Commit Protocol: process flow"
[distributed_3pc_4]:/resources/img/java/distributed_3pc_2.png "Three-Phrase Commit Protocol: state machine chart"
[distributed_paxos_1]:http://www.cppblog.com/kevinlynx/archive/2014/10/15/208580.html "图解分布式一致性协议Paxos"
[distributed_paxos_2]:http://blog.chinaunix.net/uid-16723279-id-3803058.html "两阶段提交协议与paxos投票算法 "
[distributed_paxos_img_1]:/resources/img/java/distributed_paxos_1.png "Message flow: Basic Paxos"
[distributed_paxos_img_2]:/resources/img/java/distributed_paxos_2.png "Message flow: Multi-Paxos, start"
[distributed_paxos_img_3]:/resources/img/java/distributed_paxos_3.png "Message flow: Multi-Paxos, steady-state"
[distributed_paxos_img_4]:/resources/img/java/distributed_paxos_4.png "Message flow: Byzantine Multi-Paxos, steady state"
[distributed_paxos_img_5]:/resources/img/java/distributed_paxos_5.png "Message flow: Fast Byzantine Multi-Paxos, steady state"
[distributed_paxos_img_6]:/resources/img/java/distributed_paxos_6.png "Another message flow chart from other resource"
[distributed_byzantine_1]:http://www.btckan.com/news/topic/14011 "The Byzantine Generals Problem"
[distributed_byzantine_2]:http://marknelson.us/2007/07/23/byzantine/ "The Byzantine Generals Problem"
[distributed_byzantine_3]:http://pages.cs.wisc.edu/~sschang/OS-Qual/reliability/byzantine.htm "The Byzantine Generals Problem"
[distributed_byzantine_4]:https://en.wikipedia.org/wiki/Byzantine_fault_tolerance "Byzantine fault tolerance"
[distributed_consensus_protocol_compare_img_1]:/resources/img/java/distributed_consensus_protocol_compare_1.png "Consensus protocol compare"
[restful_1]:https://en.wikipedia.org/wiki/Representational_state_transfer "Representational state transfer"
[restful_2]:http://www.informit.com/articles/article.aspx?p=1566460 "Versioning REST Services"
[distributed_cap_img_1]:/resources/img/java/distributed_cap_1.png "CAP Theorem"
[distributed_cap_img_2]:/resources/img/java/distributed_cap_2.png "CAP Theorem example-cp"
[distributed_cap_img_3]:/resources/img/java/distributed_cap_3.png "CAP Theorem example-ap"
[distributed_cap_1]:http://ksat.me/a-plain-english-introduction-to-cap-theorem/ "CAP Theorem example"
[distributed_cap_2]:http://robertgreiner.com/2014/08/cap-theorem-revisited/ "cap-theorem-revisited"
[distributed_cap_3]:http://blog.csdn.net/chen77716/article/details/30635543 "cap theorem"
[distributed_2armies_img_1]:/resources/img/java/distributed_2armies_1.png "Two Armies Problems"
[distributed_2armies_img_2]:/resources/img/java/distributed_2armies_2.png "TCP协议的基本原理"
[distributed_2armies_img_3]:/resources/img/java/distributed_2armies_3.png "量子隐形传态的原理图"



