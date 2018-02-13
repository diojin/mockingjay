# 			Big Data
---
## Indexes
* [Hadoop](#hadoop)
    - [MapReduce](#mapreduce)
    - [Issue Resolve](#hadoop-issue-resolve)
        + [Raise log threshold](#hadoop-raise-log-threshold)
        + [Unable to load native-hadoop library for your platform](#hadoop-unable-to-load-native-hadoop-library-for-your-platform)
    - [Misc](#hadoop-misc)
        + [Hadoop job management](#hadoop-jon-management)     
* [Spark](#spark)
    - [Issue Resolve](#spark-issue-resolve)
        + [Raise log threshold](#spark-raise-log-threshold)
        + [Unable to load native-hadoop library for your platform](#spark-unable-to-load-native-hadoop-library-for-your-platform)
    - [Spark Misc](#spark-misc)
        + [Spark Streaming vs Storm vs Samza](#spark-streaming-vs-storm-vs-samza)
            * [Spark Voices from others](#spark-voices-from-others)
        + [Spark Learning Materials](#spark-learning-materials)
* [Hive](#hive)
* [HBase](#hbase)
* [BigData Common](#bigdata-common)
    - [Cloudera’s CCA & CCP Certification](#clouderas-cca--ccp-certification)
        + [CCA Administrator Exam (CCA131)](#cca-administrator-exam-cca131)
        + [CCA Spark and Hadoop Developer (CCA175)](#cca-spark-and-hadoop-developer-cca175)
        + [CCA Data Analyst (CCA159)](#cca-data-analyst-cca159)
        + [CCP Data Engineer Exam (DE575)](#ccp-data-engineer-exam-de575)
    - [Misc](#bigdata-common-misc)
* [Miscellaneous](#miscellaneous)

## Hadoop

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

### MapReduce
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


### Hadoop Issue Resolve
所以如果集群以前能启动，但后来启动不了，特别是 DataNode 无法启动，不妨试着删除所有节点（包括 Slave 节点）上的 /usr/local/hadoop/tmp 文件夹，再重新执行一次 hdfs namenode -format，再次启动试试。

#### Hadoop Raise log threshold
```shell
export HADOOP_ROOT_LOGGER=DEBUG,console 
hadoop fs -text /test/data/origz/access.log.gz  ## what for??
```
or else  
$HADOOP_CONF_DIR/log4j.properties file:  
log4j.logger.org.apache.hadoop.util.NativeCodeLoader=DEBUG  

#### Hadoop Unable to load native-hadoop library for your platform
>WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform… using builtin-java classes where applicable

$HADOOP_HOME/etc/hadoop/hadoop-env.sh  
```shell
export  HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export  HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib:$HADOOP_COMMON_LIB_NATIVE_DIR"
```

however, if it is 32bit system and hadoop is 64bit, you need to compile 32bit hadoop ([bigdata-hadoop-compile-1]) and override libraries under lib/native  
```shell
$ file ../lib/native/libhadoop.so.1.0.0    # verify bit of hadoop
```

### Hadoop Misc
#### Hadoop job management
1. job submission  
```shell
$ hadoop jar <jar> [mainClass] args..
# for example
$ hadoop jar hadoop-examples-1.0.0.jar wordcount /text/input /test/output
```
2. job termination  
    1. before Hadoop 2.3.0  
    ```shell
    $ hadoop job -list 
    $ hadoop job -kill $jobId
    # for exampe, kill all jobs belongs to username
    $ for i in `hadoop job -list | grep -w  username| awk '{print $1}' | grep job_`; do 
        hadoop job -kill $i; 
      done
    ```
    2. Hadoop 2.3.0 or later  
    ```shell
    $ yarn application -list
    $ yarn application -kill {ApplicationI}
    ```

## Spark

### Spark Issue Resolve
#### Spark Raise log threshold
```shell
$ vim $SPARK_HOME/conf/log4j.properties
log4j.rootCategory=WARNING, console  
```

#### Spark Unable to load native-hadoop library for your platform
>WARN util.NativeCodeLoader: Unable to load native-hadoop library for your platform… using builtin-java classes where applicable

```shell
$ vim $SPARK_HOME/conf/spark-env.sh

export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HADOOP_COMMON_LIB_NATIVE_DIR  
```

### Spark Misc
#### Spark Streaming vs Storm vs Samza
[bigdata-spark-vs-storm-1]   
[7-most-common-hadoop-and-spark-projects-1]  
[bigdata-spark-vs-storm-2]  
All three real-time computation systems are open-source, low-latency, distributed, scalable and fault-tolerant.   

![bigdata-spark-vs-storm-vs-samza-img-1]  

Header              |Storm              |Spark              |Samza 
--------------------|-------------------|-------------------|------------------
`Delivery Semantics`|At least once, Exactly-once with Trident |Exactly once unless exception |At least once 
`State Management`  |Stateless, roll your own or Trident      |Stateful, to storage          |Stateful, key-value store
`Latency`        |Sub-second, OR some says 毫秒级 |Seconds depending on batch size | Sub-second
`Language Support`|Any JVM-language,Ruby,Python,Javascript,Perl |Scala,Java,Python | Scala, Java, JVM-language only 
吞吐量              |低                 |高                  |-
事务机制            |支持完善            |支持，但不够完善     |-
健壮性 / 容错性     |ZooKeeper，Acker，非常强 | Checkpoint，WAL，一般 |-
动态调整并行度      |支持                |不支持              |-


* Apache Spark
    * micro batching  
    Spark Streaming (an extension of the core Spark API) doesn’t process streams one at a time like Storm. Instead, it slices them in small batches of time intervals before processing them.  
    Spark Streaming implements a method for "batching" incoming updates in user-defined time intervals that get transformed into their own RDDs  
    * Spark Ecosystem  
    如果一个项目除了实时计算之外，还包括了离线批处理、交互式查询等业务功能，而且实时计算中，可能还会牵扯到高延迟批处理、交互式查询等功能，那么就应该首选Spark生态，用Spark Core开发离线批处理，用Spark SQL开发交互式查询，用Spark Streaming开发实时计算，三者可以无缝整合，给系统提供非常高的可扩展性  
    * Spark能更好地适用于数据挖掘与机器学习等需要迭代（前一步计算输出是下一步计算的输入）的Map Reduce的算法
    * 粗粒度更新状态的应用  
    由于RDD的特性，Spark不适用那种异步细粒度更新状态的应用，例如Web服务的存储或者是增量的Web爬虫和索引。就是对于那种增量修改的应用模型不适合。  
    * 分布式调试与管理依然用Yarn，文件系统依然会使用HDFS。  
    * Easy to use, supporting all the important Big Data Languages (Scala, Python, Java, R)
    * [Data-Parallel computations]  
    * User cases:   
        * Speaking of micro-batching, if you must have stateful computations, exactly-once delivery and don’t mind a higher latency
        * specially if you also plan for graph operations, machine learning or SQL access. The Apache Spark stack lets you combine several libraries with streaming (Spark SQL, MLlib, GraphX) and provides a convenient unifying programming model. In particular, streaming algorithms (e.g. streaming k-means) allow Spark to facilitate decisions in real-time.
    * Companies:  
    Amazon, Yahoo!, NASA JPL, eBay Inc., Baidu…  

* Apache Storm
    * one at a time  
    * complex event processing, CEP  
    Sometimes, you'll see such systems use Spark and HBase -- but generally they fall on their faces and have to be converted to Storm  
    * 在动态处理大量生成的“小数据块”上要更好  
    * 分布式RPC  
    由于Storm的处理组件是分布式的，而且处理延迟极低，所以可以作为一个通用的分布式RPC框架来使用。  
    * [Task-Parallel computations]  
    * User cases:  
        * a high-speed event processing system that allows for incremental computations
        * If you further need to run distributed computations on demand, while the client is waiting synchronously for the results, you’ll have Distributed RPC (DRPC) out-of-the-box.
        * because Storm uses Apache Thrift, you can write topologies in any programming language. 
        * If you need state persistence and/or exactly-once delivery though, you should look at the higher-level Trident API, which also offers micro-batching. 
        * 实时金融系统，要求纯实时进行金融交易和分析
        * 对于实时计算的功能中，要求可靠的事务机制和可靠性机制，即数据的处理完全精准，一条也不能多，一条也不能少
        * 若还需要针对高峰低峰时间段，动态调整实时计算程序的并行度，以最大限度利用集群资源（通常是在小型公司，集群资源紧张的情况）
        * 如果一个大数据应用系统，它就是纯粹的实时计算，不需要在中间执行SQL交互式查询、复杂的transformation算子等
    * Companies:  
    Twitter, Yahoo!, Spotify, The Weather Channel...  
    Storm and Kafka are the future of stream processing, and they are already in use at a number of high-profile companies including Groupon, Alibaba, and The Weather Channel.

    
* Apache Samza
    * one at a time
    * typically relies on Hadoop’s YARN (Yet Another Resource Negotiator) and Apache Kafka
    * User cases:  
    If you have a large amount of state to work with (e.g. many gigabytes per partition), Samza co-locates storage and processing on the same machines, allowing to work efficiently with state that won’t fit in memory. The framework also offers flexibility with its pluggable API: its default execution, messaging and storage engines can each be replaced with your choice of alternatives. Moreover, if you have a number of data processing stages from different teams with different codebases, Samza ‘s fine-grained jobs would be particularly well-suited, since they can be added/removed with minimal ripple effects.
    * Companies:  
    LinkedIn, Intuit, Metamarkets, Quantiply, Fortscale…

There are three general categories of delivery patterns:  
1. At-most-once:  
messages may be lost. This is usually the least desirable outcome.
2. At-least-once:  
messages may be redelivered (no loss, but duplicates). This is good enough for many use cases.
3. Exactly-once:  
each message is delivered once and only once (no loss, no duplicates). This is a desirable feature although difficult to guarantee in all cases.

Another aspect is state management. There are different strategies to store state. Spark Streaming writes data into the distributed file system (e.g. HDFS). Samza uses an embedded key-value store. With Storm, you’ll have to either roll your own state management at your application layer, or use a higher-level abstraction called Trident.

##### Spark Voices from others
Knowledge of Hadoop, Spark, Kafka, Flume is highly preferred

很多大公司现在对实时流处理的应用比较广泛，因此现在storm比较重要。hadoop兴起已经很长时间了，它的基本组件hdfs+yarn都已经比较稳定，重点学会用好这些组件。spark编程模型和效率都比hadoop mapreduce要好，所以批处理框架现在spark比较重要。现在大公司一般需要大数据的人才要懂得实时处理和批处理两种。所以感觉仔细研究spark和storm，对hadoop只需懂得原理，会使用方可。

spark仅仅用的hadoop的hdfs用作数据存储（当然你非要从本地文件系统读写文件也不是不可以）。你只需要知道hdfs的put，以及怎么从hdfs读数据就够了。

还是需要熟悉Hadoop下的，但仅仅限于其中的HDFS就可以了。毕竟，这个是大数据分布式文件系统的事实上的标准文件系统了

最近一年一直作为面试官在招人，最大的感受就是spark开发工程师的需求很大，但是来面试的水平都很差。spark以其优越的性能和计算模型赢得了越来越多的公司青睐，在可以预见的未来，spark 开发工程师的需求量会越来越高。另外spark在数据挖掘、图计算方面有天然的优势，国内的公司在大数据使用上已经逐渐的由简单的数据报表到特征挖掘以及机器学习了。 编辑于 2017-03-28

首先你要明白，不是你懂spark就能找到工作，spark是你找工作的时候一个很重的加分项，首先你得基础功底要扎实，如果做到了，那么spark的前景还是很好的，我们公司今年开始转向spark平台了，国内很多公司也在相继向spark迁移,  发布于 2017-05-15

作者：Si Luvenia
链接：https://www.zhihu.com/question/19795366/answer/106364880
来源：知乎
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

关于Hadoop的使用方式：
感觉现在各个公司使用Hadoop的方式都不一样，主要我觉得有两种吧。
第一种是long running cluster形式，比如Yahoo，不要小看这个好像已经没什么存在感的公司，Yahoo可是Hadoop的元老之一。这种就是建立一个Data Center，然后有几个上千Node的Hadoop Cluster一直在运行。比较早期进入Big Data领域的公司一般都在使用或者使用过这种方式。
另一种是只使用MapReduce类型。毕竟现在是Cloud时代，比如AWS的Elastic MapReduce。这种是把数据存在别的更便宜的地方，比如s3，自己的data center， sql database等等，需要分析数据的时候开启一个Hadoop Cluster，Hive/Pig/Spark/Presto/Java分析完了就关掉。不用自己做Admin的工作，方便简洁。
所以个人如果要学Hadoop的话我也建议第二种，AWS有免费试用时间（但是EMR并不免费，所以不要建了几千个Node一个月后发现破产了。。），可以在这上面学习。最重要的是你可以尝试各种不同的配置对于任务的影响，比如不同的版本，不同的container size，memory大小等等，这对于学习Spark非常有帮助。

#### Spark Learning Materials

我只推荐两个  
* Hadoop The Definitive Guide最新版，这也是我当时的入门书，写的非常好。强烈强烈建议看英文版的，否则容易交流障碍。。。这本书的例子都在github上可以下载下来，都跑一跑。另外Hadoop相关职位的面试问题大部分都来自于这本书，这本书看两遍基本上面试没问题。这是唯一一本我觉得从头到尾必看的书。
* Cloudera的tutorial，user guide，blog和best practice。这个比较官方和实效性。这不是说你要一页一页看完，是你有实际问题自己解决不了了来找参考资料。

* 另外还有一个传说中的Google三篇论文，那是Distributed System 和Big Data的开山始祖。其实我没看懂。。有兴趣也可以翻一翻。

我的日常，感觉每天看log都快要看到眼瞎。
如果你使用Hadoop，那么看log的时间估计会占了一大半。怎么看log，先从Resource Manager web UI开始入手吧。这是个web UI，可以让你查看每个任务的具体进展，container的运行等等。

关于Hadoop的使用方式：
感觉现在各个公司使用Hadoop的方式都不一样，主要我觉得有两种吧。
第一种是long running cluster形式，比如Yahoo，不要小看这个好像已经没什么存在感的公司，Yahoo可是Hadoop的元老之一。这种就是建立一个Data Center，然后有几个上千Node的Hadoop Cluster一直在运行。比较早期进入Big Data领域的公司一般都在使用或者使用过这种方式。
另一种是只使用MapReduce类型。毕竟现在是Cloud时代，比如AWS的Elastic MapReduce。这种是把数据存在别的更便宜的地方，比如s3，自己的data center， sql database等等，需要分析数据的时候开启一个Hadoop Cluster，Hive/Pig/Spark/Presto/Java分析完了就关掉。不用自己做Admin的工作，方便简洁。
所以个人如果要学Hadoop的话我也建议第二种，AWS有免费试用时间（但是EMR并不免费，所以不要建了几千个Node一个月后发现破产了。。），可以在这上面学习。最重要的是你可以尝试各种不同的配置对于任务的影响，比如不同的版本，不同的container size，memory大小等等，这对于学习Spark非常有帮助。

https://spark.apache.org/docs/latest/index.html
https://spark.apache.org/docs/latest/quick-start.html
https://spark.apache.org/docs/latest/rdd-programming-guide.html

#### Differences between cache, persist and checkpoint
* cache invoke persist internally, it has only one storage level, MEMORY_ONLY
* persist can have various storage level, it sets this RDD's storage level and persist its values after the first time it is computed. This can only be used to assign a new storage level if the RDD does not have a storage level set yet, or else an exception occurs.
* checkpoint 没有使用这种第一次计算得到就存储的方法，而是等到 job 结束后另外启动专门的 job 去完成 checkpoint 。 `也就是说需要 checkpoint 的 RDD 会被计算两次`。因此，在使用 rdd.checkpoint() 的时候，建议加上 rdd.cache()， 这样第二次运行的 job 就不用再去计算该 rdd 了，直接读取 cache 写磁盘。

关于这个问题，Tathagata Das 有一段回答: There is a significant difference between cache and checkpoint. Cache materializes the RDD and keeps it in memory and/or disk（PS: indeed memory only）. But the lineage of RDD will be remembered, so that if there are node failures and parts of the cached RDDs are lost, they can be regenerated. However, `checkpoint saves the RDD to an HDFS file` and actually forgets the lineage completely. This is allows long lineages to be truncated and the data to be saved reliably in HDFS (which is naturally fault tolerant by replication)

深入一点讨论，rdd.persist(StorageLevel.DISK_ONLY) 与 checkpoint 也有区别。前者虽然可以将 RDD 的 partition 持久化到磁盘，但该 partition 由 blockManager 管理。一旦 driver program 执行结束，也就是 executor 所在进程 CoarseGrainedExecutorBackend stop，blockManager 也会 stop，被 cache 到磁盘上的 RDD 也会被清空（整个 blockManager 使用的 local 文件夹被删除）。而 checkpoint 将 RDD 持久化到 HDFS 或本地文件夹，如果不被手动 remove 掉，是一直存在的.

Based on Spark 1.4.1, 
```scala
/** Persist this RDD with the default storage level (`MEMORY_ONLY`). */
def cache(): this.type = persist()

/** Persist this RDD with the default storage level (`MEMORY_ONLY`). */
def persist(): this.type = persist(StorageLevel.MEMORY_ONLY)

/**
 * Set this RDD's storage level to persist its values across operations after the first time
 * it is computed. This can only be used to assign a new storage level if the RDD does not
 * have a storage level set yet..
 */
def persist(newLevel: StorageLevel): this.type = {
  // TODO: Handle changes of StorageLevel
  if (storageLevel != StorageLevel.NONE && newLevel != storageLevel) {
    throw new UnsupportedOperationException(
      "Cannot change storage level of an RDD after it was already assigned a level")
  }
  sc.persistRDD(this)
  // Register the RDD with the ContextCleaner for automatic GC-based cleanup
  sc.cleaner.foreach(_.registerRDDForCleanup(this))
  storageLevel = newLevel
  this
}

val MEMORY_ONLY = new StorageLevel(false, true, false, true)

class StorageLevel private(
    private var _useDisk: Boolean,
    private var _useMemory: Boolean,
    private var _useOffHeap: Boolean,
    private var _deserialized: Boolean,
    private var _replication: Int = 1)
  extends Externalizable {
  ......
  def useDisk: Boolean = _useDisk
  def useMemory: Boolean = _useMemory
  def useOffHeap: Boolean = _useOffHeap
  def deserialized: Boolean = _deserialized
  def replication: Int = _replication
  ......
}
```

useOffHeap：使用堆外内存，这是Java虚拟机里面的概念，堆外内存意味着把内存对象分配在Java虚拟机的堆以外的内存，这些内存直接受操作系统管理（而不是虚拟机）。这样做的结果就是能保持一个较小的堆，以减少垃圾收集对应用的影响. 

```scala
val OFF_HEAP = new StorageLevel(false, false, true, false)
if (useOffHeap) {
  require(!useDisk, "Off-heap storage level does not support using disk")
  require(!useMemory, "Off-heap storage level does not support using heap memory")
  require(!deserialized, "Off-heap storage level does not support deserialized storage")
  require(replication == 1, "Off-heap storage level does not support multiple replication")
}
```


## Hive
Hive是基于Hadoop的一个数据仓库工具，处理能力强而且成本低廉。

__主要特点：__  
存储方式是将结构化的数据文件映射为一张数据库表。提供类SQL语言，实现完整的SQL查询功能。可以将SQL语句转换为MapReduce任务运行，十分适合数据仓库的统计分析。

__不足之处：__  
* 采用行存储的方式（SequenceFile）来存储和读取数据, 效率低
* 当要读取数据表某一列数据时需要先取出所有数据然后再提取出某一列的数据，效率很低。
* 同时，它还占用较多的磁盘空间

由于以上的不足，有人（查礼博士）介绍了一种将分布式数据处理系统中以记录为单位的存储结构变为以列为单位的存储结构，进而减少磁盘访问数量，提高查询处理性能。这样，由于相同属性值具有相同数据类型和相近的数据特性，以属性值为单位进行压缩存储的压缩比更高，能节省更多的存储空间。

## HBase
HBase是一个分布式的、面向列的开源数据库，它不同于一般的关系数据库,是一个适合于非结构化数据存储的数据库。另一个不同的是HBase基于列的而不是基于行的模式。HBase使用和 BigTable非常相同的数据模型。用户存储数据行在一个表里。一个数据行拥有一个可选择的键和任意数量的列，一个或多个列组成一个ColumnFamily，一个Fmaily下的列位于一个HFile中，易于缓存数据。表是疏松的存储的，因此用户可以给行定义各种不同的列。在HBase中数据按主键排序，同时表按主键划分为多个HRegion

## BigData Common

### Certifications
[bigdata-certifications-1]  
The top 14 big data and data analytics certifications
* Analytics: Optimizing Big Data Certificate
* Certificate in Engineering Excellence Big Data Analytics and Optimization (CPEE)
* Certification of Professional Achievement in Data Sciences
* Certified Analytics Professional
* Cloudera Certified Associate (CCA) Data Analyst
* Cloudera Certified Associate (CCA) Spark and Hadoop Developer
* Cloudera Certified Professional (CCP): Data Engineer
* EMC Proven Professional Data Scientist Associate (EMCDSA)
* IBM Certified Data Architect – Big Data
* IBM Certified Data Engineer – Big Data
* Mining Massive Data Sets Graduate Certificate
* MongoDB Certified DBA Associate
* MongoDB Certified Developer Associate
* SAS Certified Big Data Professional


### Cloudera’s CCA & CCP Certification
#### CCA Administrator Exam (CCA131)
CCA Administrator Exam (CCA131)  管理员认证   
认证准备建议：Administrator管理员培训  
考试形式：120分钟；70%通过；基于一个预配置的Cloudera企业版集群，解决8~12个场景下的任务  
`CCAH Administrator Hadoop管理员认证`   
认证准备建议：Hadoop管理员培训  
考试形式：90分钟；70%通过；60道多项选择题（会提示是单选or多选） 
培训内容  
通过讲师在课堂上的讲解，以及实操练习，学员将学习以下内容：  
* Cloudera Manager管理机群的特性，譬如日志汇总、配置管理、报告、报警及服务管理。 
* YARN、MapReduce、Spark 及HDFS的工作原理。 
* 如何为你的机群选取合适的硬件和架构。 
* 如何将 Hadoop 机群和企业已有的系统进行无缝集成。 
* 如何使用Flume 进行实时数据采集以及如何使用Sqoop在RDBMS和Hadoop机群之间进行数据导入导出。 
* 如何配置公平调度器为Hadoop上的多用户提供服务级别保障。 
* 产品环境中Hadoop机群的最佳运维实践。
* Hadoop机群排错、诊断问题和性能调优。
培训对象及学员基础   
“面向系统管理员和IT 经理，需具备Linux 经验，无需Apache Hadoop 基础。
认证 “结束本课程培训后，我们建议学员准备并注册参加Cloudera 认证 Hadoop 管理员考试（CCAH）。通过并获取该证书是向公司及客户证明个人在Hadoop 领域的技术和专长的有力依据。


#### CCA Spark and Hadoop Developer (CCA175)
CCA Spark and Hadoop Developer certification Cost: USD $295  

CCA Spark and Hadoop Developer (CCA175) 开发者认证   
认证准备建议：Spark and Hadoop开发者培训  
考试形式：120分钟；70%通过；解决10~12基于CDH5机群上需通过实际操作的问题  

`CCA Spark and Hadoop Developer开发者认证`    
认证准备建议：Spark and Hadoop开发者培训  
考试形式：120分钟；70%通过；解决10~12基于CDH5机群上需通过实际操作的问题  
培训内容  
通过讲师在课堂上的讲解，以及实操练习，学员将学习以下内容：  
* 在 Hadoop 机群上进行分布式存储和处理数据。 
* 在 Hadoop 机群上编写、配置和部署 Apache Spark 应用。 
* 使用 Spark shell 进行交互式数据分析。 
* 使用 Spark SQL 查询处理结构化数据。  
* 使用 Spark Streaming 处理流式数据。 
* 使用 Flume 和 Kafka 为 Spark Streaming 采集流式数据。
培训对象及学员基础   
本课程适合于具有编程经验的开发员及工程师。无需 Apache Hadoop 基础，培训内容中对 Apache Spark 的介绍所涉及的代码及练习使用 Scala 和Python，因此需至少掌握这两个编程语言中的一种。需熟练掌握 Linux 命令行。对 SQL 有基本了解。

Cloudera Developer training for Spark and Hadoop(CCA-175)
课时：28h/4天
Q1438118790  
Cloudera Developer Training for Spark and Hadoop(CCA-175)课程介绍  
1. Hadoop 及生态系统介绍  
    * Apache Hadoop 概述 
    * 数据存储和摄取 
    * 数据处理 
    * 数据分析和探索 
    * 其他生态系统工具 
    * 练习环境及分析应用场景介绍
2. Apache Hadoop 文件存储 
    * 传统大规模系统的问题 
    * HDFS 体系结构 
    * 使用 HDFS 
    * Apache Hadoop 文件格式
3. Apache Hadoop 机群上的数据处理  
    * YARN 体系结构 
    * 使用 YARN
4. 使用 Apache Sqoop 导入关系数据  
    * Sqoop 简介 
    * 数据导入 
    * 导入的文件选项 
    * 数据导出
5. Apache Spark 基础  
    * 什么是 Apache Spark 
    * 使用 Spark Shell 
    * RDDs(可恢复的分布式数据集） 
    * Spark 里的函数式编程
6. Spark RDD 
    * 创建 RDD 
    * 其他一般性 RDD 操作
7. 使用键值对 RDD  
    * 键值对 RDD 
    * MapReduce 
    * 其他键值对 RDD 操作
8. 编写和运行 Apache Spark 应用 
    * Spark 应用对比 Spark Shell 
    * 创建 SparkContext 
    * 创建 Spark 应用（Scala 和 Java） 
    * 运行 Spark 应用 
    * Spark 应用 WebUI
9. 配置 Apache Spark 应用 
    * 配置 Spark 属性 
    * 运行日志 
10. Apache Spark 的并行处理 
    * 回顾：机群环境里的 Spark 
    * RDD 分区 
    * 基于文件 RDD 的分区 
    * HDFS 和本地化数据 
    * 执行并行操作 
    * 执行阶段及任务
11. Spark 持久化 
    * RDD 演变族谱 
    * RDD 持久化简介 
    * 分布式持久化
12. Apache Spark 数据处理的常见模式 
    * 常见 Spark 应用案例 
    * 迭代式算法 
    * 机器学习 
    * 例子：K － Means
13. DataFrames 和 Spark SQL 
    * Apache Spark SQL 和 SQL Context 
    * 创建 DataFrames 
    * 变更及查询 DataFrames 
    * 保存 DataFrames  
    * DataFrames 和 RDD   
    * Spark SQL 对比 Impala 和Hive-on-Spark 
    * Spark 2.x 版本上的 Apache Spark SQL
14. Apache Kafka 
    * 什么是 Apache Kafka 
    * Apache Kafka 概述 
    * 如何扩展 Apache Kafka 
    * Apache Kafka 机群架构 
    * Apache Kafka 命令行工具
15. 使用 Apache Flume 采集实时数据 
    * 什么是 Apache Flume 
    * Flume 基本体系结构 
    * Flume 源 
    * Flume 槽 
    * Flume 通道 
    * Flume 配置
16. 集成 Apache Flume 和 Apache Kafka 
    * 概要 
    * 应用案例 
    * 配置
17. Apache Spark Streaming：DStreams 介绍 
    * Apache Spark Streaming 概述 
    * 例子：Streaming 访问计数 
    * DStreams 
    * 开发 Streaming 应用
18. Apache Spark Streaming：批处理 
    * 批处理操作 
    * 时间分片 
    * 状态操作 
    * 滑动窗口操作
19. Apache Spark Streaming：数据源 
    * Streaming 数据源概述 
    * Apache Flume 和Apache Kafka 数据源 
    * 例子：使用 Direct 模式连接 Kafka 
    * 数据源

#### CCA Data Analyst (CCA159)
CCA Data Analyst (CCA159) 数据分析师认证   
认证准备建议：Data Analyst数据分析师培训  
考试形式：120分钟；70%通过；解决10~12个客户问题，对于每一个问题，考生必须给出一个满足所有要求的精确的技术解决方案。考生可在群集上使用任何工具或组合使用工具  

`CCA Data Analyst数据分析师认证`  
认证准备建议：Data Analyst数据分析师培训  
考试形式：120分钟；70%通过；解决10~12个客户问题，对于每一个问题，考生必须给出一个满足所有要求的精确的技术解决方案。考生可在群集上使用任何工具或组合使用工具。  
培训内容  
通过讲师在课堂上的讲解，以及实操练习，学员将熟悉Hadoop生态系统， 学习主题包括：  
* Pig、Hive 和 Impala 针对数据采集、存储和分析而提供的功能。 
* Apache Hadoop的基本原理，以及使用Hadoop工具进行数据ETL（提取、
* 转换和加载）、撷取和处理。 
* Pig、Hive 和 Impala 是如何提高典型分析任务的处理效率的。 
* 联接多种多样的数据集，以获得有价值的商业洞察力。 
* 执行实时、复杂的数据集查询。
培训对象和学员基础  
本课程是专为数据分析师、商业智能专家、开发人员、系统架构师和数据库管理员开发的。培训学员需具备一定的SQL知识水平，且基本熟悉 Linux 命令行。培训学员至少熟悉一种脚本语言知识（例如，Bash 脚本编程、 Perl、Python 和 Ruby）将会更有帮助，但不是必需的。此外，培训学员不需要具备Apache Hadoop知识。


#### CCP Data Engineer Exam (DE575)
CCP Data Engineer Exam (DE575) 数据工程师认证   
认证准备建议：Spark and Hadoop开发者培训；设计及构建大数据应用；考生需对Hadoop有深入了解、具有实际使用大数据工具的经验、以及具备解决实际数据工程问题的专家级水平
考试形式：4小时；提供一个大数据集供使用、7个高性能节点组成的CDH5机群；解决大数据用户可能碰到的5-8个实际问题  

### BigData Common Misc

## Miscellaneous

---
[hadoop_1]:/resources/img/java/hadoop_1.png "Hadoop framework"
[hadoop_2]:/resources/img/java/hadoop_2.png "Hadoop product line"
[mapreduce_1]:/resources/img/java/mapreduce_1.png "Map Reduce Flowchart"
[mapreduce_2]:/resources/img/java/mapreduce_2.png "Map Reduce Flowchart"
[mapreduce_example_1]:/resources/img/java/mapreduce_example_1.png "Map Reduce WordCount"
[bigdata-spark-vs-storm-1]:https://dzone.com/articles/streaming-big-data-storm-spark "Streaming Big Data: Storm, Spark and Samza"
[bigdata-spark-vs-storm-vs-samza-img-1]:/resources/img/java/bigdata-spark-vs-storm-vs-samza-1.png "bigdata-spark-vs-storm-vs-samza-1"
[Data-Parallel computations]:http://en.wikipedia.org/wiki/Data_parallelism "Data-Parallel computations"
[Task-Parallel computations]:http://en.wikipedia.org/wiki/Task_parallelism "Task-Parallel computations"
[7-most-common-hadoop-and-spark-projects-1]:https://www.infoworld.com/article/2969911/application-development/the-7-most-common-hadoop-and-spark-projects.html "The 7 most common Hadoop and Spark projects"
[bigdata-spark-vs-storm-1]:http://blog.csdn.net/yown/article/details/55000097 "spark与storm比对与选型"
[bigdata-certifications-1]:https://www.cio.com/article/3209911/certifications/big-data-certifications-that-will-pay-off.html "BigData Certification"
[bigdata-hadoop-compile-1]:http://blog.csdn.net/young_kim1/article/details/50269501 "本地编译Hadoop2.7.1源码总结和问题解决"