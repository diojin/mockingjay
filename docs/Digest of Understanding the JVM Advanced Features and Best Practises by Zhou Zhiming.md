#               深入理解Java虚拟机--JVM高级特性与最佳实践
#                Understanding the JVM Advanced Features and Best Practises  
##                                      周志明
---

## Indexes

1. 走进Java                                                            --  5/26

    ![jvm_java_timeline_img_1]  

Java Version | Code Name        |Time   |Features
-------------|------------------|-------|--------------------------------------
Java 1.0     | --               |1995   |--
JDK 1.0      | --               |1996   |--
JDK 1.1      | --               |1997   |RMI, JDBC         
JDK 1.2      | Playground       |1998   |EJB
JDK 1.3      | Kestrel(美洲红隼)|2000   |2000年以后基本每2年一个版本  
JDK 1.4      | Merlin(灰背隼)    |2002   |成熟版本, 正则, NIO, 1.4.2 Mantis 螳螂
JDK 1.5      | Tiger            |2004   |语法易用性的改进(自动装箱拆箱, 泛型, 动态注释,for each), JMM Java内存模型, concurrent 包  
JAVA 6       | Mustang(野马)    |2006    |对虚拟机做了很大的改进, 包括锁与同步, 垃圾回收, 类加载等, 动态语言支持(通过内置Mozilla Javascript Rhino引擎)  
OpenJDK      | --               |2006/11 |2006年11月13, Java开源, 随后建立OpenJDK
JAVA 7       | Dolphin          |2009/2011|G1收集器, 加强对非Java语言调用, 升级类加载框架, Jigsaw??(语言级模块化的支持)
JAVA 8       | --               |--      | Lambda, Coin(语言细节进化)??

2. 自动内存管理机制                                                  -- 24/45  
![jvm_java_memory_allocation_img_1]  
    
    1. 64位虚拟机, 由于指针膨胀和数据类型的对白补齐等原因, 性能于32位虚拟机有大概15%的差距                                   -- 13/34    
    
    2. 栈(Stack)分为Java虚拟机栈和本地方法栈, 
    都会抛出OutOfMemoryError和StackOverflowError  
    
    3. 随着JIT编译器以及逃逸分析技术的逐渐成熟, 栈上分配,标量替换等优化技术使得所有Java Object都分配于堆(Heap)上变得不绝对  
    
    4. TLAB, Thread Local Allocation Buffer, 线程私有的分配缓存区
    
    5. 直接内存(Direct Memory)                                      -- 29  
    NIO 可以使用Native函数分配堆外内存, 然后使用存储于堆中的DirectByteBuffer对象引用该内存, 进而操作它.   
    可能产生OutOfMemoryError  

    6. HotSpot虚拟机使用直接指针方式进行对象访问(非指针句柄方式)   
    
    7. 栈上的异常情况                                                -- 35  
        作者实测结果, 好像不太准     
        1. 单线程  
            无论是递归调用层数太深, 还是分配大量的栈上变量, 都抛StackOverflowError
        2. 多线程  
            无限创建线程, 抛OutOfMemoryError  
        虚拟机规定,   
        1. StackOverflowError, 栈深度大于虚拟机允许的最大深度  
        2. OutOfMemoryError, 扩展栈上无足够的内存空间  

        -Xss: 栈内存大小  
        -XX:PermSize 和 -XX:MaxPermSize, Perm区(方法区)大小
    8. Direct Memory 内存分配                                       -- 41  
        Unsafe.getUnsafe() 方法只有在引导类加载器才返回非空实例, 所以用反射调用  
        DirectByteBuffer 发生OutOfMemoryError时并非直接分配内存, 而是计算会溢出就抛异常  
        -XX:MaxDirectMemorySize, 指定Direct Memory大小, 没设置时与-Xmx一样    
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
    1. 可作为GC Root的对象                                             -- 46/67  
        * 虚拟机栈及本地方法栈引用的对象  
        * 常量引用的对象  
        * 静态变量(方法区中类的静态属性)引用的对象  
    2. 引用类型  
        * 

        1. OopMap 及 Safepoint                                -- 72/93 ~ 73/94  
        2. SafeRegion                                        -- 74/95  
3.2 java引用对象的类型                                     -- 65/86
3.3 finalize queue                                          --  66/87
3.4 回收方法区的类信息, 条件及应用场景                  --  68/89  69/90
3.5 HotSpot垃圾收集器关系图                             --  75/96
3.6 CMS GC                                                  -- 81/102
3.7 G1 GC                                                   -- 84/105
3.8 GC log 的一些简单语义                                  -- 89/110
3.9 垃圾收集器参数总结                                       --  90/111
3.10 GC log的一些示例以及对分配内存空间规则         -- 92/113

5.1 Direct Memory的回收机制和溢出                       -- 137/158
5.2 除了堆外其他需要注意OOM的内存区域列表                -- 137/158
5.3 Runtime.getRuntime().exec()的性能问题                --  138/159
5.4 如何去掉Survivor区                                       --  140/161
5.5 -XX:+PrintGCApplicationStoppedTime   -XX:+PrintReferenceGC                      -- 141/162
5.6 -Dsun.awt.keepWorkingSetOnMinimize=true         -- 142/163
5.7 执行native code的线程不会被GC挂起                 --  154/175

第三部分 虚拟机执行子系统
7.1 类的生命周期                                              --  210/231
7.2 触发类初始化的场景                                       --  210/231
7.3 静态字段被引用时, 仅定义该字段的类的初始化被触发, 其子类初始化不被触发           --  212/233
7.4 通过数组定义来引用类, 该类的初始化不会被触发                                         -- 212/233  
    public static Class<?> forName(String name, boolean initialize,
                                   ClassLoader loader)
    If name denotes an array class, the component type of the array class is loaded but not initialized.                           
                                   
7.5 静态字段在编译时进入常量池中, 在其被引用时, 其类的初始化不会被触发                 -- 213/234
7.6 接口初始化的特殊说明                                  -- 213/234
7.7 Loading阶段虚拟机完成的3件事                          -- 214/235  +   215/236(关于Class对象的存储位置)
7.8 代表类的二进制字节流的来源及应用                        -- 214/235
7.9 数组类的创建规则                                        -- 215/236
7.10 Verification的验证阶段                                  --  216/237 
7.11 Preparing阶段                                            -- 219/240
7.12 <clinit>方法的注意事项                                    --  225/246
7.13 JVM在static initialization时锁的机制                 --  226/247
7.14 类加载器的唯一性                                       --  228/249
7.15 3种系统类加载器                                       -- 230/251
7.16 Parent Delegation Model                                --  231/252
7.17 Thread Context ClassLoader                         --  233/254
7.18 OSGi -- Java模块化的"标准"                           -- 234/255
<深入理解OSGi: Equinox的原理,应用与最佳实践>
7.19 OSGi 简单原理示例                                        --  280/301

第四部分, 程序编译与代码优化
10.1 javac的编译过程                                     --  304/325 ~ 305/326
10.2 数据及控制流检查在编译期和类加载器不同, 附示例   --  309/330
10.3 泛型对重载的挑战,示例                                    --  313/334
10.4 可以通过反射获得参数化类型                          --  315/336
10.5 自动装箱/拆箱的陷阱                                 --  316/337
        输出: true false true true true false
10.6 插入式注解处理器简介                                 --  318/339 

11.1 Tiered Compilation                                     --  332/353
11.2 热点代码类型与栈上替换OSR                         --  332/353 ~ 333/354
11.3 热点探测的方法                                            --  333/354                                     
11.4 热度衰减 -XX:+UseCounterDecay                      --  335/356
11.5 编译过程                                               --  338/359 ~ 339/360
11.6 编译优化技术示例                                       --  350/371
11.6 逃逸分析及相继优化                                  --  355/376

第五部分 第12,13章 高效并发                               --  359/380
12.1 java 线程状态                                          --  383/404     339/360
13.1 线程安全的"安全程度"                                    --  386/407
13.2 non blocking synchronization的硬件指令支持            -- 394/415
13.3 Unsafe.getUnsafe()及其对类加载器的限制           -- 394/415
13.4 锁优化                                                    -- 397/418
13.5 Mark Word及轻量级锁/偏向锁                         --  400/421


---
[jvm_java_timeline_img_1]:/resources/img/java/jvm_java_timeline_img_1.png "java version timeline"
[jvm_java_memory_allocation_img_1]:/resources/img/java/jvm_java_memory_allocation_1.png "java memory allocation"
