## Algorithm
---

* [Exercises & Snippets](exercises-and-snippets)
* [Miscellaneous](#miscellaneous)

### Exercises and Snippets
#### MapReduce
![mapreduce_1]

##### Snippet 1
>一个很大的2D矩阵，如果某点的值，由它周围某些点的值决定，例如下一时刻(i,j) 的值取当前时刻它的8邻点的平均，那么怎么用MapReduce来实现

用MapReduce来解决上述问题，以下标对作为map的key，遇到（i，j），生成（i-1，j-1），（i-1，j），etc，然后在reduce时merge相同的key，并计算value ???

### Miscellaneous


---
[mapreduce_1]:/resources/img/java/mapreduce_1.png "Map Reduce Flowchart"