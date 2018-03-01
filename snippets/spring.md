
##Index
---

* [Annotation](#annotation)
    - [Misc](#annotation-misc)
        + [@ComponentScan](#componentscan)
        + [@RequestMapping](#requestmapping)
        + [@ManagedResource](#managedresource)
* [Misc](#misc)    
    - [Libraries](#Libraries)
        + [DefaultPersistenceUnitManager](#defaultpersistenceunitmanager)
        + [RetryTemplate](#retrytemplate)



Annotation
---
####Annotation Misc

######@ComponentScan
* AspectJ pattern example
```java
@SpringBootApplication
@EnableAutoConfiguration
@ComponentScan(basePackages = { "com.example" },
    excludeFilters = @ComponentScan.Filter(type = FilterType.ASPECTJ, pattern = "com.example.ignore.*"))
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}

```

```xml
<context:component-scan base-package="com.example">
    <context:exclude-filter type="regex" expression="com\.example\.ignore\..*"/>
 </context:component-scan>
```

* avoid auto load classes using @Configuration
```xml
<context:component-scan base-package="my.path" >
    <context:exclude-filter type="annotation" 
        expression="org.springframework.context.annotation.Configuration" />        
</context:component-scan>
```


* examples
```java
@ComponentScan(basePackages = "net.example.tool",
  excludeFilters = {@ComponentScan.Filter(
    type = FilterType.ASSIGNABLE_TYPE,
    value = {JPAConfiguration.class, SecurityConfig.class})
  })

@ComponentScan(basePackageClasses = SSharpeneOrderAdapters.class,   includeFilters = { @ComponentScan.Filter(type = FilterType.ANNOTATION, value = Adapter.class) }, useDefaultFilters = false)

```



######@RequestMapping
```java
@RequestMapping("/vp/products/{productId:[0-9]+}") public ModelAndView productDetail(   @PathVariable(value = "productId") Long receivedProductId )
```


######@ManagedResource

```java
@ManagedResource("com.coupon.sSharpene_order:type=sSharpeneCounter,name=sSharpeneCounter")
@Component
public class SSharpeneCounter extends SSharpeneOrderCounter {

    @Override
    public String getName() {
        return "sSharpeneCounter";
    }
}

```

```java

CachedStatisticsProvider

    @PostConstruct
    public void registerCacheToMonitor() {
        GuavaCacheStatsJMXRegister.register("CachedStatisticsProvider.popularFrequencyCache", popularFrequencyCache);
    }

public final class GuavaCacheStatsJMXRegister {
    private GuavaCacheStatsJMXRegister() throws IllegalAccessException {
        throw new IllegalAccessException();
    }

    public static boolean register(String name, Cache cache) {
        GuavaCacheMXBean mxBean = new GuavaCacheMXBeanImpl(cache);
        MBeanServer server = ManagementFactory.getPlatformMBeanServer();
        try {
            String objectName = String.format("%s:type=Cache,name=%s", cache.getClass().getPackage().getName(), name);
            ObjectName mxBeanName = new ObjectName(objectName);
            if (!server.isRegistered(mxBeanName)) {
                server.registerMBean(mxBean, new ObjectName(objectName));
            }
            log.info("register guava cache stats to MBean [objectName : {}]", objectName);
            return true;
        } catch (Exception ex) {
            log.error("register fail", ex);
            return false;
        }
    }

    public static class GuavaCacheMXBeanImpl implements GuavaCacheMXBean {
        private final Cache cache;

        public GuavaCacheMXBeanImpl(Cache cache) {
            this.cache = cache;
        }

        @Override
        public long getLoadSuccessCount() {
            return cache.stats().loadSuccessCount();
        }

        @Override
        public void cleanUp() {
            cache.cleanUp();
        }
    }
}
```

Misc
---

####Libraries

######DefaultPersistenceUnitManager

>Default implementation of the PersistenceUnitManager interface. Used as internal default by LocalContainerEntityManagerFactoryBean.
>
Supports standard JPA scanning for persistence.xml files,
with configurable file locations, JDBC DataSource lookup and load-time weaving.
The default XML file location is classpath*:META-INF/persistence.xml,
scanning for all matching files in the class path (as defined in the JPA specification).
>
DataSource names are by default interpreted as JNDI names, and no load time weaving is available (which requires weaving to be turned off in the persistence provider).

DefaultPersistenceUnitManager - Found explicit default unit in persistence.xml, which overrides local default settings ('packagesToScan'/'mappingResources')

persistence.xml take precedence over  DefaultPersistenceUnitManager.packagesToScan/mappingResources ,available workarounds are, 

1. set DefaultPersistenceUnitManager.defaultPersistenceUnitName to "default", as well as setting packagesToScan'/'mappingResources,  meanwhile make sure there is no “default” in persistent.xml

this is most log-efficient way(has fewer log lines way), because it only scan packagesToScan/mappingResources, but rather as way 2, which searches everything and then filters unnecessary ones

2. use persistent.xml
there is no way to specify where to scan from

3. set PersistenceUnitPostProcessor by LocalContainerEntityManagerFactoryBean.setPersistenceUnitPostProcessors to override PersistentUnitInfo properties



######RetryTemplate

```java
    @Autowired
    private RetryTemplate retryTemplate;

    public SkuGradeApiDto getSkuGrade(final Long skuSeq) {
        Preconditions.checkNotNull(skuSeq, "Sku seq is null");

        SkuGradeApiDto skuGradeApiDto = null;
        try {
            skuGradeApiDto = retryTemplate.execute(new RetryCallback<SkuGradeApiDto>() {
                @Override
                public SkuGradeApiDto doWithRetry(RetryContext context) throws Exception {
                   return skuGradeAdapter.getApiV1SkuSSharpenedGrade(skuSeq);
                }
            });
            Preconditions.checkNotNull(skuGradeApiDto, "Response from skuGradeAdapter is null");
        } catch (Exception e) {
            log.info("ERROR HAPPEN WHILE CALLING ADAPTER : for SkuId {}", skuSeq, e);
        }

        return skuGradeApiDto;
    }
```


