## SQL Snippets
---

* [General](#general)
    - [Tuning](#tuning)
* [Oracle](#oracle)
    - [Tuning](#oracle-tuning)
    - [Examples](#oracle-examples)
    - [Misc](#oracle-misc)
* [Mysql](#mysql)
    - [Examples](#mysql-examples)
    - [Misc](#mysql-misc)
* [Miscellaneous](#miscellaneous)
    - [Examples](#examples)
    - [Uncategorized](#uncategorized)

### General
#### Tuning

##### 批量插入大量数据
1. java code in batch  
```java
for(;;){ 
    final int BATCH_SIZE = 500;
    insert_sql =
    " insert /*+append */ into RPTBOSJTEST (...)" ;
    bost.addBatch(insert_sql);
    num ++ ;
    if(num == BATCH_SIZE){
        bost.executeBatch();
        bost.clearBatch();
        num = 0 ;
    }
}
```

2. 取消日志功能  
采用不写日志及使用Hint提示减少数据操作的时间。  
建议方案是先修改表为不写日志：  
sql> alter table table_name NOLOGGING;  
插入数据：  
INSERT /*+Append*/ INTO tab1  
SELECT * FROM tab2;  
插入完数据后，再修改表写日志：  
sql> alter table table_name LOGGING;  
这里的区别就在于如果插入数据的同时又写日志，尤其是大数据量的insert操作，需要耗费较长的时间。
3. 用事务插入 setAutoCommit(0)
4. 用存储过程
5. 对于某些数据库, 可以关闭Unique索引(MYISAM)或SET UNIQUE_CHECKS=0(INNODB)

##### how to delete mass data efficiently  
1. Bulk Delete/Update
2. Disable logging
3. Disable index and recreate index afterwards
4. Use partition to faciliate it
5. As for deleting majority of data in table  
pick up remaining data into a new table  
drop source table  
rename the new table back to original table  
recreate index
6. delete and commit in batch  
单个事务中删除大量数据有几个缺点：  
    1. DELETE语句被完整的记录到日志，他要求在事务日志中有足够的空间以完成整个事务
    2. 在删除操作期间，从最早打开的事务到当前时间点的所有日志都不会被重写。
    3. 如果该事务因某种原因被中断，这之前的所有操作都将被回滚，这也会花费一些时间。
    4. 当同时删除多行时，SQL Server可能会把被删除行上的单一锁提升为排它表锁，以阻止DELETE完成之前对目标表的读写操作。

所以把`一个大DELETE事务差分成多个小事务来处理`，最好使用一个等待，这样可以日志回收，来释放系统资源。虽然这样可能会比一个delete 语句执行时间要长，但是对整个系统影响较小。

```sql 
BEGIN TRY;
DECLARE @row_count INT,@wait_for_delay CHAR(8)='00:00:10'
WHILE 1 = 1
BEGIN;
    BEGIN TRAN;
    DELETE TOP(5000) FROM tb WHERE create_Date<'2012-01-01'
    SET @row_count=@@ROWCOUNT;
    IF XACT_STATE()= 1 
        COMMIT;
    IF @row_count<5000
    BEGIN;
        BREAK;
    END;
    ELSE
        WAITFOR DELAY @wait_for_delay;
END;
END TRY
BEGIN CATCH
    IF XACT_STATE()= 1
    BEGIN
        ROLLBACK TRAN;
    END;
END CATCH; 
```

### Oracle
#### Oracle Tuning
##### Oracle 插入大量数据
1. 采用高速的存储设备,提高读写能力, 如：EMC 和NetApp
2. 假如tab1表中的没有数据的话  
DROP TABLE TAB1;  
CREATE TABLE TAB1 AS SELECT * FROM TAB2;  
然后在创建索引  
3. 用Hint提示减少操作时间  
INSERT /*+Append*/ INTO tab1  
SELECT * FROM tab2;  
PS: +Append hint是直接在HWM之后的空间插入数据
4. 采用不写日志减少数据操作的时间  
建议方案是先修改表为不写日志：  
sql> alter table table_name NOLOGGING;  
插入数据：  
INSERT /*+Append*/ INTO tab1  
SELECT * FROM tab2;  
插入完数据后，再修改表写日志：  
sql> alter table table_name LOGGING;  
这里的区别就在于如果插入数据的同时又写日志，尤其是大数据量的insert操作，需要耗费较长的时间。  
5. 用EXP/IMP 处理大量数据  
    1. 给当前的两个表分别改名  
    alter table tab1 rename to tab11;  
    alter table tab2 rename to tab1;  
    2. 导出改名前的tab2  
    exp user/pwd@... file=... log=... tables=(tab1)
    3. 把名字改回来  
    alter table tab1 rename to tab2;  
    alter table tab11 rename to tab1;  
    4. 导入数据  
    imp user/pwd@... file=... log=... fromuser=user touser=user tables=(tab1)

#### Oracle Examples
##### Example 1
表TEST  

C1          | C2 
------------|-------
2005-01-01  | 1 
2005-01-01  | 3 
2005-01-02  | 5 

要求的结果数据  
2005-01-01  4   
2005-01-02  5   
合计 9   

试用一个Sql语句完成。 
```sql
select nvl(to_char(C1,'yyyy-mm-dd'),'合计'),sum(C2)from test 
group by rollup(C1)
```



#### Oracle Misc

## Mysql
### Mysql Examples
### Mysql Misc
#### Enable Update multiple raws
```sql
SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;
```



### Miscellaneous
#### Examples
##### Example 1
有员工表 empinfo(  
Fempno varchar2(10) not null pk,   
Fempname varchar2(20) not null,   
Fage number not null,   
Fsalary number not null);   
假如数据量很大约1000万条；写一个你认为最高效的SQL，用一个SQL计算以下四种员工,每种员工的数量:
fsalary>9999 and fage > 35 
fsalary>9999 and fage < 35 
fsalary <9999 and fage > 35 
fsalary <9999 and fage < 35 

```sql
select sum(case when fsalary > 9999 and fage > 35
then 1 else 0 end) as "fsalary>9999_fage>35",
sum(case when fsalary > 9999 and fage < 35
then 1 else 0 end) as "fsalary>9999_fage<35",
sum(case when fsalary < 9999 and fage > 35
then 1 else 0 end) as "fsalary<9999_fage>35",
sum(case when fsalary < 9999 and fage < 35
then 1 else 0 end) as "fsalary<9999_fage<35"
from empinfo;
```

##### Example 2
???
表A字段如下:A(month, person, income)  
要求用一个SQL语句（注意是一个）输出所有人（不区分人员）每个月及上月和下月的总收入   
要求列表输出为   
月份 当月收入 上月收入 下月收入  
```sql
Select (Select Month From A Where Month = To_Char(Sysdate, 'mm')) 月份,
(Select Sum(Income) From A Where Month = To_Char(Sysdate, 'mm')) 当月收入,
(Select Sum(Income) From A Where To_Number(Month) = To_Number(Extract(Month From Sysdate)) - 1) 上月收入,
(Select Sum(Income) From A Where To_Number(Month) = To_Number(Extract(Month From Sysdate)) 1) 下月收入
From Dual;
```

##### Delete/Select all duplicated records based on certain columns
```sql
delete from company t1
where exists (select t2.company_name from company t2
where t2.company_name = t1.company_name
group by t2.company_name
having count(*) > 1);

DELETE FROM table t     -- best performance
WHERE t.rowid > (SELECT MIN(x.rowid)
                            FROM table x
                            WHERE x.column1 = t.column1
                             ....
                             AND      x.columnN = t.columnN );

select * from table_name 
where column in (select column FROM table_name GROUP BY column HAVING COUNT(字段) > 1);
```


#### Uncategorized


---