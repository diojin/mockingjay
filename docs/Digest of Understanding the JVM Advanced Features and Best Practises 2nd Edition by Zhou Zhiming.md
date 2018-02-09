#               深入理解Java虚拟机--JVM高级特性与最佳实践 第二版
#       Understanding the JVM Advanced Features and Best Practises 2nd Edition 
##                                      周志明
---

## Indexes

* [Contents](#contents)
* [Miscellaneous](#miscellaneous)

Contents
---

1. 走进Java                                                            --  5/26

    ![jvm_java_timeline_img_1]  

Java Version | Code Name        |Time   |Features
-------------|------------------|-------|--------------------------------------
Java 1.0     | --               |1995   |--
JDK 1.0      | --               |1996   |--
JDK 1.1      | --               |1997   |RMI, JDBC         
JDK 1.2      | Playground       |1998   |EJB
JDK 1.3      | Kestrel(美洲红隼)|2000   |2000年以后基本每2年一个版本  
JDK 1.4      | Merlin(灰背隼)    |2002   |成熟版本, 正则, NIO, 1.4.2 Mantis 螳螂, ParallelScanvenge GC
JDK 1.5      | Tiger            |2004   |语法易用性的改进(自动装箱拆箱, 泛型, 动态注释,for each), JMM Java内存模型, concurrent 包  
JAVA 6       | Mustang(野马)    |2006    |对虚拟机做了很大的改进, 包括锁与同步, 垃圾回收, 类加载等, 动态语言支持(通过内置Mozilla Javascript Rhino引擎), 提供插入式注解处理器API, ParallelOld GC  
OpenJDK      | --               |2006/11 |2006年11月13, Java开源, 随后建立OpenJDK
JAVA 7       | Dolphin          |2011   |G1收集器, 加强对非Java语言调用, 升级类加载框架
JAVA 8       | --               |2013   | Lambda, Coin(语言细节进化)??, Jigsaw??(语言级模块化的支持, 1.9)

2. 自动内存管理机制                                                  -- 37/58  
![jvm_java_memory_allocation_img_1]  
    
    1. 64位虚拟机, 由于指针膨胀和数据类型的对白补齐等原因, 性能于32位虚拟机有大概15%的差距                                   -- 13/34    
    
    2. 栈(Stack)分为Java虚拟机栈和本地方法栈, 
    都会抛出OutOfMemoryError和StackOverflowError  
    
    3. 随着JIT编译器以及逃逸分析技术的逐渐成熟, 栈上分配,标量替换等优化技术使得所有Java Object都分配于堆(Heap)上变得不绝对  
    
    4. TLAB, Thread Local Allocation Buffer, 线程私有的分配缓存区
    
    5. 直接内存(Direct Memory)                                      -- 43/64  
    NIO 可以使用Native函数分配堆外内存, 然后使用存储于堆中的DirectByteBuffer对象引用该内存, 进而操作它.   
    可能产生OutOfMemoryError  

    Direct Memory 不是在其快满了的时候回收, 而是在Full GC时"顺手"回收  -- 137/158  

    6. HotSpot虚拟机使用直接指针方式进行对象访问(非指针句柄方式)   
    
    7. 栈上的异常情况                                                -- 53/74  
        作者实测结果, 好像不太准     
        1. 单线程  
            无论是递归调用层数太深, 还是分配大量的栈上变量, 都抛StackOverflowError
        2. 多线程  
            无限创建线程, 抛OutOfMemoryError  
        虚拟机规定,   
        1. StackOverflowError, 栈深度大于虚拟机允许的最大深度  
        2. OutOfMemoryError, 扩展栈上无足够的内存空间  

        又或者,  
        StackOverflowError, 无法分配新栈帧    
        OutOfMemoryError, 无法创建新线程  

        -Xss: 栈内存大小  
        -XX:PermSize 和 -XX:MaxPermSize, Perm区(方法区)大小
    8. Direct Memory 内存分配                                       -- 59/80  
        * Unsafe.getUnsafe() 方法只有在引导类加载器才返回非空实例, 所以用反射调用, 并通过Unsafe类的实例分配Direct Memory内存  
        * 通过DirectByteBuffer分配内存发生OutOfMemoryError时并非直接分配内存, 而是计算会溢出就抛异常, 真正的内存分配动作是由Unsafe.allocateMemory()来完成  
        * -XX:MaxDirectMemorySize, 指定Direct Memory大小, 没设置时其值与-Xmx一样  
        * Direct Memory OOM时, 特征是Heap Dump小, 但直接间接引用了NIO  
        
    9. 除了JAVA堆和永久代以外, 其他需要注意OOM的内存区域列表                         -- 137/158  
        * 线程栈: -Xss    
        * Direct Memory(NIO)  
        * JNI代码  
            如果用JNI调用本地库代码, 本地库使用的内存不再堆中          
        * Socket缓存区          
        * 虚拟机和GC的额外开销       
```java
    /**
     * -XX:MaxDirectMemorySize=10M
     * @throws IllegalAccessException
     */
    public static void allocationDirectMemory() throws IllegalAccessException{
        final int _1MB = 1024 * 1024;
        Field unsafeField = Unsafe.class.getDeclaredFields()[0];
        unsafeField.setAccessible(true);
        Unsafe unsafe = (Unsafe)unsafeField.get(null);
        unsafe.allocateMemory(_1MB);                
    }
```

3. 垃圾回收器及内存分配策略  
    1. 可作为GC Root的对象                                             -- 64/85  
        * 虚拟机栈及本地方法栈引用的对象  
        * 常量引用的对象  
        * 静态变量(方法区中类的静态属性)引用的对象  
    2. 引用类型                                                      -- 65/86   
        * Strong Reference  
        * Soft Reference, 无论是否引用, 发生内存溢出前直接回收. 若回收后导致内存够用则不产生内存溢出错误  
        * Weak Reference, 无论是否引用, 下一次垃圾收集时回收  
        * Phantom Reference, 无法通过该引用获得对象, 也不影响被引用对象的生存时间, 为某对象设置该引用是为了在被引用对象被回收时, 收到一个系统通知  

    3. finalize queue, 对象死亡过程                                   -- 66/87  
    4. 回收方法区的类信息, 条件及应用场景                               -- 68/89  
        两部分: 常量和类信息  
        常量: 与其他对象一样, 无引用被回收  
        类信息回收的条件苛刻:  
        * 类的所有实例都被回收  
        * 类对应的java.lang.Class对象没有被引用, 无法通过反射生成该类  
        * 类的class loader被回收  
        
        频繁自定义ClassLoader以及生成类场景, 应注意回收方法区    
        * 反射,动态代理,CGLib等bytecode框架
        * JSP
        * OSGi  

    5. HotSpot垃圾收集器关系图                                         -- 75/96  
        ![jvm_hotspot_1.6_gc_list_img_1]   
        
        标记-整理(Mark-Compact)算法:                                   -- 71/92  
        先标记 -> 存活对象移动至一端 -> 回收端边界以外的内存   
        
        **STW: Stop The World**  
        * Serial                                                     -- 76/97  
            - Young Generation  
            - 复制算法  
            - Single Thread  
            - STW  
            - Client model default  
            - 100MB~200MB/100ms    
        * Serial Old                                                -- 80  
            - Tenured Generation  
            - 标记-整理算法  
            - Single Thread
            - STW
            - Client model default  
            - Backup for CMS during concurrent mode failure
        * Paralell New (ParNew)                                     -- 77  
            - Young Generation   
            - Serial的Multi Thread版, 其他都一样  
            - STW  
            - Default Young Gen GC for CMS               
        * Paralell Old                                              -- 80  
            - Serial Old 的多线程版本
            - 与Parallel Scanvenge一起, 作为首选吞吐量优先的收集器组合  
            - JAVA 6 开始提供  
        * Paralell Scanvenge(PS)                                    -- 79   
            - Young Generation  
            - 吞吐量优先(这里的吞吐量 = CPU运行客户代码时间/CPU总时间)  
            - Key Parameters: -XX:MaxGCPauseMillis, -XX:GCTimeRatio, -XX:+UseAdaptiveSizePolicy    
            - exits in JDK 1.4, don't work with CMS    
            - Actually has PS MarkSweep collector as a Young Gen Collector to work with, PS MarkSweep collector is based on Serial Old  
        * Concurrent Mark Sweep(CMS)                                -- 81  
            - Tenured Generation  
            - 响应时间优先, 尽可能缩短垃圾收集时用户线程的停顿时间  
            - 最短回收停顿时间为目标  
            - 算法  
            1. 初始标记 -- STW  
                标记GC Roots 直接可及的  
            2. 并发标记  
                时间长, 并发, GC Roots Tracing  
            3. 重新标记 -- STW    
                修改并发标记期间变动的  
            4. 并发清除  
                时间长, 并发
            - 缺点  
            1. 影响吞吐量, 占用CPU资源  
            2. 产生浮动垃圾, 有可能Concurrent Mode Failure  
            "浮动垃圾": 在并发清除阶段, 用户新申请的内存  
            -XX:CMSInitiatingOccupancyFraction, default is 68%  
            Concurrent Mode Failure时会用Serial Old进行回收  
            3. Mark-Sweep算法, 有碎片  
            使用STW的compaction: -XX:+UseCMSCompactAtFullCollection, -XX:CMSFullGCsBeforeCompaction   
            ![jvm_gc_cms_img_1]  
        * Garbage First(G1)                                         -- 84/105  
            - Young & Tenured Generation
            - 面向服务器, 兼顾吞吐量与响应时间  
            - 整体看基于标记-整理算法, 局部看(两个Region间看)是复制算法, 无碎片  
            - 可预测的停顿, 指定在给定M毫秒时间内, 回收时间不超过N毫秒  
            - 划分各个区域Region, 仅保留新生代和年老代的概念
            - 优先级队列, 优先回收高优先级的  
                按回收空间大小和垃圾回收时间的经验值来定优先级   
                各个Region维护Remembered Set来避免做跨Region引用扫描时的全内存扫描(其他GC用了类似的技术), 一旦引用更新且跨Region, 用Write Barrier来更新该set    
            - 算法  
            1. 初始标记 -- STW  
                Similar to CMS
            2. 并发标记  
                并发, Similar to CMS 
            3. 最终标记 -- STW   
                多线程, Similar to CMS  
            4. 筛选回收(Live data Counting and Evacuation) -- STW   
                多线程, 由于Region较小, STW更有效   
            ![jvm_gc_g1_img_1]  

        * CMS VS G1 VS PS  
            1. 吞吐量: CMS 比 G1 有 3% ~ 10% 的优势  
            2. 响应时间: CMS更好一点, G1与CMS相当, 可以选择  

    6. 垃圾收集器参数总结                                           --  90/111  

Parameters                                          |Scope      |Usage
-------------------------------------------|-----------|---------------------------------------------------------------------------------------------
-XX:+UseConcMarSweepGC                 |--             |CMS + ParNew + Serial Old  
-XX:+UseParNewGC                             |--            |ParNew + Serial Old
-XX:+UseSerialGC                               |--             |`Client模式默认, Serial + Serial Old`  
-XX:+UseParallelGC                             |--             |`Server模式默认, Parallel Scanvenge + Serial Old(PS Mark Sweep)`  
-XX:+UseParallelOld                            |--             |Parallel Scanvenge + Par Old  
-XX:ParallelGCThreads                       |Young       |Restrict number of GC threads
-XX:+UseG1GC                                    |--             |--
-XX:MaxGCPauseMillis                        |PS GC       |Try to make GC Pause not exceed it
-XX:GCTimeRatio                                |PS GC      |=Non GC Time / GC Time, 0 < value < 100 
-XX:+UseAdaptiveSizePolicy              |PS GC       |No need to give other parameters, such as -Xmn, -XX:SurvivorRatio, -XX:PretenureSizeThreadhold, and etc  
-Xmn                                                  |Young       |Size of young generation  
-Xss                                                   |--             |Stack size  
-XX:PermSize, -XX:MaxPermSize      | Perm       |Perm区(方法区)大小  
-XX:MaxDirectMemorySize               |Direct Memory|指定Direct Memory大小, 没设置时值与-Xmx一样
-XX:SurvivorRatio                             |Young       |= Eden Size/(1 Survivor Size),default is 8
-XX:PretenureSizeThreadhold          |Young       |直接晋升到年老代的对象的大小  
-XX:MaxTenuringThreadhold            |Young       |晋升到年老代的对象的年龄, 即经历多少次Minor GC后晋升, 默认是15    
`-XX:+AlwaysTenure`                        |--             |去掉Survivor, 直接进入年老代. 等效于 -XX:MaxTenuringThreadhold = 0 && -XX:SurvivorRatio = 65536  
-XX:ParallelGCThreads                      |--             |并发内存回收的线程数  
-XX:HandlePromotionFailure             |Young       |--
-XX:CMSInitiatingOccupancyFraction|CMS       | memory percentage before CMS starts SerialOld GC  
-XX:CMSFullGCsBeforeCompaction    |CMS        |a compaction start after how many Full GCs, deafult is enabled
-XX:+UseCMSCompactAtFullCollection|CMS      |a compaction start after any Full GC, default is 0, means compaction every time  
-XX:+DisableExplicitGC                        |--          |GC doesn't response to System.gc() call
-XX:+HeapDumpOnOutOfMemoryError|--         |--  
-XX:+PrintAssembly                             |--          |与HSDIS一起, 打印汇编代码  
`-XX:+PrintGCApplicationStoppedTime` |-            |--
`-XX:+PrintReferenceGC`                       |--          |可以看到各个阶段GC的耗时
-XX:+PrintGCDateStamps                    |--          |--
-verbosegc                                           |--          |--
-Xloggc:{path}                                      |--          |--
-XX:+PrintGCDetails                            |--          |--
-XX:+PrintGCTimeStamps                    |--          |--  
-Xverify:none                                       |--          |禁止字节码验证的过程(关闭大部分验证, 以减少类加载时间)  
-Xint                                                    |--          |强制虚拟机运行于解释模式  
-Xcomp                                                |--           |优先用编译器, 编译器无法进行时用解释器  
-XX:+TieredCompilation                      |--           |开启分层编译后, 1.7默认开启, 1.6手工开启  
-XX:CompileThreshold                         |--          |方法调用计数器额阀值, Client模式1500, Server模式10000  
-XX:+UseCounterDecay                       |--          |方法调用计数器用到, 使用热度衰减, GC时进行衰减, 默认使用  
-XX:CounterHalfLifeTime                   |--          |方法调用计数器用到, 热度衰减的半衰期    
-XX:+PrintCompilation                         |--          |prints out a message when dynamic compilation runs

    7. GC 日志                                                -- 89  
```html
129.766: [GC [PSYoungGen: 11756344K->5242875K(36700160K)] 14071993K->8388334K(120586240K), 4.5868930 secs] [Times: user=24.95 sys=77.69, real=4.58 secs] 

134.353: [Full GC (System) [PSYoungGen: 5242875K->0K(36700160K)] [ParOldGen: 3145459K->6652526K(83886080K)] 8388334K->6652526K(120586240K) [PSPermGen: 41235K->41166K(82432K)], 13.7703680 secs] [Times: user=127.21 sys=5.89, real=13.77 secs]
```

        * `[Full GC (System)`:  GC triggered by System.gc()  
        * `[DefNew`: Default new generation, Serial收集器  
        * `[PSYoungGen`: Parallel Scanvenge收集器  
        * `[XXX: 11756344K->5242875K(36700160K)]`: 方括号里的数字, 表示区域XXX回收前已使用了11756344K, 回收后已使用5242875K, 圆括号内为该区域总容量36700160K  
        * `8388334K->6652526K(120586240K)`: 括号外的数字表示GC或Full GC前已使用的总容量8388334K, GC后已使用的总容量6652526K, 圆括号内为内存总容量120586240K  
        * `134.353`: 行首数字代表虚拟机已运行的时间(秒)  
        * `Times: user=127.21 sys=5.89, real=13.77 secs`:  
            含义同Linux的time命令  
            user: 用户态消耗的CPU时间  
            sys: 系统态消耗的CPU时间  
            real: Wall Clock Time, 墙钟时间, 包括CPU时间+等待时间  
            多线程的CPU时间(user+sys)会叠加, real 时间不会, 所以可以看到user + sys > real   

    8. GC log的一些示例以及对分配内存空间规则               -- 92/113  
        * 对象优先在Eden区分配  
        * 大对象直接分配在年老代(PretenureSizeThreadhold)      
        * 长期存活的对象进入年老代(MaxTenuringThreadhold)或者动态对象年龄判断(如果Survivor区相同年龄的对象超过Survivor区一半空间, 直接进入年老代)  
        * 空间分配担保(HandlePromotionFailure)    
            在Minor GC前, 比较新生代所有对象大小是否小于年老代最大连续空间?  
                是, Minor GC  
                否, 查看是否开启HandlePromotionFailure?   
                    若开启并且年老代最大连续空间大于历代晋升年老代对象平均大小, 则Minor GC  
                    否则, Full GC  
4. 虚拟机性能监控及故障处理工具                                       -- 101/122  

Command/Tools       |Usage
-----------------------|----------------------------------------------------------
jps                           |相当于专门看java的ps  
`jstat`                    |GC以及JIT Compiler相关信息收集  
jinfo                        |配置信息, 运行参数或properties的值等, 可以运行时修改它们  
jmap                        |生成heap dump, 查看`finalize队列`和heap信息  
jhat                         |启动http server用于分析heap dump  
jstack                      |thread dump
jconsole                   |--
VirtualVM                |--  

    1. HSDIS及-XX:+PrintAssembly                                    -- 111  
        打印汇编代码  
    2. jconsole                                                     -- 115  
    3. VirtualVM                                                    -- 122  
        大量插件支持:  
        * BTrace, 动态加入代码                                       -- 128  

5. 调优案例分析与实战                                                 -- 132  
    1. JBossCache分布式缓存的同步异常导致的内存溢出                     -- 135  
        JBossCache自身的问题, 减少缓存的写操作   
        12g/14s  
    2. Direct Memory的回收机制和溢出                                -- 137/158  
        逆向AJAX技术: 也称为Comet或Server Side Push  
        CometD 1.1.1 大量利用NIO操作Direct Memory  
        Direct Memory 不是在其快满了的时候回收, 而是在Full GC时"顺手"回收  
    3. 除了堆外其他需要注意OOM的内存区域列表                         -- 137/158  
        * 线程栈  
        * Direct Memory  
        * JNI代码  
            如果用JNI调用本地库代码, 本地库使用的内存不再堆中          
        * Socket缓存区          
        * 虚拟机和GC的额外开销       
    4. java调用shell创建新进程带来的性能问题                          -- 138  
        Runtime.getRuntime().exec()调用shell创建`新进程`, 频繁调用性能影响很大  
    5. 如何去掉Survivor区                                          --  140/161  
        -XX:+AlwaysTenure, 或者 ( -XX:MaxTenuringThreadhold = 0 && -XX:SurvivorRatio = 65536 )  
    6. Windows最小化时虚拟内存Swap带来的GC等待                       -- 141  
        -XX:+PrintReferenceGC, 可以看到各个阶段GC的耗时  
        -Dsun.awt.keepWorkingSetOnMinimize=true    
    7. 实战案例: Eclipse调优                                          -- 142  
        GC调优的思路:  
        * 选择合适的GC算法(及JAVA版本), 并调整参数    
            MaxTenuringThreadhold  
            PretenureSizeThreadhold  
            AlwaysTenure (或者 -XX:MaxTenuringThreadhold = 0 加上 -XX:SurvivorRatio = 65536)  
            Monitoring Tools: PrintGCApplicationStoppedTime, PrintReferenceGC  
        * 调整各个内存区域的大小, 比如足够大的新生代大小以减少Minor GC         
        * 直接令-Xms = -Xmx,  -XX:PermSize = -XX:MaxPermSize, 以减少单纯扩容带来的无用GC              
        * -XX:+DisableExplicitGC    
    
        每次发生GC前, 所有线程都要跑到一个Safepoint挂起, 等待GC, 并在GC结束后恢复, 这是额外的代价, 但执行native code的线程不会被GC挂起          --  154/175  


6. 类文件结构                                                      -- 162/183  
7. 虚拟机的类加载机制                                               -- 209/230  
    运行时的类加载,连接和初始化  
    1. 类的生命周期                                                 --  210/231  
        1. 加载
        2. 连接(Linking)  
            1. Verification  
            2. Preparation  
            3. Resolution(解析)  
        3. 初始化  
        4. 使用  
        5. 卸载  
        加载, 验证, 准备, 初始化和卸载这5个阶段顺序是确定的, 其它阶段顺序可变  
        比如解析可以在初始化以后, 为了支持动态绑定或晚期绑定  
    2. 触发类"初始化"(加载, 验证, 准备在其之前也开始)的场景                                            -- 210/231  
        或称类的主动引用, 其他为类的被动引用, 不触发类初始化  
        有且只有5中  
        1. new, 访问static字段(非常量)或方法  
        2. 反射调用
        3. 子类的父类优先被初始化
        4. 包含main()方法的类  
        5. JDK 1.7动态语言中, 相当于访问static字段或方法的MethodHandle  
        
        被动调用例子:  
        1. 静态字段被引用时, 仅定义该字段的类的初始化被触发, 其子类初始化不被触发                                        -- 212/233  
        2. 通过数组定义来引用类, 该类的初始化不会被触发                                     -- 212/233    
```java
    public static Class<?> forName(String name, boolean initialize,
                                   ClassLoader loader)
```
        If name denotes an array class, the component type of the array class is loaded but not initialized.      
        3. 静态字段在编译时进入常量池中, 在其被引用时, 其类的初始化不会被触发                                     -- 213/234  

    3. 接口初始化的特殊说明                                        -- 213/234  
        接口父类不必要初始化, 只有其使用时才初始化  
    4. Class Loading阶段虚拟机完成的3件事                          -- 214/235  
        1. 获取类的字节流  
        2. 建立代表类的方法区的数据结构  
        3. 在内存中创建java.lang.Class对象作为该数据结构的访问入口(Hotspot将该对象存在方法区)     
    5. 数组类的加载规则                                            -- 215/236  
        1. 对象数组, 递归加载其组件, 数组被标识在加载其组件的类加载器的类命名空间, 数组可见性与其组件相同    
        2. primative类型数组(如int[]), 数组被标识在引导类加载器的类命名空间, 数组可见性是public   
    6. Verification, 验证阶段                                     --  216/237  
        4个阶段, 先后为:  
        1. 文件格式验证
            针对二进制流  
        2. 元数据验证  
            它与以后步骤都是针对方法区的存储结构  
            基本的语义验证(PS: 或者说静态的语义验证, 离散的语义验证)  
            比如数据类型验证, 继承格验证  
        3. 字节码验证  
            最复杂的一步  
            基于数据流和控制流分析的语义验证  
        4. 符号引用验证  
            在Resolution(解析)阶段发生的时候进行验证    
            在把符号引用转化成直接引用之前  
            对类自身以外的信息进行的匹配性校验, 例如    
                1. 常量池引用  
                2. 字段及方法存在性及访问性   
        -Xverify:none, 关闭大部分验证, 以减少类加载时间  
    7. Preparing阶段                                              -- 219/240   
        为类变量(static)分配空间并赋予初始值, 这里使用的内存都在方法区  
        * public static int value = 123  
            这阶段的值为0, 在以后的类构造器<clinit>()方法中才被赋值123  
        * public static final int value = 123  
            这个阶段的值直接是123   
    8. Resolution(解析)阶段                                       -- 220/241  
        将存储在常量池内的符号引用替换成直接引用的过程  
        符号引用: 虚拟机规范统一规定的字面量  
        直接引用: 内存地址  
        对同一符号引用的多次解析, 除了invokedynamic(其他都是运行前解析,invokedynamic是运行时解析), 缓存第一次解析(错误状态也缓存)  
        解析动作对应于常量池中的7种:  
        1. CONSTANT_Class_info
        2. CONSTANT_Fieldref_info
        3. CONSTANT_Methodref_info
        4. CONSTANT_InterfaceMethodref_info
        5. CONSTANT_MethodType_info         -- 动态语言支持
        6. CONSTANT_MethodHandle_info       -- 动态语言支持
        7. CONSTANT_InvokeDynamic_info      -- 动态语言支持
    9. 初始化阶段                                                -- 225  
        即是执行类构造器`<clinit>()`方法的过程(实例对应的方法是`<init>()`)  
        `<clinit>()`方法的注意事项                               -- 225/246  
        1. 收集所有类变量赋值和static块合并而成, 按在源文件出现的顺序  
        2. static块只能访问它之前的静态变量, 对之后的静态变量只能赋值, 不能访问  
        3. 父类的`<clinit>()`保证被先调用, 但是不是由子类的`<clinit>()`调用  
        4. `<clinit>()`方法是同步的
        5. 接口无静态块, 它的`<clinit>()`于类基本类似, 其父类`<clinit>()`不需要被优先调用, 它的实现类不需要优先调用接口的`<clinit>()`      
    10. 类加载器                                                 -- 227  
        只用于类的加载阶段, 但作用超出这个阶段.  
        每个类加载器都有独立的类命名空间, 类本身与类加载器一起确定的类的唯一性  
        1. Parent Delegation Model                             -- 231/252  
        2. Thread Context ClassLoader                          -- 233/254  
        3. OSGi -- Java模块化的"标准"                           -- 234/255  
            <深入理解OSGi: Equinox的原理,应用与最佳实践>
        4. OSGi 简单原理示例                                      -- 280/301  
        
10. 早期(编译期)优化                                              -- 302/323  
    java相当多新生的语法特性, 都是靠编译器的语法糖来实现  
    虚拟机团队把大量的优化放在后期的JIT编译器上  

    1. javac的编译过程                                            -- 304/325  
        ![jvm_javac_process_img_1]  
        ![jvm_javac_process_img_2]  
        1. 解析(词法分析及语法分析)和填充符号表   
        2. 插入式注解处理器的注解处理过程  
        3. 分析与生成字节码的过程  
            1. 标注检查(attribute)
            2. 数据及控制流分析(flow)
            3. 解语法糖(desugar)
            4. 生成字节码(generate)
        
        JAVA 1.5提供注解支持, JAVA 1.6 提供插入式注解处理器API用于在编译期间对注解进行处理, 如果它对语法树做过任何修改, 编译器会回到解析和填充符号表阶段重新处理, 直到没有修改为止                                          -- 307  

        * 标注检查阶段  
            变量声明, 类型匹配等  
            常量折叠:  
            a = 1 + 2  直接变成 a = 3  
        * 数据及控制流分析  
            与类加载期间的分析目的一致, 校验范围有区别  
            final修饰局部变量在这时期处理, 因为局部变量不进入常量池, 编译后信息丢失  
        * 生成字节码  
            有不少代码添加和转换工作  
            字符串相加替换为StringBuffer或StringBuilder  
            实例构造器`<init>()`及类构造器`<clinit>()`的生成  
            实例构造器`<init>()`及类构造器`<clinit>()`的执行顺序:      -- 310  
            1. 父类构造器(<clinit>() 或 <init>())
            2. 变量赋值(类变量 或 实例变量)
            3. 语句块( static{} 或 {} )  
    2. java的语法糖  
        1. 泛型与类型擦除                                             -- 315  
            1.6及以上的编译器, 支持Signature属性, 它保存了参数化信息.   
            仅仅是对方法的Code属性中的字节码进行擦除, 实际上元数据中还保留有泛型信息, 可以通过反射获得参数化类型  
        2. 自动装箱/拆箱的陷阱                                       -- 316/337  
            包装类的"=="运算在不遇到算术运算的情况下不会自动拆箱  
            包装类的equals()方法不处理数据类型转换  
```java
    // based on JDK 1.7
    public static void main(String[] args) {
        Integer a = 1;
        Integer b = 2;
        Integer c = 3;
        Integer d = 3;
        Integer e = 321;
        Integer f = 321;
        Long g = 3l; 
        System.out.println(c==d);                   //true
        System.out.println(e==f);                   //false
        System.out.println(c==(a+b));               //true
        System.out.println(c.equals(a+b));          //true
        System.out.println(g==(a+b));               //true  自动拆箱
        System.out.println(g.equals(a+b));          //false equals()不处理数据类型的不同
    }
```

        3. 条件编译: 编译期可确定的不可及分支被删除                    -- 317
    3. 实战插入式注解处理器                                         -- 318/339   

11. 晚期(运行期)优化                                                 -- 329/350  
    1. Hotspot虚拟机才用解释器和编译器并存的构架, 原因                  -- 330  
        *  对热点代码即时编译为机器码来提高效率  
        *  即时编译器激进优化失败后逆优化(Deoptimization)到解释器执行  
        *  解释器节省资源, 启动快, 而即时编译器为了追求更高(长期)效率  
    2. Hotspot有两个即时编译器, C1(Client Compiler)和C2(Server Compiler)  
        默认运行于混合模式, 即解释器 + C1/C2    
        -Xint, 强制虚拟机运行于解释模式  
        -Xcomp, 优先用编译器, 编译器无法进行时用解释器  

    3. Tiered Compilation                                          -- 332/353  
        1. 第0层, 解释器, 并且无性能监控(Profiling), 可触发第1层编译      
        2. 第1层, C1, 简单可靠优化及必要的Profiling  
        3. 第2层(及以上), C2, 耗时并激进的优化及Profiling  
        开启分层编译后(-XX:+TieredCompilation, 1.7默认开启, 1.6手工开启), C1和C2编译器同时工作    
    4. 热点代码类型                                                 -- 332/353  
        1. 多次执行的方法
        2. 多次执行的循环体 
    5. 栈上替换OSR                                                  -- 332/353  
        有多次执行的循环体触发的编译, 即使栈上替换OSR  
    6. 热点探测的方法                                              -- 333/354  
        1. 基于采样  
            周期性采样各线程栈顶的方法  
            简单, 高效, 且容易获取方法间的调用关系  
            线程阻塞(栈顶一直是同一个被阻塞的方法)等因素带来的噪音  
        2. 基于计数器  
            维护方法或代码块计数  
            复杂, 但精准  
            Hotspot采用这种  
    7. Hotspot的编译器触发过程  
        Hotspot有两种计数器:                                          -- 333   
            方法调用计数器(Invocation Counter)  
            回边计数器(Back Edge Counter)  
        * 方法调用计数器  
![jvm_jit_invocation_counter_img_1]  
            -XX:CompileThreshold, Client模式1500, Server模式10000  
```java
            if ( 已经编译 ){
                调用编译后代码
            } else {
                counter + = 1;
                if ( Invocation_Counter + Back_Edge_Counter > threshold ){
                    调用JIT异步编译       // 编译代码将在下一次被调用
                }
                解释执行
            }
```
            默认情况下, 方法调用计数器统计的是一段时间执行频率, 不是绝对次数.   
            -XX:+UseCounterDecay, 使用热度衰减, `GC时进行衰减`    
            -XX:CounterHalfLifeTime, 半衰期  
        * 回边计数器                                                 -- 335  
![jvm_jit_back_edge_counter_img_1]  
            回边: 字节码中遇到控制流向后跳转的指令即是回边  
            回边计数器是为了触发ORS编译  
            -XX:BackEdgeThreshold  
            -XX:OnStackReplacePercentage  
            过程与方法调用计数器相似, 增加了在执行过程中就调整计数器值的逻辑   
    8. 编译过程                                                    -- 338/359  
        -XX:-BackgroundCompilation, 禁止后台编译, oops  
        * Client Compiler 编译过程  
![jvm_client_compiler_process_img_1]  
            1. 方法内联  
            2. 常量传播  
            3. 范围检查消除  
            4. 空值检查消除  
            5. 窥孔优化(Peephold Optimization)  
            6. etc  
        * Server Compiler 编译过程  
            1. Dead code elimination  
            2. 循环展开(Loop unrolling)  
            3. 循环表达式外提(Loop expression hoisting)  
            4. 基本块重排序  
            5. 消除公共子表达式(Common subexpression elimination)  
            6. 常量传播  
            7. 范围检查消除  
            8. 空值检查消除  
            9. 守护内联(Guarded inlining, 激进)  
            10. 分支频率预测(branch frequency predication, 激进)  
            11. etc  
    9. 检查及分析JIT编译结果示例(很多开关)                          -- 339/360  
    10. 编译优化技术一览表                                         -- 346  
    11. 编译优化技术示例                                           -- 348/369  
    12. 公共子表达式消除                                           -- 350  
        如果一个表达式之前计算过, 而且直到当前它的值不会变化, 则不再重新计算它的值, 直接使用之前的值    
    13. 数组边界检查消除                                           -- 351  
        去除边界条件判断并放入try-catch块中, 转而捕捉虚拟机定义的异常(切换到核态)  
        如果profiling得知极少越界, 则使用    
    14. 方法内联                                                  -- 352  
        不简单, 虚方法如何内联是问题, 是激进的优化  
        用CHA(Class Hierarchy Analysis)及内联缓存及"逃生门"-内联守护(Guarded Inlining)          
    15. 逃逸分析及相继优化                                         -- 355/376  
        就是分析对象的动态作用域,分为  
        1. 方法逃逸  
            作为调用参数传到其他方法  
        2. 线程逃逸  
            类变量或其他线程可以访问的实例变量  
        如果证明没有逃逸, 可以对变量做各种高效优化:    
        1. 栈上分配  
            Hotspot不支持  
        2. 同步消除(Synchronization elimination)  
        3. 标量替换  
            标量, 即primary type(int,long等) + reference type  
            不创建对象, 把对象成员直接换成标量置于栈上, 有可能会利用到CPU的高速寄存器  
        逃逸分析在1.6中出现, 由于耗时高而收益不稳定, 不一定使用  
        逃逸分析相关的JVM参数                                      -- 356  
12. Java内存模型与线程                                             -- 360  
    1. Java 内存模型                                               -- 362/383  
        并非直接映射操作系统的物理内存模型(C++), 以此消除平台差异  
        ![jvm_java_memory_model_img_1]  
        [线程, 工作内存] <-> [Store,Load等原子操作] <-> 主内存  
        8个原子操作(已过时):                                          -- 364  
        * lock  
        * unlock   
        * read  
            主内存 -> 工作内存, to load    
        * load  
            工作内存 -> 线程变量副本  
        * store  
            工作内存 -> 主内存  
        * write  
            主内存 -> 主内存变量, to write    
        * assign  
        * use  
        8个操作的规则:                                                -- 365  

    2. volatile防止指令重排在JAVA 1.5 被修复, 之前版本无法用volatile实现DCL --370  
        volatile变量, 赋值操作后会增加一个"lock addl $0*0 (%esp)", 相当于一个内存屏障(Memory Barrier或Memory fence), 使得本CPU cache的内容写入内存, 并无效化其他CPU或其他内核  
        虚拟机规定, 不被volatile修饰64位的long或double的读写不具备原子性, 但是多数虚拟机实现的原子性                                      -- 372  

    3. synchronized和final也能保证可见性                                -- 374  
    4. 先行发生原则                                                    -- 375  
        The rules for happens-before are:  
        1. Program order rule.     
            Each action in a thread happens-before every action in that thread that comes later in the program order.  
        2. Monitor lock rule.   
            An unlock on a monitor lock happens-before every subsequent lock on that same monitor lock.[3]  
        3. Volatile variable rule.   
            A write to a volatile field happens-before every subsequent read of that same field.[4]  
        4. Thread start rule.   
            A call to Thread.start on a thread happens-before every action in the started thread.  
        5. Thread termination rule.   
            Any action in a thread happens-before any other thread detects that thread has terminated, either by successfully return from Thread.join or by Thread.isAlive returning false.
        6. Interruption rule.   
            A thread calling interrupt on another thread happens-before the interrupted thread detects the interrupt (either by having InterruptedException throw, or invoking isInterrupted or interrupted).  
        7. Finalizer rule.   
            The end of a constructor for an object happens-before the start of the finalizer for that object.  
        8. Transitivity.   
            If A happens-before B, and B happens-before C, then A happens-before C.  
        [3] Locks and unlocks on explicit Lock objects have the same memory semantics as intrinsic locks.  
        [4] Reads and writes of atomic variables have the same memory semantics as volatile variables.   

    5. 线程的实现方式  
        1. 使用内核线程  
            轻量级进程(LWP, Light Weight Process), 内核线程的编程接口  
            用户态核态切换, 调度由操作系统完成  
        2. 用户线程  
            部分高性能数据库有用户线程实现, 但总的说, 应用这种模式的已经很少了  
            没有用户态与核态的切换, 调度用户实现  
        3. 混合模型  
            混合前两种  

13. 线程安全与锁优化                                                -- 385/406  
    1. non blocking synchronization的硬件指令支持, 原子的            -- 394/415  
        * Test and Set
        * Fetch and Increment
        * Swap
        * CAS, Compare and Swap
        * 加载链接/条件存储(Load-Linked/Store-Conditional)  
        JAVA 1.5 后使用CAS, 包括:
        * sun.misc.Unsafe  
            compareAndSwapInt(), compareAndSwapLong()等  
        * AtomicXX类, 如AtomicInteger等  
        CAS的"ABA"问题AtomicStampedReference                       -- 396/417  
    2. 锁优化                                                      -- 397/418  
        * 自适应自旋(Adaptive Spinning)                             -- 398/419  
            适合锁定时间短且冲突不激烈的情况, 用忙式等待代替锁    
            目的是减少锁的核态切换  
        * 锁消除(Lock Elimination)   
            通过逃逸分析技术, 消除无竞争的锁   
        * 锁粗化(Lock Coarsenning)    
        * 轻量级锁(Lightweight Locking)                             -- 400/421  
            目的是在无多线程竞争的前提下使用  
            基于一个认知, 多数情况锁没有竞争  
            好处是避免使用同步原语(意味着核态切换)  
            借助对象头实现, JAVA 1.6加入    
            Hotspot虚拟机的对象头(Object Header, 占32bit/64bit)组成:                                                   -- 400    
                1) Mark Word, 运行时数据, 如hashcode, GC分代年龄等  
                2) 指向方法区对象类型数据的指针  
                3) 如果是数组, 数组长度  
            用CAS操作替代锁  
                1) 在线程栈上建立Lock Record区域, 并在对象头里增加锁的状态信息  
                2) 未加锁时, 第一个线程来到, 用CAS标记对象头为占有, 并把对象头原信息存于自己的Lock Record里  
                3) 同一线程再次到来, 检查标记位及Lock Record记录, 并直接使用   
                4) 其他线程竞争, 则膨胀为重量级锁(普通锁)  
                5) 锁释放: 占有锁的线程用CAS清除对象头标记位并从Lock Record中恢复对象头原来信息      
            如果竞争激烈, 效率不及普通锁, 因为有额外的CAS和redirection的开销  
        * 偏向锁(Biased Locking)                                   -- 402  
            目的是在无竞争的情况下把整个同步都消除  
            ![jvm_lock_lightweight_biased_flow_img_1]  
            可以认为是轻量级锁之上的又一层优化  
                1) 未加锁时, 第一个线程到来, 用CAS标记对象头为占有, 并把偏向线程信息覆盖在对象头  
                2) 同一个线程再次到来, 检查标记位并直接使用  
                3) 其他线程竞争, 撤销偏向为普通锁(不再锁定但标记为偏向)或轻量级锁(已锁定)  
            再次加了一层的redirection, 跟轻量级锁一样的优点和问题  

Miscellaneous
---
```shell
main batch
jdk6.0
command="java -verbosegc -Xloggc:/var/tmp/gmarrslive_gc_${regionID_tmp}.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+UseParallelOldGC -Xms120G -Xmx120G -XX:MaxPermSize=256m -DSYS_LOC=${SYS_LOC_tmp} -Dbu=${bu_tmp} -Dregion=${regionID_tmp}  -DsegmentId=${segmentName_tmp} -Djava.security.auth.login.config=${propsDir_tmp}/krbLogin.conf -DtradeDate=${runDate_tmp} -cp ${CLASSPATH_tmp} com/ms/aml/application/batchfw/Application environment-${environment_tmp}.properties ${runDate_tmp}"
jdk7.0
command="java -verbosegc -Xloggc:/var/tmp/gmarrslive_gc_${regionID}.log -XX:+UseG1GC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps  -Xms120G -Xmx120G -XX:MaxPermSize=256m -DSYS_LOC=${SYS_LOC} -Dbu=${bu} -Dregion=${regionID}  -DsegmentId=${segmentName}  -DtradeDate=${runDate} -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$environment.properties ${runDate}"
 
security batch
jdk6
command="java -Xms40G -Xmx40G -Xmn4G -verbose:gc -XX:+DisableExplicitGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -DSYS_LOC=${SYS_LOC_tmp} -Dbu=${bu_tmp}  -DsegmentId=${segmentName_tmp} -DtradeDate=${runDate_tmp} -cp ${CLASSPATH_tmp} com/ms/aml/application/batchfw/Application environment-${environment_tmp}.security.properties ${runDate_tmp}"
jdk7
command="java -verbosegc -Xms100G -Xmx100G -Xmn4G -XX:+UseParallelOldGC -DSYS_LOC=$SYS_LOC -Dbu=${bu}  -DsegmentId=${segmentName} -DtradeDate=${runDate} -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$environment.security.properties ${runDate}"
 
FeedCache
jdk6
x86_64
command="java -Xms60G -Xmx60G -Xmn5G -verbose:gc -XX:+DisableExplicitGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingFeedIds=$4 -DloadingFeedTypes=$5 -Dcom.sun.management.jmxremote -DsegmentId=$2 -DloadingAppName=GMARRSLoadHistFeedData -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
else
command="java -Xms3G -Xmx3G -Xmn1G -verbose:gc -XX:+DisableExplicitGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingFeedIds=$4 -DloadingFeedTypes=$5 -Dcom.sun.management.jmxremote -DsegmentId=$2 -DloadingAppName=GMARRSLoadHistFeedData -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
 
jdk7
x86_64
command="java -Xms10G -Xmx90G -Xmn5G -verbose:gc -XX:+UseG1GC -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingFeedIds=$4 -DloadingFeedTypes=$5 -Dcom.sun.management.jmxremote -DsegmentId=$2 -DloadingAppName=GMARRSLoadHistFeedData -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
else
command="java -Xms3G -Xmx90G -Xmn1G -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingFeedIds=$4 -DloadingFeedTypes=$5 -Dcom.sun.management.jmxremote -DsegmentId=$2 -DloadingAppName=GMARRSLoadHistFeedData -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
 
JurCache
jdk6
x86_64
command="java -Xms60G -Xmx60G -Xmn5G -verbose:gc -XX:+DisableExplicitGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingJurIds=$4 -DloadingJurTypes=$5 -DloadingAppName=GMARRSLoadHistJurData -Dcom.sun.management.jmxremote -DsegmentId=$2 -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
else
command="java -Xms3G -Xmx3G -Xmn1G -verbose:gc -XX:+DisableExplicitGC -XX:+PrintGCDateStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingJurIds=$4 -DloadingJurTypes=$5 -DloadingAppName=GMARRSLoadHistJurData -Dcom.sun.management.jmxremote -DsegmentId=$2 -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
 
jdk7
x86_64
command="java -Xms10G -Xmx90G -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingJurIds=$4 -DloadingJurTypes=$5 -DloadingAppName=GMARRSLoadHistJurData -Dcom.sun.management.jmxremote -DsegmentId=$2 -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
else
command="java -Xms3G -Xmx90G -Xmn1G -verbose:gc -XX:+PrintGCTimeStamps -XX:+PrintGCDetails -Dbu=$1 -DloadingJurIds=$4 -DloadingJurTypes=$5 -DloadingAppName=GMARRSLoadHistJurData -Dcom.sun.management.jmxremote -DsegmentId=$2 -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$3-loading-historical-data.properties"
 
tkdoi
main
command="java -verbosegc -Xloggc:/var/tmp/gmarrslive_gc_${regionID}.log -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xms12G -Xmx40G -Xmn4G -DSYS_LOC=${SYS_LOC} -Dbu=${bu} -Dregion=${regionID}  -DsegmentId=${segmentName}  -DtradeDate=${runDate} -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$environment.properties ${runDate}"
sec
command="java -verbosegc -Xms12G -Xmx40G -Xmn4G -DSYS_LOC=$SYS_LOC -Dbu=${bu}  -DsegmentId=${segmentName} -DtradeDate=${runDate} -cp $CLASSPATH com/ms/aml/application/batchfw/Application environment-$environment.security.properties ${runDate}"
```

---
[jvm_java_timeline_img_1]:/resources/img/java/jvm_java_version_timeline_1.png "java version timeline"
[jvm_java_memory_allocation_img_1]:/resources/img/java/jvm_java_memory_allocation_1.png "java memory allocation"
[jvm_hotspot_1.6_gc_list_img_1]:/resources/img/java/jvm_hotspot_1.6_gc_list_1.png "Hotspot JVM 1.6 GC List"
[jvm_gc_g1_img_1]:/resources/img/java/jvm_gc_g1_1.png "G1 flow"
[jvm_gc_cms_img_1]:/resources/img/java/jvm_gc_cms_1.png "CMS flow"
[jvm_javac_process_img_1]:/resources/img/java/jvm_javac_process_1.png "JVM javac process"
[jvm_javac_process_img_2]:/resources/img/java/jvm_javac_process_2.png "JVM javac process"
[jvm_jit_invocation_counter_img_1]:/resources/img/java/jvm_jit_invocation_counter_1.png "jvm_jit_invocation_counter"
[jvm_jit_back_edge_counter_img_1]:/resources/img/java/jvm_jit_back_edge_counter_1.png "jvm_jit_back_edge_counter"
[jvm_client_compiler_process_img_1]:/resources/img/java/jvm_client_compiler_process_1.png "jvm_client_compiler_process_1"
[jvm_java_memory_model_img_1]:/resources/img/java/jvm_java_memory_model_1.png "jvm_java_memory_model_1"
[jvm_lock_lightweight_biased_flow_img_1]:/resources/img/java/jvm_lock_lightweight_biased_flow_1.png "jvm_lock_lightweight_biased_flow"
