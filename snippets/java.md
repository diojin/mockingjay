## Java Snippets
---

* [Concurrent](#concurrent)
    - [Misc](#concurrent-misc)
        + [How to wait for child thread to end](#how-to-wait-for-child-thread-to-end)
* [Stream](#stream)
* [Function Style Programming](#function-style-programming)
* [Design Pattern](#design-pattern)
  - [Examples](#design-pattern-examples)
* [Miscellaneous](#miscellaneous) 
  - [Socket](#java-socket)
  - [EJB2](#ejb2)
  - [Examples](#misc-examples)


### Concurrent
#### Concurrent Misc
##### How to wait for child thread to end
1. ExecutorService  
```java
public class MainThread {
     static ExecutorService executorService = Executors.newFixedThreadPool(1);

     @SuppressWarnings(“rawtypes”)
     public static void main(String[] args) throws InterruptedException, ExecutionException {
          SubThread thread = new SubThread();
          Future future = executorService.submit(thread);
          executorService.shutdown();
          try {
            executorService.awaitTermination();
          } catch (Exception e) {
                   e.printStackTrace();
          }
          future.get();
     }
     public static class SubThread extends Thread{
          @Override
          public void run() {
              try {
                   sleep(5000L);
              } catch (InterruptedException e) {
                   e.printStackTrace();
              }
          }
     }     
}
```
2. CountDownLatch  
```java
public class MainThread {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
          int threads = 5;
          final CountDownLatch countDownLatch = new CountDownLatch(threads);
          for(int i=0;i<threads;i++){
              SubThread thread = new SubThread(2000*(i+1), countDownLatch);
              thread.start();
          }
          countDownLatch.await();
     }
     public static class SubThread extends Thread{
          private CountDownLatch countDownLatch;
          private long work;          
          public SubThread(long work, CountDownLatch countDownLatch) {
              this.countDownLatch = countDownLatch;
              this.work = work;
          }

          @Override
          public void run() {
              try{
                sleep(work);
              }finally{
                   countDownLatch.countDown();
              }
              
          }
     }
}
```

3. Thread#join  
```java
public class MainThread {
    public static void main(String[] args) {
         SubThread thread = new SubThread();
         thread.start();
         System.out.println(“now waiting sub thread done.”);
         try {
             thread.join();
         } catch (InterruptedException e) {
             e.printStackTrace();
         }
         System.out.println(“now all done.”);
    }
    public static class SubThread extends Thread{
         @Override
         public void run() {
             try {
                  sleep(5000L);
             } catch (InterruptedException e) {
                  e.printStackTrace();
             }
         }     
    }
}

```
4. CompletionService
5. Customized, such as an implementation of AbstractQueuedSynchronizer  

Stream
---

Streams differ from collections in several ways:

**No storage**. A stream is not a data structure that stores elements; instead, it conveys elements from a source such as a data structure, an array, a generator function, or an I/O channel, through a pipeline of computational operations.

__Functional in nature__. An operation on a stream produces a result, but does not modify its source. For example, filtering a Stream obtained from a collection produces a new Stream without the filtered elements, rather than removing elements from the source collection.

**Laziness-seeking**. Many stream operations, such as filtering, mapping, or duplicate removal, can be implemented lazily, exposing opportunities for optimization. For example, "find the first String with three consecutive vowels" need not examine all the input strings. `Stream operations are divided into intermediate (Stream-producing) operations and terminal (value- or side-effect-producing) operations. Intermediate operations are always lazy.`

**Possibly unbounded**. While collections have a finite size, streams need not. 

**Short-circuiting** operations such as limit(n) or findFirst() can allow computations on infinite streams to complete in finite time.

**Consumable**. The elements of a stream are only visited once during the life of a stream. Like an Iterator, a new stream must be generated to revisit the same elements of the source.

Function Style Programming
---
#### examples
1. case 1

```java
Set<Long> productIds = vendorItem2VendorItemSubscriptionDTOMap.values().stream().map(VendorItemSubscriptionDTO::getProductId).collect(Collectors.toSet());

Map<Long, ProductDto> productId2ProductDto = productList.stream().collect(toMap(ProductDto::getProductId, Function.identity()));

public class VendorItemSubscriptionDTO {
    private Long productId;

    public static Function<VendorItemSubscriptionDTO, Long> TO_PRODUCT_ID = VendorItemSubscriptionDTO::getProductId;
}
```

### Design Pattern
#### Design Pattern Examples

##### Example 1
>web应用，主要有两个部分，一个是帐户的管理，一个是客户购买商品。    
其中帐户的管理主要是：  
* 更改账号的状态，存到db 
* 存入log 
* 自动发送电子邮件给管理员，由管理员或者激活或者冻结 
* 如果一个账户已经被激活并且被分配了一个帐户的管理，那么给这个帐户管理发送电子邮件 
* 存入log  
客户购买部分：  
* 网上购物的日常流程（看，选，付款） 
* 发一封确认邮件包括产品信息给客户 
* 存入log  
问题来喽，上面两个主要的过程都需要多次使用两个操作:发邮件和存log  
那么，你选择怎样的设计模式（Design Pattern）呢？这个设计模式必须允许在多个独立的类中可以外推重复的片段（would allow extrapolating repeating sections of code in separate classes）。不但这样，这种设计模式还要支持适当的提取操作，比如市场调查模块，能够在每一个地方和市场有关的地方取得资料。（Support the appropriate level of abstraction to allow for additional handlers (ie. marketing modules) to be hooked into any business procedure. 
）  
实体化你的设计模式。  

我的想法, Oberserver,  Template  

PS:  
1. Strategy, 复用发邮件和存日志的代码
2. Decorator, 动态增加额外的操作,例如市场调查. 如果使用Template Method, 灵活性不大.
3. Observer, 账户状态的改变涉及到几个同时的操作, 可以使用Observer

##### Example 2

>用php写一个在线编辑器的类，这个类要求是在最后生成工具栏之前，无论何时用什么样的顺序都能加上新的功能。  
Requirements:  
* Panel elements may be added in any order at any time before rendering 
* The panel object class must be available globally (singleton)  

PS:  
1. Composite模式
2. Singleton 模式

##### Example 3

>假设是原始社会,有石头,2块石头互磨可以变成石刀,石刀可以去砍木头,木头被砍成木材,木材可以组成椅子,请你用oo的思想把这些事物和他们之间的关系表达出来,但是要考虑到以后可能我会增加以下几点:    
1. 有可能我还想让石刀去砍椅子,把椅子砍成木材, 
2. 可能我还想让石头增加关系,例如互相砸,互相摔,而不只是磨,也可以变成石刀, 
3. 也许我又要多添一百种不同的事物,再多添120种不同的关系...  
也就是说我的要求可能是不断变化的,所以你要怎么样设计这个oo的模型,可以让我在实行1,2,3条的时候只做最小的修改....

这里也许应该用Bridage模式， 把物体和行为分别抽象出来  

PS:  
for 1, 3 使用Mediator模式
for 2, 使用bridge或Strategy模式

##### Example 4
>金额转换，阿拉伯数字的金额转换成中国传统的形式如：  
（￥1011）－>（一千零一拾一元整）输出。

建议看一下李建忠讲的＜C＃面向对象设计模式纵横谈＞ 第19讲，Chain Of Responsibility 职责链模式(行为型模式)

##### Example 5
> 如何用图例给出windows下的文件目录的设计模式    

Composite

##### Unreolved Examples

>Design a remote control program a on a Pocket PC device(which is a PDA based on Microsoft Windows CE.Net),and support touch screen,GUI programming,and infrared port to communicate with the TVs).The functions are almost the same with the common TV remote(such as changing channel,volume,TV/AV change,ON/OFF and anything you think which should be on a TV remote).The additional functions are the undo,redo command.   
Based on MVC pattern,give an Object-Oriented Design using UML diagrams and written text (plesase be in details)for the above requirements,.Explicitly all design patterns used and justify your use of them.No code required.

PS: Observer, Command

>There is a coffee shop to server HouseBlend and Espresso coffee.Each coffee can be served with the following condiments:Milk,Mocha.Using Decorator pattern to construct the coffee shop program to compute every beverage’s cost with its description.   
Class beverage{   
String decription;   
String getDescription(){return description;}   
Double cost();   
}   
Draw the pattern class diagram,and full code(class 
CondimentDecorator,HouseBlend,Espresso,Milk,Mocha,StarBuzzCoffee and other classes required) to construct the program including a test drive(StarBuzzCoffee class). 

>In object-oriented programming one is advised to avoid case(and if )statements.Select one design pattern that helps avoid case statements and explain how it helps.

PS: State, Strategy

>Factory Method and Abstract Factory design patterns are quite similar.How are they similar and how are they different?

>JVM相当于那种设计模式



### Miscellaneous
#### Java Socket
##### example 1
```java
package test;
import java.net.*;
import java.io.*; 

public class Server{
  private ServerSocket ss;
  private Socket socket;
  private BufferedReader in;
  private PrintWriter out;
 
 public Server() {
  try {
   ss=new ServerSocket(10000);
   while(true) {
    socket = ss.accept();
    String RemoteIP = socket.getInetAddress().getHostAddress();
    String RemotePort = ":"+socket.getLocalPort();
    System.out.println("A client come in!IP:"+RemoteIP+RemotePort);
    in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    String line = in.readLine();
    System.out.println("Cleint send is :" + line);
    out = new PrintWriter(socket.getOutputStream(),true);
    out.println("Your Message Received!");
    out.close();
    in.close();
    socket.close();
   }
  }catch (IOException e) {
   out.println("wrong");
  }
 }

 public static void main(String[] args) {
  new Server();
 }
}
```

```java
package test;
import java.io.*;
import java.net.*; 

public class Client {
 Socket socket;
 BufferedReader in;
 PrintWriter out;
 public Client() {
  try {
   System.out.println("Try to Connect to 127.0.0.1:10000");
   socket = new Socket("127.0.0.1",10000);
   System.out.println("The Server Connected!");
   System.out.println("Please enter some Character:");
   BufferedReader line = new BufferedReader(new InputStreamReader(System.in));
   out = new PrintWriter(socket.getOutputStream(),true);
   out.println(line.readLine());
   in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
   System.out.println(in.readLine());
   out.close();
   in.close();
   socket.close();
  }catch(IOException e) {
   out.println("Wrong");
  }
 }

 public static void main(String[] args) {
  new Client();
 }
}

```

#### EJB2

```java

// Remote Interface 接口的代码：

package Beans;
import javax.ejb.EJBObject;
import java.rmi.RemoteException;
public interface Add extends EJBObject {
  //some method declare 
}

// Home Interface 接口的代码：



package Beans;
import java.rmi.RemoteException;
import jaax.ejb.CreateException;
import javax.ejb.EJBHome;
public interface AddHome extends EJBHome {
  //some method declare
}

// EJB类的代码：

package Beans;
import java.rmi.RemoteException;
import javax.ejb.SessionBean;
import javx.ejb.SessionContext;
public class AddBean Implements SessionBean
{
  //some method declare
}
```


#### Misc Examples
