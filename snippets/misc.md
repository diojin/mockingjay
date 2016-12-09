##Index
---
* [QueryDSL](#querydsl)
    - [Misc](#querydsl-misc)
        + [QueryDSL Code Examples](#querydsl-code-examples)
* [Groovy](#groovy)
    - [Misc](#groove-misc)
* [Mysql](#mysql)
    - [Misc](#mysql-misc)
        + [Update multiple raws](#update-multiple-raws)


QueryDSL
---
###QueryDSL Misc
####QueryDSL Code Examples
```java
@Modifying 
@Query("delete from ZombieCustomerTrace a where a.processGroup is null ") 
void clearHistory(); 
```


Groovy
---
###Groovy Misc

Mysql
---
###Mysql Misc
####Update multiple raws
```sql
SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;
```