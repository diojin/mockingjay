
###Index
---

* [1. Multimap](#multimap)

















































Multimap
---

Group a collection to Map<Object, Collection>, 1st parameter of which is the group index.

```java
List<String> badGuys =
            Arrays.asList("Inky", "Blinky", "Pinky", "Pinky", "Clyde");
    Function<String, Integer> stringLengthFunction = ...;
    Multimap<Integer, String> index =
            Multimaps.index(badGuys.iterator(), stringLengthFunction);
    System.out.println(index);
    // result: {4=[Inky], 6=[Blinky], 5=[Pinky, Pinky, Clyde]}
```