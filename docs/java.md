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
关联式容器又分为set(集合)和map(映射表)两大类，以及这两大类的衍生体multiset(多键集合)和multimap(多键映射表)，这些容器均以RB-tree完成。此外，还有第3类关联式容器，如hashtable(散列表)，以及以hashtable为底层机制完成的hash_set(散列集合)/hash_map(散列映射表)/hash_multiset(散列多键集合)/hash_multimap(散列多键映射表)。也就是说，__set/map/multiset/multimap都内含一个RB-tree，(PS: is java the same?)__而hash_set/hash_map/hash_multiset/hash_multimap都内含一个hashtable。

![][collections_1]


### Miscellaneous

#### Stream

---
[collections_1]:/resources/img/java/collection_performance_test_1.png "performance test: set vs hash_set vs hash_table"