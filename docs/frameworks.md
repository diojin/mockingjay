## Frameworks

* [Spring](#spring)
    - [General](#spring-general)
        + [Spring Framework Runtime](#spring-framework-runtime)
        + [Bean Lifecycle](#bean-lifecycle)
    - [Annotation](#spring-annotation)
        + [@ComponentScan](#componentscan)
    - [Aspect](#spring-aspect)
    - [Transaction](#spring-transaction)    
    - [Misc](#spring-misc)
* [Miscellaneous](#miscellaneous)


### Spring
#### Spring General
##### Spring Framework Runtime
![spring-framework-1]

__Core Container__  
The Core Container consists of the spring-core, spring-beans, spring-context, springcontext-support, and spring-expression (Spring Expression Language) modules.

The spring-core and spring-beans modules provide the fundamental parts of the framework,including the IoC and Dependency Injection features. The __BeanFactory__ is a sophisticated implementation of the factory pattern. It removes the need for programmatic singletons and allows you to decouple the configuration and specification of dependencies from your actual program logic.

The Context (spring-context) module builds on the solid base provided by the Core and Beans modules: it is a means to access objects in a framework-style manner that is **similar to a JNDI registry**. The Context module **inherits its features from the Beans module** and adds support for **internationalization** (using, for example, resource bundles), **event propagation**, **resource loading**, and **the transparent creation of contexts** by, for example, a Servlet container. The Context module **also supports Java EE features such as EJB, JMX, and basic remoting**. The **ApplicationContext** interface is the focal point of the Context module. **spring-context-support**provides support for `integrating common third-party libraries` into a Spring application context for caching (EhCache, Guava, JCache), mailing (JavaMail), scheduling (CommonJ, Quartz) and template engines (FreeMarker, JasperReports,Velocity).

The **spring-expression** module provides a powerful Expression Language for `querying and manipulating an object graph at runtime`. It is an extension of the unified expression language (unified EL) as specified in the JSP 2.1 specification. The language supports setting and getting property values, property assignment, `method invocation`, accessing the content of arrays, collections and indexers,logical and arithmetic operators, named variables, and retrieval of objects by name from Spring’s IoC container. It also supports list projection and selection as well as common list aggregations.

**AOP and Instrumentation**  
The **spring-aop** module provides an AOP Alliance-compliant aspect-oriented programming implementation allowing you to define, for example, method interceptors and pointcuts to cleanly decouple code that implements functionality that should be separated. Using source-level metadata functionality, you can also incorporate behavioral information into your code, in a manner similar to that of .NET attributes.

The separate spring-aspects module provides integration with AspectJ.

The **spring-instrument** module provides class instrumentation support and classloader implementations to be used in certain application servers. The spring-instrument-tomcat module contains Spring’s instrumentation agent for Tomcat.

**Messaging**  
Spring Framework 4 includes a spring-messaging module with key abstractions from the Spring Integration project such as Message, MessageChannel, MessageHandler, and others to serve as a foundation for messaging-based applications. The module also includes a set of annotations for mapping messages to methods, `similar to the Spring MVC annotation` based programming model.

**Data Access/Integration**  
The Data Access/Integration layer consists of the JDBC, ORM, OXM, JMS, and Transaction modules.
The spring-jdbc module provides a JDBC-abstraction layer that removes the need to do tedious JDBC coding and parsing of database-vendor specific error codes.

The spring-tx module supports programmatic and declarative transaction management for classes that implement special interfaces and for all your POJOs (Plain Old Java Objects).

The spring-orm module provides integration layers for popular object-relational mapping APIs,
including JPA, JDO, and Hibernate. Using the spring-orm module you can use all of these O/Rmapping frameworks in combination with all of the other features Spring offers, such as the simple declarative transaction management feature mentioned previously.

The spring-oxm module provides an abstraction layer that supports **Object/XML mapping** implementations such as JAXB, Castor, XMLBeans, JiBX and XStream.

The spring-jms module (Java Messaging Service) contains features for producing and consuming messages. Since Spring Framework 4.1, it provides integration with the spring-messaging module.

**Web**
The Web layer consists of the spring-web, **spring-webmvc**, spring-websocket, and springwebmvc-portlet modules.

The spring-web module provides basic web-oriented integration features such as multipart file upload functionality and the initialization of the IoC container using Servlet listeners and a web-oriented application context. It also contains an HTTP client and the web-related parts of Spring’s remoting support.

The spring-webmvc module (also known as the Web-Servlet module) contains **Spring’s modelview-controller (MVC)** and **REST Web Services implementation** for web applications. Spring’s MVC framework provides a clean separation between domain model code and web forms and integrates with all of the other features of the Spring Framework.

The spring-webmvc-portlet module (also known as the Web-Portlet module) provides the MVC implementation to be used in a Portlet environment and mirrors the functionality of the spring-webmvc module.

Test
The spring-test module supports the unit testing and integration testing of Spring components with JUnit or TestNG. It provides consistent loading of Spring ApplicationContexts and caching of those contexts. It also provides mock objects that you can use to test your code in isolation.

##### Bean Lifecycle


![spring_bean_lifecycle_1]

```java
public abstract interface BeanPostProcessor{
    public abstract java.lang.Object postProcessBeforeInitialization(Object arg0, String arg1) throws BeansException;

    public abstract java.lang.Object postProcessAfterInitialization(Object arg0, String arg1) throws BeansException;
}
```

If there are annotations **@PostConstruct** and **@PreDestroy**, InitializingBean and init-method, the execution order is 
@PostConstruct -> InitializingBean.afterPropertiesSet() -> init-method

The similar apply to destroy processes, 
@PreDestroy -> DispsableBean.destroy() -> destroy-method()

#### Spring Annotation

注解实现Bean配置主要用来进行如依赖注入、生命周期回调方法定义等，不能消除XML文件中的Bean元数据定义，且`基于XML配置中的依赖注入的数据将覆盖基于注解配置中的依赖注入的数据`

##### @ComponentScan

component-scan

#### Spring Aspect

**Aspect(切面)**  
An aspect is the cross-cutting functionality you are implementing. It is the aspect, or area, of your application you are modularizing. The most common (albeit simple) example of an aspect is logging.

在Spring AOP中，切面可以使用通用类（基于模式的风格） 或者在普通类中以 @Aspect 注解（@AspectJ风格）来实现。 

**Joinpoint(连接点)**  
A joinpoint is a point in the execution of the application where an aspect can be plugged in. This point could be a method being called, an exception being
thrown, or even a field being modified. These are the points where your aspect’s code can be inserted into the normal flow of your application to add new behavior.

- 前置通知（Before advice）： 在某连接点（join point）之前执行的通知，`但这个通知不能阻止连接点前的执行（除非它抛出一个异常）`
- 返回后通知（After returning advice）： 在某连接点（join point）正常完成后执行的通知：例如，一个方法没有抛出任何异常，正常返回。
- 抛出异常后通知（After throwing advice）： 在方法抛出异常退出时执行的通知。
- 后通知（After (finally) advice）： 当某连接点退出的时候执行的通知（不论是正常返回还是异常退出）。
- 环绕通知（Around Advice）： 包围一个连接点（join point）的通知，如方法调用。这是最强大的一种通知类型。 环绕通知可以在方法调用前后完成自定义的行为。`它也会选择是否继续执行连接点或直接返回它们自己的返回值或抛出异常来结束执行`. 环绕通知是最常用的一种通知类型。大部分基于拦截的AOP框架，例如Nanning和JBoss4，都只提供环绕通知。

**Advice(通知)**  
Advice is the actual implementation of our aspect. It is advising your application of new behavior. In our logging example, the logging advice would contain the code that implements the actual logging, such as writing to a log file. Advice is inserted into our application at joinpoints.

许多AOP框架，包括Spring，都是以拦截器做通知模型， 并维护一个以连接点为中心的拦截器链。(MethodInterceptor)

**Pointcut(切入点)**  
A pointcut defines at what joinpoints advice should be applied. Advice can be
applied at any joinpoint supported by the AOP framework. Of course, you don’t
want to apply all of your aspects at all of the possible joinpoints. Pointcuts allow you to specify where you want your advice to be applied. 

Often you specify these pointcuts using explicit class and method names or through regular expressions that define matching class and method name patterns. Some AOP frameworks allow you to create dynamic pointcuts that determine whether to apply advice based on runtime decisions, such as the value of method parameters.

Spring缺省使用AspectJ切入点语法

**Advisor**  
an advisor is a construct that **combines a pointcut and advice**

**Introduction**  
An introduction allows you to add new methods or attributes to existing classes
(kind of mind-blowing, huh?). For example, you could create an Auditable advice
class that keeps the state of when an object was last modified. This could be as simple as having one method, setLastModified(Date), and an instance variable
to hold this state. This can then be introduced to existing classes without having to change them, giving them new behavior and state.

也被称为内部类型声明（inter-type declaration）

**Target**  
A target is the class that is being advised. This can be either a class you write or a third-party class to which you want to add custom behavior. 

**Proxy**  
A proxy is the object created after applying advice to the target object. As far as the client objects are concerned, the target object (pre-AOP) and the proxy object (post-AOP) are the same—as it should be. That is, the rest of your application will not have to change to support the proxy class.

在Spring中，AOP代理可以是JDK动态代理或者CGLIB代理。 注意：Spring 2.0最新引入的基于模式（schema-based）风格和@AspectJ注解风格的切面声明，对于使用这些风格的用户来说，代理的创建是透明的。

**Weaving**  
Weaving is the process of applying aspects to a target object to create a new, proxied object. The aspects are woven into the target object at the specified joinpoints.
The weaving can take place at several points in the target class’s lifetime:
* **Compile time**—Aspects are woven in when the target class is compiled. This
requires a special compiler.
* **Classload time**—Aspects are woven in when the target class is loaded into
the JVM. This requires a special ClassLoader that enhances that target
class’s bytecode before the class is introduced into the application.
* **Runtime**—Aspects are woven in sometime during the execution of the
application. Typically, an AOP container will dynamically generate a proxy
class that will delegate to the target class while weaving in the aspects.

Spring和其他纯Java AOP框架一样，在运行时完成织入。

#### Spring Transaction
Spring提供的事务管理可以分为两类：编程式的和声明式的

**编程式**  

```java
TransactionDefinition //事务属性定义 
TranscationStatus //代表了当前的事务，可以提交，回滚。
PlatformTransactionManager //这个是spring提供的用于管理事务的基础接口，其下有一个实现的抽象类AbstractPlatformTransactionManager,我们使用的事务管理类例如DataSourceTransactionManager等都是这个类的子类

TransactionDefinition td = new TransactionDefinition(); 
TransactionStatus ts = transactionManager.getTransaction(td); 
try { 
    //do sth 
    transactionManager.commit(ts); 
} 
catch(Exception e){
    transactionManager.rollback(ts);
} 

// or else
transactionTemplate.execute(new TransactionCallback(){ 
    pulic Object doInTransaction(TransactionStatus ts) {
        //do sth
    } 
})
```

**声明式**  
使用`TransactionProxyFactoryBean`

PROPAGATION_REQUIRED–支持当前事务，如果当前没有事务，就新建一个事务。这是最常见的选择
PROPAGATION_SUPPORTS–支持当前事务，如果当前没有事务，就以非事务方式执行。 
PROPAGATION_MANDATORY–支持当前事务，如果当前没有事务，就抛出异常。 
PROPAGATION_REQUIRES_NEW–新建事务，如果当前存在事务，把当前事务挂起。 
PROPAGATION_NOT_SUPPORTED–以非事务方式执行操作，如果当前存在事务，就把当前事务挂起。 
PROPAGATION_NEVER–以非事务方式执行，如果当前存在事务，则抛出异常。 
PROPAGATION_NESTED–如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则进行与PROPAGATION_REQUIRED类似的操作。

前六个策略类似于EJB CMT，第七个（PROPAGATION_NESTED）是Spring所提供的一个特殊变量。它要求事务管理器或者使用JDBC 3.0 Savepoint API提供嵌套事务行为（如Spring的DataSourceTransactionManager）

#### Spring Misc


### Miscellaneous

---
[spring-framework-1]:/resources/img/java/spring-framework-runtime.png "Overview of the Spring Framework(from Spring 4.2.6)"
[spring_bean_lifecycle_1]:/resources/img/java/spring_bean_lifecycle_1.png "spring bean lifecycle in bean factory"
[spring_bean_lifecycle_2]:/resources/img/java/spring_bean_lifecycle_2.png "spring bean lifecycle in application context"