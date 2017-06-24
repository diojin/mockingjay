## Database
---

* [General](#general)
    - [Optimization](#optimization)
        + [Raw Device](#raw-device)
* [Oracle](#oracle)
    - [Tuning](#oracle-tuning)
        + [Optimizer Access Path](#oracle-optimizer-access-path)
        + [Types of Joins](#oracle-types-of-joins)
    - [Partitioning](#oracle-partitioning)
    - [Concurrency](#oracle-concurrency)
    - [Misc](#oracle-misc)
        + [High Water Mark (HWM)](#high-water-mark-hwm)
        + [index clustering factor](#index-clustering-factor)
        + [Clustered index vs non clustered index](#oracle-clustered-index-vs-non-clustered-index)
        + [Oracle index-organized table & heap-organized table](#oracle-index-organized-table--heap-organized-table)
        + [Table clusters (clustered tables)](#table-clusters-clustered-tables)
            * [Indexed Clusters](#oracle-indexed-clusters)
            * [Hash Clusters](#oracle-hash-clusters)
        + [for update nowait vs for update](#for-update-nowait-vs-for-update)
        + [Temporary segment](#oracle-temporary-segment)
        + [Temporary Table](#oracle-temporary-table)
        + [truncate vs delete](#oracle-truncate-vs-delete)
        + [Oracle startup and shutdown](#oracle-startup-and-shutdown)
        + [Uncategorized](#oracle-uncategorized)
            * [account: sys and system](#oracle-account-sys-and-system)
            * [dba vs sysdba](#dba-vs-sysdba)
            * [new schema objects](#oracle-new-schema-objects)
* [Miscellaneous](#miscellaneous)
    - [Partitioning](#partitioning)
    - [Concurrency](#concurrency)
        + [Concurrent read/write issues](#concurrent-readwrite-issues)
        + [Isolation Level and lock](#isolation-level-and-lock)
        + [write skew anomaly](#write-skew-anomaly)
        + [concurrency control mechanisms](#concurrency-control-mechanisms)
    - [Differences between Union and Union All](#differences-between-union-and-union-all)
    - [In vs Exists vs Not In vs Not Exists](#in-vs-exists-vs-not-in-vs-not-exists)
        + [In vs Exists](#in-vs-exists)
        + [Not In vs Not Exits](#not-in-vs-not-exits)
    - [Database Normal Form](#database-normal-form)

### General

#### Optimization

The default database is Oracle, it will be speculated if it is for other database.   
There are several aspects to optimize,   
1. Index
2. Fundamental types
3. Temporary table
4. SQL optimization
5. Optimization Misc

1. Index
    1. 对查询进行优化，应尽量避免全表扫描，首先应考虑在 where 及 `order by` 涉及的列上建立索引。
    2. 避免索引失效  
        1. 避免在索引列上使用IS NULL和IS NOT NULL
        2. like 可能导致索引失效  
        wild-card searches should not be in a leading position, otherwise it does not result in a range scan(col1 like '%ASD' doesn't use index)  
        避免使用困难的正规表达式，例如select * from customer where zipcode like “98___”，即便在zipcode上建立了索引，在这种情况下也还是采用顺序扫描的方式。如果把语句改成select * from customer where zipcode>”98000″，在执行查询时就会利用索引来查询，显然会大大提高速度;
        3. 隐式转换导致索引失效
        4. '!=' 将不使用索引
        5. 避免在索引列上使用NOT  
        通常，我们要避免在索引列上使用NOT, NOT会产生在和在索引列上使用函数相同的影响. 当ORACLE”遇到”NOT,他就会停止使用索引转而执行全表扫描.
        6. 应尽量避免在where子句中对字段进行函数操作, 会导致索引失效, 除非建立函数索引.
        7. 如果在 where 子句中使用参数(采用绑定变量)，也会导致全表扫描?????  
        因为SQL只有在运行时才会解析局部变量，但优化程序不能将访问计划的选择推迟到运行时；它必须在编译时进行选择。然而，如果在编译时建立访问计划，变量的值还是未知的，因而无法作为索引选择的输入项。  
        如下面语句将进行全表扫描：  
        select id from t where num=@num;  
        可以改为强制查询使用索引：  
        select id from t with(index(索引名)) where num=@num;   
        8. leading columns are used when using composite index, unless index skip scan can apply, otherwise composite index is not used  
        9. 对索引列使用OR将造成全表扫描.
    3. Index can’t have more than half of the columns of a table  
    索引并不是越多越好，索引固然可以提高相应的 select 的效率，但同时也降低了 insert 及 update 的效率，因为 insert 或 update 时有可能会重建索引，所以怎样建索引需要慎重考虑，视具体情况而定。一个表的索引数最好不要超过6个，若太多则应考虑一些不常使用到的列上建的索引是否有必要。  
    如果检索数据量超过30%的表中记录数.使用索引将没有显著的效率提高.  
    在特定情况下, 使用索引也许会比全表扫描慢, 但这是同一个数量级上的区别. 而通常情况下,使用索引比全表扫描要块几倍乃至几千倍!
    4. Clustered index  
    应尽可能的避免更新 clustered 索引数据列  
    因为 clustered 索引数据列的顺序就是表记录的物理存储顺序，一旦该列值改变将导致整个表记录的顺序的调整，会耗费相当大的资源。若应用系统需要频繁更新 clustered 索引数据列，那么需要考虑是否应将该索引建为 clustered 索引。  
    一般来说, 有`大量重复值`、且经常有范围查询（ > ,< ，> =,< =）和order by、group by发生的列，可考虑建立群集索引 
    5. 定期的重构索引是有必要的  
    ALTER INDEX \<INDEXNAME\> REBUILD \<TABLESPACENAME\>

2. Fundamental types
    1. 尽量使用数字型字段  
    若只含数值信息的字段尽量不要设计为字符型，这会降低查询和连接的性能，并会增加存储开销。这是因为引擎在处理查询和连接时会逐个比较字符串中每一个字符，而对于数字型而言只需要比较一次就够了
    2. 尽可能的使用 varchar/nvarchar 代替 char/nchar  
    因为首先变长字段存储空间小，可以节省存储空间，其次对于查询来说，在一个相对较小的字段内搜索效率显然要高些。  

    注意当字符和数值比较时, ORACLE会优先转换数值类型到字符类型

3. Temporary table
    1. 避免频繁创建和删除临时表，以减少系统表资源的消耗
    2. 尽量使用表变量来代替临时表。如果表变量包含大量数据，请注意索引非常有限（只有主键索引）
    3. 临时表并不是不可使用，适当地使用它们可以使某些例程更有效，例如，当需要重复引用大型表或常用表中的某个数据集时。但是，对于一次性事件，最好使用导出表。
    4. `在新建临时表时，如果一次性插入数据量很大，那么可以使用 select into 代替 create table，避免造成大量 log ，以提高速度；如果数据量不大，为了缓和系统表的资源，应先create table，然后insert。`
    5. 如果使用到了临时表，在存储过程的最后务必将所有的临时表显式删除，先 truncate table ，然后 drop table ，这样可以避免系统表的较长时间锁定。
    6. 使用基于游标的方法或临时表方法之前，应先寻找基于集的解决方案来解决问题，基于集的方法通常更有效

4. SQL optimization
    1. 解析过程优化  
        1. SELECT子句中避免使用 '\*'  
        ORACLE在解析的过程中, 会将'\*' 依次转换成所有的列名, 这个工作是通过查询数据字典完成的, 这意味着将耗费更多的时间
        2. 使用表的别名(Alias)  
        当在SQL语句中连接多个表时, 请使用表的别名并把别名前缀于每个Column上.这样一来,就可以减少解析的时间并减少那些由Column歧义引起的语法错误.  
        3. sql语句用大写  
        因为oracle总是先解析sql语句，把小写的字母转换成大写的再执行
        4. 选择最有效率的表名顺序(`只在基于规则的优化器中有效`)  
        ORACLE 的解析器按照从右到左的顺序处理FROM子句中的表名，FROM子句中写在最后的表(基础表 driving table)将被最先处理，在FROM子句中包含多个表的情况下,`你必须选择记录条数最少的表作为基础表`。如果有3个以上的表连接查询, 那就需要选择交叉表(intersection table)作为基础表, 交叉表是指那个被其他表所引用的表
        5. WHERE子句中的连接顺序  
        ORACLE采用自下而上的顺序解析WHERE子句,根据这个原理,表之间的连接必须写在其他WHERE条件之前, 那些可以过滤掉最大数量记录的条件必须写在WHERE子句的末尾.  
        6. On, Where, Having 的过滤顺序  
        避免使用HAVING子句, `HAVING 只会在检索出所有记录之后才对结果集进行过滤. 这个处理需要排序,总计等操作.`   如果能通过WHERE子句限制记录的数目,那就能减少这方面的开销. (非oracle中)on、where、having这三个都可以加条件的子句中，`on是最先执行，where次之，having最后`，因为on是先把不符合条件的记录过滤后才进行统计，它就可以减少中间运算要处理的数据，按理说应该速度是最快的，where也应该比having快点的，因为它过滤数据后才进行sum，在两个表联接时才用on的，所以在一个表的时候，就剩下where跟having比较了。在这单表查询统计的情况下，如果要过滤的条件没有涉及到要计算字段，那它们的结果是一样的，只是where可以使用rushmore技术，而having就不能，在速度上后者要慢如果要涉及到计算的字段，就表示在没计算之前，这个字段的值是不确定的，根据上篇写的工作流程，where的作用时间是在计算之前就完成的，而having就是在计算后才起作用的，所以在这种情况下，两者的结果会不同。`在多表联接查询时，on比where更早起作用。系统首先根据各个表之间的联接条件，把多个表合成一个临时表后，再由where进行过滤，然后再计算，计算完后再由having进行过滤。`由此可见，要想过滤条件起到正确的作用，首先要明白这个条件应该在什么时候起作用，然后再决定放在那里
    2. 语法细节的优化  
        1. 用UNION-ALL替代UNION
        2. 用UNION替换OR (适用于索引列)  
        通常情况下, 用UNION替换WHERE子句中的OR将会起到较好的效果.   对索引列使用OR将造成全表扫描. 注意, 以上规则只针对多个索引列有效.  如果有column没有被索引, 查询效率可能会因为你没有选择OR而降低.   
        3. 用IN来替代OR
        4. 避免使用耗费资源的操作  
        `带有DISTINCT,UNION,MINUS,INTERSECT,ORDER BY, GROUP BY的SQL语句会启动SQL引擎执行耗费资源的排序(SORT)功能.`  
        `DISTINCT需要一次排序操作, 而其他的至少需要执行两次排序`. 通常, 带有UNION, MINUS, INTERSECT的SQL语句都可以用其他方式重写.  如果你的数据库的`SORT_AREA_SIZE`调配得好, 使用UNION , MINUS, INTERSECT也是可以考虑的, 毕竟它们的可读性很强
        5. 用>=替代>  
        高效:  SELECT * FROM EMP WHERE DEPTNO >=4;  
        低效:  SELECT * FROM EMP WHERE DEPTNO >3;  
        两者的区别在于, 前者DBMS将直接跳到第一个DEPT等于4的记录而后者将首先定位到DEPTNO=3的记录并且向前扫描到第一个DEPT大于3的记录.
    3. 函数的使用  
        1. 使用DECODE函数来减少处理时间  
        decode（columnname，值1,翻译值1,值2,翻译值2,...值n,翻译值n,缺省值）
    4. 用TRUNCATE替代DELETE  
    当删除表中的记录时,在通常情况下, 回滚段(rollback segments ) 用来存放可以被恢复的信息. 如果你没有COMMIT事务,ORACLE会将数据恢复到删除之前的状态(准确地说是恢复到执行删除命令之前的状况) 而当运用TRUNCATE时, 回滚段不再存放任何可被恢复的信息.当命令运行后,数据不能被恢复.因此很少的资源被调用,执行时间也会很短. (译者按: TRUNCATE只在删除全表适用,TRUNCATE是DDL不是DML)  
    PS: truncate resets HWM(High water mark)
    5. 尽量多使用COMMIT  
    只要有可能,在程序中尽量多使用COMMIT, 这样程序的性能得到提高,需求也会因为COMMIT所释放的资源而减少:  
    COMMIT所释放的资源:  
    * 回滚段上用于恢复数据的信息
    * 被程序语句获得的锁
    * redo log buffer 中的空间
    * ORACLE为管理上述3种资源中的内部花费
    6. Others  
        1. 用EXISTS替换DISTINCT  
        当提交一个包含一对多表信息(比如部门表和雇员表)的查询时,避免在SELECT子句中使用DISTINCT. 一般可以考虑用EXIST替换, EXISTS 使查询更为迅速,因为RDBMS核心模块将在子查询的条件一旦满足后,立刻返回结果. 例子：  
        Assume there is no duplicated records in DEPT table
        (低效):  
        SELECT DISTINCT DEPT_NO,DEPT_NAME FROM DEPT D , EMP E  WHERE D.DEPT_NO = E.DEPT_NO;  
        (高效):     
        SELECT DEPT_NO,DEPT_NAME FROM DEPT D WHERE EXISTS ( SELECT 'X' FROM EMP E WHERE E.DEPT_NO = D.DEPT_NO);  
        2. 删除重复记录：最高效的删除重复记录方法 ( 因为使用了ROWID)例子：  
        DELETE FROM EMP E WHERE E.ROWID > (SELECT MIN(X.ROWID)  
        FROM EMP X WHERE X.EMP_NO = E.EMP_NO);
        3. 识别'低效执行'的SQL语句  
        虽然目前各种关于SQL优化的图形化工具层出不穷,但是写出自己的SQL工具来解决问题始终是一个最好的方法：  
        SELECT EXECUTIONS, DISK_READS, BUFFER_GETS,  
            ROUND((BUFFER_GETS-DISK_READS)/BUFFER_GETS,2) Hit_radio,  
            ROUND(DISK_READS/EXECUTIONS,2) Reads_per_run,  
            SQL_TEXT  
            FROM V$SQLAREA  
            WHERE EXECUTIONS>0  
            AND BUFFER_GETS > 0  
            AND (BUFFER_GETS-DISK_READS)/BUFFER_GETS < 0.8;

5. Optimization Misc
    1. 尽量避免使用游标  
    因为游标的效率较差，如果游标操作的数据超过1万行，那么就应该考虑改写。  
    与临时表一样，游标并不是不可使用。对小型数据集使用 FAST_FORWARD 游标通常要优于其他逐行处理方法，尤其是在必须引用几个表才能获得所需的数据时。在结果集中包括“合计”的例程通常要比使用游标执行的速度快。如果开发时 间允许，基于游标的方法和基于集的方法都可以尝试一下，看哪一种方法的效果更好。
    2. 在所有的存储过程和触发器的开始处设置 SET NOCOUNT ON ，在结束时设置 SET NOCOUNT OFF 。无需在执行存储过程和触发器的每个语句后向客户端发送 DONE_IN_PROC 消息。 

##### Raw Device
所谓裸设备（raw device）就是一种没有经过格式化的分区，也叫原始分区，是一种不需要通过文件系统来访问的特殊字符设备。在Linux下，通过块设备“绑定”到特殊字符设备得到裸设备。因为读写裸设备`不需要像访问块设备那样经过内核的块缓冲`(它由应用程序负责对它进行读写操作。不经过文件系统的缓冲)，所有的I/O读写都是直接在进程的内存空间到物理的寻址空间进行。

此外，由于避免了文件系统处理的开销，所以使用裸设备对于读写频繁的应用（如Oracle、DB2等数据库系统）来说，可以很好地提升应用的性能。然而，随着计算能力的提高，当应用存取数据的I/O瓶颈出现在存储设备的控制器或驱动器上时，通过裸设备的数据访问性能反而不比文件系统的高，同时文件系统的数据组织能力也更强。

在Unix的/dev 目录下，有许多文件，其中有两个大类：字符设备文件和块设备文件。  
字符设备特殊文件进行I/O操作不经过操作系统的缓冲区，而块设备特殊文件用来同外设进行定长的包传输。字符特殊文件与外设进行I/o操作时每次只传输一个字符。而对于块设备特殊文件来说，它用了cache机制，在外设和内存之间一次可以传送一整块数据。裸设备使用字符特殊文件。

因为使用裸设备避免了再经过Unix操作系统这一层，数据直接从Disk到Oracle进行传输，所以使用裸设备对于读写频繁的数据库应用来说，可以极大地提高数据库系统的性能。当然，这是以磁盘的I/O 非常大，磁盘I/O已经称为系统瓶颈的情况下才成立。如果磁盘读写确实非常频繁，以至于磁盘读写成为系统瓶颈的情况成立，那么采用裸设备确实可以大大提高性能，最大甚至可以提高至40％，非常明显。

而且，由于使用的是原始分区，没有采用文件系统的管理方式，对于Unix维护文件系统的开销也都没有了，比如不用再维护I-node，空闲块等，这也能够导致性能的提高。

如果使用了Oracle 并行服务器选项，则必须采用裸设备来存放所有的数据文件，控制文件，重做日志文件。只有把这些文件放到裸设备上，才能保证所有Oracle 实例都可以读取这个数据库的文件。这是由Unix操作系统的特性决定的。  
还有一种情况是，如果你想使用异步I/O，那么在有些Unix上也必须采用裸设备。这个需要参考具体Unix的相关文档。



### Oracle
#### Oracle Tuning
##### Oracle Optimizer Access Path
[For more information][oracle-optimizer-access-path-1]  

__Access Path__  
Access paths are ways in which data is retrieved from the database. In general, index access paths are useful for statements that retrieve a small subset of table rows, whereas full scans are more efficient when accessing a large portion of the table. Online transaction processing (OLTP) applications, which consist of short-running SQL statements with high selectivity, often are characterized by the use of index access paths. Decision support systems, however, tend to use partitioned tables and perform full scans of the relevant partitions.

There are 6 data access paths that the database can use to locate and retrieve any row in any table:   
* Full Table Scans
* Rowid Scans
* Index Scans
* Cluster Access
* Hash Access
* Sample Table Scans

1. Full Table Scans  
This type of scan reads all rows from a table and filters out those that do not meet the selection criteria. `During a full table scan, all blocks in the table that are under the high water mark are scanned.` The high water mark indicates the amount of used space, or space that had been formatted to receive data. Each row is examined to determine whether it satisfies the statement's WHERE clause.

When Oracle Database performs a full table scan, the blocks are read sequentially. Because the blocks are adjacent, the database can make I/O calls larger than a single block to speed up the process. The size of the read calls range from one block to the number of blocks indicated by the initialization parameter **DB_FILE_MULTIBLOCK_READ_COUNT**. `Using multiblock reads`, the database can perform a full table scan very efficiently. The database reads each block only once.

Full table scans are cheaper than index range scans when accessing a large fraction of the blocks in a table. Full table scans can use larger I/O calls, and making fewer large I/O calls is cheaper than making many smaller calls.

__The optimizer uses a full table scan in any of the following cases:__  
* Lack of Index
* Large Amount of Data  
If the optimizer thinks that the query requires most of the blocks in the table, then it uses a full table scan, even though indexes are available.
* Small Table  
If a table contains less than DB_FILE_MULTIBLOCK_READ_COUNT blocks under the high water mark, which the database can read in a single I/O call, then a full table scan might be cheaper than an index range scan, regardless of the fraction of tables being accessed or indexes present.
* High Degree of Parallelism  
A high degree of parallelism for a table skews the optimizer toward full table scans over range scans. Examine the DEGREE column in ALL_TABLES for the table to determine the degree of parallelism.
* higher index clustering factor  
use full table scan instead of index scan for large range scan

2. Rowid Scans  
The rowid of a row specifies the data file and data block containing the row and the location of the row in that block. `Locating a row by specifying its rowid is the fastest way to retrieve a single row, because the exact location of the row in the database is specified.`  
To access a table by rowid, `Oracle Database first obtains the rowids of the selected rows,` either from the statement's WHERE clause or through an index scan of one or more of the table's indexes. Oracle Database then locates each selected row in the table based on its rowid.  
__When the Optimizer Uses Rowids__  
`This is generally the second step after retrieving the rowid from an index.` The table access might be required for any columns in the statement not present in the index.  
Access by rowid does not need to follow every index scan. `If the index contains all the columns needed for the statement, then table access by rowid might not occur.`  

3. Index Scans  
In this method, a row is retrieved by traversing the index, using the indexed column values specified by the statement. An index scan retrieves data from an index based on the value of one or more columns in the index. To perform an index scan, Oracle Database searches the index for the indexed column values accessed by the statement. If the statement accesses only columns of the index, then Oracle Database reads the indexed column values directly from the index, rather than from the table.  
`The index contains not only the indexed value, but also the rowids of rows in the table having that value.` Therefore, if the statement accesses other columns in addition to the indexed columns, then Oracle Database can find the rows in the table by using either a table access by rowid or a cluster scan.  
__An index scan can be one of the following types:__  
* Assessing I/O for Blocks, not Rows(index clustering factor)
* Index Unique Scans
* Index Range Scans
* Index Range Scans Descending
* Index Skip Scans
* Full Scans
* Fast Full Index Scans
* Index Joins
* Bitmap Indexes  

    1. index clustering factor - Assessing I/O for Blocks, not Rows  
    Oracle Database performs I/O by blocks. Therefore, the optimizer's decision to use full table scans is influenced by the percentage of blocks accessed, not rows. This is called the __index clustering factor__.  
    Although the clustering factor is a property of the index, the clustering factor actually relates to the spread of similar indexed column values within data blocks in the table. `A lower clustering factor indicates that the individual rows are concentrated within fewer blocks in the table.` Conversely, a high clustering factor indicates that the individual rows are scattered more randomly across blocks in the table. Therefore, a high clustering factor means that it costs more to use a range scan to fetch rows by rowid, because more blocks in the table need to be visited to return the data(PS: in thi case, high index clustering factor, the index is not used for large range scan by optimizer).   
    2. Index Unique Scans  
    The database uses this access path when the user specifies `all columns of a unique (B-tree) index` or an index created as a result of `a primary key` constraint `with equality conditions.`  
    3. Index Range Scans  
    The optimizer uses a range scan when it finds `one or more leading columns of an index specified in conditions`, such as the following:  
        * col1 = :b1
        * col1 < :b1
        * col1 > :b1
        * AND  
        combination of the preceding conditions for leading columns in the index
        * col1 like 'ASD%', wild-card searches are not be in a leading position  
    Range scans can use unique or non-unique indexes  
    `Range scans avoid sorting when index columns constitute the ORDER BY/GROUP BY clause`  
    4. Index Range Scans Descending  
    An index range scan descending is identical to an index range scan, except that the data is returned in descending order. `Indexes, by default, are stored in ascending order`.   
    __Usually, the database uses this scan__  
        * when ordering data in a descending order to return the most recent data first
        * or when seeking a value less than a specified value  
    5. Index Skip Scans  
    Skip scanning lets a composite index be split logically into smaller subindexes. In skip scanning, `the initial column of the composite index is not specified in the query`. In other words, it is skipped.  
    The database determines the number of logical subindexes by the number of distinct values in the initial column. `Skip scanning is advantageous when there are few distinct values in the leading column of the composite index` and many distinct values in the nonleading key of the index.  
    6. Full (Index) Scans  
    A full (index) index scan `eliminates a sort operation`, because the data is ordered by the index key. `It reads the blocks singly`.   
    __Oracle Database may use a full scan in any of the following situations:__  
        1. `An ORDER BY clause` that meets the following requirements is present in the query:  
        * All of the columns in the ORDER BY clause must be in the index.
        * The order of the columns in the ORDER BY clause must match the order of the leading index columns.  
        The ORDER BY clause can contain all of the columns in the index or a subset of the columns in the index.  
        2. The query requires `a sort merge join`. The database can perform a full index scan instead of doing a full table scan followed by a sort when the query meets the following requirements:  
        * All of the columns referenced in the query must be in the index.
        * The order of the columns referenced in the query must match the order of the leading index columns.  
        The query can contain all of the columns in the index or a subset of the columns in the index.  
        3. `A GROUP BY clause` is present in the query  
        * the columns in the GROUP BY clause are present in the index. 
        * The columns do not need to be in the same order in the index and the GROUP BY clause.   
        The GROUP BY clause can contain all of the columns in the index or a subset of the columns in the index.  
    7. Fast Full Index Scans  
    Fast full index scans are an alternative to a full table scan when` the index contains all the columns that are needed for the query, and at least one column in the index key has the NOT NULL constraint`. A fast full scan accesses the data in the index itself, `without accessing the table`.   
    `The database cannot use this scan to eliminate a sort operation because the data is not ordered by the index key.` The database reads the entire index `using multiblock reads`, unlike a full index scan, and can scan in parallel.  
    You can specify fast full index scans with the initialization parameter OPTIMIZER_FEATURES_ENABLE or the INDEX_FFS hint. A fast full scan is faster than a normal full index scan because it can use multiblock I/O and can run in parallel just like a table scan.  
    8. Index Joins  
    An index join is a `hash join` of several indexes that `together contain all the table columns referenced in the query`. If the database uses an index join, then `table access is not needed` because the database can retrieve all the relevant column values from the indexes.   
    `The database cannot use an index join to eliminate a sort operation.`
    9. Bitmap Indexes  
    A bitmap join uses a bitmap for key values and a mapping function that converts each bit position to a rowid. Bitmaps can efficiently merge indexes that correspond to `several conditions in a WHERE clause`, `using Boolean operations to resolve AND and OR conditions`.

4. Cluster Access  
The database uses a `cluster scan` to retrieve all rows that have the same cluster key value from a table stored in `an indexed cluster`. `In an indexed cluster, the database stores all rows with the same cluster key value in the same data block.` To perform a cluster scan, Oracle Database first obtains the rowid of one of the selected rows by scanning the cluster index. Oracle Database then locates the rows based on this rowid.

5. Hash Access  
The database uses a `hash scan` to locate rows in `a hash cluster` based on a hash value. `In a hash cluster, all rows with the same hash value are stored in the same data block`. To perform a hash scan, Oracle Database first obtains the hash value by applying a hash function to a cluster key value specified by the statement. Oracle Database then scans the data blocks containing rows with that hash value.
6. Sample Table Scans  
A sample table scan retrieves `a random sample` of data from a `simple table` or `a complex SELECT statement, such as a statement involving joins and views`. The database uses this access path when a statement's `FROM clause includes the SAMPLE clause or the SAMPLE BLOCK clause`. 

##### Oracle Types of Joins
[For more information][oracle-optimizer-types-join-1]  
[For more information][oracle-optimizer-types-join-2]  

There are majorly 3 join types:   
1. Nested Loop Joins
2. Hash Joins
3. Sort Merge Joins

other 2 joins are different join concerns  
1. Cartesian Joins
2. Outer Joins

* Nested Loop Joins  
__Nested loop joins are useful when the following conditions are true:__  
1. The database joins small subsets of data.
2. The join condition is an efficient method of accessing the second table.

If the optimizer(CBO) chooses to use some other join method, then you can use the `USE_NL(table1 table2)` hint, where table1 and table2 are the aliases of the tables being joined.

`It is important to ensure that the inner table is driven from (dependent on) the outer table.` If the inner table's access path is independent of the outer table, then the same rows are retrieved for every iteration of the outer loop, degrading performance considerably. In such cases, hash joins joining the two independent row sources perform better.

`JOIN的顺序很重要，驱动表的记录集一定要小`，返回结果集的响应时间是最快的  

A nested loop join involves the following steps:  
1. The optimizer determines the driving table and designates it as the outer table.
2. The other table is designated as the inner table.
3. For every row in the outer table, Oracle Database accesses all the rows in the inner table. The outer loop is for every row in the outer table and the inner loop is for every row in the inner table.` The outer loop appears before the inner loop in the execution plan`, as follows:  
NESTED LOOPS   
  outer_loop   
  inner_loop  

```sql
select/*+ use_nl( test1, test2) */ * from test1, test2   
where test1.object_id = test2.object_id and rownum < 2;
```

* Hash Joins  
The database uses hash joins to `join large data sets`. The optimizer `uses the smaller of two tables` or data sources to build a hash table on the join key `in memory`. It then scans the larger table, probing the hash table to find the joined rows.  
This method is best when the smaller table fits in available memory. The cost is then limited to a single read pass over the data for the two tables.  
The optimizer uses a hash join to join two tables if they are joined using an `equijoin` and if either of the following conditions are true:
1. A large amount of data must be joined.
2. A large fraction of a small table must be joined.  
USE_HASH(table_name1 table_name2)  

* Sort Merge Joins  
Sort merge joins can join rows from `two independent sources`. `Hash joins generally perform better than sort merge joins`. However, sort merge joins can perform better than hash joins if both of the following conditions exist:  
1. The row sources are sorted already.
2. A sort operation does not have to be done.  
USE_MERGE(table_name1 table_name2)  

However, if a sort merge join involves choosing a slower access method (an index scan as opposed to a full table scan), then the benefit of using a sort merge might be lost.  
(在全表扫描比索引范围扫描再通过rowid进行表访问更可取的情况下，sort merge join会比nested loops性能更佳。)  
Sort merge joins are useful when the join condition between two tables is an `inequality condition such as <, <=, >, or >=.` `Sort merge joins perform better than nested loop joins for large data sets`. You cannot use hash joins unless there is an equality condition.   
In a merge join, there is no concept of a driving table. The join consists of two steps:  
1. Sort join operation: Both the inputs are sorted on the join key.
2. Merge join operation: The sorted lists are merged together.

`The optimizer can choose a sort merge join over a hash join for joining large amounts of data if any of the following conditions are true:`  
1. The join condition between two tables is not an equijoin.
2. Because of sorts required by other operations, the optimizer finds it is cheaper to use a sort merge than a hash join.  
3. PS: HASH_JOIN_ENABLED=false

它为最优化的吞吐量而设计，并且在结果没有全部找到前不返回数据。

* Cartesian join  
The database uses a Cartesian join when one or more of the tables does not have any join conditions to any other tables in the statement. The optimizer joins every row from one data source with every row from the other data source, creating the Cartesian product of the two sets.

#### Oracle Partitioning
[For more information][oracle-partitioning-1]  
ORACLE的分区(Partitioning Option)是一种处理超大型表的技术。分区是一种“分而治之”的技术，通过将大表和索引分成可以管理的小块，从而避免了对每个表作为一个大的、单独的对象进行管理，为大量数据提供了可伸缩的性能。  
* 分区通过将操作分配给更小的存储单元，减少了需要进行管理操作的时间
* 通过增强的并行处理提高了性能
* 通过屏蔽故障数据的分区，还增加了可用性

__在Oracle 11g中，Oracle支持三种普通分区以及两种组合分区:__  
ORACLE的分区表的划分方法包括：  
1. 按字段值进行划分的范围分区(RANGE)
2. 按字段的HASH 函数值进行的划分HASH 分区
3. 按字段值列表进行划分的列表 (LIST) 分区方法  
Oracle支持两种组合分区:  
4. 先按范围划分，再按HASH 划分的RANGE-HASH组合分区
5. 先按范围进行分区，再按LIST进行子分区的RANGE-LIST组合分区。

管理员可以指定每个分区的存储属性，分区在宿主文件系统(Storage subsystem)中的放置情况，这样便增加了对超大型数据库的控制粒度(granularity)。`分区可以被单独地删除、卸载或装入、备份、恢复，因此减少了需要进行管理操作的时间。`

`还可以为表分区创建单独的索引分区`，从而减少了需要进行索引维护操作的时间。此外，还提供了`种类繁多的局部和全局的索引技术`。

`分区操作也可以被并行执行。`

分区技术还提高了数据的可用性。当部分数据由于故障或其它原因不可用时，其它分区内的数据可用不收影响继续使用。

分区对应用是透明的，可以通过标准的SQL语句对分区表进行操作。Oracle 的优化器在访问数据时会分析数据的分区情况，在进行查询时，那些不包含任何查询数据的分区将被忽略，从而大大提高系统的性能。

* Range分区  
`范围分区是最常使用的一种分区。`  
范围分区根据分区字段（Partition Key）的值实现数据和分区的映射。
分区的字段可以是一个或多个字段(an ordered list of columns)组合。分区字段可以是除ROWID，LONG，LONG，LOB TIMESTAMP WITH TIME ZONE之外其他数据库内嵌数据类型。
在创建范围分区时，应指定各分区的值域和各个分区的存储特性。  
__适用情景__  
1. 范围分区特别适用于待处理分区数据在分布上具有逻辑范围或范围值域，如数据在按月份进行分区。`当数据能够在所有分区上均匀分布时范围分区能获得非常好的性能，若因数据分布不均匀而导致各个分区数据在数据量上变化很大，则应考虑采用其他的分区方法。`  
2. 范围分区也适用于数据随时间变化而增长的情景。  
3. 范围分区亦适用于数据归档和定期维护的需要，若能结合业务的需要定义好范围分区可实现按分区归档和数据维护的需要。

通过设定分区的值域(partition bond)，范围分区可以显式地指定数据的分布。

```sql
CREATE TABLE sales_range
(salesman_id NUMBER(5),
salesman_name VARCHAR2(30),
sales_amount NUMBER(10),
sales_date DATE)
COMPRESS
PARTITION BY RANGE(sales_date) —- partition key
(PARTITION sales_jan2000 VALUES LESS THAN(TO_DATE(’02/01/2000′,’DD/MM/YYYY’)),
PARTITION sales_feb2000 VALUES LESS THAN(TO_DATE(’03/01/2000′,’DD/MM/YYYY’)),
PARTITION sales_mar2000 VALUES LESS THAN(TO_DATE(’04/01/2000′,’DD/MM/YYYY’)),
PARTITION sales_apr2000 VALUES LESS THAN(TO_DATE(’05/01/2000′,’DD/MM/YYYY’)));

CREATE TABLE sales
( invoice_no NUMBER,
sale_year INT NOT NULL,
sale_month INT NOT NULL,
sale_day INT NOT NULL )
PARTITION BY RANGE (sale_year, sale_month, sale_day) –partition key
( PARTITION sales_q1 VALUES LESS THAN (1999, 04, 01) TABLESPACE tsa,
PARTITION sales_q2 VALUES LESS THAN (1999, 07, 01) TABLESPACE tsb,
PARTITION sales_q3 VALUES LESS THAN (1999, 10, 01) TABLESPACE tsc,
PARTITION sales_q4 VALUES LESS THAN (2000, 01, 01) TABLESPACE tsd 
);
```

* List分区  
List分区以可以实现将`无关、无序的离散数据集`组合到一个分区。

* Hash分区  
`哈希分区是实现数据在各个分区上均匀分区的最佳分区方式`  
`当数据与时间的关系不紧密时，哈希分区可用于替代范围分区。`  
因为数据的分布完全由哈希算法决定，因此采用哈希分区主要是希望通过将数据均匀分布到各个分区以获得性能上的提升。  
由于哈希分区的实现是基于哈希函数，因此不支持如删除哈希分区、合并哈希分区以及拆分哈希分区操作等一些分区操作。但支持增加、交换、移动、缩减等分区操作。

```sql
-- 下面的示例是创建一个4个HASH 分区表的例子，并为各个分区指定了表空间。
CREATE TABLE scubagear
( id NUMBER,
name VARCHAR2 (60))
PARTITION BY HASH (id) –-哈希分区
PARTITIONS 4 –-分区数
STORE IN (gear1, gear2, gear3, gear4);
```

__表分区原则__  
* 表的大小  
对于大表进行分区，将有益于大表操作的性能和大表的数据维护。通常当表的`大小超过1.5GB－2GB`，或对于OLTP系统，`表的记录超过1000万`，都应考虑对表进行分区。
* 数据访问特性  
若基于表的大部分查询应用，只访问表中`少量或者部分数据`，对于这样表进行分区，可充分利用分区排除无关数据查询 (partition-pruning) 的特性。
* 并行数据操作 （Parallel DML）  
对于经常执行并行操作 （如 Parallel Insert, Parallel Update 等） 的表应考虑进行分区。
* 数据维护  
某些表的数据维护，经常按时间段删除成批的数据或者按特定规则进行数据归档，例如按月删除历史数据。对于这样的表需要考虑进行分区，以满足维护的需要。因为删除（Delete）大量的数据，对系统开销很大，有时甚至是不可接受的。
* 只读数据  
如果一个表中大部分数据都是只读数据，通过对表进行分区，可将只读数据存储在只读表空间中，对于数据库的备份是非常有益的。
* 表的可用性  
当对表的部分数据可用性要求很高时，应考虑进行表分区。

__索引分区(oracle)__  
`对表进行分区的规则同样适用对索引进行分区。`  
表（无论分区与否）上的索引可以是分区的也可以是非分区的。  
分区表可以有分区的或者不分区的B-Tree索引。

__Oracle 提供了如下三种分区索引：__  
1. Local Prefixed Index
2. Local Non-Prefixed Index
3. Global Prefixed Index

Local (Prefixed/Non-Prefixed)   
Index指的是索引分区内的索引键值指向的记录都对应到基表的一个分区，即`索引分区和基表分区是equipartitioned（分区一一对应）`  

Global Index是指索引分区与表分区相互独立，不存在索引分区和表分区之间的一一对应关系  

若分区索引的partition key 是基表(Base table)的partition key的严格左前缀，则称之为Local Prefixed Index。  

若索引分区的partition key不是基表partition key的严格左前缀(left prefix)，则称之为Local Non-prefixed Index。

若一个全局分区索引按其索引字段的严格左前缀进行分区则称之为Global Prefixed Index。反之，若全局分区索引不采用其索引字段的左前缀进行分区则称为Global Non-prefixed Index。`Oracle不支持采用Global Non-prefixed Index。`  
例：假设索引基于字段（A、B、C），则可以采用（A、B、C）、（A、B）、（A、C）或者A作为全局分区的Partition Key；但不可以采用（B、C）、B或者C作为Partition Key。

Oracle的Global Partition Index，支持分别按Range或Hash进行全局索引划分

`采用HASH全局分区索引，索引键值被HASH按分区字段(Partition Key)分散到不同的分区上，有效地降低了竞争和提高了性能。`包含有“=”或者“IN”等条件子句的查询能够有效地利用全局HASH索引分区的特性，在以下两种情景尤其适用：  
1. `在并发多用户应用（OLTP）中若索引的部分页节点数据库存在竞争，则采用HASH进行全局索引分区能有效提高性能；`
2. 若索引所对应的索引字段在应用上存在单调增的特性，则容易导致索引一直进行右扩，索引树严重不均衡，最右端的索引块容易成为“热点”，导致性能下降；

上述索引分别适应于不同的性能和数据管理需求，一般可通过下图所定义的规则，可确定分区索引类型：  
![oracle-partitioning-img-1]  

#### Oracle Concurrency


#### Oracle Misc

##### High Water Mark (HWM)
[For more information][oracle-misc-high-water-mark-1]  

The __high water mark (HWM)__ is the boundary between used and unused space `in a segment`. As requests for new free blocks that cannot be satisfied by existing `free lists` are received, the block to which the high water mark points becomes a used block, and the high water mark is advanced to the next block. In other words, the segment space to the left of the high water mark is used, and the space to the right of it is unused.  
Figure B-5 shows a segment consisting of three extents containing 10K, 20K, and 30K of space, respectively. The high water mark is in the middle of the second extent. Thus, the segment contains 20K of used space to the left of the high water mark, and 40K of unused space to the right of the high water mark.  
![oracle-misc-high-water-mark-img-1]  

所有的oracle段 都有一个在段(Segment)内容纳数据的上限，我们把这个上限称为"high water mark"或HWM。这个HWM是一个标记，用来说明已经有多少没有使用的数据块分配给这个segment。HWM通常增长的幅度为一次5个数据块，`原则上HWM只会增大，不会缩小，即使将表中的数据全部删除，HWM还是为原值`，由于这个特点，使HWM很象一个水库的历史最高水位，这也就是HWM的原始含义，当然不能说一个水库没水了，就说该水库的历史最高水位为0。`但是如果我们在表上使用了truncate命令，则该表的HWM会被重新置为0`

__HWM数据库的操作有如下影响：__  
* 全表扫描通常要读出直到HWM标记的所有的属于该表数据库块，即使该表中没有任何数据。
* 即使HWM以下有空闲的数据库块，键入在插入数据时使用了append hint，则在插入时使用HWM以上的数据块，此时HWM会自动增大。

__低HWM__  
在手动段空间管理（Manual Segment Space Management）中，段中只有一个HWM，但是在Oracle9i Release才添加的自动段空间管理（Automatic Segment Space Management）中，又有了一个`低HWM`的概念出来。为什么有了HWM还又有一个低HWM呢，这个是因为自动段空间管理的特性造成的。在手段段空间管理中，当数据插入以后，如果是插入到新的数据块中，数据块就会被自动格式化等待数据访问。而在自动段空间管理中，数据插入到新的数据块以后，数据块并没有被格式化，而是在第一次在第一次访问这个数据块的时候才格式化这个块。`所以我们又需要一条水位线，用来标示已经被格式化的块`。这条水位线就叫做低HWM。一般来说，低HWM肯定是低于等于HWM的。

__修正ORACLE表的高水位线__  
`在ORACLE中，执行对表的删除操作不会降低该表的高水位线。而全表扫描将始终读取一个段(extent)中所有低于高水位线标记的块`。如果在执行删除操作后不降低高水位线标记，则将导致查询语句的性能低下。  
下面的方法都可以降低高水位线标记:  
1. 执行alter指令  
    1. 执行表重建指令  
    alter table table_name move;  
    (在线转移表空间ALTER TABLE 。。。 MOVE TABLESPACE 。。。ALTER TABLE 。。。 MOVE 后面不跟参数也行，不跟参数表还是在原来的表空间，move后记住重建索引。如果以后还要继续向这个表增加数据，没有必要move，只是释放出来的空间，只能这个表用，其他的表或者segment无法使用该空间)  
    2. 执行alter table table_name shrink space;  
    注意，此命令为Oracle 10g新增功能，再执行该指令之前必须允许行移动alter table table_name enable row movement;  
    3. alter table table_name deallocate unused
2. 复制要保留的数据到临时表t，drop原表，然后rename临时表t为原表
3. emp/imp
4. 尽量truncate吧

##### index clustering factor
发现字段上有索引，但是执行计划就是不走索引, 原因之一是索引的集群因子过高导致的  

__The clustering factor is:__  
Indicates the amount of order of the rows in the table based on the values of the index.   
1. If the value is near the number of blocks(or very low), then the table 
is very well ordered. In this case, the index entries in a 
single leaf block tend to point to rows in the same data 
blocks. 
2. If the value is near the number of rows(or very high), then the table 
is very randomly ordered. In this case, it is unlikely 
that index entries in the same leaf block point to rows 
in the same data blocks. 

The clustering factor is useful as `a rough measure of the number of I/Os` required to read an entire table by means of an index:  
1. If the clustering factor is high,then Oracle Database performs a relatively high number of I/Os during a large index range scan.The index entries point to random table blocks,so the database may have to read and reread the same blocks over and over again to retrieve the data pointed to by the index.  
2. If the clustering factor is low,then Oracle Database performs a relatively low number of I/Os during a large index range scan.The index keys in arange tend to point to the same data blcok,so the database does not have to read and reread the same blocks over and over.

__The clustering factor is relevant for index scans because it can show:__  
1. Whether the database will use an index for large range scans  
PS: if clustering factor is too high, optimizer will use full table scan instead of large range scans by the index.
2. The degree of table organization in relation to the index key;
3. Whether you should consider using an `index-organized table`,`partitioning`,or `table cluster` if rows must be ordered by the index key.

__Clustering Factor的计算方式如下：__  
1. 扫描一个索引(large index range scan)
2. 比较某行的rowid和前一行的rowid，如果这两个rowid不属于同一个数据块，那么cluster factor增加1
3. 整个索引扫描完毕后，就得到了该索引的clustering factor。

如果clustering factor接近于表存储的块数，说明这张表是按照索引字段的顺序存储的。  
如果clustering factor接近于行的数量，那说明这张表不是按索引字段顺序存储的。  
在计算索引访问成本的时候，这个值十分有用。Clustering Factor乘以选择性参数(selectivity)就是访问索引的开销。

The clustering_facotr column in the `user_indexes` view 
is a measure of how organized the data is compared to the indexed column.

how to improve it(reduce index clustering factor)?  
1. `index-organized table`,`partitioning`,or `table cluster`
If you want an index to be very clustered -- consider using index organized tables. They force the rows into a specific physical location based on their index entry. 
2. rebuild of the table  
Otherwise, a rebuild of the table is the only way to get it clustered (but you really don't want to get into that habit for what will typically be of marginal overall improvement). 

##### Oracle Clustered index vs non clustered index
[For more information][oracle-index-1]  
A table or view can contain the following types of indexes:  
1. Clustered  
    1. Clustered indexes `sort and store the data rows in the table or view` based on their key values. These are the columns included in the index definition. There can be `only one clustered index per table`, because the data rows themselves can be sorted in only one order(PS: same order as clustered index).  
    2. `The only time the data rows in a table are stored in sorted order is when the table contains a clustered index`. When a table has a clustered index, the table is called a clustered table. If a table has no clustered index, its data rows are stored in an unordered structure called a heap.  
2. Nonclustered  
    1. Nonclustered indexes have `a structure separate from the data rows`. A nonclustered index contains the nonclustered index key values and each key value entry has a pointer to the data row that contains the key value.  
    2. The pointer from an index row in a nonclustered index to a data row is called a row locator. The structure of the row locator depends on whether the data pages are stored in a heap or a clustered table. For a heap, a row locator is a pointer to the row. For a clustered table, the row locator is the clustered index key.  
    3. You can add nonkey columns to the leaf level of the nonclustered index to by-pass existing index key limits, 900 bytes and 16 key columns, and execute fully covered, indexed, queries. For more information, see Create Indexes with Included Columns. 

A clustered index is a special type of index that reorders the way records in the table are physically stored. Therefore table can have only one clustered index. `The leaf nodes of a clustered index contain the data pages.`

A nonclustered index is a special type of index in which the logical order of the index does not match the physical stored order of the rows on disk. The leaf node of a nonclustered index does not consist of the data pages. Instead, `the leaf nodes contain index rows.`

缺省情况下建立的索引是非聚簇索引，但有时它并不是最佳的。在非群集索引下，数据在物理上随机存放在数据页上。合理的索引设计要建立在对各种查询的分析和预测上。一般来说：   
1. 有大量重复值、且经常有范围查询（ > ,< ，> =,< =）和order by、group by发生的列，可考虑建立群集索引 
2. 组合索引要尽量使关键查询形成索引覆盖，其前导列一定是使用最频繁的列

下表给出了何时使用聚簇索引与非聚簇索引???:  

动作              |使用聚簇索引  |使用非聚簇索引
------------------|-------------|-------------
小数目的不同值     |应           |不应
大数目的不同值     |不应         |应

##### Oracle index-organized table & heap-organized table
__An index-organized table__ is a table stored `in a variation of a B-tree index structure`. In a heap-organized table, rows are inserted where they fit. In an index-organized table, rows are stored in an index defined on the primary key for the table. `Each index entry in the B-tree also stores the non-key column values. Thus, the index is the data, and the data is the index.` Applications manipulate index-organized tables just like heap-organized tables, using SQL statements.

`Index-organized tables are useful when related pieces of data must be stored together or data must be physically stored in a specific order.` This type of table is often used for information retrieval, spatial (see "Overview of Oracle Spatial"), and OLAP applications (see "OLAP").

__heap-organized table__  
A table in which the data rows are stored in no particular order on disk. `By default, CREATE TABLE creates a heap-organized table.`

##### Table clusters (clustered tables)
[For more information][oracle-cluster-1]  
`A table cluster is a group of tables that share common columns and store related data in the same blocks.` `When tables are clustered, a single data block can contain rows from multiple tables.` For example, a block can store rows from both the employees and departments tables rather than from only a single table.

`The cluster key value is the value of the cluster key columns for a particular set of rows`. All data that contains the same cluster key value, such as department_id=20, is physically stored together. `Each cluster key value is stored only once in the cluster and the cluster index, no matter how many rows of different tables contain the value.`

`You can consider clustering tables when they are primarily queried (but not modified) and records from the tables are frequently queried together or joined. `Because table clusters store related rows of different tables in the same data blocks, properly used table clusters offer the following benefits over nonclustered tables:  
1. Disk I/O is reduced for joins of clustered tables.
2. Access time improves for joins of clustered tables.
3. Less storage is required to store related table and index data because the cluster key value is not stored repeatedly for each row.  

Typically, clustering tables is not appropriate in the following situations:  
1. The tables are frequently updated.
2. The tables frequently require a full table scan.
3. The tables require truncating.

###### Oracle Indexed Clusters
`An indexed cluster is a table cluster that uses an index to locate data.` `The cluster index is a B-tree index on the cluster key`. A cluster index must be created before any rows can be inserted into clustered tables.

Assume that you create the cluster employees_departments_cluster with the cluster key department_id, as shown in Example. Because the HASHKEYS clause is not specified, this cluster is an indexed cluster. Afterward, you create an index namedidx_emp_dept_cluster on this cluster key.

```sql
CREATE CLUSTER employees_departments_cluster
   (department_id NUMBER(4))
SIZE 512;

CREATE INDEX idx_emp_dept_cluster ON CLUSTER employees_departments_cluster;

-- You then create the employees and departments tables in the cluster, specifying the department_id column as the cluster key, as follows 

CREATE TABLE employees ( ... )
   CLUSTER employees_departments_cluster (department_id);
 
CREATE TABLE departments ( ... )
   CLUSTER employees_departments_cluster (department_id);
```

Finally, you add rows to the employees and departments tables. The database physically stores all rows for each department from the employees and departments tables in the same data blocks. `The database stores the rows in a heap` and locates them with the index. 

Figure below shows the employees_departments_cluster table cluster, which contains employees and departments. The database stores rows for employees in department 20 together, department 110 together, and so on. If the tables are not clustered, then the database does not ensure that the related rows are stored together.   
![oracle-cluster-img-1]  

The cluster index is separately managed, just like an index on a nonclustered table, and can exist in a separate tablespace from the table cluster.


###### Oracle Hash Clusters
A hash cluster is like an indexed cluster, `except the index key is replaced with a hash function`. No separate cluster index exists. `In a hash cluster, the data is the index.`  

With an indexed table or indexed cluster, Oracle Database locates table rows using key values stored in a separate index. To find or store a row in an indexed table or table cluster, the database must perform at least two I/Os:
* One or more I/Os to find or store the key value in the index
* Another I/O to read or write the row in the table or table cluster

To find or store a row in a hash cluster, Oracle Database applies the hash function to the cluster key value of the row. The resulting hash value corresponds to a data block in the cluster, which the database reads or writes on behalf of the issued statement.

Hashing is an optional way of storing table data to improve the performance of data retrieval. Hash clusters may be beneficial when the following conditions are met:  
* A table is `queried much more often than modified.`
* The hash key column is queried frequently with `equality conditions`
* You can reasonably guess the number of hash keys and the size of the data stored with each key value.

##### for update nowait vs for update
For following operations,   
sql_1:select 1 from dual for update;  
sql_2:select 1 from dual for update;  
sql_3:select 1 from dual for update nowait;  

1. 执行sql_1,不提交,表dual被锁
2. 分支1):执行sql_2,sql_2被阻塞,等待sql_1提交
3. 分支2):执行sql_3,因为有nowait,所以立即返回错误信息 "ORA-00054 : 资源正忙,但指定以NOWAIT方式获取资源"

总结:nowait关键字,通知Oracle该sql语句采用非阻塞的方式修改或删除数据,如果发现涉及到的数据被占有(被锁),则立即通知Oracle该资源被占用,返回错误信息

##### Oracle Temporary segment
When processing queries, ORACLE often requires temporary workspace for intermediate stages of SQL statement processing. This disk space is called temporary segment, which is automatically allocated by ORACLE. The following commands may require the use of a temporary segment:  
* CREATE INDEX
* SELECT ... ORDER BY
* SELECT DISTINCT ...
* SELECT ... GROUP BY
* SELECT ... UNION
* SELECT ... INTERSECT
* SELECT ... MINUS

##### Oracle Temporary Table
临时表，最主要的好处是，操作不留任何痕迹、不产生日志，所以速度快

create [global] temporary table ,加上[global]就是全局的临时表（所有数据库连接会话都是可见的），
不加则为私有的（在一个数据库连接会话期间有效）

创建Oracle 临时表，还可以有两种类型的临时表：  
1. 会话级的临时表
2. 事务级的临时表 

* 会话级的临时表  
因为这这个临时表中的数据和你的当前会话有关系，当你当前SESSION 不退出的情况下，临时表中的数据就还存在，而当你退出当前SESSION 的时候，临时表中的数据就全部没有了，当然这个时候你如果以另外一个SESSION 登陆的时候是看不到另外一个SESSION 中插入到临时表中的数据的。即两个不同的SESSION 所插入的数据是互不相干的。当某一个SESSION 退出之后临时表中的数据就被截断(truncate table ，即数据清空)了。会话级的临时表创建方法：  
```sql
Create [Global] Temporary Table Table_Name
(Col1 Type1,Col2 Type2...) On Commit Preserve Rows;
```
* 事务级临时表  
指该临时表与事务相关，`当进行事务提交或者事务回滚的时候，临时表中的数据将自行被截断`，其他的内容和会话级的临时表的一致(包括退出SESSION 的时候，事务级的临时表也会被自动截断)。事务级临时表的创建方法：  
```sql
Create [Global] Temporary Table Table_Name
(Col1 Type1,Col2 Type2...) On Commit Delete Rows;
```

##### Oracle truncate vs delete
两者都可以用来删除表中所有的记录。  
区别在于：truncate是DDL操作，它移动HWK，不需要 rollback segment .而Delete是DML操作, 需要rollback segment 且花费较长时间.

##### Oracle startup and shutdown

STARTUP NOMOUNT – 数据库实例启动  
STARTUP MOUNT - 数据库装载  
STARTUP OPEN – 数据库打开

Database and Instance Startup:  
1. Start database [reads Parameter file before this]
    1. allocate & create SGA, Background processes
2. Mount database
    1. Associate database with previously started instance
    2. Close database
    3. Find and open control file
    4. Read Redo /data file names from this file and confirm existence
3. Open database
    1. Open online log files and data files
    2. Automatically perform instance recovery(SMON)
    3. Acquire one/more rollback segments

Database and Instance Shutdown:  
1. Close database
    1. Write all buffer data to disk
    2. Close Online redo files and data files
    3. Close database
2. Dismount database
    1. Close control files
    2. Dissociate database from Instance
3. Shut down instance
    1. Remove SGA from memory
    2. Terminate background processes

##### Oracle Uncategorized

__Oracle服务/实例的创建过程__  
* 创建实例
* 启动实例
* 创建数据库(system表空间是必须的)

__启动过程__  
* 实例启动
* 装载数据库
* 打开数据库

oracle提供了建表参数`nologging`，使对该表的操作不参与事物的回滚

__根据其他表数据更新表__  
一条更新语句是不能更新多张表的，除非使用触发器隐含更新.   
根据其他表数据更新你要更新的表
一般形式：  
* MYSQL/Sybase  
```sql
update a
set 字段1=b表字段表达式,
字段2=b表字段表达式
from b 
where 逻辑表达式
```
* oracle 8i
```sql
update a
set 字段1=（select 字段表达式 from b where ...）,
字段2=（select 字段表达式 from b where ...）
where 逻辑表达式
```

__动态执行sql语句__  
* MYSQL  
```sql
declare @count int
declare @sql nvarchar(200)
set @sql = n''select count(*) from sysobjects''
exec sp_executesql @sql,n''@i int output'',@count output
```
* oracle 8i  
    1. 程序包dbms_sql  
    执行一个语句的过程：  
    打开游标（open_cursor，对于非查询语句，无此过程）  
    分析语句（parse)  
    绑定变量（bind_variable）  
    执行语句（execute)  
    关闭游标（close_cursor,对于非查询语句，无此过程)  
    2. execute immediate ls_sql

外连接语法:  
字段1 = 字段2(+) （左连接）
字段1(+) = 字段2 （右连接）


__归档模式 vs 非归档模式__  
归档模式是指你可以备份所有的数据库 transactions并恢复到任意一个时间点。非归档模式则相反，不能恢复到任意一个时间点。但是非归档模式可以带来数据库性能上的少许提高

__热备份 vs 冷备份__  
热备份针对归档模式的数据库，在数据库仍旧处于工作状态时进行备份。而冷备份指在数据库关闭后，进行备份，适用于所有模式的数据库。热备份的优点在于当备份时，数据库仍旧可以被使用并且可以将数据库恢复到任意一个时间点。冷备份的优点在于它的备份和恢复操作相当简单，并且由于冷备份的数据库可以工作在非归档模式下,数据库性能会比归档模式稍好。（因为不必将archive log写入硬盘）


###### Oracle account: sys and system
sys存储oracle服务或者实例的信息及所有用户的数据字典信息

system用户拥有数据字典是视图信息，有了这些视图，我们的查询数据库的信息就特别方便

缺省情况下，system用户拥有dba系统角色权限，而sys不仅拥有dba的权限还拥有sysdba的权限

###### Oracle dba vs sysdba
sysdba，是管理oracle实例的，它的存在不依赖于整个数据库完全启动，只要实例启动了，他就已经存在，以sysdba身份登陆，装载数据库、打开数据库.   
只有数据库打开了，或者说整个数据库完全启动后，dba角色才有了存在的基础

###### Oracle new schema objects
* 实例化视图  
又称显形图：实例化说明他有自己的存储空间，视图：说明他的数据来源于其他表数据。  
实例化视图中的数据，设置为隔一段时间更新数据，更新的模式可以定义为完全更新和增量更新
* 快照  
基本上同实例化视图,只不过数据来源不同,`快照数据来愿于远程数据库`，而`实例化视图则来源于本地数据表`
* 序列  
相当于ms sql中的identity列，他是一个数字顺序列表
* 程序包  
他是过程、函数、全局变量的集合，他封装了私有变量、私有过程和私有函数. 如：dbms_out包
* 同义词  
是对数据库中的对象的`别名`, 同义词可以是全局的也可以是私有的（属于某个用户的）如：tab,col等
* 抽象的数据类型  
类似于c中的结构体或pascal记录类型  
table%rowtype,这是一个特别的抽象的数据类型，该类型的分量就是tab的字段  
table.tname%type,这定义了一个和tab的字段tname相同的数据类型的变量  

### Miscellaneous

#### Partitioning
[For more information][general-partitioning-1]  
A partition is a division of a logical database or its constituent elements into distinct independent parts. Database partitioning is normally done for  
* manageability
* performance or availability reasons, as for load balancing

__Types of partitioning__  
Current high end relational database management systems provide for different criteria to split the database. `They take a partitioning key and assign a partition based on certain criteria.`   
Common criteria are:    
* Range partitioning   
Selects a partition by determining if the partitioning key is inside a certain range. An example could be a partition for all rows where the column zipcode has a value between 70000 and 79999.
* List partitioning  
A partition is assigned a list of values. If the partitioning key has one of these values, the partition is chosen. For example all rows where the column Country is either Iceland, Norway, Sweden, Finland or Denmark could build a partition for the Nordic countries.
* Hash partitioning   
The value of a hash function determines membership in a partition. Assuming there are four partitions, the hash function could return a value from 0 to 3.
* Composite partitioning  
allows for certain combinations of the above partitioning schemes, by for example first applying a range partitioning and then a hash partitioning.  Consistent hashing could be considered a composite of hash and list partitioning where the hash reduces the key space to a size that can be listed.
* Round-robin partitioning  
PS: rows evenly distributed, good for sequential query, very difficult for range query(since all partitions need to be read for range query)

__Partitioning methods__  
* Horizontal partitioning
* Vertical partitioning (Column partitioning)  

PS: Table partitioned vertically on a column, and the column can’t be modified, ex. DB2

#### Concurrency

##### Concurrent read/write issues
There are 4 types of issues:  
1. Dirty Read (Uncommitted Dependency)
2. Lost Updates
3. Nonrepeatable Read (Inconsistent Analysis)
4. Phantom Reads

* Dirty Read (Uncommitted Dependency)  
Uncommitted dependency occurs when a second transaction selects a row that is being updated by another transaction. The second transaction is reading data that has not been committed yet and may be changed by the transaction updating the row.

* Lost Update  
Lost updates occur when two or more transactions select the same row and then update the row based on the value originally selected. Each transaction is unaware of other transactions. The last update overwrites updates made by the other transactions, which results in lost data.  
The "lost update" problem relates to concurrent reads and updates to data, in a system where readers do not block writers. It is not necessary for the transactions to be exactly simultaneous.
    1. Session #1 reads Account A, gets 100. 
    2. Session #2 reads Account A, gets 100. 
    3. Session #2 updates Account A to 150 (+50) and commits. 
    4. Session #1 updates Account A to 120 (+20) and commits.  
In this scenario, because Session #1 does not know that another session has already modified the account, the update by Session #2 is overwritten ("lost").
There are several ways to solve this, e.g. version numbers or before-and-after compares.

* Nonrepeatable Read (Inconsistent Analysis)  
Inconsistent analysis occurs when a second transaction accesses the same row several times and reads different data each time. Inconsistent analysis is similar to uncommitted dependency in that another transaction is changing the data that a second transaction is reading. However, in inconsistent analysis, the data read by the second transaction was committed by the transaction that made the change. Also, inconsistent analysis involves multiple reads (two or more) of the same row and each time the information is changed by another transaction; thus, the term nonrepeatable read.

* Phantom Reads  
Phantom reads occur when an insert or delete action is performed against a row that belongs to a range of rows being read by a transaction. The transaction's first read of the range of rows shows a row that no longer exists in the second or succeeding read, as a result of a deletion by a different transaction. Similarly, as the result of an insert by a different transaction, the transaction's second or succeeding read shows a row that did not exist in the original read.

##### Isolation Level and lock

Isolation Level\Phenomenons |Dirty Read|Lost Update|Unrepeatable Read|Phantom Records
--------------------|-------|-------|-------|------
Read uncommitted    |yes    |yes    |yes    |yes
Read committed      |no     |__YES__|yes    |yes
Repeatable read     |no     |no     |no     |yes
Snapshot            |no     |no     |no     |no
Serializable        |no     |no     |no     |no

Isolation Level\Lock    |Range Lock |Read Lock  |Write Lock
------------------------|-----------|-----------|------------
Read Uncommitted        |no         |no         |no
Read Committed          |no         |no         |yes
Repeatable Read         |no         |yes        |yes
Serializable            |yes        |yes        |yes

__Repeatable Read isolation level__  
The Repeatable Read isolation level allows a transaction to acquire read locks on all rows of data it returns to an application, and write locks on all rows of data it inserts, updates, or deletes. By using the Repeatable Read isolation level, SELECT SQL statements issued multiple times within the same transaction will always yield the same result. A transaction using the Repeatable Read isolation level can retrieve and manipulate the same rows of data as many times as needed until it completes its task. However, no other transaction can insert, update, or delete a row of data that would affect the result table being accessed, until the isolating transaction releases its locks. That is, when the isolating transaction is either committed or rolled back.
 
Transactions using the Repeatable Read isolation level wait until rows of data that are write-locked by other transactions are unlocked before they acquire their own locks. This prevents them from reading "dirty" data. In addition, because other transactions cannot update or delete rows of data that are locked by a transaction using the Repeatable Read isolation level, nonrepeatable read situations are avoided.

__snapshot isolation__  
A transaction executing under snapshot isolation appears to operate on a personal snapshot of the database, taken at the start of the transaction. When the transaction concludes, it will successfully commit only if the values updated by the transaction have not been changed externally since the snapshot was taken. Such a write-write conflict will cause the transaction to abort.  
If built on multiversion concurrency control, snapshot isolation allows transactions to proceed without worrying about concurrent operations, and more importantly without needing to re-verify all read operations when the transaction finally commits. The only information that must be stored during the transaction is a list of updates made, which can be scanned for conflicts fairly easily before being committed.

##### write skew anomaly
In a __write skew anomaly__, two transactions (T1 and T2) concurrently read an overlapping data set (e.g. values V1 and V2), concurrently make disjoint updates (e.g. T1 updates V1, T2 updates V2), and finally concurrently commit, neither having seen the update performed by the other. Were the system serializable, such an anomaly would be impossible, as either T1 or T2 would have to occur "first", and be visible to the other. `In contrast, snapshot isolation permits write skew anomalies.`

As a concrete example, imagine V1 and V2 are two balances held by a single person, Phil. The bank will allow either V1 or V2 to run a deficit, provided the total held in both is never negative (i.e. V1 + V2 ≥ 0). Both balances are currently $100. Phil initiates two transactions concurrently, T1 withdrawing $200 from V1, and T2 withdrawing $200 from V2.  
If the database guaranteed serializable transactions, the simplest way of coding T1 is to deduct $200 from V1, and then verify that V1 + V2 ≥ 0 still holds, aborting if not. T2 similarly deducts $200 from V2 and then verifies V1 + V2 ≥ 0. Since the transactions must serialize, either T1 happens first, leaving V1 = -$100, V2 = $100, and preventing T2 from succeeding (since V1 + (V2 - $200) is now -$200), or T2 happens first and similarly prevents T1 from committing.  
Under snapshot isolation, however, T1 and T2 operate on private snapshots of the database: each deducts $200 from an account, and then verifies that the new total is zero, using the other account value that held when the snapshot was taken. Since neither update conflicts, both commit successfully, leaving V1 = V2 = -$100, and V1 + V2 = -$200.  

##### concurrency control mechanisms

In a database scenario, there are two types of concurrency control mechanisms:  
Optimistic locking is better to use `when the likelihood of a update conflict is low`. This is usually the case when the normal action is adding a record, like in an order entry system. `Pessimistic locking is used when the likelihood of such a conflict is high. `

* Optimistic concurrency control  
Optimistic concurrency control works on the assumption that resource conflicts between multiple users are unlikely, and it permits transactions to execute without locking any resources. The resources are checked only when transactions are trying to change data. This determines whether any conflict has occurred (for example, by checking a version number). If a conflict occurs, the application must read the data and try the change again.   
Optimistic locking allows multiple users to access the same record for edits, counting on minimal conflicts over data. The "locking" happens after the user tries to save changes on top of someone else's changes. The program logic checks to see if the record has been changed since you opened it. If it has, an error is thrown and the update is rolled back. If no changes are detected, the record is saved as planned. 
* Pessimistic concurrency control  
Pessimistic concurrency control locks resources as needed, for the duration of a transaction.   
Pessimistic locking anticipates contention for the same record, preventing users from selecting a record for editing when another user has already done so. This is often done by relying on the database itself. Most relational databases use this method, `only each may use a different standard for the "granularity" considered when making a lock.` As an example, SQL Server 2000 locks single rows, while others may lock the entire page or table containing the record to be changed. A drawback is that this type of locking requires that you remain connected to the database the whole time, which can be a bit much to ask. Also, this type of locking can back up on users waiting to access a given record.

#### Differences between Union and Union All
Union：对两个结果集进行并集操作，不包括重复行，同时进行默认规则的排序；  
Union All：对两个结果集进行并集操作，包括重复行，不进行排序；   
Intersect：对两个结果集进行交集操作，不包括重复行，同时进行默认规则的排序；  
Minus：对两个结果集进行差操作，不包括重复行，同时进行默认规则的排序。 

可以在最后一个结果集中指定Order by子句改变排序方式。 

我们没有必要在每一个select结果集中使用order by子句来进行排序，我们可以在最后使用一条order by来对整个结果进行排序。例如：  
```sql 
select empno,ename from emp 
union 
select deptno,dname from dept 
order by ename;
```

#### In vs Exists vs Not In vs Not Exists
##### In vs Exists
[For more information][general-misc-1]  
__IN__  
* BIG outer query and SMALL inner query = IN
* get the LAST row (all rows) faster then the where exists

__WHERE EXISTS__  
* SMALL outer query and BIG inner query = WHERE EXISTS
* find the first row faster in general than the IN will

I verified it and the "rule of thumb" holds true. `BIG outer query and SMALL inner query = IN.  SMALL outer query and BIG inner query = WHERE EXISTS.`  Remember -- thats is a RULE OF THUMB and rules of thumb always have infinitely many exceptions to the rule.

`If both the subquery and the outer table are huge -- either might work as well as the other -- depends on the indexes and other factors.`

Well, there are infinitely many -- IO can affect the outcome of this.  The goal of the query can effect this (eg: the WHERE EXISTS will find the first row faster in general than the IN will -- the IN will get the LAST row (all rows) faster then the where exists).  If your goal is the FIRST row -- exists might totally blow away IN.  If you are a batch process (and hence getting to the LAST row is vital), use IN.

and so on.  The point is:  be aware of their differences, `try them both when tuning`, understand conceptually what they do and you'll be able to use them to maximum effect.

Well, the two are processed very very differently.  
* for IN  
```sql
Select * from T1 where x in ( select y from T2 );

-- is typically processed as:

select * 
  from t1, ( select distinct y from t2 ) t2
 where t1.x = t2.y;
```

`The subquery is evaluated, distinct'ed, indexed (or hashed or sorted) and then joined to the original table -- typically.`

* WHERE EXISTS  
```sql
select * from t1 where exists ( select null from t2 where y = x )

-- That is processed more like:

for x in ( select * from t1 )       -- 1st query
loop
   if ( exists ( select null from t2 where y = x.x )
   then 
      OUTPUT THE RECORD
   end if
end loop
```
It always results in a full scan of T1 whereas the 1st query can make use of an index on T1(x).

So, when is "where exists" appropriate and inappropriate?  
* Lets say the result of the subquery ( select y from T2 ) is "huge" and takes a long time.  
But the table T1 is relatively small and executing ( select null from t2 where y = x.x ) is very very fast (`nice index on t2(y)`).  Then the exists will be faster as the time to full scan T1 and do the index probe into T2 could be less then the time to simply full scan T2 to build the subquery we need to distinct on.
* Lets say the result of the subquery is small  
then IN is typicaly more appropriate.
* If both the subquery and the outer table are huge  
either might work as well as the other -- depends on the indexes and other factors.

##### Not In vs Not Exits
"Not In" and "Not Exists" are not perfect substitutes.  

"Not In" is different than "Not Exists", `but "Not Exists" and "Not In" are the same when the subquery you use in the "Not In" does not contain NULLS.`

Both of "Not In" and "Not Exists" can be very efficient when there are no nulls (and "Not In" WITH THE CBO is pretty good -- using an "anti join" -- see the design/tuning for performance guide for details on that).  

`With NULLS -- a "Not In" can be very in-efficient and many people substitute a "Not Exists" for it` (not realzing the ANSWER, just changed!!!)


__Another opinion:__  
请注意"Not In"逻辑上不完全等同于"Not Exists"，如果你误用了"Not In"，小心你的程序存在致命的BUG：  
```sql
create table t1 (c1 number,c2 number);
create table t2 (c1 number,c2 number);

insert into t1 values (1,2);
insert into t1 values (1,3);
insert into t2 values (1,2);
insert into t2 values (1,null);

select * from t1 where c2 not in (select c2 from t2);
-- RESULT: no rows found
select * from t1 where not exists (select 1 from t2 where t1.c2=t2.c2);
-- RESULT: (1,3)
```

因此，请尽量不要使用"Not In"，而尽量使用"Not Exists"。如果子查询中返回的任意一条记录含有空值，则查询"Not In"将不返回任何记录，正如上面例子所示。  
除非子查询字段有非空限制，这时可以使用not in.

#### Database Normal Form

PS: 简单的讲, 1NF就是原子属性, 2NF就是限制部分依赖, 3NF是限制传递依赖, BF范式是限制主键及候选键之间的依赖.

* 第一范式（1NF）  
在关系模式R中的每一个具体关系r中，如果每个属性值都是不可再分的最小数据单位，则称R是第一范式的关系。  

* 第二范式（2NF）  
如果关系模式R（U，F）中的所有非主属性都完全依赖于任意一个候选关键字，则称关系R 是属于第二范式的.   
　　例：选课关系 SCI（SNO，CNO，GRADE，CREDIT）其中SNO为学号，CNO为课程号，GRADE为成绩，CREDIT为学分。 由以上条件，关键字为组合关键字(SNO，CNO)  
　　在应用中使用以上关系模式有以下问题：  
　　1. 数据冗余，假设同一门课由40个学生选修，学分就重复40次    
　　2. 更新异常，若调整了某课程的学分，相应的元组CREDIT值都要更新，有可能会出现同一门课学分不同   
　　3. 插入异常，如计划开新课，由于没人选修，没有学号关键字，只能等有人选修才能把课程和学分存入   
　　4. 删除异常，若学生已经结业，从当前数据库删除选修记录。某些门课程新生尚未选修，则此门课程及学分记录无法保存      
　　原因：非关键字属性CREDIT仅函数依赖于CNO，也就是CREDIT部分依赖组合关键字（SNO，CNO）而不是完全依赖。  
　　解决方法：分成两个关系模式SC1（SNO，CNO，GRADE），C2（CNO，CREDIT）。新关系包括两个关系模式，它们之间通过SCN中的外关键字CNO相联系，需要时再进行联接，恢复了原来的关系

* 第三范式（3NF）  
如果关系模式R（U，F）中的所有非主属性对任何候选关键字都不存在传递信赖，则称关系R是属于第三范式的。   
　　例：如S1（SNO，SNAME，DNO，DNAME，LOCATION）各属性分别代表学号，姓名，所在系，系名称，系地址。  
　　关键字SNO决定各个属性。由于是单个关键字，没有部分依赖的问题，肯定是2NF。但这关系肯定有大量的冗余，有关学生所在的几个属性DNO，DNAME，LOCATION将重复存储，插入，删除和修改时也将产生类似以上例的情况。  
　　原因：关系中存在传递依赖造成的。即SNO -> DNO。 而DNO -> SNO却不存在，DNO -> LOCATION, 因此关键字 SNO 对 LOCATION 函数决定是通过传递依赖 SNO -> LOCATION 实现的。也就是说，SNO不直接决定非主属性LOCATION。  
　　解决目地：每个关系模式中不能留有传递依赖。   
　　解决方法：分为两个关系 S（SNO，SNAME，DNO），D（DNO，DNAME，LOCATION）  
　　注意：关系S中不能没有外关键字DNO。否则两个关系之间失去联系。  



---
[general-misc-1]: https://asktom.oracle.com/pls/asktom/f?p=100:11:::::P11_QUESTION_ID:953229842074 "In vs Exists vs Not In vs Not Exists"
[general-partitioning-1]:https://en.wikipedia.org/wiki/Partition_(database) "Partition (database)"
[oracle-optimizer-access-path-1]:http://docs.oracle.com/cd/E11882_01/server.112/e41573/optimops.htm#PFGRF001 "Oracle-The Query Optimizer"
[oracle-misc-high-water-mark-1]:http://www.cnblogs.com/linjiqin/archive/2012/01/15/2323030.html "High water mark"
[oracle-misc-high-water-mark-img-1]:/resources/img/java/database_oracle_hwm_1.png "Figure B-5 High Water Mark"
[oracle-optimizer-types-join-1]:http://docs.oracle.com/cd/E11882_01/server.112/e41573/optimops.htm#PFGRF94636 "The Query Optimizer-Overview of Joins"
[oracle-optimizer-types-join-2]:http://blog.csdn.net/chengweipeng123/article/details/7235387 "表的连接方式"
[oracle-index-1]:https://msdn.microsoft.com/en-us/library/ms190457.aspx "Clustered and Nonclustered Indexes Described"
[oracle-index-2]:http://docs.oracle.com/cd/E11882_01/server.112/e40540/indexiot.htm#CNCPT911 "Indexes and Index-Organized Tables"
[oracle-partitioning-1]:http://www.askmaclean.com/archives/category/oracle/oracle-partitioning "Oracle 数据分区创建和使用的咨询"
[oracle-partitioning-img-1]:/resources/img/java/database_oracle_partitioning_index_1.png "Partitioned Index"
[oracle-cluster-1]:http://docs.oracle.com/cd/E11882_01/server.112/e40540/tablecls.htm#CNCPT608 "Overview of Table Clusters"
[oracle-cluster-img-1]:/resources/img/java/database_oracle_clustered_table_1.png "Clustered Table Data"
