
##Index
---

* [Annotation](#annotation)
    - [Misc](#annotation-misc)
        + [@ComponentScan](#componentscan)
* [Misc](#misc)



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

```java
@ComponentScan(basePackages = "net.example.tool",
  excludeFilters = {@ComponentScan.Filter(
    type = FilterType.ASSIGNABLE_TYPE,
    value = {JPAConfiguration.class, SecurityConfig.class})
  })
```


Misc
---



