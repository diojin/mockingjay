# 			编程之法:面试和算法心得
#                             The Art Of Programming By July
## 				by July

---
## Indexes
* [Going Over](#going-over)
    - [Chapter 1. String](#chapter-1-string)
        + [字符串包含](#字符串包含)
            * [素数相乘][素数相乘]
            * [位运算法][位运算法]
        + [字符串的全排列](#字符串的全排列)
            * [字典序排列](#字典序排列)
* [Unsolved](#unsolved)
    - [变位词][变位词]
* [Miscellaneous](#miscellaneous)

---

[The-Art-Of-Programming-By-July in github]  
[The-Art-Of-Programming-By-July Menu]   

## Going Over

### Chapter 1. String
#### 字符串包含
#### 字符串的全排列
[字符串的全排列]  
##### 字典序排列
在了解next_permutation算法是怎么一个过程之前，咱们得先来分析下“下一个排列”的性质。

假定现有字符串(A)x(B)，它的下一个排列是：(A)y(B’)，其中A、B和B’是“字符串”(能为空），x和y是“字符”，前缀相同，都是A，且一定有y > x。
那么，为使下一个排列字典顺序尽可能小，必有：  
* A尽可能长
* y尽可能小
* B’里的字符按由小到大递增排列
现在的问题是：找到x和y。怎么找到呢？咱们来看一个例子。

比如说，现在我们要找21543的下一个排列，`我们可以从左至右逐个扫描每个数，看哪个能增大（至于如何判定能增大，是根据如果一个数右面有比它大的数存在，那么这个数就能增大）`，我们可以看到最后一个能增大的数是：x = 1。

而1应该增大到多少？1能`增大到它右面比它大的那一系列数中最小的那个数`，即：y = 3，故此时21543的下一个排列应该变为23xxx，显然 xxx(对应之前的B’）应由小到大排，于是我们最终找到比“21543”大，但字典顺序尽量小的23145，找到的23145刚好比21543大。

**next_permutation算法**   
定义:  升序：相邻两个位置ai < ai+1，ai 称作该升序的首位  
步骤（二找、一交换、一翻转）:  
1. 找到排列中最后（最右）一个升序的首位位置i，x = ai
2. 找到排列中第i位右边最后一个比ai 大的位置j，y = aj
3. 交换x，y
4. 把第(i+ 1)位到最后的部分翻转
重复上述过程直至循环结束.  
由于全排列总共有n!种排列情况，所以不论解法一中的递归方法，还是上述解法二的字典序排列方法，这两种方法的时间复杂度都为O(n!)。  




## Unsolved


## Miscellaneous

---
[spark_distributed_execution_img_1]:/resources/img/java/spark_distributed_execution_1.png "Figure 2-3. Components for distributed execution in Spark"
[The-Art-Of-Programming-By-July in github]:https://github.com/julycoding/The-Art-Of-Programming-By-July "The-Art-Of-Programming-By-July"
[The-Art-Of-Programming-By-July Menu]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/Readme.md "The-Art-Of-Programming-By-July Menu"
[素数相乘]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/01.02.md/#解法三 "素数相乘"
[位运算法]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/01.02.md/#解法四 "位运算法"
[变位词]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/01.02.md/#举一反三 "变位词"
[字符串的全排列]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/01.06.md "字符串的全排列"