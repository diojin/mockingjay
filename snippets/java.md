###Index
---

* [Functional operation](#functional-operation)


Functional Operation
---
#### examples
1. case 1

```java
Set<Long> productIds = vendorItem2VendorItemSubscriptionDTOMap.values().stream().map(VendorItemSubscriptionDTO::getProductId).collect(Collectors.toSet());

Map<Long, ProductDto> productId2ProductDto = productList.stream().collect(toMap(ProductDto::getProductId, Function.identity()));

public class VendorItemSubscriptionDTO {
    private Long productId;

    public static Function<VendorItemSubscriptionDTO, Long> TO_PRODUCT_ID = VendorItemSubscriptionDTO::getProductId;
}
```
