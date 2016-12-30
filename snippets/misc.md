##Index
---
* [QueryDSL](#querydsl)
    - [Misc](#querydsl-misc)
        + [QueryDSL Code Examples](#querydsl-code-examples)
* [Groovy](#groovy)
    - [Misc](#groovy-misc)
* [Mysql](#mysql)
    - [Misc](#mysql-misc)
        + [Update multiple raws](#update-multiple-raws)
* [Handlebar](#handlebar)
    - [Misc](#handlebar-misc)
        + [Handlerbar Code Examples](#handlerbar-code-examples)
* [Html](#html)
    - [Misc](#html-misc)
* [Android](#android)
    - [Genymotion](#genymotion)
        + [Installation](#installation)
            * [Issues](#genymotion-installation-issue)
* [Lombok](#Lombok)
    - [Examples](#lombok-examples)
* [Docker](#docker)
* [Miscellaneous](#miscellaneous)
    - [Temp](#temp)


QueryDSL
---
###QueryDSL Misc
####QueryDSL Code Examples
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

Groovy
---
####Groovy Misc

Mysql
---
####Mysql Misc
#####Update multiple raws
```sql
SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;
```

Handlebar
---
####Handlebar Misc
#####Handlerbar Code Examples
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

Android
---
####Genymotion
#####Installation
######Genymotion Installation Issue
* Can't download image
find from genymotion.log the actually download link and put it under image path.

Something like  

>12月 28 17:14:43 [Genymotion] [debug] Downloading file  "http://dl.genymotion.com/dists/6.0.0/ova/genymotion_vbox86p_6.0_160825_141918.ova"


Configuration {HOME} for genymotion: 
Windows:    C:\Users\{username}\AppData\Local\Genymobile
Mac OS:     /Users/diojin/.Genymobile

log path:   ${HOME}/genymotion.log
image path: ${HOME}/Genymotion/ova

* Can't upgrade virtual device after upgration of Genymotion
non license is like this, need to re-config a new virtual device

Html
---
####Html Misc


Lombok
---
####Lombok Examples
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

Docker
---




###Miscellaneous

####Temp

`org.joda.time.DateTimeComparator`

```java
int result = DateTimeComparator.getDateOnlyInstance().compare(today, notifyDate);
```
