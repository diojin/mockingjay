
###Index
---

* [Maps](#maps)
* [Multimap](#multimaps)
* [FluentIterable](#fluentiterable)
    - [anyMatch](#1-fluentiterableanymatch)
* [Splitter](#splitter)
* [SN-393](#sn-393-hahaha)


###Maps

1. Convert Collection\<V\> to `Map<K, V>`, decided by `Function<V,K>`

```java
    Map<Long, OosReport> skuId2OosReportMap = Maps.uniqueIndex(rawDs, new Function<OosReport, Long>() {
         @Nullable 
        @Override 
        public Long apply(@Nullable OosReport input) { return input.getSkuId(); }
    });
```


Multimaps
---

1. Group a `Collection<V>` to `Map<K, Collection<V>>`, decided by `Function<V, K>`, 1st parameter of which is the group index.

```java
List<String> badGuys =
            Arrays.asList("Inky", "Blinky", "Pinky", "Pinky", "Clyde");
    Function<String, Integer> stringLengthFunction = ...;
    Multimap<Integer, String> index =
            Multimaps.index(badGuys.iterator(), stringLengthFunction);
    System.out.println(index);
    // {4=[Inky], 6=[Blinky], 5=[Pinky, Pinky, Clyde]}
```

FluentIterable
---
####1. FluentIterable.anyMatch

Return true if any element matches the Predicate.

```java
    List<String> badGuys =
            Arrays.asList("Inky", "Blinky", "Pinky", "Pinky", "Clyde");

    boolean ifExists = FluentIterable.from(badGuys).anyMatch(new Predicate<String>() {
        @Override
        public boolean apply(@Nullable String input) {
            return input.length() == 5;
        }
    });

    System.out.println(ifExists); // true
```

Splitter
---
The process order is, split per onPattern at first, and then trimResults

1. pattern using "look ahead" and "positively", split by comma which has even number of " mark after itself till end of line, moreover, trim all white space characters and " 
```java
Splitter.onPattern(",(?=([^\"]*\"[^\"]*\")*[^\"]*$)")
    .trimResults(CharMatcher.BREAKING_WHITESPACE.or(CharMatcher.is('\"')))
    .split(line)
```

2. simple one
```java
Splitter.on(",").omitEmptyStrings().trimResults().splitToList(targetMemberIds)
```

SN-393 HAHAHA
---
