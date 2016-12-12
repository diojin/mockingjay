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
* [Lombok](#Lombok)
    - [Examples](#lombok-examples)


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

