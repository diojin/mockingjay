## Distributed
---

* [NoSql](#nosql)
    - [NoSql Categories](#nosql-categories)
    - [NoSql Characteristics](#nosql-characteristics)
* [Miscellaneous](#miscellaneous)
    - []

### NoSql

A NoSQL (originally referring to "non SQL" or "non relational") database provides a mechanism for storage and retrieval of data which is modeled in means other than the tabular relations used in relational databases. 

Such databases have existed since the late 1960s, but did not obtain the "NoSQL" moniker until a surge of popularity in the early twenty-first century, triggered by the needs of Web 2.0 companies such as Facebook,Google and Amazon.com. NoSQL databases are increasingly used in big data and real-time web applications. 

NoSQL systems are also sometimes called "Not only SQL" to emphasize that they `may support SQL-like query languages`.

Motivations for this approach include: simplicity of design, `simpler "horizontal" scaling to clusters of machines (which is a problem for relational databases)`, and finer control over availability. The data structures used by NoSQL databases (e.g. __key-value__, __wide column__, __graph__, or __document__) are different from those used by default in relational databases, making some operations faster in NoSQL. The particular suitability of a given NoSQL database depends on the problem it must solve. Sometimes the data structures used by NoSQL databases are also viewed as "more flexible" than relational database tables.

Many NoSQL stores __compromise consistency__ (in the sense of the __CAP theorem__) in favor of availability, partition tolerance, and speed. `Barriers to the greater adoption of NoSQL stores` include `the use of low-level query languages (instead of SQL, for instance the lack of ability to perform ad-hoc JOINs across tables)`, `lack of standardized interfaces`, and `huge previous investments in existing relational databases`.` Most NoSQL stores lack true ACID transactions`, although a few databases, such as MarkLogic, Aerospike, FairCom c-treeACE, Google Spanner (though technically a NewSQLdatabase), Symas LMDB and OrientDB have made them central to their designs. (See ACID and JOIN Support.)
Instead, most NoSQL databases offer a concept of `"eventual consistency"` in which database changes are propagated to all nodes "eventually" (typically within milliseconds) so queries for data might not return updated data immediately or might result in reading data that is not accurate, a problem known as stale reads. Additionally, `some NoSQL systems may exhibit lost writes and other forms of data loss`. Fortunately, some NoSQL systems provide concepts such as write-ahead logging to avoid data loss. `For distributed transaction processing across multiple databases`, data consistency is an even bigger challenge that is difficult for both NoSQL and relational databases. Even current relational databases "do not allow referential integrity constraints to span databases." There are few systems that maintain both ACID transactions and X/Open XA standards for distributed transaction processing.

#### NoSql Categories

分类  |Examples举例  |典型应用场景  |数据模型    |优点  |缺点
---------|-------------|---------------------|-----------------|--------|------
key-value(键值)|Tokyo Cabinet/Tyrant, __Redis__, Voldemort, __Oracle BDB__|`内容缓存`，主要用于`处理大量数据的高访问负载`，也用于一些日志系统等等| [Key 指向 Value 的键值对，通常用hash table来实现| 查找速度快|  `数据无结构化`，`通常只被当作字符串或者二进制数据`. 如果DBA只对部分值进行查询或更新的时候，Key/value就显得效率低下了
wide column(列存储数据库)|__Cassandra__, __HBase__, Riak|`分布式的文件系统`|    以列簇式存储，将同一列数据存在一起|   查找速度快，可扩展性强，`更容易进行分布式扩展`|  功能相对局限
document(文档型数据库)|__CouchDB__, __MongoDb__|Web应用(与Key-Value类似，Value是`结构化的`，不同的是数据库能够了解Value的内容)| Key-Value对应的键值对，`Value为结构化数据`, 比如JSON|  `数据结构要求不严格，表结构可变`，不需要像关系型数据库一样需要预先定义表结构|  `查询性能不高，而且缺乏统一的查询语法`
graph(图形)数据库|Neo4J, InfoGrid, Infinite Graph|`社交网络，推荐系统`等, 专注于构建关系图谱|图结构|利用图结构相关算法。比如最短路径寻址，N度关系查找等|很多时候需要对整个图做计算才能得出需要的信息，而且这种结构不太好做分布式的集群方案

>而且文档型数据库比键值数据库的查询效率更高??

#### NoSql Characteristics
对于NoSQL并没有一个明确的范围和定义，但是他们都普遍存在下面一些共同特征:  
1. 不需要预定义模式：不需要事先定义数据模式，预定义表结构。数据中的每条记录都可能有不同的属性和格式。当插入数据时，并不需要预先定义它们的模式
2. 无共享架构：相对于将所有数据存储的存储区域网络中的全共享架构。NoSQL往往将数据划分后存储在各个本地服务器上。因为从本地磁盘读取数据的性能往往好于通过网络传输读取数据的性能，从而提高了系统的性能。
3. 弹性可扩展：可以在系统运行的时候，动态增加或者删除结点。不需要停机维护，数据可以自动迁移
4. 分区：相对于将数据存放于同一个节点，NoSQL数据库需要将数据进行分区，将记录分散在多个节点上面。并且通常分区的同时还要做复制。这样既提高了并行性能，又能保证没有单点失效的问题。
5. 异步复制: 和RAID存储系统不同的是，NoSQL中的复制，往往是基于日志的异步复制。这样，数据就可以尽快地写入一个节点，而不会被网络传输引起迟延。缺点是并不总是能保证一致性，这样的方式在出现故障的时候，可能会丢失少量的数据。
6. 最终一致性和软事务-BASE：相对于事务严格的ACID特性，NoSQL数据库保证的是BASE特性。BASE是最终一致性和软事务

NoSQL数据库并没有一个统一的架构，两种NoSQL数据库之间的不同，甚至远远超过两种关系型数据库的不同。可以说，NoSQL各有所长，成功的NoSQL必然`特别适用于某些场合或者某些应用`，在这些场合中会远远胜过关系型数据库和其他的NoSQL。


CAP theorem




### Miscellaneous

