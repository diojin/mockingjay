
##Index
---

* [Annotation](#annotation)
    - [Misc](#annotation-misc)
        + [@ComponentScan](#componentscan)
        + [@RequestMapping](#requestmapping)
* [Misc](#misc)
    
    - [Libraries](#Libraries)
        + [RetryTemplate](#retrytemplate)



Annotation
---
####Annotation Misc

######@ComponentScan
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

```java
@ComponentScan(basePackages = "net.example.tool",
  excludeFilters = {@ComponentScan.Filter(
    type = FilterType.ASSIGNABLE_TYPE,
    value = {JPAConfiguration.class, SecurityConfig.class})
  })
```


######@RequestMapping
```java
@RequestMapping("/vp/products/{productId:[0-9]+}") public ModelAndView productDetail(   @PathVariable(value = "productId") Long receivedProductId,
```

Misc
---

####Libraries

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


