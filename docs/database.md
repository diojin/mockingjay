## Database
---

* [General](#general)
    - [Optimization](#optimization)
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
* [Miscellaneous](#miscellaneous)
    - [Partitioning](#partitioning)
    - [Concurrency](#concurrency)
        + [Concurrent read/write issues](#concurrent-readwrite-issues)
        + [Isolation Level and lock](#isolation-level-and-lock)

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
    一般来说, 有大量重复值、且经常有范围查询（ > ,< ，> =,< =）和order by、group by发生的列，可考虑建立群集索引 
    5. 定期的重构索引是有必要的  
    ALTER INDEX <INDEXNAME> REBUILD <TABLESPACENAME>

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
1. Local Prefixed Index
2. Local Non-Prefixed Index
3. Global Prefixed Index

Local (Prefixed/Non-Prefixed) Index指的是索引分区内的索引键值指向的记录都对应到基表的一个分区，即`索引分区和基表分区是equipartitioned（分区一一对应）`  

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
* 即使HWM以下有空闲的数据库块，键入在插入数据时使用了append关键字，则在插入时使用HWM以上的数据块，此时HWM会自动增大。

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
##### Isolation Level and lock

Isolation Level\Phenomenons |Dirty Read|Lost Update|Unrepeatable 
Read|Phantom Records
--------------------|-------|-------|-------|------
Read uncommitted    |yes    |yes    |yes    |yes
Read committed      |no     |`yes`  |yes    |yes
Repeatable read     |no     |no     |no     |yes
Snapshot            |no     |no     |no     |no
Serializable        |no     |no     |no     |no


---
[oracle-optimizer-access-path-1]:http://docs.oracle.com/cd/E11882_01/server.112/e41573/optimops.htm#PFGRF001 "Oracle-The Query Optimizer"
[oracle-misc-high-water-mark-1]:http://www.cnblogs.com/linjiqin/archive/2012/01/15/2323030.html "High water mark"
[oracle-misc-high-water-mark-img-1]:/resources/img/java/database_oracle_hwm_1.png "Figure B-5 High Water Mark"
[oracle-optimizer-types-join-1]:http://docs.oracle.com/cd/E11882_01/server.112/e41573/optimops.htm#PFGRF94636 "The Query Optimizer-Overview of Joins"
[oracle-optimizer-types-join-2]:http://blog.csdn.net/chengweipeng123/article/details/7235387 "表的连接方式"
[oracle-index-1]:https://msdn.microsoft.com/en-us/library/ms190457.aspx "Clustered and Nonclustered Indexes Described"
[oracle-index-2]:http://docs.oracle.com/cd/E11882_01/server.112/e40540/indexiot.htm#CNCPT911 "Indexes and Index-Organized Tables"
[oracle-partitioning-1]:http://www.askmaclean.com/archives/category/oracle/oracle-partitioning "Oracle 数据分区创建和使用的咨询"
[general-partitioning-1]:https://en.wikipedia.org/wiki/Partition_(database) "Partition (database)"
[oracle-partitioning-img-1]:/resources/img/java/database_oracle_partitioning_index_1.png "Partitioned Index"
