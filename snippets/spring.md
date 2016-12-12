
##Index
---

* [Annotation](#annotation)
    - [Misc](#annotation-misc)
        + [@ComponentScan](#componentscan)
        + [@RequestMapping](#requestmapping)
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

@ComponentScan(basePackageClasses = SubscribeOrderAdapters.class,   includeFilters = { @ComponentScan.Filter(type = FilterType.ANNOTATION, value = Adapter.class) }, useDefaultFilters = false)

```



######@RequestMapping
```java
@RequestMapping("/vp/products/{productId:[0-9]+}") public ModelAndView productDetail(   @PathVariable(value = "productId") Long receivedProductId )
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

DefaultPersistenceUnitManager - Found explicit default unit with name 'subscribeorder' in persistence.xml - overriding local default unit settings ('packagesToScan'/'mappingResources')
persistence.xml  take precedence over  DefaultPersistenceUnitManager.packagesToScan/mappingResources ,available compositions are, 

1. set DefaultPersistenceUnitManager.defaultPersistenceUnitName = DefaultPersistenceUnitManager.ORIGINAL_DEFAULT_PERSISTENCE_UNIT_NAME, as well as packagesToScan'/'mappingResources,  meanwhile there is no “default” in persistent.xml

this is most log-efficient way(has fewer log lines) way, because it only scan packagesToScan/mappingResources, but rather like way 2, which search everything but filter everything

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
                   return skuGradeAdapter.getApiV1SkuSubscribedGrade(skuSeq);
                }
            });
            Preconditions.checkNotNull(skuGradeApiDto, "Response from skuGradeAdapter is null");
        } catch (Exception e) {
            log.info("ERROR HAPPEN WHILE CALLING ADAPTER : for SkuId {}", skuSeq, e);
        }

        return skuGradeApiDto;
    }
```


