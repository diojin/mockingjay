## Frameworks

* [Spring](#spring)
    - [General](#spring-general)
        + [Spring Framework Runtime](#spring-framework-runtime)
        + [Bean Lifecycle](#bean-lifecycle)
    - [Annotation](#spring-annotation)
        + [@ComponentScan](#componentscan)
        + [@Component](#component)
        + [@Controller](#controller)
        + [@Service](#service)
        + [@Repository](#repository)
        + [@Scope](#scope)
        + [@Value](#value)
        + [@Bean](#bean)
        + [@Primary](#primary)
        + [@PostConstruct](#postconstruct)
        + [@PreDestroy](#predestroy)
        + [@Async](#async)
        + [@Transational](#transactional)
        + [@RequestMapping](#requestmapping)
        + [@ModelAttribute](#modelattribute)
        + [@Model and @ModelMap](#model-and-modelmap)
        + [@Autowired @Inject @Resource](#autowired-inject-resource)
        + [@Required](#required)
        + [context:annotation-config](#contextannotation-config)
    - [Aspect](#spring-aspect)
    - [Transaction](#spring-transaction)    
    - [Misc](#spring-misc)
        + [Bean Bootstrapping ways](#bean-bootstrapping-ways)
        + [Struts MVC vs Spring MVC](#struts-mvc-vs-spring-mvc)
        + [Spring's traits](#springs-traits)
        + [Spring Scope](#spring-scope)
        + [Differences between singleton and Spring's singleton](#differences-between-singleton-and-springs-singleton)
        + [Bean automatic assembling process](#bean-automatic-assembling-process)
        + [Ways to initializing a bean](#ways-to-initializing-a-bean)
        + [Spring injections types](#spring-injections-types)
        + [Differences between Setter Inject and Constructor Inject](#differences-between-setter-inject-and-constructor-inject)
        + [Integrate Hibernate](#integrate-hibernate)
        + [OpenSessionInView For Hibernate](#opensessioninview-for-hibernate)
        + [Benifit of IOC](#benifit-of-ioc)
        + [ApplicationContext implementations](#applicationcontext-implementations)
        + [Get ApplicationContext in web application](#get-applicationcontext-in-web-application)
        + [BeanFactory vs ApplicationContext](#beanfactory-vs-applicationcontext)
        + [Design pattern in Spring](#design-pattern-in-spring)
        + [Spring inner bean](#spring-inner-bean)
        + [Factory Bean](#factory-bean)
        + [Different aop sample codes](#different-aop-sample-codes)
        + [Spring MVC](#spring-mvc)
* [Hibernate](#hibernate)
    - [Hibernate architecture and key components](#hibernate-architecture-and-key-components)
    - [Performance tuning](#hibernate-performance-tuning)
        + [Top 10 Hibernate Performance Tuning Tips](#top-10-hibernate-performance-tuning-tips)
        + [Understanding Hibernate Collection performance](#understanding-hibernate-collection-performance)
        + [one shot delete](#hibernate-one-shot-delete)
    - [Hibernate APIs](#hibernate-apis)
        + [Session#load vs Session#get](#sessionload-vs-sessionget)
        + [Session#persist](#sessionpersist)
        + [Session#save](#sessionsave)
        + [Session#update vs Session#merge vs Session#lock](#sessionupdate-vs-sessionmerge-vs-sessionlock)
        + [Session#saveOrUpdate](#sessionsaveorupdate)
        + [Session#delete](#sessiondelete)
        + [Session#replicate](#sessionreplicate)
        + [Query#list vs Query#iterate](#querylist-vs-queryiterate)
        + [SessionFactory#getCurrentSession](#sessionfactorygetcurrentsession)
        + [Session#createFilter](#sessioncreatefilter)
        + [Hibernate#initialize](#hibernateinitialize)
    - [Misc](#hibernate-misc)
        + [Object states of hibernate](#object-states-of-hibernate)
        + [pros and cons of Hibernate](#pros-and-cons-of-hibernate)
        + [Process of loading entity in Session](#process-of-loading-entity-in-session)
        + [Primary key generation in Hibernate](#primary-key-generation-in-hibernate)
        + [Stateless session](#stateless-session)
        + [Open Session In View](#open-session-in-view)
        + [Fecthing strategy and timing](#fecthing-strategy-and-timing)
        + [Lazy and implementation](#hibernate-lazy-and-implementation)
        + [lazy fetching of individual properties](#lazy-fetching-of-individual-properties)
        + [inverse attribute in mapping](#inverse-attribute-in-mapping)
        + [Caching](#hibernate-caching)
        + [Concurrency concerns](#hibernate-concurrency-concerns)
        + [Hibernate isolation level](#hibernate-isolation-level)
        + [Flushing the Session](#flushing-the-session)
* [Struts](#struts)
    - [Struts2](#struts2)
        + [Misc](#struts2-misc)
            * [differences between struts 1 and 2](#differences-between-struts-1-and-2)
            * [Struts2 workflow](#struts2-workflow)
    - [Misc](#struts-misc)
        + [Struts action types](#struts-action-types)
        + [Struts Pros and Cons](#struts-pros-and-cons)
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
including JPA, JDO, and Hibernate. Using the spring-orm module you can use all of these O/R mapping frameworks in combination with all of the other features Spring offers, such as the simple declarative transaction management feature mentioned previously.

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


![spring_bean_lifecycle_2]
[![spring_bean_lifecycle_3]][spring_bean_lifecycle_4]

Some highlights,  
1. 如果配置文件中生明了其他BeanFactoryPostProcessor的实现类(other than InstantiationAwareBeanPostProcessor)，则ApplicationContext在装配配置文件之后初始化bean 之前将调用该接口对配置信息进行加工。
2. 当调用者通过 getBean（ name ）向 容器寻找Bean 时，如果容器注册了InstantiationAwareBeanPostProcessor接口，在实例 bean 之前，将调用该接口的 postProcessBeforeInstantiation()方法
3. 根据配置情况调用Bean构造函数或工厂方法实例化bean
4. 如果容器注册了InstantiationAwareBeanPostProcessor接口，在实例 bean 之后，调用该接口的 postProcessAfterInstantiation()方法，可以在这里对已经实例化的对象进行一些装饰。
5. 受用依赖注入，Spring 按照 Bean 定义信息配置 Bean 的所有属性 ，在设置每个属性之前将调用 InstantiationAwareBeanPostProcess接口的 postProcessPropertyValues()方法
...
6. 如果 BeanPostProcessor 和 Bean 关联，那么 将调用该接口 的postProcessBeforeInitialzation() 方法 对 bean进行加工操作，这个非常重要， spring 的 AOP 就是用它实现的。  
...
7. 如果有BeanPsotProcessor 和 Bean 关联，那么它们的 postProcessAfterInitialization() 方法将被调用。 到这个时候， Bean 已经可以被应用系统使用了。
    1. 如果在<bean> 中指定了该 bean 的作用范围为 scope="prototype", 将 bean 的调用者，调用者管理该 bean 的生命周期，`spring 不在管理该 bean`
    2. 如果在<bean> 中指定了该 bean 的作用范围为 scope="singleton", 则将该 bean 放入 springIOC 的缓存池中，将触发 spring 对该 bean 的生命周期管理。
...

PostProcessor配置在 spring 配置文件中就行了，不需要事先声明，Spring 通过接口反射预先知道，当spring 容器创建任何bean时，这些PostProcessor都会发生作用。

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
Configures component scanning directives for use with @Configuration classes. Provides support parallel with Spring XML's <context:component-scan> element.

It can be used with AnnotationConfigApplicationContext.

Note that the <context:component-scan> element has an annotation-config attribute, however this annotation does not. This is because in almost all cases when using @ComponentScan, default annotation config processing (e.g. processing @Autowired and friends) is assumed. Furthermore, when using AnnotationConfigApplicationContext, annotation config processors are always registered, meaning that any attempt to disable them at the @ComponentScan level would be ignored. 

```xml

<context:component-scan base-package="cn.gacl.java"/>
<!-- 表明cn.gacl.java包及其子包中，如果某个类的头上带有特定的注解【@Component/@Repository/@Service/@Controller】，就会将这个对象作为Bean注册进Spring容器。也可以在<context:component-scan base-package=” ”/>中指定多个包，如 -->
<context:component-scan base-package="cn.gacl.dao.impl,cn.gacl.action"/>

<context:component-scan base-package="com.spring.ioc5">  
    <!-- annotation 通过注解来过滤          org.example.SomeAnnotation    
        assignable 通过指定名称过滤        org.example.SomeClass  
        regex      通过正则表达式过滤      org\.example\.Default.*  
        aspectj    通过aspectj表达式过滤  org.example..*Service+  
    -->  
    <context:include-filter type="regex" expression="com.spring.ioc5.*"/>
    <context:exclude-filter type="annotation" expression="org.springframework.beans.factory.annotation.Autowired"/>  
</context:component-scan> 
```

```java
import com.coupang.configuration.CommonApplicationContextConfig;
import com.coupang.configuration.ConfigurationPropertiesApplicationContextInitializer;

@Configuration
@Import({CommonApplicationContextConfig.class, MyJpaRepositortyConfigSinglePackage.class})
@ComponentScan(
    basePackageClasses = {ZombieCustomerTraceRepository.class},
    useDefaultFilters = false,
    includeFilters = {
        @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE, value = {ZombieCustomerTraceRepository.class, AddressInfoRepository.class})
    }
)
class MyDbDependenciesSinglePackagesConfig{
}

// test classes
@Test
@Ignore
public void testMyDBSinglePackageScanned(){
    AnnotationConfigApplicationContext rootContext = new AnnotationConfigApplicationContext();
    new ConfigurationPropertiesApplicationContextInitializer().initialize(rootContext);
    rootContext.register(MyDbDependenciesSinglePackagesConfig.class);
    rootContext.refresh();
    ZombieCustomerTraceRepository repo = rootContext.getBean(ZombieCustomerTraceRepository.class);
    System.out.println(repo.findOne(15l));
}

```


##### @Component
Indicates that an annotated class is a "component". Such classes are considered as candidates for auto-detection when using annotation-based configuration and classpath scanning. 

Other class-level annotations may be considered as identifying a component as well, typically a special kind of component: e.g. the @Repository annotation or AspectJ's @Aspect annotation.

Other annotations marked as @Component includes @Configuration, @Controller, @Service, @Repository, and etc.

>org.springframework.context.annotation.ClassPathBeanDefinitionScanner
>>A bean definition scanner that detects bean candidates on the classpath, registering corresponding bean definitions with a given registry (BeanFactory or ApplicationContext). 
Candidate classes are detected through configurable type filters. The default filters include classes that are annotated with Spring's @Component, @Repository, @Service, or @Controller stereotype. 
Also supports Java EE 6's javax.annotation.ManagedBean and JSR-330's javax.inject.Named annotations, if available

##### @Configuration
org.springframework.context.annotation.Configuration

Indicates that a class declares one or more @Bean methods and may be processed by the Spring container to generate bean definitions and service requests for those beans at runtime, for example:

```java
@Configuration
public class AppConfig {
    @Bean
    public MyBean myBean() {
        // instantiate, configure and return bean ...
    }
}

// for example, a @Bean definition
@Bean(name = "threadPoolTaskExecutor")
public TaskExecutor threadPoolTaskExecutor() {
    ThreadPoolTaskExecutor threadPoolTaskExecutor =
            new ThreadPoolTaskExecutor();
    threadPoolTaskExecutor.setCorePoolSize(ASYNC_CORE_POOL_SIZE);
    threadPoolTaskExecutor.setMaxPoolSize(ASYNC_MAX_POOL_SIZE);
    threadPoolTaskExecutor.setQueueCapacity(ASYNC_QUEUE_CAPACITY);
    threadPoolTaskExecutor.setThreadNamePrefix("SubscribeOrderWorker");
    threadPoolTaskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.DiscardPolicy());
    ThreadPoolExecutorStatsJMXRegister.register(threadPoolTaskExecutor);
    return threadPoolTaskExecutor;
}
```

__Bootstrapping @Configuration classes__  
1. Via AnnotationConfigApplicationContext  
@Configuration classes are typically bootstrapped using either **AnnotationConfigApplicationContext** or its web-capable variant, **AnnotationConfigWebApplicationContext**. A simple example with the former follows: 
```java
AnnotationConfigApplicationContext ctx =
    new AnnotationConfigApplicationContext();
ctx.register(AppConfig.class);
ctx.refresh();
MyBean myBean = ctx.getBean(MyBean.class);
// use myBean ...
```

2. Via Spring <beans> XML  
As an alternative to registering @Configuration classes directly against an AnnotationConfigApplicationContext, @Configuration classes may be declared as normal <bean> definitions within Spring XML files: 

```xml
<beans>
   <context:annotation-config/>
   <bean class="com.acme.AppConfig"/>
</beans>
```
In the example above, <context:annotation-config/> is required in order to enable ConfigurationClassPostProcessor and other annotation-related post processors that facilitate handling @Configuration classes. 

3. Via component scanning  
@Configuration is meta-annotated with @Component, therefore @Configuration classes are candidates for component scanning (typically using Spring XML's <context:component-scan/> element) and therefore may also take advantage of @Autowired/@Inject at the field and method level (but not at the constructor level). 

@Configuration classes may not only be bootstrapped using component scanning, but may also themselves configure component scanning using the @ComponentScan annotation: 
```java
@Configuration
@ComponentScan("com.acme.app.services")
public class AppConfig {
    // various @Bean definitions ...
}
```

__Working with externalized values__  
1. Using the Environment API

Externalized values may be looked up by injecting the Spring Environment into a @Configuration class using the @Autowired or the @Inject annotation: 
```java
@Configuration
public class AppConfig {
    @Inject Environment env;

    @Bean
    public MyBean myBean() {
        MyBean myBean = new MyBean();
        myBean.setName(env.getProperty("bean.name"));
        return myBean;
    }
}
```

Properties resolved through the Environment reside in one or more "property source" objects, and @Configuration classes may contribute property sources to the Environment object using the @PropertySources annotation: 

```java
@Configuration
@PropertySource("classpath:/com/acme/app.properties")
public class AppConfig {
    @Inject Environment env;

    @Bean
    public MyBean myBean() {
        return new MyBean(env.getProperty("bean.name"));
    }
}
```

2. Using the @Value annotation
Externalized values may be 'wired into' @Configuration classes using the @Value annotation: 
```java
 @Configuration
 @PropertySource("classpath:/com/acme/app.properties")
 public class AppConfig {
     @Value("${bean.name}") String beanName;

     @Bean
     public MyBean myBean() {
         return new MyBean(beanName);
     }
 }
```
This approach is most useful when using Spring's PropertySourcesPlaceholderConfigurer, usually enabled via XML with <context:property-placeholder/>. See the section below on composing @Configuration classes with Spring XML using @ImportResource, see @Value Javadoc, and see @Bean Javadoc for details on working with BeanFactoryPostProcessor types such as PropertySourcesPlaceholderConfigurer. 

__Composing @Configuration classes__  
1. With the @Import annotation  
@Configuration classes may be composed using the @Import annotation, not unlike the way that <import> works in Spring XML. Because @Configuration objects are managed as Spring beans within the container, imported configurations may be injected using @Autowired or @Inject: 
```java
@Configuration
public class DatabaseConfig {
    @Bean
    public DataSource dataSource() {
        // instantiate, configure and return DataSource
    }
}

@Configuration
@Import(DatabaseConfig.class)
public class AppConfig {
    @Inject DatabaseConfig dataConfig;

    @Bean
    public MyBean myBean() {
        // reference the dataSource() bean method
        return new MyBean(dataConfig.dataSource());
    }
}
// Now both AppConfig and the imported DatabaseConfig can be bootstrapped by registering only AppConfig against the Spring context: 
new AnnotationConfigApplicationContext(AppConfig.class);
```

2. With the @Profile annotation  
@Configuration classes may be marked with the @Profile annotation to indicate they should be processed only if a given profile or profiles are active: 
```java
@Profile("embedded")
@Configuration
public class EmbeddedDatabaseConfig {
    @Bean
    public DataSource dataSource() {
        // instantiate, configure and return embedded DataSource
    }
}

@Profile("production")
@Configuration
public class ProductionDatabaseConfig {
    @Bean
    public DataSource dataSource() {
        // instantiate, configure and return production DataSource
    }
}
```

3. With Spring XML using the @ImportResource annotation  
As mentioned above, @Configuration classes may be declared as regular Spring <bean> definitions within Spring XML files. It is also possible to import Spring XML configuration files into @Configuration classes using the @ImportResource annotation. Bean definitions imported from XML can be injected using @Autowired or @Import: 
```java
 @Configuration
 @ImportResource("classpath:/com/acme/database-config.xml")
 public class AppConfig {
     @Inject DataSource dataSource; // from XML

     @Bean
     public MyBean myBean() {
         // inject the XML-defined dataSource bean
         return new MyBean(this.dataSource);
     }
 }
```

4. With nested @Configuration classes  
@Configuration classes may be nested within one another as follows: 
```java
@Configuration
public class AppConfig {
    @Inject DataSource dataSource;

    @Bean
    public MyBean myBean() {
        return new MyBean(dataSource);
    }

    @Configuration
    static class DatabaseConfig {
        @Bean
        DataSource dataSource() {
            return new EmbeddedDatabaseBuilder().build();
        }
    }
}
```
When bootstrapping such an arrangement, only AppConfig need be registered against the application context. By virtue of being a nested @Configuration class, DatabaseConfig will be registered automatically. This avoids the need to use an @Import annotation when the relationship between AppConfig and DatabaseConfig is already implicitly clear. 
Note also that nested @Configuration classes can be used to good effect with the @Profile annotation to provide two options of the same bean to the enclosing @Configuration class. 

__Configuring lazy initialization__  
By default, @Bean methods will be **eagerly instantiated** at container bootstrap time. To avoid this, @Configuration may be used in conjunction with the **@Lazy** annotation to indicate that all @Bean methods declared within the class are by default lazily initialized. Note that @Lazy may be used on individual @Bean methods as well. 

__Testing support for @Configuration classes__  
The Spring TestContext framework available in the spring-test module provides the @ContextConfiguration annotation, which as of Spring 3.1 can accept an array of @Configuration Class objects: 
```java
 @RunWith(SpringJUnit4ClassRunner.class)
 @ContextConfiguration(classes={AppConfig.class, DatabaseConfig.class})
 public class MyTests {
     @Autowired MyBean myBean;
     @Autowired DataSource dataSource;
     @Test
     public void test() {
         // assertions against myBean ...
     }
 }
```
__Enabling built-in Spring features using @Enable annotations__  
Spring features such as asynchronous method execution, scheduled task execution, annotation driven transaction management, and even Spring MVC can be enabled and configured from @Configuration classes using their respective "@Enable" annotations. See @EnableAsync, @EnableScheduling, @EnableTransactionManagement, @EnableAspectJAutoProxy, and @EnableWebMvc for details. 

__Constraints when authoring @Configuration classes__  
1. @Configuration classes must be non-final 
2. @Configuration classes must be non-local (may not be declared within a method) 
3. @Configuration classes must have a default/no-arg constructor and may not use @Autowired constructor parameters. 
4. Any nested configuration classes must be static. 

##### @Controller
* org.springframework.stereotype.Controller  
This annotation serves as a specialization of @Component, allowing for implementation classes to be autodetected through classpath scanning. It is typically used in combination with annotated handler methods based on the org.springframework.web.bind.annotation.RequestMapping annotation.
```java
@Controller
@Scope("prototype")
public class UserAction extends BaseAction<User>{
    //……
}
```

使用@Controller注解标识UserAction之后，就表示要把UserAction交给Spring容器管理，在Spring容器中会存在一个名字为"userAction"的action，这个名字是根据UserAction类名来取的。

注意：如果@Controller不指定其value，则默认的bean名字为这个类的类名首字母小写，如果指定value【@Controller(value="UserAction")】或者【@Controller("UserAction")】，则使用value作为bean的名字。

* org.springframework.web.servlet.mvc.Controller  
Base Controller interface, representing a component that receives HttpServletRequest and HttpServletResponse instances just like a HttpServlet but is able to participate in an MVC workflow. Controllers are comparable to the notion of a Struts Action. 
Not used in coupang project.

##### @Service
org.springframework.stereotype.Service

Indicates that an annotated class is a "Service", originally defined by Domain-Driven Design (Evans, 2003) as "an operation offered as an interface that stands alone in the model, with no encapsulated state." 

May also indicate that a class is a "Business Service Facade" (in the Core J2EE patterns sense), or something similar. This annotation is a general-purpose stereotype and individual teams may narrow their semantics and use as appropriate. 

This annotation serves as a specialization of @Component, allowing for implementation classes to be autodetected through classpath scanning.

##### @Repository
org.springframework.stereotype.Repository

Indicates that an annotated class is a "Repository", originally defined by Domain-Driven Design (Evans, 2003) as "a mechanism for encapsulating storage, retrieval, and search behavior which emulates a collection of objects". 

Teams implementing traditional J2EE patterns such as "Data Access Object" may also apply this stereotype to DAO classes, This annotation is a general-purpose stereotype and individual teams may narrow their semantics and use as appropriate. 

As of Spring 2.5, this annotation also serves as a specialization of @Component, allowing for implementation classes to be autodetected through classpath scanning.

##### @Scope
When used as a type-level annotation in conjunction with the Component annotation, indicates the name of a scope to use for instances of the annotated type. 

When used as a method-level annotation in conjunction with the Bean annotation, indicates the name of a scope to use for the instance returned from the method. 

In this context, scope means the lifecycle of an instance, such as singleton, prototype, and so forth. Scopes provided out of the box in Spring may be referred to using the SCOPE_* constants available in via ConfigurableBeanFactory and WebApplicationContext interfaces.
```java 
ConfigurableBeanFactory.SCOPE_SINGLETON
ConfigurableBeanFactory.SCOPE_PROTOTYPE
org.springframework.web.context.WebApplicationContext.SCOPE_REQUEST
org.springframework.web.context.WebApplicationContext.SCOPE_SESSION
org.springframework.web.context.WebApplicationContext.SCOPE_GLOBAL_SESSION
```
To register additional custom scopes, see CustomScopeConfigurer.

##### @Value

Annotation at the field or method/constructor parameter level that indicates a default value expression for the affected argument. 

Typically used for expression-driven dependency injection. Also supported for dynamic resolution of handler method parameters, e.g. in Spring MVC. 

用于注入SpEL表达式

```java
@Value("#{environment['product.change.tips.categories']}")
```

##### @Bean
Indicates that a method produces a bean to be managed by the Spring container. 

```java
public @interface Bean {
    String[] name() default {};
    /** Are dependencies to be injected via convention-based autowiring by name or type? */
    Autowire autowire() default Autowire.NO;
    String initMethod() default "";
    String destroyMethod() default AbstractBeanDefinition.INFER_METHOD;
}
```


Note that the @Bean annotation does not provide attributes for scope, depends-on, primary, or lazy. Rather, it should be used in conjunction with @Scope, @DependsOn, @Primary, and @Lazy annotations to achieve those semantics. For example: 
```java
@Bean
@Scope("prototype")
public MyBean myBean() {
    // instantiate and configure MyBean obj
    return obj;
}
```

Typically, @Bean methods are declared within @Configuration classes. In this case, bean methods may reference other @Bean methods in the same class by calling them directly. Such so-called 'inter-bean references' 

```java
@Configuration
public class AppConfig {
    @Bean
    public FooService fooService() {
        return new FooService(fooRepository());
    }
    @Bean
    public FooRepository fooRepository() {
        return new JdbcFooRepository(dataSource());
    }
    // ...
}
```

@Bean methods may also be declared within classes that are not annotated with @Configuration. In such cases, a @Bean method will get processed in a so-called 'lite' mode. 

Bean methods in lite mode will be treated as plain factory methods by the container (similar to factory-method declarations in XML)

In contrast to the semantics for bean methods in @Configuration classes, 'inter-bean references' are not supported in lite mode.

To avoid these lifecycle issues, mark BFPP-returning @Bean methods as static. For example: 

```java
@Bean
public static PropertyPlaceholderConfigurer ppc() {
    // instantiate, configure and return ppc ...
}
```

##### @Primary
自动装配时当出现多个Bean候选者时，被注解为@Primary的Bean将作为首选者，否则将抛出异常

##### @PostConstruct
用于指定初始化方法（用在方法上）

##### @PreDestory
用于指定销毁方法（用在方法上）

##### @Async
Annotation that marks a method as a candidate for asynchronous execution. Can also be used at the type level, in which case all of the type's methods are considered as asynchronous. 

the return type is constrained to either __void__ or __java.util.concurrent.Future__.

1. by xml
```xml
<bean id="taskExecutor" class="org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor">
    <property name="corePoolSize" value="10"/>
    <property name="maxPoolSize" value="300"/>
</bean>
<task:annotation-driven/>
```

2. by annotation

```java
// in some @Configuration class
@Bean(name = "threadPoolTaskExecutor")
public TaskExecutor threadPoolTaskExecutor() {
    ThreadPoolTaskExecutor threadPoolTaskExecutor =
            new ThreadPoolTaskExecutor();
    threadPoolTaskExecutor.setCorePoolSize(ASYNC_CORE_POOL_SIZE);
    threadPoolTaskExecutor.setMaxPoolSize(ASYNC_MAX_POOL_SIZE);
    threadPoolTaskExecutor.setQueueCapacity(ASYNC_QUEUE_CAPACITY);
    threadPoolTaskExecutor.setThreadNamePrefix("SubscribeOrderWorker");
    threadPoolTaskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.DiscardPolicy());

    ThreadPoolExecutorStatsJMXRegister.register(threadPoolTaskExecutor);

    return threadPoolTaskExecutor;
}

// how to use
@Async("threadPoolTaskExecutor")

// if only one executor is specified
@Async
```

##### @Transational 

顾名思义就是用于事务控制的
```java
@Transactional(readOnly = false, rollbackFor = DataAccessException.class)  
public Account register(Account account);  
```

##### @RequestMapping

Annotation for mapping web requests onto specific handler classes and/or handler methods. 

注释在类上是定义该类的访问地址，需要访问其方法是，需要在地址的后面加上”？“+方法名。如果该注解注释在方法上就指定了该方法的访问地址。

```java
@RequestMapping("center/switcher")
public ModelAndView notificationCenterSwitcher(){}

@RequestMapping(value = "/changeOrder/show", method = RequestMethod.POST, consumes = "application/json")
@ResponseBody
public List<ChangeRealOrderDateDTO> show(@RequestBody String request){}

@RequestMapping(value = "/findVendors", method = RequestMethod.POST)
@ResponseBody
public DataTableResponseVO findVendors(@RequestBody @Valid List<DataTableRequestVO> dataTableVOs){}

@RequestMapping(value = "/fundItems/{vendorId}", method = RequestMethod.GET)
public String funds(@PathVariable("vendorId") String vendorId, ModelMap modelMap){}

@RequestMapping("channel/modify")
public ModelAndView updateNotificationChannelType(@RequestParam(value = "channelTypeId", required = true) Long notificationChannelTypeId) {}

@Controller  
@RequestMapping(value = "/login.do")  
public class LoginController {  
    @RequestMapping(method = RequestMethod.GET)  
    public String initForm(ModelMap model) {  
        Account account = new Account();  
        model.addAttribute("account", account);  
        // 直接跳转到登录页面  
        return "account/login";  
    }  
    @RequestMapping(method = RequestMethod.POST)  
    public String login(@ModelAttribute("account") Account account) {  
        Account acc = accountService.read(account.getUsername(), account  
                .getPassword());  
        if (acc != null) {  
            return "redirect:profile.do?id=" + acc.getId();  
        } else {  
            return "redirect:login.do";  
        }  
    }  
} 
```

##### @ModelAttribute

Annotation that binds a method parameter or method return value to a named model attribute, exposed to a web view.

将任何一个拥有返回值的方法标注上 @ModelAttribute，使其返回值将会进入到模型对象的属性列表中.(ModelMap)

@ModelAttribute("account") Account
用来绑定表单即指明了这个方法使用的数据是来自account这个表单的数据，接收数据的对象就是Account。

```java
@RequestMapping(value={REQUEST_MAPPING_SUBSCRIPTION_LIST}, method = RequestMethod.GET)
public ModelAndView customerSubscriptionList(@ModelAttribute CsSubscriptionSearchForm searchForm){}

@ResponseBody
@RequestMapping(value = "/cs/subscribe/addressEdit/selectAddress", method = RequestMethod.POST)
public ModelAndView applyNewSelectedAddress(@ModelAttribute AddressSelectedInfoDTO addressSelectedInfoDTO, Model model){}
```


##### @Model and @ModelMap

* @ModelMap
This class serves as generic model holder for both Servlet and Portlet MVC, but is not tied to either of those. Check out the Model interface for a Java-5-based interface variant that serves the same purpose.

* @Model
Java-5-specific interface that defines a holder for model attributes. Primarily designed for adding attributes to the model. Allows for accessing the overall model as a java.util.Map.

```java
@RequestMapping(value = "/cashaccumulatedetail/cashAccumulateDetailList", method = RequestMethod.GET)
public String cashAccumulateList(Model model, CashAccumulateHistoryDetailCondition condition){
    model.addAttribute("condition", condition);
    model.addAttribute("pageIndex", condition.getPage());
    return "web/page/cashaccumulatehistory/detail/cashAccumulateDetailList";
}

@RequestMapping(value = REQUEST_MAPPING_PRICE_HISTORY)
public String showPriceHistory(@RequestParam Long subscriptionId, @RequestParam String memberId, @RequestParam Long vendorItemId, ModelMap modelMap){
    modelMap.addAttribute("priceHistory", priceHistory);
    modelMap.addAttribute("subscriptionId", subscriptionId);
    return VIEW_NAME_PRICE_HISTORY;
}


```

##### @Autowired @Inject @Resource

[SPRING INJECTION WITH @RESOURCE, @AUTOWIRED AND @INJECT][spring_annotation_1]

ANNOTATION|PACKAGE|SOURCE
:----------|:-------|------
@Resource   |javax.annotation    |Java
@Inject     |javax.inject        |Java
@Qualifier  |javax.inject        |Java
@Autowired  |org.springframework.bean.factory    |Spring

When I looked under the hood I determined that the ‘@Autowired’ and ‘@Inject’ annotation behave identically. Both of these annotations use the ‘AutowiredAnnotationBeanPostProcessor’ to inject dependencies. ‘@Autowired’ and ‘@Inject’ can be used interchangeable to inject Spring beans. 

However the ‘@Resource’ annotation uses the ‘CommonAnnotationBeanPostProcessor’ to inject dependencies. Even though they use different post processor classes they all behave nearly identically. Below is a summary of their **execution paths**.

__@Autowired and @Inject__ 
1. Matches by Type
2. Restricts by Qualifiers
3. Matches by Name  

__@Resource__  
1. Matches by Name
2. Matches by Type
3. Restricts by Qualifiers (ignored if match is found by name)

While it could be argued that ‘@Resource’ will perform faster by name than ‘@Autowired’ and ‘@Inject’ it would be negligible. This isn’t a sufficient reason to favor one syntax over the others. I do however favor the ‘@Resource’ annotation for it’s concise notation style.

```java
@Resource(name="person")

@Autowired
@Qualifier("person")

@Inject
@Qualifier("person")
```

Spring Annotation Style Best Practices
1. Explicitly name your component [@Component(“beanName”)]
2. Use ‘@Resource’ with the ‘name’ attribute [@Resource(name=”beanName”)]
3. Avoid ‘@Qualifier’ annotations unless you want to create a list of similar beans. For example you may want to mark a set of rules with a specific ‘@Qualifier’ annotation. This approach makes it simple to inject a group of rule classes into a list that can be used for processing data.
4. Scan specific packages for components <context:component-scan base-package=”com.sourceallies.person” />. While this will result in more component-scan configurations, it reduces the chance that you’ll add unnecessary components to your Spring context.

Following these guidelines will increase the readability and stability of your Spring annotation configurations.

>@Inject is part of the Java CDI (Contexts and Dependency Injection) standard introduced in Java EE 6 (JSR-300). Spring has chosen to support using @Inject synonymously with their own @Autowired annotation.  
In a Spring application, the two annotations works the same way as Spring has decided to support some JSR-300 annotations in addition to their own.

>I agree with you that we don't change the DI frameworks often . However if our source code has multiple packages and if you want to build a common package which you want to share across multiple projects and then going with @Inject JSR annotation is better than using @Autowired which locks your code base with spring DI. – Aditya


__@Autowired__  

@Autowired(required=false)

Marks a constructor, field, setter method or config method as to be autowired by Spring's dependency injection facilities. 

@Autowired 标注作用于 Map 类型时，如果 Map 的 key 为 String 类型，则 Spring 会将容器中所有类型符合 Map 的 value 对应的类型的 Bean 增加进来，用 Bean 的 id 或 name 作为 Map 的 key。

@Autowired 还有一个作用就是，如果将其标注在 BeanFactory 类型、ApplicationContext 类型、ResourceLoader 类型、ApplicationEventPublisher 类型、MessageSource 类型上，那么 Spring 会自动注入这些实现类的实例，不需要额外的操作。

##### @Required 

Marks a `method (typically a JavaBean setter method)` as being 'required': that is, the setter method must be configured to be dependency-injected with a value. 

@Required注解检查 但他只检查属性是否已经设置而不会测试属性是否非空

@Required 注释应用于 bean 属性的 setter 方法，它表明受影响的 bean 属性在配置时必须放在 XML 配置文件中，否则容器就会抛出一个 BeanInitializationException 异常。

>RequiredAnnotationBeanPostProcessor
>>Please note that an 'init' method may still need to implemented (and may still be desirable), because all that this class does is enforce that a 'required' property has actually been configured with a value. It does not check anything else... In particular, it does not check that a configured value is not null.  
Note: A default RequiredAnnotationBeanPostProcessor will be registered by the "context:annotation-config" and "context:component-scan" XML tags. Remove or turn off the default annotation configuration there if you intend to specify a custom RequiredAnnotationBeanPostProcessor bean definition.

To support @Required 接着我们需要在 配置文件中加上这样一句话
```xml
<bean class="org.springframework.beans.factory.annotation.    
    RequiredAnnotationBeanPostProcessor"/>   
```

##### context:annotation-config

<context:annotation-config /> 将隐式地向spring 容器注册AutowiredAnnotationBeanPostProcessor 、CommonAnnotationBeanPostProcessor 、 PersistenceAnnotationBeanPostProcessor 以及RequiredAnnotationBeanPostProcessor 这4个BeanPostProcessor, so that @Autowired and @Required are supported.

To do it separatedly, 
* Config AutowiredAnnotationBeanPostProcessor to support @Autowired
* To support @Required 接着我们需要在 配置文件中加上这样一句话
```xml
<bean class="org.springframework.beans.factory.annotation.    
    RequiredAnnotationBeanPostProcessor"/>   
```

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

* PROPAGATION_REQUIRED–支持当前事务，如果当前没有事务，就新建一个事务. 这是最常见的选择
* PROPAGATION_SUPPORTS–支持当前事务，如果当前没有事务，就以非事务方式执行。 
* PROPAGATION_MANDATORY–支持当前事务，如果当前没有事务，就抛出异常。 
* PROPAGATION_REQUIRES_NEW–新建事务，如果当前存在事务，把当前事务挂起。 
* PROPAGATION_NOT_SUPPORTED–以非事务方式执行操作, 如果当前存在事务, 就把当前事务挂起.
* PROPAGATION_NEVER–以非事务方式执行，如果当前存在事务，则抛出异常。 
* PROPAGATION_NESTED–如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则进行与PROPAGATION_REQUIRED类似的操作。

前六个策略类似于EJB CMT，第七个（PROPAGATION_NESTED）是Spring所提供的一个特殊变量。它要求事务管理器或者使用JDBC 3.0 Savepoint API提供嵌套事务行为（如Spring的DataSourceTransactionManager）

#### Spring Misc

##### Bean Bootstrapping ways

1. xml
```xml
<bean class="org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor"/>
```

2. context:annotation-config
```xml
<beans>
   <context:annotation-config/>
   <bean class="com.acme.AppConfig"/>
</beans>
```
In the example above, <context:annotation-config/> is required in order to enable ConfigurationClassPostProcessor and other annotation-related post processors that facilitate handling @Configuration classes. 

<context:annotation-config /> 将隐式地向spring 容器注册AutowiredAnnotationBeanPostProcessor 、CommonAnnotationBeanPostProcessor 、 PersistenceAnnotationBeanPostProcessor 以及RequiredAnnotationBeanPostProcessor 这4 个BeanPostProcessor 

3. <context:component-scan />

##### Struts MVC vs Spring MVC

1. Spring provides a very clean division between controllers, JavaBean models, and views.

2. Spring's MVC is very flexible. Unlike Struts, which `forces your Action and Form objects into concrete inheritance` (thus taking away your single shot at concrete inheritance in Java), Spring MVC is entirely based on interfaces. Furthermore, just about every part of the Spring MVC framework is configurable via plugging in your own interface. Of course we also provide convenience classes as an implementation option.

3. Spring, like WebWork, provides interceptors as well as controllers, making it easy to factor out behavior common to the handling of many requests.

4. Spring MVC is truly **view-agnostic**. You don't get pushed to use JSP if you don't want to; you can use Velocity, XLST or other view technologies. If you want to use a custom view mechanism - for example, your own templating language - you can easily implement the Spring View interface to integrate it.

5. Spring Controllers are configured via IoC like any other objects. This makes them **easy to test**, and beautifully integrated with other objects managed by Spring.

6. Spring MVC web tiers are typically easier to test than Struts web tiers, due to the avoidance of forced concrete inheritance and explicit dependence of controllers on the dispatcher servlet.

7. The web tier becomes a thin layer on top of a business object layer. This encourages good practice. Struts and other dedicated web frameworks leave you on your own in implementing your business objects; `Spring provides an integrated framework for all tiers of your application`.

##### Spring's traits

Spring是一个轻量级的`控制反转(IoC)`和`面向切面(AOP)`的容器框架。 
* 轻量——从大小与开销两方面而言Spring都是轻量的。此外，Spring是非侵入式的：典型地，Spring应用中的对象不依赖于Spring的特定类。 
* 控制反转——Spring通过一种称作控制反转（IoC）的技术促进了松耦合。
* 面向切面——Spring提供了面向切面编程的丰富支持，允许通过分离应用的业务逻辑与系统级服务（例如审计（auditing）和事务（）管理）进行内聚性的开发。应用对象只实现它们应该做的——完成业务逻辑——仅此而已。它们并不负责（甚至是意识）其它的系统级关注点，例如日志或事务支持
* 容器——Spring包含并管理应用对象的配置和生命周期，在这个意义上它是一种容器，你可以配置你的每个bean如何被创建——基于一个可配置原型（prototype），你的bean可以创建一个单独的实例或者每次需要时都生成一个新的实例——以及它们是如何相互关联的
* 框架——Spring可以将简单的组件配置、组合成为复杂的应用。在Spring中，应用对象被声明式地组合，典型地是在一个XML文件里。Spring也提供了很多基础功能（事务管理、持久化框架集成等等），将应用逻辑的开发留给了你

##### Spring Scope

Scope用来声明容器中的对象的存货时间。即容器在对象在进入其相应的scope之前，生成并装配这些对象，在该对象不再处于这些scope的限定之后，容器通常会销毁这些对象。

Sprign容器最初提供了两种bean的scope类型：singletoon和prototype。自Spring2.0之后，引入了另外三种scope类型，即request、session和global session类型。这三种类型只能再web中使用。Moreover, Spring supports customized scope

* ConfigurableBeanFactory.SCOPE_SINGLETON  
* ConfigurableBeanFactory.SCOPE_PROTOTYPE  
* org.springframework.web.context.WebApplicationContext.SCOPE_REQUEST
* org.springframework.web.context.WebApplicationContext.SCOPE_SESSION
* org.springframework.web.context.WebApplicationContext.SCOPE_GLOBAL_SESSION

1. singleton
特性：  
* 对象实例数量：容器中只存在一个实例，所有对该类型bean的依赖都引用这单一实例。
* 对象存活时间：从容器启动，到第一次因请求而实例化开始，只要容器不销毁或退出，该实例一直存在。

配置形式：
```xml
<bean id="mockObject1" class="...MockBusinessObject" />
<bean id="mockObject1" class="...MockBusinessObject" singleton="true" />
<bean id="mockObject1" class="...MockBusinessObject" scope="singleton" />
```

2. prototype
容器在接到标有prototype类型对象的请求后，会每次重新生成一个新的对象实例给请求方。`请求方负责当前返回对象的后继生命周期工作`，包括对象的销毁。
一般声明此类型的bean都是一些有状态的。比如保存每个顾客信息的对象。

配置形式：
```xml
<bean id="mockObject1" class="...MockBusinessObject" singleton="false" />
<bean id="mockObject1" class="...MockBusinessObject" scope="prototype" />
```

3. request, session, globle session
它们只适用于Web应用程序，通常是与XmlWebApplicationContext共同使用

* request
配置形式：<bean id="userManager" class="... " scope="request" />
Spring容器，即XmlWebApplicationContext会为每个Http请求创建一个新的requestProcessor对象供当前对象使用，当请求结束后，该对象实例的生命周期即告结束。当同时有10个Http请求进来，容器会分别为这10个请求返回10个全新的实例，且它们之间互不干扰。

* session   
配置形式： <bean id="userManager" class="...userManager" scope="session"/>
Spring容器会为每个独立的session创建属于它们自己的全新的userManager对象实例。存活时间大于request。

* global session
配置形式： <bean id="userManager" class="...userManager" scope="globalSession"/>
global session只有应用在基于portlet的Web应用程序中才有意义，它映射到portlet的global范围的session。如果在普通的基于servlet的Web应用中使用了这个类型的scope，容器会将其作为普通的session类型的scope对待。

4. customized scope
用户可以根据自己的需要，添加自定义的scope类型。除了默认的singleton和prototype之外，其他三种类型，包括自定义类型都实现了org.springframework.beans.factory.config.Scope接口。该接口定义如下：
```java
public interface Scope {
    Object get(String name, ObjectFactory objectFactory); 
    Object remove(String name);
    void registerDestructionCallback(String name, Runnable callback);
    String getConversationId();
}
```
要实现自己的scope类型，首先需要给出一个Scope接口的实现类，接口定义中的4个方法并非都是必须的，但get和remove方法必须实现。

##### Differences between singleton and Spring's singleton

* Spring标记Singleton的bean代表这种类型的bean在容器中只存在一个共享实例
* Singleton模式则是保证在同一个classloader中只存在一个这种类型的实例

##### Bean automatic assembling process
我们对XML配置文件装配Bean的方式都很熟悉了，但是随着业务的复杂性，我们可能编写越来越复杂的XML配置。

Spring提供了4种类型的自动装配的方式，帮助我们减少XML的配置数量。如下： 

1. byName：根据与bean的属性具有相同名字（或者ID）的其他bean进行注入
2. byType:   根据与bean的属性具有相同类型的其他bean进行注入
3. constructor：根据与bean的构造函数参数有相同类型的bean进行注入
4. autodetect :  首先尝试使用constructor进行注入，失败则尝试使用byType

##### Ways to initializing a bean

1. constructor
2. static factory method
3. instance factory method

##### Spring injections types
__不同类型的IOC（依赖注入）方式__  

1. 构造器依赖注入
    构造器依赖注入通过容器触发一个类的构造器来实现的，该类有一系列参数，每个参数代表一个对其他类的依赖。 
    用构造器参数实现强制依赖
```java
private DependencyA dependencyA;
private DependencyB dependencyB;

@Autowired
public DI(DependencyA dependencyA, DependencyB dependencyB) {
    this.dependencyA = dependencyA;
    this.dependencyB = dependencyB;
}
```
2. Setter方法注入
    Setter方法注入是容器通过调用无参构造器或无参static工厂 方法实例化bean之后，调用该bean的setter方法，即实现了基于setter的依赖注入。

    setter方法实现可选依赖
```java
private DependencyA dependencyA;
private DependencyB dependencyB;
 
@Autowired
public void setDependencyA(DependencyA dependencyA) {
    this.dependencyA = dependencyA;
}
 
@Autowired
public void setDependencyB(DependencyB dependencyB) {
    this.dependencyB = dependencyB;
}
```

3. Field Injection
```java
@Autowired
private DependencyA dependencyA;
 
@Autowired
private DependencyB dependencyB;
```

[For more information][spring-misc-injection-1]

##### Differences between Setter Inject and Constructor Inject
__构造方法注入和设值注入有什么区别__  

Setters should be used to inject optional dependencies.
Constructor injection is good for mandatory dependencies.

1. Partial dependency: can be injected using setter injection but it is not possible by constructor. Suppose there are 3 properties in a class, having 3 arg constructor and setters methods. In such case, if you want to pass information for only one property, it is possible by setter method only.
2. Overriding: Setter injection overrides the constructor injection. .
3. Changes: We can easily change the value by setter injection. It doesn't create a new bean instance always like constructor. So setter injection is flexible than constructor injection
4. Required dependency. By using Constructor Injection, you assert the requirement for the dependency in a `container-agnostic` manner.  
A class that takes a required dependency as a constructor argument can only be instantiated if that argument is provided (you should have a guard clause to make sure the argument is not null.) A constructor therefore enforces the dependency requirement whether or not you're using Spring, making it container-agnostic.  
If you use setter injection, the setter may or may not be called, so the instance may never be provided with its dependency. The only way to force the setter to be called is using @Required or @Autowired , which is specific to Spring and is therefore not container-agnostic.  
So to keep your code independent of Spring, use constructor arguments for injection.  
Update: Spring 4.3 will perform `implicit injection in single-constructor scenarios`, making your code more independent of Spring by potentially not requiring an @Autowired annotation at all.  
__Implicit constructor injection for single-constructor scenarios__  
```java
// this can be injected properly
public class FooService {
    private final FooRepository repository;
    public FooService(FooRepository repository){
        this.repository = repository;
    }
}
```

5. circular dependencies


##### Integrate Hibernate

1. 定义DataSource
2. 创建SessionFactory
3. implement DAO class
    1. DAO类继承HibernateDaoSupport，从中获得HibernateTemplate进行具体操作
Using HibernateDaoSupport/HibernateTemplate is not recommended since it unnecessarily ties your code to Spring classes.
    2. Hibernate access code can also be coded in plain Hibernate style.  
    for example:
```java
getSessionFactory().getCurrentSession().save(customer);
```

**See also:**  
[Implementing DAOs based on plain Hibernate 3 API][spring-orm-hibernate-1]

As for 3.1 Using HibernateDaoSupport/HibernateTemplate,   
Using these classes was inevitable with older versions of Hibernate in order to integrate support of Spring-managed transactions.

However, since Hibernate 3.0.1 you don't need it any more - you can write a code against a plain Hibernate API while using Spring-managed transactions. All you need is to configure Spring transaction support, inject SessionFactory and call getCurrentSession() on it when you need to work with session.

Another benefit of HibernateTemplate is exception translation. Without HibernateTemplate the same functionality can be achieved by using @Repository annotation, as shown in Gareth Davis's answer.






##### OpenSessionInView For Hibernate

在使用Hibernate时遇到OpenSessionInView的问题，可以添加OpenSessionInViewFilter或OpenSessionInViewInterceptor

它有两种配置方式OpenSessionInViewInterceptor和OpenSessionInViewFilter，功能相同，只是一个在web.xml配置，另一个在application.xml配置而已。 

Open Session In View在request把session绑定到当前thread期间一直保持hibernate session在open状态，使session在request的整个期间都可以使用，如在View层里PO也可以lazy loading数据，如 ${company.employees}。当View 层逻辑完成后，才会通过Filter的doFilter方法或Interceptor的postHandle方法自动关闭session。 
1. web.xml配置OpenSessionInViewFilter 
2. applicationContext.xml配置OpenSessionInViewInterceptor 


request(请求)->open session并开始transaction->controller->View(Jsp)->结束transaction并 close session. 

但试想下如果对于大量连接, 流程中的某一步被阻塞的话, 就有连接池连接不足，造成页面假死现象

Open Session In View是个双刃剑，放在公网上内容多流量大的网站请慎用 

##### Benifit of IOC
* Makes it easier to **test your code**. Without it, the code you are testing is hard to isolate as it will be highly coupled to the rest of the system.
* 最小的代价和最小的侵入性使`松散耦合`得以实现. Useful when `developing modular systems`. You can replace components without requiring recompilation.
* IOC容器支持加载服务时的饿汉式初始化和懒加载

##### ApplicationContext implementations
* **FileSystemXmlApplicationContext**: 此容器从一个XML文件中加载beans的定义，XML Bean 配置文件的全路径名必须提供给它的构造函数。
* **ClassPathXmlApplicationContext**：此容器也从一个XML文件中加载beans的定义，这里，你需要正确设置classpath因为这个容器将在classpath里找bean配置。
* **XmlWebApplicationContext**: 此容器加载一个XML文件，此文件定义了一个WEB应用的所有bean
* **AnnotationConfigApplicationContext** or its web-capable variant, **AnnotationConfigWebApplicationContext**

##### Get ApplicationContext in web application
**WebApplicationContextUtils**：Convenience methods for retrieving the root WebApplicationContext for a given ServletContext. This is useful for programmatically accessing a Spring application context from within custom web views or MVC actions. 

**WebApplicationContextUtils**：从web应用的根目录读取配置文件，需要先在web.xml中配置，可以配置监听器或者servlet来实现 

1. ContextLoaderListener
```xml
<listener> 
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class> 
</listener>
```

2. ContextLoaderServlet
```xml
<servlet> 
    <servlet-name>context</servlet-name> 
    <servlet-class>org.springframework.web.context.ContextLoaderServlet</servlet-class>
    <load-on-startup>1</load-on-startup> 
</servlet> 
```
>The javadoc for ContextLoaderServlet says it all:
>>Note that this class has been deprecated for containers implementing Servlet API 2.4 or higher, in favor of ContextLoaderListener.

Apparently prior to Servlet API 2.4 the order in which listeners versus servlets are initialized is not mandated by the specification. So to ensure that the Spring context is correctly loaded before any other servlets in a Servlet 2.3 and lower container, you would need to use ContextLoaderServlet and put it as the first to load on startup.

这两种方式都默认配置文件为WEB-INF/applicationContext.xml，也可使用context-param指定配置文件
```xml 
<context-param>
    <param-name>contextConfigLocation</param-name>
    <param-value>/WEB-INF/dispatcher-servlet.xml</param-value>
</context-param>
<listener>
    <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
</listener>
```

3. for MVC, use DispatchServlet directly
```xml
<servlet>
    <servlet-name>spring</servlet-name>
    <servlet-class>
        org.springframework.web.servlet.DispatcherServlet
    </servlet-class>
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:applicationContext.xml,WEB-INF/spring-security.xml</param-value>
    </init-param>
    <load-on-startup>1</load-on-startup>
</servlet>
<servlet-mapping>
        <servlet-name>spring</servlet-name>
        <url-pattern>URL_PATTERN</url-pattern>
</servlet-mapping>
```

##### BeanFactory vs ApplicationContext

* BeanFactory负责读取bean配置文档，管理bean的加载，实例化，维护bean之间的依赖关系，负责bean的声明周期。 
* ApplicationContext除了提供上述BeanFactory所能提供的功能之外，还提供了更完整的框架功能

The Context module **inherits its features from the Beans module** and adds support for **internationalization** (using, for example, resource bundles), **event propagation**, **resource loading**, and **the transparent creation of contexts** by, for example, a Servlet container. The Context module **also supports Java EE features such as EJB, JMX, and basic remoting**. The **ApplicationContext** interface is the focal point of the Context module. **spring-context-support**provides support for `integrating common third-party libraries` into a Spring application context for caching (EhCache, Guava, JCache), mailing (JavaMail), scheduling (CommonJ, Quartz) and template engines (FreeMarker,JasperReports,Velocity).

##### Design pattern in Spring
* 代理模式—在AOP和remoting中被用的比较多
* 单例模式—在spring配置文件中定义的bean默认为单例模式
* 模板方法—用来解决代码重复的问题。比如. RestTemplate, JmsTemplate, JpaTemplate。
* 工厂模式—BeanFactory用来创建对象的实例。

J2EE design pattern
* 前端控制器—Spring提供了DispatcherServlet来对请求进行分发。???
* 视图帮助(View Helper) Spring提供了一系列的JSP标签，高效宏来辅助将分散的代码整合在视图里。??
* 依赖注入—贯穿于BeanFactory / ApplicationContext接口的核心理念。???

##### Spring inner bean

当一个bean仅被用作另一个bean的属性时，它能被声明为一个内部bean，为了定义inner bean，在Spring 的 基于XML的 配置元数据中，可以在 <property/>或 <constructor-arg/> 元素内使用<bean/> 元素，内部bean通常是匿名的，它们的Scope一般是prototype。

##### Factory Bean
A factory bean is a bean that serves as a factory for creating other beans within the IoC container.Conceptually, a factory bean is very similar to a factory method, but it is a Spring-specific bean that can be identified by the Spring IoC container during bean construction and can be used by container to instantiate other beans.

To create a factory bean, all you have to do is to implement the **FactoryBean** interface by your creator bean class which will be creating actual other beans. Or to keep it simple, you can extend **AbstractFactoryBean** class.

By extending the AbstractFactoryBean class, your factory bean can simply override the **createInstance()** method to create the target bean instance. In addition, you have to return the target bean’s type in the getObjectType() method for the auto-wiring feature to work properly.

Factory beans are mostly used to implement framework facilities. Here are some examples:
1. When looking up an object (such as a data source) from JNDI, you can use JndiObjectFactoryBean.
2. When using classic Spring AOP to create a proxy for a bean, you can use ProxyFactoryBean.
3. When creating a Hibernate session factory in the IoC container, you can use LocalSessionFactoryBean.

In most cases, you **rarely** have to write any custom factory beans, because they are framework-specific and `cannot be used outside the scope of the Spring IoC container`.

If you want to get the instance of EmployeeFactoryBean itself, then you can add an `“&” before the bean name`.

```java
public class EmployeeDTO {
    private Integer id;
}

public class EmployeeFactoryBean extends AbstractFactoryBean<Object> {
    private String designation;
    //This method will be called by container to create new instances
    @Override
    protected Object createInstance() throws Exception {
        EmployeeDTO employee = new EmployeeDTO();
        return employee;
    }
     //This method is required for autowiring to work correctly
    @Override
    public Class<EmployeeDTO> getObjectType() {
        return EmployeeDTO.class;
    }
}

// test codes
EmployeeDTO manager = (EmployeeDTO) context.getBean("manager"); 
EmployeeDTO director = (EmployeeDTO) context.getBean("director");

EmployeeFactoryBean factory = (EmployeeFactoryBean) context.getBean("&director");

```

```xml
<bean id="manager"  class="com.howtodoinjava.demo.factory.EmployeeFactoryBean">
    <property name="designation" value="Manager" />
</bean>
 
<bean id="director"  class="com.howtodoinjava.demo.factory.EmployeeFactoryBean">
    <property name="designation" value="Director" />
</bean>
```
##### Different aop sample codes
__不同类型的自动代理__  

So far we have created our proxy objects using the **ProxyFactoryBean** class. This works `fine for small applications` since there are not that many classes we want to advise. But when we have several, sometimes dozens of classes we want to advise, it becomes cumbersome to explicitly create every proxy.

Luckily, Spring has an autoproxy facility that enables the container to generate proxies for us. We do so in a very Springy way—we configure a bean to do the dirty work for us. Specifically, we create autoproxy creator beans. 

Spring comes with two classes that provide this support: BeanNameAutoProxyCreator and DefaultAdvisorAutoProxyCreator.

* BeanNameAutoProxyCreator
    Wild card match bean name

* DefaultAdvisorAutoProxyCreator
    It is important to point out this proxy creator only works with advisors. If you remember, an advisor is a construct that combines a pointcut and advice. The DefaultAdvisorAutoProxyCreator needs the advisors to let it know what beans it should advise.

* AspectJAwareAdvisorAutoProxyCreator

__Examples of different proxy creating methods:__  

Common codes:
```java
public class CustomerService
{
    private String name;
    private String url;
    public void printName(){
        System.out.println("Customer name : " + this.name);
    }
    // ...
}
```

```xml
<bean id="customerService" class="com.mkyong.customer.services.CustomerService" />

<bean id="hijackAroundMethodBeanAdvice" class="com.mkyong.aop.HijackAroundMethod" />

<bean id="customerAdvisor"
    class="org.springframework.aop.support.NameMatchMethodPointcutAdvisor">
    <property name="mappedName" value="printName" />
    <property name="advice" ref="hijackAroundMethodBeanAdvice" />
</bean>
```

1. use ProxyFactoryBean
get the **proxied bean instance explicitly** by proxy bean name “customerServiceProxy”, but rather by bean name itself "customerService"
```xml
<bean id="customerServiceProxy"
    class="org.springframework.aop.framework.ProxyFactoryBean">
    <property name="target" ref="customerService" />
    <property name="interceptorNames">
        <list>
            <value>customerAdvisor</value>
        </list>
    </property>
</bean>
```

```java
CustomerService cust = (CustomerService)appContext.getBean("customerServiceProxy");
cust.printName();
```
2. BeanNameAutoProxyCreator
include all your beans (via bean name, or regular expression name)
```java
CustomerService cust = (CustomerService)appContext.getBean("customerService");
cust.printName();
```

```xml
<bean class="org.springframework.aop.framework.autoproxy.BeanNameAutoProxyCreator">
    <property name="beanNames">
        <list>
        <value>*Service</value>
        </list>
    </property>
    <property name="interceptorNames">
        <list>
            <value>customerAdvisor</value>
        </list>
    </property>
</bean>
```

3. DefaultAdvisorAutoProxyCreator
```java
CustomerService cust = (CustomerService)appContext.getBean("customerService");
cust.printName();
```

```xml
<bean class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator" />
```

__Metadata autoproxying__  
Spring also supports auto proxying driven by metadata. In this type of autoproxying, the proxy configuration is determined by source-level attributes as opposed to external configuration (e.g., an XML file). This is quite powerful since it keeps the AOP metadata with the source code that is being advised, letting you keep your code and configuration metadata in one place.

##### Spring MVC
![spring_mvc_1]

* The process starts when a client (typically a web browser) sends a request (1). The first component to receive the request is Spring’s DispatcherServlet. Like most Java-based MVC frameworks, Spring MVC funnels requests through a single front controller servlet. A **front controller** is a common web-application pattern where a single servlet delegates responsibility for a request to other components of an application to perform the actual processing. In the case of Spring MVC, **DispatcherServlet** is the front controller.

* The Spring MVC component that is responsible for handling the request is a
Controller. To figure out which controller should handle the request, DispatcherServlet starts by querying one or more **HandlerMappings** (2). A HandlerMapping typically performs its job by mapping URL patterns to Controller objects.

* Once the DispatcherServlet has a **Controller** object, it dispatches the request to the Controller to perform whatever business logic it was designed to do (3). (Actually, a well-designed Controller performs little or no business logic itself and instead delegates responsibility for the business logic to one or more service objects.) Upon completion of business logic, the Controller returns a ModelAndView object(4) to the DispatcherServlet. 

* The **ModelAndView** can either contain a View object or a logical name of a View object. If the ModelAndView object contains the logical name of a View, the Dispatcher-Servlet queries a **ViewResolver** (5) to look up the View object that will render the response. 

* Finally, the DispatcherServlet dispatches the request to the View
object (6) indicated by the ModelAndView object. The View object is responsible for rendering a response back to the client.

### Hibernate

#### Hibernate architecture and key components
![hibernate-architecture-1]

#### Hibernate performance tuning
* fetching strategy and timing
* API 的选择以及语法细节
    - 对大数据量查询时，慎用list()(HibernateTemplate.find)或者iterator()(HibernateTemplate.iterate)返回查询结果. 对于大数据量，使用Query.scroll()(ScrollableResults)可以得到较好的处理速度以及性能。而且直接对结果集向前向后滚动??
    - Dynamic Update/Insert 如果选定，则生成Update/Insert SQL 时不包含未发生变动的字段属性，这样可以在一定程度上提升SQL执行效能.
    - 在编写代码的时候请，对将POJO的getter/setter方法设定为public，如果设定为private，Hibernate将无法对属性的存取进行优化，只能转而采用传统的反射机制进行操作，这将导致大量的性能开销（特别是在1.4之前的Sun JDK版本以及IBM JDK中，反射所带来的系统开销相当可观） 
* Collection 及 mapping的正确使用
    - In well-designed Hibernate domain models, most collections are in fact one-to-many associations with inverse="true".
    - For inverse collections 
        Bags and lists are the most efficient inverse collections.
    - For non-inverse collections
        After observing that arrays cannot be lazy, you can conclude that lists, maps and idbags are the most performant (non-inverse) collection types, with sets not far behind. You can expect sets to be the most common kind of collection in Hibernate applications. This is because the "set" semantics are most natural in the relational model.
    - 由于多对多关联的性能不佳（由于引入了中间表，一次读取操作需要反复数次查询），因此在设计中应该避免大量使用

* Cascade 的设定. 对含有关联的PO（持久化对象）时，若default-cascade="all"或者 “save-update”，新增PO时，请注意对PO中的集合的赋值操作，因为有可能使得多执行一次update操作。

* Second level cache & Query Cache
    [For more information][hibernate-caching-2]
* 减少主键生成开销
    不过值得注意的是，一些数据库提供的主键生成机制在效率上未必最佳，大量并发insert数据时可能会引起表之间的互锁。数据库提供的主键生成机制，往往是通过在一个内部表中保存当前主键状态（如对于自增型主键而言，此内部表中就维护着当前的最大值和递增量），之后每次插入数据会读取这个最大值，然后加上递增量作为新记录的主键，之后再把这个新的最大值更新回内部表中，这样，一次Insert操作可能导致数据库内部多次表读写操作，同时伴随的还有数据的加锁解锁操作，这对性能产生了较大影响。因此，对于并发Insert要求较高的系统，推荐采用`uuid.hex` 作为主键生成机制。

* 使用JDBC批处理插入/更新
    - Hibernate可以通过设置hibernate.jdbc.fetch_size，hibernate.jdbc.batch_size等属性，对Hibernate进行优化。
    - 针对oracle数据库而言，Fetch Size 是设定JDBC的Statement读取数据的时候每次从数据库中取出的记录条数，一般设置为30、50、100。Oracle数据库的JDBC驱动默认的Fetch Size=15，设置Fetch Size设置为：30、50，性能会有明显提升，如果继续增大，超出100，性能提升不明显，反而会消耗内存。
    - 批量操作
    即使是使用JDBC，在进行大批数据更新时，BATCH与不使用BATCH有效率上也有很大的差别。我们可以通过设置batch_size来让其支持批量操作。
    举个例子，要批量删除某表中的对象，如“delete Account”，打出来的语句，会发现HIBERNATE找出了所有ACCOUNT的ID，再进行删除，这主要是为了维护二级缓存，这样效率肯定高不了，在后续的版本中增加了bulk delete/update，但这也无法解决缓存的维护问题。也就是说，由于有了二级缓存的维护问题，HIBERNATE的批量操作效率并不尽如人意!
```xml
<prop key="hibernate.jdbc.batch_size">100</prop>
<prop key="hibernate.order_inserts">true</prop>
<prop key="hibernate.order_updates">true</prop>
```

* 定期刷新和清理Hibernate Session Cache
entityManager.flush();
entityManager.clear();
在处理大数据量时，会有大量的数据缓冲保存在Session的一级缓存中，这缓存大太时会严重显示性能，所以在使用Hibernate处理大数据量的，可以使用Session.clear()或者Session.evict(Object) 在处理过程中，清除全部的缓存或者清除某个对象。

* 减少Hibernate过多的dirty-checking  
    如何避免dirty-checking？
    - @Transactional(readOnly=true)
    - Hibernate Stateless Session

* 事务控制
    事务方面对性能有影响的主要包括:事务方式的选用，事务隔离级别以及锁的选用  
    - 事务方式选用
        如果不涉及多个事务管理器事务的话，不需要使用JTA，只有JDBC的事务控制就可以。
　　- 事务隔离级别
        参见标准的SQL事务隔离级别
　　- 锁的选用
        悲观锁(一般由具体的事务管理器实现)，对于长事务效率低，但安全。乐观锁(一般在应用级别实现)，如在HIBERNATE中可以定义VERSION字段，显然，如果有多个应用操作数据，且这些应用不是用同一种乐观锁机制，则乐观锁会失效。

* 如果是超大的系统，建议生成htm文件。加快页面提升速度。

* 生产系统中，切记要关掉SQL语句打印

##### Top 10 Hibernate Performance Tuning Tips
1. Avoid join duplicates (AKA cartesian products) due to joins along two or more parallel to-many associations; use Exists-subqueries, multiple queries or fetch="subselect" (see (2)) instead - whatever is most appropriate in the specific situation. Join duplicates are already pretty bad in plain SQL, but things get even worse when they occur within Hibernate, because of unnecessary mapping workload and child collections containing duplicates.
 
2. Define lazy loading as the preferred association loading strategy, and consider applying fetch="subselect" rather than "select" resp. "batch-size". Configure eager loading only for special associations, but join-fetch selectively on a per-query basis.
 
3. `In case of read-only services with huge query resultsets`, use projections and fetch into flat DTOs (e.g. via **AliasToBeanResultTransformer**), instead of loading thousands of mapped objects into the Session.
 
4. Take advantage of `HQL Bulk Update and Delete statements`, as well as `Insert-By-Select` (supported by HQL as well).
 
5. Set FlushMode to "Never" on Queries and Criteria, when flushing is not necessary at this point.
 
6. Set ReadOnly to "true" on Queries and Criteria, when objects returned will never be modified.
 
7. Consider clearing the whole Session after flushing, or evict on a per-object basis, once objects are not longer needed.
 
8. Define a suitable value for jdbc.batch_size (resp. adonet.batch_size under NHibernate).
 
9. Use Hibernate Query-Cache and Second Level Caching where appropriate (but go sure you are aware of the consequences).
 
10. Set hibernate.show_sql to "false" and ensure that Hibernate logging is running at the lowest possible loglevel (also check log4j/log4net root logger configuration).

##### Understanding Hibernate Collection performance

Lazy fetching for collections is implemented using `Hibernate's own implementation of persistent collections`. 

__Hibernate defines 3 basic kinds of collections:__  
* collections of values
* one-to-many associations
* many-to-many associations

we must also consider the structure of the primary key that is used by Hibernate to update or delete collection rows. This suggests the following classification:  
* indexed collections
* sets
* bags

`In well-designed Hibernate domain models, most collections are in fact one-to-many associations with inverse="true".`

In conclusion, 
* For inverse collections 
Bags and lists are the most efficient inverse collections.
* For non-inverse collections
After observing that arrays cannot be lazy, you can conclude that lists, maps and idbags are the most performant (non-inverse) collection types, with sets not far behind. You can expect sets to be the most common kind of collection in Hibernate applications. This is because the "set" semantics are most natural in the relational model.

Bags and lists are the most efficient inverse collections.
There is a particular case, however, in which bags, and also lists, are much more performant than sets. `For a collection with inverse="true", the standard bidirectional one-to-many relationship idiom, for example, we can add elements to a bag or list without needing to initialize (fetch) the bag elements. This is because, unlike a set, Collection.add() or Collection.addAll() must always return true for a bag or List(PS: in other word, set may return false if it find out that there is any duplication, that's why set nees to initialize its elements before adding new ones).` This can make the following common code much faster:

```java
Parent p = (Parent) sess.load(Parent.class, id);
Child c = new Child();
c.setParent(p);
p.getChildren().add(c); //no need to fetch the collection!
sess.flush();
```


`All indexed collections (maps, lists, and arrays)` have a primary key consisting of the \<key\> and \<index\> columns. In this case, collection updates are extremely efficient. The primary key can be efficiently indexed and a particular row can be efficiently located when Hibernate tries to update or delete it.

Sets have a primary key consisting of \<key\> and element columns. This can be less efficient for some types of collection element, particularly composite elements or large text or binary fields, as the database may not be able to index a complex primary key as efficiently. However, for one-to-many or many-to-many associations, particularly in the case of synthetic identifiers, it is likely to be just as efficient. 

idbag mappings define a surrogate key, so they are efficient to update. In fact, they are the best case.

Bags are the worst case since they permit duplicate element values and, as they have no index column, no primary key can be defined. Hibernate has no way of distinguishing between duplicate rows. Hibernate resolves this problem by completely removing in a single DELETE and recreating the collection whenever it changes. This can be inefficient.

##### Hibernate one shot delete
However, suppose that we remove 18 elements, leaving 2 and then add 3 new elements. There are two possible ways to proceed
* delete eighteen rows one by one and then insert three rows
* remove the whole collection in one SQL DELETE and insert all five current elements one by one

Hibernate cannot know that the second option is probably quicker. It would probably be undesirable for Hibernate to be that intuitive as such behavior might confuse database triggers, etc.

Fortunately, you can force this behavior (i.e. the second strategy) at any time by discarding (i.e. dereferencing) the original collection and returning a newly instantiated collection with all the current elements.

One-shot-delete does not apply to collections mapped inverse="true".

#### Hibernate APIs

##### Session#load vs Session#get

__Hibernate3.2 Session加载数据时get和load方法的区别__  

1. get方法, hibernate会确认一下该id对应的数据是否存在，首先在session缓存中查找，然后在二级缓存中查找，还没有就查询数据库，数据库中没有就返回null。主要要说明的一点就是在这个版本中get方法也会查找二级缓存！
 
2. load方法, 加载实体对象的时候，根据映射文件上类级别的lazy属性的配置(默认为true),分情况讨论：
    1. 若为true,则首先在Session缓存中查找，看看该id对应的对象是否存在，不存在则使用延迟加载，返回实体的代理类对象(该代理类为实体类的子类，由CGLIB动态生成)。等到具体使用该对象(除获取OID以外)的时候，再查询二级缓存和数据库，若仍没发现符合条件的记录，则会抛出一个ObjectNotFoundException。
    2. 若为false,就跟get方法查找顺序一样，只是最终若没发现符合条件的记录，则会抛出一个ObjectNotFoundException。
 
这里get和load有两个重要区别:
1. 如果未能发现符合条件的记录，get方法返回null，而load方法会抛出一个ObjectNotFoundException。
2. load方法可返回没有加载实体数据的代理类实例，而`get方法永远返回有实体数据的对象`。(对于load和get方法返回类型：好多书中都说：“get方法永远只返回实体类”，实际上并不正确，get方法如果在session缓存中找到了该id对应的对象，如果刚好该对象前面是被代理过的，如被load方法使用过，或者被其他关联对象延迟加载过，那么返回的还是原先的代理对象，而不是实体类对象，如果该代理对象还没有加载实体数据（就是id以外的其他属性数据），那么它会查询二级缓存或者数据库来加载数据，但是返回的还是代理对象，只不过已经加载了实体数据。)
 
总之对于get和load的根本区别，一句话，hibernate对于load方法认为该数据在数据库中一定存在，可以放心的使用代理来延迟加载，如果在使用过程中发现了问题，只能抛异常；而对于get方法，hibernate一定要获取到真实的数据，否则返回null。

##### Session#persist

persist() makes a transient instance persistent. However, `it does not guarantee that the identifier value will be assigned to the persistent instance immediately`, the assignment might happen at flush time. `persist() also guarantees that it will not execute an INSERT statement if it is called outside of transaction boundaries`. This is useful in long-running conversations with an extended Session/persistence context.

##### Session#save
`save() does guarantee to return an identifier`. If an INSERT has to be executed to get the identifier ( e.g. "identity" generator, not "sequence"), `this INSERT happens immediately, no matter if you are inside or outside of a transaction`. This is problematic in a long-running conversation with an extended Session/persistence context.

##### Session#update vs Session#merge vs Session#lock
Hibernate supports this model by providing for reattachment of detached instances using the **Session.update()** or **Session.merge()** methods (**Session.lock()** as well)

Use update() if you are certain that the session does not contain an already persistent instance with the same identifier. Use merge() if you want to merge your modifications at any time without consideration of the state of the session. In other words, update() is usually the first method you would call in a fresh session, ensuring that the reattachment of your detached instances is the first operation that is executed.

Usually update() or saveOrUpdate() are used in the following scenario:
* the application loads an object in the first session
* the object is passed up to the UI tier
* some modifications are made to the object
* the object is passed back down to the business logic tier
* the application persists these modifications by calling update() in a second session

可以把映射文件中\<class\>元素的select-before-update设为true,默认false,修改后会先执行select进行比较.

__Session.update__  
Update the persistent instance with the identifier of the given detached instance. If there is a persistent instance with the same identifier, an exception is thrown. 

This operation cascades to associated instances if the association is mapped with cascade="save-update"

__Session.merge__  
and merge() is very different:
* if there is a persistent instance with the same identifier currently associated with the session, copy the state of the given object onto the persistent instance
* if there is no persistent instance currently associated with the session, try to load it from the database, or create a new persistent instance
* the persistent instance is returned
* the given instance does not become associated with the session, it remains detached

merge()方法处理流程:
1. 根据游离对象的OID到session缓存中查找匹配的持久化对象.
2. 如果在缓存中没有找到与游离对象的OID一致的持久化对象,就根据这个OID从数据库中加载持久化对象.如果在数据库中存在这样的持久化对象,就把游离对象的属性复制到这个刚加载的持久化对象中,计划执行一条update语句,再返回这个持久化对象的引用.
3. 如果merge()方法的参数是一个临时对象,那么也会创建一个新的对象,把临时对象的属性复制到这个新建的对象中,再调用save()方法持久化这个独享,最后返回这个持久化对象的引用.

This operation cascades to associated instances if the association is mapped with cascade="merge"

The semantics of this method are defined by JSR-220.

__Session.lock()__  
The lock() method also allows an application to reassociate an object with a new session. However, the detached instance has to be `unmodified`.

Deprecated. instead call Session.buildLockRequest(LockMode).lock(object)
Obtain the specified lock level upon the given object. 

This may be used to 
* perform a version check (**LockMode.READ**) 
* to upgrade to a pessimistic lock (**LockMode.PESSIMISTIC_WRITE**)
* to simply reassociate a transient instance with a session (**LockMode.NONE**)
 
This operation cascades to associated instances if the association is mapped with cascade="lock".

##### Session#saveOrUpdate
saveOrUpdate() does the following:
* if the object is already persistent in this session, do nothing
* if another object associated with the session has the same identifier, throw an exception
* if it is a new object, save it
    - if the object has no identifier property
    - if the object's identifier has the value assigned to a newly instantiated object
    - if the object is versioned by a <version> or <timestamp>, and the version property value is the same value assigned to a newly instantiated object
* otherwise update() the object

##### Session#delete
Session.delete() will remove an object's state from the database. Your application, however, can still hold a reference to a deleted object. It is best to think of delete() as making a persistent instance transient.

__void delete(Object object)__  
Remove a persistent instance from the datastore. The argument may be an instance associated with the receiving Session or a transient instance with an identifier associated with existing persistent state. 

This operation cascades to associated instances if the association is mapped with cascade="delete"

delete()方法处理过程:
1. `如果参数是游离态对象,先使游离态对象被当前session关联,使它变为持久态对象`.如果参数是持久态对象则忽略这一步.此步骤确保使用拦截器的场合下,拦截器能正常工作.
2.计划执行一个delete语句
3.把对象从Session缓存中删除,该对象进入transient状态.

##### Session#replicate
It is sometimes useful to be able to take a graph of persistent instances and make them persistent in a different datastore, `without regenerating identifier values`.

The ReplicationMode determines how replicate() will deal with conflicts with existing rows in the database:
• ReplicationMode.IGNORE: ignores the object when there is an existing database row with the same identifier
• ReplicationMode.OVERWRITE: overwrites any existing database row with the same identifier
• ReplicationMode.EXCEPTION: throws an exception if there is an existing database row with the same identifier
• ReplicationMode.LATEST_VERSION: overwrites the row if its version number is earlier than the version number of the object, or ignore the object otherwise

##### Query#list vs Query#iterate

__list()__  
>public List list() throws HibernateException
>>Return the query results as a List. If the query contains multiple results pre row, the results are returned in an instance of Object[].

* With one database hit, all the records are loaded
* if no cache data is available, this is faster, or else, it is slower
* Eager loading

在执行Query.list时，Hibernate的做法是首先检查是否配置了`查询缓存`，如配置了则从查询缓存中查找key为查询语句+查询参数+分页条件的值，如获取不到则从数据库中进行获取，从数据库获取到后Hibernate将会相应的`填充一级、二级和查询缓存`，如获取到的为直接的结果集，则直接返回，如获取到的为一堆id的值，则再根据id获取相应的值(Session.load)，最后形成结果集返回，可以看到，在这样的情况下，`list也是有可能造成N次的查询的`。

查询缓存在数据发生任何变化的情况下都会被自动的清空。

list只能利用查询缓存(但在交易系统中查询缓存作用不大)，无法利用二级缓存中的单个实体，但list查出的对象会写入二级缓存

__iterate()__  
>public Iterator iterate() throws HibernateException
>>Return the query results as an Iterator. If the query contains multiple results pre row, the results are returned in an instance of Object[].  
Entities returned as results are `initialized on demand`.` The first SQL query returns identifiers only.`

* The first SQL query returns identifiers only, and for each record, one database hit is made, "N+1 problem"
* if no chache data is available, this is very slower, or else, it is faster
* Lazy loading

From P109/117 Hibernate Reference Documentation Version: 3.1 rc3
Occasionally, you might be able to achieve better performance by executing the query using the iterate() method. This will only usually be the case if you expect that the actual entity instances returned by the query will already be in the session or second-level cache. If they are not already cached, iterate() will be slower than list() and might require many database hits for a simple query, usually 1 for the initial select which only returns identifiers, and n additional selects to initialize the actual instances.

##### SessionFactory#getCurrentSession
From P8/16 Hibernate Reference Documentation Version: 3.1 rc3

```xml
<!-- Enable Hibernate's automatic session context management -->
<property name="current_session_context_class">thread</property>
```

What does sessionFactory.getCurrentSession() do? First, you can call it as many times and anywhere you like, once you get hold of your SessionFactory (easy thanks to HibernateUtil). The getCurrentSession() method always returns the "current" unit of work. Remember that we switched the configuration option for this mechanism to "thread" in hibernate.cfg.xml? Hence, the scope of the current unit of work is the current Java thread that executes our application. However, this is not the full truth. A Session begins when it is first needed, when the first call to getCurrentSession() is made. It is then bound by Hibernate to the current thread. When the transaction ends, either committed or rolled back, `Hibernate also unbinds the Session from the thread and closes it for you`. If you call getCurrentSession() again, you get `a new Session` and can start a new unit of work. This thread-bound programming model is the most popular way of using Hibernate.

##### Session#createFilter
Sometimes you do not want to initialize a large collection, but still need some information about it, like its size, for example, or a subset of the data.
You can use a collection filter to get the size of a collection without initializing it:

The createFilter() method is also used to efficiently retrieve subsets of a collection without needing to initialize the whole collection:

```java
((Integer)s.createFilter(collection, "select count(*)").list().get(0)).intValue();

s.createFilter(lazyCollection, "").setFirstResult(0).setMaxResults(10).list();
```

##### Hibernate#initialize
The static methods **Hibernate.initialize()** and Hibernate.isInitialized(), provide the application with a convenient way of working with lazily initialized collections or proxies.

#### Hibernate Misc

##### Object states of hibernate

![hibernate-object-state-1]

Hibernate的对象有3种状态,分别为:瞬时态(Transient)、持久态(Persistent)、脱管态(Detached).处于持久态的对象也称为PO(PersistenceObject),瞬时对象和脱管对象也称为VO(ValueObject).

* 瞬时态
由new命令开辟内存空间的java对象,
eg.Person person=new Person("xiaoxiao","女");
如果没有变量对该对象进行引用,它将被java虚拟机回收.
瞬时对象在内存孤立存在,它是携带信息的载体,不和数据库的数据有任何关联关系,在Hibernate中,可通过session的save()或saveOrUpdate()方法将瞬时对象与数据库相关联,并将数据对应的插入数据库中,此时该瞬时对象转变成持久化对象.

持久对象具有如下特点:
1.和session实例关联;
2.在数据库中有与之关联的记录.

* 持久态
处于该状态的对象在数据库中具有对应的记录,并拥有一个持久化标识.如果是用hibernate的delete()方法,对应的持久对象就变成瞬时对象,因数据库中的对应数据已被删除,该对象不再与数据库的记录关联.

* 脱管态
当一个session执行close()或clear()、evict()之后,持久对象变成脱管对象,此时持久对象会变成脱管对象,此时`该对象虽然具有数据库识别值`,但它已不在HIbernate持久层的管理之下.

脱管态
当与某持久对象关联的session被关闭后,该持久对象转变为脱管对象.当脱管对象被重新关联到session上时,并再次转变成持久对象.
脱管对象拥有数据库的识别值,可通过update()、saveOrUpdate()等方法,转变成持久对象.
脱管对象具有如下特点:
1.本质上与瞬时对象相同,在没有任何变量引用它时,JVM会在适当的时候将它回收;
2.比瞬时对象多了一个数据库记录标识值.

__Distinguishing between transient and detached instances__  
* either identifier/version property (if it exists) is null or matches unsave-value
* You supply a Hibernate Interceptor and return Boolean.TRUE from Interceptor.
isUnsaved() after checking the instance in your code.

##### pros and cons of Hibernate
* 内存消耗
* 运行效率
* 开发效率
* Learning curve
* OLTP vs OLAP

__pros:__ 

__cons:__  
1. Hibernate在批量数据处理的时候是有弱势。针对某一对象(单个对象)简单的查\改\删\增，不是批量修改、删除，适合用Hibernate；而对于批量修改、删除，不适合用Hibernate，这也是OR框架的弱点
2. 要使用数据库的特定优化机制的时候，不适合用Hibernate


##### Process of loading entity in Session
__Session在加载实体对象的过程__  
1. 首先在第一级缓存中，通过实体类型和id进行查找，如果第一级缓存查找命中，且数据状态合法，则直接返回。
2. 之后，Session会在当前`“NonExists”`记录中进行查找，如果“NonExists”记录中存在同样的查询条件，则返回null。
3. 对于load方法而言，如果内部缓存中未发现有效数据，则查询第二级缓存，如果第二级缓存命中，则返回。
4. 如在缓存中未发现有效数据，则发起数据库查询操作（Select SQL），如经过查询未发现对应记录，则将此次查询的信息在“NonExists”中加以记录，并返回null。
5. 根据映射配置和Select SQL得到的ResultSet，创建对应的数据对象。
6. 将其数据对象纳入当前Session实体管理容器（一级缓存）。
7. 执行Interceptor.onLoad方法（如果有对应的Interceptor）。
8. 将数据对象纳入二级缓存。
9. 如果数据对象实现了LifeCycle接口，则调用数据对象的onLoad方法。
10. 返回数据对象。

##### Primary key generation in Hibernate

1. assigned
主键由外部程序负责生成，无需Hibernate参与。
2. hilo
通过hi/lo 算法实现的主键生成机制，需要额外的数据库表保存主键生成历史状态。
3. seqhilo
与hilo 类似，通过hi/lo 算法实现的主键生成机制，只是主键历史状态保存在Sequence中，适用于支持Sequence的数据库，如Oracle。
4. increment
主键按数值顺序递增。此方式的实现机制为在当前应用实例中维持一个变量，以保存着当前的最大值，之后每次需要生成主键的时候将此值加1作为主键。这种方式可能产生的问题是：如果当前有多个实例访问同一个数据库，那么由于各个实例各自维护主键状态，不同实例可能生成同样的主键，从而造成主键重复异常。因此，如果同一数据库有多个实例访问，此方式必须避免使用。
5. identity
采用数据库提供的主键生成机制。如DB2、SQL Server、MySQL中的主键生成机制。
6. sequence
采用数据库提供的sequence 机制生成主键。如Oralce 中的Sequence。
7. native
由Hibernate根据底层数据库自行判断采用identity、hilo、sequence其中一种作为主键生成方式
8. uuid.hex
由Hibernate基于128 位唯一值产生算法生成16进制数值（编码后以长度32 的字符串表示）作为主键。
9. uuid.string
与uuid.hex 类似，只是生成的主键未进行编码（长度16）。在某些数据库中可能出现问题（如PostgreSQL）。
10. foreign
使用外部表的字段作为主键。

* 一般而言，利用`uuid.hex`方式生成主键将提供最好的性能和数据库平台适应性。
* increment 比较常用,把标识符生成的权力交给Hibernate处理.
* 但是当同时多个Hibernate应用操作同一个数据库,甚至同一张表的时候.就推荐使用identity 依赖底层数据库实现,但是数据库必须支持自动增长
* 当然针对不同的数据库选择不同的方法.如果你不能确定你使用的数据库具体支持什么的情况下.可以选择用native 让Hibernate来帮选择identity,sequence,或hilo.
另外由于常用的数据库，如Oracle、DB2、SQLServer、MySql 等，都提供了易用的主键生成机制（Auto-Increase 字段或者Sequence）。我们可以在数据库提供的主键生成机制上，采用generator-class=native的主键生成方式。

不过值得注意的是，一些数据库提供的主键生成机制在效率上未必最佳，大量并发insert数据时可能会引起表之间的互锁。数据库提供的主键生成机制，往往是通过在一个内部表中保存当前主键状态（如对于自增型主键而言，此内部表中就维护着当前的最大值和递增量），之后每次插入数据会读取这个最大值，然后加上递增量作为新记录的主键，之后再把这个新的最大值更新回内部表中，这样，一次Insert操作可能导致数据库内部多次表读写操作，同时伴随的还有数据的加锁解锁操作，这对性能产生了较大影响。`因此，对于并发Insert要求较高的系统，推荐采用uuid.hex 作为主键生成机制`

##### Stateless session

StatelessSession is a command-oriented API provided by Hibernate. Use it to stream data to and from the database in the form of detached objects. A StatelessSession has no persistence context associated with it and does not provide many of the higher-level life cycle semantics. 

__Features and behaviors not provided by StatelessSession__  
* a first-level cache
* interaction with any second-level or query cache
* transactional write-behind or automatic dirty checking

__Limitations of StatelessSession__  
* Operations performed using a stateless session never cascade to associated instances.
* Collections are ignored by a stateless session.
* Operations performed via a stateless session bypass Hibernate's event model and interceptors.
* Due to the lack of a first-level cache, Stateless sessions are vulnerable to data aliasing effects.
* A stateless session is a lower-level abstraction that is much closer to the underlying JDBC.

##### Open Session In View

Another option is to keep the Session open until all required collections and proxies have been loaded. In some application architectures, particularly where the code that accesses data using Hibernate, and the code that uses it are in different application layers or different physical processes, it can be a problem to ensure that the Session is open when a collection is initialized.

There are two basic ways to deal with this issue:
* In a web-based application, a servlet filter can be used to close the Session only at the end of a user request, once the rendering of the view is complete (the Open Session in View pattern). Of course, this places heavy demands on the correctness of the exception handling of your application infrastructure. It is vitally important that the Session is closed and the transaction ended before returning to the user, even when an exception occurs during rendering of the view. See the Hibernate Wiki for examples of this "Open Session in View" pattern.

* In an application with a separate business tier, the business logic must "prepare" all collections that the web tier needs before returning. This means that the business tier should load all the data and return all the data already initialized to the presentation/web tier that is required for a
particular use case. Usually, the application calls **Hibernate.initialize()** for each collection that will be needed in the web tier (this call must occur before the session is closed) or `retrieves the collection eagerly using a Hibernate query with a FETCH clause or a FetchMode.JOIN in Criteria`. This is usually easier if you adopt the Command pattern instead of a Session Facade.

You can also attach a previously loaded object to a new Session with merge() or lock() before accessing uninitialized collections or other proxies. Hibernate does not, and certainly should not, do this automatically since it would introduce impromptu transaction semantics.

##### Fecthing strategy and timing

We have two orthogonal notions here: `when` is the association fetched and `how` is it fetched. It is important that you do not confuse them. We use fetch to tune performance. We can use lazy to define a contract for what data is always available in any detached instance of a particular class.

__(when) Hibernate also distinguishes between:__  
* Immediate fetching: an association, collection or attribute is fetched immediately when the owner is loaded.
* Lazy collection fetching: a collection is fetched when the application invokes an operation upon that collection. This is the default for collections.
* "Extra-lazy" collection fetching: individual elements of the collection are accessed from the database as needed. Hibernate tries not to fetch the whole collection into memory unless absolutely needed. It is suitable for large collections.
* Proxy fetching: a single-valued association is fetched when a method other than the identifier getter is invoked upon the associated object.
* "No-proxy" fetching: a single-valued association is fetched when the instance variable is accessed. Compared to proxy fetching, this approach is less lazy; the association is fetched even when only the identifier is accessed. It is also more transparent, since no proxy is visible to the application. This approach requires buildtime bytecode instrumentation and is rarely necessary.
* Lazy attribute fetching: an attribute or single valued association is fetched when the instance variable is accessed. This approach requires buildtime bytecode instrumentation and is rarely necessary.

__(how) Hibernate3 defines the following fetching strategies:__
* Join fetching: Hibernate retrieves the associated instance or collection in the same SELECT,using an OUTER JOIN.
* Select fetching: a second SELECT is used to retrieve the associated entity or collection. Unless you explicitly disable lazy fetching by specifying lazy="false", this second select will only be executed when you access the association.
* Subselect fetching: a second SELECT is used to retrieve the associated collections for all entities retrieved in a previous query or fetch. Unless you explicitly disable lazy fetching by specifying lazy="false", this second select will only be executed when you access the association.
* Batch fetching: an optimization strategy for select fetching. Hibernate retrieves a batch of entity instances or collections in a single SELECT by specifying a list of primary or foreign keys.

* fetch-“join” = Disable the lazy loading, always load all the collections and entities.
* fetch-“select” (default) = Lazy load all the collections and entities.
* batch-size=”N” = Fetching up to ‘N’ collections or entities, but *Not N records*.  
The batch-size fetching strategy is not define how many records inside in the collections are loaded. Instead, it defines how many collections should be loaded.
* fetch-“subselect” = Group its collection into a sub select statement.

__Examples of different strategies:__ 

[For more information][hibernate-fecthing-strategy-1]

Configuration in xml,
```xml
<hibernate-mapping>
    <class name="com.mkyong.common.Stock" table="stock">
        <set name="stockDailyRecords"  cascade="all" inverse="true" 
            table="stock_daily_record" batch-size="10" fetch="select">
            <key>
                <column name="STOCK_ID" not-null="true" />
            </key>
            <one-to-many class="com.mkyong.common.StockDailyRecord" />
        </set>
    </class>
</hibernate-mapping>
```
the same configuration by Annotation,
```java
@Entity
@Table(name = "stock", catalog = "mkyong")
public class Stock implements Serializable{
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "stock")
    @Cascade(CascadeType.ALL)
    @Fetch(FetchMode.SELECT)
        @BatchSize(size = 10)
    public Set<StockDailyRecord> getStockDailyRecords() {
        return this.stockDailyRecords;
    }
}
```

Testing codes for strategy 1, 2, 3:
```java
Stock stock = (Stock)session.get(Stock.class, 114);
Set sets = stock.getStockDailyRecords();

for ( Iterator iter = sets.iterator();iter.hasNext(); ) {
      StockDailyRecord sdr = (StockDailyRecord) iter.next();
      System.out.println(sdr.getDailyRecordId());
      System.out.println(sdr.getDate());
}
```

1. fetch=”select” or @Fetch(FetchMode.SELECT)
```sql
Output:
1 time:
    select ...from mkyong.stock
    where stock0_.STOCK_ID=?

1 times:
    select ...from mkyong.stock_daily_record
    where stockdaily0_.STOCK_ID=?
```

Hibernate generated 2 select statements
* 1 Select statement to retrieve the Stock records –session.get(Stock.class, 114)
* 1 Select its related collections – sets.iterator()

2. fetch=”join” or @Fetch(FetchMode.JOIN)
```sql
Output:
1 time: 
    select ...
    from
        mkyong.stock stock0_ 
    left outer join
        mkyong.stock_daily_record stockdaily1_ 
            on stock0_.STOCK_ID=stockdaily1_.STOCK_ID 
    where
        stock0_.STOCK_ID=?
```
Hibernate generated only 1 select statement, it retrieve all its related collections when the Stock is initialized. –session.get(Stock.class, 114)

3. batch-size=”10″ or @BatchSize(size = 10)
```sql
Output:
1 time:
    select ...from mkyong.stock
    where stock0_.STOCK_ID=?

1 times:
    select ...from mkyong.stock_daily_record
    where stockdaily0_.STOCK_ID=?
```

Hibernate generated 2 select statements
* 1 Select statement to retrieve the Stock records –session.get(Stock.class, 114)
* 1 Select its related collections – sets.iterator()

__Another example__  

Let see another example, you want to print out all the stock records and its related stock daily records (collections) one by one.

```java
List<Stock> list = session.createQuery("from Stock").list();

for(Stock stock : list){

    Set sets = stock.getStockDailyRecords();

    for ( Iterator iter = sets.iterator();iter.hasNext(); ) {
            StockDailyRecord sdr = (StockDailyRecord) iter.next();
            System.out.println(sdr.getDailyRecordId());
            System.out.println(sdr.getDate());
    }
}
```
* No batch-size fetching strategy
```sql
Output

1 time:
    select ...
    from mkyong.stock stock0_

n times:
    select ...
    from mkyong.stock_daily_record stockdaily0_
    where stockdaily0_.STOCK_ID=?

    select ...
    from mkyong.stock_daily_record stockdaily0_
    where stockdaily0_.STOCK_ID=?

    ...
```
Keep repeat the select statements....depend how many stock records in your table.

If you have 20 stock records in the database, the Hibernate’s default fetching strategies will generate 20+1 select statements and hit the database.

1) Select statement to retrieve all the Stock records.
2) Select its related collection
3) Select its related collection
4) Select its related collection
…
21) Select its related collection

The generated queries are not efficient and caused a serious performance issue.

* Enabled the batch-size=’10’ fetching strategy

Let see another example with batch-size=’10’ is enabled.

```sql
Output

1 time:
    select ...
    from mkyong.stock stock0_

n/batch_size + 1 times:
    select ...
    from mkyong.stock_daily_record stockdaily0_
    where
        stockdaily0_.STOCK_ID in (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
        )
```
Now, Hibernate will per-fetch the collections, with a select *in* statement. If you have 20 stock records, it will generate 3 select statements.

* Select statement to retrieve all the Stock records.
* Select In statement to per-fetch its related collections (10 collections a time)
* Select In statement to per-fetch its related collections (next 10 collections a time)

With batch-size enabled, it simplify the select statements from 21 select statements to 3 select statements.

4. fetch=”subselect” or @Fetch(FetchMode.SUBSELECT)
Testing codes:
```java
List<Stock> list = session.createQuery("from Stock").list();

for(Stock stock : list){
    Set sets = stock.getStockDailyRecords();
    for ( Iterator iter = sets.iterator();iter.hasNext(); ) {
            StockDailyRecord sdr = (StockDailyRecord) iter.next();
            System.out.println(sdr.getDailyRecordId());
            System.out.println(sdr.getDate());
    }
}
```

```sql
Output:
1 time:
    select ...
    from mkyong.stock stock0_

1 time:
    select ...
    from
        mkyong.stock_daily_record stockdaily0_
    where
        stockdaily0_.STOCK_ID in (
            select
                stock0_.STOCK_ID
            from
                mkyong.stock stock0_
        )
```

With “subselect” enabled, it will create 2 select statements.
* Select statement to retrieve all the Stock records.
* Select all its related collections in a sub select query.

##### Hibernate Lazy and implementation

Usually, the mapping document is not used to customize fetching. Instead, we keep the default behavior, and override it for a particular transaction, using left join fetch in HQL. This tells Hibernate to fetch the association eagerly in the first select, using an outer join. In the Criteria query API, you would use setFetchMode(FetchMode.JOIN).
If you want to change the fetching strategy used by get() or load(), you can use a Criteria query. For example:
```java
User user = (User) session.createCriteria(User.class)
.setFetchMode("permissions", FetchMode.JOIN)
.add( Restrictions.idEq(userId) )
.uniqueResult();
```

Lazy fetching for collections is implemented using `Hibernate's own implementation of persistent collections`. However, a different mechanism is needed for lazy behavior in single-ended associations. The target entity of the association must be proxied. Hibernate implements lazy initializing proxies for persistent objects using `runtime bytecode enhancement which is accessed via the CGLIB library.`

At startup, Hibernate3 generates proxies by default for all persistent classes and uses them to enable lazy fetching of many-to-one wand one-to-one associations.

The mapping file may declare an interface to use as the proxy interface for that class, with the proxy attribute. By default, Hibernate uses a subclass of the class. The proxied class must implement a default constructor with at least package visibility. This constructor is recommended for all persistent classes.

Third, you cannot use a CGLIB proxy for a final class or a class with any final methods.

__Certain operations do not require proxy initialization:__  
* equals(): if the persistent class does not override equals()
* hashCode(): if the persistent class does not override hashCode()
* The identifier getter method

`A LazyInitializationException will be thrown by Hibernate if an uninitialized collection or proxy is accessed outside of the scope of the Session`, i.e., when the entity owning the collection or having the reference to the proxy is in the detached state.

Sometimes a proxy or collection needs to be initialized before closing the Session. You can force initialization by calling cat.getSex() or cat.getKittens().size(), for example. However, this can be confusing to readers of the code and it is not convenient for generic code.

The static methods **Hibernate.initialize()** and Hibernate.isInitialized(), provide the application with a convenient way of working with lazily initialized collections or proxies.

Another option is to keep the Session open until all required collections and proxies have been loaded. **PS:** So called "open session in view", which is considered as anti-pattern.

##### lazy fetching of individual properties
Hibernate3 supports the lazy fetching of individual properties. This optimization technique is also known as fetch groups. Please note that this is mostly a marketing feature; optimizing row reads is much more important than optimization of column reads. However, only loading some properties of a class could be useful in extreme cases. For example, when legacy tables have hundreds of columns and the data model cannot be improved.

A different way of avoiding unnecessary column reads, at least for read-only transactions, is to use the projection features of HQL or Criteria queries. This avoids the need for buildtime bytecode processing and is certainly a preferred solution.

You can force the usual eager fetching of properties using fetch all properties in HQL.

##### inverse attribute in mapping

From P15/23 Hibernate Reference Documentation Version: 3.1 rc3

What about the inverse mapping attribute? For you, and for Java, a bi-directional link is simply a matter of setting the references on both sides correctly. Hibernate however doesn't have enough information to correctly arrange SQL INSERT and UPDATE statements (to avoid constraint violations), and needs some help to handle bidirectional associations properly. `Making one side of the association inverse tells Hibernate to basically ignore it, to consider it a mirror of the other side.` That's all that is necessary for Hibernate to work out all of the issues when transformation a directional navigation model to a SQL database schema. 

`The rules you have to remember are straightforward: All bi-directional associations need one side as inverse. In a one-to-many association it has to be the many-side, in many-to-many association you can pick either side, there is no difference.`

Some other referencing materials: 
`However, in well-designed Hibernate domain models, most collections are in fact one-to-many associations with inverse="true".` For these associations, the update is handled by the many-to-one end of the association, and so considerations of collection update performance simply do not apply.

Bags and lists are the most efficient inverse collections.
There is a particular case, however, in which bags, and also lists, are much more performant than sets. `For a collection with inverse="true", the standard bidirectional one-to-many relationship idiom, for example, we can add elements to a bag or list without needing to initialize (fetch) the bag elements. This is because, unlike a set, Collection.add() or Collection.addAll() must always return true for a bag or List(PS: in other word, set may return false if it find out that there is any duplication, that's why set nees to initialize its elements before adding new ones).` This can make the following common code much faster:

```java
Parent p = (Parent) sess.load(Parent.class, id);
Child c = new Child();
c.setParent(p);
p.getChildren().add(c); //no need to fetch the collection!
sess.flush();
```

One-shot-delete does not apply to collections mapped inverse="true".

##### Hibernate Caching

[Fore more information][hibernate-caching-1]

http://www.tutorialspoint.com/hibernate/hibernate_caching.htm

Hibernate Cache can be very useful in gaining fast application performance if used correctly. The idea behind cache is to reduce the number of database queries, hence reducing the throughput time of the application.

* First Level Cache: Hibernate first level cache is `associated with the Session object`. Hibernate first level cache is enabled by default and there is no way to disable it. However hibernate provides methods through which we can delete selected objects from the cache or clear the cache completely.
Any object cached in a session will not be visible to other sessions and when the session is closed, all the cached objects will also be lost.

* Second Level Cache: Hibernate Second Level cache is disabled by default but we can enable it through configuration. Currently EHCache and Infinispan provides implementation for Hibernate Second level cache and we can use them. 

Second level cache is an optional cache and first-level cache will always be consulted before any attempt is made to locate an object in the second-level cache. The second-level cache can be configured `on a per-class and per-collection basis` and mainly responsible for caching objects across sessions.
Any third-party cache can be used with Hibernate. An org.hibernate.cache.CacheProvider interface is provided, which must be implemented to provide Hibernate with a handle to the cache implementation

Not all classes benefit from caching, so it's important to be able to disable the second-level cache.

The Hibernate second-level cache is set up in two steps. First, you have to decide which concurrency strategy to use. After that, you configure cache expiration and physical cache attributes using the cache provider.

concurrency strategy: 
* read-only
A concurrency strategy suitable for data which never changes. Use it for reference data only.
* nonstrict-read-writ
This strategy makes no guarantee of consistency between the cache and the database. Use this strategy if data hardly ever changes and a small likelihood of stale data is not of critical concern.
* read-write
Again use this strategy for read-mostly data where it is critical to prevent stale data in concurrent transactions,in the rare case of an update.
比较普遍的形式，效率一般
* transactional
Use this strategy for read-mostly data where it is critical to prevent stale data in concurrent transactions,in the rare case of an update.
JTA中，且支持的缓存产品较少

* Query Cache: Hibernate can also cache result set of a query. Hibernate Query Cache doesn’t cache the state of the actual entities in the cache; `it caches only identifier values and results of value type`. So it should always be used in conjunction with the second-level cache.

Hibernate also implements a cache for query resultsets that integrates closely with the second-level cache.
This is an optional feature and requires two additional physical cache regions that hold the cached query results and the timestamps when a table was last updated. This is only useful for queries that are run frequently with the same parameters.

To use the query cache, you must first activate it using the hibernate.cache.use_query_cache="true" property in the configuration file. By setting this property to true, you make Hibernate create the necessary caches in memory to hold the query and identifier sets.

如配置了则从查询缓存中查找key为`查询语句+查询参数+分页条件的值`

Hibernate also supports very fine-grained cache support through the concept of a cache region. A **cache region** is part of the cache that's given a name.

This code uses the method to tell Hibernate to store and look for the query in the employee area of the cache.
```java
Session session = SessionFactory.openSession();
Query query = session.createQuery("FROM EMPLOYEE");
query.setCacheable(true);
query.setCacheRegion("employee");
List users = query.list();
SessionFactory.closeSession();
```

The Session caches every object that is in persistent state (watched and checked for dirty state by Hibernate). This means it grows endlessly until you get an OutOfMemoryException, if you keep it open for a long time or simply load too much data. One solution for this is to call clear() and evict() to manage the Session cache, `but you most likely should consider a Stored Procedure if you need mass data operations`. Some solutions are shown in Chapter 13, Batch processing. Keeping a Session open for the duration of a user session also means a high probability of stale data.

##### Hibernate concurrency concerns

From P121/129 Hibernate Reference Documentation Version: 3.1 rc3

A Session is not thread-safe. Things which are supposed to work concurrently, like HTTP requests, session beans, or Swing workers, will cause race conditions if a Session instance would be shared. If you keep your Hibernate Session in your HttpSession (discussed later), you should consider synchronizing access to your Http session. Otherwise, a user that clicks reload fast enough may use the same Session in two concurrently running threads.

##### Hibernate isolation level
Hibernate directly uses JDBC connections and JTA resources without adding any additional locking behavior. We highly recommend you spend some time with the JDBC, ANSI, and transaction isolation specification of your database management system.

Hibernate does not lock objects in memory. Your application can expect the behavior as defined by the isolation level of your database transactions. 

##### Flushing the Session

Sometimes the Session will execute the SQL statements needed to synchronize the JDBC connection's state with the state of objects held in memory. This process, called flush, occurs by default at the following points:
* before some query executions
* from org.hibernate.Transaction.commit()
* from Session.flush()

默认情况下,session会在以下时间点清理缓存
* 当应用程序执行一些查询操作时,如果缓存中持久化对象的属性已经发生了变化,就会先清理缓存,使session缓存与数据库同步,保证查询结果正确.
* 当应用程序调用org.hibernate.Transaction的commit()方法时候,先清理缓存,再向数据库提交事务.
* 当应用程序显示调用session的flush()方法时.
 
###### 改变清理缓存时间点
session.setFlushMode(FlushMode.COMMIT)  

清理缓存的模式 | 各种查询方法 | Transaction的commit() | Session的flush()
:---------------------|:--------|:--------|--------
FlushMode.AUTO(默认)  |清理    |清理    |清理
FlushMode.COMMIT      |不清理  |清理    |清理
FlushMode.NEVER       |不清理  |不清理  |不清理

The SQL statements are issued in the following order:
1. all entity insertions in the same order the corresponding objects were saved using Session.save()
2. all entity updates
3. all collection deletions
4. all collection element deletions, updates and insertions
5. all collection insertions
6. all entity deletions in the same order the corresponding objects were deleted using Session.delete()

An exception is that objects using native ID generation are inserted when they are saved.

Except when you explicitly flush(), there are absolutely no guarantees about when the Session executes the JDBC calls, only the order in which they are executed. However, Hibernate does guarantee that the Query.list(..) will never return stale or incorrect data.

### Struts

#### Struts2
##### Struts2 Misc
###### differences between struts 1 and 2
* Framework intrusion
    - Action 类
        + Struts1要求Action类继承一个抽象基类。Struts1的一个普遍问题是使用抽象类编程而不是接口
        + Struts 2 Action类可以实现一个Action接口, 但不是必须的，任何有execute()方法的POJO对象都可以用作Struts2的Action对象. Struts2提供一个ActionSupport基类去实现常用的接口。
    - Servlet 依赖
        + Struts1 Action 依赖于Servlet API ,因为当一个Action被调用时HttpServletRequest 和 HttpServletResponse 被传递给execute方法
        + Struts 2 Action不依赖于容器，允许Action脱离容器单独被测试。如果需要，Struts2 Action仍然可以访问初始的request和response。但是，其他的元素减少或者消除了直接访问HttpServetRequest 和 HttpServletResponse的必要性
    - 捕获输入
        + Struts1 使用ActionForm对象捕获输入。所有的ActionForm必须继承一个基类。因为其他JavaBean不能用作ActionForm，开发者经常创建多余的类捕获输入。动态Bean（DynaBeans）可以作为创建传统ActionForm的选择，但是，开发者可能是在重新描述(创建)已经存在的JavaBean（仍然会导致有冗余的javabean）
        + Struts 2直接使用Action属性作为输入属性，消除了对第二个输入对象的需求。输入属性可能是有自己(子)属性的rich对象类型。Action属性能够通过web页面上的taglibs访问。Struts2也支持ActionForm模式。rich对象类型，包括业务对象，能够用作输入/输出对象。这种ModelDriven 特性简化了taglib对POJO输入对象的引用
    - 可测性
        + 测试Struts1 Action的一个主要问题是execute方法暴露了servlet API（这使得测试要依赖于容器）。一个第三方扩展－－Struts TestCase－－提供了一套Struts1的模拟对象（来进行测试）
        + Struts 2 Action可以通过初始化、设置属性、调用方法来测试，“依赖注入”支持也使测试更容易。
* 线程模式
    - Struts1 Action是单例模式并且必须是线程安全的，因为仅有Action的一个实例来处理所有的请求
    - Struts2 Action对象为每一个请求产生一个实例，因此没有线程安全问题。（实际上，servlet容器给每个请求产生许多可丢弃的对象，并且不会导致性能和垃圾回收问题）

* 表达式语言 OGNL
    - Struts1 整合了JSTL，因此使用JSTL EL。这种EL有基本对象遍历，但是对集合和索引属性的支持很弱。
    - Struts 1 ActionForm 属性通常都是String类型。Struts1使用Commons-Beanutils进行类型转换。每个类一个转换器，对每一个实例来说是不可配置的。
    - Struts2可以使用JSTL，但是也支持一个更强大和灵活的表达式语言－－`"Object Graph Notation Language" (OGNL)`. 
    - Struts2 使用OGNL进行类型转换。提供基本和常用对象的转换器。 

* 绑定值到页面（view）
    - Struts 1使用标准JSP机制把对象绑定到页面中来访问
    - Struts 2 使用 `"ValueStack"`技术，使taglib能够访问值而不需要把你的页面（view）和对象绑定起来。ValueStack策略允许通过一系列名称相同但类型不同的属性重用页面（view）

* 校验
    - Struts 1支持在ActionForm的validate方法中手动校验，或者通过Commons Validator的扩展来校验。同一个类可以有不同的校验内容，但不能校验子对象。
    - Struts2支持通过`validate方法和XWork校验框架`来进行校验。XWork校验框架使用为属性类类型定义的校验和内容校验，来支持`chain校验子属性` 

* Action Lifecycle的控制
    - Struts1支持每一个模块有单独的Request Processors（生命周期），但是模块中的所有Action必须共享相同的生命周期。
    - Struts2支持通过拦截器堆栈（Interceptor Stacks）为每一个Action创建不同的生命周期。堆栈能够根据需要和不同的Action一起使用。

###### Struts2 workflow
Struts 2框架本身大致可以分为3个部分：
* 核心控制器FilterDispatcher
* 业务控制器Action
* 用户实现的企业业务逻辑组件

核心控制器FilterDispatcher是Struts 2框架的基础，包含了框架内部的控制流程和处理机制。业务控制器Action和业务逻辑组件是需要用户来自己实现的。用户在开发Action和业务逻辑组件的同时，还需要编写相关的配置文件，供核心控制器FilterDispatcher来使用。

Struts 2的工作流程相对于Struts 1要简单，与WebWork框架基本相同，所以说Struts 2是WebWork的升级版本。基本简要流程如下：
1. 客户端浏览器发出HTTP请求
2. 根据web.xml配置，该请求被FilterDispatcher接收
3. 根据struts.xml配置，找到需要调用的Action类和方法，并通过IoC方式，将值注入给Aciton
4. Action调用业务逻辑组件处理业务逻辑，这一步包含表单验证
5. Action执行完毕，根据struts.xml中的配置找到对应的返回结果result，并跳转到相应页面
6. 返回HTTP响应到客户端浏览器

#### Struts Misc

##### Struts action types
* DispatchAction: 能同时完成多个Action功能的Action
    - LookupDispatchAction: DispatchAction 的子类, 根据按钮的key, 控制转发给action的方法
    - MappingDispatchAction: DispatchAction的子类, 一个action 可映射出多个Action地址
* ForwardActon: 该类用来整合Struts 和其他业务逻辑组件，通常只对请求作有效 
性检查
* IncludeAction: 用于引入其他的资源和页面
* SwitchAction: 用于从一个模块转换至另一个模块，如果应用分成多个模块时， 
就可以使用SwitchAction 完成模块之间的切换

##### Struts Pros and Cons
__Pros:__  
1. 实现MVC模式，结构清晰,使开发者只关注业务逻辑的实现. 
2. 有丰富的tag可以用 ,Struts的标记库(Taglib)。
3. 有效的和其他的开源框架整合, 如Hibernate,spring.
4. 支持I18N
5. 页面导航逻辑配置在配置文件中.

__Cons:__  
1. 转到展示层时，需要配置forward，每一次转到展示层，相信大多数都是直接转到jsp，而涉及到转向，需要配置forward, 注意，每次修改配置之后，要求重新部署整个项目.
2. Struts 的Action必需是thread－safe方式，它仅仅允许一个实例去处理所有的请求
3. 测试不方便. Struts的每个Action都同Web层耦合在一起，这样它的测试依赖于Web容器，单元测试也很难实现。不过有一个Junit的扩展工具Struts TestCase可以实现它的单元测试
4. 类型的转换. Struts的FormBean把所有的数据都作为String类型，它可以使用工具Commons-Beanutils进行类型转化。但它的转化都是在Class级别，而且转化的类型是不可配置的。类型转化时的错误信息返回给用户也是非常困难的
5. 对Servlet的依赖性过强. Struts处理Action时必需要依赖ServletRequest 和ServletResponse，所有它摆脱不了Servlet容器。
6. 前端表达式语言方面.Struts集成了JSTL，所以它主要使用JSTL的表达式语言来获取数据。可是JSTL的表达式语言在Collection和索引属性方面处理显得很弱。 
7. 对Action执行的控制困难. Struts创建一个Action，如果想控制它的执行顺序将会非常困难。甚至你要重新去写Servlet来实现你的这个功能需求
8. 对Action 执行前和后的处理. Struts处理Action的时候是基于class的hierarchies，很难在action处理前和后进行操作。PS: AOP support 
9. 对事件支持不够. 表单对象不支持字段级别的事件, 如果要支持, 要通过结合JavaScript也是可以转弯实现的.

### Miscellaneous

---
[spring-framework-1]:/resources/img/java/spring-framework-runtime.png "Overview of the Spring Framework(from Spring 4.2.6)"
[spring_bean_lifecycle_1]:/resources/img/java/spring_bean_lifecycle_1.png "spring bean lifecycle in bean factory"
[spring_bean_lifecycle_2]:/resources/img/java/spring_bean_lifecycle_2.png "spring bean lifecycle in application context"
[spring_bean_lifecycle_3]:/resources/img/java/spring_bean_lifecycle_3.jpg "spring bean lifecycle in application context more"
[spring_bean_lifecycle_4]:http://997004049-qq-com.iteye.com/blog/1729793 "spring bean lifecycle in application context more"
[spring_annotation_1]:https://blogs.sourceallies.com/2011/08/spring-injection-with-resource-and-autowired/#more-2350 "SPRING INJECTION WITH @RESOURCE, @AUTOWIRED AND @INJECT"
[spring-orm-hibernate-1]:http://docs.spring.io/spring/docs/3.0.x/spring-framework-reference/html/orm.html#orm-hibernate-straight "Implementing DAOs based on plain Hibernate 3 API"
[spring-misc-injection-1]:http://vojtechruzicka.com/field-dependency-injection-considered-harmful/ "3 types of injection"
[spring_mvc_1]:/resources/img/java/spring_mvc_1.png "Spring MVC flowchart"
[hibernate-object-state-1]:/resources/img/java/hibernate-object-state-transitions-1.png "Hibernate Object State Transition"
[hibernate-architecture-1]:/resources/img/java/hibernate-architecture-1.png "Hibernate Architecture Diagram"
[hibernate-fecthing-strategy-1]:http://www.mkyong.com/hibernate/hibernate-fetching-strategies-examples/ "Hibernate – fetching strategies examples"
[hibernate-caching-1]:http://www.tutorialspoint.com/hibernate/hibernate_caching.htm "Hibernate - Caching"
[hibernate-caching-2]:http://blog.jhades.org/setup-and-gotchas-of-the-hibernate-second-level-and-query-caches/ "Pitfalls of the Hibernate Second-Level / Query Caches"