## Database
---

* [General](#general)
    - [Optimization](#optimization)
* [Oracle](#oracle)
* [Miscellaneous](#miscellaneous)

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
        1. SELECT子句中避免使用 '*'  
        ORACLE在解析的过程中, 会将'*' 依次转换成所有的列名, 这个工作是通过查询数据字典完成的, 这意味着将耗费更多的时间
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
        1. 用IN来替代OR
        2. 用UNION替换OR (适用于索引列)  
        通常情况下, 用UNION替换WHERE子句中的OR将会起到较好的效果.   对索引列使用OR将造成全表扫描. 注意, 以上规则只针对多个索引列有效.  如果有column没有被索引, 查询效率可能会因为你没有选择OR而降低.   
        3. 用>=替代>  
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





### Oracle

### Miscellaneous
