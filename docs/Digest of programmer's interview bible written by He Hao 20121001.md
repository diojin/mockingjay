#       Digest of programmer's interview bible written by He Hao 20121001
##                       [程序员面试笔试宝典].何昊 2012年10月1日.扫描版

---

Indexes
---
* [Algorithm](#algorithm)
* [Network](#network)

Algorithm
---

Content                                |Strategy                   | Pages
---------------------------------------|---------------------------|-----------
改进的(带偏向)的二分查找法               |                           |299/314
一种空间换时间的策略                     |数组结构变换策略一          |301/316
在o(n)下找到数组内重复数超过一半的数      |--                        |303/318
在a[n]数组中存放1到N-1,某数重复一次,找出它|位图法,异或法,及数组结构变换策略二,三|305 
用数组存储单链表判断其无环形             |特殊的变换策略              |308
找出仅有的2个出现奇数次的元素            |异或法                      |310
符合条件的数对                          |hash法                     |311
如何判断数组中是否有重复元素             |数组结构变换策略三           |315
去掉整型数组的重复数字                   |--                         |317
取双元素法                              |--                         |319
找到单链表中的倒数第K个元素              |--                         |329
反向输出单链表                           |--                        |330
单链表的中间节点                         | --                       |331
链表的冒泡排序及归并排序                  |--                        |332
单链表交换任意元素                       |--                        |334
较大的单链表是否有环                     |--                        |335
如何找到环入口点                        |--                         |336
判断2个链表是否相交及交点                |--                         |337
删除单链表重复元素                      |--                         |338
字符串(不借助临时变量)逆序               |异或法                     |347
字符串中按单词逆序                      |--                         |349
输出字符串的所有组合                    |--                         |351
循环队列如何判断队列为满                 |--                         |356
选择排序                                |--                         |359
插入排序                                |--                         |360
冒泡排序                                |--                         |361
归并排序                                |--                         |364
快速排序                                |--                         |366 
希尔排序                                |--                         |368
堆排序                                  |[algorithm_heap_data_structure_1] |369
排序总结和表格                       |[algorithm_complexity_complete_list_1]|371
二叉树的基本性质                         |--                         |372
完全二叉树结点个数计算题                  |--                         |373
海量数据处理                             |--                         |390
位图法处理海量数据示例1                   |--                         |406
数组后面m个数移动到前面m个位置           |--                          |320

数组后面m个数移动到前面m个位置, 正确方法是:  
1. 逆序后面m个数
2. 逆序前面n-m个数
3. 逆序整体  

Network
---
Content                                                            | Pages
-------------------------------------------------------------------|-----------
OSI 七层网络模型                                                    |254/269
TCP/IP四层模型与七层模型映射及常见协议所处层                           |255/270
路由器, 交换机, 集线器(Hub)的区别                                    |258
TCP与UDP的区别                                                      |260
三次握手和四次断开                                                   |260
ARP与RARP工作原理                                                   |262
Socket编程                                                          |264
电路交换, 报文交换, 分组交换及ATM的区别                               |268
IPv4与IPv6                                                          |269



OSI     |TCP/IP 4层  |Application               |Comments
--------|------------|--------------------------|------------------------------
应用层   |应用层|HTTP,FTP,NFS|--
表示层   |应用层|SNMP,Telnet|--
会话层   |--|RPC,X Windows,DNS,SMTP|单工, 半/全双工
传输层   |传输层|TCP,UDP,SPX|最重要的一层, 段(Segment)
网络层   |网际层|路由器,IP,ARP,RIP,OSPF|网络地址->物理地址, 包(Package), 数据包和路由更新包
数据链路层|网络接口层|交换机,MAC,PPP,SDLC,HDLC,帧中继,STP|帧(Frame)
物理层   |网络接口层|集线器(Hub),IEEE 802.1A, IEEE802.2到IEEE802.11|--

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
