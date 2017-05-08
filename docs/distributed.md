## Distributed
---

* [NoSql](#nosql)
* [Miscellaneous](#miscellaneous)
    - []

### NoSql

A NoSQL (originally referring to "non SQL" or "non relational") database provides a mechanism for storage and retrieval of data which is modeled in means other than the tabular relations used in relational databases. 

Such databases have existed since the late 1960s, but did not obtain the "NoSQL" moniker until a surge of popularity in the early twenty-first century, triggered by the needs of Web 2.0 companies such as Facebook,Google and Amazon.com. NoSQL databases are increasingly used in big data and real-time web applications. 

NoSQL systems are also sometimes called "Not only SQL" to emphasize that they `may support SQL-like query languages`.

Motivations for this approach include: simplicity of design, `simpler "horizontal" scaling to clusters of machines (which is a problem for relational databases)`, and finer control over availability. The data structures used by NoSQL databases (e.g. __key-value__, __wide column__, __graph__, or __document__) are different from those used by default in relational databases, making some operations faster in NoSQL. The particular suitability of a given NoSQL database depends on the problem it must solve. Sometimes the data structures used by NoSQL databases are also viewed as "more flexible" than relational database tables.[9]

Many NoSQL stores compromise consistency (in the sense of the CAP theorem) in favor of availability, partition tolerance, and speed. Barriers to the greater adoption of NoSQL stores include the use of low-level query languages (instead of SQL, for instance the lack of ability to perform ad-hoc JOINs across tables), lack of standardized interfaces, and huge previous investments in existing relational databases.[10] Most NoSQL stores lack true ACID transactions, although a few databases, such as MarkLogic, Aerospike, FairCom c-treeACE, Google Spanner (though technically a NewSQLdatabase), Symas LMDB and OrientDB have made them central to their designs. (See ACID and JOIN Support.)
Instead, most NoSQL databases offer a concept of "eventual consistency" in which database changes are propagated to all nodes "eventually" (typically within milliseconds) so queries for data might not return updated data immediately or might result in reading data that is not accurate, a problem known as stale reads.[11] Additionally, some NoSQL systems may exhibit lost writes and other forms of data loss.[12] Fortunately, some NoSQL systems provide concepts such as write-ahead logging to avoid data loss.[13] For distributed transaction processing across multiple databases, data consistency is an even bigger challenge that is difficult for both NoSQL and relational databases. Even current relational databases "do not allow referential integrity constraints to span databases."[14] There are few systems that maintain both ACID transactions and X/Open XA standards for distributed transaction processing.

key-value, wide column, graph, or document

### Miscellaneous

