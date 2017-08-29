#               Addison.Wesley.Java.Concurrency.in.Practice.May.2006
##                  By Brian Goetz, Tim Peierls, Joshua Bloch,   
##                          Joseph Bowbeer, David Holmes, Doug Lea

---

* [2. Thread Safety](#2-thread-safety)
    - [Racing condition VS Data Race](#racing-condition-vs-data-race)
    - [Typical scenarios of racing condition](#typical-scenarios-of-racing-condition)
    - [Reentrancy](#reentrancy)
    - [Java Monitor Pattern](#java-monitor-pattern)
        + [Invariant](#invariant)
    - [Liveness and Performance](#liveness-and-performance)
* [3. Sharing Objects](#3-sharing-objects)
    - [One code example -- Stale data](#one-code-example----stale-data)
* [Miscellaneous](#miscellaneous)

## 2. Thread Safety  
### Racing condition VS Data Race  
A race condition occurs when the correctness of a computation depends on the relative timing or interleaving of multiple threads by the runtime; in other words, when getting the right answer relies on lucky timing.  

The term race condition is often confused with the related term data race, which arises when synchronization is not used to coordinate all access to a shared nonfinal field.  

The most common type of race condition is check-then-act, where a potentially stale observation is used to make a decision on what to do next.  

Not all race conditions are data races, and not all data races are race conditions.  

### Typical scenarios of racing condition  
1. check-then-act  
A common idiom that uses `check-then-act` is lazy initialization. The goal of lazy initialization is to defer initializing an object until it is actually needed while at the same time ensuring that it is initialized only once.  
2. read-modify-write  
3. put-if-absent   
```java
if (!vector.contains(element))
    vector.add(element);  
```
    
To ensure thread safety, check-then-act operations (like lazy initialization) and read-modify-write operations (like increment) must always be atomic. We
refer collectively to check-then-act and read-modify-write sequences as **compound actions**: sequences of operations that must be executed atomically 
in order to remain thread-safe. In the next section, we'll consider locking, Java's builtin mechanism for ensuring atomicity.

When a single element of state is added to a stateless class, the resulting class will be thread-safe if the state is entirely managed by a thread-safe object. But, as we'll see in the next section, going from one state variable to more than one is not necessarily as simple as going from zero to one.  


### Reentrancy
When a thread requests a lock that is already held by another thread, the requesting thread blocks.   
But because intrinsic locks are reentrant, if a thread tries to acquire a lock that it already holds, the request succeeds.   
Reentrancy means that locks are acquired on a per-thread rather than per-invocation basis.  
Reentrancy is implemented by associating with each lock an acquisition count and an owning thread. When the count is zero, the lock is considered unheld. 
When a thread acquires a previously unheld lock, the JVM records the owner and sets the acquisition count to one. If that same thread acquires the lock again, the count is incremented, and when the owning thread exits the synchronized block, the count is decremented. When the count reaches zero, the lock is released.  

Reentrancy facilitates encapsulation of locking behavior, and thus simplifies the development of object-oriented concurrent code. Without reentrant locks, the very natural-looking code in Listing 2.7, in which a subclass overrides a synchronized method and then calls the superclass method, would deadlock.  
```java
public class Widget {
    public synchronized void doSomething() {
        ...
    }
}
public class LoggingWidget extends Widget {
    public synchronized void doSomething() {
        System.out.println(toString() + ": calling doSomething");
        super.doSomething();
    }
}
```


### Java Monitor Pattern
A common locking convention is to encapsulate all mutable state within an object and to protect it from concurrent access by synchronizing any code path that accesses mutable state using the object's intrinsic lock. This pattern is used by many thread-safe classes, such as `Vector` and `other synchronized collection classes.`   
In such cases, all the variables in an object's state are guarded by the object's intrinsic lock. However, there is nothing special about this pattern, 
and neither the compiler nor the runtime enforces this (or any other) pattern of locking. It is also easy to subvert this locking protocol accidentally by adding a new method or code path and forgetting to use synchronization.    

#### Invariant
When a variable is guarded by a lock meaning that every access to that variable is performed with that lock held you've ensured that only one thread at a time can access that variable. When a class has invariants that involve more than one state variable, there is an additional requirement: each variable participating in the invariant must be guarded by the same lock. This allows you to access or update them in a single atomic operation, preserving the invariant.  

`Making every method synchronized doesn't guarantee thread safe`  
Merely synchronizing every method, as Vector does, is not enough to render compound actions on a Vector atomic:  
```java
if (!vector.contains(element))
    vector.add(element);  
```
This attempt at a `put-if-absent` operation has a race condition, even though both contains and add are atomic. While synchronized methods can make individual operations atomic, additional locking is required when multiple operations are combined into a compound action.(See Section 4.4 for some techniques for safely adding additional atomic operations to thread-safe objects.) At the same time, synchronizing every method can lead to liveness or performance problems  

### Liveness and Performance
There is frequently a tension between simplicity and performance. `When implementing a synchronization policy, resist the temptation to prematurely sacrifice simplicity (potentially compromising safety) for the sake of performance.`  

`Avoid holding locks during lengthy computations or operations at risk of not completing quickly such as network or console I/O.`  

## 3. Sharing Objects
but it is a common misconception that synchronized is only about atomicity or demarcating "critical sections". `Synchronization also has another significant, and subtle, aspect: memory visibility`. We want not only to prevent one thread from modifying the state of an object when another is using it, but also to ensure that when a thread modifies the state of an object, other threads can actually see the changes that were made. But without synchronization, this may not happen. You can ensure that objects are published safely either by using explicit synchronization or by taking advantage of the synchronization built into library classes.  

### One code example -- Stale data

NoVisibility in Listing 3.1 illustrates what can go wrong when threads share data without synchronization. Two threads, the main thread and the reader thread, access the shared variables ready and number. The main thread starts the reader thread and then sets number to 42 and ready to true. The reader thread spins until it sees ready is true, and then prints out number. While it may seem obvious that NoVisibility will print 42, it is in fact possible that it will print zero, or never terminate at all! Because it does not use adequate synchronization, there is no guarantee that the values of ready and number written by the main thread will be visible to the reader thread

```java
public class NoVisibility {
    private static boolean ready;
    private static int number;
    private static class ReaderThread extends Thread {
        public void run() {
            while (!ready)
                Thread.yield();
            System.out.println(number);
        }
    }
    public static void main(String[] args) {
        new ReaderThread().start();
        number = 42;
        ready = true;
    }
}
```

NoVisibility could loop forever because the value of ready might never become visible to the reader thread. Even more strangely, NoVisibility could print zero because the write to ready might be made visible to the reader thread before the write to number, a phenomenon known as reordering. There is no guarantee that operations in one thread will be performed in the order given by the program, as long as the reordering is not detectable from within that thread even if the reordering is apparent to other threads.[1] When the main thread writes first to number and then to done without synchronization, the reader thread could see those writes happen in the opposite order or not at all.

[1] This may seem like a broken design, but it is meant to allow JVMs to take full advantage of the performance of modern multiprocessor hardware. For example, in the absence of synchronization, the Java Memory Model permits the compiler to reorder operations and cache values in registers, and permits CPUs to reorder operations and cache values in processor-specific caches. For more details, see Chapter 16.

In the absence of synchronization, the compiler, processor, and runtime can do some downright weird things to
the order in which operations appear to execute. Attempts to reason about the order in which memory actions "must"
happen in insufflciently synchronized multithreaded programs will almost certainly be incorrect.

12, Reasoning about insufficiently synchronized concurrent programs is prohibitively difficult. This may all sound a little scary, and it should. Fortunately, there's an easy way to avoid these complex issues: always use the proper synchronization whenever data is shared across threads.

13, NoVisibility demonstrated one of the ways that insufficiently synchronized programs can cause surprising results: stale data. Stale data can cause serious and confusing failures such as unexpected exceptions, corrupted data structures, inaccurate computations, and infinite loops.

14, Code example -- Stale value
MutableInteger in Listing 3.2 is not thread-safe because the value field is accessed from both get and set without synchronization. Among other hazards, it is susceptible to stale values: if one thread calls set, other threads calling get may or may not see that update. 
We can make MutableInteger thread safe by synchronizing the getter and setter as shown in SynchronizedInteger in Listing 3.3. Synchronizing only the setter would not be sufficient: threads calling get would still be able to see stale values.

Listing 3.2
@NotThreadSafe
public class MutableInteger {
    private int value;
    public int get() { return value; }
    public void set(int value) { this.value = value; }
}

Listing 3.3
@ThreadSafe
public class SynchronizedInteger {
    @GuardedBy("this") private int value;
    public synchronized int get() { return value; }
    public synchronized void set(int value) { this.value = value; }
}

15, Nonatomic 64-bit Operations
When a thread reads a variable without synchronization, it may see a stale value, but at least it sees a value that was actually placed there by some thread rather than some random value. This safety guarantee is called out-of-thin-air safety.
Out-of-thin-air safety applies to all variables, with one exception: 64-bit numeric variables (double and long) that are not declared volatile (see Section 3.1.4). The Java Memory Model requires fetch and store operations to be atomic, but for nonvolatile long and double variables, the JVM is permitted to treat a 64-bit read or write as two separate 32-bit operations. If the reads and writes occur in different threads, it is therefore possible to read a nonvolatile long and get back the high 32 bits of one value and the low 32 bits of another.[3]
Thus,even if you don't care about stale values, it is not safe to use shared mutable long and double variables in  multi threaded programs unless they are declared volatile or guarded by a lock.
[3] When the Java Virtual Machine Specification was written, many widely used processor architectures could not
efficiently provide atomic 64-bit arithmetic operations.

16, Locking and Visibility
Intrinsic locking can be used to guarantee that one thread sees the effects of another in a predictable manner, as illustrated by Figure 3.1. When thread A executes a synchronized block, and subsequently thread B enters a synchronized block guarded by the same lock, the values of variables that were visible to A prior to releasing the lock are guaranteed to be visible to B upon acquiring the lock. In other words, everything A did in or prior to a synchronized block is visible to B when it executes a synchronized block guarded by the same lock. Without synchronization, there is no such guarantee.

We can now give the other reason for the rule requiring all threads to synchronize on the same lock when accessing a shared mutable variable to guarantee that values written by one thread are made visible to other threads. Otherwise, if a thread reads a variable without holding the appropriate lock, it might see a stale value.

Locking is not just about mutual exclusion; it is also about memory visibility. To ensure that all threads see the most up-to-date values of shared mutable variables, the reading and writing threads must synchronize on a common lock.

17, volatile variables
The Java language also provides an alternative, weaker form of synchronization, volatile variables, to ensure that updates to a variable are propagated predictably to other threads. When a field is declared volatile, the compiler and runtime are put on notice that this variable is shared and that operations on it should not be reordered with other memory operations. Volatile variables are not cached in registers or in caches where they are hidden from other processors, so a read of a volatile variable always returns the most recent write by any thread.

A good way to think about volatile variables is to imagine that they behave roughly like the SynchronizedInteger class in Listing 3.3,replacing reads and writes of the volatile variable with calls to get and set.[4]
Yet accessing a volatile variable performs no locking and so cannot cause the executing thread to block, making volatile variables a lighter-weight synchronization mechanism than synchronized.[5]
[4] This analogy is not exact; the memory visibility effects of SynchronizedInteger are actually slightly stronger than those of volatile variables.
[5] Volatile reads are only slightly more expensive than nonvolatile reads on most current processor architectures.

The visibility effects of volatile variables extend beyond the value of the volatile variable itself. When thread A writes to a volatile variable and subsequently thread B reads that same variable, the values of all variables that were visible to A prior to writing to the volatile variable become visible to B after reading the volatile variable. So from a memory visibility perspective, writing a volatile variable is like exiting a synchronized block and reading a volatile variable is like entering a synchronized block. However, we do not recommend relying too heavily on volatile variables for visibility; code that relies on volatile variables for visibility of arbitrary state is more fragile and harder to understand than code that uses locking

Use volatile variables only when they simplify implementing and verifying your synchronization policy; avoid using volatile variables when veryfing correctness would require subtle reasoning about visibility. Good uses of volatile variables include ensuring the visibility of their own state, that of the object they refer to, or indicating that an important lifecycle event (such as initialization or shutdown) has occurred.

Listing 3.4 illustrates a typical use of volatile variables: checking a status flag to determine when to exit a loop. In this example, our anthropomorphized thread is trying to get to sleep by the time-honored method of counting sheep. For this example to work, the asleep flag must be volatile. Otherwise, the thread might not notice when asleep has been set by another thread.[6] We could instead have used locking to ensure visibility of changes to asleep, but that would have made the code more cumbersome.

Listing 3.4. Counting Sheep.
volatile boolean asleep;
...
    while (!asleep)
        countSomeSheep();

[6] Debugging tip: For server applications, be sure to always specify the -server JVM command line switch when invoking the JVM, even for development and testing. The server JVM performs more optimization than the client JVM, such as hoisting variables out of a loop that are not modified in the loop; code that might appear to work in the development environment (client JVM) can break in the deployment environment (server JVM). For example, had we "forgotten" to declare the variable asleep as volatile in Listing 3.4, the server JVM could hoist the test out of the loop (turning it into an infinite loop), but the client JVM would not. An infinite loop that shows up in development is far less costly than one that only shows up in production.

Volatile variables are convenient, but they have limitations. The most common use for volatile variables is as a completion, interruption, or status flag, such as the asleep flag in Listing 3.4. Volatile variables can be used for other kinds of state information, but more care is required when attempting this. For example, the semantics of volatile are not strong enough to make the increment operation (count++) atomic, unless you can guarantee that the variable is written only from a single thread. (Atomic variables do provide atomic read-modify-write support and can often be used as "better volatile variables"; see Chapter 15.)

Locking can guarantee both visibility and atomicity; volatile variables can only guarantee visibility.

You can use volatile variables only when all the following criteria are met:
    1, Writes to the variable do not depend on its current value, or you can ensure that only a single thread ever updates the value;
    2, The variable does not participate in invariants with other state variables; and
    3, Locking is not required for any other reason while the variable is being accessed.


18, Publication and escape
An object that is published when it should not have been is said to have escaped.

From the perspective of a class C, an alien method is one whose behavior is not fully specified by C. This includes methods in other classes as well as overrideable methods (neither private nor final) in C itself. Passing an object to an alien method must also be considered publishing that object. Since you can't know what code will actually be invoked, you don't know that the alien method won't publish the object or retain a reference to it that might later be used from another thread.

A final mechanism by which an object or its internal state can be published is to publish an inner class instance, as shown in ThisEscape in Listing 3.7. When ThisEscape publishes the EventListener, it implicitly publishes the enclosing ThisEscape instance as well, because inner class instances contain a hidden reference to the enclosing instance.

public class ThisEscape {
    public ThisEscape(EventSource source) {
        source.registerListener(
            new EventListener() {
                public void onEvent(Event e) {
                    doSomething(e);
                }
            });
    }
}

But an object is in a predictable, consistent state only after its constructor returns, so publishing an object from within its constructor can publish an incompletely constructed object. This is true even if the publication is the last statement in the constructor. If the this reference escapes during construction, the object is considered not properly constructed.[8]

[8] More specifically, the this reference should not escape from the thread until after the constructor returns. The this reference can be stored somewhere by the constructor so long as it is not used by another thread until after construction. SafeListener in Listing 3.8 uses this technique.

Do not allow the this reference to escape during construction.

Addison.Wesley.Java.Concurrency.in.Practice.May.2006 Part II

1, A common mistake that can let the this reference escape during construction is to start a thread from a constructor. When an object creates a thread from its constructor, it almost always shares its this reference with the new thread, either explicitly (by passing it to the constructor) or implicitly (because the Thread or Runnable is an inner class of the owning object). The new thread might then be able to see the owning object before it is fully constructed. There's nothing wrong with creating a thread in a constructor, but it is best not to start the thread immediately. Instead, expose a start or initialize method that starts the owned thread. (See Chapter 7 for more on service lifecycle issues.) 

Calling an overrideable instance method (one that is neither private nor final) from the constructor can also allow the this reference to escape.

If you are tempted to register an event listener or start a thread from a constructor, you can avoid the improper construction by using a
private constructor and a public factory method, as shown in SafeListener in Listing 3.8.

Listing 3.8. Using a Factory Method to Prevent the this Reference from Escaping During Construction.
class SafeListener {
    private final EventListener listener;

    private SafeListener() {
        listener = new EventListener() {
            public void onEvent(Event e) {
                doSomething(e);
            }
        };
    }

    public static SafeListener newInstance(EventSource source) {
        SafeListener safe = new SafeListener();
        source.registerListener(safe.listener);
        return safe;
    }
}

2, Thread confinement
one way to avoid this requirement is to not share. If data is only accessed from a single thread, no synchronization is needed. This technique, thread confinement, is one of the simplest ways to achieve
thread safety. When an object is confined to a thread, such usage is automatically thread-safe even if the confined object itself is not

Swing uses thread confinement extensively. The Swing visual components and data model objects are not thread safe; instead, safety is achieved by confining them to the Swing event dispatch thread. To use Swing properly, code running in threads other than the event
thread should not access these objects. (To make this easier, Swing provides the invokeLater mechanism to schedule a Runnable for execution in the event thread.) Many concurrency errors in Swing applications stem from improper use of these confined objects from another thread.

Another common application of thread confinement is the use of pooled JDBC (Java Database Connectivity) Connection objects. The JDBC specification does not require that Connection objects be thread-safe.[9]
In typical server applications, a thread acquires a connection from the pool, uses it for processing a single request, and returns it. Since most requests, such as servlet requests or EJB(Enterprise JavaBeans) calls, are processed synchronously by a single thread, and the pool will not dispense the same connection to another thread until it has been returned, this pattern of connection management implicitly confines the Connection to that thread for the duration of the request.
[9] The connection pool implementations provided by application servers are thread-safe; connection pools are necessarily accessed from multiple threads, so a non-thread-safe implementation would not make sense.

The language and core libraries provide mechanisms that can help in maintaining thread confinement local variables and the ThreadLocal class but even with these, it is still the programmer's responsibility to ensure that thread-confined objects do not escape from their intended thread.

3, Ad-hoc thread confinement
Ad-hoc thread confinement describes when the responsibility for maintaining thread confinement falls entirely on the implementation.

The decision to use thread confinement is often a consequence of the decision to implement a particular subsystem, such as the GUI, as a single-threaded subsystem. Single-threaded subsystems can sometimes offer a simplicity benefit that outweighs the fragility of ad-hoc thread confinement.[10]
[10] Another reason to make a subsystem single-threaded is deadlock avoidance; this is one of the primary
reasons most GUI frameworks are single-threaded. Single-threaded subsystems are covered in Chapter 9.

Because of its fragility, ad-hoc thread confinement should be used sparingly; if possible, use one of the stronger forms of thread confinment (stack confinement or ThreadLocal) instead.

4, Stack confinement
Stack confinement is a special case of thread confinement in which an object can only be reached through local variables. Just as encapsulation can make it easier to preserve invariants, local variables can make it easier to confine objects to a thread.

There is no way to obtain a reference to a primitive variable, so the language semantics ensure that primitive local variables are always stack confined.

Using a non-thread-safe object in a within-thread context is still thread-safe. However, be careful: the design requirement that the object be confined to the executing thread, or the awareness that the confined object is not thread-safe, often exists only in the head of the developer when the code is written. If the assumption of within-thread usage is not clearly documented, future maintainers might
mistakenly allow the object to escape.

5, ThreadLocal Confinement
A more formal means of maintaining thread confinement is ThreadLocal, which allows you to associate a per-thread value with a value-holding object. Thread-Local provides get and set accessor methods that maintain a separate copy of the value for each thread that uses it, so a get returns the most recent value passed to set from the currently executing thread.

6, example of ThreadLocal

Thread-local variables are often used to prevent sharing in designs based on mutable Singletons or global variables. For example, a single-threaded application might maintain a global database connection that is initialized at startup to avoid having to pass a Connection to every method. Since JDBC connections may not be thread-safe, a multithreaded application that uses a global connection without additional coordination is not thread-safe either. By using a ThreadLocal to store the JDBC connection, as in ConnectionHolder in Listing 3.10, each thread will have its own connection.

    private static ThreadLocal<Connection> connectionHolder = new ThreadLocal<Connection>() {
        public Connection initialValue() {
            return DriverManager.getConnection(DB_URL);
        }
    };

    public static Connection getConnection() {
        return connectionHolder.get();
    }

This technique can also be used when a frequently used operation requires a temporary object such as a buffer and wants to avoid reallocating the temporary object on each invocation. 

For example, before Java 5.0, Integer.toString used a ThreadLocal to store the 12-byte buffer used for formatting its result, rather than using a shared static buffer (which would require locking) or allocating a new buffer for each invocation.[11]

[11] This technique is unlikely to be a performance win unless the operation is performed very frequently or the allocation is unusually expensive. In Java 5.0, it was replaced with the more straightforward approach of allocating a new buffer for every invocation, suggesting that for something as mundane as a temporary buffer, it is not a performance win.

When a thread calls ThreadLocal.get for the first time, initialValue is consulted to provide the initial value for that thread(If set method were not called before the first get. Moreover, it would be called again if there were such invocation sequences like remove() and then get() ). Conceptually,you can think of a ThreadLocal<T> as holding a Map<Thread,T> that stores the thread-specific values, though this is not how it is actually implemented. The thread-specific values are stored in the Thread object itself; when the thread terminates, the thread-specific values can be garbage collected.

If you are porting a single-threaded application to a multithreaded environment, you can preserve thread safety by converting shared global variables into ThreadLocals, if the semantics of the shared globals permits this; an applicationwide cache would not be as useful if it were turned into a number of thread-local caches.

ThreadLocal is widely used in implementing application frameworks. For example, J2EE containers associate a transaction context with an executing thread for the duration of an EJB call. This is easily implemented using a static THRead-Local holding the transaction context: when framework code needs to determine what transaction is currently running, it fetches the transaction context from this ThreadLocal. This is convenient in that it reduces the need to pass execution context information into every method, but couples any code that uses this mechanism to the framework.

It is easy to abuse THReadLocal by treating its thread confinement property as a license to use global variables or as a means of creating "hidden" method arguments. Like global variables, thread-local variables can detract from reusability and introduce hidden couplings among classes, and should therefore be used with care.

7, Immutability
The other end-run around the need to synchronize is to use immutable objects [EJ Item 13].

An immutable object is one whose state cannot be changed after construction. Immutable objects are inherently thread-safe; their invariants are established by the constructor, and if their state cannot be changed, these invariants always hold.

Immutable objects are always thread-safe.

Neither the Java Language Specification nor the Java Memory Model formally defines immutability, but immutability is not equivalent to simply declaring all fields of an object final. An object whose fields are all final may still be mutable, since final fields can hold references to mutable objects.

An object is immutable if:
-- Its state cannot be modifled after construction;
-- All its flelds are final;[12]and
-- It is properly constructed (the this reference does not escape during construction).

[12] It is technically possible to have an immutable object without all fields being final. String is such a class but this relies on delicate reasoning about benign data races that requires a deep understanding of the Java Memory Model. (For the curious: String lazily computes the hash code the first time hashCode is called and caches it in a nonfinal field, but this works only because that field can take on only one non default value that is the same every time it is computed because it is derived deterministically from immutable state. Don't try this at home.)

Immutable objects can still use mutable objects internally to manage their state, as illustrated by ThreeStooges in Listing 3.11. While the Set that stores the names is mutable, the design of ThreeStooges makes it impossible to modify that Set after construction. The stooges reference is final, so all object state is reached through a final field. The last requirement, proper construction, is easily met since the constructor does nothing that would cause the this reference to become accessible to code other than the constructor and its caller.

@Immutable
final class ThreeStooges {
    private final Set<String> stooges = new HashSet<String>();

    public ThreeStooges() {
        stooges.add("Moe");
        stooges.add("Larry");
        stooges.add("Curly");
    }

    public boolean isStooge(String name) {
        return stooges.contains(name);
    }
}

Because program state changes all the time, you might be tempted to think that immutable objects are of limited use, but this is not the case. There is a difference between an object being immutable and the reference to it being immutable. Program state stored in immutable objects can still be updated by "replacing" immutable objects with a new instance holding new state; the next section offers an example of this technique.[13]
[13] Many developers fear that this approach will create performance problems, but these fears are usually unwarranted. Allocation is cheaper than you might think, and immutable objects offer additional performance advantages such as reduced need for locking or defensive copies and reduced impact on generational garbage collection.

8 Immutable objects can sometimes provide a weak form of atomicity
However, immutable objects can sometimes provide a weak form of atomicity.
Example: Using Volatile to Publish Immutable Objects

The factoring servlet performs two operations that must be atomic: updating the cached result and conditionally fetching the cached factors if the cached number matches the requested number. Whenever a group of related data items must be acted on atomically,consider creating an immutable holder class for them, such as OneValueCache[14] in Listing 3.12.
[14] OneValueCache wouldn't be immutable without the copyOf calls in the constructor and getter. Arrays.copyOf was added as a convenience in Java 6; clone would also work.

Race conditions in accessing or updating multiple related variables can be eliminated by using an immutable object to hold all the variables.

VolatileCachedFactorizer in Listing 3.13 uses a OneValueCache to store the cached number and factors. When a thread sets the volatile cache field to reference a new OneValueCache, the new cached data becomes immediately visible to other threads.

The cache-related operations cannot interfere with each other because One-ValueCache is immutable and the cache field is accessed only once in each of the relevant code paths. This combination of an immutable holder object for multiple state variables related by an invariant, and a volatile reference used to ensure its timely visibility, allows VolatileCachedFactorizer to be thread-safe even though it does no explicit locking.

Listing 3.12. Immutable Holder for Caching a Number and its Factors.
@Immutable
class OneValueCache {
    private final BigInteger lastNumber;
    private final BigInteger[] lastFactors;

    public OneValueCache(BigInteger i, BigInteger[] factors) {
        lastNumber = i;
        lastFactors = Arrays.copyOf(factors, factors.length);
    }

    public BigInteger[] getFactors(BigInteger i) {
        if (lastNumber == null || !lastNumber.equals(i))
            return null;
        else
            return Arrays.copyOf(lastFactors, lastFactors.length);
    }
}

Listing 3.13. Caching the Last Result Using a Volatile Reference to an Immutable Holder Object.
@ThreadSafe
public class VolatileCachedFactorizer implements Servlet {
    private volatile OneValueCache cache = new OneValueCache(null, null);

    public void service(ServletRequest req, ServletResponse resp) {
        BigInteger i = extractFromRequest(req);
        BigInteger[] factors = cache.getFactors(i);
        if (factors == null) {
            factors = factor(i);
            cache = new OneValueCache(i, factors);
        } 
        encodeIntoResponse(resp, factors);
    }
}

9, Unsafe publication
Listing 3.14
    // Unsafe publication
    public Holder holder;

    public void initialize() {
        holder = new Holder(42);
    }

You may be surprised at how badly this harmless-looking example could fail. Because of visibility problems, the Holder could appear to another thread to be in an inconsistent state, even though its invariants were properly established by its constructor! This improper publication could allow another thread to observe a partially constructed object.

You cannot rely on the integrity of partially constructed objects. An observing thread could see the object in an inconsistent state, and then later see its state suddenly change, even though it has not been modified since publication. In fact, if the Holder in Listing 3.15 is published using the unsafe publication idiom in Listing 3.14, and a thread other than the publishing thread were to call assertSanity, it could throw AssertionError![15]
[15] The problem here is not the Holder class itself, but that the Holder is not properly published. However, Holder can be made immune to improper publication by declaring the n field to be final, which would make Holder immutable; see Section 3.5.2.
Listing 3.15. Class at Risk of Failure if Not Properly Published.
public class Holder {
    private int n;

    public Holder(int n) {
        this.n = n;
    }

    public void assertSanity() {
        if (n != n)
            throw new AssertionError("This statement is false.");
    }
}

Because synchronization was not used to make the Holder visible to other threads, we say the Holder was not properly published.

Two things can go wrong with improperly published objects. Other threads could see a stale value for the holder field, and thus see a null reference or other older value even though a value has been placed in holder. But far worse, other threads could see an up-to-date value for the holder reference, but stale values for the state of the Holder.[16]
To make things even less predictable, a thread may see a stale value the first time it reads a field and then a more up-to-date value the next time, which is why assertSanity can throw AssertionError.
[16] While it may seem that field values set in a constructor are the first values written to those fields and therefore that there are no "older" values to see as stale values, the Object constructor first writes the default values to all fields before subclass constructors run. It is therefore possible to see the default value for a field as a stale value.

10, Immutable objects and initialization safety
Because immutable objects are so important, the Java Memory Model offers a special guarantee of initialization safety for sharing immutable objects.

Immutable objects can be used safely by any thread without additional synchronization, even when synchronization is not used to publish them.

This guarantee extends to the values of all final fields of properly constructed objects; final fields can be safely accessed without additional synchronization. However, if final fields refer to mutable objects, synchronization is still required to access the state of the objects they refer to.

11, Safe Publication Idioms
Objects that are not immutable must be safely published, which usually entails synchronization by both the publishing and the consuming thread. 

For the moment, let's focus on ensuring that the consuming thread can see the object in its as published state; we'll deal with visibility of modifications made after publication soon.

To publish an object safely, both the reference to the object and the object's state must be made visible to other threads at the same time. A properly constructed object can be safely published by:
    Initializing an object reference from a static initializer;
    Storing a reference to it into a volatile field or AtomicReference;
    Storing a reference to it into a final field of a properly constructed object; or
    Storing a reference to it into a field that is properly guarded by a lock.


Addison.Wesley.Java.Concurrency.in.Practice.May.2006 Part III

1 Thread safe collections

The thread-safe library collections offer the following safe publication guarantees, even if the Javadoc is less than clear on the subject:
    Placing a key or value in a Hashtable, synchronizedMap, or Concurrent-Map safely publishes it to any thread that retrieves it from the Map (whether directly or via an iterator);
    Placing an element in a Vector, CopyOnWriteArrayList, CopyOnWrite-ArraySet, synchronizedList, or synchronizedSet safely publishes it to any thread that retrieves it from the collection;
    Placing an element on a BlockingQueue or a ConcurrentLinkedQueue safely publishes it to any thread that retrieves it from the queue.
    Other handoff mechanisms in the class library (such as Future and Exchanger) also constitute safe publication; we will identify these as providing safe publication as they are introduced.

2 , Using a static initializer is often the easiest and safest way to publish objects that can be statically constructed:
public static Holder holder = new Holder(42);
Static initializers are executed by the JVM at class initialization time; because of internal synchronization in the JVM, this mechanism is guaranteed to safely publish any objects initialized in this way [JLS 12.4.2].

3,  -- Immutable objects can be published through any mechanism;
    -- Effectively immutable objects must be safely published;
    -- Mutable objects must be safely published, and must be either threadsafe or guarded by a lock.

4, Designing a Thread-safe Class
Encapsulation makes it possible to determine that a class is thread-safe without having to examine the entire program.

The design process for a thread-safe class should include these three basic elements:
    Identify the variables that form the object's state;
    Identify the invariants that constrain the state variables;
    Establish a policy for managing concurrent access to the object's state.

5, Simple Thread-safe Counter Using the Java Monitor Pattern
@ThreadSafe
public final class Counter {
    @GuardedBy("this")
    private long value = 0;

    public synchronized long getValue() {
        return value;
    }

    public synchronized long increment() {
        if (value == Long.MAX_VALUE)
            throw new IllegalStateException("counter overflow");
        return ++value;
    }
}

6, When defining which variables form an object's state, we want to consider only the data that object owns.

7, Instance confinement
Encapsulation simplifies making classes thread-safe by promoting instance confinement, often just called confinement [CPJ 2.3.3]

Encapsulating data within an object confines access to the data to the object's methods, making it easier to ensure that the data is always accessed with the appropriate lock held.

Instance confinement is one of the easiest ways to build thread-safe classes. It also allows flexibility in the choice of locking strategy. 

Instance confinement also allows different state variables to be guarded by different locks. (For an example of a class that uses multiple lock objects to guard its state, see ServerStatus on 236.)

8, The Java Monitor Pattern
An object following the Java monitor pattern encapsulates all its mutable state and guards it with the object's own intrinsic lock.
Following the principle of instance confinement to its logical conclusion leads you to the Java monitor pattern.[2]

The Java monitor pattern is used by many library classes, such as Vector and Hashtable. Sometimes a more sophisticated
synchronization policy is needed; Chapter 11 shows how to improve scalability through finer-grained locking strategies. The primary advantage of the Java monitor pattern is its simplicity.
The Java monitor pattern is merely a convention; any lock object could be used to guard an object's state so long as it is used consistently. Listing 4.3 illustrates a class that uses a private lock to guard its state.

Guarding State with a Private Lock.
public class PrivateLock {
    private final Object myLock = new Object();
    @GuardedBy("myLock")
    Widget widget;

    void someMethod() {
        synchronized (myLock) {
            // Access or modify the state of widget
        }
    }
}

There are advantages to using a private lock object instead of an object's intrinsic lock (or any other publicly accessible lock). Making the lock object private encapsulates the lock so that client code cannot acquire it, whereas a publicly accessible lock allows client code to participate in its synchronization policy correctly or incorrectly. Clients that improperly acquire another object's lock could cause liveness problems, and verifying that a publicly accessible lock is properly used requires examining the entire program rather than a single class.

9, The Java monitor pattern is useful when building classes from scratch or composing classes out of objects that are not thread-safe.

10, Delegating Thread Safety

All but the most trivial objects are composite objects. The Java monitor pattern is useful when building classes from scratch or composing classes out of objects that are not thread-safe. But what if the components of our class are already thread-safe? Do we need to add an additional layer of thread safety? The answer is . . . "it depends". In some cases a composite made of thread-safe components is thread-safe. 

We can also delegate thread safety to more than one underlying state variable as long as those underlying state variables are independent, meaning that the composite class does not impose any invariants involving the multiple state variables.

11, If a state variable is thread-safe, does not participate in any invariants that constrain its value, and has no prohibited state transitions for any of its operations, then it can safely be published.

12, private constructor capture idiom
[6] The private constructor exists to avoid the race condition that would occur if the copy constructor were implemented as this(p.x, p.y); this is an example of the private constructor capture idiom (Bloch and Gafter, 2005).

@ThreadSafe
public class SafePoint {
    @GuardedBy("this")
    private int x, y;

    private SafePoint(int[] a) {
        this(a[0], a[1]);
    }

    public SafePoint(SafePoint p) {
        this(p.get());
    }

    public SafePoint(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public synchronized int[] get() {
        return new int[] { x, y };
    }

    public synchronized void set(int x, int y) {
        this.x = x;
        this.y = y;
    }
}

13, Adding Functionality to Existing Thread-safe Classes
a, The safest way to add a new atomic operation is to modify the original class to support the desired operation, but this is not always possible because you may not have access to the source code or may not be free to modify it.

If you can modify the original class, you need to understand the implementation's synchronization policy so that you can enhance it in a manner consistent with its original design.

b, Another approach is to extend the class, assuming it was designed for extension.

Extension is more fragile than adding code directly to a class, because the implementation of the synchronization policy is now distributed over multiple, separately maintained source files. If the underlying class were to change its synchronization policy by choosing a different lock to guard its state variables, the subclass would subtly and silently break, because it no longer used the right lock to control concurrent access to the base class's state.

c,A third strategy is to extend the functionality of the class without extending the class itself by placing extension code in a "helper" class.
For an ArrayList wrapped with a Collections.synchronizedList wrapper, neither of these approaches adding a method to the original class or extending the class works because the client code does not even know the class of the List object returned from the synchronized wrapper factories. 

d, There is a less fragile alternative for adding an atomic operation to an existing class: composition. 

13.1 example of failure use of 13.c principle and fix --- Client-side locking or external locking

Listing 4.14. Non-thread-safe Attempt to Implement Put-if-absent. Don't Do this
@NotThreadSafe
public class ListHelper<E> {
    public List<E> list = Collections.synchronizedList(new ArrayList<E>());
    ...
    public synchronized boolean putIfAbsent(E x) {
        boolean absent = !list.contains(x);
        if (absent)
            list.add(x);
        return absent;
    }
}

Why wouldn't this work? After all, putIfAbsent is synchronized, right? The problem is that it synchronizes on the wrong lock. Whatever lock the List uses to guard its state, it sure isn't the lock on the ListHelper. ListHelper provides only the illusion of synchronization; the various list operations, while all synchronized, use different locks, which means that putIfAbsent is not atomic relative to other operations on the List. So there is no guarantee that another thread won't modify the list while putIfAbsent is executing.

To make this approach work, we have to use the same lock that the List uses by using client-side locking or external locking. 

Client-side locking entails guarding client code that uses some object X with _the lock X uses_ to guard its own state. In order to use client-side locking, you must know what lock X uses.
The documentation for Vector and the synchronized wrapper classes states, albeit obliquely, that they support client-side locking, by using the intrinsic lock for the Vector or the wrapper collection (not the wrapped collection). Listing 4.15 shows a putIfAbsent operation on
a thread-safe List that correctly uses client-side locking.

Listing 4.15. Implementing Put-if-absent with Client-side Locking.

@ThreadSafe
public class ListHelper<E> {
    public List<E> list = Collections.synchronizedList(new ArrayList<E>());

    public boolean putIfAbsent(E x) {
        synchronized (list) {
            boolean absent = !list.contains(x);
            if (absent)
                list.add(x);
            return absent;
        }
    }
}

If extending a class to add another atomic operation is fragile because it distributes the locking code for a class over multiple classes in an object hierarchy, client-side locking is even more fragile because it entails putting locking code for class C into classes that are totally unrelated to C. Exercise care when using client-side locking on classes that do not commit to their locking strategy.

Client-side locking has a lot in common with class extension they both couple the behavior of the derived class to the implementation of the base class. Just as extension violates encapsulation of implementation [EJ Item 14], client-side locking violates encapsulation of synchronization policy.

14, Composition

There is a less fragile alternative for adding an atomic operation to an existing class: composition. 

ImprovedList in Listing 4.16 implements the List operations by delegating them to an underlying List instance, and adds an atomic putIfAbsent method. (Like Collections.synchronizedList and other collections wrappers, ImprovedList assumes that once a list is passed to its constructor, the client will not use the underlying list directly again,!!! accessing it only through the ImprovedList.)

@ThreadSafe
public class ImprovedList<T> implements List<T> {
    private final List<T> list;
    public ImprovedList(List<T> list) {
        this.list = list;
    }
    public synchronized boolean putIfAbsent(T x) {
        boolean contains = list.contains(x);
        if (contains)
            list.add(x);
        return !contains;
    }
        
    public synchronized void clear() {
        list.clear();
    }
    // ... similarly delegate other List methods
}

ImprovedList adds an additional level of locking using its own intrinsic lock. It does not care whether the underlying List is thread-safe,because it provides its own consistent locking that provides thread safety even if the List is not thread-safe or changes its locking implementation. While the extra layer of synchronization may add some small performance penalty,[7] the implementation in ImprovedList is less fragile than attempting to mimic the locking strategy of another object. In effect, we've used the Java monitor pattern to encapsulate an existing List, and this is guaranteed to provide thread safety so long as our class holds the only outstanding reference to the underlying List.

15, Should we assume that access to an object can be made thread-safe by acquiring its lock first? (This risky technique works only if we control all the code that accesses that object; otherwise, it provides only the illusion of thread safety.)

16, SimpleDateFormat isn't thread-safe
To make matters worse, our intuition may often be wrong on which classes are "probably thread-safe" and which are not. As an example, java.text.SimpleDateFormat isn't thread-safe, but the Javadoc neglected to mention this until JDK 1.4.

17, HttpSession concurrent concerns
On the other hand, the objects placed in the ServletContext or HttpSession with setAttribute are owned by the web application, not the servlet container. The servlet specification does not suggest any mechanism for coordinating concurrent access to shared attributes. So attributes stored by the container on behalf of the web application should be thread-safe or effectively immutable. If all the container did was store these attributes on behalf of the web application, another option would be to ensure that they are  consistently guarded by a lock when accessed from servlet application code. But because the container may want to serialize objects in the HttpSession for replication or passivation purposes, and the servlet container can't possibly know your locking protocol, you should make them thread-safe.

HttpSession Passivation and Activation (https://access.redhat.com/documentation/en-US/JBoss_Enterprise_Web_Platform/5/html/Administration_And_Configuration_Guide/clustering-http-passivation.html)
--When the container requests the creation of a new session. If the number of currently active sessions exceeds a configurable limit, an attempt is made to passivate sessions to make room in memory.
--Periodically (by default every ten seconds) as the JBoss Web background task thread runs.
--When the web application is deployed and a backup copy of sessions active on other servers is acquired by the newly deploying web application's session manager.

18, JDBC connection concerns
On the other hand, we would not make the same argument about the JDBC Connection objects dispensed by the DataSource, since these are not necessarily intended to be shared by other activities until they are returned to the pool. So if an activity that obtains a JDBC Connection spans multiple threads, it must take responsibility for ensuring that access to the Connection is properly guarded by synchronization. (In most applications, activities that use a JDBC Connection are implemented so as to confine the Connection to a specific thread anyway.)

19,Where practical, delegation is one of the most effective strategies for creating thread-safe classes: just let existing thread-safe classes manage all the state.

20, Problems with Synchronized Collections
The synchronized collection classes include Vector and Hashtable, part of the original JDK, as well as their cousins added in JDK 1.2, the synchronized wrapper classes created by the Collections.synchronizedXxx factory methods. These classes achieve thread safety by encapsulating their state and synchronizing every public method so that only one thread at a time can access the collection state.

The synchronized collections are thread-safe, but you may sometimes need to use additional client-side locking to guard compound actions. Common compound actions on collections include iteration (repeatedly fetch elements until the collection is exhausted),navigation (find the next element after this one according to some order), and conditional operations such as put-if-absent (check if a Map
has a mapping for key K, and if not, add the mapping (K,V)). With a synchronized collection, these compound actions are still technically thread-safe even without client-side locking, but they may not behave as you might expect when other threads can concurrently modify the collection.

Listing 5.3. Iteration that may Throw ArrayIndexOutOfBoundsException.
for (int i = 0; i < vector.size(); i++)
    doSomething(vector.get(i));

Listing 5.4. Iteration with Client-side Locking.
synchronized (vector) {
    for (int i = 0; i < vector.size(); i++)
        doSomething(vector.get(i));
}

19, Iterators and Concurrentmodificationexception

We use Vector for the sake of clarity in many of our examples, even though it is considered a "legacy" collection class. But the more "modern" collection classes do not eliminate the problem of compound actions. The standard way to iterate a Collection is with an Iterator, either explicitly or through the for-each loop syntax introduced in Java 5.0, but using iterators does not obviate the need to lock the
collection during iteration if other threads can concurrently modify it. The iterators returned by the synchronized collections are not designed to deal with concurrent modification, and they are fail-fast meaning that if they detect that the collection has changed since iteration began, they throw the unchecked ConcurrentModificationException.
These fail-fast iterators are not designed to be foolproof they are designed to catch concurrency errors on a "good-faith-effort" basis and thus act only as early-warning indicators for concurrency problems. They are implemented by associating a modification count with the collection: if the modification count changes during iteration, hasNext or next throws ConcurrentModificationException. However, this check
is done without synchronization, so there is a risk of seeing a stale value of the modification count and therefore that the iterator does not realize a modification has been made. This was a deliberate design tradeoff to reduce the performance impact of the concurrent modification detection code.[2]

[2] ConcurrentModificationException can arise in single-threaded code as well; this happens when objects are removed from the collection directly rather than through Iterator.remove

There are several reasons, however, why locking a collection during iteration may be undesirable. Other threads that need to access the collection will block until the iteration is complete; if the collection is large or the task performed for each element is lengthy, they could wait a long time. Also, if the collection is locked as in Listing 5.4, doSomething is being called with a lock held, which is a risk
factor for deadlock (see Chapter 10). Even in the absence of starvation or deadlock risk, locking collections for significant periods of time hurts application scalability. The longer a lock is held, the more likely it is to be contended, and if many threads are blocked waiting for a lock throughput and CPU utilization can suffer (see Chapter 11).
An alternative to locking the collection during iteration is to clone the collection and iterate the copy instead. Since the clone is thread-confined, no other thread can modify it during iteration, eliminating the possibility of ConcurrentModificationException. (The collection still must be locked during the clone operation itself.) Cloning the collection has an obvious performance cost; whether this is a favorable tradeoff depends on many factors including the size of the collection, how much work is done for each element, the relative frequency of iteration compared to other collection operations, and responsiveness and throughput requirements.

1, Listing 5.6. Iteration Hidden within String Concatenation. Don't Do this.
public class HiddenIterator {
    @GuardedBy("this")
    private final Set<Integer> set = new HashSet<Integer>();
    public synchronized void add(Integer i) {
        set.add(i);
    }
    public synchronized void remove(Integer i) {
        set.remove(i);
    }
    public void addTenThings() {
        Random r = new Random();
        for (int i = 0; i < 10; i++)
            add(r.nextInt());
        System.out.println("DEBUG: added ten elements to " + set);  // this line, synchronization error
    }
}
While locking can prevent iterators from throwing ConcurrentModificationException, you have to remember to use locking everywhere a shared collection might be iterated. This is trickier than it sounds, as iterators are sometimes hidden, as in HiddenIterator in Listing 5.6

The addTenThings method could throw ConcurrentModificationException, because the collection is being iterated by toString in the process of preparing the debugging message. Of course, the real problem is that HiddenIterator is not thread-safe; the HiddenIterator lock should be acquired before using set in the println call, but debugging and logging code commonly neglect to do this.

The real lesson here is that the greater the distance between the state and the synchronization that guards it, the more likely that someone will forget to use proper synchronization when accessing that state. If HiddenIterator wrapped the HashSet with a synchronizedSet, encapsulating the synchronization, this sort of error would not occur.

Just as encapsulating an object's state makes it easier to preserve its invariants, encapsulating its synchronization makes it easier to enforce its synchronization policy.

Iteration is also indirectly invoked by the collection's hashCode and equals methods, which may be called if the collection is used as an element or key of another collection. Similarly, the containsAll, removeAll, and retainAll methods, as well as the constructors that take collections are arguments, also iterate the collection. All of these indirect uses of iteration can cause ConcurrentModificationException.

2, Concurrent collection
Java 5.0 adds ConcurrentHashMap, a replacement for synchronized hash-based Map implementations, and CopyOnWriteArrayList, a replacement for synchronized List implementations for cases where traversal is the dominant operation. The new ConcurrentMap interface adds support for common compound actions such as put-if-absent, replace, and conditional remove.

Java 5.0 also adds two new collection types, Queue and BlockingQueue. A Queue is intended to hold a set of elements temporarily while they await processing. Several implementations are provided, including ConcurrentLinkedQueue, a traditional FIFO queue, and PriorityQueue, a (non concurrent) priority ordered queue. Queue operations do not block; if the queue is empty, the retrieval operation returns null. While you can simulate the behavior of a Queue with a List in fact, LinkedList also implements Queue 
the Queue classes were added because eliminating the random-access requirements of List admits more efficient concurrent implementations.
BlockingQueue extends Queue to add blocking insertion and retrieval operations. If the queue is empty, a retrieval blocks until an element is available, and if the queue is full (for bounded queues) an insertion blocks until there is space available. Blocking queues are extremely useful in producer-consumer designs, and are covered in greater detail in Section 5.3.
Just as ConcurrentHashMap is a concurrent replacement for a synchronized hash-based Map, Java 6 adds ConcurrentSkipListMap and ConcurrentSkipListSet, which are concurrent replacements for a synchronized SortedMap or SortedSet (such as TreeMap or TreeSet wrapped with synchronizedMap).

3, Replacing synchronized collections with concurrent collections can offer dramatic scalability improvements with little risk.

4, ConcurrentHashMap

The synchronized collections classes hold a lock for the duration of each operation. Some operations, such as HashMap.get or List.contains, may involve more work than is initially obvious: traversing a hash bucket or list to find a specific object entails calling equals (which itself may involve a fair amount of computation) on a number of candidate objects. In a hash-based collection, if hashCode does
not spread out hash values well, elements may be unevenly distributed among buckets; in the degenerate case, a poor hash function will turn a hash table into a linked list. Traversing a long list and calling equals on some or all of the elements can take a long time, and during that time no other thread can access the collection.

lock striping
ConcurrentHashMap is a hash-based Map like HashMap, but it uses an entirely different locking strategy that offers better concurrency and scalability. Instead of synchronizing every method on a common lock, restricting access to a single thread at a time, it uses a finer-grained locking mechanism called lock striping (see Section 11.4.3) to allow a greater degree of shared access. Arbitrarily many reading threads can access the map concurrently, readers can access the map concurrently with writers, and a limited number of writers can modify the map concurrently. The result is far higher throughput under concurrent access, with little performance penalty for single-threaded access.

ConcurrentHashMap, along with the other concurrent collections, further improve on the synchronized collection classes by providing iterators that do not throw ConcurrentModificationException, thus eliminating the need to lock the collection during iteration. The iterators returned by ConcurrentHashMap are weakly consistent instead of fail-fast. A weakly consistent iterator can tolerate concurrent
modification, traverses elements as they existed when the iterator was constructed, and may (but is not guaranteed to) reflect modifications to the collection after the construction of the iterator.

As with all improvements, there are still a few tradeoffs. The semantics of methods that operate on the entire Map, such as size and isEmpty, have been slightly weakened to reflect the concurrent nature of the collection. Since the result of size could be out of date by the time it is computed, it is really only an estimate, so size is allowed to return an approximation instead of an exact count.
While at first this may seem disturbing, in reality methods like size and isEmpty are far less useful in concurrent environments because these quantities are moving targets. So the requirements for these operations were weakened to enable performance optimizations for the most important operations, primarily get, put, containsKey, and remove.

The one feature offered by the synchronized Map implementations but not by ConcurrentHashMap is the ability to lock the map for exclusive access. With Hashtable and synchronizedMap, acquiring the Map lock prevents any other thread from accessing it. This might be necessary in unusual cases such as adding several mappings atomically, or iterating the Map several times and needing to see the same elements in the same order. On the whole, though, this is a reasonable tradeoff: concurrent collections should be expected to change their contents continuously.
Because it has so many advantages and so few disadvantages compared to Hashtable or synchronizedMap, replacing synchronized Map implementations with ConcurrentHashMap in most cases results only in better scalability. Only if your application needs to lock the map for exclusive access[3]
is ConcurrentHashMap not an appropriate drop-in replacement.
[3] Or if you are relying on the synchronization side effects of the synchronizedMap implementations.

5, Additional Atomic Map Operations
Since a ConcurrentHashMap cannot be locked for exclusive access, we cannot use client-side locking to create new atomic operations such as put-if-absent, as we did for Vector in Section 4.4.1. Instead, a number of common compound operations such as put-if-absent,remove-if-equal, and replace-if-equal are implemented as atomic operations and specified by the ConcurrentMap interface, shown in Listing 5.7. If you find yourself adding such functionality to an existing synchronized Map implementation, it is probably a sign that you should consider using a ConcurrentMap instead.

6, CopyOnWriteArrayList
CopyOnWriteArrayList is a concurrent replacement for a synchronized List that offers better concurrency in some common situations and eliminates the need to lock or copy the collection during iteration. (Similarly, CopyOnWriteArraySet is a concurrent replacement for a synchronized Set.)

They implement mutability by creating and republishing a new copy of the collection every time it is modified. Iterators for the copy-on-write collections retain a reference to the backing array that was current at the start of iteration, and since this will never change, they need to synchronize only briefly to ensure visibility of the array contents. ?

The iterators returned by the copy-on-write collections do not throw ConcurrentModificationException and return the elements exactly as they were at the time the iterator was created, regardless of subsequent modifications.

Obviously, there is some cost to copying the backing array every time the collection is modified, especially if the collection is large; the copy-on-write collections are reasonable to use only when iteration is far more common than modification. This criterion exactly describes many event-notification systems: delivering a notification requires iterating the list of registered listeners and calling each one of them, and in most cases registering or unregistering an event listener is far less common than receiving an event notification.

7, BlockingQueue implementation

Build resource management into your design early using blocking queues it is a lot easier to do this up front than to retrofit it later. Blocking queues make this easy for a number of situations, but if blocking queues don't fit easily into your design, you can create other blocking data structures using
Semaphore (see Section 5.5.3).

The class library contains several implementations of BlockingQueue. LinkedBlockingQueue and ArrayBlockingQueue are FIFO queues,analogous to LinkedList and ArrayList but with better concurrent performance than a synchronized List. PriorityBlockingQueue is a priority-ordered queue, which is useful when you want to process elements in an order other than FIFO.

The last BlockingQueue implementation, SynchronousQueue, is not really a queue at all, in that it maintains no storage space for queued elements. Instead, it maintains a list of queued threads waiting to enqueue or dequeue an element. In the dish-washing analogy,this would be like having no dish rack, but instead handing the washed dishes directly to the next available dryer. While this may seem a strange way to implement a queue, it reduces the latency associated with moving data from producer to consumer because the work can be handed off directly. (In a traditional queue, the enqueue and dequeue operations must complete sequentially before a unit of work can be handed off.) The direct handoff also feeds back more information about the state of the task to the producer; when the handoff is accepted, it knows a consumer has taken responsibility for it, rather than simply letting it sit on a queue somewhere much like the difference between handing a document to a colleague and merely putting it in her mailbox and hoping she gets it soon. Since a SynchronousQueue has no storage capacity, put and take will block unless another thread is already waiting to participate in the handoff. Synchronous queues are generally suitable only when there are enough consumers that there nearly always will be one ready to take the handoff.

8, benefit of producer-consumer pattern
The producer-consumer pattern also enables several performance benefits. Producers and consumers can execute concurrently; if one is I/O-bound and the other is CPU-bound, executing them concurrently yields better overall throughput than executing them sequentially.

9, serial thread confinement
For mutable objects, producer-consumer designs and blocking queues facilitate serial thread confinement for handing off ownership of objects from producers to consumers. A thread-confined object is owned exclusively by a single thread, but that ownership can be "transferred" by publishing it safely where only one other thread will gain access to it and ensuring that the publishing thread does not access it after the handoff. The safe publication ensures that the object's state is visible to the new owner, and since the original owner will not touch it again, it is now confined to the new thread. The new owner may modify it freely since it has exclusive access.

Object pools exploit serial thread confinement, "lending" an object to a requesting thread. As long as the pool contains sufficient internal synchronization to publish the pooled object safely, and as long as the clients do not themselves publish the pooled object or use it after returning it to the pool, ownership can be transferred safely from thread to thread
One could also use other publication mechanisms for transferring ownership of a mutable object, but it is necessary to ensure that only one thread receives the object being handed off. Blocking queues make this easy; with a little more work, it could also done with the atomic remove method of ConcurrentMap or the compareAndSet method of AtomicReference.

10, Deques and Work Stealing

Just as blocking queues lend themselves to the producer-consumer pattern, deques lend themselves to a related pattern called work stealing. A producer consumer design has one shared work queue for all consumers; in a work stealing design, every consumer has its own deque. If a consumer exhausts the work in its own deque, it can steal work from the tail of someone else's deque. Work stealing can be more scalable than a traditional producer-consumer design because workers don't contend for a shared work queue; most of the time they access only their own deque, reducing contention. When a worker has to access another's queue, it does so from the tail rather than the head, further reducing contention.

Work stealing is well suited to problems in which consumers are also producers when performing a unit of work is likely to result in the identification of more work. For example, processing a page in a web crawler usually results in the identification of new pages to be crawled. Similarly, many graph-exploring algorithms, such as marking the heap during garbage collection, can be efficiently parallelized using work stealing. When a worker identifies a new unit of work, it places it at the end of its own deque (or alternatively, in a work sharing design, on that of another worker); when its deque is empty, it looks for work at the end of someone else's deque, ensuring that each worker stays busy

11, Blocking and Interruptible Methods
Threads may block, or pause, for several reasons: waiting for I/O completion, waiting to acquire a lock, waiting to wake up from Thread.sleep, or waiting for the result of a computation in another thread. When a thread blocks, it is usually suspended and placed in one of the blocked thread states (BLOCKED, WAITING, or TIMED_WAITING).

12,
Thread provides the interrupt method for interrupting a thread and for querying whether a thread has been interrupted. Each thread has a boolean property that represents its interrupted status; interrupting a thread sets this status.

13, Listing 5.10. Restoring the Interrupted Status so as Not to Swallow the Interrupt.
public class TaskRunnable implements Runnable {
    BlockingQueue<Task> queue;

    public void run() {
        try {
            processTask(queue.take());
        } catch (InterruptedException e) {
            // restore interrupted status
            Thread.currentThread().interrupt();
        }
    }
}

When your code calls a method that throws InterruptedException, then your method is a blocking method too, and must have a plan for responding to interruption. For library code, there are basically two choices:

a, Propagate the InterruptedException. This is often the most sensible policy if you can get away with it just propagate the InterruptedException to your caller. This could involve not catching InterruptedException, or catching it and throwing it again after performing some brief activity-specific cleanup.
b, Restore the interrupt. Sometimes you cannot throw InterruptedException, for instance when your code is part of a Runnable. In these situations, you must catch InterruptedException and restore the interrupted status by calling interrupt on the current thread, so that code higher up the call stack can see that an interrupt was issued, as demonstrated in Listing 5.10.

14, Synchronizers
A synchronizer is any object that coordinates the control flow of threads based on its state. Blocking queues can act as synchronizers; other types of synchronizers include semaphores, barriers, and latches.

15, Latches

A latch is a synchronizer that can delay the progress of threads until it reaches its terminal state [CPJ 3.4.2]. A latch acts as a gate: until the latch reaches the terminal state the gate is closed and no thread can pass, and in the terminal state the gate opens, allowing all threads to pass. Once the latch reaches the terminal state, it cannot change state again, so it remains open forever. Latches can be
used to ensure that certain activities do not proceed until other one-time activities complete

15.1 
Listing 5.11. Using CountDownLatch for Starting and Stopping Threads in Timing Tests
public class TestHarness {
    public long timeTasks(int nThreads, final Runnable task)
            throws InterruptedException {
        final CountDownLatch startGate = new CountDownLatch(1);
        final CountDownLatch endGate = new CountDownLatch(nThreads);
        for (int i = 0; i < nThreads; i++) {
            Thread t = new Thread() {
                public void run() {
                    try {
                        startGate.await();
                        try {
                            task.run();
                        } finally {
                            endGate.countDown();
                        }
                    } catch (InterruptedException ignored) {
                    }
                }
            };
            
            t.start();
        }
        long start = System.nanoTime();
        startGate.countDown();
        endGate.await();
        long end = System.nanoTime();
        return end - start;
    }
}

16, FutureTask

FutureTask also acts like a latch. (FutureTask implements Future, which describes an abstract result-bearing computation [CPJ 4.3.3].) A computation represented by a FutureTask is implemented with a Callable, the result-bearin
g equivalent of Runnable, and can be in one of three states: waiting to run, running, or completed.Completion subsumes all the ways a computation can complete, including normal
completion, cancellation, and exception.

class FutureTask<V> implements RunnableFuture<V>
interface RunnableFuture<V> extends Runnable, Future<V>

The behavior of Future.get depends on the state of the task. If it is completed, get returns the result immediately, and otherwise blocks until the task transitions to the completed state and then returns the result or throws an exception. FutureTask conveys the result from the thread executing the computation to the thread(s) retrieving the result; the specification of FutureTask guarantees that this transfer
constitutes a safe publication of the result.

1, Semaphores
Counting semaphores are used to control the number of activities that can access a certain resource or perform a given action at the same time [CPJ 3.4.1]. Counting semaphores can be used to implement resource pools or to impose a bound on a collection.

2, Mutex
A degenerate case of a counting semaphore is a binary semaphore, a Semaphore with an initial count of one. A binary semaphore can be used as a mutex with nonreentrant locking semantics; whoever holds the sole permit holds the mutex.

3, Barriers
We have seen how latches can facilitate starting a group of related activities or waiting for a group of related activities to complete. Latches are single-use objects; once a latch enters the terminal state, it cannot be reset.

Barriers are similar to latches in that they block a group of threads until some event has occurred [CPJ 4.4.3]. The key difference is that with a barrier, all the threads must come together at a barrier point at the same time in order to proceed. Latches are for waiting for events; barriers are for waiting for other threads. A barrier implements the protocol some families use to rendezvous during a day at the
mall: "Everyone meet at McDonald's at 6:00; once you get there, stay there until everyone shows up, and then we'll figure out what we're doing next."

CyclicBarrier allows a fixed number of parties to rendezvous repeatedly at a barrier point and is useful in parallel iterative algorithms that break down a problem into a fixed number of independent subproblems. Threads call await when they reach the barrier point, and await blocks until all the threads have reached the barrier point. If all threads meet at the barrier point, the barrier has been successfully passed, in which case all threads are released and the barrier is reset so it can be used again. If a call to await times out or a thread blocked in await is interrupted, then the barrier is considered broken and all outstanding calls to await terminate with BrokenBarrierException. If the barrier is successfully passed, await returns a unique arrival index for each thread, which can be used to "elect" a leader that takes some special action in the next iteration. CyclicBarrier also lets you pass a barrier action to the constructor; this is a Runnable that is executed (in one of the subtask threads) when the barrier is successfully passed but before the blocked threads are released.

4, CellularAutomata, case study
CellularAutomata in Listing 5.15 demonstrates using a barrier to compute a cellular automata simulation, such as Conway's Life game (Gardner, 1970). When parallelizing a simulation, it is generally impractical to assign a separate thread to each element (in the case of Life, a cell); this would require too many threads, and the overhead of coordinating them would dwarf the computation. Instead, it makes sense to partition the problem into a number of subparts, let each thread solve a subpart, and then merge the results. CellularAutomata partitions the board into Ncpu parts, where Ncpu is the number of CPUs available, and assigns each part to a thread.[5] 

[5] For computational problems like this that do no I/O and access no shared data, Ncpu or Ncpu + 1 threads yield optimal throughput; more threads do not help, and may in fact degrade performance as the threads compete for CPU and memory resources.

At each step, the worker threads calculate new values for all the cells in their part of the board. When all worker threads have reached the barrier, the barrier action commits the new values to the data model. After the barrier action runs, the worker threads are released to compute the next step of the calculation, which includes consulting an isDone method to determine whether further iterations are required.

5, Another form of barrier is Exchanger, a two-party barrier in which the parties exchange data at the barrier point [CPJ 3.4.3].

6, Case study, implement Cache
// Listing 5.16. Initial Cache Attempt Using HashMap and Synchronization. 
// Not good
public interface Computable<A, V> {
    V compute(A arg) throws InterruptedException;
}

public class ExpensiveFunction implements Computable<String, BigInteger> {
    public BigInteger compute(String arg) {
        // after deep thought...
        return new BigInteger(arg);
    }
}

public class Memoizer1<A, V> implements Computable<A, V> {
    @GuardedBy("this")
    private final Map<A, V> cache = new HashMap<A, V>();
    private final Computable<A, V> c;

    public Memoizer1(Computable<A, V> c) {
        this.c = c;
    }

    public synchronized V compute(A arg) throws InterruptedException {
        V result = cache.get(arg);
        if (result == null) {
            result = c.compute(arg);
            cache.put(arg, result);
        }
        return result;
    }
}

HashMap is not thread-safe, so to ensure that two threads do not access the HashMap at the same time, Memoizer1 takes the conservative approach of synchronizing the entire compute method. This ensures thread safety but has an obvious scalability problem: only one thread at a time can execute compute at all. If another thread is busy computing a result, other threads calling compute may be blocked for a long time. If multiple threads are queued up waiting to compute values not already computed, compute may actually take longer than it would have without memoization. This is not the sort of performance improvement we had hoped to achieve through caching.

// Listing 5.17. Replacing HashMap with ConcurrentHashMap.  
// Still not good
public class Memoizer2<A, V> implements Computable<A, V> {
    private final Map<A, V> cache = new ConcurrentHashMap<A, V>();
    private final Computable<A, V> c;

    public Memoizer2(Computable<A, V> c) {
        this.c = c;
    }

    public V compute(A arg) throws InterruptedException {
        V result = cache.get(arg);
        if (result == null) {
            result = c.compute(arg);
            cache.put(arg, result);
        }
        return result;
    }
}

Memoizer2 in Listing 5.17 improves on the awful concurrent behavior of Memoizer1 by replacing the HashMap with a ConcurrentHashMap. Since ConcurrentHashMap is thread-safe, there is no need to synchronize when accessing the backing Map, thus eliminating the serialization induced by synchronizing compute in Memoizer1.
Memoizer2 certainly has better concurrent behavior than Memoizer1: multiple threads can actually use it concurrently. But it still has some defects as a cache there is a window of vulnerability in which two threads calling compute at the same time could end up computing the same value. In the case of memoization, this is merely inefficient. the purpose of a cache is to prevent the same data from being calculated multiple times. For a more general-purpose caching mechanism, it is far worse; for an object cache that is supposed to provide once-and-only-once initialization, this vulnerability would also pose a safety risk.
The problem with Memoizer2 is that if one thread starts an expensive computation, other threads are not aware that the computation is in progress and so may start the same computation, as illustrated in Figure 5.3. We'd like to somehow represent the notion that "thread X is currently computing f (27)", so that if another thread arrives looking for f (27), it knows that the most efficient way to find it is to head over to Thread X's house, hang out there until X is finished, and then ask "Hey, what did you get for f (27)?"

// Listing 5.18. Memoizing Wrapper Using FutureTask.
// Still not good enough
public class Memoizer3<A, V> implements Computable<A, V> {
    private final Map<A, Future<V>> cache = new ConcurrentHashMap<A, Future<V>>();
    private final Computable<A, V> c;

    public Memoizer3(Computable<A, V> c) {
        this.c = c;
    }

    public V compute(final A arg) throws InterruptedException {
        Future<V> f = cache.get(arg);
        if (f == null) {
            Callable<V> eval = new Callable<V>() {
                public V call() throws InterruptedException {
                    return c.compute(arg);
                }
            };
            FutureTask<V> ft = new FutureTask<V>(eval);
            f = ft;
            cache.put(arg, ft);
            ft.run(); // call to c.compute happens here
        }
        try {
            return f.get();
        } catch (ExecutionException e) {
            throw launderThrowable(e.getCause());
        }
    }
}

Memoizer3 in Listing 5.18 redefines the backing Map for the value cache as a ConcurrentHashMap<A,Future<V>> instead of a
ConcurrentHashMap<A,V>. Memoizer3 first checks to see if the appropriate calculation has been started (as opposed to finished, as in Memoizer2). If not, it creates a FutureTask, registers it in the Map, and starts the computation; otherwise it waits for the result of the existing computation. The result might be available immediately or might be in the process of being computed but this is transparent to the caller of Future.get.
The Memoizer3 implementation is almost perfect: it exhibits very good concurrency (mostly derived from the excellent concurrency of ConcurrentHashMap), the result is returned efficiently if it is already known, and if the computation is in progress by another thread, newly arriving threads wait patiently for the result. 
It has only one defect there is still a small window of vulnerability in which two threads might compute the same value. This window is far smaller than in Memoizer2, but because the if block in compute is still a nonatomic check-then-act sequence, it is possible for two threads to call compute with the same value at roughly the same time, both see that the cache does not contain the desired value, and both start the computation. 

Memoizer3 is vulnerable to this problem because a compound action (put-if-absent) is performed on the backing map that cannot be made atomic using locking. Memoizer in Listing 5.19 takes advantage of the atomic putIfAbsent method of ConcurrentMap, closing the window of vulnerability in Memoizer3.

// Listing 5.19. Final Implementation of Memoizer.
public class Memoizer<A, V> implements Computable<A, V> {
    private final ConcurrentMap<A, Future<V>> cache = new ConcurrentHashMap<A, Future<V>>();
    private final Computable<A, V> c;

    public Memoizer(Computable<A, V> c) {
        this.c = c;
    }

    public V compute(final A arg) throws InterruptedException {
        while (true) {
            Future<V> f = cache.get(arg);
            if (f == null) {
                Callable<V> eval = new Callable<V>() {
                    public V call() throws InterruptedException {
                        return c.compute(arg);
                    }
                };
                FutureTask<V> ft = new FutureTask<V>(eval);
                f = cache.putIfAbsent(arg, ft);
                if (f == null) {
                    f = ft;
                    ft.run();
                }
            }
            try {
                return f.get();
            } catch (CancellationException e) {
                cache.remove(arg, f);
            } catch (ExecutionException e) {
                throw launderThrowable(e.getCause());
            }
        }
    }
}

Caching a Future instead of a value creates the possibility of cache pollution: if a computation is cancelled or fails, future attempts to compute the result will also indicate cancellation or failure. To avoid this, Memoizer removes the Future from the cache if it detects that the computation was cancelled; it might also be desirable to remove the Future upon detecting a RuntimeException if the computation might succeed on a future attempt. Memoizer also does not address cache expiration, but this could be accomplished by using a subclass of FutureTask that associates an expiration time with each result and periodically scanning the cache for expired entries. (Similarly, it does not address cache eviction, where old entries are removed to make room for new ones so that the cache does not consume too much
memory.)
With our concurrent cache implementation complete, we can now add real caching to the factorizing servlet from Chapter 2, as promised. Factorizer in Listing 5.20 uses Memoizer to cache previously computed values efficiently and scalably.

7, Executing Tasks in Threads

The first step in organizing a program around task execution is identifying sensible task boundaries.

Server applications should exhibit both good throughput and good responsiveness under normal load.Further, applications should exhibit graceful degradation as they become overloaded, rather than simply falling over under heavy load. Choosing good task boundaries, coupled with a sensible task execution policy (see Section 6.2.2), can help achieve these goals
8, In some situations, sequential processing may offer a simplicity or safety advantage; most GUI frameworks process tasks sequentially using a single thread. 

9, Case study, Web server with different task execution policy
// Listing 6.2. Web Server that Starts a New Thread for Each Request.
// Not good
class ThreadPerTaskWebServer {
    public static void main(String[] args) throws IOException {
        ServerSocket socket = new ServerSocket(80);
        while (true) {
            final Socket connection = socket.accept();
            Runnable task = new Runnable() {
                public void run() {
                    handleRequest(connection);
                }
            };
            new Thread(task).start();
        }
    }
}
Under light to moderate load, the thread-per-task approach is an improvement over sequential execution. As long as the request arrival rate does not exceed the server's capacity to handle requests, this approach offers better responsiveness and throughput.

// Listing 6.4. Web Server Using a Thread Pool.
class TaskExecutionWebServer {
    private static final int NTHREADS = 100;
    private static final Executor exec = Executors.newFixedThreadPool(NTHREADS);

    public static void main(String[] args) throws IOException {
        ServerSocket socket = new ServerSocket(80);
        while (true) {
            final Socket connection = socket.accept();
            Runnable task = new Runnable() {
                public void run() {
                    handleRequest(connection);
                }
            };
            exec.execute(task);
        }
    }
}


9.1 Disadvantages of Unbounded Thread Creation
a, Thread lifecycle overhead. Thread creation and teardown are not free. The actual overhead varies across platforms, but thread creation takes time, introducing latency into request processing, and requires some processing activity by the JVM and OS. If requests are frequent and lightweight, as in most server applications, creating a new thread for each  request can consume significant computing resources.

b, Resource consumption. Active threads consume system resources, especially memory. When there are more runnable threads than available processors, threads sit idle. Having many idle threads can tie up a lot of memory, putting pressure on the garbage collector,and having many threads competing for the CPUs can impose other performance costs as well. If you have enough threads to keep all the CPUs busy, creating more threads won't help and may even hurt.

c, Stability. There is a limit on how many threads can be created. The limit varies by platform and is affected by factors including JVM invocation parameters, the requested stack size in the Thread constructor, and limits on threads placed by the underlying operating system.[2]
When you hit this limit, the most likely result is an OutOfMemoryError. trying to recover from such an error is very risky; it is far easier to structure your program to avoid hitting this limit.

[2] On 32-bit machines, a major limiting factor is address space for thread stacks. Each thread maintains two execution stacks, one for Java code and one for native code. Typical JVM defaults yield a combined stack size of around half a megabyte. (You can change this with the -Xss JVM flag or through the Thread constructor.) If you divide the per-thread stack size into 232, you get a limit of a few thousands or tens of thousands of threads. Other factors, such as OS limitations, may impose stricter limits.

10, The primary abstraction for task execution in the Java class libraries is not Thread, but Executor.

Executor may be a simple interface, but it forms the basis for a flexible and powerful framework for asynchronous task execution that supports a wide variety of task execution policies. It provides a standard means of decoupling task submission from task execution,describing tasks with Runnable. The Executor implementations also provide lifecycle support and hooks for adding statistics gathering,application management, and monitoring.

Executor is based on the producer-consumer pattern, where activities that submit tasks are the producers (producing units of work to be done) and the threads that execute tasks are the consumers (consuming those units of work). Using an Executor is usually the easiest path to implementing a producer-consumer design in your application.

11, Thread Pools

The class library provides a flexible thread pool implementation along with some useful predefined configurations. You can create a thread pool by calling one of the static factory methods in Executors:

newFixedThreadPool. A fixed-size thread pool creates threads as tasks are submitted, up to the maximum pool size, and then attempts to keep the pool size constant (adding new threads if a thread dies due to an unexpected Exception).

newCachedThreadPool. A cached thread pool has more flexibility to reap idle threads when the current size of the pool exceeds the demand for processing, and to add new threads when demand increases, but places no bounds on the size of the pool.

newSingleThreadExecutor. A single-threaded executor creates a single worker thread to process tasks, replacing it if it dies unexpectedly. Tasks are guaranteed to be processed sequentially according to the order imposed by the task queue (FIFO, LIFO, priority order).[4]
[4] Single-threaded executors also provide sufficient internal synchronization to guarantee that any memory writes made by tasks are visible to subsequent tasks; this means that objects can be safely confined to the "task thread" even though that thread may be replaced with another from time to time.

newScheduledThreadPool. A fixed-size thread pool that supports delayed and periodic task execution, similar to Timer. (See Section 6.2.5.)

class ScheduledThreadPoolExecutor extends ThreadPoolExecutor implements ScheduledExecutorService
interface ScheduledExecutorService extends ExecutorService 

12, But the JVM can't exit until all the (nondaemon) threads have terminated, so failing to shut down an Executor could prevent the JVM from exiting.

1, ExecutorService, shut down methods 

The lifecycle implied by ExecutorService has three states running, shutting down, and terminated.

The shutdown method initiates a graceful shutdown: no new tasks are accepted but previously submitted tasks are allowed to complete including those that have not yet begun execution. 

The shutdownNow method initiates an abrupt shutdown: it attempts to cancel outstanding tasks and does not start any tasks that are queued but not begun.

Tasks submitted to an ExecutorService after it has been shut down are handled by the rejected execution handler (see Section 8.3.3), which might silently discard the task or might cause execute to throw the unchecked RejectedExecutionException. Once all tasks have completed, the ExecutorService Transitions to the terminated state. You can wait for an ExecutorService to reach the terminated state with awaitTermination, or poll for whether it has yet terminated with isTerminated. It is common to follow shutdown immediately by awaitTermination, creating the effect of synchronously shutting down the ExecutorService.

2, Delayed and Periodic Tasks: Timer vs ScheduledThreadPoolExecutor vs DelayQueue

The Timer facility manages the execution of deferred ("run this task in 100 ms") and periodic ("run this task every 10 ms") tasks. However, Timer has some drawbacks, and ScheduledThreadPoolExecutor should be thought of as its replacement.[6]
[6] Timer does have support for scheduling based on absolute, not relative time, so that tasks can be sensitive to changes in the system clock; ScheduledThreadPoolExecutor supports only relative time.

A Timer creates only a single thread for executing timer tasks. If a timer task takes too long to run, the timing accuracy of other
TimerTasks can suffer. If a recurring TimerTask is scheduled to run every 10 ms and another Timer-Task takes 40 ms to run, the recurring task either (depending on whether it was scheduled at fixed rate or fixed delay) gets called four times in rapid succession after the long-running task completes, or "misses" four invocations completely. Scheduled thread pools address this limitation by letting you provide multiple threads for executing deferred and periodic tasks.

Another problem with Timer is that it behaves poorly if a TimerTask throws an unchecked exception. The Timer thread doesn't catch the exception, so an unchecked exception thrown from a TimerTask terminates the timer thread. Timer also doesn't resurrect the thread in this situation; instead, it erroneously assumes the entire Timer was cancelled. In this case, TimerTasks that are already scheduled but not yet executed are never run, and new tasks cannot be scheduled. (This problem, called "thread leakage" is described in Section 7.3, along with techniques for avoiding it.)

ScheduledThreadPoolExecutor deals properly with ill-behaved tasks; there is little reason to use Timer in Java 5.0 or later.

If you need to build your own scheduling service, you may still be able to take advantage of the library by using a DelayQueue, a
BlockingQueue implementation that provides the scheduling functionality of ScheduledThreadPoolExecutor. A DelayQueue manages a collection of Delayed objects. A Delayed has a delay time associated with it: DelayQueue lets you take an element only if its delay has expired. Objects are returned from a DelayQueue ordered by the time associated with their delay.

3, There may also be exploitable parallelism within a single client request in server applications, as is sometimes the case in database servers.

4, Runnable vs Callable

The Executor framework uses Runnable as its basic task representation. Runnable is a fairly limiting abstraction; run cannot return a value or throw checked exceptions, although it can have side effects such as writing to a log file or placing a result in a shared data structure.
Many tasks are effectively deferred computations executing a database query, fetching a resource over the network, or computing a
complicated function. For these types of tasks, Callable is a better abstraction: it expects that the main entry point, call, will return a value and anticipates that it might throw an exception.[7]
Executors includes several utility methods for wrapping other types of tasks, including Runnable and java.security.PrivilegedAction, with a Callable.
[7] To express a non-value-returning task with Callable, use Callable<Void>.

5, cancel tasks
In the Executor framework, tasks that have been submitted but not yet started can always be cancelled, and tasks that have started can sometimes be cancelled if they are responsive to interruption. Cancelling a task that has already completed has no effect.

6, Future.get
The behavior of get varies depending on the task state (not yet started, running, completed). It returns immediately or throws an
Exception if the task has already completed, but if not it blocks until the task completes. If the task completes by throwing an exception, get rethrows it wrapped in an ExecutionException; if it was cancelled, get throws CancellationException. If get throws
ExecutionException, the underlying exception can be retrieved with getCause.

7, There are several ways to create a Future to describe a task. The submit methods in ExecutorService all return a Future, so that you can submit a Runnable or a Callable to an executor and get back a Future that can be used to retrieve the result or cancel the task. You can also explicitly instantiate a FutureTask for a given Runnable or Callable.

8, Limitations of Parallelizing Heterogeneous Tasks
Two people can divide the work of cleaning the dinner dishes fairly effectively: one person washes while the other dries. However,
assigning a different type of task to each worker does not scale well; if several more people show up, it is not obvious how they can help without getting in the way or significantly restructuring the division of labor. Without finding finer-grained parallelism among similar tasks, this approach will yield diminishing returns.

A further problem with dividing heterogeneous tasks among multiple workers is that the tasks may have disparate sizes. If you divide tasks A and B between two workers but A takes ten times as long as B, you've only speeded up the total process by 9%. Finally, dividing a task among multiple workers always involves some amount of coordination overhead; for the division to be worthwhile, this overhead must be more than compensated by productivity improvements due to parallelism.

9, CompletionService: Executor Meets BlockingQueue
If you have a batch of computations to submit to an Executor and you want to retrieve their results as they become available, you could retain the Future associated with each task and repeatedly poll for completion by calling get with a timeout of zero. This is possible, but tedious. Fortunately there is a better way: a completion service.

CompletionService combines the functionality of an Executor and a BlockingQueue. You can submit Callable tasks to it for execution and use the queuelike methods take and poll to retrieve completed results, packaged as Futures, as they become available. ExecutorCompletionService implements CompletionService, delegating the computation to an Executor.

The implementation of ExecutorCompletionService is quite straightforward. The constructor creates a BlockingQueue to hold the completed results. Future-Task has a done method that is called when the computation completes. When a task is submitted, it is wrapped with a QueueingFuture, a subclass of FutureTask that overrides done to place the result on the BlockingQueue, as shown in Listing 6.14. The take and poll methods delegate to the BlockingQueue, blocking if results are not yet available.

Multiple ExecutorCompletionServices can share a single Executor, so it is perfectly sensible to create an
ExecutorCompletionService that is private to a particular computation while sharing a common Executor. When used in this way, a CompletionService acts as a handle for a batch of computations in much the same way that Future acts as a handle for a single computation. By remembering how many tasks were submitted to the CompletionService and counting how many completed results are retrieved, you can know when all the results for a given batch have been retrieved, even if you use a shared Executor.

10, invokeAll

uses the timed version of invokeAll to submit multiple tasks to an ExecutorService and retrieve the results. The invokeAll method takes a collection of tasks and returns a collection of Futures. The two collections have identical structures; invokeAll adds the Futures to the returned collection in the order imposed by the task collection's iterator, thus allowing the caller to associate a Future with the Callable it represents. The timed version of invokeAll will return when all the tasks have completed, the calling thread is interrupted, or the timeout expires. Any tasks that are not complete when the timeout expires are cancelled. On return from invokeAll, each task will have either completed normally or been cancelled; the client code can call get or isCancelled to find out which.


// Listing 6.17. Requesting Travel Quotes Under a Time Budget. invokeAll method
private class QuoteTask implements Callable<TravelQuote> {
    private final TravelCompany company;
    private final TravelInfo travelInfo;

    public TravelQuote call() throws Exception {
        return company.solicitQuote(travelInfo);
    }
}

public List<TravelQuote> getRankedTravelQuotes(TravelInfo travelInfo,
        Set<TravelCompany> companies, Comparator<TravelQuote> ranking,
        long time, TimeUnit unit) throws InterruptedException {
    List<QuoteTask> tasks = new ArrayList<QuoteTask>();
    for (TravelCompany company : companies)
        tasks.add(new QuoteTask(company, travelInfo));
    List<Future<TravelQuote>> futures = exec.invokeAll(tasks, time, unit);
    List<TravelQuote> quotes = new ArrayList<TravelQuote>(tasks.size());
    Iterator<QuoteTask> taskIter = tasks.iterator();
    for (Future<TravelQuote> f : futures) {
        QuoteTask task = taskIter.next();
        try {
            quotes.add(f.get());
        } catch (ExecutionException e) {
            quotes.add(task.getFailureQuote(e.getCause()));
        } catch (CancellationException e) {
            quotes.add(task.getTimeoutQuote(e));
        }
    }
    Collections.sort(quotes, ranking);
    return quotes;
}

11, Getting tasks and threads to stop safely, quickly, and reliably is not always easy. Java does not provide any mechanism for safely forcing a thread to stop what it is doing.[1]
Instead, it provides interruption, a cooperative mechanism that lets one thread ask another to stop what it is doing.
[1] The deprecated Thread.stop and suspend methods were an attempt to provide such a mechanism, but were quickly realized to be seriously flawed and should be avoided. See 
http://java.sun.com/j2se/1.5.0/docs/guide/misc/threadPrimitiveDeprecation.html
for an explanation of the problems with these methods.

12, Why Are Thread.stop, Thread.suspend, Thread.resume and Runtime.runFinalizersOnExit Deprecated?
http://java.sun.com/j2se/1.5.0/docs/guide/misc/threadPrimitiveDeprecation.html

//Listing 7.1. Using a Volatile Field to Hold Cancellation State.
@ThreadSafe
public class PrimeGenerator implements Runnable {
    @GuardedBy("this")
    private final List<BigInteger> primes = new ArrayList<BigInteger>();
    private volatile boolean cancelled;

    public void run() {
        BigInteger p = BigInteger.ONE;
        while (!cancelled) {
            p = p.nextProbablePrime();
            synchronized (this) {
                primes.add(p);
            }
        }
    }

    public void cancel() {
        cancelled = true;
    }

    public synchronized List<BigInteger> get() {
        return new ArrayList<BigInteger>(primes);
    }
}

The cancellation mechanism in PrimeGenerator will eventually cause the prime seeking task to exit, but it might take a while. If, however,
a task that uses this approach calls a blocking method such as BlockingQueue.put, we could have a more serious problem the task might
never check the cancellation flag and therefore might never terminate.
BrokenPrimeProducer in Listing 7.3 illustrates this problem.

Listing 7.3. Unreliable Cancellation that can Leave Producers Stuck in a Blocking Operation. Don't Do this.
class BrokenPrimeProducer extends Thread {
    private final BlockingQueue<BigInteger> queue;
    private volatile boolean cancelled = false;

    BrokenPrimeProducer(BlockingQueue<BigInteger> queue) {
        this.queue = queue;
    }

    public void run() {
        try {
            BigInteger p = BigInteger.ONE;
            while (!cancelled)
                queue.put(p = p.nextProbablePrime());
        } catch (InterruptedException consumed) {
        }
    }

    public void cancel() {
        cancelled = true;
    }

}

class ClientCode1 {
    void consumePrimes() throws InterruptedException {
        BlockingQueue<BigInteger> primes = null; // ...;
        BrokenPrimeProducer producer = new BrokenPrimeProducer(primes);
        producer.start();
        try {
            while (needMorePrimes())
                consume(primes.take());
        } finally {
            producer.cancel();
        }
    }
    
    @PhantomCode
    private boolean needMorePrimes(){
        return false;
    }
    @PhantomCode
    private void consume(BigInteger i){
        
    }
}

There is nothing in the API or language specification that ties interruption to any specific cancellation semantics, but in
practice, using interruption for anything but cancellation is fragile and difficult to sustain in larger applications.

Each thread has a boolean interrupted status; interrupting a thread sets its interrupted status to true. Thread contains methods for
interrupting a thread and querying the interrupted status of a thread, as shown in Listing 7.4. The interrupt method interrupts the target
thread, and isInterrupted returns the interrupted status of the target thread. The poorly named static interrupted method clears the
interrupted status of the current thread and returns its previous value; this is the only way to clear the interrupted status.

public class Thread {
    public void interrupt() { ... }
    public boolean isInterrupted() { ... }
    public static boolean interrupted() { ... }
    ...
}

A good way to think about interruption is that it does not actually interrupt a running thread; it just requests that the thread interrupt itself
at the next convenient opportunity. (These opportunities are called cancellation points.) Some methods, such as wait, sleep, and join, take
such requests seriously, throwing an exception when they receive an interrupt request or encounter an already set interrupt status upon
entry.

The static interrupted method should be used with caution, because it clears the current thread's interrupted status. If you call interrupted
and it returns TRue, unless you are planning to swallow the interruption, you should do something with it either throw InterruptedException
or restore the interrupted status by calling interrupt again, as in Listing 5.10 on page 94. Thread.currentThread().interrupt();

Interruption is usually the most sensible way to implement cancellation.

BrokenPrimeProducer can be easily fixed (and simplified) by using interruption instead of a boolean flag to request cancellation, as
shown in Listing 7.5. There are two points in each loop iteration where interruption may be detected: in the blocking put call, and by
explicitly polling the interrupted status in the loop header. The explicit test is not strictly necessary here because of the blocking put call,
but it makes PrimeProducer more responsive to interruption because it checks for interruption before starting the lengthy task of
searching for a prime, rather than after. When calls to interruptible blocking methods are not frequent enough to deliver the desired
responsiveness, explicitly testing the interrupted status can help.

Listing 7.5. Using Interruption for Cancellation.
class PrimeProducer extends Thread {
    private final BlockingQueue<BigInteger> queue;
    PrimeProducer(BlockingQueue<BigInteger> queue) {
        this.queue = queue;
    }
    public void run() {
        try {
        BigInteger p = BigInteger.ONE;
        while (!Thread.currentThread().isInterrupted())
            queue.put(p = p.nextProbablePrime());
        } catch (InterruptedException consumed) {
            /* Allow thread to exit */
        }
    }
    public void cancel() { interrupt(); }
}

Just as tasks should have a cancellation policy, threads should have an interruption policy. An interruption policy determines how a thread interprets an interruption request, what it does (if anything) when one is detected, what units of work are considered atomic with respect to interruption, and how quickly it reacts to interruption.

Tasks do not execute in threads they own; they borrow threads owned by a service such as a thread pool. Code that doesn't own the
thread (for a thread pool, any code outside of the thread pool implementation) should be careful to preserve the interrupted status so that
the owning code can eventually act on it, even if the "guest" code acts on the interruption as well. (If you are house-sitting for someone,
you don't throw out the mail that comes while they're away you save it and let them deal with it when they get back, even if you do read
their magazines.)

The most sensible interruption policy is some form of thread-level or service-level cancellation: exit as quickly as practical, cleaning up if necessary, and possibly notifying some owning entity that the thread is exiting. It is possible to establish other interruption policies, such as pausing or resuming a service, but threads or thread pools with nonstandard interruption policies may need to be restricted to tasks that have been written with an awareness of the policy.

This is why most blocking library methods simply throw InterruptedException in response to an interrupt. They will never
execute in a thread they own, so they implement the most reasonable cancellation policy for task or library code: get out of the way as
quickly as possible and communicate the interruption back to the caller so that code higher up on the call stack can take further action.

A task should not assume anything about the interruption policy of its executing thread unless it is explicitly designed to run within a
service that has a specific interruption policy. Whether a task interprets interruption as cancellation or takes some other action on
interruption, it should take care to preserve the executing thread's interruption status. If it is not simply going to propagate
InterruptedException to its caller, it should restore the interruption status after catching InterruptedException:
Thread.currentThread().interrupt();

Because each thread has its own interruption policy, you should not interrupt a thread unless you know what
interruption means to that thread.

when you call an interruptible blocking method such as Thread.sleep or BlockingQueue.put, there are two practical strategies for handling InterruptedException:
Propagate the exception (possibly after some task-specific cleanup), making your method an interruptible blocking method,
too; or
Restore the interruption status so that code higher up on the call stack can deal with it.

Only code that implements a thread's interruption policy may swallow an interruption request. General-purpose task
and library code should never swallow interruption requests.

Activities that do not support cancellation but still call interruptible blocking methods will have to call them in a loop, retrying when
interruption is detected. In this case, they should save the interruption status locally and restore it just before returning, as shown in
Listing 7.7, rather than immediately upon catching InterruptedException. Setting the interrupted status too early could result in an infinite
loop, because most interruptible blocking methods check the interrupted status on entry and throw InterruptedException immediately if it
is set. (Interruptible methods usually poll for interruption before blocking or doing any significant work, so as to be as responsive to
interruption as possible.)

The aSecondOfPrimes method in Listing 7.2 starts a PrimeGenerator and interrupts it after a second. While the PrimeGenerator might
take somewhat longer than a second to stop, it will eventually notice the interrupt and stop, allowing the thread to terminate. But another
aspect of executing a task is that you want to find out if the task throws an exception. If PrimeGenerator throws an unchecked exception
before the timeout expires, it will probably go unnoticed, since the prime generator runs in a separate thread that does not explicitly
handle exceptions

Listing 7.1. Using a Volatile Field to Hold Cancellation State.
@ThreadSafe
class PrimeGenerator implements Runnable {
    @GuardedBy("this")
    private final List<BigInteger> primes = new ArrayList<BigInteger>();
    private volatile boolean cancelled;

    public void run() {
        BigInteger p = BigInteger.ONE;
        while (!cancelled) {
            p = p.nextProbablePrime();
            synchronized (this) {
                primes.add(p);
            }
        }
    }

    public void cancel() {
        cancelled = true;
    }

    public synchronized List<BigInteger> get() {
        return new ArrayList<BigInteger>(primes);
    }
}

Listing 7.2. Generating a Second's Worth of Prime Numbers.
List<BigInteger> aSecondOfPrimes() throws InterruptedException {
    PrimeGenerator generator = new PrimeGenerator();
    new Thread(generator).start();
    try {
        SECONDS.sleep(1);
    } finally {
        generator.cancel();
    }
    return generator.get();
}

Listing 7.8 This is an appealingly simple approach, but it violates the rules: you should know a thread's interruption policy before interrupting it.
Since timedRun can be called from an arbitrary thread, it cannot know the calling thread's interruption policy. If the task completes
before the timeout, the cancellation task that interrupts the thread in which timedRun was called could go off after timedRun has returned
to its caller. We don't know what code will be running when that happens, but the result won't be good. (It is possible but surprisingly
tricky to eliminate this risk by using the ScheduledFuture returned by schedule to cancel the cancellation task.)

Further, if the task is not responsive to interruption, timedRun will not return until the task finishes, which may be long after the desired
timeout (or even not at all). A timed run service that doesn't return after the specified time is likely to be irritating to its callers.

Listing 7.8. Scheduling an Interrupt on a Borrowed Thread. Don't Do this.
private static final ScheduledExecutorService cancelExec = null;// ...;

public static void timedRun(Runnable r, long timeout, TimeUnit unit) {
    final Thread taskThread = Thread.currentThread();
    cancelExec.schedule(new Runnable() {
        public void run() {
            taskThread.interrupt();
        }
    }, timeout, unit);
    r.run();
}

Listing 7.9 addresses the exception-handling problem of aSecondOfPrimes and the problems with the previous attempt. The thread
created to run the task can have its own execution policy, and even if the task doesn't respond to the interrupt, the timed run method can
still return to its caller. After starting the task thread, timedRun executes a timed join with the newly created thread. After join returns, it
checks if an exception was thrown from the task and if so, rethrows it in the thread calling timedRun. The saved Throwable is shared
between the two threads, and so is declared volatile to safely publish it from the task thread to the timedRun thread.

it shares a deficiency with join: we don't know if control was returned because the thread exited normally or because the join timed out.[2]
[2] This is a flaw in the Thread API, because whether or not the join completes successfully has memory visibility consequences in the Java Memory Model, 
but join does not return a status indicating whether it was successful.

Listing 7.9. Interrupting a Task in a Dedicated Thread.
private static final ScheduledExecutorService cancelExec = null; //...;
public static void timedRun(final Runnable r, long timeout, TimeUnit unit) throws InterruptedException {
    class RethrowableTask implements Runnable {
        private volatile Throwable t;

        public void run() {
            try {
                r.run();
            } catch (Throwable t) {
                this.t = t;
            }
        }

        void rethrow() {
            if (t != null)
                throw launderThrowable(t);
        }
        @PhantomCode
        RuntimeException launderThrowable(Throwable t){
            return null;
        }
    }
    RethrowableTask task = new RethrowableTask();
    final Thread taskThread = new Thread(task);
    taskThread.start();
    cancelExec.schedule(new Runnable() {
        public void run() {
            taskThread.interrupt();
        }
    }, timeout, unit);
    taskThread.join(unit.toMillis(timeout));
    task.rethrow();
}

ExecutorService.submit returns a Future describing the task. Future has a cancel method that takes a boolean argument,
mayInterruptIfRunning, and returns a value indicating whether the cancellation attempt was successful. (This tells you only whether it was
able to deliver the interruption, not whether the task detected and acted on it.) When mayInterruptIfRunning is true and the task is
currently running in some thread, then that thread is interrupted. Setting this argument to false means "don't run this task if it hasn't
started yet", and should be used for tasks that are not designed to handle interruption.

Since you shouldn't interrupt a thread unless you know its interruption policy, when is it OK to call cancel with an argument of TRue? The
task execution threads created by the standard Executor implementations implement an interruption policy that lets tasks be cancelled
using interruption, so it is safe to set mayInterruptIfRunning when cancelling tasks through their Futures when they are running in a
standard Executor. You should not interrupt a pool thread directly when attempting to cancel a task, because you won't know what task is
running when the interrupt request is delivered do this only through the task's Future. This is yet another reason to code tasks to treat
interruption as a cancellation request: then they can be cancelled through their Futures.

Listing 7.10 shows a version of timedRun that submits the task to an ExecutorService and retrieves the result with a timed Future.get.
If get terminates with a TimeoutException, the task is cancelled via its Future. (To simplify coding, this version calls Future.cancel
unconditionally in a finally block, taking advantage of the fact that cancelling a completed task has no effect.) If the underlying
computation throws an exception prior to cancellation, it is rethrown from timedRun, which is the most convenient way for the caller to
deal with the exception. Listing 7.10 also illustrates another good practice: cancelling tasks whose result is no longer needed.

Listing 7.10. Cancelling a Task Using Future.
public static void timedRun(Runnable r, long timeout, TimeUnit unit)
        throws InterruptedException {
    Future<?> task = taskExec.submit(r);
    try {
        task.get(timeout, unit);
    } catch (TimeoutException e) {
        // task will be cancelled below
    } catch (ExecutionException e) {
        // exception thrown in task; rethrow
        throw launderThrowable(e.getCause());
    } finally {
        // Harmless if task already completed
        task.cancel(true); // interrupt if running
    }
}

However, not all blocking methods or blocking mechanisms are responsive to interruption;
if a thread is blocked performing synchronous socket I/O or waiting to acquire an intrinsic lock, interruption has no effect other than
setting the thread's interrupted status. We can sometimes convince threads blocked in noninterruptible activities to stop by means similar
to interruption, but this requires greater awareness of why the thread is blocked.

1, Synchronous socket I/O in java.io. The common form of blocking I/O in server applications is reading or writing to a
socket. Unfortunately, the read and write methods in InputStream and OutputStream are not responsive to interruption, but closing the
underlying socket makes any threads blocked in read or write throw a SocketException.
2, Synchronous I/O in java.nio. Interrupting a thread waiting on an InterruptibleChannel causes it to throw ClosedByInterruptException and
close the channel (and also causes all other threads blocked on the channel to throw ClosedByInterruptException). Closing an
InterruptibleChannel causes threads blocked on channel operations to throw AsynchronousCloseException. Most standard Channels
implement InterruptibleChannel.
3, Asynchronous I/O with Selector. If a thread is blocked in Selector.select (in java.nio.channels), wakeup causes it to return prematurely
by throwing a ClosedSelectorException.
4, Lock acquisition. If a thread is blocked waiting for an intrinsic lock, there is nothing you can do to stop it short of ensuring that it
eventually acquires the lock and makes enough progress that you can get its attention some other way. However, the explicit Lock
classes offer the lockInterruptibly method, which allows you to wait for a lock and still be responsive to interrupts see Chapter 13.

The technique used in ReaderThread to encapsulate nonstandard cancellation can be refined using the newTaskFor hook added to
ThreadPoolExecutor in Java 6. When a Callable is submitted to an ExecutorService, submit returns a Future that can be used to cancel
the task. The newTaskFor hook is a factory method that creates the Future representing the task. It returns a RunnableFuture, an interface
that extends both Future and Runnable (and is implemented by FutureTask).

Customizing the task Future allows you to override Future.cancel. Custom cancellation code can perform logging or gather statistics on
cancellation, and can also be used to cancel activities that are not responsive to interruption. ReaderThread encapsulates cancellation of
socket-using threads by overriding interrupt; the same can be done for tasks by overriding Future.cancel.

SocketUsingTask implements CancellableTask and defines Future.cancel to close the socket as well as call super.cancel. If a
SocketUsingTask is cancelled through its Future, the socket is closed and the executing thread is interrupted. This increases the task's
responsiveness to cancellation: not only can it safely call interruptible blocking methods while remaining responsive to cancellation, but it
can also call blocking socket I/O methods.

Provide lifecycle methods whenever a thread-owning service has a lifetime longer than that of the method that created it.

Stream classes like PrintWriter are thread-safe, so this simple approach would require no explicit synchronization.[3]

[3] If you are logging multiple lines as part of a single log message, you may need to use additional client-side
locking to prevent undesirable interleaving of output from multiple threads. If two threads logged multiline stack
traces to the same stream with one println call per line, the results would be interleaved unpredictably, and could
easily look like one large but meaningless stack trace.

Listing 7.12. Encapsulating Nonstandard Cancellation in a Task with Newtaskfor.  

interface CancellableTask<T> extends Callable<T> {
    void cancel();

    RunnableFuture<T> newTask();
}

@ThreadSafe
public class CancellingExecutor extends ThreadPoolExecutor {
    // ...
    protected <T> RunnableFuture<T> newTaskFor(Callable<T> callable) {
        if (callable instanceof CancellableTask)
            return ((CancellableTask<T>) callable).newTask();
        else
            return super.newTaskFor(callable);
    }
    @PhantomCode
    public CancellingExecutor(){
        super(0, 0, 0, TimeUnit.HOURS, null);
    }
}

abstract class SocketUsingTask<T> implements CancellableTask<T> {
    @GuardedBy("this")
    private Socket socket;
 
    protected synchronized void setSocket(Socket s) {
        socket = s;
    }

    public synchronized void cancel() {
        try {
            if (socket != null)
                socket.close();
        } catch (IOException ignored) {
        }
    }

    public RunnableFuture<T> newTask() {
        return new FutureTask<T>(this) {
            public boolean cancel(boolean mayInterruptIfRunning) {
                try {
                    SocketUsingTask.this.cancel();
                } finally {
                    return super.cancel(mayInterruptIfRunning);
                }
            }
        };
    }
}

case study:  shut down mechanism
Listing 7.13. Producer-Consumer Logging Service with No Shutdown Support.
class LogWriter {
    private final BlockingQueue<String> queue;
    private final LoggerThread logger;

    public LogWriter(Writer writer) {
        this.queue = new LinkedBlockingQueue<String>(CAPACITY);
        this.logger = new LoggerThread(writer);
    }

    public void start() {
        logger.start();
    }

    public void log(String msg) throws InterruptedException {
        queue.put(msg);
    }

    private class LoggerThread extends Thread {
        private final PrintWriter writer;
        // ...
        public void run() {
            try {
                while (true)
                    writer.println(queue.take());
            } catch (InterruptedException ignored) {
            } finally {
                writer.close();
            }
        }
    }
}

For a service like LogWriter to be useful in production, we need a way to terminate the logger thread so it does not prevent the JVM from
shutting down normally. Stopping the logger thread is easy enough, since it repeatedly calls take, which is responsive to
interruption; if the logger thread is modified to exit on catching InterruptedException, then interrupting the logger thread stops the service.

if the logger thread is modified to exit on catching InterruptedException, then interrupting the logger thread stops the service.
However, simply making the logger thread exit is not a very satifying shutdown mechanism. Such an abrupt shutdown discards log
messages that might be waiting to be written to the log, but, more importantly, threads blocked in log because the queue is full will never
become unblocked. Cancelling a producerconsumer activity requires cancelling both the producers and the consumers. Interrupting the
logger thread deals with the consumer, but because the producers in this case are not dedicated threads, cancelling them is harder.

Listing 7.14. Unreliable Way to Add Shutdown Support to the Logging Service.
    public void log(String msg) throws InterruptedException {
        if (!shutdownRequested)
            queue.put(msg);
        else
            throw new IllegalStateException("logger is shut down");
    }

The implementation of log is a check-then-act sequence: producers could observe that the service has not yet been shut
down but still queue messages after the shutdown, again with the risk that the producer might get blocked in log and never become
unblocked.


Listing 7.15. Adding Reliable Cancellation to LogWriter.
class LogService {
    private final BlockingQueue<String> queue;
    private final LoggerThread loggerThread;
    private final PrintWriter writer;
    @GuardedBy("this")
    private boolean isShutdown;
    @GuardedBy("this")
    private int reservations;

    public void start() {
        loggerThread.start();
    }

    public void stop() {
        synchronized (this) {
            isShutdown = true;
        }
        loggerThread.interrupt();
    }

    public void log(String msg) throws InterruptedException {
        synchronized (this) {
            if (isShutdown)
                throw new IllegalStateException(...);
            ++reservations;
        }
        queue.put(msg);
    }

    private class LoggerThread extends Thread {
        public void run() {
            try {
                while (true) {
                    try {
                        synchronized (this) {
                            if (isShutdown && reservations == 0)
                                break;
                        }
                        String msg = queue.take();
                        synchronized (this) {
                            --reservations;
                        }
                        writer.println(msg);
                    } catch (InterruptedException e) { /* retry */
                    }
                }
            } finally {
                writer.close();
            }
        }
    }
}

The way to provide reliable shutdown for LogWriter is to fix the race condition, which means making the submission of a new log
message atomic. But we don't want to hold a lock while trying to enqueue the message, since put could block. Instead, we can
atomically check for shutdown and conditionally increment a counter to "reserve" the right to submit a message, as shown in LogService
in Listing 7.15.

Listing 7.16. Logging Service that Uses an ExecutorService.
class LogService {
    private final ExecutorService exec = newSingleThreadExecutor();

    // ...
    public void start() {
    }

    public void stop() throws InterruptedException {
        try {
            exec.shutdown();
            exec.awaitTermination(TIMEOUT, UNIT);
        } finally {
            writer.close();
        }
    }

    public void log(String msg) {
        try {
            exec.execute(new WriteTask(msg));
        } catch (RejectedExecutionException ignored) {
        }
    }
}

Poison pills work reliably only with unbounded queues.

Listing 7.17. Shutdown with Poison Pill.<br><br>
class IndexingService {
    private static final File POISON = new File("");
    private final IndexerThread consumer = new IndexerThread();
    private final CrawlerThread producer = new CrawlerThread();
    private final BlockingQueue<File> queue;
    private final FileFilter fileFilter;
    private final File root;

    class CrawlerThread extends Thread {
        public void run() {
            try {
                crawl(root);
            } catch (InterruptedException e) {/* fall through */ } 
            finally {
                while (true) {
                    try {
                        queue.put(POISON);
                        break;
                    } catch (InterruptedException e1) {
                        /* retry */ }
                }
            }
        }

        private void crawl(File root) throws InterruptedException {
            // ...
        }
    }
    
    class IndexerThread extends Thread {
        public void run() {
            try {
                while (true) {
                    File file = queue.take();
                    if (file == POISON)
                        break;
                    else
                        indexFile(file);
                }
            } catch (InterruptedException consumed) {
            }
        }
    }

    public void start() {
        producer.start();
        consumer.start();
    }

    public void stop() {
        producer.interrupt();
    }

    public void awaitTermination() throws InterruptedException {
        consumer.join();
    }
}

If a method needs to process a batch of tasks and does not return until all the tasks are finished, it can simplify service lifecycle
management by using a private Executor whose lifetime is bounded by that method. (The invokeAll and invokeAny methods can often be
useful in such situations.)

boolean checkMail(Set<String> hosts, long timeout, TimeUnit unit) throws InterruptedException {
    ExecutorService exec = Executors.newCachedThreadPool();
    final AtomicBoolean hasNewMail = new AtomicBoolean(false);
    try {
        for (final String host : hosts)
            exec.execute(new Runnable()  {
                public void run() {
                    if (checkMail(host))
                        hasNewMail.set(true);
                }        
            });
    } finally {
        exec.shutdown();
        exec.awaitTermination(timeout, unit);
    }
    return hasNewMail.get();
}
    
When an ExecutorService is shut down abruptly with shutdownNow, it attempts to cancel the tasks currently in progress and returns a list
of tasks that were submitted but never started so that they can be logged or saved for later processing.[5]
[5] The Runnable objects returned by shutdownNow might not be the same objects that were submitted to the ExecutorService:
they might be wrapped instances of the submitted tasks.

However, there is no general way to find out which tasks started but did not complete. This means that there is no way of knowing the
state of the tasks in progress at shutdown time unless the tasks themselves perform some sort of checkpointing. To know which tasks
have not completed, you need to know not only which tasks didn't start, but also which tasks were in progress when the executor was
shut down.[6]

TRackingExecutor has an unavoidable race condition that could make it yield false positives: tasks that are identified as cancelled but
actually completed. This arises because the thread pool could be shut down between when the last instruction of the task
executes and when the pool records the task as complete. This is not a problem if tasks are idempotent (if performing them twice has the
same effect as performing them once), as they typically are in a web crawler. Otherwise, the application retrieving the cancelled tasks
must be aware of this risk and be prepared to deal with false positives.

Listing 7.21. ExecutorService that Keeps Track of Cancelled Tasks After Shutdown.
class TrackingExecutor extends AbstractExecutorService {
    private final ExecutorService exec;
    private final Set<Runnable> tasksCancelledAtShutdown = Collections
            .synchronizedSet(new HashSet<Runnable>());

    // ...
    public List<Runnable> getCancelledTasks() {
        if (!exec.isTerminated())
            throw new IllegalStateException(...);
        return new ArrayList<Runnable>(tasksCancelledAtShutdown);
    }

    public void execute(final Runnable runnable) {
        exec.execute(new Runnable() {
            public void run() {
                try {
                    runnable.run();
                } finally {
                    if (isShutdown() && Thread.currentThread().isInterrupted())
                        tasksCancelledAtShutdown.add(runnable);
                }
            }
        });
    }
    // delegate other ExecutorService methods to exec
}

Listing 7.22. Using TRackingExecutorService to Save Unfinished Tasks for Later Execution.
abstract class WebCrawler {
    private volatile TrackingExecutor exec;
    @GuardedBy("this")
    private final Set<URL> urlsToCrawl = new HashSet<URL>();

    // ...
    public synchronized void start() {
        exec = new TrackingExecutor(Executors.newCachedThreadPool());
        for (URL url : urlsToCrawl)
            submitCrawlTask(url);
        urlsToCrawl.clear();
    }

    public synchronized void stop() throws InterruptedException {
        try {
            saveUncrawled(exec.shutdownNow());
            if (exec.awaitTermination(TIMEOUT, UNIT))
                saveUncrawled(exec.getCancelledTasks());
        } finally {
            exec = null;
        }
    }

    protected abstract List<URL> processPage(URL url);

    private void saveUncrawled(List<Runnable> uncrawled) {
        for (Runnable task : uncrawled)
            urlsToCrawl.add(((CrawlTask) task).getPage());
    }

    private void submitCrawlTask(URL u) {
        exec.execute(new CrawlTask(u));
    }

    private class CrawlTask implements Runnable {
        private final URL url;

        // ...
        public void run() {
            for (URL link : processPage(url)) {
                if (Thread.currentThread().isInterrupted())
                    return;
                submitCrawlTask(link);
            }
        }

        public URL getPage() {
            return url;
        }
    }
}

Listing 7.23 illustrates a way to structure a worker thread within a thread pool. If a task throws an unchecked exception, it allows the
thread to die, but not before notifying the framework that the thread has died. The framework may then replace the worker thread with a
new thread, or may choose not to because the thread pool is being shut down or there are already enough worker threads to meet
current demand. ThreadPoolExecutor and Swing use this technique to ensure that a poorly behaved task doesn't prevent subsequent
tasks from executing. If you are writing a worker thread class that executes submitted tasks, or calling untrusted external code (such as
dynamically loaded plugins), use one of these approaches to prevent a poorly written task or plugin from taking down the thread that
happens to call it.

Listing 7.23. Typical Thread-pool Worker Thread Structure.
public void run() {
    Throwable thrown = null;
    try {
        while (!isInterrupted())
            runTask(getTaskFromWorkQueue());
    } catch (Throwable e) {
        thrown = e;
    } finally {
        threadExited(this, thrown);
    }
}

The previous section offered a proactive approach to the problem of unchecked exceptions. The Thread API also provides the
UncaughtExceptionHandler facility, which lets you detect when a thread dies due to an uncaught exception. The two approaches are
complementary: taken together, they provide defense-indepth against thread leakage.
When a thread exits due to an uncaught exception, the JVM reports this event to an application-provided UncaughtExceptionHandler
(see Listing 7.24); if no handler exists, the default behavior is to print the stack trace to System.err.[8]

[8] Before Java 5.0, the only way to control the UncaughtExceptionHandler was by subclassing THReadGroup. In Java 5.0 and
later, you can set an UncaughtExceptionHandler on a per-thread basis with THRead.setUncaughtExceptionHandler, and can also set the
default UncaughtExceptionHandler with Thread.setDefaultUncaughtExceptionHandler. However, only one of these handlers is calledfirst
the JVM looks for a per-thread handler, then for a THReadGroup handler. The default handler implementation in
THReadGroup delegates to its parent thread group, and so on up the chain until one of the ThreadGroup handlers deals
with the uncaught exception or it bubbles up to the toplevel thread group. The top-level thread group handler
delegates to the default system handler (if one exists; the default is none) and otherwise prints the stack trace to
the console.

In long-running applications, always use uncaught exception handlers for all threads that at least log the exception.

Somewhat confusingly, exceptions thrown from tasks make it to the uncaught exception handler only for tasks submitted with execute;
for tasks submitted with submit, any thrown exception, checked or not, is considered to be part of the task's return status. If a task
submitted with submit terminates with an exception, it is rethrown by Future.get, wrapped in an ExecutionException.

The JVM can shut down in either an orderly or abrupt manner. An orderly shutdown is initiated when the last "normal"
(nondaemon) thread terminates, someone calls System.exit, or by other platform-specific means (such as sending a SIGINT or hitting
Ctrl-C). While this is the standard and preferred way for the JVM to shut down, it can also be shut down abruptly by calling Runtime.halt or
by killing the JVM process through the operating system (such as sending a SIGKILL).

In an orderly shutdown, the JVM first starts all registered shutdown hooks. Shutdown hooks are unstarted threads that are registered with
Runtime.addShutdownHook. The JVM makes no guarantees on the order in which shutdown hooks are started. If any application
threads (daemon or nondaemon) are still running at shutdown time, they continue to run concurrently with the shutdown process. When
all shutdown hooks have completed, the JVM may choose to run finalizers if runFinalizersOnExit is true, and then halts. The JVM makes
no attempt to stop or interrupt any application threads that are still running at shutdown time; they are abruptly terminated when the JVM
eventually halts. If the shutdown hooks or finalizers don't complete, then the orderly shutdown process "hangs" and the JVM must be
shut down abruptly. In an abrupt shutdown, the JVM is not required to do anything other than halt the JVM; shutdown hooks will not run.

Shutdown hooks should be thread-safe: they must use synchronization when accessing shared data and should be careful to avoid
deadlock, just like any other concurrent code. Further, they should not make assumptions about the state of the application (such as
whether other services have shut down already or all normal threads have completed) or about why the JVM is shutting down, and must
therefore be coded extremely defensively. Finally, they should exit as quickly as possible, since their existence delays JVM termination at
a time when the user may be expecting the JVM to terminate quickly.

Because shutdown hooks all run concurrently, closing the log file could cause trouble for other shutdown hooks who want to use the
logger. To avoid this problem, shutdown hooks should not rely on services that can be shut down by the application or other shutdown
hooks. One way to accomplish this is to use a single shutdown hook for all services, rather than one for each service, and have it call a
series of shutdown actions. This ensures that shutdown actions execute sequentially in a single thread, thus avoiding the possibility of
race conditions or deadlock between shutdown actions. This technique can be used whether or not you use shutdown hooks; executing
shutdown actions sequentially rather than concurrently eliminates many potential sources of failure. In applications that maintain
explicit dependency information among services, this technique can also ensure that shutdown actions are performed in the right order.

Sometimes you want to create a thread that performs some helper function but you don't want the existence of this thread to prevent the
JVM from shutting down. This is what daemon threads are for.
Threads are divided into two types: normal threads and daemon threads. When the JVM starts up, all the threads it creates (such as
garbage collector and other housekeeping threads) are daemon threads, except the main thread. When a new thread is created, it
inherits the daemon status of the thread that created it, so by default any threads created by the main thread are also normal threads.
Normal threads and daemon threads differ only in what happens when they exit. When a thread exits, the JVM performs an inventory of
running threads, and if the only threads that are left are daemon threads, it initiates an orderly shutdown. When the JVM halts, any
remaining daemon threads are abandoned finally blocks are not executed, stacks are not unwound the JVM just exits.

Daemon threads should be used sparingly few processing activities can be safely abandoned at any time with no cleanup. In particular, it
is dangerous to use daemon threads for tasks that might perform any sort of I/O. Daemon threads are best saved for "housekeeping"
tasks, such as a background thread that periodically removes expired entries from an in-memory cache.

Daemon threads are not a good substitute for properly managing the lifecycle of services within an application.

Since finalizers can run in a thread managed by the JVM, any state accessed by a finalizer will be accessed by more than one thread
and therefore must be accessed with synchronization. Finalizers offer no guarantees on when or even if they run, and they impose a
significant performance cost on objects with nontrivial finalizers. They are also extremely difficult to write correctly.[9]
In most cases, the
combination of finally blocks and explicit close methods does a better job of resource management than finalizers; the sole exception is
when you need to manage objects that hold resources acquired by native methods. For these reasons and others, work hard to avoid
writing or using classes with finalizers (other than the platform library classes) [EJ Item 6].
[9] See (Boehm, 2005) for some of the challenges involved in writing finalizers.

While the Executor framework offers substantial flexibility in specifying and
modifying execution policies, not all tasks are compatible with all execution policies. Types of tasks that require specific execution
policies include:

Tasks that use ThreadLocal. ThreadLocal allows each thread to have its own private "version" of a variable. However, executors are
free to reuse threads as they see fit. The standard Executor implementations may reap idle threads when demand is low and add new
ones when demand is high, and also replace a worker thread with a fresh one if an unchecked exception is thrown from a task.
ThreadLocal makes sense to use in pool threads only if the thread-local value has a lifetime that is bounded by that of a task; Thread-Local
should not be used in pool threads to communicate values between tasks.

Thread pools work best when tasks are homogeneous and independent.Mixing long-running and short-running tasks risks "clogging" the
pool unless it is very large; submitting tasks that depend on other tasks risks deadlock unless the pool is unbounded.

Some tasks have characteristics that require or preclude a specific execution policy. Tasks that depend on other tasks
require that the thread pool be large enough that tasks are never queued or rejected; tasks that exploit thread
confinement require sequential execution. Document these requirements so that future maintainers do not undermine
safety or liveness by substituting an incompatible execution policy.
 
This is called thread
starvation deadlock, and can occur whenever a pool task initiates an unbounded blocking wait for some resource or condition that can
succeed only through the action of another pool task, such as waiting for the return value or side effect of another task, unless you can
guarantee that the pool is large enough.

Similarly, tasks coordinating amongst themselves with a barrier could also cause thread starvation deadlock if the pool is not big enough.

In addition to any explicit bounds on the size of a thread pool, there may also be implicit limits because of constraints on other resources.
If your application uses a JDBC connection pool with ten connections and each task needs a database connection, it is as if your thread
pool only has ten threads because tasks in excess of ten will block waiting for a connection.

How to decide size of thread pools
For compute-intensive tasks, an Ncpu-processor system usually achieves optimum utilization with a thread pool of Ncpu +1 threads.
(Even compute-intensive threads occasionally take a page fault or pause for some other reason, so an "extra" runnable thread prevents
CPU cycles from going unused when this happens.) For tasks that also include I/O or other blocking operations, you want a larger pool,
since not all of the threads will be schedulable at all times. In order to size the pool properly, you must estimate the ratio of waiting time
to compute time for your tasks; this estimate need not be precise and can be obtained through pro-filing or instrumentation. Alternatively,
the size of the thread pool can be tuned by running the application using several different pool sizes under a
benchmark load and observing the level of CPU utilization.

For tasks that also include I/O or other blocking operations,
Nthreads = Ncpu * Ucpu * ( 1 + Wait-time/Compute-time)      ( Ucpu is target CPU utilization, 0<= Ucpu <= 1 )

Ncpu = Runtime.getRuntime().availableProcessors();

The core pool size, maximum pool size, and keep-alive time govern thread creation and teardown. The core size is the target size; the
implementation attempts to maintain the pool at this size even when there are no tasks to execute,[2] and will not create
more threads than this unless the work queue is full.[3]The maximum pool size is the upper bound on how many pool threads can be
active at once. A thread that has been idle for longer than the keep-alive time becomes a candidate for reaping and can be terminated if
the current pool size exceeds the core size.

[2] When a ThreadPoolExecutor is initially created, the core threads are not started immediately but instead as tasks are
submitted, unless you call prestartAllCoreThreads.

The newFixedThreadPool factory sets both the core pool size and the maximum pool size to the requested pool size, creating the effect
of infinite timeout; the newCachedThreadPool factory sets the maximum pool size to Integer.MAX_VALUE and the core pool size to zero
with a timeout of one minute, creating the effect of an infinitely expandable thread pool that will contract again when demand decreases.
Other combinations are possible using the explicit THReadPool-Executor constructor.

Requests often arrive in bursts even when the average request rate is fairly stable. Queues can help smooth out transient bursts of
tasks, but if tasks continue to arrive too quickly you will eventually have to throttle the arrival rate to avoid running out of memory.[4] 
Even before you run out of memory, response time will get progressively worse as the task queue grows.
[4] This is analogous to flow control in communications networks: you may be willing to buffer a certain amount of
data, but eventually you need to find a way to get the other side to stop sending you data, or throw the excess
data on the floor and hope the sender retransmits it when you're not so busy.

ThreadPoolExecutor allows you to supply a BlockingQueue to hold tasks awaiting execution. There are three basic approaches to task
queueing: unbounded queue, bounded queue, and synchronous handoff. The choice of queue interacts with other configuration
parameters such as pool size.
The default for newFixedThreadPool and newSingleThreadExecutor is to use an unbounded LinkedBlockingQueue. Tasks will queue up
if all worker threads are busy, but the queue could grow without bound if the tasks keep arriving faster than they can be executed.

A more stable resource management strategy is to use a bounded queue, such as an ArrayBlockingQueue or a bounded
LinkedBlockingQueue or Priority-BlockingQueue. Bounded queues help prevent resource exhaustion but introduce the question of what
to do with new tasks when the queue is full. (There are a number of possible saturation policies for addressing this problem; see Section
8.3.3.) With a bounded work queue, the queue size and pool size must be tuned together. 

A large queue coupled with a small pool can help reduce memory usage, CPU usage, and context switching, at the cost of potentially constraining throughput.

For very large or unbounded pools, you can also bypass queueing entirely and instead hand off tasks directly from producers to worker
threads using a SynchronousQueue. A SynchronousQueue is not really a queue at all, but a mechanism for managing handoffs between
threads.

In order to put an element on a SynchronousQueue, another thread must already be waiting to accept the handoff. If no thread
is waiting but the current pool size is less than the maximum, Thread-PoolExecutor creates a new thread; otherwise the task is rejected
according to the saturation policy. Using a direct handoff is more efficient because the task can be handed right to the thread that will
execute it, rather than first placing it on a queue and then having the worker thread fetch it from the queue. SynchronousQueue is a
practical choice only if the pool is unbounded or if rejecting excess tasks is acceptable. The newCachedThreadPool factory uses a SynchronousQueue.

Using a FIFO queue like LinkedBlockingQueue or ArrayBlockingQueue causes tasks to be started in the order in which they arrived. For
more control over task execution order, you can use a PriorityBlockingQueue, which orders tasks according to priority.
Priority can be defined by natural order (if tasks implement Comparable) or by a Comparator.

The newCachedThreadPool factory is a good default choice for an Executor, providing better queuing performance than
a fixed thread pool.[5]
A fixed size thread pool is a good choice when you need to limit the number of concurrent tasks
for resource-management purposes, as in a server application that accepts requests from network clients and would
otherwise be vulnerable to overload.
[5] This performance difference comes from the use of SynchronousQueue instead of LinkedBlocking-Queue. SynchronousQueue was
replaced in Java 6 with a new nonblocking algorithm that improved throughput in Executor benchmarks by a factor of
three over the Java 5.0 SynchronousQueue implementation (Scherer et al., 2006).

Bounding either the thread pool or the work queue is suitable only when tasks are independent. With tasks that depend on other tasks,
bounded thread pools or queues can cause thread starvation deadlock; instead, use an unbounded pool configuration like
newCachedThreadPool.[6]
[6] An alternative configuration for tasks that submit other tasks and wait for their results is to use a bounded
thread pool, a SynchronousQueue as the work queue, and the caller-runs saturation policy.

When a bounded work queue fills up, the saturation policy comes into play. The saturation policy for a ThreadPoolExecutor can be
modified by calling setRejectedExecutionHandler. (The saturation policy is also used when a task is submitted to an Executor that has
been shut down.) Several implementations of RejectedExecutionHandler are provided, each implementing a different saturation policy:
AbortPolicy, CallerRunsPolicy, DiscardPolicy, and DiscardOldestPolicy.

The default policy, abort, causes execute to throw the unchecked Rejected-ExecutionException; the caller can catch this exception and
implement its own overflow handling as it sees fit. The discard policy silently discards the newly submitted task if it cannot be queued for
execution; the discard-oldest policy discards the task that would otherwise be executed next and tries to resubmit the new task. (If the
work queue is a priority queue, this discards the highest-priority element, so the combination of a discard-oldest saturation policy and a
priority queue is not a good one.)
The caller-runs policy implements a form of throttling that neither discards tasks nor throws an exception, but instead tries to slow down
the flow of new tasks by pushing some of the work back to the caller. It executes the newly submitted task not in a pool thread, but in the
thread that calls execute. If we modified our WebServer example to use a bounded queue and the caller-runs policy, after all the pool
threads were occupied and the work queue filled up the next task would be executed in the main thread during the call to execute. Since
this would probably take some time, the main thread cannot submit any more tasks for at least a little while, giving the worker
threads some time to catch up on the backlog. The main thread would also not be calling accept during this time("accept" is function name), so incoming requests
will queue up in the TCP layer instead of in the application. If the overload persisted, eventually the TCP layer would decide it has
queued enough connection requests and begin discarding connection requests as well. As the server becomes overloaded, the overload
is gradually pushed outwardfrom the pool threads to the work queue to the application to the TCP layer, and eventually to the
client enabling more graceful degradation under load.

There is no predefined saturation policy to make execute block when the work queue is full. However, the same effect can be
accomplished by using a Semaphore to bound the task injection rate, as shown in BoundedExecutor in Listing 8.4.

Listing 8.4. Using a Semaphore to Throttle Task Submission.
@ThreadSafe
class BoundedExecutor {
    private final Executor exec;
    private final Semaphore semaphore;

    public BoundedExecutor(Executor exec, int bound) {
        this.exec = exec;
        this.semaphore = new Semaphore(bound);
    }

    public void submitTask(final Runnable command) throws InterruptedException {
        semaphore.acquire();
        try {
            exec.execute(new Runnable() {
                public void run() {
                    try {
                        command.run();
                    } finally {
                        semaphore.release();
                    }
                }
            });
        } catch (RejectedExecutionException e) {
            semaphore.release();
        }
    }
}

If your application takes advantage of security policies to grant permissions to particular codebases, you may want to use the
privilegedThreadFactory factory method in Executors to construct your thread factory. It creates pool threads that have the same
permissions, AccessControlContext, and contextClassLoader as the thread creating the privilegedThreadFactory. Otherwise, threads
created by the thread pool inherit permissions from whatever client happens to be calling execute or submit at the time a new thread is
needed, which could cause confusing security-related exceptions.

Executors includes a factory method, unconfigurableExecutorService, which takes an existing ExecutorService and wraps it with one
exposing only the methods of ExecutorService so it cannot be further configured. Unlike the pooled implementations,
newSingleThreadExecutor returns an ExecutorService wrapped in this manner, rather than a raw ThreadPoolExecutor. While a
single-threaded executor is actually implemented as a thread pool with one thread, it also promises not to execute tasks concurrently. If
some misguided code were to increase the pool size on a single-threaded executor, it would undermine the intended execution
semantics.

You can use this technique with your own executors to prevent the execution policy from being modified. If you will be exposing an
ExecutorService to code you don't trust not to modify it, you can wrap it with an unconfigurableExecutorService

ThreadPoolExecutor was designed for extension, providing several "hooks" for subclasses to override beforeExecute, afterExecute, and
terminate that can be used to extend the behavior of ThreadPoolExecutor.

The beforeExecute and afterExecute hooks are called in the thread that executes the task.

Loops whose bodies contain nontrivial computation or
perform potentially blocking I/O are frequently good candidates for parallelization, as long as the iterations are independent

Sequential loop iterations are suitable for parallelization when each iteration is independent of the others and the work
done in each iteration of the loop body is significant enough to offset the cost of managing a new task.


Loop parallelization can also be applied to some recursive designs; there are often sequential loops within the recursive algorithm that
can be parallelized in the same manner as Listing 8.10. The easier case is when each iteration does not require the results of the
recursive iterations it invokes.
Listing 8.11. Transforming Sequential Tail-recursion into Parallelized Recursion.

public <T> void sequentialRecursive(List<Node<T>> nodes,
        Collection<T> results) {
    for (Node<T> n : nodes) {
        results.add(n.compute());
        sequentialRecursive(n.getChildren(), results);
    }
}

public <T> void parallelRecursive(final Executor exec, List<Node<T>> nodes,
        final Collection<T> results) {
    for (final Node<T> n : nodes) {
        exec.execute(new Runnable() {
            public void run() {
                results.add(n.compute());
            }
        });
        parallelRecursive(exec, n.getChildren(), results);
    }
}

Listing 8.12. Waiting for Results to be Calculated in Parallel.
public <T> Collection<T> getParallelResults(List<Node<T>> nodes)
        throws InterruptedException {
    ExecutorService exec = Executors.newCachedThreadPool();
    Queue<T> resultQueue = new ConcurrentLinkedQueue<T>();
    parallelRecursive(exec, nodes, resultQueue);
    exec.shutdown();
    exec.awaitTermination(Long.MAX_VALUE, TimeUnit.SECONDS);
    return resultQueue;
}

Case study: A Puzzle Framework

We define a "puzzle" as a combination of an initial position, a goal position, and a set of rules that determine valid moves. The rule set
has two parts: computing the list of legal moves from a given position and computing the result of applying a move to a position. Puzzle
in Listing 8.13 shows our puzzle abstraction; the type parameters P and M represent the classes for a position and a move. From this
interface, we can write a simple sequential solver that searches the puzzle space until a solution is found or the puzzle space is
exhausted.

Node in Listing 8.14 represents a position that has been reached through some series of moves, holding a reference to the move that
created the position and the previous Node. Following the links back from a Node lets us reconstruct the sequence of moves that led to
the current position.

Rewriting the solver to exploit concurrency would allow us to compute next moves and evaluate the goal condition in parallel, since the
process of evaluating one move is mostly independent of evaluating other moves. (We say "mostly" because tasks share some mutable
state, such as the set of seen positions.) If multiple processors are available, this could reduce the time it takes to find a solution.

ConcurrentPuzzleSolver in Listing 8.16 uses an inner SolverTask class that extends Node and implements Runnable. Most of the work is
done in run: evaluating the set of possible next positions, pruning positions already searched, evaluating whether success has yet been
achieved (by this task or by some other task), and submitting unsearched positions to an Executor.

To avoid infinite loops, the sequential version maintained a Set of previously searched positions; ConcurrentPuzzleSolver uses a
ConcurrentHashMap for this purpose. This provides thread safety and avoids the race condition inherent in conditionally updating a
shared collection by using putIfAbsent to atomically add a position only if it was not previously known.ConcurrentPuzzleSolver
uses the internal work queue of the thread pool instead of the call stack to hold the state of the search.

The concurrent approach also trades one form of limitation for another that might be more suitable to the problem domain. The
sequential version performs a depth-first search, so the search is bounded by the available stack size. The concurrent version performs a
breadth-first search and is therefore free of the stack size restriction (but can still run out of memory if the set of positions to be searched
or already searched exceeds the available memory).

In order to stop searching when we find a solution, we need a way to determine whether any thread has found a solution yet. If we want
to accept the first solution found, we also need to update the solution only if no other task has already found one. These requirements
describe a sort of latch (see Section 5.5.1) and in particular, a result-bearing latch. We could easily build a blocking result bearing latch
using the techniques in Chapter 14, but it is often easier and less error-prone to use existing library classes rather than low-level
language mechanisms. ValueLatch in Listing 8.17 uses a CountDownLatch to provide the needed latching behavior, and uses locking to
ensure that the solution is set only once.

Each task first consults the solution latch and stops if a solution has already been found. The main thread needs to wait until a solution is
found; getValue in ValueLatch blocks until some thread has set the value. ValueLatch provides a way to hold a value such that only the
first call actually sets the value, callers can test whether it has been set, and callers can block waiting for it to be set. On the first call to
setValue, the solution is updated and the CountDownLatch is decremented, releasing the main solver thread from getValue.

The first thread to find a solution also shuts down the Executor, to prevent new tasks from being accepted. To avoid having to deal with
RejectedExecutionException, the rejected execution handler should be set to discard submitted tasks. Then, all unfinished tasks
eventually run to completion and any subsequent attempts to execute new tasks fail silently, allowing the executor to terminate. (If the
tasks took longer to run, we might want to interrupt them instead of letting them finish.)

ConcurrentPuzzleSolver does not deal well with the case where there is no solution: if all possible moves and positions have been
evaluated and no solution has been found, solve waits forever in the call to getSolution. The sequential version terminated when it had
exhausted the search space, but getting concurrent programs to terminate can sometimes be more difficult. One possible solution is to
keep a count of active solver tasks and set the solution to null when the count drops to zero, as in Listing 8.18.

Finding the solution may also take longer than we are willing to wait; there are several additional termination conditions we could impose
on the solver. One is a time limit; this is easily done by implementing a timed getValue in ValueLatch (which would use the timed version
of await), and shutting down the Executor and declaring failure if getValue times out. Another is some sort of puzzle-specific metric such
as searching only up to a certain number of positions. Or we can provide a cancellation mechanism and let the client make its own
decision about when to stop searching.

Listing 8.13. Abstraction for Puzzles Like the "Sliding Blocks Puzzle".
public interface Puzzle<P, M> {
    P initialPosition();
    boolean isGoal(P position);
    Set<M> legalMoves(P position);
    P move(P position, M move);
}

Listing 8.14. Link Node for the Puzzle Solver Framework.
@Immutable
static class Node<P, M> {
    final P pos;
    final M move;
    final Node<P, M> prev;

    Node(P pos, M move, Node<P, M> prev) {...}

    List<M> asMoveList() {
        List<M> solution = new LinkedList<M>();
        for (Node<P, M> n = this; n.move != null; n = n.prev)
            solution.add(0, n.move);
        return solution;
    }
}

Listing 8.15. Sequential Puzzle Solver.
public class SequentialPuzzleSolver<P, M> {
    private final Puzzle<P, M> puzzle;
    private final Set<P> seen = new HashSet<P>();

    public SequentialPuzzleSolver(Puzzle<P, M> puzzle) {
        this.puzzle = puzzle;
    }

    public List<M> solve() {
        P pos = puzzle.initialPosition();
        return search(new Node<P, M>(pos, null, null));
    }

    private List<M> search(Node<P, M> node) {
        if (!seen.contains(node.pos)) {
            seen.add(node.pos);
            if (puzzle.isGoal(node.pos))
                return node.asMoveList();
            for (M move : puzzle.legalMoves(node.pos)) {
                P pos = puzzle.move(node.pos, move);
                Node<P, M> child = new Node<P, M>(pos, move, node);
                List<M> result = search(child);
                if (result != null)
                    return result;
            }
        }
        return null;
    }

    static class Node<P, M> { /* Listing 8.14 */
    }
}

Listing 8.16. Concurrent Version of Puzzle Solver.

public class ConcurrentPuzzleSolver<P, M> {
    private final Puzzle<P, M> puzzle;
    private final ExecutorService exec;
    private final ConcurrentMap<P, Boolean> seen;
    final ValueLatch<Node<P, M>> solution = new ValueLatch<Node<P, M>>();

    // ...
    public List<M> solve() throws InterruptedException {
        try {
            P p = puzzle.initialPosition();
            exec.execute(newTask(p, null, null));
            // block until solution found
            Node<P, M> solnNode = solution.getValue();
            return (solnNode == null) ? null : solnNode.asMoveList();
        } finally {
            exec.shutdown();
        }
    }

    protected Runnable newTask(P p, M m, Node<P, M> n) {
        return new SolverTask(p, m, n);
    }

    class SolverTask extends Node<P, M> implements Runnable {
        // ...
        public void run() {
            if (solution.isSet() || seen.putIfAbsent(pos, true) != null)
                return; // already solved or seen this position
            if (puzzle.isGoal(pos))
                solution.setValue(this);
            else
                for (M m : puzzle.legalMoves(pos))
                    exec.execute(newTask(puzzle.move(pos, m), m, this));
        }
    }
}

Listing 8.17. Result-bearing Latch Used by ConcurrentPuzzleSolver.

@ThreadSafe
public class ValueLatch<T> {
    @GuardedBy("this") private T value = null;
    private final CountDownLatch done = new CountDownLatch(1);
    public boolean isSet() {
        return (done.getCount() == 0);
    }
    public synchronized void setValue(T newValue) {
        if (!isSet()) {
            value = newValue;
            done.countDown();
        }
    }
    public T getValue() throws InterruptedException {
        done.await();
        synchronized (this) {
            return value;
        }
    }
}

Listing 8.18. Solver that Recognizes when No Solution Exists. 

public class PuzzleSolver<P, M> extends ConcurrentPuzzleSolver<P, M> {
    // ...
    private final AtomicInteger taskCount = new AtomicInteger(0);

    protected Runnable newTask(P p, M m, Node<P, M> n) {
        return new CountingSolverTask(p, m, n); 
    }

    class CountingSolverTask extends SolverTask {
        CountingSolverTask(P pos, M move, Node<P, M> prev) {
            super(pos, move, prev);
            taskCount.incrementAndGet();
        }

        public void run() {
            try {
                super.run();
            } finally {
                if (taskCount.decrementAndGet() == 0)
                    solution.setValue(null);
            }
        }
    }
}


To maintain safety, certain tasks must run in the Swing event thread. But you cannot execute longrunning tasks in the
event thread, lest the UI become unresponsive. And Swing data structures are not thread-safe, so you must be careful to confine them
to the event thread.

Nearly all GUI toolkits, including Swing and SWT, are implemented as singlethreaded subsystems in which all GUI activity is confined to
a single thread.

In the old days, GUI applications were single-threaded and GUI events were processed from a "main event loop". Modern GUI
frameworks use a model that is only slightly different: they create a dedicated event dispatch thread (EDT) for handling GUI events.

Single-threaded GUI frameworks are not unique to Java; Qt, NextStep, MacOS Cocoa, X Windows, and many others are also
single-threaded. This is not for lack of trying; there have been many attempts to write multithreaded GUI frameworks, but because of
persistent problems with race conditions and deadlock, they all eventually arrived at the single-threaded event queue model in which a
dedicated thread fetches events off a queue and dispatches them to application defined event handlers. (AWT originally tried to support a
greater degree of multithreaded access, and the decision to make Swing single-threaded was based largely on experience with AWT.)

Single-threaded GUI frameworks achieve thread safety via thread confinement; all GUI objects, including visual components and data
models, are accessed exclusively from the event thread. Of course, this just pushes some of the thread safety burden back onto the
application developer, who must make sure these objects are properly confined

GUI applications are oriented around processing fine-grained events such as mouse clicks, key presses, or timer
expirations. Events are a kind of task; the event handling machinery provided by AWT and Swing is structurally similar to an Executor.
Because there is only a single thread for processing GUI tasks, they are processed sequentially one task finishes before the next one
begins, and no two tasks overlap. Knowing this makes writing task code easier you don't have to worry about interference from other
tasks.

All Swing components (such as JButton and JTable) and data model objects (such as TableModel and TReeModel) are confined to the
event thread, so any code that accesses these objects must run in the event thread. GUI objects are kept consistent not by
synchronization, but by thread confinement. The upside is that tasks that run in the event thread need not worry about synchronization
when accessing presentation objects; the downside is that you cannot access presentation objects from outside the event thread at all.

The Swing single-thread rule: Swing components and models should be created, modified, and queried only from the
event-dispatching thread.

As with all rules, there are a few exceptions. A small number of Swing methods may be called safely from any thread; these are clearly
identified in the Javadoc as being thread-safe. Other exceptions to the single-thread rule include:
    SwingUtilities.isEventDispatchThread, which determines whether the current thread is the event thread;
    SwingUtilities.invokeLater, which schedules a Runnable for execution on the event thread (callable from any thread);
    SwingUtilities.invokeAndWait, which schedules a Runnable task for execution on the event thread and blocks the current
thread until it completes (callable only from a non-GUI thread);
    methods to enqueue a repaint or revalidation request on the event queue (callable from any thread); and
    methods for adding and removing listeners (can be called from any thread, but listeners will always be invoked in the event
thread).

//Listing 9.1. Implementing SwingUtilities Using an Executor.
class SwingUtilities {
    private static final ExecutorService exec = Executors
            .newSingleThreadExecutor(new SwingThreadFactory());
    private static volatile Thread swingThread;

    private static class SwingThreadFactory implements ThreadFactory {
        public Thread newThread(Runnable r) {
            swingThread = new Thread(r);
            return swingThread;
        }
    }

    public static boolean isEventDispatchThread() {
        return Thread.currentThread() == swingThread;
    }

    public static void invokeLater(Runnable task) {
        exec.execute(task);
    }

    public static void invokeAndWait(Runnable task)
            throws InterruptedException, InvocationTargetException {
        Future f = exec.submit(task);
        try {
            f.get();
        } catch (ExecutionException e) {
            throw new InvocationTargetException(e);
        }
    }
}

//Listing 9.2. Executor Built Atop SwingUtilities.
class GuiExecutor extends AbstractExecutorService {
    // Singletons have a private constructor and a public factory
    private static final GuiExecutor instance = new GuiExecutor(); 

    private GuiExecutor() {
    }

    public static GuiExecutor instance() {
        return instance;
    }

    public void execute(Runnable r) {
        if (SwingUtilities.isEventDispatchThread())
            r.run();
        else
            SwingUtilities.invokeLater(r);
    }
    // Plus trivial implementations of lifecycle methods
}

The task triggered when the button is pressed is composed of three sequential subtasks whose execution alternates between the event
thread and the background thread. The first subtask updates the user interface to show that a longrunning operation has begun and
starts the second subtask in a background thread. Upon completion, the second subtask queues the third subtask to run again in the
event thread, which updates the user interface to reflect that the operation has completed. This sort of "thread hopping" is typical of
handling long-running tasks in GUI applications.

//Listing 9.5. Long-running Task with User Feedback.

class LongrunTaskInSwing {
    public void longRunCall() {
        button.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                button.setEnabled(false);
                label.setText("busy");
                backgroundExec.execute(new Runnable() {
                    public void run() {
                        try {
                            doBigComputation();
                        } finally {
                            GuiExecutor.instance().execute(new Runnable() {
                                public void run() {
                                    button.setEnabled(true);
                                    label.setText("idle");
                                }
                            });
                        }
                    }
                });
            }
        });
    }
}

Using a Future to represent a long-running task greatly simplified implementing cancellation. FutureTask also has a done hook that
similarly facilitates completion notification. After the background Callable completes, done is called.

We've built a simple framework using FutureTask and Executor to execute longrunning tasks in background threads without undermining
the responsiveness of the GUI. These techniques can be applied to any single-threaded GUI framework, not just Swing. In Swing, many
of the features developed here are provided by the SwingWorker class, including cancellation, completion notification, and progress
indication. Various versions of SwingWorker have been published in The Swing Connection and The Java Tutorial, and an updated
version is included in Java 6.

As long as responsiveness is not unduly affected by blocking, the problem of multiple threads operating on the data can be
addressed with a thread-safe data model. If the data model supports fine-grained concurrency, the event thread and background threads
should be able to share it without responsiveness problems. For example, DelegatingVehicleTracker on page 65 uses an underlying
ConcurrentHashMap whose retrieval operations offer a high degree of concurrency. The downside is that it does not offer a consistent
snapshot of the data, which may or may not be a requirement. Thread-safe data models must also generate events when the model has
been updated, so that views can be updated when the data changes.

It may sometimes be possible to get thread safety, consistency and good responsiveness with a versioned data model such as
CopyOnWriteArrayList [CPJ 2.2.3.3]. When you acquire an iterator for a copy-on-write collection, that iterator traverses the collection as it
existed when the iterator was created. However, copy-on-write collections offer good performance only when traversals greatly
outnumber modifications, which would probably not be the case in, say, a vehicle tracking application. More specialized versioned data
structures may avoid this restriction, but building versioned data structures that provide both efficient concurrent access and do not retain
old versions of data longer than needed is not easy, and thus should be considered only when other approaches are not practical

A program that has both a presentation-domain and an application-domain data model is said to have a split-model design (Fowler, 2005).

In a split-model design, the presentation model is confined to the event thread and the other model, the shared model, is thread-safe and
may be accessed by both the event thread and application threads. The presentation model registers listeners with the shared model so
it can be notified of updates. The presentation model can then be updated from the shared model by embedding a snapshot of the
relevant state in the update message or by having the presentation model retrieve the data directly from the shared model when it
receives an update event.

The snapshot approach is simple, but has limitations. It works well when the data model is small, updates are not too frequent, and the
structure of the two models is similar. If the data model is large or updates are very frequent, or if one or both sides of the split contain
information that is not visible to the other side, it can be more efficient to send incremental updates instead of entire snapshots. This
approach has the effect of serializing updates on the shared model and recreating them in the event thread against the presentation
model. Another advantage of incremental updates is that finer-grained information about what changed can improve the perceived
quality of the display if only one vehicle moves, we don't have to repaint the entire display, just the affected regions

Consider a split-model design when a data model must be shared by more than one thread and implementing a
thread-safe data model would be inadvisable because of blocking, consistency, or complexity reasons.

We use locking to ensure thread safety, but indiscriminate
use of locking can cause lock-ordering deadlocks. Similarly, we use thread pools and semaphores to bound resource consumption, but
failure to understand the activities being bounded can cause resource deadlocks.

Lock-ordering Deadlocks:
The deadlock in LeftRightDeadlock came about because the two threads attempted to acquire the same locks in a different  order. If they
asked for the locks in the same order, there would be no cyclic locking dependency and therefore no deadlock. If you can guarantee that
every thread that needs locks L and M at the same time always acquires L and M in the same order, there will be no  deadlock.

A program will be free of lock-ordering deadlocks if all threads acquire the locks they need in a fixed global order.

Verifying consistent lock ordering requires a global analysis of your program's locking behavior. It is not sufficient to inspect code paths
that acquire multiple locks individually; both leftRight and rightLeft are "reasonable" ways to acquire the two locks, they are just not
compatible. When it comes to locking, the left hand needs to know what the right hand is doing.

Dynamic Lock Order Deadlocks
One way to induce an ordering on objects is to use System.identityHashCode, which returns the value that would be returned by
Object.hashCode. Listing 10.3 shows a version of transferMoney that uses System.identityHashCode to induce a lock ordering. It
involves a few extra lines of code, but eliminates the possibility of deadlock.
In the rare case that two objects have the same hash code, we must use an arbitrary means of ordering the lock acquisitions, and this
reintroduces the possibility of deadlock. To prevent inconsistent lock ordering in this case, a third "tie breaking" lock is used. By acquiring
the tie-breaking lock before acquiring either Account lock, we ensure that only one thread at a time performs the risky task of acquiring
two locks in an arbitrary order, eliminating the possibility of deadlock (so long as this mechanism is used consistently). If hash collisions
were common, this technique might become a concurrency bottleneck (just as having a single, program-wide lock would), but because
hash collisions with System.identityHashCode are vanishingly infrequent, this technique provides that last bit of safety at little cost.

You may think we're overstating the risk of deadlock because locks are usually held only briefly, but deadlocks are a serious problem in
real systems. A production application may perform billions of lock acquire-release cycles per day. Only one of those needs to be timed
just wrong to bring the application to deadlock, and even a thorough load-testing regimen may not disclose all latent deadlocks.[1]
[1] Ironically, holding locks for short periods of time, as you are supposed to do to reduce lock contention,
increases the likelihood that testing will not disclose latent deadlock risks.

Invoking an alien method with a lock held is asking for liveness trouble. The alien method might acquire other locks
(risking deadlock) or block for an unexpectedly long time, stalling other threads that need the lock you hold.

a method call is an abstraction barrier intended to shield you from the details of what happens on the other side. But because you don't
know what is happening on the other side of the call, calling an alien method with a lock held is difficult to analyze and therefore risky.

Calling a method with no locks held is called an open call [CPJ 2.4.1.3], and classes that rely on open calls are more well-behaved and
composable than classes that make calls with locks held. Using open calls to avoid deadlock is analogous to using encapsulation to
provide thread safety: while one can certainly construct a thread-safe program without any encapsulation, the thread safety analysis of a
program that makes effective use of encapsulation is far easier than that of one that does not. Similarly, the liveness analysis of a
program that relies exclusively on open calls is far easier than that of one that does not. Restricting yourself to open calls makes it
far easier to identify the code paths that acquire multiple locks and therefore to ensure that locks are acquired in a consistent order.

Taxi and Dispatcher in Listing 10.5 can be easily refactored to use open calls and thus eliminate the deadlock risk. This involves
shrinking the synchronized blocks to guard only operations that involve shared state, as inL isting 10.6. Very often, the cause of problems
like those in Listing 10.5 is the use of synchronized methods instead of smaller synchronized blocks for reasons of compact syntax or
simplicity rather than because the entire method must be guarded by a lock. (As a bonus, shrinking the synchronized block may also
improve scalability as well; see Section 11.4.1 for advice on sizing synchronized blocks.)

Strive to use open calls throughout your program. Programs that rely on open calls are far easier to analyze for
deadlock-freedom than those that allow calls to alien methods with locks held

Restructuring a synchronized block to allow open calls can sometimes have undesirable consequences, since it takes an operation that
was atomic and makes it not atomic. In many cases, the loss of atomicity is perfectly acceptable; there's no reason that updating a taxi's
location and notifying the dispatcher that it is ready for a new destination need be an atomic operation. In other cases, the loss of
atomicity is noticeable but the semantic changes are still acceptable. In the deadlock-prone version, getImage produces a complete
snapshot of the fleet locations at that instant; in the refactored version, it fetches the location of each taxi at slightly different times.

Thus, rather than using locking to keep the other threads out of a critical section of code,
this technique relies on constructing protocols so that other threads don't try to get in.

In some cases, however, the loss of atomicity is a problem, and here you will have to use another technique to achieve atomicity. One
such technique is to structure a concurrent object so that only one thread can execute the code path following the open call. For
example, when shutting down a service, you may want to wait for in-progress operations to complete and then release resources used by
the service. Holding the service lock while waiting for operations to complete is inherently deadlock-prone, but releasing the service lock
before the service is shut down may let other threads start new operations. The solution is to hold the lock long enough to update the
service state to "shutting down" so that other threads wanting to start new operations including shutting down the service see that the
service is unavailable, and do not try. You can then wait for shutdown to complete, knowing that only the shutdown thread has access to
the service state after the open call completes. Thus, rather than using locking to keep the other threads out of a critical section of code,
this technique relies on constructing protocols so that other threads don't try to get in.

Another form of resource-based deadlock is thread-starvation deadlock. We saw an example of this hazard in Section 8.1.1, where a task
that submits a task and waits for its result executes in a single-threaded Executor. In that case, the first task will wait forever,
permanently stalling that task and all others waiting to execute in that Executor. Tasks that wait for the results of other tasks are the
primary source of thread-starvation deadlock; bounded pools and interdependent tasks do not mix well.

In programs that use fine-grained locking, audit your code for deadlock freedom using a two-part strategy: first, identify where multiple
locks could be acquired (try to make this a small set), and then perform a global analysis of all such instances to ensure that lock
ordering is consistent across your entire program. Using open calls wherever possible simplifies this analysis substantially. With no
non-open calls, finding instances where multiple locks are acquired is fairly easy, either by code review or by automated bytecode or
source code analysis.

Another technique for detecting and recovering from deadlocks is to use the timed tryLock feature of the explicit Lock classes (see
Chapter 13) instead of intrinsic locking.Where intrinsic locks wait forever if they cannot acquire the lock, explicit locks let you specify a
timeout after which tryLock returns failure. By using a timeout that is much longer than you expect acquiring the lock to take, you can
regain control when something unexpected happens. (Listing 13.3 on page 280 shows an alternative implementation of transferMoney
using the polled tryLock with retries for probabilistic deadlock avoidance.)

Using timed lock acquisition to acquire multiple locks can be effective against deadlock even when timed locking is not used consistently
throughout the program. If a lock acquisition times out, you can release the locks, back off and wait for a while, and try again, possibly
clearing the deadlock condition and allowing the program to recover. (This technique works only when the two locks are acquired
together; if multiple locks are acquired due to the nesting of method calls, you cannot just release the outer lock, even if you know you
hold it.)

While preventing deadlocks is mostly your problem, the JVM can help identify them when they do happen using thread dumps. A thread
dump includes a stack trace for each running thread, similar to the stack trace that accompanies an exception. Thread dumps also
include locking information, such as which locks are held by each thread, in which stack frame they were acquired, and which lock a
blocked thread is waiting to acquire.[4]
Before generating a thread dump, the JVM searches the is-waiting-for graph for cycles to find
deadlocks. If it finds one, it includes deadlock information identifying which locks and threads are involved, and where in the program the
offending lock acquisitions are

If you are using the explicit Lock classes instead of intrinsic locking, Java 5.0 has no support for associating Lock information with the
thread dump; explicit Locks do not show up at all in thread dumps. Java 6 does include thread dump support and deadlock detection with
explicit Locks, but the information on where Locks are acquired is necessarily less precise than for intrinsic locks. Intrinsic locks are
associated with the stack frame in which they were acquired; explicit Locks are associated only with the acquiring thread.

While deadlock is the most widely encountered liveness hazard, there are several other liveness hazards you may encounter
in concurrent programs including starvation, missed signals, and livelock.

Starvation occurs when a thread is perpetually denied access to resources it needs in order to make progress; the most commonly
starved resource is CPU cycles. Starvation in Java applications can be caused by inappropriate use of thread priorities. It can also be
caused by executing nonterminating constructs (infinite loops or resource waits that do not terminate) with a lock held, since other
threads that need that lock will never be able to acquire it.

The thread priorities defined in the Thread API are merely scheduling hints. The Thread API defines ten priority levels that the JVM can
map to operating system scheduling priorities as it sees fit. This mapping is platform-specific,

In most Java applications, all application threads have the same priority, Thread. NORM_PRIORITY. The thread priority
mechanism is a blunt instrument, and it's not always obvious what effect changing priorities will have; boosting a thread's priority might
do nothing or might always cause one thread to be scheduled in preference to the other, causing starvation.

It is generally wise to resist the temptation to tweak thread priorities. As soon as you start modifying priorities, the behavior of your
application becomes platform-specific and you introduce the risk of starvation. You can often spot a program that is trying to recover
from priority tweaking or other responsiveness problems by the presence of Thread.sleep or Thread.yield calls in odd places, in an
attempt to give more time to lower-priority threads

Avoid the temptation to use thread priorities, since they increase platform dependence and can cause liveness
problems. Most concurrent applications can use the default priority for all threads.

One step removed from starvation is poor responsiveness, which is not uncommon in GUI applications using background
threads. Chapter 9 developed a framework for offloading long-running tasks onto background threads so as not to freeze the user
interface. CPU-intensive background tasks can still affect responsiveness because they can compete for CPU cycles with the event
thread. This is one case where altering thread priorities makes sense; when compute intensive background computations would affect
responsiveness. If the work done by other threads are truly background tasks, lowering their priority can make the foreground tasks more
responsive.

Livelock is a form of liveness failure in which a thread, while not blocked, still cannot make progress because it keeps retrying an
operation that will always fail. Livelock often occurs in transactional messaging applications, where the messaging infrastructure rolls
back a transaction if a message cannot be processed successfully, and puts it back at the head of the queue. If a bug in the message
handler for a particular type of message causes it to fail, every time the message is dequeued and passed to the buggy handler, the
transaction is rolled back. Since the message is now back at the head of the queue, the handler is called over and over with the same
result. (This is sometimes called the poison message problem.) The message handling thread is not blocked, but it will never make
progress either. This form of livelock often comes from overeager error-recovery code that mistakenly treats an unrecoverable error as a
recoverable one.

Livelock can also occur when multiple cooperating threads change their state in response to the others in such a way that no thread can
ever make progress. This is similar to what happens when two overly polite people are walking in opposite directions in a hallway: each
steps out of the other's way, and now they are again in each other's way. So they both step aside again, and again, and again.

The solution for this variety of livelock is to introduce some randomness into the retry mechanism
Retrying with random waits and backoffs can be equally effective for avoiding livelock in concurrent applications.

This chapter explores techniques for analyzing, monitoring, and improving the performance of concurrent programs. Unfortunately, many
of the techniques for improving performance also increase complexity, thus increasing the likelihood of safety and liveness failures.
Worse, some techniques intended to improve performance are actually counterproductive or trade one sort of performance problem for
another. While better performance is often desirable and improving performance can be very satisfying safety always comes first. First
make your program right, then make it fast and then only if your performance requirements and measurements tell you it needs to be
faster. In designing a concurrent application, squeezing out the last bit of performance is often the least of your concerns.

Improving performance means doing more work with fewer resources.

When the performance of an activity is limited by availability of a particular resource, we say it is bound by that resource: CPU-bound, database-bound, etc.

While the goal may be to improve performance overall, using multiple threads always introduces some performance costs compared to
the single-threaded approach. These include the overhead associated with coordinating between threads (locking, signaling, and
memory synchronization), increased context switching, thread creation and teardown, and scheduling overhead. When
threading is employed effectively, these costs are more than made up for by greater throughput, responsiveness, or capacity. On the
other hand, a poorly designed concurrent application can perform even worse than a comparable sequential one.

In using concurrency to achieve better performance, we are trying to do two things: utilize the processing resources we have more
effectively, and enable our program to exploit additional processing resources if they become available.

Application performance can be measured in a number of ways, such as service time, latency, throughput, efficiency, scalability, or
capacity. Some of these (service time, latency) are measures of "how fast" a given unit of work can be processed or acknowledged;
others (capacity, throughput) are measures of "how much" work can be performed with a given quantity of computing resources.

Scalability describes the ability to improve throughput or capacity when additional computing resources (such as
additional CPUs, memory, storage, or I/O bandwidth) are added

Designing and tuning concurrent applications for scalability can be very different from traditional performance optimization. When tuning
for performance, the goal is usually to do the same work with less effort, such as by reusing previously computed results through caching
or replacing an O(n2) algorithm with an O(n log n) one. When tuning for scalability, you are instead trying to find ways to parallelize the
problem so you can take advantage of additional processing resources to do more work with more resources.

These two aspects of performance how fast and how much are completely separate, and sometimes even at odds with each other. In
order to achieve higher scalability or better hardware utilization, we often end up increasing the amount of work done to process each
individual task, such as when we divide tasks into multiple "pipelined" subtasks. Ironically, many of the tricks that improve performance in
single-threaded programs are bad for scalability (see Section 11.4.4 for an example).

Avoid premature optimization. First make it right, then make it fast if it is not already fast enough.

Why are we recommending such a conservative approach to optimization? The quest for performance is probably the single greatest source of
concurrency bugs. The belief that synchronization was "too slow" led to many clever-looking but dangerous idioms for reducing
synchronization (such as double-checked locking, discussed in Section 16.2.4), and is often cited as an excuse for not following the rules
regarding synchronization.

Worse, when you trade safety for performance, you may get neither. Especially when it comes to concurrency, the intuition of many
developers about where a performance problem lies or which approach will be faster or more scalable is often incorrect. It is therefore
imperative that any performance tuning exercise be accompanied by concrete performance requirements (so you know both when to
tune and when to stop tuning) and with a measurement program in place using a realistic configuration and load profile. Measure again
after tuning to verify that you've achieved the desired improvements.

Measure, don't guess.

The difference in throughput comes from differing degrees of serialization between the two queue implementations. The synchronized
LinkedList guards the entire queue state with a single lock that is held for the duration of theo ffer or remove call; ConcurrentLinkedQueue
uses a sophisticated nonblocking queue algorithm (see Section 15.4.2) that uses atomic references to update individual link pointers. In
one, the entire insertion or removal is serialized; in the other, only updates to individual pointers are serialized.

Context switches are not free; thread scheduling requires manipulating shared data structures in the OS and JVM. The OS and JVMuse
the same CPUs your program does; more CPU time spent in JVM and OS code means less is available for your program. But OS and
JVM activity is not the only cost of context switches. When a new thread is switched in, the data it needs is unlikely to be in the local
processor cache, so a context switch causes a flurry of cache misses, and thus threads run a little more slowly when they are first
scheduled. This is one of the reasons that schedulers give each runnable thread a certain minimum time quantum even when many
other threads are waiting: it amortizes the cost of the context switch and its consequences over more uninterrupted execution time,
improving overall throughput (at some cost to responsiveness).

The performance cost of synchronization comes from several sources. The visibility guarantees provided by synchronized and volatile
may entail using special instructions called memory barriers that can flush or invalidate caches, flush hardware write buffers, and stall
execution pipelines. Memory barriers may also have indirect performance consequences because they inhibit other compiler
optimizations; most operations cannot be reordered with memory barriers.

The actual cost of context switching varies across platforms, but a good rule of thumb is that a context switch costs the equivalent of
5,000 to 10,000 clock cycles, or several microseconds on most current processors.

When assessing the performance impact of synchronization, it is important to distinguish between contended and uncontended
synchronization. The synchronized mechanism is optimized for the uncontended case (volatile is always uncontended), and at this
writing, the performance cost of a "fast-path" uncontended synchronization ranges from 20 to 250 clock cycles for most systems. While
this is certainly not zero, the effect of needed, uncontended synchronization is rarely significant in overall application performance, and
the alternative involves compromising safety and potentially signing yourself (or your successor) up for some very painful bug hunting
later.

Modern JVMs can reduce the cost of incidental synchronization by optimizing away locking that can be proven never to contend.

More sophisticated JVMs can use escape analysis to identify when a local object reference is never published to the heap and is
therefore thread-local.

Synchronization by one thread can also affect the performance of other threads. Synchronization creates traffic on the shared memory
bus; this bus has a limited bandwidth and is shared across all processors. If threads must compete for synchronization bandwidth, all
threads using synchronization will suffer.[6]

[6] This aspect is sometimes used to argue against the use of nonblocking algorithms without some sort of backoff,
because under heavy contention, nonblocking algorithms generate more synchronization traffic than lock-based
ones. See Chapter 15.

Uncontended synchronization can be handled entirely within the JVM (Bacon et al., 1998); contended synchronization may
require OS activity, which adds to the cost. When locking is contended, the losing thread(s) must block. The JVM can implement blocking
either via spin-waiting (repeatedly trying to acquire the lock until it succeeds) or by suspending the blocked thread through the operating
system. Which is more efficient depends on the relationship between context switch overhead and the time until the lock becomes
available; spin-waiting is preferable for short waits and suspension is preferable for long waits. Some JVMs choose between the two
adaptively based on profiling data of past wait times, but most just suspend threads waiting for a lock.

The principal threat to scalability in concurrent applications is the exclusive resource lock.

Two factors influence the likelihood of contention for a lock: how often that lock is requested and how long it is held once acquired.[7] If
the product of these factors is sufficiently small, then most attempts to acquire the lock will be uncontended, and lock contention will not
pose a significant scalability impediment. If, however, the lock is in sufficiently high demand, threads will block waiting for it; in the
extreme case, processors will sit idle even though there is plenty of work to do.

[7] This is a corollary of Little's law, a result from queueing theory that says "the average number of customers in a
stable system is equal to their average arrival rate multiplied by their average time in the system".

There are three ways to reduce lock contention:
Reduce the duration for which locks are held;
Reduce the frequency with which locks are requested; or
Replace exclusive locks with coordination mechanisms that permit greater concurrency

An effective way to reduce the likelihood of contention is to hold locks as briefly as possible. This can be done by moving code that
doesn't require the lock out of synchronized blocks, especially for expensive operations and potentially blocking operations such as I/O.
Because AttributeStore has only one state variable, attributes, we can improve it further by the technique of delegating thread safety
(Section 4.3). By replacing attributes with a thread-safe Map (a Hashtable, synchronizedMap, or ConcurrentHashMap), AttributeStore can
delegate all its thread safety obligations to the underlying thread-safe collection.

The other way to reduce the fraction of time that a lock is held (and therefore the likelihood that it will be contended) is to have threads
ask for it less often. This can be accomplished by lock splitting and lock striping, which involve using separate locks to guard multiple
independent state variables previously guarded by a single lock.

Splitting a lock into two offers the greatest possibility for improvement when the lock is experiencing moderate but not heavy contention.
Splitting locks that are experiencing little contention yields little net improvement in performance or throughput, although it might increase
the load threshold at which performance starts to degrade due to contention. Splitting locks experiencing moderate contention
might actually turn them into mostly uncontended locks, which is the most desirable outcome for both performance and
scalability.

Lock splitting can sometimes be extended to partition locking on a variablesized set of independent objects, in which case it is called lock
striping. For example, the implementation of ConcurrentHashMap uses an array of 16 locks, each of which guards 1/16 of the hash
buckets; bucket N is guarded by lock N mod 16. Assuming the hash function provides reasonable spreading characteristics and keys are
accessed uniformly, this should reduce the demand for any given lock by approximately a factor of 16. It is this technique that enables
ConcurrentHashMap to support up to 16 concurrent writers. 

One of the downsides of lock striping is that locking the collection for exclusive access is more difficult and costly than with a single lock.
Usually an operation can be performed by acquiring at most one lock, but occasionally you need to lock the entire collection, as when
ConcurrentHashMap needs to expand the map and rehash the values into a larger set of buckets. This is typically done by acquiring all
of the locks in the stripe set.[10]
[10] The only way to acquire an arbitrary set of intrinsic locks is via recursion.

Lock splitting and lock striping can improve scalability because they enable different threads to operate on different data (or different
portions of the same data structure) without interfering with each other. A program that would benefit from lock splitting necessarily
exhibits contention for a lock more often than for the data guarded by that lock. If a lock guards two independent variablesX and Y,
and thread A wants to access X while B wants to access Y (as would be the case if one thread called addUser while another called
addQuery in ServerStatus), then the two threads are not contending for any data, even though they are contending for a lock.

Lock granularity cannot be reduced when there are variables that are required for every operation. This is yet another area where raw
performance and scalability are often at odds with each other; common optimizations such as caching frequently computed values can
introduce "hot fields" that limit scalability.

Keeping a separate count to speed up operations like size and isEmpty works fine for a single-threaded or fully synchronized
implementation, but makes it much harder to improve the scalability of the implementation because every operation that modifies the
map must now update the shared counter. Even if you use lock striping for the hash chains, synchronizing access to the counter
reintroduces the scalability problems of exclusive locking. What looked like a performance optimizationcaching the results of the size
operation has turned into a scalability liability. In this case, the counter is called a hot field because every mutative operation needs to
access it.

ConcurrentHashMap avoids this problem by having size enumerate the stripes and add up the number of elements in each stripe, instead
of maintaining a global count. To avoid enumerating every element, ConcurrentHashMap maintains a separate count field for each stripe,
also guarded by the stripe lock.[12]
[12] If size is called frequently compared to mutative operations, striped data structures can optimize for this by
caching the collection size in a volatile whenever size is called and invalidating the cache (setting it to -1) whenever
the collection is modified. If the cached value is nonnegative on entry to size, it is accurate and can be returned;
otherwise it is recomputed.

A third technique for mitigating the effect of lock contention is to forego the use of exclusive locks in favor of a more concurrency-friendly
means of managing shared state. These include using the concurrent collections, read-write locks, immutable objects and atomic
variables.

ReadWriteLock (see Chapter 13) enforces a multiple-reader, single-writer locking discipline: more than one reader can access the shared
resource concurrently so long as none of them wants to modify it, but writers must acquire the lock excusively. For read-mostly data
structures, ReadWriteLock can offer greater concurrency than exclusive locking; for read-only data structures, immutability can eliminate
the need for locking entirely.

Atomic variables (see Chapter 15) offer a means of reducing the cost of updating "hot fields" such as statistics counters, sequence
generators, or the reference to the first node in a linked data structure. The atomic variable classes provide very fine-grained (and thereforemore scalable) 
atomic operations on integers or object references, and are implemented using low-level concurrency primitives (such as compare-and-swap)
provided by most modern processors. If your class has a small number of hot fields that do not participate in invariants with other
variables, replacing them with atomic variables may improve scalability. (Changing your algorithm to have fewer hot fields might improve
scalability even more atomic variables reduce the cost of updating hot fields, but they don't eliminate it.)

If the CPUs are asymmetrically utilized (some CPUs are running hot but others are not) your first goal should be to find increased
parallelism in your program. Asymmetric utilization indicates that most of the computation is going on in a small set of threads, and your
application will not be able to take advantage of additional processors.

If the CPUs are not fully utilized, you need to figure out why. There are several likely causes:
1) Insufficent load
2) I/O-bound. You can determine whether an application is disk-bound using iostat or perfmon, and whether it is
bandwidth-limited by monitoring traffic levels on your network.
3) Externally bound. If your application depends on external services such as a database or web service, the
bottleneck may not be in your code. You can test for this by using a profiler or database administration tools to
determine how much time is being spent waiting for answers from the external service.
4) Lock contention. Profiling tools can tell you how much lock contention your application is experiencing and which
locks are "hot". You can often get the same information without a profiler through random sampling, triggering a
few thread dumps and looking for threads contending for locks. If a thread is blocked waiting for a lock, the
appropriate stack frame in the thread dump indicates "waiting to lock monitor . . . " Locks that are mostly
uncontended rarely show up in a thread dump; a heavily contended lock will almost always have at least one
thread waiting to acquire it and so will frequently appear in thread dumps.

If your application is keeping the CPUs sufficiently hot, you can use monitoring tools to infer whether it would benefit from
additional CPUs. A program with only four threads may be able to keep a 4-way system fully utilized, but is unlikely to see a performance
boost if moved to an 8-way system since there would need to be waiting runnable threads to take advantage of the additional
processors. (You may also be able to reconfigure the program to divide its workload over more threads, such as adjusting a thread pool
size.) One of the columns reported by vmstat is the number of threads that are runnable but not currently running because a CPU is not
available; if CPU utilization is high and there are always runnable threads waiting for a CPU, your application would probably benefit
from more processors.

Just Say No to Object Pooling

In fact, allocation in Java is now faster than malloc is in C

Even taking into account its reduced garbage collection overhead, object pooling has been
shown to be a performance loss[14] for all but the most expensive objects (and a serious loss for light- and medium-weight objects) in
single-threaded programs

In concurrent applications, pooling fares even worse. Because blocking a thread due to lock contention is hundreds of times more expensive than an
allocation, even a small amount of pool-induced contention would be a scalability bottleneck. (Even an uncontended synchronization is
usually more expensive than allocating an object.)

Pooling has its uses,[15] but is of limited utility as a performance optimization
[15]In constrained environments, such as some J2ME or RTSJ targets, object pooling may still be required for
effective memory management or to manage responsiveness.

Allocating objects is usually cheaper than synchronizing.

Reducing Context Switch Overhead
Many tasks involve operations that may block; transitioning between the running and blocked states entails a context switch. One
source of blocking in server applications is generating log messages in the course of processing requests;

Most tests of concurrent classes fall into one or both of the classic categories of safety and liveness. In Chapter 1, we defined safety as
"nothing bad ever happens" and liveness as "something good eventually happens".

Related to liveness tests are performance tests. Performance can be measured in a number of ways, including:
Throughput: the rate at which a set of concurrent tasks is completed;
Responsiveness: the delay between a request for and completion of some action (also called latency); or
Scalability: the improvement in throughput (or lack thereof) as more resources (usually CPUs) are made available.

It is tempting to use Thread.getState to verify that the thread is actually blocked on a condition wait, but this approach is not reliable.
There is nothing that requires a blocked thread ever to enter the WAITING or TIMED_WAITING states, since the JVM can choose to
implement blocking by spin-waiting instead. Similarly, because spurious wakeups from Object.wait or Condition.await are permitted (see
Chapter 14), a thread in the WAITING or TIMED_WAITING state may temporarily transition to RUNNABLE even if the condition for which it
is waiting is not yet true. Even ignoring these implementation options, it may take some time for the target thread to settle into a blocking
state. The result of Thread.getState should not be used for concurrency control, and is of limited usefulness for testing its primary utility is
as a source of debugging information.

Constructing tests to disclose safety errors in concurrent classes is a chicken-and-egg problem: the test programs themselves are
concurrent programs. Developing good concurrent tests can be more difficult than developing the classes they test.

The challenge to constructing effective safety tests for concurrent classes is identifying easily checked properties that
will, with high probability, fail if something goes wrong, while at the same time not letting the failure auditing code limit
concurrency artificially. It is best if checking the test property does not require any synchronization

One approach that works well with classes used in producer-consumer designs (like BoundedBuffer) is to check that everything put into a
queue or buffer comes out of it, and that nothing else does. A naive implementation of this approach would insert the element into a
"shadow" list when it is put on the queue, remove it from the list when it is removed from the queue, and assert that the shadow list is
empty when the test has finished. But this approach would distort the scheduling of the test threads because modifying the shadow list
would require synchronization and possibly blocking.

A better approach is to compute checksums of the elements that are enqueued and dequeued using an order-sensitive checksum
function, and compare them. If they match, the test passes. This approach works best when there is a single producer putting elements
into the buffer and a single consumer taking them out, because it can test not only that the right elements (probably) came out but that
they came out in the right order.

To ensure that your test actually tests what you think it does, it is important that the checksums themselves not be guessable by the
compiler. It would be a bad idea to use consecutive integers as your test data because then the result would always be the same, and a
smart compiler could conceivably just precompute it.

To avoid this problem, test data should be generated randomly, but many otherwise effective tests are compromised by a poor choice of
random number generator (RNG). Random number generation can create couplings between classes and timing artifacts because most
random number generator classes are threadsafe and therefore introduce additional synchronization.[4] 
Giving each thread its own RNG allows a non-thread-safe RNG to be used.

Rather than using a general-purpose RNG, it is better to use simple pseudorandom functions. You don't need high-quality randomness;
all you need is enough randomness to ensure the numbers change from run to run. The xor-Shift function in Listing 12.4 (Marsaglia,
2003) is among the cheapest mediumquality random number functions. Starting it off with values based on hashCode and nanoTime
makes the sums both unguessable and almost always different for each run.

Listing 12.4. Medium-quality Random Number Generator Suitable for Testing.
static int xorShift(int y) {
    y ^= (y << 6);
    y ^= (y >>> 21);
    y ^= (y << 7);
    return y;
}

int seed = (this.hashCode() ^ (int)System.nanoTime());
seed = xorShift(seed);

Tests should be run on multiprocessor systems to increase the diversity of potential interleavings. However, having
more than a few CPUs does not necessarily make tests more effective. To maximize the chance of detecting
timing-sensitive data races, there should be more active threads than CPUs, so that at any given time some threads
are running and some are switched out, thus reducing the predicatability of interactions between threads.

The tests so far have been concerned with a class's adherence to its specification that it does what it is supposed to do. A secondary
aspect to test is that it does not do things it is not supposed to do, such as leak resources. Any object that holds or manages other
objects should not continue to maintain references to those objects longer than necessary. Such storage leaks prevent garbage
collectors from reclaiming memory (or threads, file handles, sockets, database connections, or other limited resources) and can lead to
resource exhaustion and application failure.

[5] Technically, it is impossible to force a garbage collection; System.gc only suggests to the JVM that this might be a
good time to perform a garbage collection. HotSpot can be instructed to ignore System.gc calls with -XX:+DisableExplicitGC.

Listing 12.8. Thread Factory for Testing THReadPoolExecutor.

class TestingThreadFactory implements ThreadFactory {
    public final AtomicInteger numCreated = new AtomicInteger();
    private final ThreadFactory factory = Executors.defaultThreadFactory();
    public Thread newThread(Runnable r) {
        numCreated.incrementAndGet();
        return factory.newThread(r);
    }
}

A useful trick for increasing the number of interleavings, and therefore more effectively exploring the state space of your programs, is to
use THRead.yield to encourage more context switches during operations that access shared state. (The effectiveness of this technique
is platform-specific, since the JVM is free to treat THRead.yield as a no-op [JLS 17.9]; using a short but nonzero sleep would be slower
but more reliable.)

By sometimes yielding in the middle of an operation, you may activate
timing-sensitive bugs in code that does not use adequate synchronization to access state. The inconvenience of adding these calls for
testing and removing them for production can be reduced by adding them using aspect-oriented programming (AOP) tools.

This test suggests that LinkedBlockingQueue scales better than ArrayBlockingQueue. This may seem odd at first: a
linked queue must allocate a link node object for each insertion, and hence seems to be doing more work than the array-based queue.
However, even though it has more allocation and GC overhead, a linked queue allows more concurrent access by puts and takes
than an array-based queue because the best linked queue algorithms allow the head and tail to be updated independently. Because
allocation is usually threadlocal, algorithms that can reduce contention by doing more allocation usually scale better. (This is another
instance in which intuition based on traditional performance tuning runs counter to what is needed for scalability.)

So far we have focused on measuring throughput, which is usually the most important performance metric for concurrent programs. But
sometimes it is more important to know how long an individual action might take to complete, and in this case we want to measure the
variance of service time. Sometimes it makes sense to allow a longer average service time if it lets us obtain a smaller variance;
predictability is a valuable performance characteristic too. Measuring variance allows us to estimate the answers to quality-of-service
questions like "What percentage of operations will succeed in under 100 milliseconds?"

Sometimes it makes sense to allow a longer average service time if it lets us obtain a smaller variance;
predictability is a valuable performance characteristic too.

the cost of fairness results primarily from blocking threads

So, unless threads are continually blocking anyway because of tight synchronization requirements, nonfair semaphores provide much
better throughput and fair semaphores provides lower variance. Because the results are so dramatically different, Semaphore forces its
clients to decide which of the two factors to optimize for.

In theory, developing performance tests is easy find a typical usage scenario, write a program that executes that scenario many times,
and time it. In practice, you have to watch out for a number of coding pitfalls that prevent performance tests from yielding meaningful
results.
1. Garbage Collection
2. Dynamic Compilation
3. Unrealistic Sampling of Code Paths
4. Unrealistic Degrees of Contention
5. Dead Code Elimination

There are two strategies for preventing garbage collection from biasing your results. One is to ensure that garbage collection does not run
at all during your test (you can invoke the JVM with -verbose:gc to find out); alternatively, you can make sure that the garbage collector
runs a number of times during your run so that the test program adequately reflects the cost of ongoing allocation and garbage collection.
The latter strategy is often better it requires a longer test and is more likely to reflect real-world performance.

Writing and interpreting performance benchmarks for dynamically compiled languages like Java is far more difficult than for statically
compiled languages like C or C++. The HotSpot JVM (and other modern JVMs) uses a combination of bytecode interpretation and
dynamic compilation. When a class is first loaded, the JVM executes it by interpreting the bytecode. At some point, if a method is run often
enough, the dynamic compiler kicks in and converts it to machine code; when compilation completes, it switches from interpretation to
direct execution

The point at which compilation runs seriously affects the measured per-operation runtime.

One way to to prevent compilation from biasing your results is to run your program for a long time (at least several minutes) so that
compilation and interpreted execution represent a small fraction of the total run time. Another approach is to use an unmeasured
"warm-up" run, in which your code is executed enough to be fully compiled when you actually start timing. On HotSpot, running your
program with -XX:+PrintCompilation prints out a message when dynamic compilation runs, so you can verify that this is prior to,
rather than during, measured test runs.

Running the same test several times in the same JVM instance can be used to validate the testing methodology. The first group of results
should be discarded as warm-up; seeing inconsistent results in the remaining groups suggests that the test should be examined further to
determine why the timing results are not repeatable

The JVM uses various background threads for housekeeping tasks. When measuring multiple unrelated computationally intensive
activities in a single run, it is a good idea to place explicit pauses between the measured trials to give the JVM a chance to catch up with
background tasks with minimal interference from measured tasks. (When measuring multiple related activities, however, such as multiple
runs of the same test, excluding JVM background tasks in this way may give unrealistically optimistic results.)

Runtime compilers use profiling information to help optimize the code being compiled. The JVM is permitted to use information specific to
the execution in order to produce better code, which means that compiling method M in one program may generate different code than
compiling M in another. In some cases, the JVM may make optimizations based on assumptions that may only be true temporarily, and
later back them out by invalidating the compiled code if they become untrue.[8]
[8] For example, the JVM can use monomorphic call transformation to convert a virtual method call to a direct
method call if no classes currently loaded override that method, but it invalidates the compiled code if a class is
subsequently loaded that overrides the method.

As a result, it is important that your test programs not only adequately approximate the usage patterns of a typical application, but also
approximate the set of code paths used by such an application. Otherwise, a dynamic compiler could make special optimizations to a purely single-threaded test program that could not be applied in real applications containing at least occasional parallelism.

If N threads are fetching tasks from a shared work queue and executing them, and the tasks are compute-intensive and long-running (and
do not access shared data very much), there will be almost no contention; throughput is dominated by the availability of CPU resources.
On the other hand, if the tasks are very short-lived, there will be a lot of contention for the work queue and throughput is dominated by the
cost of synchronization.

To obtain realistic results, concurrent performance tests should try to approximate the thread-local computation done by a typical
application in addition to the concurrent coordination under study. If the the work done for each task in an application is significantly
different in nature or scope from the test program, it is easy to arrive at unwarranted conclusions about where the performance bottlenecks
lie.

One of the challenges of writing good benchmarks (in any language) is that optimizing compilers are adept at spotting and eliminating
dead code code that has no effect on the outcome. Since benchmarks often don't compute anything, they are an easy target for the
optimizer. Most of the time, it is a good thing when the optimizer prunes dead code from a program, but for a benchmark this is a big
problem because then you are measuring less execution than you think.

Many microbenchmarks perform much "better" when run with HotSpot's -server compiler than with -client, not just because the server
compiler can produce more efficient code, but also because it is more adept at optimizing dead code. Unfortunately, the dead-code
elimination that made such short work of your benchmark won't do quite as well with code that actually does something. But you should still
prefer -server to -client for both production and testing on multiprocessor systems you just have to write your tests so that they are not
susceptible to dead-code elimination.

Writing effective performance tests requires tricking the optimizer into not optimizing away your benchmark as dead
code. This requires every computed result to be used somehow by your programin a way that does not require
synchronization or substantial computation.

A cheap trick for preventing a calculation from being optimized away without introducing too much overhead is to compute the hashCode
of the field of some derived object, compare it to an arbitrary value such as the current value of System. nanoTime, and print a useless
and ignorable message if they happen to match:
if (foo.x.hashCode() == System.nanoTime())
System.out.print(" ");

The comparison will rarely succeed, and if it does, its only effect will be to insert a harmless space character into the output. (The print
method buffers output until println is called, so in the rare case that hashCode and System.nanoTime are equal no I/O is actually
performed.)

Not only should every computed result be used, but results should also be unguessable. Otherwise, a smart dynamic optimizing compiler
is allowed to replace actions with precomputed results.

Testing is critically important for building confidence that concurrent classes behave correctly, but should be only one
of the QA metholologies you employ.
Different QA methodologies are more effective at finding some types of defects and less effective at finding others. By employing
complementary testing methodologies such as code review and static analysis, you can achieve greater confidence than you could with
any single approach.
1. Code Review
Code review also has other benefits; not only can it find errors, but it often improves the quality of
comments describing the implementation details, thus reducing future maintenence cost and risk.
2. Static Analysis Tools
As of this writing, static analysis tools are rapidly emerging as an effective complement to formal testing and code review. Static code
analysis is the process of analyzing code without executing it, and code auditing tools can analyze classes to look for instances of
common bug patterns. Static analysis tools such as the open-source FindBugs[9] contain bug-pattern detectors for many common coding
errors, many of which can easily be missed by testing or code review.
3. Aspect-oriented Testing Techniques

Inconsistent synchronization. Many objects follow the synchronization policy of guarding all variables with the object's intrinsic lock. If a
field is accessed frequently but not always with the this lock held, this may indicate that the synchronization policy is not being
consistently followed.
Analysis tools must guess at the synchronization policy because Java classes do not have formal concurrency specifications. In the
future, if annotations such as @GuardedBy are standardized, auditing tools could interpret annotations rather than having to guess
at the relationship between variables and locks, thus improving the quality of analysis.

Invoking THRead.run. THRead implements Runnable and therefore has a run method. However, it is almost always a mistake to call
Thread.run directly; usually the programmer meant to call THRead.start.

Unreleased lock. Unlike intrinsic locks, explicit locks (see Chapter 13) are not automatically released when control exits the scope in
which they were acquired. The standard idiom is to release the lock from a finally block; otherwise the lock can remain unreleased in the
event of an Exception.

Empty synchronized block. While empty synchronized blocks do have semantics under the Java Memory Model, they are frequently
used incorrectly, and there are usually better solutions to whatever problem the developer was trying to solve.

Double-checked locking. Double-checked locking is a broken idiom for reducing synchronization overhead in lazy initialization (see
Section 16.2.4) that involves reading a shared mutable field without appropriate synchronization.
The real problem with DCL
But the worst case is actually considerably worse it is possible to see a current value of the reference but stale values
for the object's state, meaning that the object could be seen to be in an invalid or incorrect state.
Subsequent changes in the JMM (Java 5.0 and later) have enabled DCL to work if resource is made volatile, and the performance impact
of this is small since volatile reads are usually only slightly more expensive than nonvolatile reads. However, this is an idiom whose
utility has largely passed the forces that motivated it (slow uncontended synchronization, slow JVM startup) are no longer in play, making
it less effective as an optimization. The lazy initialization holder idiom offers the same benefits and is easier to understand.

Starting a thread from a constructor. Starting a thread from a constructor introduces the risk of subclassing problems, and can allow
the this reference to escape the constructor.

Notification errors. The notify and notifyAll methods indicate that an object's state may have changed in a way that would unblock
threads that are waiting on the associated condition queue. These methods should be called only when the state associated with the
condition queue has changed. A synchronized block that calls notify or notifyAll but does not modify any state is likely to be an error. (See
Chapter 14.)

Condition wait errors. When waiting on a condition queue, Object.wait or Condition. await should be called in a loop, with the
appropriate lock held, after testing some state predicate (see Chapter 14). Calling Object.wait or Condition.await without the lock held, not
in a loop, or without testing some state predicate is almost certainly an error.

Misuse of Lock and Condition. Using a Lock as the lock argument for a synchronized block is likely to be a typo, as is calling
Condition.wait instead of await (though the latter would likely be caught in testing, since it would throw an IllegalMonitorStateException
the first time it was called).

Sleeping or waiting while holding a lock. Calling Thread.sleep with a lock held can prevent other threads from making progress for a
long time and is therefore a potentially serious liveness hazard. Calling Object.wait or Condition.await with two locks held poses a similar
hazard.

Spin loops. Code that does nothing but spin (busy wait) checking a field for an expected value can waste CPU time and, if the
field is not volatile, is not guaranteed to terminate. Latches or condition waits are often a better technique when waiting for a state
transition to occur.

Most commercial profiling tools have some support for threads. They vary in feature set and effectiveness, but can often provide insight
into what your program is doing (although profiling tools are usually intrusive and can substantially affect program timing and behavior).
Many profilers also claim features for identifying which locks are causing contention, but in
practice these features are often a blunter instrument than is desired for analyzing a program's locking behavior.)

The built-in JMX agent also offers some limited features for monitoring thread behavior. The ThreadInfo class includes the thread's
current state and, if the thread is blocked, the lock or condition queue on which it is blocked. If the "thread contention monitoring" feature
is enabled (it is disabled by default because of its performance impact), ThreadInfo also includes the number of times that the thread has
blocked waiting for a lock or notification, and the cumulative amount of time it has spent waiting.

The Lock interface, shown in Listing 13.1, defines a number of abstract locking operations. Unlike intrinsic locking,Lock offers a choice of
unconditional, polled, timed, and interruptible lock acquisition, and all lock and unlock operations are explicit. Lock implementations must
provide the same memory-visibility semantics as intrinsic locks, but can differ in their locking semantics, scheduling algorithms, ordering
guarantees, and performance characteristics.

public interface Lock {
    void lock();
    void lockInterruptibly() throws InterruptedException;
    boolean tryLock();
    boolean tryLock(long timeout, TimeUnit unit) throws InterruptedException;
    void unlock();
    Condition newCondition();
}

ReentrantLock implements Lock, providing the same mutual exclusion and memory-visibility guarantees as synchronized. Acquiring a
ReentrantLock has the same memory semantics as entering a synchronized block, and releasing a ReentrantLock has the same memory
semantics as exiting a synchronized block. (Memory visibility is covered in Section 3.1 and in Chapter 16.) And, like synchronized,
ReentrantLock offers reentrant locking semantics (see Section 2.3.2). ReentrantLock supports all of the lock-acquisition modes defined
by Lock, providing more flexibility for dealing with lock unavailability than does synchronized.

Why create a new locking mechanism that is so similar to intrinsic locking? Intrinsic locking works fine in most situations but has some
functional limitations it is not possible to interrupt a thread waiting to acquire a lock, or to attempt to acquire a lock without being willing to
wait for it forever. Intrinsic locks also must be released in the same block of code in which they are acquired; this simplifies coding and
interacts nicely with exception handling, but makes non-blockstructured locking disciplines impossible. None of these are reasons to
abandon synchronized, but in some cases a more flexible locking mechanism offers better liveness or performance.

Listing 13.2. Guarding Object State Using ReentrantLock.

Lock lock = new ReentrantLock();
...
lock.lock();
try {
    // update object state
    // catch exceptions and restore invariants if necessary
} finally {
    lock.unlock();
}

The timed and polled lock-acqusition modes provided by TRyLock allow more sophisticated error recovery than unconditional
acquisition. With intrinsic locks, a deadlock is fatal the only way to recover is to restart the application, and the only defense is to construct
your program so that inconsistent lock ordering is impossible. Timed and polled locking offer another option: probabalistic deadlock
avoidance.

Using timed or polled lock acquisition (TRyLock) lets you regain control if you cannot acquire all the required locks, release the ones you
did acquire, and try again (or at least log the failure and do something else). Listing 13.3 shows an alternate way of addressing the
dynamic ordering deadlock from Section 10.1.2: use TRyLock to attempt to acquire both locks, but back off and retry if they cannot both
be acquired. The sleep time has a fixed component and a random component to reduce the likelihood of livelock. If the locks cannot be
acquired within the specified time, transferMoney returns a failure status so that the operation can fail gracefully.

Timed locks are also useful in implementing activities that manage a time budget (see Section 6.3.7). When an activity with a time
budget calls a blocking method, it can supply a timeout corresponding to the remaining time in the budget. This lets activities terminate
early if they cannot deliver a result within the desired time. With intrinsic locks, there is no way to cancel a lock acquisition once it is
started, so intrinsic locks put the ability to implement time-budgeted activities at risk.

Listing 13.4. Locking with a Time Budget.
public boolean trySendOnSharedLine(String message, long timeout, TimeUnit unit)
throws InterruptedException {
    long nanosToLock = unit.toNanos(timeout) - estimatedNanosToSend(message);
    if (!lock.tryLock(nanosToLock, NANOSECONDS))
        return false;
    try {
        return sendOnSharedLine(message);
    } finally {
        lock.unlock();
    }
}

The timed TRyLock is also responsive to interruption

With intrinsic locks, acquire-release pairs are block-structured a lock is always released in the same basic block in which it was acquired,
regardless of how control exits the block. Automatic lock release simplifies analysis and prevents potential coding errors, but sometimes
a more flexible locking discipline is needed.

In Chapter 11, we saw how reducing lock granularity can enhance scalability. Lock striping allows different hash chains in a
hash-based collection to use different locks. We can apply a similar principle to reduce locking granularity in a linked list by using a
separate lock for each link node, allowing different threads to operate independently on different portions of the list. The lock for a given
node guards the link pointers and the data stored in that node, so when traversing or modifying the list we must hold the lock on one
node until we acquire the lock on the next node; only then can we release the lock on the first node. An example of this technique, called
hand-over-hand locking or lock coupling, appears in [CPJ 2.5.1.4].

When ReentrantLock was added in Java 5.0, it offered far better contended performance than intrinsic locking. For synchronization
primitives, contended performance is the key to scalability: if more resources are expended on lock management and scheduling, fewer
are available for the application. A better lock implementation makes fewer system calls, forces fewer context switches, and initiates less
memory-synchronization traffic on the shared memory bus, operations that are time-consuming and divert computing resources from the
program.

Java 6 uses an improved algorithm for managing intrinsic locks, similar to that used by ReentrantLock, that closes the scalability gap
considerably.On Java 5.0, ReentrantLock offers considerably better throughput, but on Java 6, the two are quite close

On Java 5.0, the performance of intrinsic locking drops dramatically in going from one thread (no contention) to more than one
thread; the performance of ReentrantLock drops far less, showing its better scalability. But on Java 6, it is a different story intrinsic locks no
longer fall apart under contention, and the two scale fairly similarly.

Performance is a moving target; yesterday's benchmark showing that X is faster than Y may already be out of date today.

The ReentrantLock constructor offers a choice of two fairness options: create a nonfair lock (the default) or a fair lock. Threads acquire a fair
lock in the order in which they requested it, whereas a nonfair lock permits barging: threads requesting a lock can jump ahead of the
queue of waiting threads if the lock happens to be available when it is requested. (Semaphore also offers the choice of fair or nonfair
acquisition ordering.) Nonfair ReentrantLocks do not go out of their way to promote barging they simply don't prevent a thread from barging
if it shows up at the right time. With a fair lock, a newly requesting thread is queued if the lock is held by another thread or if threads are
queued waiting for the lock; with a nonfair lock, the thread is queued only if the lock is currently held.[4]
[4] The polled tryLock always barges, even for fair locks.

Wouldn't we want all locks to be fair? After all, fairness is good and unfairness is bad, right? (Just ask your kids.) When it comes to locking,
though, fairness has a significant performance cost because of the overhead of suspending and resuming threads. In practice, a statistical
fairness guarantee promising that a blocked thread will eventually acquire the lock is often good enough, and is far less expensive to
deliver. Some algorithms rely on fair queueing to ensure their correctness, but these are unusual. In most cases, the performance
benefits of nonfair locks outweigh the benefits of fair queueing

One reason barging locks perform so much better than fair locks under heavy contention is that there can be a significant delay between
when a suspended thread is resumed and when it actually runs. Let's say thread A holds a lock and thread B asks for that lock. Since the
lock is busy, B is suspended. When A releases the lock, B is resumed so it can try again. In the meantime, though, if thread C requests the
lock, there is a good chance that C can acquire the lock, use it, and release it before B even finishes waking up. In this case, everyone
wins: B gets the lock no later than it otherwise would have C, gets it much earlier, and throughput is improved.

Fair locks tend to work best when they are held for a relatively long time or when the mean time between lock requests is relatively long. In
these cases, the condition under which barging provides a throughput advantage when the lock is unheld but a thread is currently waking
up to claim it is less likely to hold.

Intrinsic locks still have significant advantages over explicit locks. The notation is familiar and compact, and many existing programs
already use intrinsic locking and mixing the two could be confusing and error-prone.

ReentrantLock is an advanced tool for situations where intrinsic locking is not practical. Use it if you need its advanced
features: timed, polled, or interruptible lock acquisition, fair queueing, or non-block-structured locking. Otherwise, prefer
synchronized.

Under Java 5.0, intrinsic locking has another advantage over ReentrantLock: tHRead dumps show which call frames acquired which
locks and can detect and identify deadlocked threads. The JVM knows nothing about which threads hold ReentrantLocks and therefore
cannot help in debugging threading problems using ReentrantLock. This disparity is addressed in Java 6 by providing a management
and monitoring interface with which locks can register, enabling locking information for ReentrantLocks to appear in thread dumps and
through other management and debugging interfaces. The availability of this information for debugging is a substantial, if mostly
temporary, advantage for synchronized; locking information in thread dumps has saved many programmers from utter consternation.
The non-block-structured nature of ReentrantLock still means that lock acquisitions cannot be tied to specific stack frames, as they can
with intrinsic locks.

Future performance improvements are likely to favor synchronized over ReentrantLock. Because synchronized is built into the
JVM, it can perform optimizations such as lock elision for thread-confined lock objects and lock coarsening to eliminate synchronization
with intrinsic locks (see Section 11.3.2); doing this with library-based locks seems far less likely. Unless you are deploying on Java 5.0
for the foreseeable future and you have a demonstrated need for ReentrantLock's scalability benefits on that platform, it is not a good
idea to choose ReentrantLock over synchronized for performance reasons.

This is what read-write locks allow: a resource can be accessed by multiple readers or a single writer at a time, but not
both.

ReadWriteLock, shown in Listing 13.6, exposes two Lock objects one for reading and one for writing. To read data guarded by a
ReadWriteLock you must first acquire the read lock, and to modify data guarded by a ReadWriteLock you must first acquire the write lock.
While there may appear to be two separate locks, the read lock and write lock are simply different views of an integrated read-write lock
object.

public interface ReadWriteLock {
    Lock readLock();
    Lock writeLock();
}

Read-write locks are a performance optimization designed to allow greater concurrency in certain situations. In practice, read-write locks
can improve performance for frequently accessed read-mostly data structures on multiprocessor systems; under other conditions they
perform slightly worse than exclusive locks due to their greater complexity. Whether they are an improvement in any given situation
is best determined via profiling

Read-write locks can improve concurrency when locks are typically held for a moderately long time and most operations do not modify the
guarded resources. ReadWriteMap in Listing 13.7 uses a ReentrantReadWriteLock to wrap a Map so that it can be shared safely by
multiple readers and still prevent reader-writer or writer-writer conflicts.[7]
In reality, ConcurrentHashMap's performance is so good that you
would probably use it rather than this approach if all you needed was a concurrent hash-based map, but this technique would be useful if
you want to provide more concurrent access to an alternate Map implementation such as LinkedHashMap.

[7]ReadWriteMap does not implement Map because implementing the view methods such as entrySet and values would be
difficult and the "easy" methods are usually sufficient.

Listing 13.7. Wrapping a Map with a Read-write Lock.
public class ReadWriteMap<K,V> {
    private final Map<K,V> map;
    private final ReadWriteLock lock = new ReentrantReadWriteLock();
    private final Lock r = lock.readLock();
    private final Lock w = lock.writeLock();
    public ReadWriteMap(Map<K,V> map) {
        this.map = map;
    }
    public V put(K key, V value) {
        w.lock();
        try {
        
            return map.put(key, value);
        } finally {
            w.unlock();
        }
    }
    // Do the same for remove(), putAll(), clear()
    public V get(Object key) {
        r.lock();
        try {
            return map.get(key);
        } finally {
            r.unlock();
        }
    }
    // Do the same for other read-only Map methods
}

But if the library classes do not provide the
functionality you need, you can also build your own synchronizers using the low-level mechanisms provided by the language and
libraries, including intrinsic condition queues, explicit Condition objects, and the AbstractQueuedSynchronizer framework. This chapter
explores the various options for implementing state dependence and the rules for using the state dependence mechanisms provided by
the platform.

State-dependent operations that block until the operation can proceed are more convenient and less error-prone than those that simply fail.
The built-in condition queue mechanism enables threads to block until an object has entered a state that allows progress and to wake
blocked threads when they may be able to make further progress.

Listing 14.1. Structure of Blocking State-dependent Actions 
void blockingAction() throws InterruptedException {
    acquire lock on object state
    while (precondition does not hold) {
        release lock
        wait until precondition might hold
        optionally fail if interrupted or timeout expires
        reacquire lock
    }
    perform action
}

State dependent operations can deal with precondition failure by throwing an exception or returning an error status (making it the caller's
problem), or by blocking until the object transitions to the right state.

The simplification in implementing the buffer (forcing the caller to manage the state dependence) is more than made up for by the
substantial complication in using it, since now the caller must be prepared to catch exceptions and possibly retry for every buffer
operation

Somewhere between busy waiting and sleeping would be calling Thread.yield in each iteration, which is a hint
to the scheduler that this would be a reasonable time to let another thread run. If you are waiting for another thread to do something, that
something might happen faster if you yield the processor rather than consuming your full scheduling quantum.
    
Condition queues are like the "toast is ready" bell on your toaster. If you are listening for it, you are notified promptly when your toast is
ready and can drop what you are doing (or not, maybe you want to finish the newspaper first) and get your toast. If you are
not listening for it (perhaps you went outside to get the newspaper), you could miss the notification, but on return to the kitchen you can
observe the state of the toaster and either retrieve the toast if it is finished or start listening for the bell again if it is not.

A condition queue gets its name because it gives a group of threads called the wait set away to wait for a specific condition to become true.
Unlike typical queues in which the elements are data items, the elements of a condition queue are the threads waiting for the condition.

Just as each Java object can act as a lock, each object can also act as a condition queue, and the wait, notify, and notifyAll methods in
Object constitute the API for intrinsic condition queues. An object's intrinsic lock and its intrinsic condition queue are related: in order to call
any of the condition queue methods on object X, you must hold the lock on X. This is because the mechanism for waiting for state-based
conditions is necessarily tightly bound to the mechanism for preserving state consistency: you cannot wait for a condition unless you can
examine the state, and you cannot release another thread from a condition wait unless you can modify the state.

Object.wait atomically releases the lock and asks the OS to suspend the current thread, allowing other threads to acquire the lock and
therefore modify the object state. Upon waking, it reacquires the lock before returning. Intuitively, calling wait means "I want to go to sleep,
but wake me when something interesting happens", and calling the notification methods means "something interesting happened".


@ThreadSafe
public class SleepyBoundedBuffer<V> extends BaseBoundedBuffer<V> {
    public SleepyBoundedBuffer(int size) { super(size); }
    public void put(V v) throws InterruptedException {
        while (true) {
            synchronized (this) {
                if (!isFull()) {
                    doPut(v);
                    return;
                }
            }
            Thread.sleep(SLEEP_GRANULARITY);
        }
    }
    public V take() throws InterruptedException {
        while (true) {
            synchronized (this) {
                if (!isEmpty())
                return doTake();
            }
            Thread.sleep(SLEEP_GRANULARITY);
        }
    }
}

BoundedBuffer in Listing 14.6 implements a bounded buffer using wait and notifyAll. This is simpler than the sleeping version, and is both
more efficient (waking up less frequently if the buffer state does not change) and more responsive (waking up promptly when an interesting
state change happens). This is a big improvement, but note that the introduction of condition queues didn't change the semantics compared
to the sleeping version. It is simply an optimization in several dimensions: CPU efficiency, context-switch overhead, and responsiveness.
Condition queues don't let you do anything you can't do with sleeping and polling[5], 
but they make it a lot easier and more efficient to express and manage state dependence.

Listing 14.6. Bounded Buffer Using Condition Queues.

@ThreadSafe
public class BoundedBuffer<V> extends BaseBoundedBuffer<V> {
    // CONDITION PREDICATE: not-full (!isFull())
    // CONDITION PREDICATE: not-empty (!isEmpty())
    public BoundedBuffer(int size) { super(size); }
    // BLOCKS-UNTIL: not-full
    public synchronized void put(V v) throws InterruptedException {
        while (isFull())
            wait();
        doPut(v);
        notifyAll();
    }
    // BLOCKS-UNTIL: not-empty
    public synchronized V take() throws InterruptedException {
        while (isEmpty())
            wait();
        V v = doTake();
        notifyAll();
        return v;
    }
}

Condition queues make it easier to build efficient and responsive state-dependent classes, but they are still easy to use incorrectly; there
are a lot of rules regarding their proper use that are not enforced by the compiler or platform. (This is one of the reasons to build on top
of classes like LinkedBlockingQueue, CountDown-Latch, Semaphore, and FutureTask when you can; if you can get away with it, it is a lot
easier.)

1. The Condition Predicate
The key to using condition queues correctly is identifying the condition predicates that the object may wait for. It is the condition
predicate that causes much of the confusion surrounding wait and notify, because it has no instantiation in the API and nothing in either
the language specification or the JVM implementation ensures its correct use. In fact, it is not mentioned directly at all in the language
specification or the Javadoc. But without it, condition waits would not work.

Document the condition predicate(s) associated with a condition queue and the operations that wait on them.

There is an important three-way relationship in a condition wait involving locking, the wait method, and a condition predicate. The
condition predicate involves state variables, and the state variables are guarded by a lock, so before testing the condition predicate, we
must hold that lock. The lock object and the condition queue object (the object on which wait and notify are invoked) must also be the
same object.

Every call to wait is implicitly associated with a specific condition predicate. When calling wait regarding a particular
condition predicate, the caller must already hold the lock associated with the condition queue, and that lock must also
guard the state variables from which the condition predicate is composed.

2. Waking Up Too Soon

A single intrinsic condition queue may be used with more than one condition predicate. When your thread is awakened because
someone called notifyAll, that doesn't mean that the condition predicate you were waiting for is now true. (This is like having your toaster
and coffee maker share a single bell; when it rings, you still have to look to see which device raised the signal.)[7]
Additionally, wait is even allowed to return "spuriously"not in response to any thread calling notify.[8]

When control re-enters the code calling wait, it has reacquired the lock associated with the condition queue. Is the condition predicate
now true? Maybe. It might have been true at the time the notifying thread called notifyAll, but could have become false again by the time
you reacquire the lock. Other threads may have acquired the lock and changed the object's state between when your thread was
awakened and when wait reacquired the lock. Or maybe it hasn't been true at all since you called wait. You don't know why another
thread called notify or notifyAll; maybe it was because another condition predicate associated with the same condition queue became
true.

For all these reasons, when you wake up from wait you must test the condition predicate again, and go back to waiting (or fail) if it is not
yet true. Since you can wake up repeatedly without your condition predicate being true, you must therefore always call wait from within a
loop, testing the condition predicate in each iteration. The canonical form for a condition wait is shown in Listing 14.7.

Listing 14.7. Canonical Form for State-dependent Methods.
void stateDependentMethod() throws InterruptedException {
    // condition predicate must be guarded by lock
    synchronized(lock) {
        while (!conditionPredicate())
        lock.wait();
        // object is now in desired state
    }
}

When using condition waits (Object.wait or Condition.await):
    Always have a condition predicate some test of object state that must hold before proceeding;
    Always test the condition predicate before calling wait, and again after returning from wait;
    Always call wait in a loop;
    Ensure that the state variables making up the condition predicate are guarded by the lock associated with
    the condition queue;
    Hold the lock associated with the the condition queue when calling wait, notify, or notifyAll; and
    Do not release the lock after checking the condition predicate but before acting on it.

3. Missed Signals

A missed signal
occurs when a thread must wait for a specific condition that is already true, but fails to check the condition predicate before waiting. Now
the thread is waiting to be notified of an event that has already occurred. This is like starting the toast, going out to get the newspaper,
having the bell go off while you are outside, and then sitting down at the kitchen table waiting for the toast bell. You could wait a long
time potentially forever.[10]
Unlike the marmalade for your toast, notification is not "sticky" if threadA notifies on a condition queue and
thread B subsequently waits on that same condition queue, B does not immediately wake up another notification is required to wake B.
Missed signals are the result of coding errors like those warned against in the list above, such as failing to test the condition predicate
before calling wait. If you structure your condition waits as inL isting 14.7, you will not have problems with missed signals.
[10] In order to emerge from this wait, someone else would have to make toast, but this will just make matters
worse; when the bell rings, you will then have a disagreement about toast ownership.

4. Notification

Whenever you wait on a condition, make sure that someone will perform a notification whenever the condition
predicate becomes true.

There are two notification methods in the condition queue API notify and notifyAll. To call either, you must hold the lock associated with
the condition queue object. Calling notify causes the JVM to select one thread waiting on that condition queue to wake up; calling notifyAll
wakes up all the threads waiting on that condition queue. Because you must hold the lock on the condition queue object when calling
notify or notifyAll, and waiting threads cannot return from wait without reacquiring the lock, the notifying thread should release the lock
quickly to ensure that the waiting threads are unblocked as soon as possible.

Because multiple threads could be waiting on the same condition queue for different condition predicates, using notify instead of notifyAll
can be dangerous, primarily because single notification is prone to a problem akin to missed signals.

BoundedBuffer provides a good illustration of why notifyAll should be preferred to single notify in most cases. The condition queue is used
for two different condition predicates: "not full" and "not empty". Suppose thread A waits on a condition queue for predicate PA, while
thread B waits on the same condition queue for predicate PB. Now, suppose PB becomes true and thread C performs a single notify: the
JVM will wake up one thread of its own choosing. If A is chosen, it will wake up, see that PA is not yet true, and go back to waiting.
Meanwhile, B, which could now make progress, does not wake up. This is not exactly a missed signal it's more of a "hijacked signal"but
the problem is the same: a thread is waiting for a signal that has (or should have) already occurred.

Single notify can be used instead of notifyAll only when both of the following conditions hold:
    Uniform waiters. Only one condition predicate is associated with the condition queue, and each
    thread executes the same logic upon returning from wait; and
    One-in, one-out. A notification on the condition variable enables at most one thread to proceed.

Most classes don't meet these requirements, so the prevailing wisdom is to use notifyAll in preference to single notify. While this may be
inefficient, it is much easier to ensure that your classes behave correctly when using notifyAll instead of notify.

This "prevailing wisdom" makes some people uncomfortable, and for good reason. Using notifyAll when only one thread can make
progress is inefficient, sometimes a little, sometimes grossly so. If ten threads are waiting on a condition queue, calling notifyAll causes
each of them to wake up and contend for the lock; then most or all of them will go right back to sleep. This means a lot of context
switches and a lot of contended lock acquisitions for each event that enables (maybe) a single thread to make progress. (In the worst
case, using notify-All results in O(n2) wakeups where n would suffice.) This is another situation where performance concerns support one
approach and safety concerns support the other.

The notification done by put and take in BoundedBuffer is conservative: a notification is performed every time an object is put into or
removed from the buffer. This could be optimized by observing that a thread can be released from a wait only if the buffer goes from
empty to not empty or from full to not full, and notifying only if a put or take effected one of these state transitions. This is called
conditional notification. While conditional notification can improve performance, it is tricky to get right (and also complicates the
implementation of subclasses) and so should be used carefully. Listing 14.8 illustrates using conditional notification in BoundedBuffer.put.

Listing 14.8. Using Conditional Notification in BoundedBuffer.put.

public synchronized void put(V v) throws InterruptedException {
    while (isFull())
        wait();
    boolean wasEmpty = isEmpty();
    doPut(v);
    if (wasEmpty)
        notifyAll();
}

Single notification and conditional notification are optimizations. As always, follow the principle "First make it right, and then make it fast if
it is not already fast enough" when using these optimizations; it is easy to introduce strange liveness failures by applying them
incorrectly.

Using conditional or single notification introduces constraints that can complicate subclassing [CPJ 3.3.3.3]. If you want to support
subclassing at all, you must structure your class so subclasses can add the appropriate notification on behalf of the base class if it is
subclassed in a way that violates one of the requirements for single or conditional notification.

A state-dependent class should either fully expose (and document) its waiting and notification protocols to subclasses, or prevent
subclasses from participating in them at all. (This is an extension of "design and document for inheritance, or else prohibit it" [EJ Item
15].) At the very least, designing a state-dependent class for inheritance requires exposing the condition queues and locks and
documenting the condition predicates and synchronization policy; it may also require exposing the underlying state variables. (The worst
thing a state-dependent class can do is expose its state to subclasses but not document its protocols for waiting and notification; this is
like a class exposing its state variables but not documenting its invariants.)

One option for doing this is to effectively prohibit subclassing, either by making the class final or by hiding the condition queues, locks,
and state variables from subclasses. Otherwise, if the subclass does something to undermine the way the base class uses notify, it
needs to be able to repair the damage.

It is generally best to encapsulate the condition queue so that it is not accessible outside the class hierarchy in which it is used.
Otherwise, callers might be tempted to think they understand your protocols for waiting and notification and use them in a manner
inconsistent with your design. (It is impossible to enforce the uniform waiters requirement for single notification unless the condition
queue object is inaccessible to code you do not control; if alien code mistakenly waits on your condition queue, this could subvert your
notification protocol and cause a hijacked signal.)

Unfortunately, this advice to encapsulate objects used as condition queues is not consistent with the most common design pattern for
thread-safe classes, in which an object's intrinsic lock is used to guard its state. BoundedBuffer illustrates this common idiom, where the
buffer object itself is the lock and condition queue. However, BoundedBuffer could be easily restructured to use a private lock object and
condition queue; the only difference would be that it would no longer support any form of client-side locking.

Wellings (Wellings, 2004) characterizes the proper use of wait and notify in terms of entry and exit protocols. For each state-dependent
operation and for each operation that modifies state on which another operation has a state dependency, you should define and
document an entry and exit protocol. The entry protocol is the operation's condition predicate; the exit protocol involves examining any
state variables that have been changed by the operation to see if they might have caused some other condition predicate to become
true, and if so, notifying on the associated condition queue.

AbstractQueuedSynchronizer, upon which most of the state-dependent classes in java.util.concurrent are built (see Section 14.4), exploits
the concept of exit protocol. Rather than letting synchronizer classes perform their own notification, it instead requires synchronizer
methods to return a value indicating whether its action might have unblocked one or more waiting threads. This explicit API requirement
makes it harder to "forget" to notify on some state transitions.

Just as Lock is a generalization of intrinsic locks, Condition (see Listing 14.10) is a generalization of intrinsic condition queues.

Intrinsic condition queues have several drawbacks. Each intrinsic lock can have only one associated condition queue, which
means that in classes like BoundedBuffer multiple threads might wait on the same condition queue for different condition predicates, and
the most common pattern for locking involves exposing the condition queue object. Both of these factors make it impossible to enforce
the uniform waiter requirement for using notifyAll. If you want to write a concurrent object with multiple condition predicates, or you want
to exercise more control over the visibility of the condition queue, the explicit Lock and Condition classes offer a more flexible alternative
to intrinsic locks and condition queues.

A Condition is associated with a single Lock, just as a condition queue is associated with a single intrinsic lock; to create Ca ondition, call
Lock.newCondition on the associated lock. And just as Lock offers a richer feature set than intrinsic locking, Condition offers a richer
feature set than intrinsic condition queues: multiple wait sets per lock, interruptible and uninterruptible condition waits, deadline-based
waiting, and a choice of fair or nonfair queueing.

Listing 14.10. Condition Interface.

public interface Condition {
    void await() throws InterruptedException;
    boolean await(long time, TimeUnit unit)
    throws InterruptedException;
    long awaitNanos(long nanosTimeout) throws InterruptedException;
    void awaitUninterruptibly();
    boolean awaitUntil(Date deadline) throws InterruptedException;
    void signal();
    void signalAll();
}

Listing 14.11. Bounded Buffer Using Explicit Condition Variables.
@ThreadSafe
public class ConditionBoundedBuffer<T> {
    protected final Lock lock = new ReentrantLock();
    // CONDITION PREDICATE: notFull (count < items.length)
    private final Condition notFull = lock.newCondition();
    // CONDITION PREDICATE: notEmpty (count > 0)
    private final Condition notEmpty = lock.newCondition();
    @GuardedBy("lock")
    private final T[] items = (T[]) new Object[BUFFER_SIZE];
    @GuardedBy("lock") private int tail, head, count;
    // BLOCKS-UNTIL: notFull
    public void put(T x) throws InterruptedException {
        lock.lock();
        try {
            while (count == items.length)
                notFull.await();
            items[tail] = x;
            if (++tail == items.length)
            tail = 0;
            ++count;
            notEmpty.signal();
        } finally {
            lock.unlock();
        }
    }
    // BLOCKS-UNTIL: notEmpty
    public T take() throws InterruptedException {
        lock.lock();
        try {
            while (count == 0)
                notEmpty.await();
            T x = items[head];
            items[head] = null;
            if (++head == items.length)
            head = 0;
            --count;
            notFull.signal();
            return x;
        } finally {
            lock.unlock();
        }
    }
}


Unlike intrinsic condition queues, you can have as many Condition objects per Lock as you want. Condition objects inherit the fairness
setting of their associated Lock; for fair locks, threads are released from Condition.await in FIFO order.

Hazard warning: The equivalents of wait, notify, and notifyAll for Condition objects are await, signal, and signalAll.
However, Condition extends Object, which means that it also has wait and notify methods. Be sure to use the proper
versions await and signal instead!

Just as with built-in locks and condition queues, the three-way relationship among the lock, the condition predicate, and the condition
variable must also hold when using explicit Locks and Conditions. The variables involved in the condition predicate must be guarded by
the Lock, and the Lock must be held when testing the condition predicate and when calling await and signal.

Choose between using explicit Conditions and intrinsic condition queues in the same way as you would choose betweenR eentrantLock
and synchronized: use Condition if you need its advanced features such as fair queueing or multiple wait sets per lock, and otherwise
prefer intrinsic condition queues. (If you already use ReentrantLock because you need its advanced features, the choice is already
made.)

In actuality, they are both (ReentrantLock and Semaphore) implemented using a common base class, Abstract-QueuedSynchronizer (AQS)as are many other
synchronizers. AQS is a framework for building locks and synchronizers, and a surprisingly broad range of synchronizers can be built
easily and efficiently using it. Not only are ReentrantLock and Semaphore built using AQS, but so are CountDownLatch,
ReentrantReadWriteLock, SynchronousQueue,[12] and FutureTask.
[12] Java6 replaces the AQS-based SynchronousQueue with a (more scalable) nonblocking version.

Using AQS to build synchronizers offers several benefits. Not only does it substantially reduce the implementation effort, but you also
needn't pay for multiple points of contention, as you would when constructing one synchronizer on top of another. In SemaphoreOnLock,
acquiring a permit has two places where it might block once at the lock guarding the semaphore state, and then again if a permit is not
available. Synchronizers built with AQS have only one point where they might block, reducing context-switch overhead and improving
throughput. AQS was designed for scalability, and all the synchronizers in java.util.concurrent that are built with AQS benefit from this.

A synchronizer supporting exclusive acquisition should implement the protected methods TRyAcquire, TRyRelease, and
isHeldExclusively, and those supporting shared acquisition should implement tryAcquireShared and TRyReleaseShared. The acquire,
acquireShared, release, and releaseShared methods in AQS call the TRy forms of these methods in the synchronizer subclass to
determine if the operation can proceed. The synchronizer subclass can use getState, setState, and compareAndSetState to examine and
update the state according to its acquire and release semantics, and informs the base class through the return status whether the
attempt to acquire or release the synchronizer was successful. For example, returning a negative value from TRyAcquireShared
indicates acquisition failure; returning zero indicates the synchronizer was acquired exclusively; and returning a positive value indicates
the synchronizer was acquired nonexclusively. The TRyRelease and TRyReleaseShared methods should return true if the release may
have unblocked threads attempting to acquire the synchronizer.
To simplify implementation of locks that support condition queues (like ReentrantLock), AQS also provides machinery for constructing
condition variables associated with synchronizers.

Listing 14.13. Canonical Forms for Acquisition and Release in AQS.
boolean acquire() throws InterruptedException {
    while (state does not permit acquire) {
        if (blocking acquisition requested) {
            enqueue current thread if not already queued
            block current thread
        }
        else
            return failure
    }
    possibly update synchronization state
    dequeue thread if it was queued
    return success
}
void release() {
    update synchronization state
    if (new state may permit a blocked thread to acquire)
        unblock one or more queued threads
}

OneShotLatch in Listing 14.14 is a binary latch implemented using AQS. It has two public methods, await and signal, that correspond to
acquisition and release. Initially, the latch is closed; any thread calling await blocks until the latch is opened. Once the latch is opened by
a call to signal, waiting threads are released and threads that subsequently arrive at the latch will be allowed to proceed.

Listing 14.14. Binary Latch Using AbstractQueuedSynchronizer.
@ThreadSafe
public class OneShotLatch {
    private final Sync sync = new Sync();
    public void signal() { sync.releaseShared(0); }
    public void await() throws InterruptedException {
        sync.acquireSharedInterruptibly(0);
    }
    private class Sync extends AbstractQueuedSynchronizer {
        protected int tryAcquireShared(int ignored) {
            // Succeed if latch is open (state == 1), else fail
            return (getState() == 1) ? 1 : -1;
        }
        protected boolean tryReleaseShared(int ignored) {
            setState(1); // Latch is now open
            return true; // Other threads may now be able to acquire
        }
    }
}

In OneShotLatch, the AQS state holds the latch state closed (zero) or open (one). The await method calls acquireSharedInterruptibly in
AQS, which in turn consults the TRyAcquireShared method in OneShotLatch. The tryAcquire-Shared implementation must return a value
indicating whether or not acquisition can proceed. If the latch has been previously opened, tryAcquireShared returns success, allowing
the thread to pass; otherwise it returns a value indicating that the acquisition attempt failed. The acquireSharedInterruptibly method
interprets failure to mean that the thread should be placed on the queue of waiting threads. Similarly, signal calls releaseShared, which
causes tryReleaseShared to be consulted. The TRyReleaseShared implementation unconditionally sets the latch state to open and
indicates (through its return value) that the synchronizer is in a fully released state. This causes AQS to let all waiting threads attempt
to reacquire the synchronizer, and acquisition will now succeed because tryAcquireShared returns success.

OneShotLatch could have been implemented by extending AQS rather than delegating to it, but this is undesirable for several reasons
[EJ Item 14]. Doing so would undermine the simple (two-method) interface of OneShotLatch, and while the public methods of AQS won't
allow callers to corrupt the latch state, callers could easily use them incorrectly. None of the synchronizers in java.util.concurrent extends
AQS directly they all delegate to private inner subclasses of AQS instead.

Many of the blocking classes in java.util.concurrent, such as ReentrantLock, Semaphore, ReentrantReadWriteLock, CountDownLatch,
SynchronousQueue, and FutureTask, are built using AQS.

FutureTask uses the AQS synchronization state to hold the task status running, completed, or cancelled. It also maintains additional state
variables to hold the result of the computation or the exception it threw. It further maintains a reference to the thread that is running the
computation (if it is currently in the running state), so that it can be interrupted if the task is cancelled.

The interface for ReadWriteLock suggests there are two locks a reader lock and a writer lock but in the AQS-based implementation of
ReentrantReadWriteLock, a single AQS subclass manages both read and write locking. ReentrantRead-WriteLock uses 16 bits of the
state for the write-lock count, and the other 16 bits for the read-lock count. Operations on the read lock use the shared acquire and
release methods; operations on the write lock use the exclusive acquire and release methods.

Internally, AQS maintains a queue of waiting threads, keeping track of whether a thread has requested exclusive or shared access. In
ReentrantRead-WriteLock, when the lock becomes available, if the thread at the head of the queue was looking for write access it will
get it, and if the thread at the head of the queue was looking for read access, all queued threads up to the first writer will get it.[15]
[15] This mechanism does not permit the choice of a reader-preference or writer-preference policy, as some
read-write lock implementations do. For that, either the AQS wait queue would need to be something other than a
FIFO queue, or two queues would be needed. However, such a strict ordering policy is rarely needed in practice; if
the nonfair version of ReentrantReadWriteLock does not offer acceptable liveness, the fair version usually provides
satisfactory ordering and guarantees nonstarvation of readers and writers.

Many of the classes in java.util.concurrent, such as Semaphore and ConcurrentLinkedQueue, provide better
performance and scalability than alternatives using synchronized. In this chapter, we take a look at the primary source of this
performance boost: atomic variables and nonblocking synchronization.

Much of the recent research on concurrent algorithms has focused on nonblocking algorithms, which use low-level atomic machine
instructions such as compare-and-swap instead of locks to ensure data integrity under concurrent access. Nonblocking algorithms are
used extensively in operating systems and JVMs for thread and process scheduling, garbage collection, and to implement locks and
other concurrent data structures.

Nonblocking algorithms are considerably more complicated to design and implement than lock-based alternatives, but they can offer
significant scalability and liveness advantages. They coordinate at a finer level of granularity and can greatly reduce scheduling overhead
because they don't block when multiple threads contend for the same data. Further, they are immune to deadlock and other liveness
problems. In lock-based algorithms, other threads cannot make progress if a thread goes to sleep or spins while holding a lock, whereas
nonblocking algorithms are impervious to individual thread failures. As of Java 5.0, it is possible to build efficient nonblocking algorithms
in Java using the atomic variable classes such as AtomicInteger and AtomicReference.

Atomic variables can also be used as "better volatile variables" even if you are not developing nonblocking algorithms. Atomic variables
offer the same memory semantics as volatile variables, but with additional support for atomic updatesmaking them ideal for counters,
sequence generators, and statistics gathering while offering better scalability than lock-based alternatives.

Volatile variables are a lighter-weight synchronization mechanism than locking because they do not involve context switches or thread
scheduling. However, volatile variables have some limitations compared to locking: while they provide similar visibility guarantees, they
cannot be used to construct atomic compound actions. This means that volatile variables cannot be used when one variable depends on
another, or when the new value of a variable depends on its old value. This limits when volatile variables are appropriate, since they
cannot be used to reliably implement common tools such as counters or mutexes.[2]

Disadvantages of Locking

Modern JVMs can optimize uncontended lock acquisition and release fairly effectively, but if multiple threads request the lock at the
same time the JVM enlists the help of the operating system. If it gets to this point, some unfortunate thread will be suspended and have
to be resumed later.[1]
When that thread is resumed, it may have to wait for other threads to finish their scheduling quanta before it is
actually scheduled. Suspending and resuming a thread has a lot of overhead and generally entails a lengthy interruption. For lock-based
classes with fine-grained operations (such as the synchronized collections classes, where most methods contain only a few operations),
the ratio of scheduling overhead to useful work can be quite high when the lock is frequently contended.

Locking has a few other disadvantages. When a thread is waiting for a lock, it cannot do anything else. If a thread holding a lock is
delayed (due to a page fault, scheduling delay, or the like), then no thread that needs that lock can make progress. This can be a serious
problem if the blocked thread is a high-priority thread but the thread holding the lock is a lower-priority threada performance hazard
known as priority inversion. Even though the higher-priority thread should have precedence, it must wait until the lock is released, and
this effectively downgrades its priority to that of the lower-priority thread. If a thread holding a lock is permanently blocked (due to an
infinite loop, deadlock, livelock, or other liveness failure), any threads waiting for that lock can never make progress.
Even ignoring these hazards, locking is simply a heavyweight mechanism for fine-grained operations such as incrementing a counter. It
would be nice to have a finer-grained technique for managing contention between threads something like volatile variables, but
offering the possibility of atomic updates as well. Happily, modern processors offer us precisely such a mechanism.

Exclusive locking is a pessimistic technique it assumes the worst (if you don't lock your door, gremlins will come in and rearrange your
stuff) and doesn't proceed until you can guarantee, by acquiring the appropriate locks, that other threads will not interfere.

For fine-grained operations, there is an alternate approach that is often more efficient the optimistic approach, whereby you proceed with
an update, hopeful that you can complete it without interference. This approach relies on collision detection to determine if there has
been interference from other parties during the update, in which case the operation fails and can be retried (or not). The optimistic
approach is like the old saying, "It is easier to obtain forgiveness than permission", where "easier" here means "more efficient".

The approach taken by most processor architectures, including IA32 and Sparc, is to implement a compare-and-swap (CAS) instruction.
(Other processors, such as PowerPC, implement the same functionality with a pair of instructions: loadlinked and store-conditional.) CAS
has three operands a memory location V on which to operate, the expected old value A, and the newvalue B. CAS atomically updates V to
the new value B, but only if the value in V matches the expected old value A; otherwise it does nothing. In either case, it returns the value
currently in V. (The variant called compare-and-set instead returns whether the operation succeeded.) CAS means "I think V should have
the value A; if it does, put B there, otherwise don't change it but tell me I was wrong." CAS is an optimistic technique it proceeds with the
update in the hope of success, and can detect failure if another thread has updated the variable since it was last examined.

When multiple threads attempt to update the same variable simultaneously using CAS, one wins and updates the variable's value, and
the rest lose. But the losers are not punished by suspension, as they could be if they failed to acquire a lock; instead, they are told that
they didn't win the race this time but can try again. Because a thread that loses a CAS is not blocked, it can decide whether it wants to
try again, take some other recovery action, or do nothing.[3]
This flexibility eliminates many of the liveness hazards associated with
locking (though in unusual cases can introduce the risk of livelock see Section 10.3.3).
[3] Doing nothing may be a perfectly sensible response to a failed CAS; in some nonblocking algorithms, such as
the linked queue algorithm in Section 15.4.2, a failed CAS means that someone else already did the work you
were planning to do.

The typical pattern for using CAS is first to read the value A from V, derive the new value B from A, and then use CAS to atomically
change V from A to B so long as no other thread has changed V to another value in the meantime. CAS addresses the problem of
implementing atomic read-modify-write sequences without locking, because it can detect interference from other threads.

CasCounter in Listing 15.2 implements a thread-safe counter using CAS. The increment operation follows the canonical form fetch the old
value, transform it to the new value (adding one), and use CAS to set the new value. If the CAS fails, the operation is immediately
retried. Retrying repeatedly is usually a reasonable strategy, although in cases of extreme contention it might be desirable to wait or back
off before retrying to avoid livelock.

Listing 15.2. Nonblocking Counter Using CAS.
@ThreadSafe
public class CasCounter {
    private SimulatedCAS value;
    public int getValue() {
        return value.get();
    }
    public int increment() {
        int v;
        do {
            v = value.get();
        }
        while (v != value.compareAndSwap(v, v + 1));
        return v + 1;
    }
}

At first glance, the CAS-based counter looks as if it should perform worse than a lock-based counter; it has more operations and a more
complicated control flow, and depends on the seemingly complicated CAS operation. But in reality, CAS-based counters significantly
outperform lock-based counters if there is even a small amount of contention, and often even if there is no contention.

The language syntax for locking may be compact, but the work done by the JVM and OS to manage locks is not. Locking entails
traversing a relatively complicated code path in the JVM and may entail OS-level locking, thread suspension, and context switches. In
the best case, locking requires at least one CAS, so using locks moves the CAS out of sight but doesn't save any actual execution cost.
On the other hand, executing a CAS from within the program involves no JVM code, system calls, or scheduling activity. What looks like
a longer code path at the application level is in fact a much shorter code path when JVM and OS activity are taken into account.
The primary disadvantage of CAS is that it forces the caller to deal with contention (by retrying, backing off, or giving up), whereas locks
deal with contention automatically by blocking until the lock is available.[5]
[5] Actually, the biggest disadvantage of CAS is the difficulty of constructing the surrounding algorithms correctly.

A good rule of thumb is that the cost of the "fast path" for uncontended lock acquisition and release on most
processors is approximately twice the cost of a CAS.

So, how does Java code convince the processor to execute a CAS on its behalf? Prior to Java 5.0, there was no way to do this short of
writing native code. In Java 5.0, low-level support was added to expose CAS operations on int, long, and object references, and the JVM
compiles these into the most efficient means provided by the underlying hardware. On platforms supporting CAS, the runtime inlines
them into the appropriate machine instruction(s); in the worst case, if a CAS-like instruction is not available the JVM uses a spin lock.
This low-level JVMsupport is used by the atomic variable classes (AtomicXxx in java.util.concurrent. atomic) to provide an efficient CAS
operation on numeric and reference types; these atomic variable classes are used, directly or indirectly, to implement most of the
classes in java.util.concurrent

Atomic variables are finer-grained and lighter-weight than locks, and are critical for implementing high-performance concurrent code on
multiprocessor systems. Atomic variables limit the scope of contention to a single variable; this is as fine grained as you can get (assuming
your algorithm can even be implemented using such fine granularity). The fast (uncontended) path for updating an atomic variable is no
slower than the fast path for acquiring a lock, and usually faster; the slow path is definitely faster than the slow path for locks because it
does not involve suspending and rescheduling threads. With algorithms based on atomic variables instead of locks, threads are more
likely to be able to proceed without delay and have an easier time recovering if they do experience contention

The atomic variable classes provide a generalization of volatile variables to support atomic conditional read-modify-write operations.
AtomicInteger represents an int value, and provides get and set methods with the same memory semantics as reads and writes to
a volatile int. It also provides an atomic compareAndSet method (which if successful has the memory effects of both reading and writing a
volatile variable) and, for convenience, atomic add, increment, and decrement methods. AtomicInteger bears a superficial resemblance to
an extended Counter class, but offers far greater scalability under contention because it can directly exploit underlying hardware support
for concurrency.

There are twelve atomic variable classes, divided into four groups: scalars, field updaters, arrays, and compound variables. The most
commonly used atomic variables are the scalars: AtomicInteger, AtomicLong, AtomicBoolean, and AtomicReference. All support CAS; the
Integer and Long versions support arithmetic as well. (To simulate atomic variables of other primitive types, you can cast short or byte
values to and from int, and use floatToIntBits or doubleToLongBits for floating-point numbers.)

The atomic array classes (available in Integer, Long, and Reference versions) are arrays whose elements can be updated atomically. The
atomic array classes provide volatile access semantics to the elements of the array, a feature not available for ordinary arrays a volatile
array has volatile semantics only for the array reference, not for its elements.

Performance Comparison: Locks Versus Atomic Variables

With a low level of thread-local
computation, the lock or atomic variable experiences heavy contention; with more thread-local computation, the lock or atomic variable
experiences less contention since it is accessed less often by each thread.

As these graphs show, at high contention levels locking tends to outperform atomic variables, but at more realistic contention levels
atomic variables outperform locks.[6]This is because a lock reacts to contention by suspending threads, reducing CPU usage and
synchronization traffic on the shared memory bus. (This is similar to how blocking producers in a producer-consumer design reduces the
load on consumers and thereby lets them catch up.) On the other hand, with atomic variables, contention management is pushed back to
the calling class. Like most CAS-based algorithms, AtomicPseudoRandom reacts to contention by trying again immediately, which is
usually the right approach but in a high-contention environment just creates more contention.

Before we condemn AtomicPseudoRandom as poorly written or atomic variables as a poor choice compared to locks, we should realize
that the level of contention in Figure 15.1 is unrealistically high: no real program does nothing but contend for a lock or atomic variable. In
practice, atomics tend to scale better than locks because atomics deal more effectively with typical contention levels.

The performance reversal between locks and atomics at differing levels of contention illustrates the strengths and weaknesses of each.
With low to moderate contention, atomics offer better scalability; with high contention, locks offer better contention avoidance. (CAS-based
algorithms also outperform lock-based ones on single-CPU systems, since a CAS always succeeds on a single-CPU system except in the
unlikely case that a thread is preempted in the middle of the read-modify-write operation.)

Figures 15.1 and 15.2 include a third curve; an implementation of PseudoRandom that uses a THReadLocal for the PRNG state. This
implementation approach changes the behavior of the class each thread sees its own private sequence of pseudorandom numbers,
instead of all threads sharing one sequence but illustrates that it is often cheaper to not share state at all if it can be avoided. We can
improve scalability by dealing more effectively with contention, but true scalability is achieved only by eliminating contention entirely.

An algorithm is called nonblocking if failure or suspension of any thread
cannot cause failure or suspension of another thread; an algorithm is called lock-free if, at each step, some thread can make progress.

The key to creating nonblocking algorithms
is figuring out how to limit the scope of atomic changes to a single variable while maintaining data consistency.

Good nonblocking algorithms are known for many
common data structures, including stacks, queues, priority queues, and hash tables though designing new ones is a task best left to
experts.

CasCounter and ConcurrentStack illustrate characteristics of all nonblocking algorithms: some work is done speculatively and may have to
be redone.

Nonblocking algorithms like ConcurrentStack derive their thread safety from the fact that, like locking, compareAndSet provides both
atomicity and visibility guarantees.

Listing 15.6. Nonblocking Stack Using Treiber's Algorithm (Treiber, 1986).

@ThreadSafe
public class ConcurrentStack <E> {
    AtomicReference<Node<E>> top = new AtomicReference<Node<E>>();
    public void push(E item) {
        Node<E> newHead = new Node<E>(item);
        Node<E> oldHead;
        do {
            oldHead = top.get();
            newHead.next = oldHead;
        } while (!top.compareAndSet(oldHead, newHead));
    }
    public E pop() {
        Node<E> oldHead;
        Node<E> newHead;
        do {
            oldHead = top.get();
            if (oldHead == null)
            return null;
            newHead = oldHead.next;
        } while (!top.compareAndSet(oldHead, newHead));
        return oldHead.item;
    }
    private static class Node <E> {
        public final E item;
        public Node<E> next;
        public Node(E item) {
        this.item = item;
    }
}

A linked queue is more complicated than a stack because it must support fast access to both the head and the tail. To do this, it maintains
separate head and tail pointers. Two pointers refer to the node at the tail: the next pointer of the current last element, and the tail
pointer. To insert a new element successfully, both of these pointers must be updated atomically. At first glance, this cannot be done with
atomic variables; separate CAS operations are required to update the two pointers, and if the first succeeds but the second one fails the
queue is left in an inconsistent state. And, even if both operations succeed, another thread could try to access the queue between the first
and the second. Building a nonblocking algorithm for a linked queue requires a plan for both these situations.

We need several tricks to develop this plan. The first is to ensure that the data structure is always in a consistent state, even in the middle
of an multi-step update. That way, if thread A is in the middle of a update when thread B arrives on the scene, B can tell that an operation
has been partially completed and knows not to try immediately to apply its own update. Then B can wait (by repeatedly examining the
queue state) until A finishes, so that the two don't get in each other's way.
While this trick by itself would suffice to let threads "take turns" accessing the data structure without corrupting it, if one thread failed in the
middle of an update, no thread would be able to access the queue at all. To make the algorithm nonblocking, we must ensure that the
failure of a thread does not prevent other threads from making progress. Thus, the second trick is to make sure that if B arrives to find the
data structure in the middle of an update by A, enough information is already embodied in the data structure for B to finish the update for A.
If B "helps" A by finishing A's operation, B can proceed with its own operation without waiting for A. When A gets around to finishing its
operation, it will find that B already did the job for it.

LinkedQueue in Listing 15.7 shows the insertion portion of the Michael-Scott nonblocking linked-queue algorithm (Michael and Scott, 1996),
which is used by ConcurrentLinkedQueue.

The key observation that enables both of the required tricks is that if the queue is in the quiescent state, the next field of the link node
pointed to by tail is null, and if it is in the intermediate state, tail.next is non-null. So any thread can immediately tell the state of the queue by
examining tail.next. Further, if the queue is in the intermediate state, it can be restored to the quiescent state by advancing the tail pointer
forward one node, finishing the operation for whichever thread is in the middle of inserting an element.[7]

Listing 15.7. Insertion in the Michael-Scott Nonblocking Queue Algorithm (Michael and Scott,
1996).
@ThreadSafe
public class LinkedQueue <E> {
    private static class Node <E> {
        final E item;
        final AtomicReference<Node<E>> next;
        public Node(E item, Node<E> next) {
            this.item = item;
            this.next = new AtomicReference<Node<E>>(next);
        }
    }
    private final Node<E> dummy = new Node<E>(null, null);
    private final AtomicReference<Node<E>> head
        = new AtomicReference<Node<E>>(dummy);
    private final AtomicReference<Node<E>> tail
        = new AtomicReference<Node<E>>(dummy);
    public boolean put(E item) {
        Node<E> newNode = new Node<E>(item, null);
        while (true) {
            Node<E> curTail = tail.get();
            Node<E> tailNext = curTail.next.get();
            if (curTail == tail.get()) {
                if (tailNext != null) {                                             // STEP A
                    // Queue in intermediate state, advance tail
                    tail.compareAndSet(curTail, tailNext);                      // STEP B
                } else {
                    // In quiescent state, try inserting new node
                    if (curTail.next.compareAndSet(null, newNode)) {            // STEP C
                        // Insertion succeeded, try advancing tail
                        tail.compareAndSet(curTail, newNode);                   // STEP D
                        return true;
                    }
                }
            }
        }
    }
}

LinkedQueue.put first checks to see if the queue is in the intermediate state before attempting to insert a new element (stepA ). If it is, then
some other thread is already in the process of inserting an element (between its steps C and D). Rather than wait for that thread to finish,
the current thread helps it by finishing the operation for it, advancing the tail pointer (step B). It then repeats this check in case another
thread has started inserting a new element, advancing the tail pointer until it finds the queue in the quiescent state so it can begin its own
insertion.
The CAS at step C, which links the new node at the tail of the queue, could fail if two threads try to insert an element at the same time. In
that case, no harm is done: no changes have been made, and the current thread can just reload the tail pointer and try again. Once C
succeeds, the insertion is considered to have taken effect; the second CAS (step D) is considered "cleanup", since it can be
performed either by the inserting thread or by any other thread. If D fails, the inserting thread returns anyway rather than retrying the CAS,
because no retry is needed another thread has already finished the job in its step B! This works because before any thread tries to link a
new node into the queue, it first checks to see if the queue needs cleaning up by checking if tail.next is non-null. If it is, it advances the tail
pointer first (perhaps multiple times) until the queue is in the quiescent state.

Listing 15.7 illustrates the algorithm used by ConcurrentLinkedQueue, but the actual implementation is a bit different. Instead of
representing each Node with an atomic reference, ConcurrentLinkedQueue uses an ordinary volatile reference and updates it through the
reflection-based AtomicReferenceFieldUpdater, as shown in Listing 15.8.

Listing 15.8. Using Atomic Field Updaters in ConcurrentLinkedQueue.
private class Node<E> {
    private final E item;
    private volatile Node<E> next;
    public Node(E item) {
        this.item = item;
    }
}
private static AtomicReferenceFieldUpdater<Node, Node> nextUpdater
= AtomicReferenceFieldUpdater.newUpdater(Node.class, Node.class, "next");

The atomic field updater classes (available in Integer, Long, and Reference versions) represent a reflection-based "view" of an existing
volatile field so that CAS can be used on existing volatile fields.

The atomicity guarantees for the updater classes are weaker than for
the regular atomic classes because you cannot guarantee that the underlying fields will not be modified directly. the compareAndSet and
arithmetic methods guarantee atomicity only with respect to other threads using the atomic field updater methods.

In ConcurrentLinkedQueue, updates to the next field of a Node are applied using the compareAndSet method of nextUpdater. This
somewhat circuitous approach is used entirely for performance reasons. For frequently allocated, short-lived objects like queue link nodes,
eliminating the creation of an AtomicReference for each Node is significant enough to reduce the cost of insertion operations. However, in
nearly all situations, ordinary atomic variables perform just fine, in only a few cases will the atomic field updaters be needed. (The atomic
field updaters are also useful when you want to perform atomic updates while preserving the serialized form of an existing class.)

The ABA Problem
The ABA problem is an anomaly that can arise from the naive use of compare-and-swap in algorithms where nodes can be recycled
(primarily in environments without garbage collection).
This ABA problem can arise in algorithms that do their own memory management for link node objects.
If you cannot avoid the ABA
problem by letting the garbage collector manage link nodes for you, there is still a relatively simple solution: instead of updating the value
of a reference, update a pair of values, a reference and a version number. Even if the value changes fromA to B and back to A, the version
numbers will be different. AtomicStampedReference (and its cousin AtomicMarkableReference) provide atomic conditional update on a pair
of variables. AtomicStampedReference updates an object reference-integer pair, allowing "versioned" references that are immune[8]
to the
ABA problem. Similarly, AtomicMarkableReference updates an object reference-boolean pair that is used by some algorithms to let a node
remain in a list while being marked as deleted.[9]

[9] Many processors provide a double-wide CAS (CAS2 or CASX) operation that can operate on a pointer-integer
pair, which would make this operation reasonably efficient. As of Java 6, Atomic-StampedReference does not use
double-wide CAS even on platforms that support it. (Double-wide CAS differs from DCAS, which operates on two
unrelated memory locations; as of this writing, no current processor implements DCAS.)

The Java Language Specification requires the JVM to maintain within thread as-if-serial semantics: as long as
the program has the same result as if it were executed in program order in a strictly sequential environment, all these games are
permissible.

In order to shield the Java developer from the
differences between memory models across architectures, Java provides its own memory model, and the JVM deals with the differences
between the JMM and the underlying platform's memory model by inserting memory barriers at the appropriate places.

One convenient mental model for program execution is to imagine that there is a single order in which the operations happen in a
program, regardless of what processor they execute on, and that each read of a variable will see the last write in the execution order to
that variable by any processor. This happy, if unrealistic, model is called sequential consistency. Software developers often mistakenly
assume sequential consistency, but no modern multiprocessor offers sequential consistency and the JMM does not either. The classic
sequential computing model, the von Neumann model, is only a vague approximation of how modern multiprocessors behave.

The bottom line is that modern shared-memory multiprocessors (and compilers) can do some surprising things when data is shared across
threads, unless you've told them not to through the use of memory barriers. Fortunately, Java programs need not specify the placement of
memory barriers; they need only identify when shared state is being accessed, through the proper use of synchronization.

The Java Memory Model is specified in terms of actions, which include reads and writes to variables, locks and unlocks of monitors, and
starting and joining with threads. The JMM defines a partial ordering[2]
called happens-before on all actions within the program. To
guarantee that the thread executing action B can see the results of action A (whether or not A and B occur in different threads), there must
be a happens-before relationship between A and B. In the absence of a happens-before ordering between two operations, the JVM is free
to reorder them as it pleases.

A data race occurs when a variable is read by more than one thread, and written by at least one thread, but the reads and writes are
not ordered by happens-before. A correctly synchronized program is one with no data races; correctly synchronized programs exhibit
sequential consistency, meaning that all actions within the program appear to happen in a fixed, global order.

The rules for happens-before are:
    Program order rule. Each action in a thread happens-before every action in that thread that comes
    later in the program order.
    
    Monitor lock rule. An unlock on a monitor lock happens-before every subsequent lock on that
    same monitor lock.[3]
    
    Volatile variable rule. A write to a volatile field happens-before every subsequent read of that
    same field.[4]
    
    Thread start rule. A call to Thread.start on a thread happens-before every action in the started
    thread.
    
    Thread termination rule. Any action in a thread happens-before any other thread detects that
    thread has terminated, either by successfully return from Thread.join or by Thread.isAlive returning
    false.
    
    Interruption rule. A thread calling interrupt on another thread happens-before the interrupted
    thread detects the interrupt (either by having InterruptedException tHRown, or invoking
    isInterrupted or interrupted).
    
    Finalizer rule. The end of a constructor for an object happens-before the start of the finalizer for that
    object.
    
    Transitivity. If A happens-before B, and B happens-before C, then A happens-before C.
    [3] Locks and unlocks on explicit Lock objects have the same memory semantics as intrinsic locks.
    [4] Reads and writes of atomic variables have the same memory semantics as volatile variables.
    
Because of the strength of the happens-before ordering, you can sometimes piggyback on the visibility properties of an existing
synchronization. This entails combining the program order rule for happens-before with one of the other ordering rules (usually the monitor
lock or volatile variable rule) to order accesses to a variable not otherwise guarded by a lock. This technique is very sensitive to the order
in which statements occur and is therefore quite fragile; it is an advanced technique that should be reserved for squeezing the last drop of
performance out of the most performance-critical classes like ReentrantLock.

We call this technique "piggybacking" because it uses an existing happensbefore ordering that was created for some other reason to
ensure the visibility of object X, rather than creating a happens-before ordering specifically for publishing X.

Piggybacking of the sort employed by FutureTask is quite fragile and should not be undertaken casually. However, in some cases
piggybacking is perfectly reasonable, such as when a class commits to a happens-before ordering between methods as part of its
specification. For example, safe publication using a BlockingQueue is a form of piggybacking. One thread putting an object on a queue and
another thread subsequently retrieving it constitutes safe publication because there is guaranteed to be sufficient internal synchronization
in a BlockingQueue implementation to ensure that the enqueue happens-before the dequeue.

Other happens-before orderings guaranteed by the class library include:
    Placing an item in a thread-safe collection happens-before another thread retrieves that item from the collection;
    
    Counting down on a CountDownLatch happens-before a thread returns from await on that latch;
    
    Releasing a permit to a Semaphore happens-before acquiring a permit from that same Semaphore;
    
    Actions taken by the task represented by a Future happens-before another thread successfully returns from Future.get;
    
    Submitting a Runnable or Callable to an Executor happens-before the task begins execution; and
    
    A thread arriving at a CyclicBarrier or Exchanger happens-before the other threads are released from that same barrier or
    exchange point. If CyclicBarrier uses a barrier action, arriving at the barrier happens-before the barrier action, which in turn
    happens-before threads are released from the barrier.

Chapter 3 explored how an object could be safely or improperly published. The safe publication techniques described there derive their
safety from guarantees provided by the JMM; the risks of improper publication are consequences of the absence of a happens-before
ordering between publishing a shared object and accessing it from another thread.

With the exception of immutable objects, it is not safe to use an object that has been initialized by another thread
unless the publication happensbefore the consuming thread uses it.

This happens-before guarantee is actually a stronger promise of visibility and ordering than made by safe publication. When X is safely
published from A to B, the safe publication guarantees visibility of the state of X, but not of the state of other variables A may have
touched. But if A putting X on a queue happens-before B fetches X from that queue, not only does B see X in the state that A left it
(assuming that X has not been subsequently modified by A or anyone else), but B sees everything A did before the handoff (again, subject
to the same caveat).[5]
[5] The JMM guarantees that B sees a value at least as up-to-date as the value that A wrote; subsequent writes may
or may not be visible.

The treatment of static fields with initializers (or fields whose value is initialized in a static initialization block [JPL 2.2.1 and 2.5.3]) is
somewhat special and offers additional thread-safety guarantees. Static initializers are run by the JVM at class initialization time, after
class loading but before the class is used by any thread. Because the JVM acquires a lock during initialization [JLS 12.4.2] and this lock
is acquired by each thread at least once to ensure that the class has been loaded, memory writes made during static initialization are
automatically visible to all threads. Thus statically initialized objects require no explicit synchronization either during construction or when
being referenced. However, this applies only to the as-constructed state if the object is mutable, synchronization is still required by both
readers and writers to make subsequent modifications visible and to avoid data corruption

Listing 16.5. Eager Initialization.

@ThreadSafe
public class EagerInitialization {
    private static Resource resource = new Resource();
    public static Resource getResource() { return resource; }
}

Using eager initialization, shown in Listing 16.5, eliminates the synchronization cost incurred on each call to getInstance in
SafeLazyInitialization. This technique can be combined with the JVM's lazy class loading to create a lazy initialization technique that
does not require synchronization on the common code path. The lazy initialization holder class idiom [EJ Item 48] in Listing 16.6 uses a
class whose only purpose is to initialize the Resource. The JVM defers initializing the ResourceHolder class until it is actually used [JLS
12.4.1], and because the Resource is initialized with a static initializer, no additional synchronization is needed. The first call to
get resource by any thread causes ResourceHolder to be loaded and initialized, at which time the initialization of the Resource happens
through the static initializer.

Listing 16.6. Lazy Initialization Holder Class Idiom.
@ThreadSafe
public class ResourceFactory {
    private static class ResourceHolder {
        public static Resource resource = new Resource();
    }
    public static Resource getResource() {
        return ResourceHolder.resource ;
    }
}

The guarantee of initialization safety allows properly constructed immutable objects to be safely shared across threads without
synchronization, regardless of how they are published even if published using a data race. (This means that UnsafeLazyInitialization is
actually safe if Resource is immutable.)

Listing 16.3. Unsafe Lazy Initialization. Don't Do this.

@NotThreadSafe
public class UnsafeLazyInitialization {
    private static Resource resource;
    public static Resource getInstance() {
        if (resource == null)
            resource = new Resource(); // unsafe publication
        return resource;
    }
}

Initialization safety guarantees that for properly constructed objects, all threads will see the correct values of final fields
that were set by the constructor, regardless of how the object is published. Further, any variables that can be reached
through a final field of a properly constructed object (such as the elements of a final array or the contents of a HashMap
referenced by a final field) are also guaranteed to be visible to other threads.[6]
[6] This applies only to objects that are reachable only through final fields of the object under construction.

For objects with final fields, initialization safety prohibits reordering any part of construction with the initial load of a reference to that
object. All writes to final fields made by the constructor, as well as to any variables reachable through those fields, become "frozen" when
the constructor completes, and any thread that obtains a reference to that object is guaranteed to see a value that is at least as up to
date as the frozen value. Writes that initialize variables reachable through final fields are not reordered with operations following the
post-construction freeze

However, a number of small changes to SafeStates would take away its thread safety. If states were not final, or if any method other than
the constructor modified its contents, initialization safety would not be strong enough to safely access SafeStates without
synchronization. If SafeStates had other nonfinal fields, other threads might still see incorrect values of those fields. And allowing the
object to escape during construction invalidates the initialization-safety guarantee.

Listing 16.8. Initialization Safety for Immutable Objects.

@ThreadSafe
public class SafeStates {
    private final Map<String, String> states;
    public SafeStates() {
        states = new HashMap<String, String>();
        states.put("alaska", "AK");
        states.put("alabama", "AL");
        ...
        states.put("wyoming", "WY");
    }
    public String getAbbreviation(String s) {
        return states.get(s);
    }
}

Initialization safety makes visibility guarantees only for the values that are reachable through final fields as of the time
the constructor finishes. For values reachable through nonfinal fields, or values that may change after construction, you
must use synchronization to ensure visibility.





## Miscellaneous

---
[]:  ""


