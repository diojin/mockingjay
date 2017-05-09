## Algorithm
---


* [Distributed](#distributed)
    - [Consistent hash](#consistent-hash)
    - [MapReduce](#mapreduce)
    - [Exercises & Snippets](distributed-exercises-and-snippets)
* [Exercises & Snippets](exercises-and-snippets)
    - [Misc](exercises-and-snippets-misc)
* [Miscellaneous](#miscellaneous)

### Distributed

#### Consistent hash
__一致性 hash 算法__  

一致性Hash算法本身比较简单，不过可以根据实际情况有很多改进的版本，其目的无非是两点：  
* 节点变动后其他节点受影响尽可能小
* 节点变动后数据重新分配尽可能均衡(虚拟节点的引入)

__Hash算法的衡量指标__  
* 单调性（ Monotonicity ）
>单调性是指如果已经有一些内容通过哈希分派到了相应的缓冲中，又有新的缓冲加入到系统中。哈希的结果应能够保证原有已分配的内容可以被映射到新的缓冲中去，而不会被映射到旧的缓冲集合中的其他缓冲区???!!!

* 平衡性:
平衡性是指哈希的结果能够尽可能分布到所有的缓冲中去，这样可以使得所有的缓冲空间都得到利用。

一致性hash算法是：首先求出服务器（节点）的哈希值，并将其配置到0～2^32-1的圆（continuum）上。然后用同样的方法求出存储数据的key的哈希值，并映射到圆上。然后从数据映射到的位置开始顺时针查找，将数据保存到找到的第一个服务器上。如果超过2^32-1仍然找不到服务器，就会保存到第一台服务器上。
idx=FirstMaxServerIdx(hash(query_key))

__普通Hash算法的问题__  
比如你有 N 个 cache 服务器（后面简称 cache ），那么如何将一个对象 object 映射到 N 个 cache 上呢，你很可能会采用类似下面的通用方法计算 object 的 hash 值，然后均匀的映射到到 N 个 cache ；

hash(object)%N
一切都运行正常，再考虑如下的两种情况；
1. 一个 cache 服务器 m down 掉了（在实际应用中必须要考虑这种情况），这样所有映射到 cache m 的对象都会失效，怎么办，需要把 cache m 从 cache 中移除，这时候 cache 是 N-1 台，映射公式变成了 hash(object)%(N-1) ；
2. 由于访问加重，需要添加 cache ，这时候 cache 是 N+1 台，映射公式变成了 hash(object)%(N+1) ；
1 和 2 意味着什么？这意味着突然之间几乎所有的 cache 都失效了。对于服务器而言，这是一场灾难，洪水般的访问都会直接冲向后台服务器；
再来考虑第三个问题，由于硬件能力越来越强，你可能想让后面添加的节点多做点活，显然普通hash 算法也做不到。

[For more information][distributed_consistent_hash_1]

__Consistent Hash的做法__  
1. 环形hash空间  
考虑通常的 hash 算法都是将 value 映射到一个 32 为的 key 值，也即是 0~2^32-1 次方的数值空间；我们可以将这个空间想象成一个首（ 0 ）尾（ 2^32-1 ）相接的圆环，如下面图 1 所示的那样。
![distributed_consistent_hash_2]

2. 把对象映射到hash 空间  
接下来考虑 4 个对象 object1~object4 ，通过 hash 函数计算出的 hash 值 key 在环上的分布如图 2 所示。
hash(object1) = key1;
…
hash(object4) = key4;

![distributed_consistent_hash_3]

3. 把cache 映射到hash空间  
`Consistent hashing 的基本思想就是将对象和 cache (server) 都映射到同一个hash 数值空间中，并且使用相同的 hash算法`
假设当前有 A,B 和 C 共 3 台 cache (server)，那么其映射结果将如图 3 所示，他们在 hash 空间中，以对应的 hash 值排列。
hash(cache A) = key A;
…
hash(cache C) = key C;
 
![distributed_consistent_hash_4]
 
说到这里，顺便提一下 cache server 的 hash 计算，一般的方法可以使用 cache serve的 IP 地址或者机器名作为 hash输入

4. 把对象映射到cache  
现在 cache server 和对象都已经通过同一个 hash 算法映射到 hash 数值空间中了，接下来要考虑的就是如何将对象映射到 cache 上面了。
在这个环形空间中，如果沿着`顺时针方向`从对象的 key 值出发，直到遇见一个 cache ，那么就将该对象存储在这个 cache 上，因为对象和 cache 的 hash 值是固定的，因此这个 cache 必然是唯一和确定的。
依然继续上面的例子（参见图 3 ），那么根据上面的方法，对象 object1 将被存储到 cache A 上； object2 和object3 对应到 cache C ； object4 对应到 cache B ；

5. 虚拟节点  
考量 Hash 算法的另一个指标是平衡性 (Balance) ，定义如下：
hash 算法并不是保证绝对的平衡，如果 cache server较少的话，对象并不能被均匀的映射到 cache 上，比如在上面的例子中，仅部署 cache A 和 cache C 的情况下，在 4 个对象中， cache A 仅存储了 object1 ，而 cache C 则存储了object2 、 object3 和 object4 ；分布是很不均衡的。
为了解决这种情况， consistent hashing 引入了“虚拟节点”的概念，它可以如下定义：
“虚拟节点”（ virtual node ）是实际节点在 hash 空间的复制品（ replica ），一个实际节点对应了若干个“虚拟节点”，这个对应个数也成为“复制个数”，“虚拟节点”在 hash 空间中以 hash 值排列。
仍以仅部署 cache A 和 cache C 的情况为例，cache 分布并不均匀。现在我们引入虚拟节点，并设置“复制个数”为 2 ，这就意味着一共会存在 4 个“虚拟节点”， cache A1, cache A2 代表了cache A ； cache C1, cache C2 代表了 cache C ；假设一种比较理想的情况，参见图 4 。
 
![distributed_consistent_hash_5]
 
此时，对象到“虚拟节点”的映射关系为：
objec1->cache A2 ； objec2->cache A1 ； objec3->cache C1 ； objec4->cache C2 ；
因此对象 object1 和 object2 都被映射到了 cache A 上，而 object3 和 object4 映射到了 cache C 上；平衡性有了很大提高。
引入“虚拟节点”后，映射关系就从 { 对象 -> 节点 } 转换到了 { 对象 -> 虚拟节点 } 。查询物体所在 cache 时的映射关系如图 5 所示。
 
![distributed_consistent_hash_6]
 
“虚拟节点”的 hash 计算可以采用对应节点的 IP 地址加数字后缀的方式。例如假设 cache A 的 IP 地址为202.168.14.241 。
引入“虚拟节点”前，计算 cache A 的 hash 值：
Hash(“202.168.14.241”);
引入“虚拟节点”后，计算“虚拟节”点 cache A1 和 cache A2 的 hash 值：
Hash(“202.168.14.241#1”);  // cache A1
Hash(“202.168.14.241#2”);  // cache A2

#### Vector Clock
[For more information 1][distributed_vector_clock_2]  
为了提高可用性，Dynamo允许“更新”操作异步的传播到其他副本，当出现多个写事件并发执行时，可能会导致`系统中出现多个版本的对象`。
由于我们`无法保证分布式系统中的多个结点的物理时钟是完美同步的`，所以通过物理时钟来确定事件的时序是不靠谱的，但我们可以通过`基于事件的逻辑时钟`来构建部分有序的事件时序集合
Dynamo通过Vector Clock来构建同一对象多个事件的部分有序的时序集合
需要特别说明的是，`Vector Clock能解决分布式系统多版本合并的问题, 但是对于确实发生冲突的版本，它无法合并，而需要用户自己去做合并`

[For more information 2][distributed_vector_clock_2]  
A vector clock is an algorithm for `generating a partial ordering of events in a distributed system` and `detecting causality violations`. Just as in Lamport timestamps, interprocess messages contain the state of the sending process's logical clock. A vector clock of a system of N processes is anarray/vector of N logical clocks, one clock per process; a local "smallest possible values" copy of the global clock-array is kept in each process, with the following rules for clock updates:
* Initially all clocks are zero.
* Each time a process experiences an internal event, it increments its own logical clock in the vector by one.
* Each time a process prepares to send a message, it sends its entire vector along with the message being sent.
* Each time a process receives a message, it increments its own logical clock in the vector by one and updates each element in its vector by taking the maximum of the value in its own vector clock and the value in the vector in the received message (for every element).

![distributed_vector_clock_3]
Example of a system of vector clocks. Events in the blue region are the causes leading to event B4, whereas those in the red region are the effects of event B4

__How to use the vector?__  
通过比较这些向量的大小，来确定事件发生的顺序。
假如一个向量的所有分享量的count值都小于或等于另一个向量，可以认为后者并前者更"新"
否则，存在冲突

__An example:__  

1. “用户A在N1节点上设置x=100”   ------------  节点N1生成向量<(N1,1)>
2. “用户A在N1节点上设置x=200”   ------------  节点N1生成向量<(N1,2)>
3. “N1将x=200传播到N2” -----------  节点N2生成向量<(N1,2), (N2,1)>
4. “N1将x=200传播到N3” -----------   节点N3生成向量<(N1,2), (N3,1)>
5. “用户A在N2节点上设置x=300”   ------------  节点N2生成向量<(N1,2), (N2,2)>
6. “用户B在N3节点上设置x=400”   -----------  节点N3生成向量<(N1,2), (N3,2)>

As a result,   
N1: <(N1,2), (N2,0), (N3,0)>  
N2: <`(N1,2)`, (N2,2), (N3,0)>  
N3: <`(N1,2)`, (N2,0), (N3,2)>  
客户端其拿到N1,N2,N3上的向量，通过比较可知，N1上的是旧数据，N2/N3版本存在冲突，此时需要用户自己去解决冲突


如果使用Example图示例子中的操作, (PS: which add an additional operation, that is, message sender increases its own logical clock by one when sending a message to other processor) 那么例子变为

1. “用户A在N1节点上设置x=100”   ------------  节点N1生成向量<(N1,1)>
2. “用户A在N1节点上设置x=200”   ------------  节点N1生成向量<(N1,2)>
3. “N1将x=200传播到N2” -----------  节点N2生成向量<(N1,3), (N2,1)>
4. “N1将x=200传播到N3” -----------   节点N3生成向量<(N1,4), (N3,1)>
5. “用户A在N2节点上设置x=300”   ------------  节点N2生成向量<(N1,3), (N2,2)>
6. “用户B在N3节点上设置x=400”   -----------  节点N3生成向量<(N1,4), (N3,2)>

As a result,  
N1: <(N1,2), (N2,0), (N3,0)>  
N2: <`(N1,3)`, (N2,2), (N3,0)>  
N3: <`(N1,4)`, (N2,0), (N3,2)>  

Conclusion is the same as before, however, there are differences on version value of the vector clock, which are highlighted and doesn't affect the result.

#### MapReduce
![mapreduce_1]

##### Snippet 1
>一个很大的2D矩阵，如果某点的值，由它周围某些点的值决定，例如下一时刻(i,j) 的值取当前时刻它的8邻点的平均，那么怎么用MapReduce来实现

用MapReduce来解决上述问题，以下标对作为map的key，遇到（i，j），生成（i-1，j-1），（i-1，j），etc，然后在reduce时merge相同的key，并计算value ???

#### Distributed Exercises and Snippets

### Exercises and Snippets

#### Exercises and Snippets Misc

### Miscellaneous




---
[mapreduce_1]:/resources/img/java/mapreduce_1.png "Map Reduce Flowchart"
[distributed_consistent_hash_1]:http://blog.csdn.net/sparkliang/article/details/5279393 "一致性hash算法 - consistent hashing"
[distributed_consistent_hash_2]:/resources/img/java/algorithm_consistent_hash_1.png "一致性hash算法 - consistent hashing Diagram 1"
[distributed_consistent_hash_2]:/resources/img/java/algorithm_consistent_hash_1.png "一致性hash算法 - 图 1 环形 hash 空间"
[distributed_consistent_hash_3]:/resources/img/java/algorithm_consistent_hash_2.png "一致性hash算法 - 图 2 4 个对象的 key 值分布"
[distributed_consistent_hash_4]:/resources/img/java/algorithm_consistent_hash_3.png "一致性hash算法 - 图 3 cache 和对象的 key 值分布"
[distributed_consistent_hash_5]:/resources/img/java/algorithm_consistent_hash_4.png "一致性hash算法 - 图 4 引入“虚拟节点”后的映射关系"
[distributed_consistent_hash_6]:/resources/img/java/algorithm_consistent_hash_5.png "一致性hash算法 - 图 5 查询对象所在 cache"
[distributed_vector_clock_1]:https://en.wikipedia.org/wiki/Vector_clock "Vector clock"
[distributed_vector_clock_2]:http://blog.csdn.net/yfkiss/article/details/39966087 "Vector Clock理解"
[distributed_vector_clock_3]:/resources/img/java/algorithm_vector_clock_1.png "Example of a system of vector clocks"