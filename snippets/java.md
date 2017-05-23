## Java Snippets
---

* [Concurrent](#concurrent)
    - [Misc](#concurrent-misc)
        + [How to wait for child thread to end](#how-to-wait-for-child-thread-to-end)
* [Stream](#stream)
* [Functional operation](#functional-operation)


### Concurrent
#### Concurrent Misc
##### How to wait for child thread to end
1. ExecutorService  
```java
public class MainThread {
     static ExecutorService executorService = Executors.newFixedThreadPool(1);

     @SuppressWarnings(“rawtypes”)
     public static void main(String[] args) throws InterruptedException, ExecutionException {
          SubThread thread = new SubThread();
          Future future = executorService.submit(thread);
          executorService.shutdown();
          try {
            executorService.awaitTermination();
          } catch (Exception e) {
                   e.printStackTrace();
          }
          future.get();
     }
     public static class SubThread extends Thread{
          @Override
          public void run() {
              try {
                   sleep(5000L);
              } catch (InterruptedException e) {
                   e.printStackTrace();
              }
          }
     }     
}
```
2. CountDownLatch  
```java
public class MainThread {
    public static void main(String[] args) throws InterruptedException, ExecutionException {
          int threads = 5;
          final CountDownLatch countDownLatch = new CountDownLatch(threads);
          for(int i=0;i<threads;i++){
              SubThread thread = new SubThread(2000*(i+1), countDownLatch);
              thread.start();
          }
          countDownLatch.await();
     }
     public static class SubThread extends Thread{
          private CountDownLatch countDownLatch;
          private long work;          
          public SubThread(long work, CountDownLatch countDownLatch) {
              this.countDownLatch = countDownLatch;
              this.work = work;
          }

          @Override
          public void run() {
              try{
                sleep(work);
              }finally{
                   countDownLatch.countDown();
              }
              
          }
     }
}
```

3. Thread#join  
```java
public class MainThread {
    public static void main(String[] args) {
         SubThread thread = new SubThread();
         thread.start();
         System.out.println(“now waiting sub thread done.”);
         try {
             thread.join();
         } catch (InterruptedException e) {
             e.printStackTrace();
         }
         System.out.println(“now all done.”);
    }
    public static class SubThread extends Thread{
         @Override
         public void run() {
             try {
                  sleep(5000L);
             } catch (InterruptedException e) {
                  e.printStackTrace();
             }
         }     
    }
}

```
4. CompletionService
5. Customized, such as an implementation of AbstractQueuedSynchronizer  

Stream
---

Streams differ from collections in several ways:

**No storage**. A stream is not a data structure that stores elements; instead, it conveys elements from a source such as a data structure, an array, a generator function, or an I/O channel, through a pipeline of computational operations.

__Functional in nature__. An operation on a stream produces a result, but does not modify its source. For example, filtering a Stream obtained from a collection produces a new Stream without the filtered elements, rather than removing elements from the source collection.

**Laziness-seeking**. Many stream operations, such as filtering, mapping, or duplicate removal, can be implemented lazily, exposing opportunities for optimization. For example, "find the first String with three consecutive vowels" need not examine all the input strings. `Stream operations are divided into intermediate (Stream-producing) operations and terminal (value- or side-effect-producing) operations. Intermediate operations are always lazy.`

**Possibly unbounded**. While collections have a finite size, streams need not. 

**Short-circuiting** operations such as limit(n) or findFirst() can allow computations on infinite streams to complete in finite time.

**Consumable**. The elements of a stream are only visited once during the life of a stream. Like an Iterator, a new stream must be generated to revisit the same elements of the source.

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
