# 		Snippets of miscellaneous techniques
---

## Indexes

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

---