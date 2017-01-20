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
* [Android IOS](#android-ios)
    - [Misc](#mobile-misc)
        + [WebView](#webview)
* [JMeter](#jmeter)
* [Case Study](#case_study)
    - [JMeter Practise Example](#jmeter-practise-example)
    - [Confidence Practise Example](#confidence-practise-example)
    - [Database backup strategy](#database-backup-strategy)
    - [Mysql replication delay and programmer guideline](#mysql-replication-delay-and-programmer-guideline)
    - [PureData System for Analytics(PDA)](#puredata-system-for-analyticspda)
    - [sysbench](#sysbench)
    - [Data volume example](#data-volume-example)
    - [Set up a virtual machine](#set-up-a-virtual-machine)
    - [Akamai](#akamai)
    - [Pinpoint](#pinpoint)
    - [Other facilities](#other-facilities)
* [Miscellaneous](#miscellaneous)
    - [Elastic Stack](#elastic-stack)
        + [ElasticSearch](#elasticsearch)
    - [Grafana](#grafana)
    - [BSF](#bsf)
    - [TUNGSTEN REPLICATOR](#tungsten-replicator)
    - [Linux Virtual Server(LVS)](#linux-virtual-serverlvs)
    - [Nginx](#nginx)
    - [Memcached](#memcached)
        + [Simple Spring Memcached (SSM)](#simple-spring-memcached-ssm)
        + [Moxi Proxy](#moxi-proxy)
        + [Kryo Serializer](#kryo-serializer)
        + [Spymemcached](#spymemcached)
        + [memaslap](#memaslap)
    - [twemproxy (nutcracker)](#twemproxy-nutcracker)
    - [HTTP Pipeling vs Domain Sharding](#http-pipeling-vs-domain-sharding)
    - [Mesosphere (DC/OS)](#mesosphere-dcos)
        + [Marathon](#marathon)
    - [Temp](#temp)
        + [Transfer](#transfer)
* [Appendix](#appendix)


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


###Android IOS
####Mobile Misc
#####WebView
* The WebView Strategy for Creating Mobile Apps
[***The WebView Strategy for Creating Mobile Apps***][webview_strategy]

__THE CHALLENGE__

Both Android and iPhone (iOS) development are separate beasts. For example, if you create an Android app, you must rewrite it as a port to iPhone. `All that hard work x2`. It isn’t ideal, but we do what we have to do to work around the limitations imposed on what we can develop.


__AN 80% SOLUTION__

However, there is hope. There is a way to reuse 80% of our application code for BOTH iOS and Android development. The strategy to do this is to write your app using web technologies: `CSS, HTML, and JavaScript`, then configure a WebView (a container for web pages) in your native phone app to render your app pages (saving user preferences, dynamic content, graphics, etc…). HTML5, CSS, and JavaScript should be sufficient to do all of these things INSIDE the WebView of whatever device has WebView support.


__WEBVIEW STRATEGY__

A WebView app is composed primarily of `Javascript, CSS, and HTML files`. Basically, your app is one or more web pages. These web pages make up your frontend interface. The “WebView” is the window through which your device displays these web pages.

Normally, when a user views web pages, they use a browser. However, a WebView replaces a “browser.” Instead of allowing users to change web pages, the WebView only displays pages related to your app.

Mechanically, your app is a bunch of web pages. `However, aesthetically, it appears to be a normal app`. This is the WebView strategy.

__WHERE DO YOUR WEB FILES LIVE?__

>Distributed Code vs Centralized Hosting

`Web app packaged with the phone app`:
`Primary Benefits`:

* Works Offline. No internet connection is required for devices accessing the app, unless some of your app content depends on external data.
* Initial Load Time. The app is loaded locally on the device, so theoretically, initial load time should be faster.

`Primary Drawbacks`:

* Deploying updates. Any change to the app code, must be rolled out to the app store where your app is hosted (before the update can make it out to user devices).

* App size. Your app must host more local code/data on the device. So the distributed app will be a larger size.

`Web app stored in a central location`:

`Primary Benefits`:

* Deploying updates. Any update you make to your centralized code will immediately take affect on all devices that access this centralized code. Users don’t even need to update your app for your changes to take affect.
* App size. Since most of your code is stored in a single location, the downloadable app is very light-weight. Phones that run the app don’t have to store very many files or data.

`Primary Drawbacks`:

* Online required. An internet connection is required to access the app. If a device tries to use your app in airplane mode, for example, then the user should get some sort of “no connection” message.
* Initial load time. Devices access your codebase remotely. This may add additional front-loading time.
Front-loading speed will depend on the quality of the user’s connection to the internet.

`Disclaimer`: This list of pros and cons are not all inclusive. For example, you should also consider what should happen if your centralized host crashes. Instead of having devices trying to access a broken server, you could design a backup procedure where devices fall back to locally cached data. But such additional considerations are beyond the scope of this article. Let’s just keep things simple for now. Where should your app live? This is up to you.

__THE OTHER 20%__

`PLATFORM-SPECIFIC EXAMPLES`

What mechanics of your app cannot be written in web languages, like Javascript, HTML, and CSS? Here are some of the mechanics that I had to tackle (for each platform) when building a dual-platform WebView app.

These are some examples of development considerations that may comprise the remaining 20% of development; stuff that Javascript, HTML, and CSS may not be able to handle in an app.
Only platform-specific code may be able to handle these things:

This is a job for Objective-C, IOS / Java, Android…

* App start. You need code to tell your app what to do when it starts. Is there a splash screen? What URL will your WebView open? Will you need to display a loading icon until the URL fully loads inside your WebView?
* Title bars. By default, your app may display a title bar. But if you are using the WebView strategy, you may want to write platform code to hide the title bar. A title bar may be written inside of the WebView with HTML and CSS, instead.
* Back button. On Android, you may have to write a little Java to tell the WebView how to handle back button presses. Otherwise, the default back button behavior may simply close your app instead of going to a previous view.
* Remove letter-boxing. iPhones may “letter-box” your app… until you add a splash screen. The app looks at the splash screen image to determine app dimensions (without letter-boxing).
* Orientation changes. On Android, your WebView may reload when the orientation changes. In most cases, you want to prevent this by writing some custom Java code.
* External links. Are there any external links in your app? When the user presses one, what should happen? Should it open a separate browser app, or should the external link appear inside your app?
* No internet connection. If your WebView connects with an external host, what happens if the device is NOT connected when the user opens the app? You may need to write a little extra code to detect this error and display a message.

__PHONEGAP CAN FILL IN THE OTHER 20% (ONE ALTERNATIVE)__

[PhoneGap] will try to minimize the amount of platform-specific code you have to write by providing pre-packaged “boiler-plates”. PhoneGap intends on handling the mechanics of your WebView on different platforms. You can focus on developing web content to fill PhoneGap’s pre-written WebView.

PhoneGap is great for pre-packaged functionality. However, it will make it more difficult for you to fine-tune the mechanics of your app… unless the mechanics, that you want, are already pre-packaged.

###JMeter

Apache JMeter may be used to test performance both on static and dynamic resources, Web dynamic applications. 
It can be used to `simulate a heavy load on a server, group of servers, network` or object to test its strength or to analyze overall performance under different load types.

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
    - Pluggable Samplers allow unlimited testing capabilities.
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

${__BeanShell(vars.put("name"\,"value"))}

Alternatively, you can define your script as a variable, e.g. on the Test Plan −
SCRIPT     vars.put("name","value")

The script can then be referenced as follows −
${__BeanShell(${SCRIPT})}

__jMeter - Best Practices__

>JMeter has some limitations especially when it is run in a distributed environment ??

* Use multiple instances of JMeter in case, the number of threads are more.
* Here are some suggestion to reduce resource requirements −
    - `Use non-GUI mode`: jmeter -n -t test.jmx -l test.jtl.
    - Use as few Listeners as possible; if using the -l flag as above, they can all be deleted or disabled.
    - `Disable the “View Result Tree” listener as it consumes a lot of memory` and can result in the console freezing or JMeter running out of memory. It is, however, safe to use the “View Result Tree” listener with only “Errors” checked.
    - Rather than using lots of similar samplers, use the same sampler in a loop, and use variables (CSV Data Set) to vary the sample. Or perhaps use the Access Log Sampler.
    - Don't use functional mode.
    - `Use CSV output rather than XML.`
    - Only save the data that you need.
    - Use as few Assertions as possible.
    - `Disable all JMeter graphs as they consume a lot of memory. You can view all of the real time graphs using the JTLs tab in your web interface.`
    - Don't forget to erase the local path from CSV Data Set Config if used.
    - Clean the Files tab prior to every test run.


###Case Study
---

####JMeter Practise Example

10.255.255.223  xtrigger-perf01-mv              or use VNC access
Data:   /pang/share/maple
Home:   /home/maple/workspaces/performance-runner/

Gather data from both JMeter JTL log and WAS, publish to ES clusters, and later referred by Kibana.

[jmeter_test_example_entire_flow]

1. Prepare for running JMeter slave node

dist -f "stop.jmeter.sh @DIST_HOST" 10.255.255.221 10.255.255.222
dist -f "start.jmeter.sh @DIST_HOST" 10.255.255.221 10.255.255.222

2. testing metaphor properties, as well as properties files and jmx files it uses
Metaphor to illustrate that separates the testing context units from the Dashboard

3. run testing
./jmeter_runner_for_ES.py {testing_metaphor}.properties

4. report to es server
./report_runner_for_ES.py {testing_metaphor}.properties

Statistics to gather:
1. JMeter data 
    1.1 TPS, successful tps & failure tps
    1.2 max/mean response time
2. WAS jmx data, including System(load average, system cpu load), heap memory, GC TIME(MINOR/FULL), GC COUNT(MINOR/FULL), CLASSLOADING(total loaded/unloaded class count)
THREADBUSY(threadCount, totalStartedThreadCount, peakThreadCount,  daemonThreadCount 

Data example,  compared memcached version to one without memcached version

TPS = Transactions / Time  =  Thread Count / mean response time 


item|source|settings|TPS|Response time|others
:---------------------|:-----:|--------:|-------:|:--------|:-------
findBySubscriptionIdAndVendorItemId|orders(1,224,280), order_items(1,350,144) on 20150908|thread=50, slave server=2, loop count=200,000|tps = 10000 | max response < 1s, mean response = 10 ms| orders(6,726,007), order_items(12,022,210) on 20170109
`getTransitionBanners_memcached`|on 20160407, transitions(510), transition_target_members(52082), transition_banners(435)| thread=100, slave server=2, loop count=200,000 | tps = 24000 | max response < 1s, mean response = 8.3 ms| on 20170109, transitions(6245), transition_target_members(784,288), transition_banners(5795)
`getTransitionBanners`|on 20160407, transitions(510), transition_target_members(52082), transition_banners(435)| thread=100, slave server=2, loop count=100,000 | tps = 8000 | max response < 1s, mean response = 25 ms|
getNextBox|on 20160325, subscription(2,980,191), order_calendar(8,413,559), shipment_day(857,582)| thread=50, slave server=2, loop count=200,000 | tps = 28000 | max response < 1s, mean response = 3.6 ms| on 20170109, subscription(1,427,685/5,762,064)(active/all), order_calendar(17,849,581)(active row count should be same as subscription table), shipment_day(340,164/1,231,910)

####Confidence Practise Example
Metrics gathering: 

* CPU Usage(%)
* Memory(MB)
* System Load(1 m)(System Load Average)
* tomcat.requestCount (count)
* tomcat.currentThreadBusy (count)(Thread Busy Tomcat number of HTTP Thread-pool)
* jvm.gc.fullgc.time (ms)
* tomcat.errorCount (count)
* nginx.request.500.count (count) 
* nginx.request.count(the total accumulated in the nginx logs and ssl-access.log number of access.log, Deutham collection)

####Database backup strategy

Backup in master DB are run every day at dawn. (Time will vary for each service, because backup data is stored in NAS, so network load needs to be distributed)
Mysql Enterprise Backup (Hot or Warm Backup) 
Some servers with large data size do not save data in NAS
Backup data remains for 2 days. If the DB size is huge, it  may remain for just one day.

Run daily test to see if backup is  successfully done and the data can be used after recovery.
Recovery takes from minimum 30 minutes to maximum 14  hours.

The Perf Zone DB is reconstructed and reconfigured by utilizing the backup data every week. 

####FDS processes

Current FDS ETL runs every 3 minutes, recursively, for example, 7:05 to etl from 7:00 to 7:03, then 7:08 to etl from 7:03 to 7:06

Limitations of current ETL strategy:
* Execution time
    - Currently it is done within 1 min and 46 secs. If this time increases to be more than 3 mins, we won't be able to do 3 mins sync.  
* Missing Deleted Data
    - Insert/update data are synced properly, but Delete data from Source DB is not reflected. Because current ETL extract data by where condition on modifiedDate column, viz. modifiedDate between XX and XX.

####Mysql replication delay and programmer guideline

Replication is synced on transaction level. Once committed, it is delivered to Slave's queue for sync. 

So the guideline says,  when you execute DML, write DML based on PK and commit 1 row at a time and allow 1 sec sleep per 1000.

####Tungsten practise on CDC(Change Data Capture)

Tungsten Replicator is one of the CDC solutions. CDC (Change Data Capture) is the feature to capture the changed data from Data Source and transfer and apply the data to Target System.  

1. Read Binlog files of MySQL from source 
2. Capture the changed data 
3. Generate the capture in THL and save it  
4. Get the generated THL to target via remote
5. Read the changed data in THL and load it on Memory Q(In-Memory Queue)
6. What's loaded on Memory Q(In-Memory Queue) is applied on target DB. Tungsten is in Java, so it is through JDBC  

`Transaction History Log (THL)`
It holds the data on __transaction level__, managed as file based on __GTID (Global Transaction ID)__. So it's designed to have multi-master configuration.  

MySQL directly reads Binary Log file during the step to transform the changed data from source to THL
Oracle interfaces with Oracle Change Data Capture(CDC). (Oracle requires setting for CDC. The script is provided) 

__Structure__
DB areconfigured as 3 layers: Standby, Consolidation, and Target.
Standby:    Standby DBs in real service
Standby -> Consolidation is configured as MySQL replication: 1 Consolidation server to maximum 6 Standby DBs. 
Consolidation -> Target:    Tungsten replicator 

`Why is it Standby-Consolidation-Target configuration instead of Standby-Target? (Why do we need Consolidation?)  `
1. As for Tungsten replication, parameter "binlog_format=row" needs to be applied. But we cannot use row base in real db server, hence using this way to configure similar to row base while it's not service server(means merely config standby db server to row base, but rather master db).
2. In order to add service or table to be synchronized in CDC structure, initial (data) loading is needed. And data inflow for source needs to be blocked, so as to sync the data between source and target. But CDC structure in real service cannot be done in this regard. (So only Standby DB server is blocked then)

####PureData System for Analytics(PDA)
PDA is a high-performance, scalable, `massively parallel` system that enables clients to gain insight from their data and perform analytics on `enormous data volumes`.

PDA, powered by Netezza technology, provides faster performance, is big data and business intelligence (BI) ready, and provides advanced security all in a wider range of appliance models.

####sysbench

[SysBench] is a modular, cross-platform and multi-threaded benchmark tool for evaluating OS parameters that are important for a system running a database under intensive load.

The idea of this benchmark suite is to quickly get an impression about system performance without setting up complex database benchmarks or even without installing a database at all.

[SysBench_1]

####Data volume example

The available space of the current system is expected to 2T, and 1.6T expansion about the point of use systems
master db: data 1T, backup 2T (about 2,000 million)
slave db: fusion io 1T (about 1,500 million)
Additional slave
When 2T expansion in the existing system: fusion io 2T, system 1 units (about 5,000 million)
When capacity expansion in the 3T system: fusion io 3T, system 1 units (about 6,500 million)


s_order04-mdb-prod01-mp 10.10.10.210
CPU : E5-2630 6core 2ea
MEM : 64GB
DISK : OS 300GB x2ea Raid 1  / DATA 600GB x6ea Raid 1+0
OS : CentOS 5.8 64bit

Santorini team equipment should be 1EA (mkt platform)
Fusion-io in the search team 3.2TB * 2EA, memory8GB * 6EA
Fusion-io 1.2TB * 8EA - use> 2EA (sdb3 and replacement)

Nimbo storage data sample
table                           row             data size       index size      sum
coupang.xe_cp_coupons           461 million     98g             230g            328G
doupang.coupon_receiver_info    62 million      5G              11G             16G

####Set up a virtual machine

1. https://www.virtualbox.org/wiki/Downloads
2. CentOS linux version 6 , x86_64  https://wiki.centos.org/Download
3, Network Connections
cd /etc/sysconfig/network-scripts
$ vi ifcfg-eth0
ONBOOT= yes 로 바꿔주기
$ reboot
4. In addition to root sudo permissions granted to user accounts
$ su 
# Root password input
$ chmod u+w /etc/sudoers
$ vi /etc/sudoers
[userId]   ALL=(ALL)    ALL 추가
$ chmod u-w /etc/sudoers 
sudo permissions obtained for # userId
5. install EPEL
$ Sudo yum install warm-release
http://www.cyberciti.biz/faq/installing-rhel-epel-repo-on-centos-redhat-7-x/
6. SELinux contrast settings related to the installation

$ sudo yum -y install policycoreutils-python

$ semanage port -l | grep http
 
$ semanage port -m -t http_port_t -p tcp 8000
$ semanage port -a -t http_port_t -p tcp 80

$ service httpd restart
7. Lower security level for the test
$ rpm -qa | grep iptables
iptables-1.4.7-9.el6.x86_64
iptables-ipv6-1.4.7-9.el6.x86_64

$ yum -y install iptables

$ service iptables status
$ service iptables stop

$ /usr/sbin/setsebool httpd_can_network_connect true

8. Installing Nginx 
The repository is yum package manager is not registered by default in the nginx.
Therefore, to install nginx via yum, you need to tell the repository for information that is nginx yum.


wget http://nginx.org/packages/centos/5/noarch/RPMS/nginx-release-centos-5-0.el5.ngx.noarch.rpm
rpm -ivh nginx-release-rhel-5.0.el5.ngx.noarch.rpm
sudo yum install nginx

service nginx start

--registers the nginx boot process.
chkconfig nginx on

9. Installing Tomcat
cd /usr/local/
yum install wget
wget http://mirror.apache-kr.org/tomcat/tomcat-7/v7.0.67/bin/apache-tomcat-7.0.67.tar.gz -O tomcat7.tar.gz
tar -zxvf tomcat7.tar.gz
cp -Rf apache-tomcat-7.0.67 /usr/local/tomcat
[root@localhost local]# cp -rf /usr/local/tomcat /usr/local/tomcat2

$ yum -y install java-1.7.0-openjdk
yum -y install yum-plugin-priorities
rpm -Uvh http://mirrors.dotsrc.org/jpackage/6.0/generic/free/RPMS/jpackage-release-6-3.jpp6.noarch.rpm
yum -y --nogpgcheck  install tomcat7-webapps

10. Preparing to Practice
$ cd /etc/nginx/conf.d
$ vi default.conf

upstream backend {
    server 127.0.0.1:8080;
    server 127.0.0.1:9090;
}

location /statistics {
    root /usr/share/nginx/html;
}

location / {
    proxy_pass http://backend/;
}

$ cd /usr/share/nginx/html
$ mkdir statistics
$ cp -rf ./nginx-logo.png ./statistics/test.png


####Akamai
__Akamai__ Technologies, Inc. is an American content delivery network (CDN) and cloud services provider headquartered in Cambridge, Massachusetts, in the United States. Akamai's content delivery network is one of the world's largest distributed computing platforms, responsible for serving between 15 and 30 percent of all web traffic.[6] The company operates a network of servers around the world and rents capacity on these servers to customers who want their websites to work faster by distributing content from locations close to the user. Over the years its customers have included Apple, Facebook, Bing, Valve, Twitter, eBay, Google, LinkedIn and healthcare.gov. When a user navigates to the URL of an Akamai customer, their browser is redirected to one of Akamai's copies of the website.

Web Application Firewall??

####Pinpoint

[Pinpoint] Pinpoint is an __APM (Application Performance Management)__ tool for large-scale distributed systems written in Java. Modelled after Dapper, Pinpoint provides a solution to help analyze the overall structure of the system and how components within them are interconnected by tracing transactions across distributed applications.

* Install agents without changing a single line of code
* Minimal impact on performance (approximately 3% increase in resource usage)

####Other facilities
`Chakra Max` for database access control
`Nimbo storage` for storage solution
ETL tool: `IBM InfoSphere DataStage` vs `TeraStream`

`IBM InfoSphere DataStage` is an ETL tool and part of the IBM Information Platforms Solutions suite and IBM InfoSphere. It uses a graphical notation to construct data integration solutions and is available in various versions such as the Server Edition, the Enterprise Edition, and the MVS Edition.(not free)

`TeraStream`™ is the high-performance data integration solution in conjunction with DB in a variety of server environments to do the core functional ETL routines (Extract, Transform, and Load). It can be efficiently applied to high-volume batch processing, real-time data connectivity and data conversion. It guarantees a differentiated file handling performance from the existing data integration solutions in market. (Brand Name: DataStreams, Place of Origin: South Korea)
[TeraStream ETL]

`MaxGauge` for MySQL/Oracle monitoring

`Upsource` for code review


###Miscellaneous

####Elastic Stack
#####ElasticSearch

[Elastic][elastic_home]

[Elasticsearch][elasticsearch_wiki] is a search engine based on __Lucene__. It provides a `distributed`, multitenant-capable full-text search engine with an HTTP web interface and schema-free JSON documents. Elasticsearch is developed in Java and is released as open source under the terms of the Apache License. Elasticsearch is the most popular enterprise search engine followed by `Apache Solr`, also based on Lucene.[1]
It is developed alongside a data collection and log parsing engine called **Logstash**, and an analytics and visualization platform called **Kibana**. The three products are designed to be used as an integrated solution, referred to as the **"ELK stack"**.

Elasticsearch is a distributed, **RESTful search** and analytics engine capable of solving a growing number of use cases. As the heart of the **Elastic Stack**, it centrally stores your data so you can discover the expected and uncover the unexpected.

[Elasticsearch Home][elasticsearch_home]

[Kibana][kibana_home] lets you visualize your Elasticsearch data and navigate the **Elastic Stack**

[Logstash][logstash_home] Centralize, Transform & Stash Your Data
Logstash is an open source, server-side data processing pipeline that ingests data from a multitude of sources simultaneously, transforms it, and then sends it to your favorite “stash.” (Ours is Elasticsearch, naturally.)

Logstash supports a variety of inputs that pull in events from a multitude of common sources, all at the same time. Easily ingest from your logs, metrics, web applications, data stores, and various AWS services, all in continuous, **streaming fashion**.

####Grafana

[Grafana] is most commonly used for visualizing time series data for Internet infrastructure and application analytics but many use it in other domains including industrial sensors, home automation, weather, and process control.

Supports Graphite, Elasticsearch, Prometheus, InfluxDB, OpenTSDB and KairosDB out of the box. Or use the plug-in functionality to add your own.

####BSF

__Bean Scripting Framework (BSF)__ is a set of Java classes which provides scripting language support within Java applications, and access to Java objects and methods from scripting languages. BSF allows one to write JSPs in languages other than Java while providing access to the Java class library. In addition, BSF permits any Java application to be implemented in part (or dynamically extended) by a language that is embedded within it. This is achieved by providing an API that permits calling scripting language engines from within Java, as well as an object registry that exposes Java objects to these scripting language engines.

`BSF 2.x supports several scripting languages currently`:
Javascript (using Rhino ECMAScript, from the Mozilla project)
NetRexx (an extension of the IBM REXX scripting language in Java)
Commons JEXL
Python (using Jython)
Tcl (using Jacl)
XSLT Stylesheets (as a component of Apache XML project's Xalan and Xerces)

`In addition, the following languages are supported with their own BSF engines`:
Java (using BeanShell, from the BeanShell project)
Groovy
Groovy Monkey
JLog (PROLOG implemented in Java)
JRuby
JudoScript
ObjectScript
ooRexx (Open Object Rexx), using BSF4ooRexx.

Apache BSF 3.x includes an implementation of JSR-223 (javax.script) and runs on Java 1.4 and Java 1.5. (Java 1.6 includes javax.script as standard.)

####TUNGSTEN REPLICATOR

[Tungsten Replicator][Tungsten_Replicator_git] is an open source replication engine supporting a variety of different extractor and applier modules. Data can be extracted from MySQL, Oracle and Amazon RDS, and applied to transactional stores, including MySQL, Oracle, and Amazon RDS; `NoSQL stores such as MongoDB`, and datawarehouse stores such as Vertica, `Hadoop`, and `Amazon RDS`.

During replication, Tungsten Replication assigns data a unique global transaction ID, and enables flexible statement and/or row-based replication of data. This enables data to be exchanged between different databases and different database versions. During replication, information can be filtered and modified, and deployment can be between on-premise or cloud-based databases. For performance, Tungsten Replicator includes support for `parallel replication`, and `advanced topologies such as fan-in and multi-master`, and can be used efficiently in cross-site deployments.

MySQL replication isn’t perfect and sometimes our data gets out of sync, either by a failure in replication or human intervention.

Multi-source replication was not possible using regular MySQL replication before. This is now a working feature in MariaDB 10 and also a feature coming with the new MySQL 5.7 

* Continuent Tungsten Clustering
    - Zero-downtime Maintenance
    - High Availability and Continuous Operations
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

####Linux Virtual Server(LVS)
The Linux Virtual Server is a highly scalable and highly available server built on a cluster of __real servers__, with the load balancer running on the Linux operating system. The architecture of the server cluster is fully transparent to end users, and the users interact as if it were a single high-performance virtual server.

The real servers and the load balancers may be interconnected by either high-speed LAN or by geographically dispersed WAN. The load balancers can dispatch requests to the different servers and make parallel services of the cluster to appear as a virtual service on a single IP address, and request dispatching can use IP load balancing technolgies or application-level load balancing technologies. Scalability of the system is achieved by transparently adding or removing nodes in the cluster. High availability is provided by detecting node or daemon failures and reconfiguring the system appropriately.

The Linux Virtual Server Project (LVS) implements __layer 4 switching__ in the Linux Kernel. This allows TCP and UDP sessions to to be load balanced between multiple real servers. Thus it provides a way to scale Internet services beyond a single host. HTTP and HTTPS traffic for the World Wide Web is probably the most common use. Though it can also be used for more or less any service, from email to the X Windows System.

LVS itself runs on Linux, however it is able to load balance connections `from end users running any operating system to real servers running any operating system`. As long as the connections use TCP or UDP, LVS can be used.

LVS is very high performance. It is able to handle upwards of `100,000 simultaneous connections`. It is easily able to load balance a saturated 100Mbit ethernet link using inexpensive commodity hardware. It is also able to load balance saturated 1Gbit link and beyond using higher-end commodity hardware.

####Nginx

NGINX is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server. NGINX is known for its high performance, stability, rich feature set, simple configuration, and low resource consumption.

NGINX is one of a handful of servers written to address the C10K problem. Unlike traditional servers, NGINX `doesn’t rely on threads to handle requests`. Instead it uses a much more scalable `event-driven (asynchronous) architecture`. This architecture uses small, but more importantly, predictable amounts of memory under load. Even if you don’t expect to handle thousands of simultaneous requests, you can still benefit from NGINX’s `high-performance and small memory footprint`. NGINX scales in all directions: from the smallest VPS all the way up to large clusters of servers.

NGINX can be deployed as a standalone web server, and as a frontend proxy for Apache and other web servers. This drop‑in solution acts as a network offload device in front of Apache servers, translating slow Internet‑side connections into fast and reliable server‑side connections, and completely offloading keepalive connections from Apache servers.

NGINX also acts as a shock absorber

The performance and scalability of NGINX arise from its event‑driven architecture. It differs significantly from Apache’s process‑or‑thread‑per‑connection approach – in NGINX, `each worker process can handle thousands of HTTP connections simultaneously`. This results in a highly regarded implementation that is lightweight, scalable, and high performance.

A downside of NGINX’s sophisticated architecture is that developing modules for it isn’t as simple and easy as with Apache. 

Editor – NGINX Plus Release 11 (R11) and open source NGINX 1.11.5 introduce binary compatibility for dynamic modules, including support for compiling custom and third‑party modules.

NGINX provides all of the core features of a web server, without sacrificing the lightweight and high‑performance qualities that have made it successful, and can also serve as a proxy that forwards HTTP requests to upstream web servers (such as an Apache backend) and FastCGI, memcached, SCGI, and uWSGI servers. `NGINX does not seek to implement the huge range of functionality necessary to run an application`, instead relying on specialized third‑party servers such as PHP‑FPM, Node.js, and even Apache.

And so emerged the architectural pattern of running NGINX at the frontend to act as the accelerator and shock absorber, and whatever technology is most appropriate for running applications at the backend.

To forward HTTP requests to upstream application components, the frontend needs to provide termination of HTTP, HTTPS, and HTTP/2 connections, along with “shock‑absorber” protection and routing. It also needs to offer basic logging and first‑line access control, implement global security rules, and offload HTTP heavy lifting (caching, compression) to optimize the performance of the upstream application.

This is where NGINX and NGINX Plus come into their element, providing these twelve features (among others) that make them ideal for microservices and containers:
Single, reliable entry point
Serve static content
Consolidated logging
SSL/TLS and HTTP/2 termination
Support multiple backend apps
Easy A/B testing
Scalability and fault tolerance
Caching (for offload and acceleration)
GZIP compression
Zero downtime
Simpler security requirements
Mitigate security and DDoS attacks

A monolithic architectural framework was sound practice when Apache was new and fresh, but app developers are finding that such an approach is no longer up to the task of delivering complex applications at the speed their businesses require. __Microservice architecture__ is emerging as the wave of the future for web apps and sites, and NGINX is perfectly poised to assume its place in that architecture as the ideal application delivery platform for the modern Web.

from compound wiki:
>Nginx also supports major functionalists which apache supports like the following. 
SSL/TLS
Virtual Hosts
Reverse Proxy
Load Balence??
Compression
URL rewrite

__use case__

ADC  ->  Nginx -> Tomcat (production env)
LVS -> Nginx  -> Tomcat (IT env)
1. ADC is device and LVS is software. They are both the LB(Load Balance) solution of Coupang
2. Nginx  is just used as a Web Server and Reverse Proxy.
3. Tomcat is the real application (10001, 20001)

Nginx is known for its speed in serving static pages, much faster than apache and keeping the machine resources very low.

__Apache vs Nginx__

__Apache’s process‑per‑connection model__
At that time, many network services were triggered from a master service called inetd; when a new network (TCP) connection was received, inetd would fork( ) and exec( ) a Unix process of the correct type to handle the connection. The process read the request on the connection, calculated the response and wrote it back down the connection, and then exited.

Apache took this model and ran with it. The biggest downside was the cost of forking a new httpd worker process for each new connection, and Apache developers quickly adopted a prefork model in which a pool of worker processes was created in advance, each ready and willing to accept one new HTTP connection.

The isolation and protection afforded by the one‑connection‑per‑process model made it very easy to insert additional code (in the form of modules) at any point in Apache’s web‑serving logic. 

Apache administrators try two temp solutions:
* limited the maximum number of httpd processes (typically to 256)
* disabled keepalive connections or reduced their duration

Two __Apache MPMs__ (called multi‑processing modules, or MPMs)
1. worker MPM:  The worker MPM replaced separate httpd processes with a small number of child processes that ran multiple worker threads and assigned one thread per connection. This was helpful on `many commercial versions of Unix (such as IBM’s AIX) where threads are much lighter weight than processes`, but is less effective on `Linux where threads and processes are just different incarnations of the same operating system entity`.

2. event MPM: extends the worker MPM by adding a separate listening thread that manages idle keepalive connections once the HTTP request has completed.

`Apache has gained a reputation as a bloated, overly complex, and performance‑limited web server that can be exploited by slow denial‑of‑service (DoS) attacks.`

Apache, the monolithic one‑server‑does‑all model is struggling.

####Memcached
#####Simple Spring Memcached (SSM)

[simple-spring-memcached] This project enables caching in Spring-managed beans, by using Java 5 Annotations and Spring/AspectJ AOP on top of the spymemcached or xmemcached client.

`Simple Spring Memcached`:  simple-spring-memcached-3.6.0.jar

[simple-spring-memcached-detail]

* Cache zone
Cache zone is a group of memcached servers (instances) supported by one of the available providers. Using cache zones data can be split across different groups of servers. It's useful when depending on type cached data should be separated and stored on dedicated servers, so one type of data doesn't influence (evict) another.

To store data on specific cache zone mark class or method with __@CacheName__ and provide name or alias of cache zone.

* Serialization
By default all objects stored in cache are serialized/deserialized using standard java serialization. Other serilization framework are suggested to be used.

* Runtime node switching
Memcached instances used by each cache zone can be change on the fly without redeploying or restarting application. This is available by invoking changeAddresses method on cache factory. 

Spring AOP is designed that method calls within the same object does not work (when a method calls b method within the same class, b method AOP doesn't work.)

`When Memcached Does not work`
* Memcached AOP inherits the characteristics of Spring AOP.
* Hence, private method is not going to be executed in Memcached AOP.
* Memcached AOP does not work when calling methods within the same class.
* It is recommended to give annotations at class level. Interface annotation sometimes does not work.

Thus, it is important to version the namespace upon change of cached class to avoid conflict.

```java
@CacheName(SubscribeOrderMemcachedConfig.CACHE_NAME)
@ReadThroughMultiCache(namespace = "get-product-multi-get-v1", expiration = 1800, option = @ReadThroughMultiCacheOption(generateKeysFromResult = true, skipNullsInResult = true))
public List<ProductDto> getProductsUseCache(@ParameterValueKeyProvider List<Long> productIds){
    List<ProductDto> productDtos = Lists.newArrayList();
    for (Long productId : productIds) {
        ProductDto product = getProduct(productId);
        if(product != null){
            productDtos.add(product);
        }
    }
    return productDtos;
}
```

```java

@CacheName(SubscribeOrderMemcachedConfig.CACHE_NAME)
class DefaultNextBoxDateCacheCore implements NextBoxDateCacheCore {
    @ReadThroughSingleCache(namespace = CacheSettings.NextCoupangBox.namespace, expiration = CacheSettings.NextCoupangBox.expiration)
    public CachedCoupangBox getFromCache(@NotNull @ParameterValueKeyProvider String memberId) {
        // nothing to implement
        return null;
    }

    @UpdateSingleCache(namespace = CacheSettings.NextCoupangBox.namespace, expiration = CacheSettings.NextCoupangBox.expiration)
    @ReturnDataUpdateContent
    public CachedCoupangBox setCache(@NotNull @ParameterValueKeyProvider String memberId, @NotNull CachedCoupangBox coupangBox) {
        return coupangBox;
    }

    @InvalidateSingleCache(namespace = CacheSettings.NextCoupangBox.namespace)
    public void removeCache(@NotNull @ParameterValueKeyProvider String memberId) {
        // nothing to implement
    }
}

```


```java
@Configuration
@ImportResource("classpath:simplesm-context.xml")
public class MemcachedConfig {

    @Autowired
    private Environment environment;

    // 20140610 아발론에서 셋팅한 초기값들을 javaconfig로 전환 by 쿵푸
    @Bean
    @DependsOn("cacheBase")
    public CacheFactory cacheFactory() {
        CacheFactory cacheFactory = new CacheFactory();
        cacheFactory.setCacheName("coupang");
        cacheFactory.setCacheAliases(Arrays.asList("member"));
        cacheFactory.setCacheClientFactory(new MemcacheClientFactoryImpl());
        cacheFactory.setAddressProvider(new DefaultAddressProvider(environment.getRequiredProperty("coupang.memcached.server")));
        CacheConfiguration configuration = new CacheConfiguration();
        configuration.setConsistentHashing(true);
        configuration.setOperationTimeout(Integer.parseInt(environment.getRequiredProperty("coupang.memcached.operation.timeout")));
        configuration.setUseBinaryProtocol(true);
        cacheFactory.setConfiguration(configuration);
        cacheFactory.setDefaultSerializationType(SerializationType.CUSTOM);

        GzipDecorationTranscoder customTranscoder = new GzipDecorationTranscoder();
        customTranscoder.setThreashold(10000);
        customTranscoder.setTranscoder(new KryoTranscoder(2097152));
        cacheFactory.setCustomTranscoder(customTranscoder);

        JsonObjectMapper jsonObjectMapper = new JsonObjectMapper();
        jsonObjectMapper.configure(MapperFeature.AUTO_DETECT_FIELDS, true);
        jsonObjectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        jsonObjectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

        cacheFactory.setJsonTranscoder(new JsonTranscoder(jsonObjectMapper));

        return cacheFactory;
    }

    @Bean
    public Settings settings() {
        Settings settings = new Settings();
        settings.setOrder(500);
        return settings;
    }
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:p="http://www.springframework.org/schema/p"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:ehcache="http://ehcache-spring-annotations.googlecode.com/svn/schema/ehcache-spring"
       xmlns:aop="http://www.springframework.org/schema/aop" xmlns:cache="http://www.springframework.org/schema/cache"
       xmlns:util="http://www.springframework.org/schema/util"
       xsi:schemaLocation="http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-3.2.xsd
        http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-3.2.xsd
        http://www.springframework.org/schema/aop http://www.springframework.org/schema/aop/spring-aop-3.2.xsd
        http://www.springframework.org/schema/cache http://www.springframework.org/schema/cache/spring-cache.xsd http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">

    <bean name="coupangMemcachedClient" class="com.google.code.ssm.CacheFactory">
        <property name="cacheName" value="coupang" />
        <property name="cacheAliases">
            <list>
                <value>member</value>
            </list>
        </property>
        <property name="cacheClientFactory">
            <bean name="cacheClientFactory" class="com.google.code.ssm.providers.spymemcached.MemcacheClientFactoryImpl" />
        </property>
        <property name="addressProvider">
            <bean class="com.google.code.ssm.config.DefaultAddressProvider">
                <property name="address" value="${coupang.memcached.server}" />
            </bean>
        </property>
        <property name="configuration">
            <bean class="com.google.code.ssm.providers.CacheConfiguration">
                <property name="consistentHashing" value="true" />
                <property name="operationTimeout" value="${coupang.memcached.operation.timeout}" />
                <property name="useBinaryProtocol" value="true" />
            </bean>
        </property>
        <property name="defaultSerializationType"
                  value="#{T(com.google.code.ssm.api.format.SerializationType).CUSTOM}" />
        <property name="customTranscoder">
            <bean class="com.coupang.common.inf.memcached.transcoder.GzipDecorationTranscoder">
                <property name="threashold" value="10000"/> <!-- 너무 작게 주면 CPU만 잡아먹고 압축률은 떨어짐 -->
                <property name="transcoder">
                    <bean class="com.coupang.common.inf.memcached.transcoder.KryoTranscoder">
                        <constructor-arg value="2097152" /> <!-- 2mb, gzip 때문에 1mb보다 많은 용량 확보 가능 -->
                    </bean>
                </property>
            </bean>
        </property>
    </bean>
</beans>
```

<entry key="coupang.memcached.server">10.10.5.222:11811</entry>
<entry key="coupang.memcached.operation.timeout">1000</entry>



#####Moxi Proxy

[moxi_git]
[moxi-guide]

moxi is a proxy capable of handling many connections for client applications, providing those clients simplified management and increased performance.  It can be used with memcached servers or a Membase Cluster hosting both membase and memcached type buckets.

`Handling Memcached failover`
Unlike a database with built in failover (master/slave model), you can usually only connect a client to a single Memcached server. If you specify multiple servers then these are used as part of the hashing to determine where the data gets stored, but there’s no concept of replication. This means if one Memcached node goes down, you lose the keys on that node. If you’re only connecting to a single node then you lose all Memcached.

The commercial product, __Membase__, handles this by providing replicated Memcached and failover functionality so if one node goes down, you can still access the other node(s) without any impact to the application.

Instead, you can use the __Moxi Memcached proxy__. This allows your application servers to connect to what looks like a single Memcached host but Moxi handles sending the queries to the correct Membase (or Memcached) node. It also communicates with Membase to determine the health of a node for failover purposes.

We have recently deployed Moxi to elimiate Memcached as a single point of failure. Our web nodes now connect to one of several local Moxi instances (one for each Memcached bucket) which proxy the connections out to the cluster. If one of the Memcached cluster nodes fails, our application never needs to know because Moxi will silently handle the failover.

Alternatively, with `Couchbase 1.8 (which is what Membase has been renamed to)`, you can use their client libraries to connect directly to your Couchbase instances with the failover support built into the libraries.

```shell
/opt/moxi/bin/moxi -z /pang/service/moxi/moxi.conf -t 11 -Z concurrency=1024,wait_queue_timeout=200,connect_timeout=400,connect_max_errors=6,connect_retry_interval=10000,downstream_conn_max=4,downstream_timeout=1000,cycle=200

/opt/moxi/bin/moxi -z /pang/service/moxi/moxi.conf
 
/pang/service/moxi/moxi.conf 
11811=memcached1:11211,memcached2:11211,memcached3:11211
```

-t no of threads, (here uses CPU physical core/ CPU physical core -1 ??)

Current standard web server 24 core. Physical 12 core.

?? Moxi uses consistent hash algorithm to guarantee same key on same servers, whereas LVS doesn't support it.
?? Moxi supports cluster nodes change on the fly.(The only changes moxi is set at the time of addition or deletion of memcached servers. If you are a client-side continues to look at only the LVS.)



#####Kryo Serializer
You may have a need to customize Kryo serialization library, especially when you use joda-time.
Most of customer serialization implementation can be found in https://github.com/magro/kryo-serializers

#####Spymemcached
A simple, asynchronous, single-threaded memcached client written in java.
[spymemcached_git]
[spymemcached_gc]

* Efficient storage of objects. General serializable objects are stored in their `serialized form` and optionally compressed if they meet criteria. Certain native objects are stored as tightly as possible (for example, a Date object generally consumes six bytes, and a Long can be anywhere from zero to eight bytes).
* Resilient to server and network outages. In many cases, a client operation can be replayed against a server if it goes away and comes back. In cases where it can't, it will communicate that as well. An exponential backoff(二进制指数回退) reconnect algorithm is applied when a memcached becomes unavailable, but asynchronous operations will queue up for the server to be applied when it comes back online.
* Operations are asynchronous. It is possible to issue a store and continue processing without having to wait for that operation to finish. It is even possible to issue a get, do some further processing, check the result of the get and cancel it if it doesn't return fast enough.
* There is only one thread for all processing. Regardless of the number of requests, threads using the client, or servers to which the client is connected, only one thread will ever be allocated to a given MemcachedClient.
Aggressively optimized. There are many optimizations that combine to provide high throughput.

#####memaslap

[memaslap] is a load generation and benchmark tool for memcached servers. It generates configurable workload such as threads, concurrencies, connections, run time, overwrite, miss rate, key size, value size, get/set proportion, expected throughput, and so on. Furthermore, it also testss data verification, expire-time verification, UDP, binary protocol, facebook test, replication test, multi-get and reconnection, etc.


####twemproxy (nutcracker)

[twemproxy]
twemproxy (pronounced "two-em-proxy"), aka nutcracker is a fast and lightweight proxy for memcached and redis protocol. It was built primarily to reduce the number of connections to the caching servers on the backend. This, together with protocol pipelining and sharding enables you to horizontally scale your distributed caching architecture.

?? it only supports text mode

####HTTP Pipeling vs Domain Sharding

https://www.fir3net.com/Networking/Protocols/http-pipelining-vs-domain-sharding.html

One of the key features to HTTP2.0 is the ability to interleave (i.e multiplex) multiple requests and responses across a single TCP connection. Resulting in Domain Sharding being considered counterproductive. 

`HTTP PIPELING`

Ok, first a little history. Within HTTP versions prior to HTTP 1.1 each request was sent over a separate TCP connection. HTTP 1.1 then introduced a feature called "Keep-Alive". This allowed for multiple requests to be sent over a single connection. However only a single request could be sent at once. When the request had been served i.e the response fully received the next request could be sent. This is also known as head-of-line-blocking. 

HTTP Pipeling was introduced and allowed the client to send multiple requests within a single TCP connection in parallel. 
However, Pipelining was still prone to head-of-line-blocking as `each response had to be completed before the next response could be sent`. Below is an example,

Consider the following,

1. Client sends 2 requests to the server in parallel for index.php and html.txt. index.php is received first.
2. Both requests are processed. php:60ms and txt:20ms.
3. Even though txt is processed first it is buffered until the php response is sent.
4. The txt response is sent once the php response is complete.

Because of the head-of-line blocking issues with HTTP Pipelining, along with many servers and proxies not supporting it due to problems with implementation Pipelining is typically disabled (by default) within browsers.

`DOMAIN SHARDING`

Because of the limited adoption of HTTP pipelining there was still a need for further optimisation techniques within the HTTP protocol to allow for HTTP requests/responses to be sent and received in parallel.

By default browsers open a maximum of 6 connections on a per domain basis. Domain Sharding simply means that the websites assets are spread across multiple domains. In turn maximising the amount of concurrent connections opened by the browser, allowing for a greater number of parallel downloads via HTTP.

However Domain Sharding does come with its own disadvantages. Such as the additional overhead/latency introduced with a) building extra TCP connections and b) performing additional Domain Name lookups.

SUMMARY

In essence both HTTP Pipelining and Domain Sharding allow for HTTP requests to be sent in parallel. But this is where the similarities end. With head-of-line-blocking and the limited adoption of HTTP Pipelining, Domain Sharding is the preferred choice when choosing between these 2 HTTP optimization 'techniques'. 

####Mesosphere (DC/OS)
#####Marathon
Marathon is a production-grade container orchestration platform for Mesosphere’s Datacenter Operating System (DC/OS) and Apache Mesos.


####Temp

Profiler tools: `Borland OptimizeIt or JProbe`

`org.joda.time.DateTimeComparator`

**Personally identifiable information (PII)** is any data that could potentially identify a specific individual. Any information that can be used to distinguish one person from another and can be used for de-anonymizing anonymous data can be considered PII. 

```java
int result = DateTimeComparator.getDateOnlyInstance().compare(today, notifyDate);
```

The abbreviation **viz.** (or viz without a full stop), short for the Latin videlicet, is used as a synonym for "namely", "that is to say", "to wit", or "as follows".

__On-premises software__ (sometimes abbreviated as "on-prem") is installed and runs on computers on the premises (in the building) of the person or organization using the software, rather than at a remote facility such as a server farm or cloud. On-premises software is sometimes referred to as “shrinkwrap” software, and off-premises software is commonly called “software as a service” ("SaaS") or “cloud computing”.

__Fan-in__ is the number of inputs a gate can handle
fan-in network 输入网络
fan-in factor 输入端数

__Network-attached storage (NAS)__ is a type of dedicated file storage device that provides local-area network local area network (LAN) nodes with file-based shared storage through a standard Ethernet connection.
NAS devices, which typically do not have a keyboard or display, are configured and managed with a browser-based utility program. Each NAS resides on the LAN as an independent network node and has its own IP address.

__Fraud Detection Systems(FDS)__ Cases of card companies breaching their customers’ personal information are on the rise. Therefore, the Korea Financial Supervisory Service advised PG (Payment Gateway) companies, as well as card companies, to build Fraud Detection Systems (hereafter FDS), and FDS has become a necessary part of all the Korean payment systems. 

```sql
truncate table oltp.ins_t"01";
  
let $i=1;
while($i<=100000)
{
  eval INSERT INTO oltp.ins_t"01" VALUES ("1",$i,now());
  inc $i;
}

```

__TeraStream__ A Simplified "IP Network" Service Delivery Model

rabbitmq:   http://127.0.0.1:15672/#/           guest/guest

__SPOF__: Single point of failure

__SourceTree__: git tools

__C10k__: its a name given to the issue of optimizing the web server software to handle large number of requsts at one time. In the range of 10000 requests at a time, hence the name

#####Transfer

__vitamin-project-skeleton: can help to create project complying to vitamin__

* prerequisite
Windows/Linux: http://www.groovy-lang.org/,  Linux users http://gvmtool.net/ 
http://groovy-lang.org/install.html

Mac:
1. Install HomeBrew. Open a terminal window, and execute:
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
2. brew install groovy
If the installation through the Man SDK,    see the three items.

* creating project here.  
groovy create_vitamin.groovy MyTrial 0.28.3.RELEASE 0.3.7.RELEASE
then find your project under ./build

膝盖伤病是跑者最常面临的，强化关节附近的肌肉才是不二法门。试试靠墙蹲姿训练，来强化双腿的上半部。背靠墙、双脚与肩同宽置于前。背贴着墙慢慢往下滑，使身体和大腿、大腿和小腿各呈90度，维持此姿势30至60秒，然后起身休息，共做3次。想要更有挑战性的话，就轮流提起你的脚后跟，顺便锻练小腿肌。 

如果要拉伸你右腿的髂胫束，那就左侧身体对墙站立，把右腿交叉放到左腿后面，左手扶墙，把身体重量放到右腿上，向墙倾斜，同时把右侧臀部向外推。在拉伸的时候一定要保持右脚和墙保持平行。你可以感受到臀部和髂胫束被拉伸（在这里是你右腿的右侧）。保持10秒钟，做10组。对于左腿也是如上所示，只是让你右侧身体对着墙，左腿放在右腿后面。

做好热身，加强下肢力量练习，跑步距离循序渐进，`如果本身没有存在膝关节不稳定，或者是其它的韧带的问题，不建议使用护膝`，如果是存在膝关节不稳，建议还是要控制跑步的量，然后护膝要选那种前面有个洞，可以把髌骨露出来的那种。

基本没用，护膝主要对那些球类运动的人有用，像足球的守门员要经常倒地，膝关节容易碰撞或者擦到地面，对他们有作用。

长跑的话，注意以下几点：
１.最好不要在水泥地跑，水泥地对关节的损害比较严重；
２.注意跑的动作，要脚尖或者是脚的前半部分先落地，这样与地面之间有一个缓冲，膝关节不易损伤。
３.选择合适的，最好是专业的慢跑鞋；
另外：
４.加强膝关节的柔韧性练习；
５.加强膝关节附近肌肉力量的练习。


https://www.zhihu.com/question/25341242

专业的护具应针对不同症状、不同运动特征及强度有不同的设计，跑者可依据使用目的和需求选择适合自己的护具。世界上护具大牌也不少，Mueller、LP、MacDavid等等种类样式繁多，如何选择也许是跑友关心的问题。今天，我们就以最常用的膝关节护具向跑友们介绍如何从琳琅满目的膝部护具中选择最适合自己的。

保暖型护膝：该类护膝由皮毛类、绒线类材料制成，没有弹性支撑及保护作用。不能作为护具佩戴，其唯一的功能是局部保暖。`这类广大跑友可以直接忽略了`

2、一般性保护使用一体成型全包裹式护膝；膝关节前方疼痛可使用开洞式护膝；膝关节下方疼痛使用髌骨带；



可能是经常用电脑，我的右前臂靠近上臂的关节附近，肌肉经常有疲劳的感觉，虽然不是剧痛，但隐隐约约的感觉不舒服，有时候腕关节也有类似的症状，是怎么回事？用什么药能有效消除？

病情分析：
你好，这种情况一般的情况来说，往往是由于软组织炎症的情况引起的这种症状的。往往是和长期用电脑有关的。`另外是有颈椎病的情况的`。
指导意见：
这种情况的情况往往是可以采用`按摩、针灸、理疗、中药的治疗的`。或配合外用药物的治疗的。自己可以用`热水袋热敷`的。

从你描述的情况，出现这些症状的原因一方面可能是由于长时间一个姿势引起的肌肉僵硬，再就是可能是由于颈椎引起的。
指导意见：
颈椎病是临床常见病，有年轻化的趋势，多见于长期伏案工作的人，可以去医院拍个片子或做个ct看看，可以通过休息和锻炼会逐渐的减轻的。再就是可以通过些外用药，针灸推拿等，注意休息和锻炼。

http://www.dxy.cn/bbs/thread/22916017#22916017
08年抬了个病人就落下了腰痛的毛病，加上最近工作太忙（大量书写病历，有手书的也有用电脑的，还给人做了很多针灸推拿治疗），双手劳损得严重，老是疼痛（疼痛和压痛部位：旋前圆肌处、桡侧腕屈肌、尺侧腕屈肌和掌长肌行程中段、拇深屈肌附着点、豌豆骨尺侧腕屈肌处、大鱼际内中1/3处、桡骨茎突），严重的时候夜间痛醒，旋前背伸或者提重物就加重。自己打过封闭（利多卡因+地塞米松）症状稍缓解，害怕神经有问题，在丁香园

意料中事，小手的肌肉劳损范围大，`建议适当锻炼+热敷`

`中药熏洗劳累的双手`

肌肉劳损是一种慢性的反复积累的微细损伤。常发生在肌肉活动过多或静态姿势下肌肉持久紧张的部位。可分为急、慢性两类。常见部位为腰、颈、腿部的肌肉。遇到问题总是能解决的哦别急。这些偏方都是有帮助的。
1. 乌龟肉250克、核桃仁100克。共煮熟服。用于慢性虚劳腰痛。
2. 桑寄生20克、猪骨250克。同煮汤。一般腰痛均可食。
3. 猪腰或羊腰1对,黑豆100克、茴香3克、生姜9克。共煮熟，吃腰子和豆，喝汤，可常食。对你病有好处。
`4. 还可试试用姜汁敷上患部后，贴上（由姜、面粉、马铃薯）制成的姜膏，然后用姜油擦拭患部效果更佳`
5. 也是最好的一个方法`日本的缤漮`是我一个国外同学给我带回来非常管用，辽校真的很牛，揪心的是，有点把贵。

如果是肌肉劳损的话，大多数是可以彻底康复的，但是修养的时间会长一些，请不要过于担心。
意见建议：`建议给予受伤部位的热敷或者是理疗`，`给予活血化瘀的药物外涂`，`另外避免受伤胳膊的负重，注意休息，注意保暖`

当地医生说是手指和手臂肌肉损伤、劳损问题。曾经擦过`扶他林`，贴过膏药，在小臂压痛处打过两次`封闭`，效果都不好。后又做过两次`小针刀`，还做过5次冲击波，现在小臂的

`针灸，热敷`，咨询针灸医生，平时自己穴位按摩，`增加血液循环好` `关键不要让有毛病的手臂不再劳累（不用劲，好好休息）`，保暖也很重要
慢慢会好的

`肌肉劳损实质是一种无菌性炎症`，主要表现为患处疼痛、压痛和功能障碍。劳损好发于支配多动或负重关节的肌肉或维系这些关节的韧带，尤其是肌肉或韧带在骨质上的附着点。长期、经常地重复某一特定的动作是造成超负荷使用的常见原因。`有了病咱们就慢慢治,平时注重锻炼,起居要避风、寒、湿，劳逸结合,加强身材高的素质,常常的加入体育的训练。日本的缤漮是我同学不断像我推介的良方，受到一致认可，无法承受的是，很费钱。`

建议你可以去正规的大型按摩店做针灸推拿治疗的，`肌肉劳损最好的治疗就是针灸推拿`

每天保证八小时的睡眠。（内分泌调整好）

肌肉劳损用药的话，最好是内服加外用了。
指导意见：
外用的中成药可以选用奇正消痛贴膏，也可以选用西药如扶他林乳膏剂等，或者用气雾剂好得快，口服止痛药如散利痛、西乐葆都可以指导意见：另外需要注意休息，不要过力，注意饮食营养。

`手臂受伤做什么运动好恢复`
(一)休息！休息！休息！ 如果锻炼中身体某部位感到某种异常的疼痛，就别再做下去了，应该彻底放松和休息。 
(二)弄清伤势 将受伤部位轻轻转动，随便做一些轻柔动作以确定哪些肌肉，肌腱，韧带疼痛或受了伤，这样就能知道治疗动作应该集中在何处，并在强烈锻炼时应该避开哪些动作。 
(三)不增加伤处的负担。 弄清受伤部位后，不仅仅不要做影响这些伤痛处的锻炼动作，就是在日常活动中，也须注意不给伤处增加负担，例如，后腰疼痛就别去提起重物，脚疼就要避免跑步。 
(四)`绕过伤处锻炼` 人体有600多块肌肉，因此，即使你伤了100块肌肉，你还有500多块肌肉可练，应该锻炼全部肌肉，才能改善你的健康，取得均匀发展，同时又能加强主要负重的股骨，伤处周围会存在可作意中人活动的肌肉，，例如，受伤或接任胫部肌肉阻碍整个下蹲的动作，但还允许做到半蹲动作，但必须小心从事，若活动时，有所不适，就应该让整个伤处肌群都得到休息。 
(五)`促进局部血液循环 `必须很仔细的测定受伤的部位，寻找一种能很轻柔地活动受伤部位的动作，用这种动作促进血液循环，以补充新鲜养料，清除废弃物质。 
(六)`轻轻伸展` 慢慢伸展伤处，直到一遇到有轻微抵触处即停止，然后试着放松损伤部位。这样做时，试试作进一步的伸展，当肌肉达到伸展和轻松时，起治疗作用的血液会更多的流往该处，就能更快得到治愈，但如伸展过分，就会导致创伤的恶化，甚至甚至再受伤。 
(七)`按摩` 轻轻的按摩能直接增进血液流量，可以自我搓揉，但更有效的解痛办法是自己放松，让一位懂推拿术的人给你推拿。 
(八)`热力` 热力能凭借人体自然的冷却反应而促进血液涌向身体表面，热力也能减缓受伤肌肉的紧张状态，从而使血液循环加速，给肌肉带来更多的营养物质。 
(九)冰敷 热力作用往往用于长期的受伤后的养治，而不能用作临场的急救，刚受伤即加热能造成伤处肿胀而引起组织进一步损伤，一般受伤后的48小时内，用冰敷可减轻肿胀。 
最后，`对于一般的肌肉拉伤，最好是针灸治疗`，效果会比较好。恢复得快，不会有什么后遗症。还有，看拉伤是否出血，如果没有，则可以热敷，同时，用点扶他林，有比较好的止痛效果。如果是由于运动量过大肌腱受伤可吃点三七伤痛药，对伤处擦红花油，不妨减小运动时间及强度，便可早日恢复。


甩手、瑜伽、跳绳、左右旋转等

摔臂和哑铃运动

具体方法：人体平躺，将木枕或其他硬枕头垫在脖子下面，手脚尽量垂直高举。手脚稍微分开伸直，脚底尽量保持水平，在这种姿势下轻轻抖动手指和脚趾1~2分钟。关键是贵在坚持，每天坚持锻炼，自然而然就会越做越好。(见图)

雷蛇炼狱蝰蛇普通版鼠标（RZ01-0015)雷蛇炼狱蝰蛇普通版鼠标（RZ01-0015)
Razer雷蛇DeathAdder 3500DPI炼狱蝰蛇鼠标驱动
http://download.pchome.net/driver/hardware/oi/mouse/detail-177705.html

http://drivers.razersupport.com/cn//index.php?_m=downloads&_a=viewdownload&downloaditemid=617&nav=0,76,11,116

Zookeeper
Host: 10.211.205.60,10.211.205.61,10.211.205.62
Pre-requisite:
mkdir -p /pang/logs/zookeeper
Init zookeeper docker container:  
10.211.205.60
docker run -d -e MYID=1 -e SERVERS=10.211.205.60,10.211.205.61,10.211.205.62 -v /pang/logs/zookeeper:/tmp/zookeeper --name=zookeeper --net=host --restart=always mesoscloud/zookeeper:3.4.7-ubuntu
10.211.205.61
docker run -d -e MYID=2 -e SERVERS=10.211.205.60,10.211.205.61,10.211.205.62 -v /pang/logs/zookeeper:/tmp/zookeeper --name=zookeeper --net=host --restart=always mesoscloud/zookeeper:3.4.7-ubuntu
10.211.205.62
docker run -d -e MYID=3 -e SERVERS=10.211.205.60,10.211.205.61,10.211.205.62 -v /pang/logs/zookeeper:/tmp/zookeeper --name=zookeeper --net=host --restart=always mesoscloud/zookeeper:3.4.7-ubuntu
Start:
docker start zookeeper
Stop:
docker stop zookeeper
Port: 2181
Mesos Master
Host: 10.211.205.214
Pre-requisite:
sudo apt-get install -y libsvn-dev libcurl4-nss-dev
mkdir -p /pang/logs/mesos/workspace
Install mesos:
cd /pang/program
wget http://xpoint.coupang.net:8082/service/local/repositories/releases/content/org/mesos/mesos/1.1.0-ubuntu-16.04-bin/mesos-1.1.0-ubuntu-16.04-bin.tar.gz
tar -xzf mesos-1.1.0-ubuntu-16.04-bin.tar.gz
ln -s /pang/program/mesos-1.1.0 mesos
Start:
nohup /pang/program/mesos/sbin/mesos-master --zk=zk://10.211.205.60:2181,10.211.205.61:2181,10.211.205.62:2181/mesos --work_dir=/pang/logs/mesos/workspace --log_dir=/pang/logs/mesos --logging_level=WARNING --cluster=XpointAwsProdCluster --quorum=1 --no-hostname_lookup > /pang/logs/mesos/master.log &
Stop:
sudo pkill -f mesos-master
Web ui: http://10.211.205.214:5050/
Mesos Slave
Host: 10.211.205.70,10.211.205.71,10.211.205.72,10.211.205.73,10.211.205.74,10.211.205.75,10.211.205.76,10.211.205.77,10.211.205.78,10.211.205.79,10.211.205.80
Pre-requisite:
sudo apt-get install -y libsvn-dev libcurl4-nss-dev
mkdir -p /pang/logs/mesos/workspace
Start:
Used by marathon job directly(10.211.205.70,10.211.205.71,10.211.205.72,10.211.205.73):
nohup sudo /pang/program/mesos/sbin/mesos-agent --master=zk://10.211.205.60:2181,10.211.205.61:2181,10.211.205.62:2181/mesos --attributes="role:marathon-job" --no-hostname_lookup --switch_user --resources="cpus:8;mem:6144" --work_dir=/pang/logs/mesos/workspace --log_dir=/pang/logs/mesos --containerizers=docker,mesos --executor_registration_timeout=5mins --executor_environment_variables="{\"JAVA_HOME\" : \"/pang/program/jdk\", \"PATH\" : \"/pang/program/jdk/bin:$PATH\" }" > /pang/logs/mesos/agent.log &

Used by spark executor(10.211.205.74,10.211.205.75,10.211.205.76,10.211.205.77,10.211.205.78,10.211.205.79,10.211.205.80):
nohup sudo /pang/program/mesos/sbin/mesos-agent --master=zk://10.211.205.60:2181,10.211.205.61:2181,10.211.205.62:2181/mesos --attributes="role:executor" --no-hostname_lookup --switch_user --resources="cpus:8;mem:6144" --work_dir=/pang/logs/mesos/workspace --log_dir=/pang/logs/mesos --containerizers=docker,mesos --executor_registration_timeout=5mins --executor_environment_variables="{\"JAVA_HOME\" : \"/pang/program/jdk\", \"PATH\" : \"/pang/program/jdk/bin:$PATH\" }" > /pang/logs/mesos/agent.log &

Used by system docker, such as kafka, mesos-ui – TODO(change the role attribute)
Stop:
sudo pkill -f mesos-agent
sudo rm -f /pang/service/mesos/meta/slaves/latest
Marathon
Host: 10.211.205.214
Pre-requisite:
mkdir -p /pang/logs/marathon
Init marathon docker container:  
docker run -d --name=xpoint-marathon --net=host --restart=always -v /pang/logs/marathon:/marathon/log:rw mesosphere/marathon:v1.3.6 --master zk://10.211.205.60:2181,10.211.205.61:2181,10.211.205.62:2181/mesos --zk zk://10.211.205.60:2181,10.211.205.61:2181,10.211.205.62:2181/marathon --http_port 8083 
Disable 8083 port access except localhost and nginx host(10.213.193.240). And set nginx proxy(8080 to 8083). Please refer to Marathon Authorization - by Nginx
sudo iptables -A INPUT -p tcp -s localhost --dport 8083 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8083 -j DROP
sudo iptables-save
Start:
docker start marathon
Stop:
docker stop marathon
Web ui: http://10.211.205.203:8080/
Marathon LB
Host: 10.211.205.214
Init marathon lb docker container:  
mkdir -p /pang/conf/marathon-lb
Copy marathon-lb/config.py(from https://github.com/mesosphere/marathon-lb) to /pang/conf/marathon-lb
Modify the 80 and 443 port(such as 10080 and 10443) in /pang/conf/marathon-lb/config.py
docker run -d --name=marathon-lb --net=host --restart=always -e PORTS=9090 -v /pang/conf/marathon-lb/config.py:/marathon-lb/config.py:ro mesosphere/marathon-lb:v1.4.3 sse --marathon http://127.0.0.1:8083 --group external
Start:
docker start marathon-lb
Stop:
docker stop marathon-lb
 
Nginx
Host: 10.211.205.214
Init nginx docker container:  
mkdir -p /pang/conf/nginx/conf.d /pang/logs/nginx /pang/service/nginx/webRoot
chmod a+wrx /pang/logs/nginx
Copy file(http://gitlab.coupang.net/xpoint/xpoint-core/blob/master/specification/aws-prod/nginx/nginx.conf) to /pang/conf/nginx/nginx.conf
Copy file(http://gitlab.coupang.net/xpoint/xpoint-core/blob/master/specification/aws-prod/nginx/status.conf) to /pang/conf/nginx/status.conf
Copy files in http://gitlab.coupang.net/xpoint/xpoint-core/tree/master/specification/aws-prod/nginx/conf.d to /pang/conf/nginx/conf.d
Download xpoint-dashboard from nexus(http://xpoint.coupang.net:8082/), unzip and rename as xpoint-chart in /pang/service/nginx/webRoot/ directory
Edit /pang/conf/docker/nginx/docker-compose.yml as below:
nginx:
  container_name: xpoint-nginx
  restart: always
  image: nginx:1.10
  net: "host"
  volumes:
    - /pang/conf/nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - /pang/conf/nginx/conf.d:/etc/nginx/conf.d:ro
    - /pang/logs/nginx:/pang/logs/nginx:rw
    - /pang/service/nginx/webRoot:/pang/service/nginx/webRoot:ro
docker-compose -f /pang/conf/docker/nginx/docker-compose.yml up -d
Start:
docker start xpoint-nginx
Stop:
docker stop xpoint-nginx
Kafka
Host: 10.211.205.60,10.211.205.61,10.211.205.62
Init kafka docker container:  
mkdir -p /pang/logs/kafka /pang/conf/kafka
chmod a+wrx /pang/logs/kafka
Copy config files to /pang/conf/kafka and modify server.properties (broker.id, advertised.host.name, num.partitions, log.retention.hours, zookeeper.connect, log.dirs: /logs). broker.id should be unique for each kafka instance.
Please refer to http://gitlab.coupang.net/xpoint/xpoint-core/tree/master/specification/aws-prod/kafka
docker run -d --name kafka --restart=always -v /pang/conf/kafka:/kafka/config:ro -v /pang/logs/kafka:/logs -p 9092:9092 -p 7203:7203 ches/kafka:0.9.0.1 /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
Start:
docker start kafka
Stop:
docker stop kafka
Port: 9092
 
Cassandra
Host: 10.211.205.63,10.211.205.64,10.211.205.65,10.211.205.66,10.211.205.67
Install cassandra:  
cd /pang/program
Download cassandra: http://downloads.datastax.com/community/dsc-cassandra-3.0.9-bin.tar.gz
tar -xzf dsc-cassandra-3.0.9-bin.tar.gz
rm dsc-cassandra-3.0.9-bin.tar.gz
ln -s /pang/program/dsc-cassandra-3.0.9 cassandra 
mkdir -p /pang/logs/cassandra/data
cd /pang/program/cassandra/conf
Modify the config file(cassandra.yaml). Please refer to http://gitlab.coupang.net/xpoint/xpoint-core/tree/master/specification/aws-prod/cassandra
cluster_name: 'XPoint Cluster'
 data_file_directories:
  - /pang/logs/cassandra/data
 commitlog_directory: /pang/logs/cassandra/commitlog
 saved_caches_directory: /pang/data/cassandra/saved_caches
  - seeds: "10.211.205.63,10.211.205.64,10.211.205.65"
 listen_address: ip_of_host
 rpc_address: ip_of_host
 endpoint_snitch: GossipingPropertyFileSnitch
Modify the jvm file(jvm.options). Please refer to http://gitlab.coupang.net/xpoint/xpoint-core/tree/master/specification/aws-prod/cassandra/jvm.options
Start:
export JVM_OPTS="-Xms5g -Xmx5g"
nohup /pang/program/cassandra/bin/cassandra -f 2>&1 > /pang/logs/cassandra/out.log &
Stop:
pkill -f CassandraDaemon
Port: 9042
 
Elasticsearch
Host: 10.211.205.68
Init elasticsearch docker container:  
mkdir -p /pang/logs/elasticsearch/data /pang/conf/elasticsearch /pang/service/elasticsearch/plugins
chmod a+wrx /pang/logs/elasticsearch/data /pang/logs/elasticsearch
Copy elasticsearch config to /pang/conf/elasticsearch
modify attribute in elasticsearch.yml. Please refer to http://gitlab.coupang.net/xpoint/xpoint-core/tree/master/specification/aws-dev/elasticsearch
cluster.name: all instances with one name
node.name: each instance with a uniq name
path.conf: /usr/share/elasticsearch/config
path.data: /pang/data/elasticsearch
path.logs: /pang/logs/elasticsearch
path.plugins: /pang/service/elasticsearch/plugins
network.host: ip for the instance
discovery.zen.ping.multicast.enabled: true
discovery.zen.ping.unicast.hosts: ["10.213.193.236"]

Copy elasticsearch plugins to /pang/service/elasticsearch/plugins(from monitoring-dev09-mv:/pang/program/elasticsearch/plugins)
Edit /pang/conf/docker/elasticsearch/docker-compose.yml as below:
elasticsearch:
  container_name: elasticsearch
  restart: always
  image: elasticsearch:1.7.5
  network: "host"
  environment:
    - ES_HEAP_SIZE=2g
  volumes:
    - /pang/conf/elasticsearch:/usr/share/elasticsearch/config:ro
    - /pang/data/elasticsearch:/pang/data/elasticsearch:rw 
    - /pang/logs/elasticsearch:/pang/logs/elasticsearch:rw 
    - /pang/service/elasticsearch/plugins:/pang/service/elasticsearch/plugins:ro
  command: elasticsearch -XX:-UseSuperWord
docker-compose -f /pang/conf/docker/elasticsearch/docker-compose.yml up -d
Start:
docker start elasticsearch
Stop:
docker stop elasticsearch
UI: http://10.211.205.203:9200/
 
Docker registery
Host: 10.211.205.69
Init docker registery container:  
mkdir -p /pang/conf/docker/registry /pang/logs/docker-registry
Edit /pang/conf/docker/registry/docker-compose.yml as below:
registry:
  container_name: xpoint-dev-docker-registry
  restart: always
  image: registry:2
  ports:
    - 5000:5000
  volumes:
    - /pang/logs/docker-registry:/var/lib/registry
docker-compose -f /pang/conf/docker/registry/docker-compose.yml up -d
Start:
docker start xpoint-dev-docker-registry
Stop:
docker stop xpoint-dev-docker-registry
UI: http://10.211.205.203:15000/v2/_catalog
http://10.211.205.214:15000/v2/<docker image name>/tags/list
docker image name such as: zookeeper, xpoint/spark-streaming-all-feed 
Jenkins
Host: 10.211.205.69
Init docker registery container:  
mkdir -p /pang/conf/docker/jenkins /pang/logs/jenkins
Edit /pang/conf/docker/jenkins/docker-compose.yml as below:
jenkins:
  container_name: xpoint-jenkins
  restart: always
  image: 10.211.205.214:15000/xpoint/jenkins:2.7.1
  user: coupang:1002
  ports:
    - 8080:8080
    - 50000:50000
  volumes:
    - /pang/logs/jenkins:/var/jenkins_home
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - /usr/bin/docker:/usr/bin/docker:ro
docker-compose -f /pang/conf/docker/jenkins/docker-compose.yml up -d
Start:
docker start xpoint-jenkins
Stop:
docker stop xpoint-jenkins
UI: http://10.211.205.203:8081/

CC0034  Joy Jin 金英花     HR Manager  0501    D01 jjin@coupang.com    live:yeeunghua

CC0060  Fiona Zhang     张志芳     Recruiter   0526    D06 fzhang@coupang.com  603768442@qq.com

Forward Ventures, Ltd.
韩国地市：501, Teheran-ro, Gangnam-gu, Seoul, Republic of Korea
韩国电话： 02-6150-5450
营业执照号码是：120-88-00767
上海公司电话:  021-6156-0500

welcome000

###Appendix

---
[webview_strategy]:http://www.human-element.com/webview-strategy-creating-mobile-apps-part-13/ "Webview Strategy"
[PhoneGap]:http://phonegap.com/ "PhoneGap"
[jmeter dynamic HTML report]:http://jmeter.apache.org/usermanual/generating-dashboard.html "Generating Report Dashboard"
[jmeter_quick_guide]:http://www.tutorialspoint.com/jmeter/jmeter_quick_guide.htm
[jmeter_test_example_entire_flow]:https://wiki.compound.net:8443/pages/viewpage.action?pageId=29227149
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