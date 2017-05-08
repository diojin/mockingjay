## Distributed
---

* [NoSql](#nosql)
    - [NoSql Categories](nosql-categories)
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

key-value, wide column, graph, or document

分类  |Examples举例  |典型应用场景  |数据模型    |优点  |缺点
---------|-------------|------------------------|-------------|--------|------
key-value(键值)|Tokyo Cabinet/Tyrant, __Redis__, Voldemort, __Oracle BDB__|`内容缓存`，主要用于`处理大量数据的高访问负载`，也用于一些日志系统等等| [Key 指向 Value 的键值对，通常用hash table来实现| 查找速度快|  `数据无结构化`，`通常只被当作字符串或者二进制数据`
wide column(列存储数据库)|__Cassandra__, __HBase__, Riak|`分布式的文件系统`|    以列簇式存储，将同一列数据存在一起|   查找速度快，可扩展性强，`更容易进行分布式扩展`|  功能相对局限
document(文档型数据库)|__CouchDB__, __MongoDb__|Web应用(与Key-Value类似，Value是`结构化的`，不同的是数据库能够了解Value的内容)| Key-Value对应的键值对，`Value为结构化数据`|  `数据结构要求不严格，表结构可变`，不需要像关系型数据库一样需要预先定义表结构|  `查询性能不高，而且缺乏统一的查询语法`
graph(图形)数据库|Neo4J, InfoGrid, Infinite Graph|`社交网络，推荐系统`等, 专注于构建关系图谱|图结构|利用图结构相关算法。比如最短路径寻址，N度关系查找等|很多时候需要对整个图做计算才能得出需要的信息，而且这种结构不太好做分布式的集群方案




CAP theorem




### Miscellaneous

