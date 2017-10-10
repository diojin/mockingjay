#       Coupon's Development Toolkit Collections
---

## Indexes
* [Android](#android)
    - [Misc](#android-misc)
        + [WebView](#webview)
            * [Phonegap](#phonegap)
* [JMeter](#jmeter)
    - [Case study](#jmeter-case-study)
* [Databaes](#database)
    - [Tungsten Replicator](#tungsten-replicator)
    - [PureData System for Analytics(PDA)](#puredata-system-for-analyticspda)
    - [Sysbench](#sysbench)
* [Miscellaneous](#miscellaneous)
    - [Akamai](#akamai)
    - [Pinpoint](#pinpoint)
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

JMeter is a software that can perform load test, performance-oriented business (functional) test, regression test, etc., on different protocols or technologies.

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

Functions are referenced in the same manner, but by convention, the names of functions begin with "__" to avoid conflict with user value names.

Some functions take arguments to configure them, and these go in parentheses, comma-delimited. If the function takes no arguments, the parentheses can be omitted. For example −  

If a function parameter contains a comma, then make sure you escape this with "\" as shown below  
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
**Tungsten practise on CDC(Change Data Capture)**  
Tungsten Replicator is one of the CDC solutions. CDC (Change Data Capture) is the feature to capture the changed data from Data Source and transfer and apply the data to Target System.  
1. Read Binlog files of MySQL from source 
2. Capture the changed data 
3. Generate the capture in THL and save it  
4. Get the generated THL to target via remote
5. Read the changed data in THL and load it on Memory Q(In-Memory Queue)
6. What's loaded on Memory Q(In-Memory Queue) is applied on target DB. Tungsten is in Java, so it is through JDBC  

`Transaction History Log (THL)`
It holds the data `on transaction level`, managed as file based on __GTID (Global Transaction ID)__. So it's designed to have multi-master configuration.  
MySQL directly reads Binary Log file during the step to transform the changed data from source to THL Oracle interfaces with Oracle Change Data Capture(CDC). (Oracle requires setting for CDC. The script is provided) 

__Structure__  
DB are configured as 3 layers: Standby, Consolidation, and Target.  
* Standby  
Standby DBs in real service  
* Standby -> Consolidation  
Standby -> Consolidation is configured as MySQL replication: 1 Consolidation server mapped to maximum 6 Standby DBs.  
* Consolidation -> Target  
Consolidation -> Target uses Tungsten replicator 

`Why is it Standby-Consolidation-Target configuration instead of Standby-Target? (Why do we need Consolidation?)`  
1. As for Tungsten replication, parameter "binlog_format=row" needs to be applied. But we cannot use row base in real db server, hence using this way to configure similar to row base while it's not service server(means merely config standby db server to row base, but rather master db).
2. In order to add service or table to be synchronized in CDC structure, initial (data) loading is needed. And data inflow for source needs to be blocked, so as to sync the data between source and target. But CDC structure in real service cannot be done in this regard. (So only Standby DB server is blocked then)

### PureData System for Analytics(PDA)
PDA is a high-performance, scalable, `massively parallel` system that enables clients to gain insight from their data and perform analytics on `enormous data volumes`.

PDA, powered by Netezza technology, provides faster performance, is big data and business intelligence (BI) ready, and provides advanced security all in a wider range of appliance models.

### Sysbench
[SysBench] is a modular, cross-platform and multi-threaded benchmark tool for evaluating OS parameters that are important for a system running a database under intensive load.

The idea of this benchmark suite is to `quickly get an impression about system performance without setting up complex database benchmarks or even without installing a database at all`.

[SysBench_1]  


## Miscellaneous
[Back To Indexes](#indexes)  

### Akamai
__Akamai__ Technologies, Inc. is an American `content delivery network (CDN)` and `cloud services provider` headquartered in Cambridge, Massachusetts, in the United States. Akamai's content delivery network is one of the world's largest distributed computing platforms, responsible for serving between 15 and 30 percent of all web traffic.[6] The company operates a network of servers around the world and rents capacity on these servers to customers who want their websites to work faster by distributing content from locations close to the user. Over the years its customers have included Apple, Facebook, Bing, Valve, Twitter, eBay, Google, LinkedIn and healthcare.gov. When a user navigates to the URL of an Akamai customer, their browser is redirected to one of Akamai's copies of the website.

Web Application Firewall??

### Pinpoint
[Pinpoint] Pinpoint is an __APM (Application Performance Management)__ tool for large-scale distributed systems written in Java. Modelled after Dapper, Pinpoint provides a solution to help analyze the `overall structure of the system and how components within them are interconnected` by tracing transactions across distributed applications.

* `Install agents without changing a single line of code`
* Minimal impact on performance (approximately 3% increase in resource usage)

### Other facilities
* `Chakra Max` for database access control
* `Nimbo storage` for storage solution
* ETL tool: `IBM InfoSphere DataStage` vs `TeraStream`  
`IBM InfoSphere DataStage` is an ETL tool and part of the IBM Information Platforms Solutions suite and IBM InfoSphere. It uses a graphical notation to construct data integration solutions and is available in various versions such as the Server Edition, the Enterprise Edition, and the MVS Edition.(not free)  
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