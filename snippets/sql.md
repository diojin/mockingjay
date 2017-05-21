## SQL Snippets
---

* [General](#general)
* [Oracle](#oracle)
    - [Examples](#oracle-examples)
    - [Misc](#oracle-misc)
* [Miscellaneous](#miscellaneous)
    - [Examples](#examples)
    - [Uncategorized](#uncategorized)

### General
### Oracle
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

#### Uncategorized


---