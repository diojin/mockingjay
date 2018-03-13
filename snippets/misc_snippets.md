# 		Snippets of miscellaneous techniques
---

## Indexes
* [git](#git)
    - [remove ignored files](#remove-ignored-files)
    - [resolve conflicts between local and remote repository](#resolve-conflicts-between-local-and-remote-repository)
* [QueryDSL](#querydsl)
    - [Misc](#querydsl-misc)
        + [QueryDSL Code Examples](#querydsl-code-examples)
* [Handlebar](#handlebar)
    - [Misc](#handlebar-misc)
        + [Handlerbar Code Examples](#handlerbar-code-examples)
* [Android](#android)
    - [Genymotion](#genymotion)
        + [Installation](#installation)
            * [Issues](#genymotion-installation-issue)
    - [Misc](#android-misc)
* [Miscellaneous](#miscellaneous)
    - [Lombok](#lombok)
        + [Examples](#lombok-examples)
    - [Memcached](#memcached)
        + [Example 1](#memcached-example-1)

## git
### remove ignored files
```shell
# file lists
git rm --cached file1 file2 dir/file3

# many files
git rm --cached `git ls-files -i --exclude-from=.gitignore`

# as for Git Bash on Windows.
git ls-files -i --exclude-from=.gitignore | xargs git rm --cached  
```

### resolve conflicts between local and remote repository
```shell
# 1、把远程仓库master分支下载到本地并存为tmp分支
git fetch origin master:tmp 

# 2、查看tmp分支与本地原有分支的不同
git diff tmp 

# 3、将tmp分支和本地的master分支合并
git merge tmp 

# 4、最后别忘记删除tmp分支
git branch -d tmp 
```

## QueryDSL
### QueryDSL Misc
#### QueryDSL Code Examples
[Back To Indexes](#indexes)  
* native query example
```java
@Modifying 
@Query("delete from ZombieCustomerTrace a where a.processGroup is null ") 
void clearHistory(); 
```

* use group to convert result
```java
public Map<Long /*VendorItemId*/,List<BmTransitionAlternativeVendorItem>> findActivatedMapBySkuId(Long skuId){
    Map<Long, List<BmTransitionAlternativeVendorItem>> resultMap = 
    from(qBmTransition, qBmTransitionAlternativeVendorItem)
        .where(qBmTransition.bmTransitionId.eq(qBmTransitionAlternativeVendorItem.bmTransitionId))
        .where(qBmTransitionAlternativeVendorItem.valid.isTrue())
        .transform(groupBy(qBmTransition.vendorItemId).as(list(qBmTransitionAlternativeVendorItem)));
    return Optional.fromNullable(resultMap).or(Maps.<Long, List<BmTransitionAlternativeVendorItem>>newHashMap());
}
```

## Handlebar
[Back To Indexes](#indexes)  
### Handlebar Misc
#### Handlerbar Code Examples
```javascript
{{#each messages}}
  <li style="color:red">
    {{this}}
  </li>
{{/each}}

{{#assign "subsItemIdImgUrl"}}{{this.itemPictureUri}}{{/assign}}
<img src="{{subsItemIdImgUrl}}" height="130px" width="130px"/>

<li {{#when searchCondtion.searchType "equalsAsString" "BMREQUESTED"}}{{else}}class="active"{{/when}}>
    <a id="oosreporttab" data-toggle="tab" href="#oosReportDashboard">OOS Report</a>
</li>
```

## Android
### Genymotion
[Back To Indexes](#indexes)  
#### Installation
##### Genymotion Installation Issue
* Can't download image
find from genymotion.log the actually download link and put it under image path. Something like  
```json
>12月 28 17:14:43 [Genymotion] [debug] Downloading file  "http://dl.genymotion.com/dists/6.0.0/ova/genymotion_vbox86p_6.0_160825_141918.ova"
```

Configuration {HOME} for genymotion:   
Windows:    C:\Users\{username}\AppData\Local\Genymobile  
Mac OS:     /Users/diojin/.Genymobile  

log path:   ${HOME}/genymotion.log  
image path: ${HOME}/Genymotion/ova  

* Can't upgrade virtual device after upgration of Genymotion  
due to non license, need to re-config a new virtual device

### Android Misc


## Miscellaneous
[Back To Indexes](#indexes)  
### Lombok
[Back To Indexes](#indexes)  
#### Lombok Examples
```java
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@ToString
@EqualsAndHashCode
@Data               // ps; to generate a mutable class
@Value              // ps: to generate a immutable class
```

### Memcached
[Back To Indexes](#indexes)  
#### Memcached Example 1
```java
@CacheName(SSharpeneOrderMemcachedConfig.CACHE_NAME)
@ReadThroughMultiCache(namespace = "get-product-multi-get-v1", expiration = 1800, option = @ReadThroughMultiCacheOption(generateKeysFromResult = true, skipNullsInResult = true))
public List<ProductDto> getProductsUseCache(@ParameterValueKeyProvider List<Long> productIds){
    List<ProductDto> productDtos = Lists.newArrayList();
    for (Long productId : productIds) {
        ProductDto product = getProduct(productId);
        if(product != null){
            productDtos.add(product);
        }
    }
    return productDtos;
}
```

```java
@CacheName(SSharpeneOrderMemcachedConfig.CACHE_NAME)
class DefaultNextBoxDateCacheCore implements NextBoxDateCacheCore {
    @ReadThroughSingleCache(namespace = CacheSettings.NextcouponBox.namespace, expiration = CacheSettings.NextcouponBox.expiration)
    public CachedcouponBox getFromCache(@NotNull @ParameterValueKeyProvider String memberId) {
        // nothing to implement
        return null;
    }

    @UpdateSingleCache(namespace = CacheSettings.NextcouponBox.namespace, expiration = CacheSettings.NextcouponBox.expiration)
    @ReturnDataUpdateContent
    public CachedcouponBox setCache(@NotNull @ParameterValueKeyProvider String memberId, @NotNull CachedcouponBox couponBox) {
        return couponBox;
    }

    @InvalidateSingleCache(namespace = CacheSettings.NextcouponBox.namespace)
    public void removeCache(@NotNull @ParameterValueKeyProvider String memberId) {
        // nothing to implement
    }
}

```


```java
@Configuration
@ImportResource("classpath:simplesm-context.xml")
public class MemcachedConfig {

    @Autowired
    private Environment environment;

    @Bean
    @DependsOn("cacheBase")
    public CacheFactory cacheFactory() {
        CacheFactory cacheFactory = new CacheFactory();
        cacheFactory.setCacheName("coupon");
        cacheFactory.setCacheAliases(Arrays.asList("member"));
        cacheFactory.setCacheClientFactory(new MemcacheClientFactoryImpl());
        cacheFactory.setAddressProvider(new DefaultAddressProvider(environment.getRequiredProperty("coupon.memcached.server")));
        CacheConfiguration configuration = new CacheConfiguration();
        configuration.setConsistentHashing(true);
        configuration.setOperationTimeout(Integer.parseInt(environment.getRequiredProperty("coupon.memcached.operation.timeout")));
        configuration.setUseBinaryProtocol(true);
        cacheFactory.setConfiguration(configuration);
        cacheFactory.setDefaultSerializationType(SerializationType.CUSTOM);

        GzipDecorationTranscoder customTranscoder = new GzipDecorationTranscoder();
        customTranscoder.setThreashold(10000);
        customTranscoder.setTranscoder(new KryoTranscoder(2097152));
        cacheFactory.setCustomTranscoder(customTranscoder);

        JsonObjectMapper jsonObjectMapper = new JsonObjectMapper();
        jsonObjectMapper.configure(MapperFeature.AUTO_DETECT_FIELDS, true);
        jsonObjectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        jsonObjectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

        cacheFactory.setJsonTranscoder(new JsonTranscoder(jsonObjectMapper));

        return cacheFactory;
    }

    @Bean
    public Settings settings() {
        Settings settings = new Settings();
        settings.setOrder(500);
        return settings;
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:ehcache="http://ehcache-spring-annotations.googlecode.com/svn/schema/ehcache-spring"
       xmlns:aop="http://www.springframework.org/schema/aop" xmlns:cache="http://www.springframework.org/schema/cache"
       xmlns:util="http://www.springframework.org/schema/util"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd
        http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
        http://www.springframework.org/schema/cache http://www.springframework.org/schema/cache/spring-cache.xsd http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">

    <bean name="couponMemcachedClient" class="com.google.code.ssm.CacheFactory">
        <property name="cacheName" value="coupon" />
        <property name="cacheAliases">
            <list>
                <value>member</value>
            </list>
        </property>
        <property name="cacheClientFactory">
            <bean name="cacheClientFactory" class="com.google.code.ssm.providers.spymemcached.MemcacheClientFactoryImpl" />
        </property>
        <property name="addressProvider">
            <bean class="com.google.code.ssm.config.DefaultAddressProvider">
                <property name="address" value="${coupon.memcached.server}" />
            </bean>
        </property>
        <property name="configuration">
            <bean class="com.google.code.ssm.providers.CacheConfiguration">
                <property name="consistentHashing" value="true" />
                <property name="operationTimeout" value="${coupon.memcached.operation.timeout}" />
                <property name="useBinaryProtocol" value="true" />
            </bean>
        </property>
        <property name="defaultSerializationType"
                  value="#{T(com.google.code.ssm.api.format.SerializationType).CUSTOM}" />
        <property name="customTranscoder">
            <bean class="com.coupon.common.inf.memcached.transcoder.GzipDecorationTranscoder">
                <property name="threashold" value="10000"/> <!-- if the cpu is too small to catch the rate of fall -->
                <property name="transcoder">
                    <bean class="com.coupon.common.inf.memcached.transcoder.KryoTranscoder">
                        <constructor-arg value="2097152" /> <!-- 2mb, gzip to ensure that the available capacity for more than 1mb -->
                    </bean>
                </property>
            </bean>
        </property>
    </bean>
</beans>
```

<entry key="coupon.memcached.server">10.10.5.222:11811</entry>
<entry key="coupon.memcached.operation.timeout">1000</entry>

---