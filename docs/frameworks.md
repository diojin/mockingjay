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
    - [Aspect](#spring-aspect)
    - [Transaction](#spring-transaction)    
    - [Misc](#spring-misc)
        + [Bean Bootstrapping ways](#bean-bootstrapping-ways)
        + [context:annotation-config](#contextannotation-config)
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
When bootstrapping such an arrangement, only AppConfig need be registered against the application context. By virtue of being a nested @Configuration class, DatabaseConfig will be registered automatically. This avoids the need to use an @Import annotation when the relationship between AppConfig DatabaseConfig is already implicitly clear. 
Note also that nested @Configuration classes can be used to good effect with the @Profile annotation to provide two options of the same bean to the enclosing @Configuration class. 

__Configuring lazy initialization__  
By default, @Bean methods will be **eagerly instantiated** at container bootstrap time. To avoid this, @Configuration may be used in conjunction with the **@Lazy** annotation to indicate that all @Bean methods declared within the class are by default lazily initialized. Note that @Lazy may be used on individual @Bean methods as well. 

__Testing support for @Configuration classes__  
The Spring TestContext framework available in the spring-test module provides the @ContextConfiguration annotation, which as of Spring 3.1 can accept an array of @Configuration Class objects: 
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
org.springframework.stereotype

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

the return type is constrained to either void or java.util.concurrent.Future.

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

##### @Autowired and @Required and @Inject and @Resource

>RequiredAnnotationBeanPostProcessor
>>In particular, it does not check that a configured value is not null. 
Note: A default RequiredAnnotationBeanPostProcessor will be registered by the "context:annotation-config" and "context:component-scan" XML tags. Remove or turn off the default annotation configuration there if you intend to specify a custom RequiredAnnotationBeanPostProcessor bean definition.

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


@Inject

@Autowired 默认按类型装配，如果我们想使用按名称装配，可以结合@Qualifier注解一起使用。如下：
@Autowired @Qualifier("personDaoBean") 存在多个实例配合使用
@Resource默认按名称装配，当找不到与名称匹配的bean才会按类型装配。


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

##### context:annotation-config

<context:annotation-config /> 将隐式地向spring 容器注册AutowiredAnnotationBeanPostProcessor 、CommonAnnotationBeanPostProcessor 、 PersistenceAnnotationBeanPostProcessor 以及RequiredAnnotationBeanPostProcessor 这4个BeanPostProcessor, so that @Autowired and @Required are supported.

To do it separatedly, 
* 通过在配置文件中配置AutowiredAnnotationBeanPostProcessor 达到支持@Autowired
* For @Required 接着我们需要在 配置文件中加上这样一句话
```xml
<bean class="org.springframework.beans.factory.annotation.    
    RequiredAnnotationBeanPostProcessor"/>   
```

### Miscellaneous

---
[spring-framework-1]:/resources/img/java/spring-framework-runtime.png "Overview of the Spring Framework(from Spring 4.2.6)"
[spring_bean_lifecycle_1]:/resources/img/java/spring_bean_lifecycle_1.png "spring bean lifecycle in bean factory"
[spring_bean_lifecycle_2]:/resources/img/java/spring_bean_lifecycle_2.png "spring bean lifecycle in application context"
[spring_annotation_1]:https://blogs.sourceallies.com/2011/08/spring-injection-with-resource-and-autowired/#more-2350 "SPRING INJECTION WITH @RESOURCE, @AUTOWIRED AND @INJECT"