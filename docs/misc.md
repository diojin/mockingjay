## Miscellaneous
---
* [Design Pattern](#design-pattern)
    - [Design Principles](#design-principles)
    - [MVC model](#mvc-model)
    - [JSP Design Pattern](#jsp-design-pattern)
    - [Singleton](#singleton)
* [Network](#network)
    - [Socket](#socket)
    - [Misc](#network-misc)
        + [IP address categories](#ip-address-categories)
* [Shell](#shell)
    - [Misc](#shell-misc)
        + [System Variables](#shell-system-variables)
* [Others](#others)
    - [Toolkits](#toolkits)
    - [MarkDown Language](#markdown-language)

## Design Pattern

### Design Principles
从设计原则到设计模式  
1. 针对接口编程，而不是针对实现编程
2. 优行使用类组合，而不是类继承
3. 变化点封装  
使用封装来创建对象之间的分界层，让设计者可以在分界层的一侧进行修改，而不会对另一侧产生不良的影响，从而实现层次间的松耦合
4. 使用重构得到模式－－设计模式的应用不宜先入为主  
一上来就使用设计模式是对设计模式的最大误用。没有一步到位的设计模式。敏捷软件开发实践提倡的“Refactoring to Patterns ”是目前普遍公认的最好的使用设计模式的方法

几条更具体的设计原则  
1. 单一职责原则（SRP）  
一个类应该仅有一个引起它变化的原因。
2. 接口隔离原则（ISP）  
不应该强迫客户程序依赖于它们不用的方法
3. 开放封闭原则（OCP）  
类模块应该是可扩展的，但是不可修改（对扩展开放，对更改封闭）
4. ListKov替换原则（LSP）  
子类必须能够替换它们的基类  
如果有两个具体类A和B之间的关系违反了里氏代换原则，可以在以下两种重构方案中选择一种：  
    1. 创建一个新的抽象类C,作为两个具体类的超类，将A和B共同的行为移动到C中，从而解决A和B行为不完全一致的问题。 
    2. 从B到A的继承关系改写为委派关系。
5. 依赖倒置原则（DIP）  
依赖倒转原则讲的是：要依赖于抽象，不要依赖于具体。  
高层模块不应该依赖于低层模块，二者都应该依赖于抽象。  
抽象不应该依赖于实现细节，实现细节应该依赖于抽象。  
5. 合成、聚合复用原则   
合成、聚合复用原则就是在一个新的对象里面使用一些已有的对象，使之成为新对象的一部份，新的对象通过向这些对象的委派达到复用已有功能的目的。这个原则有一个简短的描述：要尽量使用合成、聚合，尽量不要使用继承。  
如果两个类是“Has-a”关系那么应使用合成、聚合，如果是“Is-a”关系那么可使用继承。
6. 迪米特法则   
迪米特法则说的是一个对象应该对其它对象有尽可能少的了解。即只与你直接的朋友通信，不要跟陌生人说话。如果需要和陌生人通话，而你的朋友与陌生人是朋友，那么可以将你对陌生人的调用由你的朋友转发.  
迪米特法则（Law of Demeter, LoD）又叫最少知识原则（Least Knowledge Principle, LKP）, 迪米特法则可以简单说成：talk only to your immediate friends, 门面模式（Facade）和中介模式（Mediator），都是迪米特法则应用的例子

### MVC model
From P 14/14  - Design Patterns.Elements of Reusable Object-Oriented Software

The Model/View/Controller (MVC) triad of classes [KP88] is used to build user interfaces in Smalltalk-80. Looking at the design patterns inside MVC should help you see what we mean by the term "pattern."

MVC consists of three kinds of objects. The Model is the application object, the View is its screen presentation, and the Controller defines the way the user interface reacts to user input. Before MVC, user interface designs tended to lump these objects together. MVC decouples them to increase flexibility and reuse.

MVC decouples views and models by establishing a subscribe/notify protocol between them. A view must ensure that its appearance reflects the state of the model. Whenever the model's data changes, the model notifies views that depend on it. In response, each view gets an opportunity to update itself. This approach lets you attach multiple views to a model to provide different presentations. You can also create new views for a model without rewriting it.
This more general design is described by the **Observer** (page 326) design pattern.

Another feature of MVC is that views can be nested. For example, a control panel of buttons might be implemented as a complex view containing nested button views. The user interface for an object inspector can consist of nested views that may be reused in a debugger. MVC supports nested views with the CompositeView class, a subclass of View. CompositeView objects act just like View objects; a composite view can be used wherever a view can be used, but it also contains and manages nested views.
This more general design is described by the **Composite** (183) design pattern.

A view uses an instance of a Controller subclass to implement a particular response strategy; to implement a different strategy, simply replace the instance with a different kind of controller. It's even possible to change a view's controller at run-time to let the view change the way it responds to user input. For example, a view can be disabled so that it doesn't accept input simply by giving it a controller that ignores input events.
The View-Controller relationship is an example of the **Strategy** (349) design pattern.

MVC uses other design patterns, such as Factory Method (121) to specify the default controller class for a view and Decorator (196) to add scrolling to a view. But the main relationships in MVC are given by the Observer, Composite, and Strategy design patterns.

### JSP Design Pattern

JSP设计模式包括两个：  
1. Model1，JSP+JavaBean设计模式  
在这种模式中，JSP页面独自响应请求并将处理结果返回客户，所有的数据库操作通过JavaBean来实现。大量地使用这种模式，常会导致在JSP页面中嵌入大量的Java代码，当需要处理的商业逻辑非常复杂时，这种情况就会变得很糟糕。大量的Java代码使得JSP页面变得非常臃肿。前端的页面设计人员稍有不慎，就有可能破坏关系到商业逻辑的代码。
2. Model2，MVC设计模式.   
“MVC”模式即是：“Model-View-Controller”模式。在这种模式中，通过JSP技术来表现页面，通过Servlet技术来完成大量的事务处理工作，实现用户的商业逻辑。   
在这种模式中，Servlet用来处理请求的事务，充当了控制器（Controller即“C”）的角色，Servlet负责响应客户对业务逻辑的请求并根据用户的请求行为，决定将哪个JSP页面发送给客户。JSP页面处于表现层，也就是视图（View即“V”）的角色。JavaBean则负责数据的处理，也就是模型（Model即“M”）的角色。


### Singleton
```java
/**
 * 1, 懒汉写法, lazy initialization
 */
@NotThreadSafe
class Singleton1d0 {
    private static Singleton1d0 instance = null;
    private Singleton1d0(){}
    public static Singleton1d0 getInstance(){
        if ( null == instance){
            instance = new Singleton1d0();
        }
        return instance;
    }
}

/**
 * 2, 懒汉写法, lazy initialization
 * Double-Checked Locking
 * thread safe, performance good
 */
@ThreadSafe
class Singleton1d2 {
    // volatile is not mandatory, it is thread safe even without it
    // however, the chances to enter CS is reduced when using it
    private static volatile Singleton1d2 instance = null;
    private static final Object lock = new Object();
    private Singleton1d2(){}
    public static Singleton1d2 getInstance(){
        if ( null == instance ){
            synchronized (lock){
                if ( null == instance ){
                    instance = new Singleton1d2();
                }
            }
        }
        return instance;
    }
}

/**
 * 3, 饿汉写法
 */
@ThreadSafe
class Singleton2 {
    private static Singleton2 instance = new Singleton2();
    private Singleton2(){}
    public static Singleton2 getInstance(){
        return instance;
    }
}

/**
 * 4, 静态内部类，优点：加载时不会初始化静态变量INSTANCE，因为没有主动使用，达到Lazy loading
 * @author threepwood
 *
 */
@ThreadSafe
class Singleton3 {
    private static class SingletonHolder{
        // PS: final should not be necessary, but looks better
        public static final Singleton3 INSTANCE = new Singleton3();
    }
    private Singleton3(){
        
    }
    public static Singleton3 getInstance(){
        return SingletonHolder.INSTANCE;
    }
}
/**
 * 5, 枚举. 优点：不仅能避免多线程同步问题，而且还能防止反序列化重新创建新的对象
 */
@ThreadSafe
enum Singleton4{
    INSTANCE;
    public void doSometing(){
    }
}

```
## Network

### Socket

__Socket可工作于阻塞和非阻塞两种模式__  
先还是简单所列一下几中调用方式的常见解释：  
同步：函数没有执行完不返回，线程被挂起；  
阻塞：没有收完数据函数不返回，线程也被挂起；  
异步：函数立即返回，通过事件或是信号通知调用者；(状态变量或回调函数)  
非阻塞：函数立即返回，通过select通知调用者  

以套接字Socket为例，在阻塞模式下，利用TCP协议发送一个报文时，如果低层协议没有可用空间来存放用户数据，则应用进程将阻塞等待直到协议有可用的空间。而在非阻塞模式下，调用将直接返回而不需等待。在应用进程调用接收函数接收报文时，如果是在阻塞模式下，若没有到达的数据，则调用将一直阻塞直到有数据到达或出错；而在非阻塞模式下，将直接返回而不需等待。 

对于UDP协议而言，由于UDP没有发送缓存，因此所有UDP协议即使在阻塞模式下也不会发生阻塞。 

### Network Misc

#### IP address categories
现在的IP网络使用32位地址，以点分十进制表示，如172.16.0.0。  
地址格式为：  
IP地址=网络地址＋主机地址 或 IP地址=主机地址＋子网地址＋主机地址。 

最初设计互联网络时，为了便于寻址以及层次化构造网络，每个IP地址包括两个标识码（ID），即网络ID和主机ID。同一个物理网络上的所有主机都使用同一个网络ID，网络上的一个主机（包括网络上工作站，服务器和路由器等）有一个主机ID与其对应。  

IP地址根据网络ID的不同分为5种类型，A类地址、B类地址、C类地址、D类地址和E类地址.   
1. A类IP地址  
一个A类IP地址由1字节的网络地址和3字节主机地址组成，网络地址的最高位必须是“0”， 地址范围从1.0.0.0 到126.0.0.0。可用的A类网络有126个，每个网络能容纳1亿多个主机。  
默认网络掩码为：255.0.0.0；A类地址分配给规模特别大的网络使用。

2. B类IP地址  
一个B类IP地址由2个字节的网络地址和2个字节的主机地址组成，网络地址的最高位必须是“10”，地址范围从128.0.0.0到191.255.255.255。可用的B类网络有16382个，每个网络能容纳6万多个主机. B类地址分配给一般的中型网络。

3. C类IP地址  
一个C类IP地址由3字节的网络地址和1字节的主机地址组成，网络地址的最高位必须是“110”。范围从192.0.0.0到223.255.255.255。C类网络可达209万余个，每个网络能容纳254个主机。C类地址分配给小型网络，如一般的局域网和校园网，它可连接的主机数量是最少的，采用把所属的用户分为若干的网段进行管理。

4. D类地址用于多点广播(Multicast)  
D类IP地址第一个字节以“lll0”开始，它是一个专门保留的地址。它并不指向特定的网络，目前这一类地址被用在多点广播（Multicast）中。多点广播地址用来一次寻址一组计算机，它标识共享同一协议的一组计算机 

5. E类IP地址  
以“llll0”开始，为将来使用保留.   
全零（“0．0．0．0”）地址对应于当前主机。全“1”的IP地址（“255．255．255．255”）是当前子网的广播地址。   

在IP地址3种主要类型里，各保留了3个区域作为私有地址，其地址范围如下:   
* A类地址：10.0.0.0～10.255.255.255
* B类地址：172.16.0.0～172.31.255.255
* C类地址：192.168.0.0～192.168.255.255

## Shell
### Shell Misc
#### Shell System Variables

```shell
Variable|Usage
--------|----------------------------------------
$0      |当前脚本的文件名
$num    |num为从1开始的数字，$1是第一个参数，$2是第二个参数，${10}是第十个参数
$#      |传入脚本的参数的个数
$*      |所有的位置参数(`作为单个字符串`)  (以”参数1 参数2 …” 形式保存)
$@      |所有的位置参数(每个都作为`独立的字符串`)。(以”参数1” “参数2” … 形式保存)
$?      |当前shell进程中，上一个命令的返回值，如果上一个命令成功执行则$?的值为0，否则为其他非零值
$$      |当前shell进程的pid
$!      |后台运行的最后一个进程的pid(上一个命令的PID)
$-      |显示shell使用的当前选项
$_      |之前命令的最后一个参数
```

## Others
### Toolkits
* SourceTree  
git tools



### MarkDown Language
* How to jump to internal link  
```xml
[Back To Indexes](#indexes)   
[for comprehension](#for-comprehension)
```
* How to add newline in table  
embed entire HTML codes, or simply use `<br>`   
* Tow ways to use menu navigation
```html
* [Chapter 1. String](#chapter-1-string)
    - [字符串包含](#字符串包含)
        + [素数相乘][素数相乘]
## Chapter 1. String
### 字符串包含

---
[素数相乘]:https://github.com/julycoding/The-Art-Of-Programming-By-July/blob/master/ebook/zh/01.02.md/#解法三 "素数相乘"
```

---

