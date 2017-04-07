## Indexes
---


* [Collections](#collections)
    - [Misc](#collections-misc)
* [Miscellaneous](#miscellaneous)
    - [NIO](#nio)
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

从程序运行结果可以发现，我们自己实现的hash_table（简化版）在插入和查找的效率要远高于set。 

[![collections_1]][collections_2]

[For more information][collections_2]

可以发现在hash_table(简化实现的)中最长的链表也只有5个元素，长度为1和长度为2的链表中的数据占全部数据的89%以上。因此绝大数查询将仅仅访问哈希表1次到2次。这样的查询效率当然会比set（内部使用红黑树——类似于二叉平衡树）高的多。有了这个图示，无疑已经可以证明hash_set会比set快速高效了。

###### RB Tree vs Hashtable on performance

据朋友№邦卡猫№的做的红黑树和hash table的性能测试中发现：`当数据量基本上int型key时，hash table是rbtree的3-4倍，但hash table一般会浪费大概一半内存`。

因为hash table所做的运算就是个%，而rbtree要比较很多，比如rbtree要看value的数据 ，每个节点要多出3个指针（或者偏移量） 如果需要其他功能，比如，统计某个范围内的key的数量，就需要加一个计数成员。
    
且1s rbtree能进行大概50w+次插入，hash table大概是差不多200w次。不过很多的时候，其速度可以忍了，例如倒排索引差不多也是这个速度，而且单线程，且倒排表的拉链长度不会太大。`正因为基于树的实现其实不比hashtable慢到哪里去，所以数据库的索引一般都是用的B/B+树，而且B+树还对磁盘友好(B树能有效降低它的高度，所以减少磁盘交互次数)。比如现在非常流行的NoSQL数据库，像MongoDB也是采用的B树索引。`关于B树系列，请参考本blog内此篇文章：[从B树、B+树、B*树谈到R 树][collections_3]。更多请待后续实验论证。



### Miscellaneous

#### NIO

Java NIO 由以下几个核心部分组成： 

* Channels
- Buffers
* Selectors


#### Stream

---
[collections_1]:/resources/img/java/collection_performance_test_1.png "performance test: set vs hash_set vs hash_table"
[collections_2]:http://blog.csdn.net/morewindows/article/details/7330323 "STL系列之九 探索hash_set"
[collections_3]:http://blog.csdn.net/v_JULY_v/article/details/6530142 "从B 树、B+ 树、B* 树谈到R 树"