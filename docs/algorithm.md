## Algorithm
---

* [Basic](#basic)
    - [Sorting](#sorting)
        + [Array Sorting Algorithms' Complexity Chart](#array-sorting-algorithms-complexity-chart)
        + [Insertion Sort](#insertion-sort)
            * [Shell Sort](#shell-sort) 
            * [Other Variants](#insertion-sort-variants)
        + [Selection Sort](#selection-sort)
        + [HeapSort](#heapsort)
            * [complete binary tree](#complete-binary-tree)
        + [Bubble Sort](#bubble-sort)
        + [QuickSort](#quicksort)
        + [MergeSort](#mergesort)
        + [RadixSort](#radixsort)
        + [BucketSort](#bucketsort)
            * [Value Distribution Sort](#value-distribution-sort)
        + [External Sort](#external-sort)
            * [Huffman Merge Algorithm](#huffman-merge-algorithm)
            * [Balanced Merge Sort](#balanced-merge-sort)
            * [Multiple Channels Merge Sort](#multiple-channels-merge-sort)
            * [Fibonacci Merge Sort](#fibonacci-merge-sort)
* [Data Structure](#data-structure)
    - [Tree](#tree)
      + [Binary Tree](#binary-tree)
      + [Tree & Forest](#tree--forest)
      + [Huffman Tree](#huffman-tree)
    - [Graph](#graph)
      + [Topological Sorting](#topological-sorting)
      + [AOE Critical Path](#aoe-critical-path)
      + [None Weight Shortest Path](#none-weight-shortest-path) 
      + [Positive Weight Shortest Path](#positive-weight-shortest-path)
      + [Negtive Weight Shortest Path](#negtiveeight Shortest Path)  
      + [Shorest Path for all vertexes](#shorest-path-for-all-vertexes)     
      + [Minimum-cost Spanning Tree](#minimum-cost-spanning-tree)
      + [Reachability & Warshall Algorithm](#reachability--warshall-algorithm)
    - [String](#string)
      + [KMP Fast Find](#kmp-fast-find)
* [Distributed](#distributed)
    - [Consistent hash](#consistent-hash)
    - [MapReduce](#mapreduce)
    - [Exercises & Snippets](distributed-exercises-and-snippets)
* [Exercises & Snippets](exercises-and-snippets)
    - [Misc](exercises-and-snippets-misc)
* [Miscellaneous](#miscellaneous)

Basic
---
#### Sorting

##### Array Sorting Algorithms' Complexity Chart

PS: If sorting algorithm swap adjacent elements, it should be stable, otherwise, it is unstable. (Seems Mergesort is an exception, it is a stable sort)

**Time Complexity(TC)**  
**Space Complexity(SC)**  

Algorithm       |TC Best        |TC Average     |TC Worst       |SC Worst   |Stable(Y/N)
:---------------|---------------|---------------|---------------|-----------|--
Quicksort       |O(n log(n))    |O(n log(n))    |O(n^2)         |O(log(n))  |N
Mergesort       |O(n log(n))    |O(n log(n))    |O(n log(n))    |O(n)       |Y
Timsort         |O(n)           |O(n log(n))    |O(n log(n))    |O(n)       |N
Heapsort        |O(n log(n))    |O(n log(n))    |O(n log(n))    |O(1)       |N
Bubble Sort     |O(n)           |O(n^2)         |O(n^2)         |O(1)       |Y
Insertion Sort  |O(n)           |O(n^2)         |O(n^2)         |O(1)       |Y
Selection Sort  |O(n^2)         |O(n^2)         |O(n^2)         |O(1)       |N
Shell Sort      |O(n)           |O((nlog(n))^2) |O((nlog(n))^2) |O(1)       |N
Bucket Sort     |O(n+k)         |O(n+k)         |O(n^2)         |O(n)       |Y
Radix Sort      |O(nk)          |O(nk)          |O(nk)          |O(n+k)     |Y

![algorithm_sorting_1]  
![algorithm_sorting_2]  

快速排序比大部分排序算法都要快。尽管我们可以在某些特殊的情况下写出比快速排序快的算法，但是就通常情况而言，没有比它更快的了。快速排序是递归的，对于内存非常有限的机器来说，它不是一个好的选择。

堆排序适合于数据量非常大的场合（百万数据）。  
堆排序不需要大量的递归或者多维的暂存数组。这对于数据量非常巨大的序列是合适的。比如超过数百万条记录，因为快速排序，归并排序都使用递归来设计算法，在数据量非常大的时候，可能会发生堆栈溢出错误。



##### Insertion Sort
```scala
  def insertionSort[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {
    var i = 1
    var j = 0
    while ( i < source.length ){
      j = i
      var tmp = source(j)
      while ( j > 0 && source(j-1) > tmp) {
        source(j) = source(j - 1)
        j -= 1
      }
      source(j) = tmp      
      i += 1
    }
  } 
```

* Complex:  O(n*n)

###### Shell Sort
1. Define a interval sequence, such as (..., 8, 4, 2, 1), or 2^p * 3^q (2^p * 3^q < n) (the last element of the sequence is 1 so that at last, the entire input data is sorted)
2. for each interval in the sequence, group input data by the interval
    1. use insertion sort against each group 

* Complex:    
    O(n * log2(n) * log2(n)) for interval sequence 2^p * 3^q (2^p * 3^q < n)  
    O((nlog(n))^2)  

* hard to find out an efficient interval sequence

###### Insertion Sort Other Variants
1. use binary search instead of sequencial search in each step to find out insert location

##### Selection Sort
```scala
  def sort[T](source: Array[T])(implicit ev: T <:< Ordered[T]){ 
    for ( i <- source.length -1 to (1, -1) ){
      var max = 0
      for ( j <- 1 to i ){
        if ( source(j) >= source(max) ){        // use >= instead of > to improve stability
           max = j
        }
      }
      var tmp = source(i)
      source(i) = source(max)
      source(max) = tmp
    }
  }
```

For all situations, it needs 1/2 * n * (n-1) times of keyword comparations and n-1 times of record exchange

##### HeapSort
It is indeed a kind of selection sort.

The heapsort algorithm can be divided into two parts.  
1. a heap is built out of the data, K0, K1,..., Kn-1
2. swap and restore heap from the remainings  
```scala
for ( i = n-1 to 1 ) {
    swap K0 with Ki
    restore heap from the remaings, that is, K0, K1, ..., K(i-1)
} 
```

**Restore(K, start, end)**
Assumption: both left and right subtree of K(start) are heap already
Compare K(start) with the larger one (say K(larger)) of its left child( K(2*start + 1) ) and right child( K(2*start + 2) ),  if K(start) > K(larger), then it is already a heap, process ends, otherwise, swap K(start) with K(larger), and call R(K, larger, end)

**HeapSort(K, n)**
Assumption: n is the length of K
1. initiating the heap  
```scala
for ( i <- floor((n-1)/2) to 0 ){
    Restore(K, i, n-1)
}
```
2. sort  
```scala
for ( i <- n-1 to 1 ){
    swap K0 with Ki
    Restore(K, 0, i-1)
}
```

**Code examples**:  
```scala
  def restore[T](source: Array[T], start : Int, end: Int)(implicit ev: T <:< Ordered[T]){
    var i = start
    while( i <= (math.floor((end - 1)/2)).toInt ){
      var largerChild = 2 * i + 1
      if ( 2 * i + 2 <= end && source(2*i+2) > source(largerChild) ){
        largerChild = 2*i + 2
      }
      if (source(i) > source(largerChild) ){
        i = end  // create the effect of leaving loop
      }else{
        var tmp = source(i)
        source(i) = source(largerChild)
        source(largerChild) = tmp
        i = largerChild
      }
    }
  }
  
  def sort[T](source: Array[T])(implicit ev: T <:< Ordered[T]){
    // initiating the heap
    for ( i <- (math.floor((source.length -1)/2).toInt) to (0, -1) ){
      restore(source, i, source.length -1)
    }
    
    // sort
    for ( i<- source.length -1 to (1, -1) ){
      var tmp = source(i)
      source(i) = source(0)
      source(0) = tmp
      restore(source, 0, i-1)
    }
  }

```

###### complete binary tree
完全二叉树  
The heap is often placed in an array with the layout of a complete binary tree. The complete binary tree maps the binary tree structure into the array indices; each array index represents a node; the index of the node's parent, left child branch, or right child branch are simple expressions. For a zero-based array, the root node is stored at index 0; if i is the index of the current node, then  
iParent(i)     = floor((i-1) / 2) where floor functions map a real number to the smallest leading integer.  
iLeftChild(i)  = 2*i + 1  
iRightChild(i) = 2*i + 2  

##### Bubble Sort

Too many element swap and comparation, not often used

```scala
  def sort[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {
    for ( i <- source.length -1 to (1, -1) ){
      for ( j <- 0 to i - 1 ){
        if ( source(j) > source(j+1) ){
          var tmp = source(j)
          source(j) = source(j+1)
          source(j+1) = tmp
        }
      }
    }
  }
```

**Improvements**:  
1. for certain round, if there is no more swap after certain index k, which indicates data between k and the end of this round is already sorted, hence in next round, the range of sort should be from 0 to k-1
```scala
  def improvedSort1[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {
    var bound = source.length -1
    while (bound > 1){
      var upper = bound - 1
      bound = 0
      for ( i <- 0 to upper ){
        if ( source(i) > source(i+1) ){
          var tmp = source(i)
          source(i)=source(i+1)
          source(i+1) = tmp
          bound=i
        }
      }
    }
  }
```


2. moreover, take turns to use bubble up and bubble down, further improve the speed
```scala
  def improvedSort2[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {
    var left = 0
    var right = source.length -1
    while ( left < right ){
      // at fisrt, bubble up
      var marker = 0
      for ( i <- left to right - 1 ){
        if ( source(i) > source(i+1) ){
          var tmp = source(i)
          source(i) = source(i+1)
          source(i+1) = tmp
          marker = i
        }
      }
      right = marker
      // then, bubble down
      for ( i <- right to (left + 1, -1) ){
        if ( source(i) < source(i-1) ){
          var tmp = source(i)
          source(i) = source(i-1)
          source(i-1) = tmp
          marker = i          
        }
      }
      left = marker
    }
  }
```

##### QuickSort

```scala
  def sort[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {
    quickSort(source, 0, source.length-1)
  }
  
  def quickSort[T](source: Array[T], start: Int, end: Int)(implicit ev: T <:< Ordered[T]) {
    if ( start < end ){
      var target = start
      var left = start
      var right = end + 1
      while( left < right ){
        left += 1
        while( source(left) < source(target) ){      // if use <= instead of <, index "left" may be outbound
          left += 1
        }
        right -= 1
        while( source(right) > source(target) ){    // if use >= instead of >, index "right" may be outbound   
          right -= 1
        }
        if ( left < right ){
          var tmp = source(left)
          source(left) = source(right)
          source(right) = tmp
        }
      }
      var tmp = source(target)
      source(target) = source(right)
      source(right) = tmp
      quickSort(source, start, right-1)
      quickSort(source, right+1, end)
    }
  }
```

The worst case for quick sort is When the input is already sorted, in that case, the complexity is O(n^2)

Some improvements target to introduce some random cases so that the input could not be a totally sorted array

**Improvement**  
1. swap K(start) with K(random(start, end)) at the beginning of each recursion
2. use swap to make sure K(start) is the medium value of K(start), K((start+end)/2), K(end) at the beginning of each recursion


##### MergeSort

at first, define a merge function
```scala
  def merge[T](from: Array[T], to: Array[T], start: Int, mid: Int, end: Int)(implicit ev: T <:< Ordered[T]){
    var i = start
    var j = mid
    var k = start
    while ( i < mid || j <= end ) {
      if ( i < mid && ( j > end || from(i) <= from(j) ) ){
        to(k) = from(i)
        i += 1
      }else{
        to(k) = from(j)
        j += 1
      }
      k +=1
    }   
  }
```

there are 2 ways  
1. top down merge sort
```scala
  def topDownMergeSort[T](source: Array[T])(implicit ev: T <:< Ordered[T]){
    // this copying source to buffer operation is necessary
    val buffer = source.clone()
    topDownSplitMerge(buffer, source, 0, source.length - 1)
  }

  /**
   * the order of the parameters are a little tricky
   */
  def topDownSplitMerge[T](from: Array[T], to: Array[T], start: Int, end: Int)(implicit ev: T <:< Ordered[T]) {  
    if ( end > start ){
      val mid = math.floor((start+end)/2).toInt
      topDownSplitMerge(to, from, start, mid)
      topDownSplitMerge(to, from, mid+1, end)
      merge(from, to, start, mid+1, end)           
    }
  }
```
or simpler one, but too much space waste
```scala
  def topDownMergeSort[T](source: Array[T])(implicit ev: T <:< Ordered[T]){
    topDownSplitMergeSimple(source, 0, source.length - 1)
  }
  /**
   * logic is simpler but too much space waste
   */
  def topDownSplitMergeSimple[T](source: Array[T], start: Int, end: Int)(implicit ev: T <:< Ordered[T]) { 
    if ( end > start ){
      val buffer = source.clone()
      val mid = math.floor((start+end)/2).toInt
      topDownSplitMerge(source, buffer, start, mid)
      topDownSplitMerge(source, buffer, mid+1, end)
      merge(buffer, source, start, mid+1, end)           
    }
  }
```

2. bottom up merge sort
```scala
  def sort[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {  
    buttomUpMergeSort(source)
  }
  
  def buttomUpMergeSort[T](source: Array[T])(implicit ev: T <:< Ordered[T]) {  
    var length = 1
    var buffer = source.clone()
    while ( length < source.length - 1 ){
      buttomUpOnePass(source, buffer, length)
      length *= 2
      buttomUpOnePass(buffer, source, length)
    }
  }
  
  def buttomUpOnePass[T](from: Array[T], to: Array[T], length: Int)(implicit ev: T <:< Ordered[T]){
    var i = 0
    while ( i + 2*length <= from.length ){
      merge(from, to, i, i + length, i + 2*length -1 )
      i += 2 * length
    }
    if ( i + length < from.length ){
      merge(from, to, i, i+length, from.length -1 )
    }else{
      for ( j <- i to from.length -1 ){
        to(j) = from(j)
      }
    }
  }
```

##### RadixSort
Not by keyword comparasion, but by dictionary comparasion.  
Basicly, the input data is sorted for several rounds, same to the amount of digits, from last digit to first dight ( in dictionary comparasion, first digit are more desicive ), in each round, sort the data by certain digit

**RadixSort(Q, n, p, r)**  
Q: input data in a queue  
n: size of input data  
p: amount of digits of each element, should be same for each element
r: Radix for each digit, for a decimal number, it is 2

1. simply put input data in queue Q, create queues Q0, Q1, ..., Q(r-1) for each value for radix 
2. For j = 0 to p-1 Do  
    1. clear Q0, Q1, ..., Q(r-1)
    2. While Q Not Empty Do
            X <= Q
            Get jth digit of X as D(j),  
            Put X to Q(D(j))
    3. Merge Q0, Q1,..., Q(r-1) intoto Q    

```scala
  def radixSort(source: Array[String], radix: Int) {
    val allData = new Queue[String]
    source.foreach { allData += _}
    
    val radixQueues = new Array[Queue[String]](radix)
    for ( i <- 0 to radixQueues.length - 1 ){
      radixQueues(i) = new Queue[String]
    }
    
    val length = source(0).length()
    var curElement: String = null
    for ( i <- length -1 to (0, -1)  ){
      radixQueues.foreach { _.clear() }
      while ( ! allData.isEmpty ){
        curElement = allData.dequeue()
        radixQueues(curElement(i).toString().toInt) += curElement
      }
      radixQueues.foreach { allData ++= _ }
    }   
    for ( i <- 0 to source.length - 1 ){
      source(i) = allData.dequeue()
    }
  }
```


##### BucketSort
Bucket sort works as follows:  
1. Set up an array of initially empty "buckets".
2. Scatter: Go over the original array, putting each object in its bucket.
3. Sort each non-empty bucket.
4. Gather: Visit the buckets in order and put all elements back into the original array.  

**Pseudo Code**  
```scala
function bucketSort(array, n) is
  buckets ← new array of n empty lists
  for i = 0 to (length(array)-1) do
    insert array[i] into buckets[msbits(array[i], k)]
  for i = 0 to n - 1 do
    nextSort(buckets[i]);
  return the concatenation of buckets[0], ...., buckets[n-1]
```

Here array is the array to be sorted and n is the number of buckets to use. The function msbits(x,k) returns the k most significant bits of x (floor(x/2^(size(x)-k))); different functions can be used to translate the range of elements in array to n buckets, such as translating the letters A–Z to 0–25 or returning the first character (0–255) for sorting strings. The function nextSort is a sorting function; using bucketSort itself as nextSort produces a relative of radix sort; in particular, the case n = 2 corresponds to quicksort (although potentially with poor pivot choices).  
Note that for bucket sort to be O(n) on average, the number of buckets n must be equal to the length of the array being sorted, and the input array must be uniformly distributed across the range of possible bucket values. If these requirements are not met, the performance of bucket sort will be dominated by the running time of nextSort, which is typically O(n^2) insertion sort, making bucket sort less optimal than O(n\log(n)) comparison sort algorithms like Quicksort.

A common optimization is to put the unsorted elements of the buckets back in the original array first, then run insertion sort over the complete array; because insertion sort's runtime is based on how far each element is from its final position, the number of comparisons remains relatively small, and the memory hierarchy is better exploited by storing the list contiguously in memory.

###### Value Distribution Sort
Suppose value range of input dataset K is from u to v, [u, v]

**Distribute(K, n, u, v, S)**  
S: output  

1. create array COUNT[v+1]  
   For i = u to v DO  
    COUNT[i] = 0  
2. For j = 0 to n-1 DO  
    COUNT[Kj] += 1
3. compute Count[i], which is the last index of elements whose value equal to i  
    For i = u+1 to v Do  
        COUNT[i] = COUNT[i] + Count[i-1]
4. output to S  
    For j = n-1 to 0 DO  {
        i <- COUNT[Kj]
        Si = Kj
        COUNT[Kj] <- i-1
    }
    
##### External Sort
PS: Initial sorted segment(ISS): a data segment which can be loaded into memory and is sorted there by internal sort algorithm, size of ISS should be less than memory size.

Tape sort algorithm:  
* Balanced Merge Sort
* Multiple Channels Merge Sort
* Fibonacci Merge Sort

All tape sort algorithms are applied to disk sort, since tape can do only sequential scan, while disk can do both sequential and random scan

As for disk sort, at first ignore seek time and delay time, following conclusions are got:  
合并模式的树表示:  对应每个初始有序段ISS都有一个外节点(也称为树叶), 树的每个内节点也都表示一个有序段, 该有序段是经过合并而生成的  

用合并树来表示合并模式时, 排序算法所处理的有序段的总数等于该模式树的外通路长度

如果所有的初始有序段都具有同样的长度, 则完全p叉树具有最小的外通路长度  

如果初始有序段的长度不同, 排序时间就由加权外通路长度确定, Huffman树具有最小的加权外通路长度  

###### Huffman Merge Algorithm  
首先添加(S-1) mod (p-1) 个长度为零的虚拟有序段, 然后重复合并当前最短的p个有序段直到只剩下一个有序段为止.  


###### Balanced Merge Sort
T (T >= 2) channels in all, separated in 2 groups, group A and group B, group A has P(P < T) channels, group B has (T-P) channels    
1. Place all ISS in turn (interleavingly) to P channels in group A
2. Merge ISS in group A to group B  
    every P ISS are merged to 1 larger ISS ( create several virtual ISS whose length is 0 so that total number of ISS is a multiple of P), and places newly merged ISS in turn (interleavingly) to (T-P) channels in group B   
3. Merge ISS in group B to group A by the same way as in step 2
4. Change the role of group A and B alternatively to do the merge, until there is only 1 ISS left, which is the final result

Take an example that T=6, P=3, 5000 ISS, it takes 3 rounds to finish  
1. Round 1  
Channel 1: R1 ~ R1000       :   R3001 ~ R4000  
Channel 2: R1001 ~ R2000    :   R4001 ~ R5000  
Channel 3: R2001 ~ R3000    :  
Channel 4: EMPTY  
Channel 5: EMPTY  
Channel 6: EMPTY  
2. Round 2   
Channel 1: EMPTY  
Channel 2: EMPTY  
Channel 3: EMPTY  
Channel 4: R1 ~ R3000    
Channel 5: R3001 ~ R5000    
Channel 6: EMPTY  
3. Round 3   
Channel 1: R1 ~ R5000  
Channel 2: EMPTY  
Channel 3: EMPTY  
Channel 4: EMPTY    
Channel 5: EMPTY    
Channel 6: EMPTY  

###### Multiple Channels Merge Sort
T (T >= 2) channels in all, separated in 2 groups, group A and group B, group A has P(P = T-1) channels, group B has 1 channels    
1. Place all ISS in turn (interleavingly) to P channels in group A
2. Merge ISS in group A to group B  
    every P ISS are merged to 1 larger ISS ( create several virtual ISS whose length is 0 so that total number of ISS is a multiple of P), and places newly merged ISS to the only channel in group B   
3. Algorithm ends if there is only 1 ISS left in group B, otherwise, copy in turn (interleavingly) all ISS in the only channel in group B back to P channels in group A, repeat step 2 and 3

Take an example that T=4, P=3, 5000 ISS(S=5000), it takes 3 rounds to finish  
1. Operation 1  
Channel 1: R1 ~ R1000       :   R3001 ~ R4000  
Channel 2: R1001 ~ R2000    :   R4001 ~ R5000  
Channel 3: R2001 ~ R3000    :  
Channel 4: EMPTY  
2. Operation 2   
Channel 1: EMPTY  
Channel 2: EMPTY  
Channel 3: EMPTY  
Channel 4: R1 ~ R3000       :   R3001 ~ R500    
3. Operation 3   
Channel 1: R1 ~ R3000    
Channel 2: R3000 ~ R5000    
Channel 3: EMPTY  
Channel 4: EMPTY    
3. Operation 4   
Channel 1: EMPTY    
Channel 2: EMPTY    
Channel 3: EMPTY  
Channel 4: R1 ~ R5000    

Because the the copy step, it needs double times of scan, 2 * ceil(logP(S))

###### Fibonacci Merge Sort
Multiple channels merge sort is not so efficent because they needs more scan times, Fibonacci merge sort can avoid copy step, reduce scan times

Take 3 Tapes 2 channels merge sort for example,   
ISS(n) means ISS whose length is n  
ISS(n) * m means amount m of ISS whose length is n 
Rank 2 Fibonacci sequence: 0, 1, 1, 2, 3, 5, 8, 13, 21, ....  

Round|  Tape 1      |     Tape 2        | Tape 3
:---:|--------------|-------------------|---------------------
1    | ISS(1) * 13  | ISS(1) * 8        | ---
2    | ISS(1) * 5   | ---               | ISS(2) * 8
3    | ---          | ISS(3) * 5        | ISS(2) * 3
4    | ISS(5) * 3   | ISS(3) * 2        | ---
5    | ISS(5) * 1   | ---               | ISS(8) * 2
6    | ---          | ISS(13) * 1       | ISS(8) * 1
7    | ISS(21) * 1  | ---               | ---

Rank P Fibonacci sequence are defined as:  
F(n) = F(n-1) + F(n-2) + ... + F(n-P)
F(m) = 0 ( 0 <= m <= P-2)
F(P-1) = 1 

### Data Structure
#### Tree
层数: 从根节点到某个结点的路径长度叫做结点的层数, 根节点的层数为0  
树的高度: 树中的节点的最大层数

##### Binary Tree
* 二叉树中层数为n的结点至多有2^n个
* 高度为k的二叉树中至多有2^(k+1)-1 个结点
* 结点的子节点个数为该节点的次数
* 结点的个数 = 边数 + 1
* 对于n结点的二叉树,  叶子结点的个数为n(0),  次数为1, 2的结点个数分别为n(1), n(2)  
    n(0) = n(2) + 1
* 满二叉树: 高度为k的满二叉树, 是有 2^(k+1) - 1 个结点的高度为k的二叉树
* 完全二叉树(complete binary tree), 一颗具有n个结点, 高度为k的二叉树, 并且树中所有的结点连续对应于高度为k的满二叉树中编号为由0至n的那些结点(n <= 2^(k+1) - 1) 
* n个结点的完全二叉树的高度是floor(log2(n))
* 线索二叉树: 比二叉树增加两个指针域, 分别指向当前节点的中根前驱结点和中根后继结点
* 只知道二叉树的先根/中根/后根次序, 无法唯一确定一颗二叉树
* 如果已知二叉树的先根次序和各结点的次数, 可以唯一确定一棵二叉树
* 对于树和森林的顺序存储, 还可以采用后根次序和层次次序来进行存储

**Binary Tree Definition**  
```scala
trait Node extends Ordered[Node]{
  def data: Int
  def compare(that: Node) = {
    data - that.data
  }
}

class BinaryTreeNode(var data: Int = -1, var left: BinaryTreeNode = null, var right: BinaryTreeNode = null) extends Node{}

class BinaryTree {
  var root: BinaryTreeNode = null
  var current: BinaryTreeNode = null
}
```

**Preorder traversal**  
```scala
  def preorder( begin: BinaryTreeNode ) {
    if ( null != begin ){
      println(begin.data)
      preorder(begin.left)      
      preorder(begin.right)
    }
  }
```

**Inorder traversal**  
```scala
  def inorder( begin: BinaryTreeNode ) {
    if ( null != begin ){
      inorder(begin.left)
      println(begin.data)
      inorder(begin.right)
    }
  }
```

**Postorder traversal**  
```scala
  def postorder( begin: BinaryTreeNode ) {
    if ( null != begin ){      
      postorder(begin.left)      
      postorder(begin.right)
      println(begin.data)
    }
  }
```

**copy tree**  
```scala
  override def clone() = {
    BinaryTree(copySubTree(root))
  }
  
  private def copySubTree( cur: BinaryTreeNode ): BinaryTreeNode = {
    if ( null == cur ){
      null
    }else{
      BinaryTreeNode(cur.data, 
          copySubTree(cur.left),
          copySubTree(cur.right))
    }
  }
```

##### Tree & Forest
By using 2 pointer fiels to express a forest, that is, firstChild and nextBrother,  a forest can be converted to a binary tree, vice verse, the cardinal of the relationship is 1:1

**Tree & Forest Definition**  
```scala
trait Node extends Ordered[Node]{
  def data: Int
  def compare(that: Node) = {
    data - that.data
  }
}

class TreeNode(var data: Int = -1, var firstChild: TreeNode = null, var nextBrother: TreeNode = null) extends Node{}

class Tree {
  var root: TreeNode = null
  var current: TreeNode = null
}

class Forest(myroot: TreeNode ) extends Tree(myroot) {}
```

**Preorder traversal**  
* recursive implementation  
```scala
  // tree traverse
  def preorder(begin: TreeNode){
    if ( null != begin ){
      println(begin)
      var k = begin.firstChild
      while ( k != null ){
        preorder(k)
        k = k.nextBrother      
      }
    }
  }

  // forest implementation
  override def preorder(begin: TreeNode){
    var k = begin
    while ( null != k ){
      preorderInternal(k)
      k = k.nextBrother
    }
  }
  
  def preorderInternal(begin: TreeNode){
    if ( null != begin ){
      println(begin)
      var k = begin.firstChild
      while ( k != null ){
        preorderInternal(k)
        k = k.nextBrother      
      }
    }
  }
```
* stack implementation  
```scala
  // tree implementation
  def preorderStack(begin: TreeNode) {
    val stack = new Stack[TreeNode]
    var k = begin
    do {
      while (null != k) {
        println(k)
        stack.push(k)
        k = k.firstChild
      }
      if (stack.nonEmpty) {
        k = stack.pop()
      }
      if (k != null) {
        k = k.nextBrother
      }
    } while (stack.nonEmpty)
  }

  // forest implementation
  override def preorderStack(begin: TreeNode) {
    val stack = new Stack[TreeNode]
    var k = begin
    do {
      while (null != k) {
        println(k)
        stack.push(k)
        k = k.firstChild
      }
      if (stack.nonEmpty) {
        k = stack.pop()
      }
      if (k != null) {
        k = k.nextBrother
      }
    } while (stack.nonEmpty || k != null)
  } 

```

**level order traversal**  

```scala
  def levelOrder(begin: TreeNode){
    val queue = new Queue[TreeNode]
    var k = begin
    while ( k != null ){
      queue.enqueue(k)
      k = k.nextBrother
    }
    
    while ( queue.nonEmpty ){
      k = queue.dequeue()
      println(k)
      if ( k != null ){
        k = k.firstChild
        while( k != null ){
          queue.enqueue(k)
          k = k.nextBrother
        }
      }
    }
  }
```


##### Huffman Tree
* Huffman Tree, also call 最优二叉树
* 如果字符集包含C个字符, 在标准的等长编码中, 每个字符由ceil(log2(C))位的二进制串表示
* 文件压缩的通常策略是, 采用不等长的二进制码, 令文件中出现频率高的字符编码尽可能短
* 前缀码:  为了避免多义性, 必须要求字符集中任何字符的编码都不是其他字符的编码的前缀, 满足这个条件的编码即是前缀码
* 树的路径长度: 从根节点到树中每个叶子节点的路径长度之和
* 结点的权: 将树中结点附上一个有某种意义的数, 成为该结点的权. 
* 结点的带权路径长度: 该结点到根结点的路径长度与结点上的权的乘积
* 树的带权路径长度(WPL: Weighted Path Length of Tree): 树中所有叶子结点的带权路径长度之和
* 扩充二叉树: 设一个权值集合为{w0, w1, ...,w(n-1)}, 若T是一棵有n个叶子节点的二叉树, 且n个叶结点的权值分别是w0, w1, ...,w(n-1),  则称T是权值为w0, w1, ...,w(n-1)的扩充二叉树
* 增长二叉树: 为了简化, 可以让二叉树形增长, 则每当原二叉树中的结点没有左子树或右子树形时, 就增加特殊的结点(成为外结点, 树中原来的结点成为内结点), 由此生成的二叉树成为增长的二叉树, 简称增长树
* 完全平衡二叉树: 一颗增长树, 如果存在k, 使所有的外结点堵在k层上或者都在k层和k+1层上
* Huffman Tree是带权路径长度WPL最小的二叉树, 又称作最优二叉树

Huffman Algorithm  
1. Consider each weighted node as the root of a separate tree, thus all initial nodes become a forest
2. While count of trees in forest > 0  
    combine 2 trees with smallest 2 weighted values  
        A new tree is generated, count of trees in forest decrease by 1  
        previous 2 trees become respectively left and right subtree of the new tree  
        weighted value of new tree is the sum of previous two tree's weighted values  
3. Grant value for each path, path to left subtree is granted to 0, while path to right subtree is granted to 1, thus, combine path values from root to leaf, and it is the binary expression of the leaf node character

#### Graph
* Graph 由顶点集V(G) 和边集E(G) 组成 G=(V, E). 有向边`<vi, vj>`, 无向边`(vi, vj)`
* 设G, H是图, 如果V(G) <= V(H), 并且E(G) <= E(H), 则称G是H的子图, H是G的母图. 
* 支撑子图:  如果G是H的子图, 并且V(G)=V(H), 则称G是H的支撑子图
* 设G是无向图, E(G)中以v为顶点的边的个数成为v的度(degree). 若G是有向图, v的出度(out-degree)是以v为始点的边的个数, v的入度(in-degree)是以v为终点的边的个数
* 若G为有向图, 对于任意两个不同的顶点vi和vj, 都同时有vi与vj可及, vj与vi可以, 则称G为强连通图
* 设G=(V, E)是非(强)连通图, 若G的子图Gk是一个(强)连通图, 则称Gk为G的连通分量.

**Data structure**  
1. Adjacent matrix(邻接矩阵)  
    1. Stores vertexes in an array;   
    2. Stores edges in a n * n matrix   
    n * n matrix A, n is the count of vertexes  
    Aii = 0  
    Aij = 1 if there is `<vi, vj>` or `(vi, vj)`   
    Aij = 0 otherwise   
```scala
/**
 * edges:  n * n matrix of edges
 * vertexList: a array contains all vertex values
 */
class AdjacentMatrixGraph(val edges: Array[Array[Int]], val vertexList: Array[Int] = null) {  
}
```

2. Adjacent array(邻接表)  
    1. All vertexes(Vi), which are directly adjacent to V, are stored in a linked list in certain order, data structure of which is EdgeNode{ verAdj, weight, next }, where verAdj is the index of vertex Vi(other than V), weight is the weight of edge (V, Vi), and next is pointer to next adjacent vertex defined as a EdgeNode
    2. An array of vertexes in graph, whose data structure is VertexNode{verName, next}, where verName is the value of the vertex, and next is the pointer to the head of its adjacent vertex list, which is defined as a linked list of EdgeNode  
```scala
class AdjacentArrayGraph( val vertexes : ArrayBuffer[VertexNode] = null) {
}

class EdgeNode(var verAdj: Int, var weight: Int = -1, var next: EdgeNode = null) {}
  
class VertexNode(var verName: Int = -1, var next: EdgeNode = null) {}

```

**Depth First Search**  
Depth first search of graph is almost same to preorder traversal of binary tree.  
```scala
  def depthFirstSearch {
    val visited = new Array[Int](vertexes.size)
    for (i <- 0 to visited.length -1 ){
      visited(i) = 0
    }
    depthFirstSearchInner(0, visited)
  }
  def depthFirstSearchInner( index: Int, visited: Array[Int] ){
    if ( visited(index) == 0 ){
      println(vertexes(index))
      visited(index) = 1
      var adjVer = vertexes(index).next
      while( null != adjVer ){
        if ( visited(adjVer.verAdj) == 0 ){
          depthFirstSearchInner(adjVer.verAdj, visited)
        }        
        adjVer = adjVer.next
      }
    }
  }
```

stack implementation 1
```scala
  /**
   * a variant of preorder traversal algorithm of binary tree by stack 
   */
  def depthFirstSearchStack() {
    val visited = new Array[Int](vertexes.size)
    for (i <- 0 to visited.length -1 ){
      visited(i) = 0
    }
    val stack = Stack[Int]()
    var cur = 0
    var nextNotVisited:AdjacentArrayGraph.EdgeNode = null
    do{
      while ( cur >= 0 && cur < vertexes.size && visited(cur) == 0){
        println(vertexes(cur))
        visited(cur) = 1
        stack.push(cur)
        if (vertexes(cur).next == null){
          cur = -1
        }else{
          cur = vertexes(cur).next.verAdj
        }        
      }
      cur = stack.pop()
      
      // if children of current node aren't all visited, push current
      // node back to stack so that not visited children can be visited later
      var allChildVisited = true
      nextNotVisited = vertexes(cur).next
      while ( allChildVisited && nextNotVisited != null ){
        if ( visited(nextNotVisited.verAdj) == 0 ){
          allChildVisited = false
        }else{
          nextNotVisited = nextNotVisited.next
        }        
      }
      if ( allChildVisited ){
        cur = -1
      }else{
        stack.push(cur)
        cur = nextNotVisited.verAdj        
      }
      
    }while ( stack.nonEmpty )    
  }

```

stack implementation 2  
```scala
  /**
   * simpler than 1st implementation
   */
  def depthFirstSearchStackImp2() {
    val visited = new Array[Int](vertexes.size)
    for (i <- 0 to visited.length -1 ){
      visited(i) = 0
    }
    val stack = Stack[Int]()
    var cur = 0
    stack.push(cur)
    while ( stack.nonEmpty ){
      cur = stack.pop()
      if ( visited(cur) == 0 ){
        println(cur)
        visited(cur) = 1        
      }
      var nextChild = vertexes(cur).next
      while ( nextChild != null && visited(nextChild.verAdj) == 1){
        nextChild = nextChild.next
      }
      if (null != nextChild){
        stack.push(cur)
        cur = nextChild.verAdj
        stack.push(cur)
      }           
    }    
  }
```

stack implementation 3  
```scala
  /**
   * much simpler but is indeed not depth first search
   */
  def depthFirstSearchStackImp3() {
    val visited = new Array[Int](vertexes.size)
    for (i <- 0 to visited.length -1 ){
      visited(i) = 0
    }
    val stack = Stack[Int]()
    var cur = 0
    stack.push(cur)
    while ( stack.nonEmpty ){
      cur = stack.pop()
      if ( visited(cur) == 0 ){
        println(cur)
        visited(cur) = 1        
      }
      var nextChild = vertexes(cur).next
      while ( nextChild != null){
        if ( visited(nextChild.verAdj) == 0 ){
          stack.push(nextChild.verAdj)
        }
        nextChild = nextChild.next
      }
    }    
  }
```

**Width First Search**  
Width first search of graph is similar to level order traversal of a tree  

```scala
  def widthFirstSearch() {
    val visited = new Array[Int](vertexes.size)
    for (i <- 0 to visited.length -1 ){
      visited(i) = 0
    }
    val queue = new Queue[Int]()
    var cur = 0
    queue.enqueue(cur)
    while( queue.nonEmpty ){
      cur = queue.dequeue()
      if ( visited(cur) == 0 ){
        visited(cur) = 1
        println(cur)
      }
      var nextChild = vertexes(cur).next
      while ( nextChild != null){
        if ( visited(nextChild.verAdj) == 0 ){
          queue.enqueue(nextChild.verAdj)
        }
        nextChild = nextChild.next
      }
    }
  }
```

##### Topological Sorting
* Topological Sorting, 拓扑排序  
* AOV网: Activity On Vertex Network, 用顶点表示活动, 用有向边表示活动之间的先后关系, 这样的有向图为AOV
* 拓扑序列: 把AOV网中的所有结点排成一个线性序列, 该序列满足如下条件: 如果AOV网中存在有向边<Vi, Vj>, 则在序列中Vi必在Vj之前
* 拓扑排序:  构造AOV网的拓扑序列的操作即是拓扑排序
* Complexity:  o(n+e), e 为边数, n为顶点数

**Topological Sorting Algorithm**  
1.  发现入度为0的一个顶点并输出之
2.  从AOV网中"删除"步骤1中的顶点, 更新其他顶点的入度  
重复步骤1,2, 直到或者所有的顶点都输出, 或者部分结点输出, 图中有`回路`  

```scala
  def topoOrder(): ArrayBuffer[Int] = {
    // initiate an array of in-degree of all vertexes
    val indegree = new Array[Int](vertexes.size)
    val result = new ArrayBuffer[Int]
    
    for (i <- indegree){
      indegree(i) = 0
    }
    for ( i <- vertexes ){
      var child = i.next
      while ( child != null ){
        indegree(child.verAdj) += 1 
        child = child.next
      }
    }
    // use array to simulate a stack, top is the top of the stack
    var top = -1
    for ( i <- 0 to indegree.length - 1 ){
      if ( indegree(i) == 0 ){
        // a typical stack-in operation by array simulation
        indegree(i) = top
        top = i
      }
    }
    
    val maxRound = vertexes.length
    for ( i <- 1 to maxRound ){
      if ( top != -1 ){
        // a typical stack-out operation by array simulation
        var cur = top
        top = indegree(top)
        result += cur
        
        // "delete" cur vertex, update indegree of the rest vertexes 
        var child = vertexes(cur).next
        while(child != null){
          indegree(child.verAdj) -= 1
          if ( indegree(child.verAdj) == 0 ){
            indegree(child.verAdj) = top
            top = child.verAdj
          }          
          child = child.next
        }
      }else{
        throw new RuntimeException("there is a circurt")
      }
    }
    result
  }

```


##### AOE Critical Path
* AOE网: Activity On Edge Network, 边表示一个活动, 边上的权值(weight)表示活动所需的时间, 顶点是事件, 表示其入边事件的完成, 其出边事件可以开始
* Complexity:  o(n+e), e 为边数, n为顶点数  

设表示活动Ai的边<Vj, Vk>,  
e(i)和l(i)分别表示活动Ai的最早和最晚的发生时间  
ve(j)和vl(j)分别表示顶点Vj的最早和最晚的发生时间  
有如下结论  
e(i) = ve(j)
l(i) = vl(k) - weight(<Vj, Vk>)  
对于(按拓扑排序)最后的顶点n,   
vl(n) = ve(n)  

**AOE Critical Path Algorithm**  
1. 对图做拓扑排序, 如果有回路, 终止算法
2. 按拓扑排序的顺序, 计算各个顶点的最早开始时间, 计算方法是  
ve(0) = 0   
ve(j) = max{ ve(i) + weight(<Vi, Vj>) } if there is edge <Vi, Vj>   
3. 计算(按拓扑排序)最后顶点n的vl(n): vl(n) = ve(n)  
4. 按拓扑排序的逆序, 计算各个顶点的最晚开始时间, 计算方法是  
vl(n) = ve(n)  
vl(i) = min { vl(j) - weight(<Vi, Vj>) } if there is edge <Vi, Vj>   
6. 计算各个活动的最早和最晚发生时间, 计算公式如下  
e(i) = ve(j)
l(i) = vl(k) - weight(<Vj, Vk>)  
如果e(i) = l(i) , 则活动Ai是关键活动, 在关键路径上  

##### None Weight Shortest Path
* None Weight Shortest Path, 无权最短路径.   
* 单源无权最短路径的算法, 基本是图的Width First Search(广度优先排序算法)   
* Complexity:  o(n+e), e 为边数, n为顶点数  

所以, 当从源点的广度优先遍历首次访问到某顶点时, 可以计算该顶点最短路径, 设有向边<Vi, Vj>, 从源点到Vj的无权最短路径没有计算, 而从源点到Vi的无权最短路径已经计算, 则  
shortest_path(Vj) = shortest_path(Vi) + <Vi, Vj>  
length(Vj) = length(Vi) + 1  

可以用单一数组存储各个顶点最短路径:  
path[j] = i, 当边<Vi, Vj>是从源点广度优先遍历首次打到Vj的边  

##### Positive Weight Shortest Path 
* 单源正权最短路径  
* Dijkstra算法可以作为一个通用的计算方法解决一类最优问题
* Complexity:  o(n^2 + e), e 为边数, n为顶点数  


**Dijkstra Algorithm**  
设初始时(s为源点), Ds = 0, 对于其他顶点 i != s,  Di = max   
数组visited[i] = 0 (包括源点) 表示顶点i没有被访问过; 一旦被访问, 则令visited[i] = 1  
数组path[i]存储从源点到达顶点i的最短路径上的前一个顶点
1. 从没有被访问过的顶点中选择Dv最小的顶点v, 访问顶点v, 令visited[v] = 1  
2. 一次检验与顶点v的所有顶点w, 如果Dv + weight(v,w) < Dw, 则更新Dw = Dv + weight(v,w), 且path[w] = v  


##### Negtive Weight Shortest Path
If there is negtive weight circuit(负开销回路) between source vertex to targe vertex, the shortest path doesn't exist.  

Complexity:  o(n*e), e 为边数, n为顶点数  

单源负权最短路径算法基本类似与图的层次遍历, 不过对每个顶点增加一个访问计数, 用以控制每个顶点被访问的次数. 访问次数过多(超过2倍顶点个数), 则存在开销回路.  

scratch[]数组, 初始值为零, 当一个顶点v入队(enqueue)或者出队(dequeue), scratch[v]++ 于是可知, scratch[v]为奇数时, 顶点v已经在队列; 为偶数时, 则不在队列.   

path[]数组用于记录最短路径, path[v] = k 表示源点到v的最短路径中, v之前的顶点是k.  
dist[]数组用于记录开销  

**Negtive Weight Shortest Path Algorithm**  
1. 初始化阶段, 源点S入队, 并令dist[S] = 0, scratch[S] = -1, path[S] = -1. 对于其他顶点v, dist[v] = max, scratch[v] = 0,  path[v] = -1
2. 从队列中弹出一个顶点v, 如果scratch[v] > 2n, 则终止算法, 标明有负开销回路, 否则, 计算如下,   
    1. 遍历v的所有邻接顶点k, 对于每一个k, 计算如下,   
        1. if ( dist[v] + weight(v, k) < dist[k] ) {   
              if ( scratch[k] 是偶数 ) {  
                 表示k不在队列里面   
                 将k入队    
                 scratch[k] = scratch[v] + 1  
              }else {  
                 表示k已经在队列里面   
                 if ( scratch[v] + 1 > scratch[k] ){  //奇怪,可能是为了保持scratch的单调递增才有这个条件判断     
                    scratch[k] = scratch[v] + 1   
                 }  
              }  
              dist[k] = dist[v] + weight(v, k)    
              path[k] = v  
            }   
           }    


##### Shorest Path for all vertexes
* an alternative way, execute Dijkstra algorithm for each vertex, complexity is o(n^3)
* 算法是一种计算顺序的模式  
* Complexity: o(n^3)

Algorithm:  
考虑顶点集S0 = {V0},  S1 = {V0, V1}, ... S(n-1) = {V0, V1, ..., V(n-1)}   
第0步, Vi ~ Vj的最短路径设置为weight(Vi, Vj), 如果没有直接路径, 设为max   
第1步, 考虑是否存在路径Vi ~ Vj,  其经由的顶点是S0的子集, 即有Vi ~ V0 和 V0 ~ Vj. 考察其路径小于当前最短路径, 有则更新   
第2步, 考虑是否存在路径Vi ~ Vj,  其经由的顶点是S1的子集, 而不是S0的子集, , 考察其路径小于当前最短路径, 有则更新   
...   

```scala
  def eachVertexesMinDist( path: Array[Array[Int]] ) : Array[Array[Int]] = {
    val dist: Array[Array[Int]] = Array.ofDim(edges.length, edges.length)
    // the last vertex to vertex j in path Vi -> Vj
    for ( i <- 0 to edges.length-1 ){
      for ( j <- 0 to edges(i).length-1 ){
        dist(i)(j) = edges(i)(j)
        path(i)(j) = -1
        if ( edges(i)(j) == Int.MinValue ){
          dist(i)(j) = Int.MaxValue
        }else{
          path(i)(j) = i
        }
        
      }
    }

    for (k <- 0 to dist.length - 1) {
      for (i <- 0 to dist.length - 1) {
        if (i != k) {
          for (j <- 0 to dist.length - 1) {
            if (j != k && i != j && 
                dist(i)(k) < Int.MaxValue && dist(k)(j) < Int.MaxValue && 
                ( dist(i)(k) + dist(k)(j) < dist(i)(j) ) ) {
              dist(i)(j) = dist(i)(k) + dist(k)(j)
              path(i)(j) = path(k)(j)
            }
          }
        }

      }
    }
    dist
  }
```

##### Minimum-cost Spanning Tree
* 连通图的代价:  若要在n个顶点之间建立连通图, 则至少要n-1条边, 这些边的权值之和就是连通图的代价  
* Minimum-cost Spanning Tree(MST, 最小支撑树): 对于无向网络(V(n), E(m)), 代价最小的连通图(V(n), E(n-1))即是最小支撑树. 对一个图, 最小支撑树不唯一   
* MST性质:  对于连通图N=(V, E), U是V的非空子集, 顶点u在U集合中, 顶点v在V集合中, 且weight(u,v)是这样的顶点对中最小的, 则边(u,v)一定在该图的某个最小支撑树中

**Prime Algorithm**  
* Complexity:  o(n ^ 2), e 为边数, n为顶点数  
* 适合于边稠密网   
  
![algorithm_graph_mst_prime_1]  

对于图N = (V, E), 设U为已连通的顶点的集合, MST-E是最小支撑树的边的集合  
1. 初始时, U = {V0}, MST-E = null, (PS: 初始顶点V0可以任选, 也可以是最短边的任意一个顶点)  
2. 找出分别在U和V-U中顶点u, v中, weight(u,v) 最小的, 把边(u,v)加到MST-E集合, v 加入到U集合
3. 重复步骤2直至U=V



**Kruskar Algorithm**  
* Complexity:  o(e * log(e)), e 为边数, n为顶点数  
* 适合于边稀疏网   

![algorithm_graph_mst_kruskar_1]   

对于图N = (V, E), 设T是当前连通分量的集合, MST-E是最小支撑树的边的集合     
1. 初始时, T = {V}, n个顶点构成了n个联通分量
2. 从边集合E中删除权值最小的边e. 如果e在当前T的两个不同的连通分量里面, 则合并两个连通分量, 并且把e加入到MST-E集合中, 如果不是, 则继续步骤2
3. 重复步骤2直到T中只有一个连通分量

##### Reachability & Warshall Algorithm
* 计算可及性矩阵, 判断任意两个顶点的可及性  
* 基本是算法Shorest Path for all vertexes

**Warshall算法**:  
1. 对所有顶点拓扑排序(PS: 必要吗?? 只是提高算法效率吧)
2. 套用算法Shorest Path for all vertexes

**连通分量**  
基本是两次depth first search,  
1. 第一次depth first search 找出所有与某一顶点Vi可及的顶点集U
2. 对每个U里面的顶点做depth first search, 看看是否可以打到顶点Vi, 是的话与Vi在同一个连通分量
3. 选择一个不再任何已知连通分量的顶点Vj, 重复步骤1, 2, 直到所有的顶点都在某个连通分量里面

#### String
**Plain Pattern Match**  
* 逐一字符比较, 失败后pattern string的指针归0, 目标串指针加一, 直到找到匹配或者目标串到达字符串尾部  
* Complexity: O( m * n ), m为pattern string长度, n为目标串长度

##### KMP Fast Find
设字符串S0S1...Sn, 失败函数(failure function) 定义如下:  
f(n)  = k, k为满足0<= k < n, 且S0S1...Sk = S(n-k)...Sn的最大整数   
或者 f(n) =  -1, 没有上述的k存在或n=0
即失败函数找到最大的前后相等的子串  

**KMP Fast Find**  
1. 逐一字符比较, 失败后设当前成功匹配的长度为p
  1. 若p == 0, 目标串指针加一, 继续匹配
  2. 若p > 0, 计算p的失败函数f(p) = k, pattern string从k+1处开始比较, 目标字符串从失败点开始比较
2. 重复上述过程直到找到匹配或者目标串到达字符串尾部  

```scala
    val failFunction: Array[Int] = failureFunction(pattern) 
    val m = pattern.size
    val n = target.size
    var t, p = 0
    while ( t < n && p < m  ){
      if ( pattern(p).equals(target(t)) ){
        p += 1
        t += 1
      }else if ( p == 0 ) {
        t += 1
      }else {
        p = failFunction(p-1) + 1
      }
    }
    
    if ( p < m ){
      -1
    }
    t - m
  }
```

失败函数f(j)的方法:  
1. 初始时f(0) = -1
2. 重复的过程, 直到某次迭代算出结果
    1. 令本轮的计算值m = j-1
    2. 计算f(m) = k, 如果S(k+1) = S(j+1), 则 f(j) = f(m) + 1, 返回
    3. 否则令 m = f(m), 重复步骤2.2  
 
可以顺次计算失败函数0, 1, ....  

```scala
  def failureFunction( pattern: String ): Array[Int] = {
    val result = new Array[Int](pattern.size)
    result(0) = -1
    for ( i <- 1 to result.length -1 ){
      var j = result(i-1)
      while ( ! pattern(j+1).equals(pattern(i)) && j >= 0){
        j = result(j)
      }
      if ( pattern(j+1).equals(pattern(i)) ){
        result(i) = j + 1
      }else{
        result(i) = -1 
      }
    }
    result
  }
```

Complexity: m为pattern string长度, n为目标串长度  
1. 失败函数:  O(m)
2. KMP Fast Find: O(m+n)  





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
[algorithm_sorting_1]:/resources/img/java/algorithm_sorting_complexity_1.png "Array Sorting Algorithms Complexity Chart"
[algorithm_sorting_2]:/resources/img/java/algorithm_sorting_complexity_2.png "Array Sorting Algorithms Complexity & Stability Chart"
[algorithm_graph_mst_prime_1]:/resources/img/java/algorithm_mst_prime_1.png "graph_mst_prime"
[algorithm_graph_mst_kruskar_1]:/resources/img/java/algorithm_mst_kruskar_1.png "graph_mst_kruskar"
