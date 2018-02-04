#       Digest of programmer's interview bible written by He Hao 20121001
##                       [程序员面试笔试宝典].何昊 2012年10月1日.扫描版

---

Indexes
---
* [Algorithm](#algorithm)
* [Network](#network)

Algorithm
---

Content                                                             |Strategy                                                                   | Pages
-----------------------------------------------------|----------------------------------------------------------|------------------------------------
改进的(带偏向)的二分查找法                               |                                                                                 |299/314
二分查找法的灵活应用                                        |--                                                                              |301/316
数组的一种空间换时间的策略                              |数组结构变换策略一: array[MAX]                              |301/316
在o(n)下找到数组内重复数超过一半的数              |--                                                                              |303/318
在a[N]数组中存放1到N-1,某数重复一次,找出它    |位图法,异或法,及数组结构变换策略二:计数排序, 策略三: negtive element    |305 
用数组存储单链表判断其无环形                          |数组变换策略四:  simulate Linklist                              |308
找出仅有的2个出现奇数次的元素                        |异或法(按位)                                                              |310
符合条件的数对                                                 |数组结构变换策略二:计数排序, hash法                         |311
如何判断数组中是否有重复元素                          |数组结构变换策略五: exchange index                         |315
去掉整型数组的重复数字                                    |`排序后不借助辅助数组去重`                                      |317
取双元素法                                                        |--                                                                               |319
找到单链表中的倒数第K个元素                           |--                                                                               |329
反向输出单链表                                                 |递归比较适合反向输出                                                |330
单链表的中间节点                                              |--                                                                                |331
链表的冒泡排序及数组归并排序                          |--                                                                               |332
单链表交换任意元素                                          |--                                                                               |334
较大的单链表是否有环                                       |--                                                                               |335
`如何找到环入口点`                                          |--                                                                               |336
判断2个链表是否相交及交点                              |--                                                                               |337
删除单链表重复元素                                          |--                                                                                |338
字符串(不借助临时变量)逆序                             |异或法                                                                         |347
字符串中按单词逆序                                          |--                                                                               |349
输出字符串的所有组合                                      |--                                                                                |351
循环队列下标的使用                                          |--                                                                                |356
选择排序                                                          |--                                                                                |359
插入排序                                                          |--                                                                                |360
冒泡排序                                                          |--                                                                                |361
归并排序                                                          |--                                                                                |364
快速排序                                                          |--                                                                                |366 
希尔排序                                                          |--                                                                                |368
堆排序                                                             |[algorithm_heap_data_structure_1]                          |369
排序总结和表格                                               |[algorithm_complexity_complete_list_1]                    |371
二叉树的基本性质                                            |--                                                                                |372
完全二叉树结点个数计算题                              |--                                                                                |373
海量数据处理                                                  |--                                                                                |390
位图法处理海量数据示例1                                |--                                                                                |406
数组后面m个数移动到前面m个位置                  |--                                                                                |320  

* 输出字符串的所有组合  
```python
# print all possible substring combination of a string
# for example, for 'abc', result is c,b,bc,a,ac,ab,abc

def __strPrinter(strArray, endIndex, delimiter = ''):
    '''endIndex is inclusive'''
    return delimiter.join(strArray[:endIndex+1])

def substrCombinationInternal(source,curStrIndex,stackIndex, stack):
    '''It has 2^n stack invocation.'''
    if curStrIndex == len(source):
        stackIndex -= 1
        # it is very important to restrain the upper bound of result
        # since data beyond it is garbage from previous round of computation
        if stackIndex >= 0:
            print(__strPrinter(stack, stackIndex))
    else:
        substrCombinationInternal(source,curStrIndex+1,stackIndex, stack)
        stack[stackIndex] = source[curStrIndex]
        substrCombinationInternal(source,curStrIndex+1, stackIndex+1, stack)

def substrCombination(source):
    substrCombinationInternal(source, 0, 0,['' for i in range(0, len(source))])

substrCombination('abcd')   
```

* 数组结构变换策略二:计数排序  
可以认为是一种特殊的Hash方法, 对于key, hash(key) = index key of array, 该方法需要辅助数组array[MAX+1], MAX是输入数组的最大元素值.

* 循环队列下标的使用
```python
# initial
front = rear = 0

# isFull
(rear + 1) mod MAXSIZE == front

# isEmpty
front == rear

# dequeue
if not isEmpty:
    front = (front + 1) mod MAXSIZE
    return queue[front]

# enqueue
if not isFull:
    rear = ( rear + 1 ) mod MAXSIZE
    queue[rear] = new element
```

* 数组后面m个数移动到前面m个位置, 正确方法是:  
1. 逆序后面m个数
2. 逆序前面n-m个数
3. 逆序整体  

Network
---
Content                                                                             | Pages
----------------------------------------------------------------|------------------------------------------------------------------------------------
OSI 七层网络模型                                                             |254/269
TCP/IP四层模型与七层模型映射及常见协议所处层              |255/270
路由器, 交换机, 集线器(Hub)的区别                                    |258
TCP与UDP的区别                                                               |260
三次握手和四次断开                                                          |260
ARP与RARP工作原理                                                         |262
基本的HTTP流程                                                               |264
Socket编程                                                                       |264
电路交换, 报文交换, 分组交换及ATM的区别                       |268
IPv4与IPv6                                                                      |269



OSI             |TCP/IP 4层  |Application                                                                |Comments
--------------|--------------|-----------------------------------------------------------|-----------------------------------------------------------
应用层         |应用层          |HTTP,FTP,NFS                                                          |--
表示层         |应用层          |SNMP,Telnet                                                             |--
会话层         |--                 |RPC,X Windows,DNS,SMTP                                        |单工, 半/全双工
传输层         |传输层          |TCP,UDP,SPX                                                             |最重要的一层, 段(Segment), 流量控制
网络层         |网际层          |路由器,IP,ICMP, ARP, RARP, RIP,OSPF                      |网络地址->物理地址, 包(Package), 数据包和路由更新包
数据链路层  |网络接口层   |交换机,MAC,PPP,SDLC,HDLC,帧中继,STP                     |帧(Frame), 流量控制
物理层         |网络接口层   |集线器(Hub),IEEE 802.1A, IEEE802.2到IEEE802.11  |--

![network_tcp_ip_img_1]   

交换机负责同一网段通讯, 路由器可负责不同网段的通讯.   
传统交换机分割冲突域, 不分割广播域, 广播数据会在交换机连接的所有网段上传播  

* TCP基于字节流, UDP基于数据报  
* TCP不会乱序和丢包, UDP会

由于TCP是全双工的, 要求连接两方都要单独关闭连接, 所以需要四次断开  

![network_tcp_ip_img_2]  

ping命令用的是TCP/IP协议簇中的ICMP(Internet Control and Message Protocal)  

![network_tcp_ip_socket_img_1]  

Socket Type     | Read                         | Write
----------------|------------------------------|------------------------------
TCP 阻塞        | 线程挂起                      | 线程挂起
TCP 非阻塞      | 立即异常返回                  | 立即异常返回
UDP             | 接收缓存区为空则挂起           | 无发送缓存区, 直接发送

分组交换技术: 面向无连接和存储转发技术

IPv4 VS IPv6  
1. 寻址空间
2. 路由效率
3. 对组播和流及多媒体的支持
4. 扩展的安全性 

---
[algorithm_heap_data_structure_1]: https://en.wikipedia.org/wiki/Binary_heap#Heap_implementation "堆数据结构"
[algorithm_complexity_complete_list_1]: http://bigocheatsheet.com/ "Big O List"
[network_tcp_ip_img_1]:/resources/img/java/network_tcp_ip_1.png "TCP/IP VS OSI"
[network_tcp_ip_img_2]:/resources/img/java/network_tcp_ip_2.png "三次握手和四次断开"
[network_tcp_ip_socket_img_1]:/resources/img/java/network_tcp_ip_socket_1.png "socket flow"
