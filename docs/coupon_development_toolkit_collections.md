#       Coupon's Development Toolkit Collections
---

## Indexes
* [Android](#android)
    - [Misc](#android-misc)
        + [WebView](#webview)
            * [Phonegap](#phonegap)
* [JMeter](#jmeter)
    - [Case study](#jmeter-case-study)
* [Database](#database)
    - [Tungsten Replicator](#tungsten-replicator)
    - [PureData System for Analytics(PDA)](#puredata-system-for-analyticspda)
    - [Sysbench](#sysbench)
* [Elastic Stack](#elastic-stack)
    - [ElasticSearch](#elasticsearch)
* [Nginx](#nginx)
    - [Nginx Use Case 1](#nginx-use-case-1)
    - [Apache Server vs Nginx](#apache-server-vs-nginx)
* [Memcached](#memcached)
    - [Simple Spring Memcached (SSM)](#simple-spring-memcached-ssm)
    - [Moxi Proxy](#moxi-proxy)
    - [twemproxy (nutcracker)](#twemproxy-nutcracker)
    - [Kryo Serializer](#kryo-serializer)
    - [Spymemcached](#spymemcached)
    - [memaslap](#memaslap)
* [Miscellaneous](#miscellaneous)
    - [Akamai](#akamai)
    - [Pinpoint](#pinpoint)
    - [Grafana](#grafana)
    - [BSF](#bsf)
    - [Linux Virtual Server(LVS)](#linux-virtual-serverlvs)
    - [HTTP Pipeling vs Domain Sharding](#http-pipeling-vs-domain-sharding)
    - [Mesosphere (DC/OS)](#mesosphere-dcos)
        + [Marathon](#marathon)
    - [Other facilities](#other-facilities)

## Android
[Back To Indexes](#indexes)  
### Android Misc
#### WebView
* The WebView Strategy for Creating Mobile Apps   
[***The WebView Strategy for Creating Mobile Apps***][webview_strategy]  
__THE CHALLENGE__  
Both Android and iPhone (iOS) development are separate beasts. For example, if you create an Android app, you must rewrite it as a port to iPhone. `All that hard work x2`. It isn’t ideal, but we do what we have to do to work around the limitations imposed on what we can develop.

__AN 80% SOLUTION__  
However, there is hope. There is a way to reuse 80% of our application code for BOTH iOS and Android development. The strategy to do this is to write your app using web technologies: `CSS, HTML, and JavaScript`, then configure `a WebView (a container for web pages)` in your native phone app to render your app pages (saving user preferences, dynamic content, graphics, etc…). HTML5, CSS, and JavaScript should be sufficient to do all of these things INSIDE the WebView of whatever device has WebView support. 

__WEBVIEW STRATEGY__  
A WebView app is composed primarily of `Javascript, CSS, and HTML files`. Basically, your app is one or more web pages. These web pages make up your frontend interface. The “WebView” is the window through which your device displays these web pages.

Normally, when a user views web pages, they use a browser. However, a WebView replaces a “browser.” `Instead of allowing users to change web pages, the WebView only displays pages related to your app`.  

Mechanically, your app is a bunch of web pages. `However, aesthetically, it appears to be a normal app`. This is the WebView strategy.

__WHERE DO YOUR WEB FILES LIVE?__  
>Distributed Code vs Centralized Hosting  

* Web app packaged with the phone app  
    * Primary Benefits  
        1. Works Offline.  
        No internet connection is required for devices accessing the app, unless some of your app content depends on external data.
        2. Initial Load Time.  
        The app is loaded locally on the device, so theoretically, initial load time should be faster.  

    * Primary Drawbacks  
        1. Deploying updates.  
        Any change to the app code, must be rolled out to the app store where your app is hosted (before the update can make it out to user devices).
        2. App size.  
        Your app must host more local code/data on the device. So the distributed app will be a larger size.

* Web app stored in a central location  
    * Primary Benefits  
        1. Deploying updates.  
        Any update you make to your centralized code will immediately take affect on all devices that access this centralized code. Users don’t even need to update your app for your changes to take affect.
        2. App size.  
        Since most of your code is stored in a single location, the downloadable app is very light-weight. Phones that run the app don’t have to store very many files or data.  
    * Primary Drawbacks  
        1. Online required.  
        An internet connection is required to access the app. If a device tries to use your app in airplane mode, for example, then the user should get some sort of “no connection” message.  
        2. Initial load time. Devices access your codebase remotely. This may add additional front-loading time. Front-loading speed will depend on the quality of the user’s connection to the internet.

`Disclaimer`: This list of pros and cons are not all inclusive. For example, you should also consider what should happen if your centralized host crashes. Instead of having devices trying to access a broken server, you could design a backup procedure where devices fall back to locally cached data. But such additional considerations are beyond the scope of this article. Let’s just keep things simple for now. Where should your app live? This is up to you.

__THE OTHER 20%__   
**PLATFORM-SPECIFIC EXAMPLES**  
What mechanics of your app cannot be written in web languages, like Javascript, HTML, and CSS? Here are some of the mechanics that I had to tackle (for each platform) when building a dual-platform WebView app.

These are some examples of development considerations that may comprise the remaining 20% of development; stuff that Javascript, HTML, and CSS may not be able to handle in an app. Only platform-specific code may be able to handle these things:  

This is a job for Objective-C, IOS / Java, Android…  

* App start.  
You need code to tell your app what to do when it starts. Is there a splash screen? What URL will your WebView open? Will you need to display a loading icon until the URL fully loads inside your WebView?  
* Title bars.  
By default, your app may display a title bar. But if you are using the WebView strategy, you may want to write platform code to hide the title bar. A title bar may be written inside of the WebView with HTML and CSS, instead.
* Back button.  
On Android, you may have to write a little Java to tell the WebView how to handle back button presses. Otherwise, `the default back button behavior may simply close your app instead of going to a previous view`.
* Remove letter-boxing.  
iPhones may “letter-box” your app… until you add a splash screen. The app looks at the splash screen image to determine app dimensions (without letter-boxing).
* Orientation changes.  
`On Android, your WebView may reload when the orientation changes. In most cases, you want to prevent this by writing some custom Java code`.
* External links.  
Are there any external links in your app? When the user presses one, what should happen? Should it open a separate browser app, or should the external link appear inside your app?
* No internet connection.  
If your WebView connects with an external host, what happens if the device is NOT connected when the user opens the app? You may need to write a little extra code to detect this error and display a message.  

##### Phonegap
`PHONEGAP CAN FILL IN THE OTHER 20% (ONE ALTERNATIVE)`  
[PhoneGap] will try to minimize the amount of platform-specific code you have to write by providing `pre-packaged “boiler-plates”`. PhoneGap intends on handling the mechanics of your WebView on different platforms. You can focus on developing web content to `fill PhoneGap’s pre-written WebView`.  

`PhoneGap is great for pre-packaged functionality. However, it will make it more difficult for you to fine-tune the mechanics of your app`… unless the mechanics, that you want, are already pre-packaged.


## JMeter
[Back To Indexes](#indexes)  
Apache JMeter may be used to test performance both on static and dynamic resources, Web dynamic applications.  
It can be used to `simulate a heavy load on a server, group of servers, network` or object to test its strength or to `analyze overall performance under different load types`.

JMeter is a software that can `perform load test, performance-oriented business (functional) test, regression test`, etc., on different protocols or technologies.

__Apache JMeter features include__:  
* Ability to load and performance test many different applications/server/protocol types:  
    - Web - HTTP, HTTPS (Java, NodeJS, PHP, ASP.NET, …)
    - Web − HTTP, HTTPS sites 'web 1.0' web 2.0 (`ajax, flex and flex-ws-amf`) -- from [jmeter_quick_guide]
    - SOAP / REST Webservices
    - FTP
    - Database via JDBC
    - LDAP
    - Message-oriented middleware (MOM) via JMS
    - Mail - SMTP(S), POP3(S) and IMAP(S)
    - Native commands or shell scripts
    - TCP
    - Java Objects  
* Full featured Test IDE that allows fast Test Plan recording (from Browsers or native applications), building and debugging.
* Command-line mode (Non GUI / headless mode) to load test from any Java compatible OS (Linux, Windows, Mac OSX, …)
* `A complete and ready to present dynamic HTML report` [jmeter dynamic HTML report]
* Easy correlation through ability to extract data from most popular response formats, `HTML, JSON , XML` or any textual format
* Complete portability and `100% Java purity`.
* `Full multi-threading framework allows concurrent sampling by many threads and simultaneous sampling of different functions by separate thread groups.`
* Caching and offline analysis/replaying of test results.
* `Highly Extensible core`:
    - `Pluggable Samplers` allow unlimited testing capabilities.
    - `Scriptable Samplers (JSR223-compatible languages like Groovy and BeanShell)`
    - Several load statistics may be chosen with pluggable timers.
    - Data analysis and visualization plugins allow great extensibility as well as personalization.
    - Functions can be used to provide dynamic input to a test or provide data manipulation.
    - `Easy Continuous Integration through 3rd party Open Source libraries for Maven, Graddle and Jenkins`

__JTL__: JMeter Text Logs  

A __Test Plan__ can be viewed as a container for running tests. It defines what to test and how to go about it. A complete test plan consists of one or more elements such as `thread groups, logic controllers, sample-generating controllers, listeners, timers, assertions, and configuration elements`. A test plan must have at least one thread group.  

`Within each Thread Group, we may place a combination of one or more of other elements − Sampler, Logic Controller, Configuration Element, Listener, and Timer. Each Sampler can be preceded by one or more Pre-processor element, followed by Post-processor element, and/or Assertion element. `

__Ramp-Up__ is the amount of time Jmeter should take to get all the threads sent for the execution. Ramp-Up should be sufficient enough to avoid unnecessary and large work load from the beginning of the test execution.

JMeter has two types of Controllers − __Samplers__ and __Logic Controllers__.

`Some useful samplers are` − (not limited to)
* HTTP Request
* FTP Request
* JDBC Request
* Java Request
* SOAP/XML Request
* RPC Requests

A __Test Fragment__ is a special type of element placed at the same level as the Thread Group element. It is distinguished from a Thread Group in that it is not executed unless it is `referenced by either a Module Controller or an Include_Controller`. This element is purely for `code re-use` within Test Plans.

__Listeners__ let you view the results of Samplers in the form of tables, graphs, trees, or simple text in some log files. They provide visual access to the data gathered by JMeter about the test cases as a Sampler component of JMeter is executed.  

`Listeners can be added anywhere in the test`, including directly under the test plan. They will collect data only from elements at or below their level.

__Timers__
By default, a JMeter thread sends requests without pausing between each sampler. This may not be what you want. You can add a timer element which allows you to define a period to wait between each request.

I would use Ramp-up period only at the beginning of my test, where I want a number of threads/users to begin the test over a fixed period

Uniform Random Timer I would use in the middle of my tests, where I want to introduce random gaps to the tests. 

__Configuration Elements__ allow you to create defaults and variables to be `used by Samplers`. They are used to add or modify requests made by Samplers.

`They are executed at the start of the scope of which they are part, before any Samplers that are located in the same scope`. Therefore, a Configuration Element is accessed only from inside the branch where it is placed.

__Execution Order of Test Elements__  
Following is the execution order of the test plan elements −   
* Configuration elements
* Pre-Processors
* Timers
* Sampler
* Post-Processors (unless SampleResult is null)
* Assertions (unless SampleResult is null)
* Listeners (unless SampleResult is null)

__JMeter Functions and User Variables__   
There are two kinds of functions  
* User-defined static values (or variables)
* Built-in functions

__Referencing Variables and Functions__
Referencing a variable in a test element is done by `bracketing the variable name with '${' and '}'`.

Functions are referenced in the same manner, but by convention, the names of functions begin with `"__"` to avoid conflict with user value names.

Some functions take arguments to configure them, and these go in parentheses, comma-delimited. If the function takes no arguments, the parentheses can be omitted.  

If a function parameter contains a comma, then make sure you escape this with `"\"` as shown below  
```javascript
${__BeanShell(vars.put("name"\,"value"))}
```

Alternatively, you can define your script as a variable, e.g. on the Test Plan  
```javascript
SCRIPT     vars.put("name","value")
```
The script can then be referenced as follows  
```javascript
${__BeanShell(${SCRIPT})}
```
__jMeter - Best Practices__  

>JMeter has some limitations especially when it is run in a distributed environment ??  

* Use multiple instances of JMeter in case, the number of threads are more.
* Here are some suggestion to reduce resource requirements  
    * `Use non-GUI mode`: jmeter -n -t test.jmx -l test.jtl
    * Use as few Listeners as possible; if using the -l flag as above, they can all be deleted or disabled.
    * `Disable the “View Result Tree” listener as it consumes a lot of memory` and can result in the console freezing or JMeter running out of memory. It is, however, safe to use the “View Result Tree” listener with only “Errors” checked.
    * Rather than using lots of similar samplers, use the same sampler in a loop, and use variables (CSV Data Set) to vary the sample. Or perhaps use the Access Log Sampler.
    * Don't use functional mode.
    * `Use CSV output rather than XML.`
    * Only save the data that you need.
    * Use as few Assertions as possible.
    * `Disable all JMeter graphs as they consume a lot of memory. You can view all of the real time graphs using the JTLs tab in your web interface.`
    * Don't forget to erase the local path from CSV Data Set Config if used.
    * Clean the Files tab prior to every test run.

### JMeter Case Study

## Database
### Tungsten Replicator
[Tungsten Replicator][Tungsten_Replicator_git] is an open source replication engine supporting a variety of different extractor and applier modules. Data can be extracted from MySQL, Oracle and Amazon RDS, and applied to transactional stores, including MySQL, Oracle, and Amazon RDS; `NoSQL stores such as MongoDB`, and datawarehouse stores such as Vertica, `Hadoop`, and `Amazon RDS`.

![img][db_topology_examples_by_tangsten]     

![img][Tungsten_Replicator_processing]  

During replication, Tungsten Replication assigns data a unique global transaction ID, and enables flexible statement and/or row-based replication of data. This enables data to be exchanged between different databases and different database versions. During replication, information can be filtered and modified, and deployment can be between on-premise or cloud-based databases. For performance, Tungsten Replicator includes support for `parallel replication`, and `advanced topologies such as fan-in and multi-master`, and can be used efficiently in cross-site deployments.

`On-premises` software is installed and run on computers on the premises (in the building) of the person or organisation using the software, against cloud software. Premises的意思是生产场所, 营业场所.  

MySQL replication isn’t perfect and sometimes our data gets out of sync, either by a failure in replication or human intervention.

Multi-source replication was not possible using regular MySQL replication before. This is now a working feature in MariaDB 10 and also a feature coming with the new MySQL 5.7 

* Continuent Tungsten Clustering
    * Zero-downtime Maintenance
    * High Availability and Continuous Operations
* Real-Time Data Loading Into Hadoop

Continuent provides two products related to the replication, disaster recovery, and high-availability for database deployments:  
__Tungsten Replicator__ - provides heterogeneous replication between Oracle and MySQL, and replication from those two databases out to Amazon Redshift, HP Vertica, and Hadoop. This product was formerly called VMware Continuent for Replication.
__Tungsten Clustering__ - provides clustering, disaster recovery, high availability for MySQL database. This product was formerly called Continuent Tungsten or VMware Continuent for Clustering.

Tungsten replicator (http://tungsten-replicator.org) is a `high performance`, open source, data replication engine for MySQL that is a drop in replacement for standard MySQL replication. 

Tungsten replicator   
* Global transaction ID
* Multiple masters
* Multiple sources
* Flexible topologies
* Parallel replication
* Heterogeneous replication
* ... and more

What Tungsten Replicator is NOT  
* Automated management
* Automatic failover
* Transparent connections

All the above (and more) are available with a commercial solution named Continuent Tungsten (a.k.a. Tungsten Enterprise)  

### PureData System for Analytics(PDA)
PDA is a high-performance, scalable, `massively parallel` system that enables clients to gain insight from their data and perform analytics on `enormous data volumes`.

PDA, powered by Netezza technology, provides faster performance, is big data and business intelligence (BI) ready, and provides advanced security all in a wider range of appliance models.

### Sysbench
[SysBench] is a modular, cross-platform and multi-threaded benchmark tool for evaluating OS parameters that are important for a system running a database under intensive load.

The idea of this benchmark suite is to `quickly get an impression about system performance without setting up complex database benchmarks or even without installing a database at all`.

[SysBench_1]  

## Elastic Stack
### ElasticSearch

[Elastic][elastic_home]

[Elasticsearch][elasticsearch_wiki] is a search engine based on __Lucene__. It provides a `distributed`, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. Elasticsearch is developed in Java and is released as open source under the terms of the Apache License. Elasticsearch is the most popular enterprise search engine followed by `Apache Solr`, also based on Lucene.[1]
It is developed alongside a data collection and log parsing engine called **Logstash**, and an analytics and visualization platform called **Kibana**. The three products are designed to be used as an integrated solution, referred to as the **"ELK stack"**.

Elasticsearch is a distributed, **RESTful search** and analytics engine capable of solving a growing number of use cases. As the heart of the **Elastic Stack**, it centrally stores your data so you can discover the expected and uncover the unexpected.

[Elasticsearch Home][elasticsearch_home]

[Kibana][kibana_home] lets you visualize your Elasticsearch data and navigate the **Elastic Stack**

[Logstash][logstash_home] Centralize, Transform & Stash Your Data  
Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.” (Ours is Elasticsearch, naturally.)

Logstash supports a variety of inputs that pull in events from a multitude of common sources, all at the same time. Easily ingest from your logs, metrics, web applications, data stores, and various AWS services, all in continuous, **streaming fashion**.

[AWS] Amazon Web Services (AWS) is a comprehensive, evolving cloud computing platform provided by Amazon.com. 

## Nginx
NGINX is a free, open-source, `high-performance HTTP server` and `reverse proxy`, as well as an `IMAP/POP3 proxy server`. NGINX is known for its `high performance`, `stability`, rich feature set, simple configuration, and low resource consumption.

NGINX is one of a handful of servers written to address the C10K problem. Unlike traditional servers, NGINX `doesn’t rely on threads to handle requests`. Instead it uses a `much more scalable` `event-driven (asynchronous) architecture`. This architecture `uses small, but more importantly, predictable amounts of memory under load`. Even if you don’t expect to handle thousands of simultaneous requests, you can still benefit from NGINX’s `high-performance and small memory footprint`. NGINX scales in all directions: from the smallest VPS all the way up to large clusters of servers.

`NGINX can be deployed as a standalone web server, and as a frontend proxy for Apache and other web servers`. `This drop‑in solution acts as a network offload device in front of Apache servers`, translating slow Internet‑side connections into fast and reliable server‑side connections, and `completely offloading keepalive connections from Apache servers`.

NGINX also `acts as a shock absorber`  

The performance and scalability of NGINX arise from its event‑driven architecture. It differs significantly from Apache’s process‑or‑thread‑per‑connection approach – in NGINX, `each worker process can handle thousands of HTTP connections simultaneously`. This results in a highly regarded implementation that is lightweight, scalable, and high performance.

`A downside of NGINX’s sophisticated architecture is that developing modules for it isn’t as simple and easy as with Apache`. 

Editor – NGINX Plus Release 11 (R11) and open source NGINX 1.11.5 introduce binary compatibility for dynamic modules, including support for compiling custom and third‑party modules.

`NGINX provides all of the core features of a web server`, without sacrificing the lightweight and high‑performance qualities that have made it successful, and can also serve as a proxy that forwards HTTP requests to upstream web servers (such as an Apache backend) and FastCGI, memcached, SCGI, and uWSGI servers. `NGINX does not seek to implement the huge range of functionality necessary to run an application, instead relying on specialized third‑party servers` such as PHP‑FPM, Node.js, and even Apache.

`And so emerged the architectural pattern of running NGINX at the frontend to act as the accelerator and shock absorber, and whatever technology is most appropriate for running applications at the backend`.

To forward HTTP requests to upstream application components, the frontend needs to provide termination of HTTP, HTTPS, and HTTP/2 connections, along with “shock‑absorber” protection and routing. It also needs to offer basic logging and first‑line access control, implement global security rules, and `offload HTTP heavy lifting (caching, compression)` to optimize the performance of the upstream application.

This is where NGINX and NGINX Plus come into their element, providing these twelve features (among others) that `make them ideal for microservices and containers`:  
1. Single, reliable entry point
2. `Serve static content`
3. Consolidated logging
4. SSL/TLS and HTTP/2 termination
5. Support multiple backend apps
6. `Easy A/B testing`
7. Scalability and fault tolerance
8. `Caching (for offload and acceleration)`
9. `GZIP compression`
10. Zero downtime
11. Simpler security requirements
12. `Mitigate security and DDoS attacks`

A monolithic architectural framework was sound practice when Apache was new and fresh, but app developers are finding that such an approach is no longer up to the task of delivering complex applications at the speed their businesses require. __Microservice architecture__ is emerging as the wave of the future for web apps and sites, and NGINX is perfectly poised to assume its place in that architecture as the ideal application delivery platform for the modern Web.

from coupon wiki:  
>Nginx also supports major functionalists which apache supports like the following.   
SSL/TLS
Virtual Hosts
Reverse Proxy
Load Balence??
Compression
URL rewrite

### Nginx Use Case 1

ADC -> Nginx  -> Tomcat (production env)   
LVS -> Nginx  -> Tomcat (IT env)   
1. ADC is device and LVS is software. They are both the LB(Load Balance) solution of Coupon
2. Nginx is just used as a Web Server and Reverse Proxy.
3. Tomcat is the real application (10001, 20001)

Nginx is known for its speed in serving static pages, much faster than apache and keeping the machine resources very low.

### Apache Server vs Nginx
__Apache’s process‑per‑connection model__  
At that time, many network services were triggered from a master service called inetd; when a new network (TCP) connection was received, inetd would fork( ) and exec( ) a Unix process of the correct type to handle the connection. The process read the request on the connection, calculated the response and wrote it back down the connection, and then exited.

Apache took this model and ran with it. `The biggest downside was the cost of forking a new httpd worker process for each new connection`, and Apache developers quickly adopted a prefork model in which a pool of worker processes was created in advance, each ready and willing to accept one new HTTP connection.

The isolation and protection afforded by the one‑connection‑per‑process model made it very easy to insert additional code (in the form of modules) at any point in Apache’s web‑serving logic. 

Apache administrators try two temp solutions:  
* limited the maximum number of httpd processes (typically to 256)
* disabled keepalive connections or reduced their duration

Two __Apache MPMs__ (called multi‑processing modules, or MPMs)
1. worker MPM:  The worker MPM replaced separate httpd processes with a small number of child processes that ran multiple worker threads and assigned one thread per connection. This was helpful on `many commercial versions of Unix (such as IBM’s AIX) where threads are much lighter weight than processes`, but is less effective on `Linux where threads and processes are just different incarnations of the same operating system entity`.

2. event MPM: extends the worker MPM `by adding a separate listening thread that manages idle keepalive connections once the HTTP request has completed`.

`Apache has gained a reputation as a bloated, overly complex, and performance‑limited web server that can be exploited by slow denial‑of‑service (DoS) attacks.`

Apache, the monolithic one‑server‑does‑all model is struggling.

## Memcached
### Simple Spring Memcached (SSM)
[simple-spring-memcached] This project `enables caching in Spring-managed beans`, by using Java 5 Annotations and Spring/AspectJ AOP `on top of the spymemcached or xmemcached client`.

`Simple Spring Memcached`:  simple-spring-memcached-3.6.0.jar  

[simple-spring-memcached-detail]  

* Cache zone  
Cache zone is a group of memcached servers (instances) supported by one of the available providers. Using cache zones data can be split across different groups of servers. It's useful when depending on type cached data should be separated and stored on dedicated servers, so one type of data doesn't influence (evict) another.  
To store data on specific cache zone mark class or method with __@CacheName__ and provide name or alias of cache zone.

* Serialization  
By default all objects stored in cache are serialized/deserialized using standard java serialization. Other serilization framework are suggested to be used.

* Runtime node switching  
Memcached instances used by each cache zone can be change on the fly without redeploying or restarting application. This is available by invoking `changeAddresses` method on cache factory.  
`When Memcached Does not work`  
* Memcached AOP inherits the characteristics of Spring AOP.
* Hence, private method is not going to be executed in Memcached AOP.
* Memcached AOP does not work when calling methods within the same class.  
`Spring AOP is designed that method calls within the same object does not work (when a method calls b method within the same class, b method AOP doesn't work.) ???`  
* It is recommended to give annotations at class level. Interface annotation sometimes does not work.

Thus, it is important to version the namespace upon change of cached class to avoid conflict.  

### Moxi Proxy
[moxi_git]  
[moxi-guide]  
moxi is a proxy capable of handling many connections for client applications, providing those clients simplified management and increased performance. It can be `used with memcached servers` or `a Membase Cluster` hosting both membase and memcached type buckets.   

`Handling Memcached failover`  
Unlike a database with built in failover (master/slave model), you can usually only connect a client to a single Memcached server. If you specify multiple servers then these are used as part of the hashing to determine where the data gets stored, but there’s no concept of replication. This means if one Memcached node goes down, you lose the keys on that node. If you’re only connecting to a single node then you lose all Memcached.

The commercial product, __Membase__, handles this by providing replicated Memcached and failover functionality so if one node goes down, you can still access the other node(s) without any impact to the application.

Instead, you can use the __Moxi Memcached proxy__. This allows your application servers to connect to what looks like a single Memcached host but Moxi handles sending the queries to the correct Membase (or Memcached) node. It also communicates with Membase to determine the health of a node for failover purposes.

`We have recently deployed Moxi to elimiate Memcached as a single point of failure`. Our web nodes now connect to one of several local Moxi instances (one for each Memcached bucket) which proxy the connections out to the cluster. If one of the Memcached cluster nodes fails, our application never needs to know because Moxi will silently handle the failover.

Alternatively, with `Couchbase 1.8 (which is what Membase has been renamed to)`, you can use their client libraries to connect directly to your Couchbase instances with the failover support built into the libraries.

![img][memcached_and_moxi_proxy_architecture]  

* `Moxi uses consistent hash algorithm to guarantee same key on same servers, whereas LVS doesn't support it`.
* Moxi supports cluster nodes change on the fly.(The only changes moxi is set at the time of addition or deletion of memcached servers. If you are a client-side continues to look at only the LVS.)

### twemproxy (nutcracker)
[twemproxy]
twemproxy (pronounced "two-em-proxy"), aka nutcracker is a fast and lightweight proxy for memcached and redis protocol. It was built primarily to reduce the number of connections to the caching servers on the backend. This, together with protocol pipelining and sharding enables you to horizontally scale your distributed caching architecture.

?? it only supports text mode

### Kryo Serializer
You may have a need to customize Kryo serialization library, especially when you use joda-time.
Most of customer serialization implementation can be found in [Kryo_Serializers_Git_1]  

### Spymemcached
`A simple, asynchronous, single-threaded memcached client written in java.`  
[spymemcached_git]   
[spymemcached_gc]  

* Efficient storage of objects.  
General serializable objects are stored in their `serialized form` and optionally compressed if they meet criteria. Certain native objects are stored as tightly as possible (for example, a Date object generally consumes six bytes, and a Long can be anywhere from zero to eight bytes).
* Resilient to server and network outages.   
In many cases, a client operation can be replayed against a server if it goes away and comes back. In cases where it can't, it will communicate that as well. `An exponential backoff(二进制指数回退) reconnect algorithm` is applied when a memcached becomes unavailable, but `asynchronous operations will queue up` for the server to be applied when it comes back online.  
* Operations are asynchronous.  
It is possible to issue a store and continue processing without having to wait for that operation to finish. It is even possible to issue a get, do some further processing, check the result of the get and cancel it if it doesn't return fast enough.
* There is only one thread for all processing.  
Regardless of the number of requests, threads using the client, or servers to which the client is connected, only one thread will ever be allocated to a given MemcachedClient.  
Aggressively optimized. There are many optimizations that combine to provide `high throughput`.

### memaslap
[memaslap] is a load generation and benchmark tool for memcached servers. It generates configurable workload such as threads, concurrencies, connections, run time, overwrite, miss rate, key size, value size, get/set proportion, expected throughput, and so on. Furthermore, it also tests data verification, expire-time verification, UDP, binary protocol, facebook test, replication test, multi-get and reconnection, etc.

## Miscellaneous
[Back To Indexes](#indexes)  

### Akamai
__Akamai__ Technologies, Inc. is an American `content delivery network (CDN)` and `cloud services provider` headquartered in Cambridge, Massachusetts, in the United States. Akamai's content delivery network is one of the world's largest distributed computing platforms, `responsible for serving between 15 and 30 percent of all web traffic`.[6] The company operates a network of servers around the world and rents capacity on these servers to customers who want their websites to work faster by distributing content from locations close to the user. Over the years its customers have included Apple, Facebook, Bing, Valve, Twitter, eBay, Google, LinkedIn and healthcare.gov. When a user navigates to the URL of an Akamai customer, their browser is redirected to one of Akamai's copies of the website.

Web Application Firewall??

### Pinpoint
[Pinpoint] Pinpoint is an __APM (Application Performance Management)__ tool for `large-scale distributed systems` written in Java. Modelled after Dapper, Pinpoint provides a solution to help analyze the `overall structure of the system and how components within them are interconnected` by tracing transactions across distributed applications.

* `Install agents without changing a single line of code`
* Minimal impact on performance (approximately 3% increase in resource usage)


### Grafana
[Grafana] is `most commonly used for visualizing time series data for Internet infrastructure and application analytics` but many use it in other domains including industrial sensors, home automation, weather, and process control.

Supports Graphite, Elasticsearch, Prometheus, InfluxDB, OpenTSDB and KairosDB out of the box. Or use the plug-in functionality to add your own.

### BSF
__Bean Scripting Framework (BSF)__ is a set of Java classes which provides scripting language support within Java applications, and `access to Java objects and methods from scripting languages`. BSF allows one to write JSPs in languages other than Java while providing access to the Java class library. In addition, BSF permits any Java application to be implemented in part (or dynamically extended) by a language that is embedded within it. This is achieved by providing an API that permits `calling scripting language engines from within Java`, as well as an object registry that exposes Java objects to these scripting language engines.

`BSF 2.x supports several scripting languages currently`:  
* Javascript (using Rhino ECMAScript, from the Mozilla project)
* NetRexx (an extension of the IBM REXX scripting language in Java)
* Commons JEXL
* Python (using Jython)
* Tcl (using Jacl)
* XSLT Stylesheets (as a component of Apache XML project's Xalan and Xerces)

`In addition, the following languages are supported with their own BSF engines`:  
* Java (using BeanShell, from the BeanShell project)
* Groovy
* Groovy Monkey
* JLog (PROLOG implemented in Java)
* JRuby
* JudoScript
* ObjectScript
* ooRexx (Open Object Rexx), using BSF4ooRexx.

Apache BSF 3.x includes an implementation of JSR-223 (javax.script) and runs on Java 1.4 and Java 1.5. (Java 1.6 includes javax.script as standard.)

### Linux Virtual Server(LVS)
The Linux Virtual Server is a highly scalable and highly available server `built on a cluster of real servers`, `with the load balancer running on the Linux operating system`. The architecture of the server cluster is fully transparent to end users, and the users interact as if it were a single high-performance virtual server.

The real servers and the load balancers may be interconnected by either high-speed LAN or by geographically dispersed WAN. The load balancers can dispatch requests to the different servers and make parallel services of the cluster to appear as a virtual service on a single IP address, and request dispatching can use IP load balancing technolgies or application-level load balancing technologies. Scalability of the system is achieved by transparently adding or removing nodes in the cluster. `High availability is provided by detecting node or daemon failures and reconfiguring the system appropriately`(PS: no failover supported).

The Linux Virtual Server Project (LVS) implements __layer 4 switching__ in the Linux Kernel. This `allows TCP and UDP sessions to to be load balanced` between multiple real servers. Thus it provides a way to scale Internet services beyond a single host. HTTP and HTTPS traffic for the World Wide Web is probably the most common use. Though it can also be used for more or less any service, from email to the X Windows System.

LVS itself runs on Linux, however it is able to load balance connections from end users running any operating system to real servers running any operating system. As long as the connections use TCP or UDP, LVS can be used.

LVS is very high performance. It is able to handle upwards of `100,000 simultaneous connections`. It is easily able to load balance a saturated 100Mbit ethernet link using inexpensive commodity hardware. It is also able to load balance saturated 1Gbit link and beyond using higher-end commodity hardware.

### HTTP Pipeling vs Domain Sharding
[HTTP Pipelining vs Domain Sharding]  
One of the key features to HTTP2.0 is the ability to interleave (i.e multiplex) multiple requests and responses across a single TCP connection. Resulting in Domain Sharding being considered counterproductive.  

`HTTP PIPELING`  

Ok, first a little history. Within HTTP versions prior to HTTP 1.1 each request was sent over a separate TCP connection. `HTTP 1.1 then introduced a feature called "Keep-Alive". This allowed for multiple requests to be sent over a single connection`. However `only a single request could be sent at once`. When the request had been served i.e the response fully received, the next request could be sent. This is also known as head-of-line-blocking. 

`HTTP Pipeling was introduced and allowed the client to send multiple requests within a single TCP connection in parallel`.  
However, Pipelining was still prone to head-of-line-blocking as `each response had to be completed before the next response could be sent`. Below is an example,  
Consider the following,  
1. Client sends 2 requests to the server in parallel for index.php and html.txt. index.php is received first.
2. Both requests are processed. php:60ms and txt:20ms.
3. Even though txt is processed first it is buffered until the php response is sent.
4. The txt response is sent once the php response is complete.
(PS: without considering transferring time, it costs 60ms via pipeline but 80ms via keep-alive connection)

Because of the head-of-line blocking issues with HTTP Pipelining, along with many servers and proxies not supporting it due to problems with implementation, `Pipelining is typically disabled (by default) within browsers`.

`DOMAIN SHARDING`  
Because of the limited adoption of HTTP pipelining, there was still a need for further optimisation techniques within the HTTP protocol to allow for HTTP requests/responses to be sent and received in parallel.  

`By default browsers open a maximum of 6 connections on a per domain basis`. `Domain Sharding simply means that the websites assets are spread across multiple domains`. In turn maximising the amount of concurrent connections opened by the browser, allowing for a greater number of parallel downloads via HTTP.

However Domain Sharding does come with its own disadvantages. Such as the additional overhead/latency introduced with a) `building extra TCP connections` and b) `performing additional Domain Name lookups`.

SUMMARY  
In essence both HTTP Pipelining and Domain Sharding allow for HTTP requests to be sent in parallel. But this is where the similarities end. With head-of-line-blocking and the limited adoption of HTTP Pipelining, `Domain Sharding is the preferred choice when choosing between these 2 HTTP optimization 'techniques'`. 

### Mesosphere (DC/OS)
#### Marathon
Marathon is a production-grade container orchestration platform for Mesosphere’s Datacenter Operating System (DC/OS) and Apache Mesos.

### Other facilities
* `Chakra Max` for database access control
* `Nimbo storage` for storage solution
* ETL tool: `IBM InfoSphere DataStage` vs `TeraStream`  
`IBM InfoSphere DataStage` is an ETL tool and part of the IBM Information Platforms Solutions suite and IBM InfoSphere. It uses a graphical notation to construct data integration solutions and is available in various versions such as the Server Edition, the Enterprise Edition, and the MVS Edition.(`not free`)  
`TeraStream`™ is the high-performance data integration solution in conjunction with DB in a variety of server environments to do the core functional ETL routines (Extract, Transform, and Load). It can be efficiently applied to high-volume batch processing, real-time data connectivity and data conversion. It guarantees a differentiated file handling performance from the existing data integration solutions in market. (Brand Name: DataStreams, Place of Origin: South Korea)  
[TeraStream ETL]  
* `MaxGauge` for MySQL/Oracle monitoring  
* `Upsource` for code review

---
[webview_strategy]:http://www.human-element.com/webview-strategy-creating-mobile-apps-part-13/ "Webview Strategy"
[PhoneGap]:http://phonegap.com/ "PhoneGap"
[jmeter dynamic HTML report]:http://jmeter.apache.org/usermanual/generating-dashboard.html "Generating Report Dashboard"
[jmeter_quick_guide]:http://www.tutorialspoint.com/jmeter/jmeter_quick_guide.htm
[elasticsearch_wiki]:https://en.wikipedia.org/wiki/Elasticsearch
[elasticsearch_home]:https://www.elastic.co/products/elasticsearch
[kibana_home]:https://www.elastic.co/products/kibana
[elastic_home]:https://www.elastic.co/
[logstash_home]:https://www.elastic.co/products/logstash
[Grafana]:http://grafana.org/
[Tungsten_Replicator_git]:https://github.com/continuent/tungsten-replicator
[SysBench]:https://github.com/akopytov/sysbench
[SysBench_1]:https://launchpad.net/sysbench
[TeraStream ETL]:http://datastreamsglobal.com/
[spymemcached_gc]:https://code.google.com/archive/p/spymemcached/
[spymemcached_git]:https://github.com/dustin/java-memcached-client
[simple-spring-memcached]:https://github.com/ragnor/simple-spring-memcached
[simple-spring-memcached-detail]:https://code.google.com/archive/p/simple-spring-memcached/wikis/UserGuide.wiki
[moxi_git]:https://github.com/couchbase/moxi
[moxi-guide]:http://docs.couchbase.com/moxi-guide/
[twemproxy]:https://github.com/twitter/twemproxy
[memaslap]:http://docs.libmemcached.org/bin/memaslap.html
[Pinpoint]:https://github.com/naver/pinpoint
[AWS]:http://searchaws.techtarget.com/definition/Amazon-Web-Services "What is AWS"
[Kryo_Serializers_Git_1]:https://github.com/magro/kryo-serializers "Kryo_Serializers_Git_1"
[HTTP Pipelining vs Domain Sharding]:https://www.fir3net.com/Networking/Protocols/http-pipelining-vs-domain-sharding.html "HTTP Pipelining vs Domain Sharding"
[db_topology_examples_by_tangsten]:/resources/img/java/db_topology_examples_by_tangsten.png "db_topology_examples_by_tangsten"
[Tungsten_Replicator_processing]:/resources/img/java/Tungsten_Replicator_processing.png "Tungsten_Replicator_processing"
[memcached_and_moxi_proxy_architecture]:/resources/img/java/coupon_memcached_and_moxi_proxy_architecture.png "memcached_and_moxi_proxy_architecture"

