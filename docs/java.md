## Indexes
---


* [Collections](#collections)
    - [Misc](#collections-misc)
* [Miscellaneous](#miscellaneous)
    - [Stream](#stream)

### Collections



#### Collections Misc

##### STL collections references

STL容器分两种，
* 序列式容器(vector/list/deque/stack/queue/heap)
* 关联式容器  
关联式容器又分为set(集合)和map(映射表)两大类，以及这两大类的衍生体multiset(多键集合)和multimap(多键映射表)，这些容器均以`RB-tree`完成。此外，还有第3类关联式容器，如hashtable(散列表)，以及以hashtable为底层机制完成的hash_set(散列集合)/hash_map(散列映射表)/hash_multiset(散列多键集合)/hash_multimap(散列多键映射表)。也就是说，`set/map/multiset/multimap都内含一个RB-tree，(PS: is java the same?)`而hash_set/hash_map/hash_multiset/hash_multimap都内含一个hashtable。

`set，同map一样，所有元素都会根据元素的键值自动被排序`，因为set/map两者的所有各种操作，都只是转而调用RB-tree的操作行为，不过，值得注意的是，两者都不允许两个元素有相同的键值。

不同的是：set的元素不像map那样可以同时拥有实值(value)和键值(key)，set元素的键值就是实值，实值就是键值，而map的所有元素都是pair，同时拥有实值(value)和键值(key)，pair的第一个元素被视为键值，第二个元素被视为实值。

至于multiset/multimap，他们的特性及用法和set/map完全相同，唯一的差别就在于它们允许键值重复，即所有的插入操作基于RB-tree的insert_equal()而非insert_unique()。

但由于hash_set/hash_map都是基于hashtable之上，所以不具备自动排序功能。为什么?因为hashtable没有自动排序功能。

至于hash_multiset/hash_multimap的特性与上面的multiset/multimap完全相同，唯一的差别就是它们hash_multiset/hash_multimap的底层实现机制是hashtable（而multiset/multimap，上面说了，底层实现机制是RB-tree），所以它们的元素都不会被自动排序，不过也都允许键值重复。

###### set/map vs hash_set/hash_map on performance

1. 从程序运行结果可以发现，我们自己实现的hash_table（简化版）在插入和查找的效率要远高于set。 

[![collections_1]][collections_2]

[For more information][collections_2]



### Miscellaneous

#### Stream

---
[collections_1]:/resources/img/java/collection_performance_test_1.png "performance test: set vs hash_set vs hash_table"
[collections_2]:http://blog.csdn.net/morewindows/article/details/7330323 "STL系列之九 探索hash_set"