# 			Digest of Learning Spark
## 				by Holden Karau, Andy Konwinski, Patrick Wendell, and Matei Zaharia
## 				February 2015: First Edition
---
## Indexes
* [Recommendations](#recommendations)
* [Chapter 1. Introduction to Data Analysis with Spark](#chapter-1-introduction-to-data-analysis-with-spark)
    - [A Unified Stack](#a-unified-stack)
    - [Data Science Task](#data-science-task)
    - [Data Processing Applications](#data-processing-applications)
* [Chapter 2. Downloading Spark and Getting Started](#chapter-2-downloading-spark-and-getting-started)
    - [Using IPython](#using-ipython)
    - [Introduction to Core Spark Concepts](#introduction-to-core-spark-concepts)
    - [Standalone Applications](#standalone-applications)
* [Chapter 3. Programming with RDDs](#chapter-3-programming-with-rdds)
    - [RDD Basics](#rdd-basics)
    - [Creating RDDs](#creating-rdds)
    - [RDD Operations](#rdd-operations)
        + [Lazy Evaluation](#lazy-evaluation)
    - [Passing Functions to Spark](#passing-functions-to-spark)
    - [Common Transformations and Actions](#common-transformations-and-actions)
        + [Basic RDDs](#basic-rdds)
            * [Element-wise transformations](#element-wise-transformations)
            * [Pseudo set operations](#pseudo-set-operations)
            * [Actions](#basic-rdds-actions)
        + [Converting Between RDD Types](#converting-between-rdd-types)
    - [Persistence Caching](#persistence-caching)
* [Chapter 4. Working with Key/Value Pairs](#chapter-4-working-with-key/value-pairs)
    - [Creating Pair RDDs](#creating-pair-rdds)
    - [Transformations on Pair RDDs](#transformations-on-pair-rdds)
        + [Aggregations](#aggregations)
        + [Tuning the level of parallelism](#tuning-the-level-of-parallelism)
        + [Grouping Data](#grouping-data)
        + [Joins](#joins)
        + [Sorting Data](#sorting-data)
    - [Actions Available on Pair RDDs](#actions-available-on-pair-rdds)
    - [Data Partitioning (Advanced)](#data-partitioning-advanced)
        + [Determining an RDD’s Partitioner](#determining-an-rdds-partitioner)
        + [Operations That Benefit from Partitioning](#operations-that-benefit-from-partitioning)
        + [Operations That Affect Partitioning](#operations-that-affect-partitioning)
        + [Example: PageRank](#example-pagerank)
        + [Custom Partitioners](#custom-partitioners)
* [Chapter 5. Loading and Saving Your Data](#chapter-5-loading-and-saving-your-data)
    - [File Formats](#file-formats)
        + [Text Files](#text-files)
        + [JSON](#json) 
        + [Comma-Separated Values and Tab-Separated Values](#comma-separated-values-and-tab-separated-values)
        + [SequenceFiles](#sequencefiles)
        + [Object Files](#object-files)
        + [Hadoop Input and Output Formats](#hadoop-input-and-output-formats)
            * [Example: Protocol buffers](#example-protocol-buffers)
        + [File Compression](#file-compression)
    - [Filesystems](#filesystems)
        + [Local/“Regular” FS](#localregular-fs)
        + [Amazon S3](#amazon-s3)
        + [HDFS](#hdfs)
        + [Structured Data with Spark SQL](#structured-data-with-spark-sql)
            * [Apache Hive](#apache-hive)
            * [JSON](#json-1)
        + [Databases](#databases)
            * [Java Database Connectivity](#java-database-connectivity)
            * [Cassandra](#cassandra)
            * [HBase](#hbase)
            * [Elasticsearch](#elasticsearch)
* [Chapter 6. Advanced Spark Programming](#chapter-6-advanced-spark-programming)
    - [Accumulators](#accumulators)
        + [Accumulators and Fault Tolerance](#accumulators-and-fault-tolerance)
        + [Custom Accumulators](#custom-accumulators)
    - [Broadcast Variables](#broadcast-variables)
        + [Optimizing Broadcasts](#optimizing-broadcasts)
    - [Working on a Per-Partition Basis](#working-on-a-per-partition-basis)
    - [Piping to External Programs](#piping-to-external-programs)
    - [Numeric RDD Operations](#numeric-rdd-operations)
* [Chapter 7. Running on a Cluster](#chapter-7-running-on-a-cluster)
    - [Spark Runtime Architecture](#spark-runtime-architecture)
        + [The Driver](#the-driver)
        + [Executors](#executors)
        + [Cluster Manager](#cluster-manager)
    - [Deploying Applications with spark-submit](#deploying-applications-with-spark-submit)
    - [Packaging Your Code and Dependencies](#packaging-your-code-and-dependencies)
    - [Scheduling Within and Between Spark Applications](#scheduling-within-and-between-spark-applications)
    - [Cluster Managers](#cluster-managers)
        + [Standalone Cluster Manager](#standalone-cluster-manager)
        + [Hadoop YARN](#hadoop-yarn)
        + [Apache Mesos](#apache-mesos)
        + [Amazon EC2](#amazon-ec2)
    - [Which Cluster Manager to Use?](#which-cluster-manager-to-use?)
* [Chapter 8. Tuning and Debugging Spark](#chapter-8-tuning-and-debugging-spark)
    - [Configuring Spark with SparkConf](#configuring-spark-with-sparkconf)
    - [Components of Execution: Jobs, Tasks, and Stages](#components-of-execution-jobs-tasks-and-stages)
    - [Finding Information](#finding-information)
        + [Spark Web UI](#spark-web-ui)
        + [Driver and Executor Logs](#driver-and-executor-logs)
    - [Key Performance Considerations](#key-performance-considerations)
        + [Level of Parallelism](#level-of-parallelism)
        + [Serialization Format](#serialization-format)
        + [Memory Management](#memory-management)
        + [Hardware Provisioning](#hardware-provisioning)
* [Chapter 9. Spark SQL](#chapter-9-spark-sql)
    - [Linking with Spark SQL](#linking-with-spark-sql)
    - [Using Spark SQL in Applications](#using-spark-sql-in-applications)
        + [SchemaRDDs](#schemardds)
    - [Loading and Saving Data](#loading-and-saving-data)
        + [Apache Hive](#loading-and-saving-data-apache-hive)
        + [Parquet](#loading-and-saving-data-parquet)
        + [JSON](#loading-and-saving-data-json)
        + [From RDDs](#loading-and-saving-data-from-rdds)
    - [JDBC/ODBC Server](#jdbcodbc-server)
        + [Working with Beeline](#working-with-beeline)
        + [Long-Lived Tables and Queries](#long-lived-tables-and-queries)
        + [Standalone Spark SQL Shell](#standalone-spark-sql-shell)
    - [User-Defined Functions](#user-defined-functions)
    - [Spark SQL Performance](#spark-sql-performance)
* [Chapter 10. Spark Streaming](#chapter-10-spark-streaming)
    - [Architecture and Abstraction](#architecture-and-abstraction)
    - [Transformations](#stream-transformations)
        + [Stateless Transformations](#stateless-transformations)
        + [Stateful Transformations](#stateful-transformations)
            * [Windowed transformations](#windowed-transformations)
            * [UpdateStateByKey transformation](#updatestatebykey-transformation)
        + [Output Operations](#stream-output-operations)
    - [Input Sources](#stream-input-sources)
        + [Core Sources](#core-sources)
            * [Stream of files](#stream-of-files)
            * [Akka actor stream](#akka-actor-stream)
        + [Additional Sources](#additional-sources)
            * [Apache Kafka](#apache-kafka)
            * [Apache Flume](#apache-flume)
        + [24/7 Operation](#247-operation)
            * [Checkpointing](#checkpointing)
            * [Driver Fault Tolerance](#driver-fault-tolerance)
            * [Worker Fault Tolerance](#worker-fault-tolerance)
            * [Receiver Fault Tolerance](#receiver-fault-tolerance)
        + [Streaming UI](#streaming-ui)
            * [Performance Considerations](#streaming-performance-considerations)
                - [Batch and Window Sizes](#batch-and-window-sizes)
                - [Level of Parallelism](#steamings-level-of-parallelism)
                - [Garbage Collection and Memory Usage](#garbage-collection-and-memory-usage)
* [Miscellaneous](#miscellaneous)

## Recommendations
If you are a data scientist and don’t have much experience with Python, the books [Learning Python] and [Head First Python] (both O’Reilly) are excellent introductions. If you have some Python experience and want more, [Dive into Python] (Apress) is a great book to help you get a deeper understanding of Python.  

If you are an engineer and after reading this book you would like to expand your data analysis skills, [Machine Learning for Hackers] and [Doing Data Science] are excellent books (both O’Reilly).

[Code Examples] on github  

The easiest way to demonstrate the power of Spark’s shells is to start using one of them for some simple data analysis. Let’s walk through the example from the [Quick Start Guide] in the official Spark documentation.

>Note that, before Spark 2.0, the main programming interface of Spark was the Resilient Distributed Dataset (RDD). After Spark 2.0, RDDs are replaced by Dataset, which is strongly-typed like an RDD, but with richer optimizations under the hood. The RDD interface is still supported, and you can get a more complete reference at the RDD programming guide. However, we highly recommend you to switch to use Dataset, which has better performance than RDD. See the SQL programming guide to get more information about Dataset.

## Chapter 1. Introduction to Data Analysis with Spark
Apache Spark is a cluster computing platform designed to be fast and general-purpose.

On the speed side, Spark `extends the popular MapReduce model` to efficiently support more types of computations, including interactive queries and stream processing. One of the main features Spark offers for speed is the ability to `run computations in memory`, but the system is also more efficient than MapReduce for complex applications running on disk.

On the generality side, Spark is designed to cover a wide range of workloads that previously required separate distributed systems, including batch applications, iterative algorithms, interactive queries, and streaming. (PS: Machine learning, ETL, Graphic computation)

Spark is designed to be highly accessible, offering simple APIs in Python, Java, Scala, and SQL, and rich built-in libraries. It also integrates closely with other Big Data tools. In particular, Spark can run in Hadoop clusters and access any Hadoop data source, including Cassandra.

### A Unified Stack
The Spark project contains multiple closely integrated components. `At its core`, Spark is a “computational engine” that is responsible for scheduling, distributing, and monitoring applications consisting of many computational tasks across many worker machines, or a computing cluster. Because the core engine of Spark is both fast and general-purpose, it powers multiple higher-level components specialized for various workloads, such as SQL or machine learning. These components are designed to interoperate closely, letting you combine them like libraries in a software project.

Finally, one of the largest advantages of tight integration is the ability to build applications that seamlessly combine different processing models. For example, in Spark you can write one application that uses machine learning to classify data in real time as it is ingested from streaming sources. Simultaneously, analysts can query the resulting data, also in real time, via SQL (e.g., to join the data with unstructured logfiles). In addition, more sophisticated data engineers and data scientists can access the same data via the Python shell for ad hoc analysis. Others might access the data in standalone batch applications. All the while, the IT team has to maintain only one system.

![spark_unified_stack_img_1]  

* Spark Core  
Spark Core contains the basic functionality of Spark, including components for task scheduling, memory management, fault recovery, interacting with storage systems, and more. Spark Core is also home to the API that defines `resilient distributed datasets (RDDs)`, which are Spark’s main programming abstraction. RDDs represent a collection of items distributed across many compute nodes that can be manipulated in parallel. Spark Core provides many APIs for building and manipulating these collections.  
* Spark SQL  
Spark SQL is Spark’s package for working with structured data. It allows querying data via `SQL` as well as the Apache Hive variant of SQL — called the `Hive Query Language (HQL) `— and it supports many sources of data, including Hive tables, Parquet, and JSON. Beyond providing a SQL interface to Spark, `Spark SQL allows developers to intermix SQL queries with the programmatic data manipulations supported by RDDs in Python, Java, and Scala`, all within a single application, thus combining SQL with complex analytics. This tight integration with the rich computing environment provided by Spark makes Spark SQL unlike any other open source data warehouse tool.  
* Spark Streaming  
Spark Streaming is a Spark component that enables processing of live streams of data. Examples of data streams include logfiles generated by production web servers, or queues of messages containing status updates posted by users of a web service. `Spark Streaming provides an API for manipulating data streams that closely matches the Spark Core’s RDD API`, making it easy for programmers to learn the project and move between applications that manipulate data stored in memory, on disk, or arriving in real time. Underneath its API, Spark Streaming was designed to provide the same degree of fault tolerance, throughput, and scalability as Spark Core.  
* MLlib  
Spark comes with a library containing common machine learning (ML) functionality, called MLlib. MLlib provides multiple types of machine learning algorithms, including classification, regression, clustering, and collaborative filtering, as well as supporting functionality such as model evaluation and data import. It also provides some lower-level ML primitives, including a generic gradient descent optimization algorithm. All of these methods are designed to scale out across a cluster.   
* GraphX  
GraphX is a library for manipulating graphs (e.g., a social network’s friend graph) and performing graph-parallel computations. Like Spark Streaming and Spark SQL, GraphX extends the Spark RDD API, allowing us to create a directed graph with arbitrary properties attached to each vertex and edge. GraphX also provides various operators for manipulating graphs (e.g., subgraph and mapVertices) and a library of common graph algorithms (e.g., PageRank and triangle counting).
* Cluster Managers  
Under the hood, Spark is designed to efficiently scale up from one to many thousands of compute nodes. To achieve this while maximizing flexibility, Spark can run over a variety of cluster managers, including `Hadoop YARN, Apache Mesos`, and a simple cluster manager included in Spark itself called the `Standalone Scheduler`. If you are just installing Spark on an empty set of machines, the Standalone Scheduler provides an easy way to get started;

### Data Science Task
While there is no standard definition, for our purposes a data scientist is somebody whose main task is to `analyze and model data`. Data scientists may have experience with `SQL, statistics, predictive modeling (machine learning), and programming, usually in Python, Matlab, or R`. Data scientists also have experience with techniques necessary to transform data into formats that can be analyzed for insights (sometimes referred to as data wrangling).

Data scientists use their skills to analyze data with the goal of answering a question or discovering insights. `Oftentimes, their workflow involves ad hoc analysis`, so they use interactive shells (versus building complex applications) that let them see results of queries and snippets of code in the least amount of time. Spark’s speed and simple APIs shine for this purpose, and its built-in libraries mean that many algorithms are available out of the box.

Spark supports the different tasks of data science with a number of components. The Spark shell makes it easy to do interactive data analysis using Python or Scala. `Spark SQL also has a separate SQL shell` that can be used to do data exploration using SQL, or `Spark SQL can be used as part of a regular Spark program or in the Spark shell`. Machine learning and data analysis is supported through the MLLib libraries. In addition, `there is support for calling out to external programs in Matlab or R`. Spark enables data scientists to tackle problems with larger data sizes than they could before with tools like R or Pandas.

Sometimes, after the initial exploration phase, the work of a data scientist will be “productized,” or extended, hardened (i.e., made fault-tolerant), and tuned to become a production data processing application, which itself is a component of a business application. Often it is a different person or team that leads the process of productizing the work of the data scientists, and that person is often an engineer.

### Data Processing Applications
The other main use case of Spark can be described in the context of the engineer persona.  
For our purposes here, we think of engineers as a large class of software developers who use Spark to build production data processing applications.  
The modular nature of the API (based on passing distributed collections of objects) makes it easy to factor work into reusable libraries and `test it locally`.  


Spark started in 2009 as a research project in the UC Berkeley RAD Lab, later to become the AMPLab. The researchers in the lab had previously been working on Hadoop MapReduce, and observed that` MapReduce was inefficient for iterative and interactive computing jobs`. Thus, from the beginning, `Spark was designed to be fast for interactive queries and iterative algorithms`, bringing in ideas like support for `in-memory storage and efficient fault recovery`.

In addition to UC Berkeley, major contributors to Spark include Databricks, Yahoo!, and Intel.

In 2011, the AMPLab started to develop higher-level components on Spark, such as Shark (Hive on Spark, now replaced by Spark SQL.) and Spark Streaming. These and other components are sometimes referred to as the [Berkeley Data Analytics Stack (BDAS)].

Spark can create distributed datasets from any file stored in the Hadoop distributed filesystem (HDFS) or other storage systems supported by the Hadoop APIs (including your local filesystem, Amazon S3, Cassandra, Hive, HBase, etc.). `It’s important to remember that Spark does not require Hadoop; it simply has support for storage systems implementing the Hadoop APIs`. Spark supports text files, SequenceFiles, Avro, Parquet, and any other Hadoop InputFormat.

## Chapter 2. Downloading Spark and Getting Started

Spark itself is written in Scala, and runs on the Java Virtual Machine (JVM). `To run Spark on either your laptop or a cluster, all you need is an installation of Java 6 or newer`. If you wish to use the Python API you will also need a Python interpreter (version 2.6 or newer). Spark does not yet work with Python 3.

Spark comes with interactive shells that enable ad hoc data analysis.  

Because Spark can load data into memory on the worker nodes, many distributed computations, even ones that process terabytes of data across dozens of machines, can run in a few seconds. This makes the sort of iterative, ad hoc, and `exploratory analysis` commonly done in shells a good fit for Spark. `Spark provides both Python and Scala shells` that have been augmented to support connecting to a cluster.

The easiest way to demonstrate the power of Spark’s shells is to start using one of them for some simple data analysis. Let’s walk through the example from the [Quick Start Guide] in the official Spark documentation.

>Note that, before Spark 2.0, the main programming interface of Spark was the Resilient Distributed Dataset (RDD). After Spark 2.0, RDDs are replaced by Dataset, which is strongly-typed like an RDD, but with richer optimizations under the hood. The RDD interface is still supported, and you can get a more complete reference at the [RDD programming guide]. However, we highly recommend you to switch to use Dataset, which has better performance than RDD. See the [SQL programming guide] to get more information about Dataset.

The first step is to open up one of Spark’s shells. To open the Python version of the Spark shell, which we also refer to as the PySpark Shell, go into your Spark directory and type:  
```shell
bin/pyspark
```
(Or bin\pyspark in Windows.) To open the Scala version of the shell, type:  
```shell
bin/spark-shell
```

### Using IPython
IPython is an enhanced Python shell that many Python users prefer, offering features such as tab completion. You can find instructions for installing it at http://ipython.org. You can use IPython with Spark by setting the IPYTHON environment variable to 1:  
```shell
IPYTHON=1 ./bin/pyspark
```
On Windows, set the variable and run the shell as follows:  
```shell
set IPYTHON=1
bin\pyspark
```

### Introduction to Core Spark Concepts
```python
>>> sc
<pyspark.context.SparkContext object at 0x1025b8f90>
```

Some codes from new Dataset API  
```shell
scala> val textFile = spark.read.textFile("/home/hadoop/workspace/learning-spark/README.md")
textFile: org.apache.spark.sql.Dataset[String] = [value: string]

scala> textFile.count
res3: Long = 36

scala> textFile.first()
res4: String = [![buildstatus](https://travis-ci.org/holdenk/learning-spark-examples.svg?branch=master)](https://travis-ci.org/holdenk/learning-spark-examples)
```

```scala
/* SimpleApp.scala */
import org.apache.spark.sql.SparkSession

object SimpleApp {
  def main(args: Array[String]) {
    val logFile = "YOUR_SPARK_HOME/README.md" // Should be some file on your system
    val spark = SparkSession.builder.appName("Simple Application").getOrCreate()
    val logData = spark.read.textFile(logFile).cache()
    val numAs = logData.filter(line => line.contains("a")).count()
    val numBs = logData.filter(line => line.contains("b")).count()
    println(s"Lines with a: $numAs, Lines with b: $numBs")
    spark.stop()
  }
}
```
Unlike the earlier examples with the Spark shell, which initializes its own **SparkSession**, we initialize a SparkSession as part of the program. We call `SparkSession.builder` to construct a [[SparkSession]], then set the application name, and finally call getOrCreate to get the [[SparkSession]] instance.

http://[ipaddress]:4040. You can access the Spark UI there and see all sorts of information about your tasks and cluster.

At a high level, every Spark application consists of a `driver program` that launches various parallel operations on a cluster. The driver program contains your application’s main function and defines distributed datasets on the cluster, then applies operations to them. In the preceding examples, the driver program was the Spark shell itself, and you could just type in the operations you wanted to run.

Driver programs access Spark through a **SparkContext** object, which represents a connection to a computing cluster. In the shell, a SparkContext is automatically created for you as the variable called `sc`.
```shell
scala> sc
res5: org.apache.spark.SparkContext = org.apache.spark.SparkContext@7053b64b
```

```shell
scala> val textFile1 = sc.textFile("/home/hadoop/workspace/learning-spark/README.md")
textFile1: org.apache.spark.rdd.RDD[String] = /home/hadoop/workspace/learning-spark/README.md MapPartitionsRDD[19] at textFile at <console>:24
```
Once you have a SparkContext, you can use it to build RDDs. In Examples 2-1 and 2-2, we called sc.textFile() to create an RDD representing the lines of text in a file.  

Because we just ran the Spark shell locally, it executed all its work on a single machine — but you can connect the same shell to a cluster to analyze data in parallel. Figure 2-3 shows how Spark executes on a cluster.  
![spark_distributed_execution_img_1]   
**Figure 2-3. Components for distributed execution in Spark**  

Finally, a lot of Spark’s API revolves around passing functions to its operators to run them on the cluster. For example, we could extend our README example by filtering the lines in the file that contain a word, such as Python, as shown in Example 2-4 (for Python) and Example 2-5 (for Scala).

```python
>>> lines = sc.textFile(“README.md”)
>>> pythonLines = lines.filter(lambda line: “Python” in line)
>>> pythonLines.first()
u’## Interactive Python Shell’

def hasPython(line):
    return “Python” in line
pythonLines = lines.filter(hasPython)
```

```scala
scala> val lines = sc.textFile(“README.md”) // Create an RDD called lines
lines: spark.RDD[String] = MappedRDD[…]
scala> val pythonLines = lines.filter(line => line.contains(“Python”))
pythonLines: spark.RDD[String] = FilteredRDD[…]
scala> pythonLines.first()
res0: String = ## Interactive Python Shell
```
For Java, 
```java
JavaRDD<String> pythonLines = lines.filter(
    new Function<String, Boolean>() {
        Boolean call(String line) { 
            return line.contains(“Python”); 
        }
    }
);

// Java 8 introduces lambda
JavaRDD<String> pythonLines = lines.filter(line -> line.contains(“Python”));
```
A lot of its magic is that function-based operations like `filter` also parallelize across the cluster. That is, Spark automatically takes your function (e.g., line.contains(“Python”)) and ships it to executor nodes. Thus, you can write code in a single driver program and automatically have parts of it run on multiple nodes.  

### Standalone Applications

The final piece missing in this quick tour of Spark is how to use it in `standalone programs`. Apart from running interactively, Spark can be linked into standalone applications in either Java, Scala, or Python. `The main difference from using it in the shell is that you need to initialize your own SparkContext`. After that, the API is the same.

In Java and Scala, you give your application a Maven dependency on the `spark-core` artifact. You can use Maven itself to build your project, or use other tools that can talk to the Maven repositories, including Scala’s sbt tool or Gradle.
```shell
# Use spark-submit to run your application
$ YOUR_SPARK_HOME/bin/spark-submit \
  --class "SimpleApp" \
  --master local[4] \
  target/scala-2.11/simple-project_2.11-1.0.jar
```

In Python, you simply write applications as Python scripts, but you must run them using the `bin/spark-submit` script included in Spark. The spark-submit script includes the Spark dependencies for us in Python. This script sets up the environment for Spark’s Python API to function. Simply run your script with the line given in Example 2-6.   

**Example 2-6. Running a Python script**  
```shell
bin/spark-submit my_script.py
```

```python
from pyspark import SparkConf, SparkContext
conf = SparkConf().setMaster(“local”).setAppName(“My App”)
sc = SparkContext(conf = conf)
```

```scala
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
val conf = new SparkConf().setMaster(“local”).setAppName(“My App”)
val sc = new SparkContext(conf)
```

Finally, to shut down Spark, you can either call the `stop() method on your SparkContext`, or simply exit the application (e.g., with `System.exit(0)` or sys.exit()).

## Chapter 3. Programming with RDDs
An RDD is simply a distributed collection of elements. In Spark all work is expressed as either creating new RDDs, transforming existing RDDs, or calling operations on RDDs to compute a result. Under the hood, Spark automatically distributes the data contained in RDDs across your cluster and parallelizes the operations you perform on them.  

### RDD Basics
An RDD in Spark is simply an `immutable` distributed collection of objects. Each RDD is `split into multiple partitions`, which may be computed on different nodes of the cluster. RDDs can contain `any type of Python, Java, or Scala objects, including user-defined classes`.

Users create RDDs in two ways: by loading an external dataset, or by distributing a collection of objects (e.g., a list or set) in their driver program.  

Once created, RDDs offer two types of operations: transformations and actions.  
* Transformations  
construct a new RDD from a previous one.  
```python
>>> pythonLines = lines.filter(lambda line: “Python” in line)
```
* Actions  
on the other hand, compute a result based on an RDD, and either return it to the driver program or save it to an external storage system (e.g., HDFS)  
```python
>>> pythonLines.first()
u’## Interactive Python Shell’
```

Transformations and actions are different because of the way Spark computes RDDs. Although you can define new RDDs any time, `Spark computes them only in a lazy fashion — that is, the first time they are used in an action`. This approach might seem unusual at first, but makes a lot of sense when you are working with Big Data.

```python
>>> lines = sc.textFile(“README.md”)
>>> pythonLines = lines.filter(lambda line: “Python” in line)
>>> pythonLines.first()
u’## Interactive Python Shell’
```
If Spark were to load and store all the lines in the file as soon as we wrote lines = sc.textFile(…), it would waste a lot of storage space, given that we then immediately filter out many lines. Instead, once Spark sees the whole chain of transformations, it can compute just the data needed for its result. In fact, for the first() action, Spark scans the file only until it finds the first matching line; it doesn’t even read the whole file.

Finally, `Spark’s RDDs are by default recomputed each time you run an action on them`. `If you would like to reuse an RDD in multiple actions, you can ask Spark to persist it using RDD.persist()`(PS: or cache(), or checkpoint()). We can ask Spark to persist our data in a number of different places, which will be covered in Table 3-6. `After computing it the first time, Spark will store the RDD contents in memory (partitioned across the machines in your cluster), and reuse them in future actions`(PS: indeed, as for persist() or cache(), persisting results only happens after the first time it is computed, the persisting to the place specified as in Table 3-6). Persisting RDDs on disk instead of memory is also possible. The behavior of not persisting by default may again seem unusual, but it makes a lot of sense for big datasets: if you will not reuse the RDD, there’s no reason to waste storage space when Spark could instead stream through the data once and just compute the result.  

The ability to always recompute an RDD is actually why RDDs are called “resilient.” When a machine holding RDD data fails, Spark uses this ability to recompute the missing partitions, transparent to the user.

In practice, you will often use persist() to load a subset of your data into memory and query it repeatedly. For example, if we knew that we wanted to compute multiple results about the README lines that contain Python, we could write the script shown in Example 3-4.  
**Example 3-4. Persisting an RDD in memory**  
```python
>>> pythonLines.persist
>>> pythonLines.count()
2
>>> pythonLines.first()
u’## Interactive Python Shell’
```

To summarize, every Spark program and shell session will work as follows:  
1. Create some input RDDs from external data.
2. Transform them to define new RDDs using transformations like filter().
3. Ask Spark to persist() any intermediate RDDs that will need to be reused.
4. Launch actions such as count() and first() to kick off a parallel computation, which is then optimized and executed by Spark.

cache() is the same as calling persist() with the default storage level.  

### Creating RDDs
Spark provides two ways to create RDDs: `loading an external dataset` and `parallelizing a collection in your driver program`.

The simplest way to create RDDs is to take an existing collection in your program and pass it to `SparkContext’s parallelize() method`.  
**Example 3-6. parallelize() method in Scala**  
```scala
val lines = sc.parallelize(List(“pandas”, “i like pandas”))
```
A more common way to create RDDs is to load data from external storage.  
```scala
val lines = sc.textFile(“/path/to/README.md”)
```

### RDD Operations
As we’ve discussed, RDDs support two types of operations: transformations and actions. Transformations are operations on RDDs that return a new RDD, such as map() and filter(). Actions are operations that return a result to the driver program or write it to storage, and kick off a computation, such as count() and first(). Spark treats transformations and actions very differently, so understanding which type of operation you are performing will be important. `If you are ever confused whether a given function is a transformation or an action, you can look at its return type`: transformations return RDDs, whereas actions return some other data type.

* Transformations  
Transformations are operations on RDDs that return a new RDD. As discussed in “Lazy Evaluation”, transformed RDDs are computed lazily, only when you use them in an action. Many transformations are element-wise;
```scala
val inputRDD = sc.textFile(“log.txt”)
val errorsRDD = inputRDD.filter(line => line.contains(“error”))
errorsRDD = inputRDD.filter(lambda x: “error” in x)
warningsRDD = inputRDD.filter(lambda x: “warning” in x)
badLinesRDD = errorsRDD.union(warningsRDD)
```
Finally, as you derive new RDDs from each other using transformations, Spark keeps track of the set of dependencies between different RDDs, called the `lineage graph`. It uses this information to compute each RDD on demand and to recover lost data if part of a persistent RDD is lost.  

![spark_example_lineage_graph_img_1]  

* Actions  
They are the operations that return a final value to the driver program or write data to an external storage system. Actions force the evaluation of the transformations required for the RDD they were called on, since they need to actually produce output.
```scala
val inputRDD = sc.textFile(“log.txt”)
val errorsRDD = inputRDD.filter(line => line.contains(“error”))
errorsRDD = inputRDD.filter(lambda x: “error” in x)
warningsRDD = inputRDD.filter(lambda x: “warning” in x)
badLinesRDD = errorsRDD.union(warningsRDD)

println(“Input had “ + badLinesRDD.count() + ” concerning lines”)
println(“Here are 10 examples:”)
badLinesRDD.take(10).foreach(println)
```
In this example, we used take() to retrieve a small number of elements in the RDD at the driver program. We then iterate over them locally to print out information at the driver. `RDDs also have a collect() function to retrieve the entire RDD`. This can be useful if your program filters RDDs down to a very small size and you’d like to deal with it locally. Keep in mind that your entire dataset must fit in memory on a single machine to use collect() on it, so `collect() shouldn’t be used on large datasets`.  
`In most cases RDDs can’t just be collect()ed to the driver because they are too large`. `In these cases, it’s common to write data out to a distributed storage system such as HDFS or Amazon S3`. You can save the contents of an RDD using the saveAsTextFile() action, saveAsSequenceFile(), or any of a number of actions for various built-in formats.   
`It is important to note that each time we call a new action, the entire RDD must be computed “from scratch.”` To avoid this inefficiency, users can persist intermediate results, as we will cover in “Persistence (Caching)”.  

#### Lazy Evaluation
Lazy evaluation means that when we call a transformation on an RDD (for instance, calling map()), the operation is not immediately performed. Instead, Spark internally records metadata to indicate that this operation has been requested. `Rather than thinking of an RDD as containing specific data, it is best to think of each RDD as consisting of instructions on how to compute the data` that we build up through transformations. `Loading data into an RDD is lazily evaluated in the same way (as) transformations are`. So, when we call sc.textFile(), the data is not loaded until it is necessary. `As with transformations, the operation (in this case, reading the data) can occur multiple times`.

`Spark uses lazy evaluation to reduce the number of passes it has to take over our data by grouping operations together`.` In systems like Hadoop MapReduce, developers often have to spend a lot of time considering how to group together operations to minimize the number of MapReduce passes`. `In Spark, there is no substantial benefit to writing a single complex map instead of chaining together many simple operations. Thus, users are free to organize their program into smaller, more manageable operations`.

### Passing Functions to Spark
Most of Spark’s transformations, and some of its actions, depend on passing in functions that are used by Spark to compute data.

Each of the core languages has a slightly different mechanism for passing functions to Spark.  
#### Python  
1. lambda expressions
2. top-level functions
3. locally defined functions     

```python
# lambda expression
word = rdd.filter(lambda s: “error” in s)

# top-level function
def containsError(s):
    return “error” in s
word = rdd.filter(containsError)
```
One issue to watch out for when passing functions is inadvertently serializing the object containing the function. `When you pass a function that is the member of an object, or contains references to fields in an object (e.g., self.field), Spark sends the entire object to worker nodes, which can be much larger than the bit of information you need` (see Example 3-19). Sometimes this can also cause your program to fail, if your class contains objects that Python can’t figure out how to pickle.  
**Example 3-19. Passing a function with field references (don’t do this!)**  
```python
class SearchFunctions(object):
    def __init__(self, query):
        self.query = query
    def isMatch(self, s):
        return self.query in s
    def getMatchesFunctionReference(self, rdd):
        # Problem: references all of “self” in “self.isMatch”
        return rdd.filter(self.isMatch)
    def getMatchesMemberReference(self, rdd):
        # Problem: references all of “self” in “self.query”
        return rdd.filter(lambda x: self.query in x)
```
`Instead, just extract the fields you need from your object into a local variable and pass that in`, like we do in Example 3-20.  
**Example 3-20. Python function passing without field references**  
```python
class WordFunctions(object):
    …
    def getMatchesNoReference(self, rdd):
        # Safe: extract only the field we need into a local variable
        query = self.query
        return rdd.filter(lambda x: query in x)
```

#### Scala
In Scala, we can pass in `functions defined inline, references to methods, or static functions` as we do for Scala’s other functional APIs. Some other considerations come into play, though — namely that `the function we pass and the data referenced in it needs to be serializable (implementing Java’s Serializable interface). Furthermore, as in Python, passing a method or field of an object includes a reference to that whole object`, though this is less obvious because we are not forced to write these references with self. As we did with Python in Example 3-20, we can instead extract the fields we need as local variables and avoid needing to pass the whole object containing them, as shown in Example 3-21.

```scala
class SearchFunctions(val query: String) {
    def isMatch(s: String): Boolean = {
        s.contains(query)
    }
    def getMatchesFunctionReference(rdd: RDD[String]): RDD[String] = {
        // Problem: “isMatch” means “this.isMatch”, so we pass all of “this”
        rdd.map(isMatch)
    }
    def getMatchesFieldReference(rdd: RDD[String]): RDD[String] = {
        // Problem: “query” means “this.query”, so we pass all of “this”
        rdd.map(x => x.split(query))
    }
    def getMatchesNoReference(rdd: RDD[String]): RDD[String] = {
        // Safe: extract just the field we need into a local variable
        val query_ = this.query
        rdd.map(x => x.split(query_))
    }
}
```
If **NotSerializableException** occurs in Scala, a reference to a method or field in a nonserializable class is usually the problem. Note that passing in `local serializable variables` or `functions that are members of a top-level object` is always safe.

#### Java
In Java, functions are specified as objects that implement one of Spark’s function interfaces from the `org.apache.spark.api.java.function` package.
```java
class ContainsError implements Function<String, Boolean>() {
        public Boolean call(String x) { return x.contains(“error”); }
}
RDD<String> errors = lines.filter(new ContainsError());

class Contains implements Function<String, Boolean>() {
        private String query;
        public Contains(String query) { this.query = query; }
        public Boolean call(String x) { return x.contains(query); }
}
RDD<String> errors = lines.filter(new Contains(“error”));

// JAVA 8 lambda
RDD<String> errors = lines.filter(s -> s.contains(“error”));
```
Both anonymous inner classes and lambda expressions can reference any final variables in the method enclosing them, so you can pass these variables to Spark just as in Python and Scala.

### Common Transformations and Actions
In this chapter, we tour the most common transformations and actions in Spark. Additional operations are available on RDDs containing certain types of data — for example, `statistical functions on RDDs of numbers`, and key/value operations such as aggregating data by key on RDDs of key/value pairs.

#### Basic RDDs
##### Element-wise transformations
* map()  
The map() transformation takes in a function and applies it to each element in the RDD with the result of the function being the new value of each element in the resulting RDD.   
```python
nums = sc.parallelize([1, 2, 3, 4])
squared = nums.map(lambda x: x * x).collect()
for num in squared:
    print “%i “ % (num)
```
```scala
val input = sc.parallelize(List(1, 2, 3, 4))
val result = input.map(x => x * x)
println(result.collect().mkString(“,”))
```
* filter()  
The filter() transformation takes in a function and returns an RDD that only has elements that pass the filter() function.  
* flatMap()  
Sometimes we want to produce multiple output elements for each input element. The operation to do this is called flatMap(). As with map(), the function we provide to flatMap() is called individually for each element in our input RDD. `Instead of returning a single element, we return an iterator with our return values. Rather than producing an RDD of iterators, we get back an RDD that consists of the elements from all of the iterators`.   
```scala
val lines = sc.parallelize(List(“hello world”, “hi”))
val words = lines.flatMap(line => line.split(” “))
words.first() // returns “hello”
```

##### Pseudo set operations  
RDDs support many of the operations of mathematical sets, such as union and intersection, `even when the RDDs themselves are not properly sets`. Four operations are shown in Figure 3-4. It’s important to note that all of these operations require that the RDDs being operated on are of the same type.   
1. distinct()  
`Note that distinct() is expensive`, however, as it requires `shuffling all the data over the network`(PS: maybe only single Mapper phrase is enough, why shuffling?) to ensure that we receive only one copy of each element. Shuffling, and how to avoid it, is discussed in more detail in Chapter 4.  
2. union(other)  
the result of Spark’s union() will contain duplicates
3. intersection(other)  
returns only elements in both RDDs. intersection() also removes all duplicates (including duplicates from a single RDD) while running. While intersection() and union() are two similar concepts, `the performance of intersection() is much worse since it requires a shuffle over the network to identify common elements`.
4. subtract(other)  
takes in another RDD and returns an RDD that has only values present in the first RDD and not the second RDD. Like intersection(), `it performs a shuffle`.
5. cartesian(other)    
We can also compute a Cartesian product between two RDDs. Be warned, however, that `the Cartesian product is very expensive for large RDDs`.  
    
##### Basic RDDs' Actions  
1. reduce()  
The most common action on basic RDDs you will likely use is reduce(), which takes a function that operates on `two elements of the type` in your RDD and `returns a new element of the same type`.
```python
sum = rdd.reduce(lambda x, y: x + y)
```
```scala
val sum = rdd.reduce((x, y) => x + y)
```
```java
Integer sum = rdd.reduce(new Function2<Integer, Integer, Integer>() {
    public Integer call(Integer x, Integer y) { return x + y; }
});
```
2. fold()  
Similar to reduce() is fold(), which also takes a function with the same signature as needed for reduce(), but in addition takes a “zero value” to be used for the initial call `on each partition`. The zero value you provide should be the identity element for your operation; that is, `applying it multiple times with your function should not change the value (e.g., 0 for +, 1 for *, or an empty list for concatenation)`.  
You can minimize object creation in fold() by modifying and returning the first of the two parameters in place. However, you should not modify the second parameter(PS: Hadoop MapReduce's Writable does the same tricks).  
Both fold() and reduce() require that the return type of our result be the same type as that of the elements in the RDD we are operating over. This works well for operations like sum, but sometimes we want to return a different type. For example, when computing a running average, we need to keep track of both the count so far and the number of elements, which requires us to return a pair. `We could work around this by first using map() where we transform every element into a pair of the element and the number 1, which is the type we want to return`, so that the reduce() function can work on pairs.
3. aggregate()  
The aggregate() function frees us from the constraint of having the return be the same type as the RDD we are working on. With aggregate(), like fold(), we supply `an initial zero value of the type we want to return`. We then supply `a function to combine the elements from our RDD with the accumulator`. Finally, we need to supply `a second function to merge two accumulators, given that each node accumulates its own results locally`(PS: the second function is used to merge two nodes' results together).
```python
sumCount = nums.aggregate((0, 0),
                                (lambda acc, value: (acc[0] + value, acc[1] + 1),
                                (lambda acc1, acc2: (acc1[0] + acc2[0], acc1[1] + acc2[1]))))
return sumCount[0] / float(sumCount[1])
```
```scala
val result = input.aggregate((0, 0))(
                                (acc, value) => (acc._1 + value, acc._2 + 1),
                                (acc1, acc2) => (acc1._1 + acc2._1, acc1._2 + acc2._2))
val avg = result._1 / result._2.toDouble
```
See how many boiler-plate codes are there in java without lambda  
```java
class AvgCount implements Serializable {
        public AvgCount(int total, int num) {
                this.total = total;
                this.num = num;
        }
        public int total;
        public int num;
        public double avg() {
                return total / (double) num;
        }
} 

Function2<AvgCount, Integer, AvgCount> addAndCount =
new Function2<AvgCount, Integer, AvgCount>() {
        public AvgCount call(AvgCount a, Integer x) {
                a.total += x;
                a.num += 1;
                return a;
        }
};
Function2<AvgCount, AvgCount, AvgCount> combine =
new Function2<AvgCount, AvgCount, AvgCount>() {
        public AvgCount call(AvgCount a, AvgCount b) {
                a.total += b.total;
                a.num += b.num;
                return a;
        }
};
AvgCount initial = new AvgCount(0, 0);
AvgCount result = rdd.aggregate(initial, addAndCount, combine);
System.out.println(result.avg());
```
4. collect()  
The simplest and most common operation that returns data to our driver program is collect(), which `returns the entire RDD’s contents`. collect() is `commonly used in unit tests` where the entire contents of the RDD are expected to fit in memory, as that makes it easy to compare the value of our RDD with our expected result. collect() `suffers from the restriction that all of your data must fit on a single machine`, as it all needs to be copied to the driver.
5. take(n)  
take(n) returns n elements from the RDD and `attempts to minimize the number of partitions it accesses`, so `it may represent a biased collection`. It’s important to note that these operations `do not return the elements in the order you might expect`.
6. top()  
`If there is an ordering defined on our data`, we can also extract the top elements from an RDD using top(). top() will use the default ordering on the data, but we can supply our own comparison function to extract the top elements.
7. takeSample(withReplacement, num, [seed])  
Sometimes we need a sample of our data in our driver program. The takeSample(withReplacement, num, seed) function allows us to take a sample of our data either with or without replacement.  
8. foreach()  
Sometimes it is useful to perform an action on all of the elements in the RDD, but `without returning any result to the driver program`. A good example of this would be posting JSON to a webserver or inserting records into a database. In either case, the foreach() action lets us perform computations on each element in the RDD without bringing it back locally.
9. countByValue()  
returns a map of each unique value to its count.  
10. takeOrdered(num)(ordering)  
Return num elements based on provided ordering.

#### Converting Between RDD Types

Some functions are available only on certain types of RDDs, such as mean() and variance() on numeric RDDs or join() on key/value pair RDDs. We will cover these special functions for numeric data in Chapter 6 and pair RDDs in Chapter 4. In Scala and Java, these methods aren’t defined on the standard RDD class, so to access this additional functionality we have to make sure we get the correct specialized class.

* Scala  
In Scala the conversion to RDDs with special functions (e.g., to expose numeric functions on an RDD[Double]) is handled automatically using `implicit conversions`. we need to add import `org.apache.spark.SparkContext._` for these conversions to work. You can see the implicit conversions listed in the SparkContext object’s ScalaDoc. These implicits turn an RDD into various wrapper classes, such as DoubleRDDFunctions (for RDDs of numeric data, implicit conversions between
RDD[Double] and DoubleRDDFunctions ) and PairRDDFunctions (for key/value pairs), to expose additional functions such as mean() and variance().   
* JAVA  
In Java the conversion between the specialized types of RDDs is a bit more explicit. In particular, there are special classes called JavaDoubleRDD and JavaPairRDD for RDDs of these types, with extra methods for these types of data.  
`To construct RDDs` of these special types, instead of always using the Function class we will need to use specialized versions. If we want to create a DoubleRDD from an RDD of type T, rather than using Function<T, Double> we use DoubleFunction<T>.  

Function name                           |Equivalent function*<A, B,…>                   | Usage
-----------------------------------|---------------------------------------------|------------------------------------------------------------------ 
DoubleFlatMapFunction<T>        |Function<T, Iterable<Double>>                |DoubleRDD from a flatMapToDouble
DoubleFunction<T>                    |Function<T, double>                                 |DoubleRDD from mapToDouble
PairFlatMapFunction<T, K, V>    |Function<T, Iterable<Tuple2<K, V>>>        |PairRDD<K, V> from a flatMapToPair
PairFunction<T, K, V>                 |Function<T, Tuple2<K, V>>                       |PairRDD<K, V> from a mapToPair

```java
JavaDoubleRDD result = rdd.mapToDouble(
        new DoubleFunction<Integer>() {
                public double call(Integer x) {
                        return (double) x * x;
                }
        });
System.out.println(result.mean());
```
* Python  
The Python API is structured differently than Java and Scala. In Python `all of the functions are implemented on the base RDD class` but will fail at runtime if the type of data in the RDD is incorrect.

### Persistence (Caching)
As discussed earlier, Spark RDDs are lazily evaluated, and `sometimes we may wish to use the same RDD multiple times. If we do this naively, Spark will recompute the RDD and all of its dependencies each time we call an action on the RDD`. This can be especially expensive for iterative algorithms, which look at the data many times. Another trivial example would be doing a count and then writing out the same RDD, as shown in Example 3-39.   
**Example 3-39. Double execution in Scala**  
```scala
val result = input.map(x => x*x)
println(result.count())
println(result.collect().mkString(“,”))
```

To avoid computing an RDD multiple times, we can `ask Spark to persist the data`. When we ask Spark to persist an RDD, `the nodes that compute the RDD store their partitions`. If a node that has data persisted on it fails, Spark will recompute the lost partitions of the data when needed. `We can also replicate our data on multiple nodes` if we want to be able to handle node failure without slowdown.

Spark has many levels of persistence to choose from based on what our goals are, as you can see in Table 3-6. `In Scala (Example 3-40) and Java, the default persist() will store the data in the JVM heap as unserialized objects`. `In Python, we always serialize the data that persist stores`, so the default is instead stored in the JVM heap as pickled objects. `When we write data out to disk or off-heap storage, that data is also always serialized`.

**Table 3-6. Persistence levels from org.apache.spark.storage.StorageLevel and pyspark.StorageLevel; if desired we can replicate the data on two machines by adding _2 to the end of the storage level**  

Level                                       |Space used |CPU time |In memory |On disk |Comments
----------------------------------|-------------|-----------|-------------|---------|----------------------------------------------------------------
MEMORY_ONLY                     |High           |Low         |Y                |N           |_
MEMORY_ONLY_SER            |Low             |High        |Y                |N          |_
MEMORY_AND_DISK            |High           |Medium   |Some          |Some    |Spills to disk if there is too much data to fit in
memory.  
MEMORY_AND_DISK_SER   |Low            |High        |Some          |Some    |Spills to disk if there is too much data to fit in memory. Stores serialized representation in memory.
DISK_ONLY                           |Low            |High        |N                |Y          | _

Off-heap caching is experimental and uses Tachyon. If you are interested in off-heap caching with Spark, take a look at the Running Spark on Tachyon guide.

**Example 3-40. persist() in Scala**
```scala
val result = input.map(x => x * x)
result.persist(StorageLevel.DISK_ONLY)
println(result.count())
println(result.collect().mkString(“,”))
```
Notice that we called persist() on the RDD before the first action. The persist() call on its own doesn’t force evaluation. If you attempt to cache too much data to fit in memory, Spark will automatically evict old partitions using a Least Recently Used (LRU) cache policy. For the memory-only storage levels, it will recompute these partitions the next time they are accessed, while for the memory-and-disk ones, it will write them out to disk. In either case, this means that you don’t have to worry about your job breaking if you ask Spark to cache too much data. However, caching unnecessary data can lead to eviction of useful data and more recomputation time. 

Finally, RDDs come with a method called unpersist() that lets you manually remove them from the cache.

## Chapter 4. Working with Key/Value Pairs

Key/value RDDs are commonly used to perform aggregations, and often we will do some initial ETL (extract, transform, and load) to get our data into a key/value format. Key/value RDDs expose new operations (e.g., counting up reviews for each product, grouping together data with the same key, and grouping together two different RDDs) 

We also discuss an advanced feature that lets users control the layout of pair RDDs across nodes: partitioning. Using controllable partitioning, applications can sometimes greatly reduce communication costs by ensuring that data will be accessed together and will be on the same node. This can provide significant speedups. We illustrate partitioning using the `PageRank algorithm` as an example.

Spark provides special operations on RDDs containing key/value pairs. These RDDs are called pair RDDs. Pair RDDs are a useful building block in many programs, as they expose operations that allow you to act on each key in parallel or regroup data across the network. For example, pair RDDs have a reduceByKey() method that can aggregate data separately for each key, and a join() method that can merge two RDDs together by grouping elements with the same key. It is common to extract fields from an RDD (representing, for instance, an event time, customer ID, or other identifier) and use those fields as keys in pair RDD operations.

### Creating Pair RDDs
Many formats we explore loading from in Chapter 5 will directly return pair RDDs for their key/value data. In other cases we have a regular RDD that we want to turn into a pair RDD. We can do this by running a map() function that returns key/value pairs. 

To illustrate, we show code that starts with an RDD of lines of text and keys the data by the first word in each line.  

In Python, for the functions on keyed data to work we need to return an RDD composed of tuples.
```python
pairs = lines.map(lambda x: (x.split(” “)[0], x))
```

In Scala, for the functions on keyed data to be available, we also need to return tuples (see Example 4-2). An implicit conversion on RDDs of tuples exists to provide the additional key/value functions.
```scala
val pairs = lines.map(x => (x.split(” “)(0), x))
```

Java doesn’t have a built-in tuple type, so Spark’s Java API has users create tuples using the scala.Tuple2 class. This class is very simple: Java users can construct a new tuple by writing new Tuple2(elem1, elem2) and can then access its elements with the ._1() and ._2() methods.  
```java
PairFunction<String, String, String> keyData =
new PairFunction<String, String, String>() {
        public Tuple2<String, String> call(String x) {
                return new Tuple2(x.split(” “)[0], x);
        }
};
JavaPairRDD<String, String> pairs = lines.mapToPair(keyData);
```

When creating a pair RDD from an in-memory collection in Scala and Python, we only need to call `SparkContext.parallelize()` on a collection of pairs. To create a pair RDD in Java from an in-memory collection, we instead use SparkContext.parallelizePairs().

### Transformations on Pair RDDs
Pair RDDs are allowed to use all the transformations available to standard RDDs. The same rules apply from “Passing Functions to Spark”. Since pair RDDs contain tuples, we need to pass functions that operate on tuples rather than on individual elements. Tables 4-1 and 4-2 summarize transformations on pair RDDs, and we will dive into the transformations in detail later in the chapter.

**Table 4-1. Transformations on one pair RDD (example: {(1, 2), (3, 4), (3, 6)})**  

Function name               |Example                                    |Result                         |Purpose
---------------------------|---------------------------------- |-------------------------|-----------------------------------------------------------
reduceByKey(func)       |rdd.reduceByKey((x, y) => x + y)|{(1,2),(3,10)}                |Combine values with the same key.
groupByKey()                |rdd.groupByKey()                      |{(1,[2]),(3,[4,6])}          |Group values with the same key.
combineByKey(createCombiner, mergeValue, mergeCombiners, partitioner) |See Examples 4-12 through 4-14. | _ |Combine values with the same key using a different result type.
mapValues(func)           |rdd.mapValues(x => x+1)            |{(1,3),(3,5),(3,7)}          |Apply a function to each value of a pair RDD without changing the key.
flatMapValues(func)     |rdd.flatMapValues(x => (x to 5))|{(1,2),(1,3),(1,4),(1,5),(3,4),(3,5)}(PS: no (3,6)) |Apply a function that returns an iterator to each value of a pair RDD, and for each element returned, produce a key/value entry with the old key. Often used for tokenization.
keys()                           |rdd.keys()                                 |{1, 3, 3}                        |Return an RDD of just the keys.
values()                        |rdd.values()                               |{2, 4, 6}                       |Return an RDD of just the values.
sortByKey()                  |rdd.sortByKey()                        |{(1,2), (3, 4),(3, 6)}       |Return an RDD sorted by the key.

**Table 4-2. Transformations on two pair RDDs (rdd = {(1, 2), (3, 4), (3, 6)} other = {(3, 9)})**  

Function name   |Example                                |Result                                           |Purpose
------------------|--------------------------------|--------------------------------------|----------------------------------------------------------
subtractByKey  |rdd.subtractByKey(other)    |{(1, 2)}                                           |Remove elements with a key present in the other RDD.
join                   |rdd.join(other)                      |{(3, (4, 9)),(3, (6, 9))}                   |Perform an inner join between two RDDs.
rightOuterJoin |rdd.rightOuterJoin(other)   |{(3, (Some(4),9)), (3, (Some(6),9))}|Perform a join between two RDDs where the key must be present in the other RDD.
leftOuterJoin  |rdd.leftOuterJoin(other)     |{(1,(2,None)), (3,(4,Some(9))),(3,(6,Some(9)))} |Perform a join between two RDDs where the key must be present in the first RDD.
cogroup            |rdd.cogroup(other)               |{(1,([2],[])),(3,([4, 6],[9]))}              |Group data from both RDDs sharing the same key.

Pair RDDs are also still RDDs (of Tuple2 objects in Java/Scala or of Python tuples), and thus support the same functions as RDDs.

```python
result = pairs.filter(lambda keyValue: len(keyValue[1]) < 20)
```

```scala
pairs.filter{case (key, value) => value.length < 20}
```

Sometimes working with pairs can be awkward if we want to access only the value part of our pair RDD. Since this is a common pattern, Spark provides the mapValues(func) function, which is the same as map{case (x, y) : (x, func(y))}.

#### Aggregations

* reduceByKey()  
reduceByKey() `runs several parallel reduce operations`, one for each key in the dataset, where each operation combines values that have the same key. `Because datasets can have very large numbers of keys, reduceByKey() is not implemented as an action` that returns a value to the user program. Instead, it returns a new RDD consisting of each key and the reduced value for that key.
**Example 4-7. Per-key average with reduceByKey() and mapValues() in Python**
```python
rdd.mapValues(lambda x: (x, 1)).reduceByKey(lambda x, y: (x[0] + y[0], x[1] + y[1]))
```
**Example 4-8. Per-key average with reduceByKey() and mapValues() in Scala**
```python
rdd.mapValues(x => (x, 1)).reduceByKey((x, y) => (x._1 + y._1, x._2 + y._2))
```
* foldByKey()  
foldByKey() is quite similar to fold(); both use a zero value of the same type of the data in our RDD and combination function. As with fold(), the provided zero value for foldByKey() should have no impact when added with your combination function to another element.  

Those familiar with the combiner concept from MapReduce should note that `calling reduceByKey() and foldByKey() will automatically perform combining locally on each machine before computing global totals for each key`. The user does not need to specify a combiner. The more general combineByKey() interface allows you to customize combining behavior.

**Example 4-9. Word count in Python**
```python
rdd = sc.textFile(“s3://…”)
words = rdd.flatMap(lambda x: x.split(” “))
result = words.map(lambda x: (x, 1)).reduceByKey(lambda x, y: x + y)
```
**Example 4-10. Word count in Scala**  
```scala
val input = sc.textFile(“s3://…”)
val words = input.flatMap(x => x.split(” “))
val result = words.map(x => (x, 1)).reduceByKey((x, y) => x + y)
```
We can actually implement word count even faster by using the countByValue() function on the first RDD: `input.flatMap(x => x.split(” “)).countByValue()`.  

* combineByKey()  
combineByKey() is the most general of the per-key aggregation functions. `Most of the other per-key combiners are implemented using it`. Like aggregate(), `combineByKey() allows the user to return values that are not the same type as our input data`.  
To understand combineByKey(), it’s useful to think of how it handles each element it processes. As combineByKey() goes through the elements in a partition, each element either has a key it hasn’t seen before or has the same key as a previous element. If it’s a new element, combineByKey() uses a function we provide, called `createCombiner()`, to create the initial value for the accumulator on that key. It’s important to note that `this happens the first time a key is found in each partition`, rather than only the first time the key is found in the RDD.  
If it is a value we have seen before `while processing that partition`, it will instead use the provided function, `mergeValue()`, with the current value for the accumulator for that key and the new value.   
Since each partition is processed independently, we can have multiple accumulators for the same key. When we are merging the results from each partition, `if two or more partitions have an accumulator for the same key we merge the accumulators using the user-supplied mergeCombiners() function`.  
`We can disable map-side aggregation in combineByKey()` if we know that our data won’t benefit from it. For example, groupByKey() disables map-side aggregation as the aggregation function (appending to a list) does not save any space. `If we want to disable map-side combines, we need to specify the partitioner`; for now you can just use the partitioner on the source RDD by passing `rdd.partitioner`.

To better illustrate how combineByKey() works, we will look at computing the average value for each key, as shown in Examples 4-12 through 4-14 and illustrated in Figure 4-3.  
**Example 4-12. Per-key average using combineByKey() in Python**  
```python
sumCount = nums.combineByKey((lambda x: (x,1)),
(lambda x, y: (x[0] + y, x[1] + 1)),
(lambda x, y: (x[0] + y[0], x[1] + y[1])))
sumCount.map(lambda key, xy: (key, xy[0]/xy[1])).collectAsMap()
```
**Example 4-13. Per-key average using combineByKey() in Scala** 
```scala
val result = input.combineByKey(
                                (v) => (v, 1),
                                (acc: (Int, Int), v) => (acc._1 + v, acc._2 + 1),
                                (acc1: (Int, Int), acc2: (Int, Int)) => (acc1._1 + acc2._1, acc1._2 + acc2._2)
                            ).map{ case (key, value) => (key, value._1 / value._2.toFloat) }
result.collectAsMap().map(println(_))
```

![spark_combinebykey_flow_img_1]   
**Figure 4-3. combineByKey() sample data flow**  

There are many options for combining our data by key. Most of them are implemented on top of combineByKey() but provide a simpler interface.

#### Tuning the level of parallelism
So far we have talked about how all of our transformations are distributed, but we have not really looked at how Spark decides how to split up the work. `Every RDD has a fixed number of partitions that determine the degree of parallelism` to use when executing operations on the RDD.  

`When performing aggregations or grouping operations, we can ask Spark to use a specific number of partitions`. Spark will always try to infer a sensible default value based on the size of your cluster, but in some cases you will want to tune the level of parallelism for better performance.

`Most of the operators discussed in this chapter accept a second parameter giving the number of partitions to use` when creating the grouped or aggregated RDD.

**Example 4-15. reduceByKey() with custom parallelism in Python**  
```python
data = [(“a”, 3), (“b”, 4), (“a”, 1)]
sc.parallelize(data).reduceByKey(lambda x, y: x + y) # Default parallelism
sc.parallelize(data).reduceByKey(lambda x, y: x + y, 10) # Custom parallelism
```
**Example 4-16. reduceByKey() with custom parallelism in Scala**
```scala
val data = Seq((“a”, 3), (“b”, 4), (“a”, 1))
sc.parallelize(data).reduceByKey((x, y) => x + y) // Default parallelism
sc.parallelize(data).reduceByKey((x, y) => x + y, 10) // Custom parallelism
```

Sometimes, we want to change the partitioning of an RDD outside the context of grouping and aggregation operations. For those cases, Spark provides the `repartition()` function, which shuffles the data across the network to create a new set of partitions. Keep in mind that `repartitioning your data is a fairly expensive operation`. Spark also has an optimized version of repartition() called `coalesce() that allows avoiding data movement, but only if you are decreasing the number of RDD partitions`. To know whether you can safely call coalesce(), you can check the size of the RDD using `rdd.partitions.size()` in Java/Scala and `rdd.getNumPartitions()` in Python and make sure that you are coalescing it to fewer partitions than it currently has.

#### Grouping Data
If our data is already keyed in the way we want, groupByKey() will group our data using the key in our RDD. On an RDD consisting of keys of type K and values of type V, we get back an RDD of type [K, Iterable[V]].

groupBy() works on unpaired data or data where we want to use a different condition besides equality on the current key. It takes a function that it applies to every element in the source RDD and uses the result to determine the key.

If you find yourself writing code where you groupByKey() and then use a reduce() or fold() on the values, you can probably achieve the same result more efficiently by using one of the per-key aggregation functions. Rather than reducing the RDD to an in-memory value, we reduce the data per key and get back an RDD with the reduced values corresponding to each key. For example, rdd.reduceByKey(func) produces the same RDD as rdd.groupByKey().mapValues(value => value.reduce(func)) but is more efficient as it avoids the step of creating a list of values for each key.

In addition to grouping data from a single RDD, we can group data sharing the same key from multiple RDDs using a function called cogroup(). cogroup() over two RDDs sharing the same key type, K, with the respective value types V and W gives us back RDD[(K, (Iterable[V], Iterable[W]))]. If one of the RDDs doesn’t have elements for a given key that is present in the other RDD, the corresponding Iterable is simply empty. cogroup() gives us the power to group data from multiple RDDs. `cogroup() is used as a building block for the joins` we discuss in the next section.

cogroup() can be used for much more than just implementing joins. We can also use it to implement intersect by key. Additionally, cogroup() can work on three or more RDDs at once.

#### Joins
Some of the most useful operations we get with keyed data comes from using it together with other keyed data. Joining data together is probably one of the most common operations on a pair RDD, and we have a full range of options including right and left outer joins, cross joins, and inner joins.

With leftOuterJoin() the resulting pair RDD has entries for each key in the source RDD. The value associated with each key in the result is a tuple of the value from the source RDD and an Option (or Optional in Java) for the value from the other pair RDD. In Python, if a value isn’t present None is used; and if the value is present the regular value, without any wrapper, is used. As with join(), we can have multiple entries for each key; when this occurs, we get the Cartesian product between the two lists of values.

#### Sorting Data
Having sorted data is quite useful in many cases, especially when you’re producing downstream output. We can sort an RDD with key/value pairs provided that there is an ordering defined on the key. Once we have sorted our data, any subsequent call on the sorted data to collect() or save() will result in ordered data.

In Examples 4-19 through 4-21, we will sort our RDD by converting the integers to strings and using the string comparison functions.

**Example 4-19. Custom sort order in Python, sorting integers as if strings**  
```python
rdd.sortByKey(ascending=True, numPartitions=None, keyfunc = lambda x: str(x))
```
**Example 4-20. Custom sort order in Scala, sorting integers as if strings**
```scala
val input: RDD[(Int, Venue)] = …
implicit val sortIntegersByString = new Ordering[Int] {
    override def compare(a: Int, b: Int) = a.toString.compare(b.toString)
} 
rdd.sortByKey()
```

### Actions Available on Pair RDDs
As with the transformations, all of the traditional actions available on the base RDD are also available on pair RDDs. Some additional actions are available on pair RDDs to take advantage of the key/value nature of the data; these are listed in Table 4-3.  
**Table 4-3. Actions on pair RDDs (example ({(1, 2), (3, 4), (3, 6)}))**  

Function name   |Example                                |Result                                           |Purpose
------------------|--------------------------------|--------------------------------------|----------------------------------------------------------
countByKey()    |rdd.countByKey()                  |{(1, 1), (3, 2)}                                 |Count the number of elements for each key.
collectAsMap()  |rdd.collectAsMap()              |Map{(1, 2), (3, 4), (3,6)}                 |Collect the result as a map to provide easy lookup.
lookup(key)       |rdd.lookup(3)                        |[4, 6]                                             |Return all values associated with the provided key.

### Data Partitioning (Advanced)
The final Spark feature we will discuss in this chapter is how to control datasets’ partitioning across nodes. In a distributed program, communication is very expensive, so laying out data to minimize network traffic can greatly improve performance. Spark programs can choose to control their RDDs’ partitioning to reduce communication. Partitioning will not be helpful in all applications — for example, if a given RDD is scanned only once, there is no point in partitioning it in advance. `It is useful only when a dataset is reused multiple times in key-oriented operations such as joins`. We will give some examples shortly.

Spark’s partitioning is available on all RDDs of key/value pairs, and causes the system to group elements based on a function of each key. Although Spark does not give explicit control of which worker node each key goes to (partly because the system is designed to work even if specific nodes fail), it lets the program ensure that a set of keys will appear together on some node.

As a simple example, consider an application that keeps a large table of user information in memory — say, an RDD of (UserID, UserInfo) pairs, where UserInfo contains a list of topics the user is subscribed to. The application periodically combines this table with a smaller file representing events that happened in the past five minutes — say, a table of (UserID, LinkInfo) pairs for users who have clicked a link on a website in those five minutes. For example, we may wish to count how many users visited a link that was not to one of their subscribed topics. We can perform this combination with Spark’s join() operation, which can be used to group the UserInfo and LinkInfo pairs for each UserID by key. Our application would look like Example 4-22.  
**Example 4-22. Scala simple application**  
```scala
// Initialization code; we load the user info from a Hadoop SequenceFile on HDFS.
// This distributes elements of userData by the HDFS block where they are found,
// and doesn’t provide Spark with any way of knowing in which partition a
// particular UserID is located.
val sc = new SparkContext(…)
val userData = sc.sequenceFile[UserID, UserInfo](“hdfs://…”).persist()
// Function called periodically to process a logfile of events in the past 5 minutes;
// we assume that this is a SequenceFile containing (UserID, LinkInfo) pairs.
def processNewLogs(logFileName: String) {
    val events = sc.sequenceFile[UserID, LinkInfo](logFileName)
    val joined = userData.join(events)// RDD of (UserID, (UserInfo, LinkInfo)) pairs
    val offTopicVisits = joined.filter {
        case (userId, (userInfo, linkInfo)) => // Expand the tuple into its components
                !userInfo.topics.contains(linkInfo.topic)
    }.count()
    println(“Number of visits to non-subscribed topics: “ + offTopicVisits)
}
```
This code will run fine as is, but it will be inefficient. This is because the join() operation, called each time processNewLogs() is invoked, does not know anything about how the keys are partitioned in the datasets. `By default, this operation will hash all the keys of both datasets, sending elements with the same key hash across the network to the same machine, and then join together the elements with the same key on that machine` (see Figure 4-4). Because we expect the userData table to be much larger than the small log of events seen every five minutes, this wastes a lot of work: the userData table is hashed and shuffled across the network on every call, even though it doesn’t change.  

`Fixing this is simple: just use the partitionBy() transformation on userData to hashpartition it at the start of the program`. We do this by passing a `spark.HashPartitioner` object to partitionBy, as shown in Example 4-23.  
**Example 4-23. Scala custom partitioner**  
```scala
val sc = new SparkContext(…)
val userData = sc.sequenceFile[UserID, UserInfo](“hdfs://…”)
                            .partitionBy(new HashPartitioner(100)) // Create 100 partitions
                            .persist()
```
The processNewLogs() method can remain unchanged: the events RDD is local to processNewLogs(), and is used only once within this method, so there is no advantage in specifying a partitioner for events. Because we called partitionBy() when building userData, Spark will now know that it is hash-partitioned, and calls to join() on it will take advantage of this information. In particular, when we call userData.join(events), Spark will shuffle only the events RDD, sending events with each particular UserID to the machine that contains the corresponding hash partition of userData (see Figure 4-5). The result is that a lot less data is communicated over the network, and the program runs significantly faster.

Note that `partitionBy() is a transformation`, so it always returns a new RDD — it does not change the original RDD in place. RDDs can never be modified once created. Therefore it is important to persist and save as userData the result of partitionBy(), not the original sequenceFile(). Also, `the 100 passed to partitionBy() represents the number of partitions, which will control how many parallel tasks perform further operations on the RDD (e.g., joins); in general, make this at least as large as the number of cores in your cluster`.

Failure to persist an RDD after it has been transformed with partitionBy() will cause subsequent uses of the RDD to repeat the partitioning of the data. Without persistence, use of the partitioned RDD will cause reevaluation of the RDDs complete lineage. That would negate the advantage of partitionBy(), resulting in repeated partitioning and shuffling of data across the network, similar to what occurs without any specified partitioner.

In fact, many other Spark operations automatically result in an RDD with known partitioning information, and many operations other than join() will take advantage of this information. For example, sortByKey() and groupByKey() will result in rangepartitioned and hash-partitioned RDDs, respectively. `On the other hand, operations like map() cause the new RDD to forget the parent’s partitioning information`, because such operations could theoretically modify the key of each record.

Spark’s Java and Python APIs benefit from partitioning in the same way as the Scala API. However, in Python, you cannot pass a HashPartitioner object to partitionBy; instead, you just pass the number of partitions desired (e.g., rdd.partitionBy(100)).

#### Determining an RDD’s Partitioner
In Scala and Java, you can determine how an RDD is partitioned using its partitioner property (or partitioner() method in Java). This returns a scala.Option object, which is a Scala class for a container that may or may not contain one item. You can call isDefined() on the Option to check whether it has a value, and get() to get this value. If present, the value will be a spark.Partitioner object. This is essentially a function telling the RDD which partition each key goes into;  

**Example 4-24. Determining partitioner of an RDD**
```scala
scala> val pairs = sc.parallelize(List((1, 1), (2, 2), (3, 3)))
pairs: spark.RDD[(Int, Int)] = ParallelCollectionRDD[0] at parallelize at <console>:12
scala> pairs.partitioner
res0: Option[spark.Partitioner] = None
scala> val partitioned = pairs.partitionBy(new spark.HashPartitioner(2))
partitioned: spark.RDD[(Int, Int)] = ShuffledRDD[1] at partitionBy at <console>:14
scala> partitioned.partitioner
res1: Option[spark.Partitioner] = Some(spark.HashPartitioner@5147788d)
```

#### Operations That Benefit from Partitioning
Many of Spark’s operations involve shuffling data by key across the network. All of these will benefit from partitioning. As of Spark 1.0, the operations that benefit from partitioning are cogroup(), groupWith(), join(), leftOuterJoin(), rightOuterJoin(), groupByKey(), reduceByKey(), combineByKey(), and lookup().  

For operations that act on a single RDD, such as reduceByKey(), running on a prepartitioned RDD will cause all the values for each key to be computed locally on a single machine, requiring only the final, locally reduced value to be sent from each worker node back to the master. For binary operations, such as cogroup() and join(), pre-partitioning will cause at least one of the RDDs (the one with the known partitioner) to not be shuffled. `If both RDDs have the same partitioner, and if they are cached on the same machines (e.g., one was created using mapValues() on the other, which preserves keys and partitioning)` or if one of them has not yet been computed, then no shuffling across the network will occur.

#### Operations That Affect Partitioning
Spark knows internally how each of its operations affects partitioning, and automatically sets the partitioner on RDDs created by operations that partition the data. For example, suppose you called join() to join two RDDs; because the elements with the same key have been hashed to the same machine, Spark knows that the result is hash-partitioned, and operations like reduceByKey() on the join result are going to be significantly faster.

The flipside, however, is that for transformations that cannot be guaranteed to produce a known partitioning, the output RDD will not have a partitioner set. For example, `if you call map() on a hash-partitioned RDD of key/value pairs, the function passed to map() can in theory change the key of each element, so the result will not have a partitioner`. Spark does not analyze your functions to check whether they retain the key. Instead, it provides two other operations, mapValues() and flatMapValues(), which guarantee that each tuple’s key remains the same.

All that said, here are all the operations that `result in a partitioner being set on the output RDD`: `cogroup(), groupWith(), join(), leftOuterJoin(), rightOuterJoin(), groupByKey(), reduceByKey(), combineByKey(), partitionBy(), sort(), mapValues() (if the parent RDD has a partitioner), flatMapValues() (if parent has a partitioner), and filter() (if parent has a partitioner)`. All other operations will produce a result with no partitioner.

Finally, for binary operations, which partitioner is set on the output depends on the parent RDDs’ partitioners. By default, it is a hash partitioner, with the number of partitions set to the level of parallelism of the operation. However, if one of the parents has a partitioner set, it will be that partitioner; and if both parents have a partitioner set, it will be the partitioner of the first parent.

#### Example: PageRank
As an example of a more involved algorithm that can benefit from RDD partitioning, we consider PageRank. The PageRank algorithm, named after Google’s Larry Page, `aims to assign a measure of importance (a “rank”) to each document in a set based on how many documents have links to it`. It can be used to rank web pages, of course, but also scientific articles, or influential users in a social network.  

PageRank is an iterative algorithm that performs many joins, so it is a good use case for RDD partitioning. The algorithm maintains two datasets: one of (pageID, linkList) elements containing the list of neighbors of each page, and one of (pageID, rank) elements containing the current rank for each page. It proceeds as follows:
1. Initialize each page’s rank to 1.0.
2. On each iteration, have page p send a contribution of rank(p)/numNeighbors(p) to its neighbors (the pages it has links to).
3. Set each page’s rank to 0.15 + 0.85 * contributionsReceived.  
The last two steps repeat for several iterations, during which the algorithm will converge to the correct PageRank value for each page. In practice, it’s typical to run about 10 iterations.

```scala
// Assume that our neighbor list was saved as a Spark objectFile
val links = sc.objectFile[(String, Seq[String])](“links”)
.partitionBy(new HashPartitioner(100))
.persist()
// Initialize each page’s rank to 1.0; since we use mapValues, the resulting RDD
// will have the same partitioner as links
var ranks = links.mapValues(v => 1.0)
// Run 10 iterations of PageRank
for (i <- 0 until 10) {
    val contributions = links.join(ranks).flatMap {
        case (pageId, (links, rank)) =>
            links.map(dest => (dest, rank / links.size))
    }
    ranks = contributions.reduceByKey((x, y) => x + y).mapValues(v => 0.15 + 0.85*v)
}
// Write out the final ranks
ranks.saveAsTextFile(“ranks”)
```
Although the code itself is simple, the example does several things to ensure that the RDDs are partitioned in an efficient way, and to minimize communication:  
1. Notice that the links RDD is joined against ranks on each iteration. `Since links is a static dataset, we partition it at the start with partitionBy()`, so that it does not need to be shuffled across the network. In practice, the links RDD is also likely to be much larger in terms of bytes than ranks, since it contains a list of neighbors for each page ID instead of just a Double, so this optimization saves considerable network traffic over a simple implementation of PageRank (e.g., in plain MapReduce).  
2. For the same reason, we call persist() on links to keep it in RAM across iterations.  
3. When we first create ranks, we `use mapValues() instead of map() to preserve the partitioning of the parent RDD (links)`, so that our first join against it is cheap.  
4. In the loop body, `we follow our reduceByKey() with mapValues()`; because the result of reduceByKey() is already hash-partitioned, this will make it more efficient to join the mapped result against links on the next iteration.

`To maximize the potential for partitioning-related optimizations, you should use mapValues() or flatMapValues() whenever you are not changing an element’s key.`

#### Custom Partitioners
While Spark’s HashPartitioner and RangePartitioner are well suited to many use cases, Spark also allows you to tune how an RDD is partitioned by providing a custom Partitioner object. This can help you further reduce communication by taking advantage of domain-specific knowledge.

For example, suppose we wanted to run the PageRank algorithm in the previous section on a set of web pages. Here each page’s ID (the key in our RDD) will be its URL. Using a simple hash function to do the partitioning, pages with similar URLs (e.g., http://www.cnn.com/WORLD and http://www.cnn.com/US) might be hashed to completely different nodes. However, we know that web pages within the same domain tend to link to each other a lot. Because PageRank needs to send a message from each page to each of its neighbors on each iteration, it helps to group these pages into the same partition. We can do this with a custom Partitioner that looks at just the domain name instead of the whole URL.

To implement a custom partitioner, you need to subclass the `org.apache.spark.Partitioner` class and implement three methods:  
* numPartitions: Int, which returns the number of partitions you will create.
* getPartition(key: Any): Int, which returns the partition ID (0 to numPartitions-1) for a given key.
* equals(), the standard Java equality method. This is important to implement because Spark will need to test your Partitioner object against other instances of itself when it decides whether two of your RDDs are partitioned the same way!

`One gotcha is that if you rely on Java’s hashCode() method in your algorithm, it can return negative numbers`. You need to be careful to ensure that getPartition() always returns a nonnegative result.  

Example 4-26 shows how we would write the domain-name-based partitioner sketched previously, which hashes only the domain name of each URL.   
```scala
class DomainNamePartitioner(numParts: Int) extends Partitioner {
        override def numPartitions: Int = numParts
        override def getPartition(key: Any): Int = {
                val domain = new Java.net.URL(key.toString).getHost()
                val code = (domain.hashCode % numPartitions)
                if (code < 0) {
                    code + numPartitions // Make it non-negative
                } else {
                        code
                }
        }
        // Java equals method to let Spark compare our Partitioner objects
        override def equals(other: Any): Boolean = other match {
            case dnp: DomainNamePartitioner =>
                dnp.numPartitions == numPartitions
            case _ =>
                false
        }
}
```

In Python, you do not extend a Partitioner class, but instead pass a hash function as an additional argument to RDD.partitionBy(). Example 4-27 demonstrates.  
**Example 4-27. Python custom partitioner**
```python
import urlparse
def hash_domain(url):
    return hash(urlparse.urlparse(url).netloc)
rdd.partitionBy(20, hash_domain) # Create 20 partitions
```
Note that the hash function you pass will be compared by identity to that of other RDDs. If you want to partition multiple RDDs with the same partitioner, pass the same function object (e.g., a global function) instead of creating a new lambda for each one!

## Chapter 5. Loading and Saving Your Data
Spark supports a wide range of input and output sources, partly because it builds on the ecosystem available for Hadoop. `In particular, Spark can access data through the InputFormat and OutputFormat interfaces used by Hadoop MapReduce`, which are available for many common file formats and storage systems (e.g., S3, HDFS, Cassandra, HBase, etc.)

More commonly, though, you will want to use higher-level APIs built on top of these raw interfaces. Luckily, Spark and its ecosystem provide many options here. In this chapter, we will cover three common sets of data sources:
* File formats and filesystems  
For data stored in a local or distributed filesystem, such as NFS, HDFS, or Amazon S3, Spark can access a variety of file formats including text, JSON, SequenceFiles, and protocol buffers.
* Structured data sources through Spark SQL  
The Spark SQL module, covered in Chapter 9, provides a nicer and often more efficient API for structured data sources, including JSON and Apache Hive.
* Databases and key/value stores  
We will sketch built-in and third-party libraries for connecting to Cassandra, HBase, Elasticsearch, and JDBC databases

### File Formats
Table 5-1. Common supported file formats  
* Text files
* JSON
* CSV
* SequenFiles
* Protocol buffers  
A fast, space-efficient multilanguage format. 
* Object files  
Useful for saving data from a Spark job to be consumed by shared code. Breaks if you change your classes, as `it relies on Java Serialization`

In addition to the output mechanisms supported directly in Spark, we can use both Hadoop’s new and old file APIs for keyed (or paired) data.

#### Text Files
We can also load multiple whole text files at the same time into a pair RDD, with the key being the name and the value being the contents of each file.
```scala
val input = sc.textFile(“file:///home/holden/repos/spark/README.md”)

result.saveAsTextFile(outputFile)
```

Multipart inputs in the form of a directory containing all of the parts can be handled in two ways. We can just use the same textFile method and pass it a directory and it will load all of the parts into our RDD. 

Sometimes it’s important to know which file which piece of input came from (such as time data with the key in the file) or we need to process an entire file at a time. If our files are `small enough, then we can use the SparkContext.wholeTextFiles()` method and get back a pair RDD where the key is the name of the input file.

**Example 5-4. Average value per file in Scala**  
```scala
val input = sc.wholeTextFiles(“file://home/holden/salesFiles”)
val result = input.mapValues{y =>
    val nums = y.split(” “).map(x => x.toDouble)
    nums.sum / nums.size.toDouble
}
```

Spark supports reading all the files `in a given directory` and doing `wildcard expansion` on the input (e.g., part-*.txt).

#### JSON
JSON is a popular semistructured data format. `The simplest way to load JSON data is by loading the data as a text file and then mapping over the values with a JSON parser`. Likewise, we can use our preferred JSON serialization library to write out the values to strings, which we can then write out. In Java and Scala we can also work with JSON data using a custom Hadoop format. “JSON” also shows how to load JSON data with Spark SQL.

Loading the data as a text file and then parsing the JSON data is an approach that we can use in all of the supported languages. `This works assuming that you have one JSON record per row;` if you have multiline JSON files, you will instead have to load the whole file and then parse each file. If constructing a JSON parser is expensive in your language, you can use mapPartitions() to reuse the parser

There are a wide variety of JSON libraries available for the three languages we are looking at, but for simplicity’s sake we are considering only one library per language. In Python we will use the built-in library (Example 5-6), and in Java and Scala we will use **Jackson** (Examples 5-7 and 5-8). These libraries have been chosen because they perform reasonably well and are also relatively simple.

**Example 9-21. Input records**
```json
{“name”: “Holden”}
{“name”:“Sparky The Bear”, “lovesPandas”:true, “knows”:{“friends”: [“holden”]}}
```

**Example 5-6. Loading unstructured JSON in Python**  
```python
import json
data = input.map(lambda x: json.loads(x))
```

In Scala and Java, it is common to load records into a class representing their schemas. At this stage, we may also want to skip invalid records. We show an example of loading records as instances of a Person class.

**Example 5-7. Loading JSON in Scala**  
```scala
import com.fasterxml.jackson.module.scala.DefaultScalaModule
import com.fasterxml.jackson.module.scala.experimental.ScalaObjectMapper
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.DeserializationFeature
… 
case class Person(name: String, lovesPandas: Boolean) // Must be a top-level class
… 
// Parse it into a specific case class. We use flatMap to handle errors
// by returning an empty list (None) if we encounter an issue 
// or a list with one element if everything is ok (Some(_)).
val result = input.flatMap(record => {
    try {
            Some(mapper.readValue(record, classOf[Person]))
        } catch {
            case e: Exception => None
        }})
```

**Example 5-8. Loading JSON in Java**  
```java
class ParseJson implements FlatMapFunction<Iterator<String>, Person> {
        public Iterable<Person> call(Iterator<String> lines) throws Exception {
                ArrayList<Person> people = new ArrayList<Person>();
                ObjectMapper mapper = new ObjectMapper();
                while (lines.hasNext()) {
                        String line = lines.next();
                        try {
                                people.add(mapper.readValue(line, Person.class));
                        } catch (Exception e) {
                            // skip records on failure
                        }
                }
                return people;
        }
} 
JavaRDD<String> input = sc.textFile(“file.json”);
JavaRDD<Person> result = input.mapPartitions(new ParseJson());
```

Writing out JSON files is much simpler compared to loading it, because we don’t have to worry about incorrectly formatted data and we know the type of the data that we are writing out. We can use the same libraries we used to convert our RDD of strings into parsed JSON data and instead take our RDD of structured data and convert it into an RDD of strings, which we can then write out using Spark’s text file API.

**Example 5-9. Saving JSON in Python**  
```python
(data.filter(lambda x: x[‘lovesPandas’]).map(lambda x: json.dumps(x))
    .saveAsTextFile(outputFile))
```
**Example 5-10. Saving JSON in Scala**
```scala
result.filter(p => P.lovesPandas).map(mapper.writeValueAsString(_))
        .saveAsTextFile(outputFile)
```

If you have a JSON file with records fitting the same schema, Spark SQL can infer the schema by scanning the file and let you access fields by name (Example 9-21). If you have ever found yourself staring at a huge directory of JSON records, Spark SQL’s schema inference is a very effective way to start working with the data without writing any special loading code.

**Example 9-21. Input records**
```json
{“name”: “Holden”}
{“name”:“Sparky The Bear”, “lovesPandas”:true, “knows”:{“friends”: [“holden”]}}
```

#### Comma-Separated Values and Tab-Separated Values
Comma-separated value (CSV) files are supposed to contain a fixed number of fields per line, and the fields are separated by a comma (or a tab in the case of tab-separated value, or TSV, files). Records are often stored one per line, but this is not always the case as records can sometimes span lines. CSV and TSV files can sometimes be inconsistent, most frequently with respect to handling newlines, escaping, and rendering non-ASCII characters, or noninteger numbers. CSVs cannot handle nested field types natively, so we have to unpack and pack to specific fields manually. 

Unlike with JSON fields, each record doesn’t have field names associated with it; instead we get back row numbers. It is common practice in single CSV files to make the first row’s column values the names of each field.

Loading CSV/TSV data is similar to loading JSON data in that we can first load it as text and then process it. The lack of standardization of format leads to different versions of the same library sometimes handling input in different ways.  

As with JSON, there are many different CSV libraries, but we will use only one for each language. Once again, in Python we use the included `csv` library. In both Scala and Java we use `opencsv`.

There is also a Hadoop InputFormat, `CSVInputFormat`, that we can use to load CSV data in Scala and Java, although it does not support records containing newlines.

```python
import csv
import StringIO
… 
def loadRecord(line):
    “““Parse a CSV line”””
    input = StringIO.StringIO(line)
    reader = csv.DictReader(input, fieldnames=[“name”, “favouriteAnimal”])
    return reader.next()
input = sc.textFile(inputFile).map(loadRecord)
```

```scala
import Java.io.StringReader
import au.com.bytecode.opencsv.CSVReader
… 
val input = sc.textFile(inputFile)
val result = input.map{ line =>
    val reader = new CSVReader(new StringReader(line));
    reader.readNext();
}
```

```java
import au.com.bytecode.opencsv.CSVReader;
import Java.io.StringReader;
… 
public static class ParseLine implements Function<String, String[]> {
        public String[] call(String line) throws Exception {
                CSVReader reader = new CSVReader(new StringReader(line));
                return reader.readNext();
        }
} 
JavaRDD<String> csvFile1 = sc.textFile(inputFile);
// JavaPairRDD<String, AvgCount> avgCounts
JavaPairRDD<String[]> csvData = csvFile1.map(new ParseLine());
```
Note that returning type is JavaPairRDD<String[]>

If there are embedded newlines in fields, we will need to load each file in full and parse the entire segment, as shown in Examples 5-15 through 5-17. This is unfortunate because if each file is large it can introduce bottlenecks in loading and parsing. The different text file loading methods are described “Loading text files”.  

**Example 5-15. Loading CSV in full in Python**  
```python
def loadRecords(fileNameContents):
    “““Load all the records in a given file”””
    input = StringIO.StringIO(fileNameContents[1])
    reader = csv.DictReader(input, fieldnames=[“name”, “favoriteAnimal”])
    return reader
fullFileData = sc.wholeTextFiles(inputFile).flatMap(loadRecords)
```
**Example 5-16. Loading CSV in full in Scala**
```scala
case class Person(name: String, favoriteAnimal: String)
val input = sc.wholeTextFiles(inputFile)
val result = input.flatMap{ case (_, txt) =>
    val reader = new CSVReader(new StringReader(txt));
    reader.readAll().map(x => Person(x(0), x(1)))
}
```
**Example 5-17. Loading CSV in full in Java**  
```java
public static class ParseLine implements FlatMapFunction<Tuple2<String, String>, String[]> {
        public Iterable<String[]> call(Tuple2<String, String> file) throws Exception {
                CSVReader reader = new CSVReader(new StringReader(file._2()));
                return reader.readAll();
        }
} 
JavaPairRDD<String, String> csvData = sc.wholeTextFiles(inputFile);
JavaRDD<String[]> keyedRDD = csvData.flatMap(new ParseLine());
```

If there are only a few input files, and you need to use the wholeFile() method, you may want to repartition your input to allow Spark to effectively parallelize your future operations.

Since in CSV we don’t output the field name with each record, to have a consistent output we need to create a mapping. One of the easy ways to do this is to just write a function that converts the fields to given positions in an array. In Python, if we are outputting dictionaries the CSV writer can do this for us based on the order in which we provide the fieldnames when constructing the writer.

```python
def writeRecords(records):
        “““Write out CSV lines”””
        output = StringIO.StringIO()
        writer = csv.DictWriter(output, fieldnames=[“name”, “favoriteAnimal”])
        for record in records:
                writer.writerow(record)
        return [output.getvalue()]
pandaLovers.mapPartitions(writeRecords).saveAsTextFile(outputFile)
```

```scala
pandaLovers.map(person => List(person.name, person.favoriteAnimal).toArray)
.mapPartitions{people =>
    val stringWriter = new StringWriter();
    val csvWriter = new CSVWriter(stringWriter);
    csvWriter.writeAll(people.toList)
    Iterator(stringWriter.toString)
    }.saveAsTextFile(outFile)
```

#### SequenceFiles
The standard rule of thumb is to try adding the word Writable to the end of your class name and see if it is a known subclass of org.apache.hadoop.io.Writable(such as IntWritable or VIntWritable). If you can’t find a Writable for the data you are trying to write out (for example, a custom case class), you can go ahead and implement your own Writable class by overriding readFields and write from org.apache.hadoop.io.Writable.

Hadoop’s RecordReader reuses the same object for each record, `so directly calling cache on an RDD you read in like this can fail`; instead, add a simple map() operation and cache its result. Furthermore, many `Hadoop Writable classes do not implement java.io.Serializable`, so for them to work in RDDs we need to convert them with a map() anyway.

Note that you will need to use Java and Scala to define custom Writable types, however. The Python Spark API knows only how to convert the basic Writables available in Hadoop to Python, and makes a best effort for other classes based on their available getter methods.

Spark has a specialized API for reading in SequenceFiles. On the SparkContext we can `call sequenceFile(path, keyClass, valueClass, minPartitions)`.

**Example 5-20. Loading a SequenceFile in Python**
```python
val data = sc.sequenceFile(inFile,
“org.apache.hadoop.io.Text”, “org.apache.hadoop.io.IntWritable”)
```
**Example 5-21. Loading a SequenceFile in Scala**
```scala
val data = sc.sequenceFile(inFile, classOf[Text], classOf[IntWritable]).
map{case (x, y) => (x.toString, y.get())}
```

In Scala there is a convenience function that can automatically convert Writables to their corresponding Scala type. Instead of specifying the keyClass and valueClass, we can call sequenceFile[Key, Value](path, minPartitions) and get back an RDD of native Scala types.

Writing the data out to a SequenceFile is fairly similar in Scala. First, because SequenceFiles are key/value pairs, we need a PairRDD with types that our SequenceFile can write out. Implicit conversions between Scala types and Hadoop Writables exist for many native types, so if you are writing out a native type you can just save your PairRDD by calling `saveAsSequenceFile(path)`, and it will write out the data for you. If there isn’t an automatic conversion from our key and value to Writable, or we want to use variablelength types (e.g., VIntWritable), we can just map over the data and convert it before saving.

```scala
val data = sc.parallelize(List((“Panda”, 3), (“Kay”, 6), (“Snail”, 2)))
data.saveAsSequenceFile(outputFile)
```

#### Object Files
`Object files are a deceptively simple wrapper around SequenceFiles that allows us to save our RDDs containing just values`. Unlike with SequenceFiles, with object files the values are written out `using Java Serialization`.

If you change your classes — for example, to add and remove fields — old object files may no longer be readable. Object files use Java Serialization, which has some support for managing compatibility across class versions but requires programmer effort to do so.

Using Java Serialization for object files has a number of implications. Unlike with normal SequenceFiles, the output will be different than Hadoop outputting the same objects. `Unlike the other formats, object files are mostly intended to be used for Spark jobs communicating with other Spark jobs`. `Java Serialization can also be quite slow`.  

Saving an object file is as simple as calling `saveAsObjectFile` on an RDD. Reading an object file back is also quite simple: the function `objectFile() on the SparkContext` takes in a path and returns an RDD.  

With all of these warnings about object files, you might wonder why anyone would use them. `The primary reason to use object files is that they require almost no work to save almost arbitrary objects.`  

Object files are not available in Python, but the Python RDDs and SparkContext support methods called saveAsPickleFile() and pickleFile() instead. These use `Python’s pickle serialization library`. The same caveats for object files apply to pickle files, however: `the pickle library can be slow, and old files may not be readable if you change your classes.`

#### Hadoop Input and Output Formats
In addition to the formats Spark has wrappers for, we can also interact with any Hadoopsupported formats. Spark supports both the “old” and “new” Hadoop file APIs, providing a great amount of flexibility

To read in a file using the new Hadoop API we need to tell Spark a few things. The newAPIHadoopFile takes a path, and three classes. The first class is the “format” class, which is the class representing our input format. A similar function, hadoopFile(), exists for working with Hadoop input formats implemented with the older API. The next class is the class for our key, and the final class is the class of our value. If we need to specify additional Hadoop configuration properties, we can also pass in a conf object.

```scala
val input = sc.hadoopFile[Text, Text, KeyValueTextInputFormat](inputFile).map{
    case (x, y) => (x.toString, y.toString)
}
```

We looked at loading JSON data by loading the data as a text file and then parsing it, but we can also load JSON data using a custom Hadoop input format. This example requires setting up some extra bits for compression, so feel free to skip it. [Twitter’s Elephant Bird package] supports a large number of data formats, including JSON, Lucene, Protocol Buffer–related formats, and others. The package also works with both the new and old Hadoop file APIs. To illustrate how to work with the new-style Hadoop APIs from Spark, we’ll look at loading LZO-compressed JSON data with Lzo JsonInputFormat in Example 5-25.
**Example 5-25. Loading LZO-compressed JSON with Elephant Bird in Scala**
```scala
val input = sc.newAPIHadoopFile(inputFile, classOf[LzoJsonInputFormat],
classOf[LongWritable], classOf[MapWritable], conf)
// Each MapWritable in “input” represents a JSON object
```

In addition to the hadoopFile() and saveAsHadoopFile() family of functions, you can use hadoopDataset/saveAsHadoopDataSet and newAPIHadoopDataset/saveAsNewAPIHadoopDataset to access Hadoop-supported storage formats that are not filesystems. For example, many key/value stores, such as HBase and MongoDB, provide Hadoop input formats that read directly from the key/value store. You can easily use any such format in Spark.  

The hadoopDataset() family of functions just take a Configuration object on which you set the Hadoop properties needed to access your data source. You do the configuration the same way as you would configure a Hadoop MapReduce job, so you can follow the instructions for accessing one of these data sources in MapReduce and then pass the object to Spark.

##### Example: Protocol buffers
[Protocol buffers] were first developed at Google for internal remote procedure calls (RPCs) and have since been open sourced. Protocol buffers (PBs) are `structured data, with the fields and types of fields being clearly defined`. They are optimized to be fast for encoding and decoding and also take up the minimum amount of space. Compared to XML, PBs are `3× to 10× smaller and can be 20× to 100× faster to encode and decode`. While a PB has a consistent encoding, there are multiple ways to create a file consisting of many PB messages.

Protocol buffers are defined using a domain-specific language, and then the protocol buffer compiler can be used to generate accessor methods in a variety of languages (including all those supported by Spark). Since PBs aim to take up a minimal amount of space they are `not “self-describing”`, as encoding the description of the data would take up additional space. This means that to parse data that is formatted as PB, `we need the protocol buffer definition` to make sense of it.

`PBs consist of fields that can be either optional, required, or repeated.` When you’re parsing data, a missing optional field does not result in a failure, but a missing required field results in failing to parse the data. Therefore, when you’re adding new fields to existing protocol buffers it is good practice to make the new fields optional, as not everyone will upgrade at the same time (and even if they do, you might want to read your old data).

**Example 5-27. Sample protocol buffer definition**
```json
message Venue {
    required int32 id = 1;
    required string name = 2;
    required VenueType type = 3;
    optional string address = 4;
    enum VenueType {
        COFFEESHOP = 0;
        WORKPLACE = 1;
        CLUB = 2;
        OMNOMNOM = 3;
        OTHER = 4;
    }
}
message VenueResponse {
    repeated Venue results = 1;
}
```

[Twitter’s Elephant Bird package], which we used in the previous section to load JSON data, also supports loading and saving data from protocol buffers.

```scala
val job = new Job()
val conf = job.getConfiguration
LzoProtobufBlockOutputFormat.setClassConf(classOf[Places.Venue], conf);
val dnaLounge = Places.Venue.newBuilder()
dnaLounge.setId(1);
dnaLounge.setName(“DNA Lounge”)
dnaLounge.setType(Places.Venue.VenueType.CLUB)
val data = sc.parallelize(List(dnaLounge.build()))
val outputData = data.map{ pb =>
    val protoWritable = ProtobufWritable.newInstance(classOf[Places.Venue]);
    protoWritable.set(pb)
    (null, protoWritable)
} 
outputData.saveAsNewAPIHadoopFile(outputFile, classOf[Text],
        classOf[ProtobufWritable[Places.Venue]],
        classOf[LzoProtobufBlockOutputFormat[ProtobufWritable[Places.Venue]]], conf)
```

#### File Compression
Frequently when working with Big Data, we find ourselves needing to use compressed data to save storage space and network overhead.

These compression options apply only to the Hadoop formats that support compression, namely those that are written out to a filesystem. `The database Hadoop formats generally do not implement support for compression`, or if they have compressed records that is configured in the database itself.

**Table 5-3. Compression options**

Format  |Splittable |Average compression speed |Effectiveness on text |Hadoop compression codec |Pure Java |Native |Comments  
----------|---|--------------|---------------|-------------------|---|---|---------------------------------------------------------------------------
gzip       |N   |Fast           |High               |GzipCodec          |Y  |Y  |-
lzo         |Y   |Very fast    |Medium         |LzoCodec            |Y  |Y  |LZO requires installation every worker node
bzip2     |Y   |Slow           |Very high       |BZip2Codec        |Y  |Y  |Uses pure for splittable version
zlib        |N  |Slow           |Medium          |DefaultCodec     |Y  |Y  |Default compression codec for Hadoop
Snappy  |N   |Very Fast  |Low                |SnappyCodec       |N  |Y  |There is a Java port of Snappy but is not yet available in Spark/Hadoop

`While Spark’s textFile() method can handle compressed input, it automatically disables splittable even if the input is compressed such that it could be read in a splittable way.` If you find yourself needing to read in a large single-file compressed input, consider skipping Spark’s wrapper and instead use either newAPIHadoopFile or hadoopFile and specify the correct compression codec. 

Some input formats (like SequenceFiles) allow us to compress only the values in key/value data, which can be useful for doing lookups. Other input formats have their own compression control: for example, many of the formats in Twitter’s Elephant Bird package work with LZO compressed data.

### Filesystems
#### Local/“Regular” FS
While Spark supports loading files from the local filesystem, `it requires that the files are available at the same path on all nodes in your cluster`.  

Some network filesystems, like NFS, AFS, and MapR’s NFS layer, are exposed to the user as a regular filesystem. If your data is already in one of these systems, then you can use it as an input by just specifying a `file://` path; `Spark will handle it as long as the filesystem is mounted at the same path on each node `(see Example 5-29).
```scala
val rdd = sc.textFile(“file:///home/holden/happypandas.gz”)
```

If your file isn’t already on all nodes in the cluster, you can load it locally on the driver without going through Spark and then call parallelize to distribute the contents to workers. This approach can be slow, however, so we recommend putting your files in a shared filesystem like HDFS, NFS, or S3.

#### Amazon S3
Amazon S3 is an increasingly popular option for storing large amounts of data. S3 is especially fast when your compute nodes are located inside of Amazon EC2, `but can easily have much worse performance if you have to go over the public Internet`.

To access S3 in Spark, you should first set the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables to your S3 credentials. You can create these credentials from the Amazon Web Services console. Then pass a path starting with s3n:// to Spark’s file input methods, of the form s3n://bucket/path-within-bucket. As with all the other filesystems, Spark supports wildcard paths for S3, such as s3n://bucket/my-files/*.txt.

#### HDFS
The Hadoop Distributed File System (HDFS) is a popular distributed filesystem with which Spark works well. HDFS is designed to work on commodity hardware and be resilient to node failure while providing high data throughput. Spark and HDFS can be collocated on the same machines, and Spark can take advantage of this data locality to avoid network overhead.  

Using Spark with HDFS is as simple as specifying hdfs://master:port/path for your input and output.

#### Structured Data with Spark SQL
Spark SQL is a component added in Spark 1.0 that is quickly becoming Spark’s preferred way to work with structured and semistructured data. By structured data, we mean data that has a schema — that is, a consistent set of fields across data records. Spark SQL supports multiple structured data sources as input, and because it understands their schema, it can `efficiently read only the fields you require from these data sources`. 

In all cases, we give Spark SQL a SQL query to run on the data source (selecting some fields or a function of the fields), and we get back an RDD of Row objects, one per record. In Java and Scala, the Row objects allow access based on the column number. Each Row has a get() method that gives back a general type we can cast, and specific get() methods for common basic types (e.g., getFloat(), getInt(), getLong(), getString(), getShort(), and getBoolean()). In Python we can just access the elements with row[column_number] and row.column_name.

##### Apache Hive
Spark SQL can load any table supported by Hive.

To connect Spark SQL to an existing Hive installation, you need to provide a Hive configuration. You do so by copying your hive-site.xml file to Spark’s ./conf/ directory. Once you have done this, you create a HiveContext object, which is the entry point to Spark SQL, and you can write Hive Query Language (HQL) queries against your tables to get data back as RDDs of rows.
```python
from pyspark.sql import HiveContext
hiveCtx = HiveContext(sc)
rows = hiveCtx.sql(“SELECT name, age FROM users”)
firstRow = rows.first()
print firstRow.name
```

```scala
import org.apache.spark.sql.hive.HiveContext
val hiveCtx = new org.apache.spark.sql.hive.HiveContext(sc)
val rows = hiveCtx.sql(“SELECT name, age FROM users”)
val firstRow = rows.first()
println(firstRow.getString(0)) // Field 0 is the name
```

##### JSON 1
If you have JSON data with a consistent schema across records, Spark SQL can infer their schema and load this data as rows as well, making it very simple to pull out the fields you need. To load JSON data, first create a HiveContext as when using Hive. (No installation of Hive is needed in this case, though — that is, you don’t need a hive-site.xml file.) Then use the HiveContext.jsonFile method to get an RDD of Row objects for the whole file. Apart from using the whole Row object, you can also register this RDD as a table and select specific fields from it.

For example, suppose that we had a JSON file containing tweets in the format shown in Example 5-33, one per line.
**Example 5-33. Sample tweets in JSON**  
```json
{“user”: {“name”: “Holden”, “location”: “San Francisco”}, “text”: “Nice day out today”}
{“user”: {“name”: “Matei”, “location”: “Berkeley”}, “text”: “Even nicer here :)”}
```
```python
tweets = hiveCtx.jsonFile(“tweets.json”)
tweets.registerTempTable(“tweets”)
results = hiveCtx.sql(“SELECT user.name, text FROM tweets”)
```

```scala
val tweets = hiveCtx.jsonFile(“tweets.json”)
tweets.registerTempTable(“tweets”)
val results = hiveCtx.sql(“SELECT user.name, text FROM tweets”)
```

#### Databases
Spark can access several popular databases using either their Hadoop connectors or custom Spark connectors.

##### Java Database Connectivity
Spark can load data from any relational database that supports Java Database Connectivity (JDBC), including MySQL, Postgres, and other systems. To access this data, we construct an org.apache.spark.rdd.JdbcRDD and provide it with our SparkContext and the other parameters. Example 5-37 walks you through using JdbcRDD for a MySQL database.
```scala
def createConnection() = {
    Class.forName(“com.mysql.jdbc.Driver”).newInstance();
    DriverManager.getConnection(“jdbc:mysql://localhost/test?user=holden”);
}
def extractValues(r: ResultSet) = {
    (r.getInt(1), r.getString(2))
}
val data = new JdbcRDD(sc,
    createConnection, “SELECT * FROM panda WHERE ? <= id AND id <= ?”,
    lowerBound = 1, upperBound = 3, numPartitions = 2, mapRow = extractValues)
println(data.collect().toList)
```

JdbcRDD takes several parameters:   
* First, we provide a function to establish a connection to our database. This `lets each node create its own connection` to load data over, after performing any configuration required to connect.   
* Next, we provide a query that can read a range of the data, as well as a lowerBound and upperBound value for the parameter to this query. `These parameters allow Spark to query different ranges of the data on different machines`, so we don’t get bottlenecked trying to load all the data on a single node.  
* The last parameter is a function that converts each row of output from a java.sql.ResultSet to a format that is useful for manipulating our data. In Example 5-37, we will get (Int, String) pairs. If this parameter is left out, Spark will automatically convert each row to an array of objects.

As with other data sources, `when using JdbcRDD, make sure that your database can handle the load of parallel reads from Spark`. `If you’d like to query the data offline rather than the live database, you can always use your database’s export feature to export a text file`.

##### Cassandra
Spark’s Cassandra support has improved greatly with the introduction of the open source [Spark Cassandra connector] from DataStax. Since the connector is not currently part of Spark, you will need to add some further dependencies to your build file. `Cassandra doesn’t yet use Spark SQL, but it returns RDDs of CassandraRow objects`, which have some of the same methods as Spark SQL’s Row object, as shown in Examples 5-38 and 5- 39.The Spark Cassandra connector is currently only available in Java and Scala.

**Example 5-38. sbt requirements for Cassandra connector**
```html
“com.datastax.spark” %% “spark-cassandra-connector” % “1.0.0-rc5”,
“com.datastax.spark” %% “spark-cassandra-connector-java” % “1.0.0-rc5”
```
***Example 5-39. Maven requirements for Cassandra connector***
```xml
<dependency> <!— Cassandra —>
    <groupId>com.datastax.spark</groupId>
    <artifactId>spark-cassandra-connector</artifactId>
    <version>1.0.0-rc5</version>
</dependency>
<dependency> <!— Cassandra —>
    <groupId>com.datastax.spark</groupId>
    <artifactId>spark-cassandra-connector-java</artifactId>
    <version>1.0.0-rc5</version>
</dependency>
```
Much like with Elasticsearch, the Cassandra connector reads a job property to determine which cluster to connect to. We set the `spark.cassandra.connection.host` to point to our Cassandra cluster and if we have a username and password we can set them with `spark.cassandra.auth.username` and `spark.cassandra.auth.password`. Assuming you have only a single Cassandra cluster to connect to, we can set this up when we are creating our SparkContext as shown in Examples 5-40 and 5-41.

```scala
val conf = new SparkConf(true)
            .set(“spark.cassandra.connection.host”, “hostname”)
val sc = new SparkContext(conf)
```

The Datastax Cassandra connector uses implicits in Scala to provide some additional functions on top of the SparkContext and RDDs. Let’s import the implicit conversions and try loading some data (Example 5-42).
```scala
// Implicits that add functions to the SparkContext & RDDs.
import com.datastax.spark.connector._
// Read entire table as an RDD. Assumes your table test was created as
// CREATE TABLE test.kv(key text PRIMARY KEY, value int);
val data = sc.cassandraTable(“test” , “kv”)
// Print some basic stats on the value field.
data.map(row => row.getInt(“value”)).stats()
```

```java
import com.datastax.spark.connector.CassandraRow;
import static com.datastax.spark.connector.CassandraJavaUtil.javaFunctions;
// Read entire table as an RDD. Assumes your table test was created as
// CREATE TABLE test.kv(key text PRIMARY KEY, value int);
JavaRDD<CassandraRow> data = javaFunctions(sc).cassandraTable(“test” , “kv”);
// Print some basic stats.
System.out.println(data.mapToDouble(new DoubleFunction<CassandraRow>() {
        public double call(CassandraRow row) { return row.getInt(“value”); }
}).stats());
```

The Cassandra connector supports saving to Cassandra from a variety of RDD types. We can directly save RDDs of CassandraRow objects, which is useful for copying data between tables. We can save RDDs that aren’t in row form as tuples and lists by specifying the column mapping, as Example 5-44 shows.  
**Example 5-44. Saving to Cassandra in Scala**  
```scala
val rdd = sc.parallelize(List(Seq(“moremagic”, 1)))
rdd.saveToCassandra(“test” , “kv”, SomeColumns(“key”, “value”))
```

##### HBase
Spark can access HBase through its Hadoop input format, implemented in the `org.apache.hadoop.hbase.mapreduce.TableInputFormat` class. This input format returns key/value pairs where the key is of type `org.apache.hadoop.hbase.io.ImmutableBytesWritable` and the value is of type `org.apache.hadoop.hbase.client.Result`. The Result class includes various methods for getting values based on their column family, as described in its API documentation.

To use Spark with HBase, you can call SparkContext.newAPIHadoopRDD with the correct input format, as shown for Scala in Example 5-45.  
**Example 5-45. Scala example of reading from HBase**
```scala
import org.apache.hadoop.hbase.HBaseConfiguration
import org.apache.hadoop.hbase.client.Result
import org.apache.hadoop.hbase.io.ImmutableBytesWritable
import org.apache.hadoop.hbase.mapreduce.TableInputFormat
val conf = HBaseConfiguration.create()
conf.set(TableInputFormat.INPUT_TABLE, “tablename”) // which table to scan
val rdd = sc.newAPIHadoopRDD(
            conf, classOf[TableInputFormat], classOf[ImmutableBytesWritable], classOf[Result])
```
To optimize reading from HBase, TableInputFormat includes multiple settings such as limiting the scan to just one set of columns and limiting the time ranges scanned. You can find these options in the TableInputFormat API documentation and set them on your HBaseConfiguration before passing it to Spark.

##### Elasticsearch
Spark can both read and write data from Elasticsearch using [Elasticsearch-Hadoop]. Elasticsearch is a new open source, Lucene-based search system.

The Elasticsearch connector is a bit different than the other connectors we have examined, since it ignores the path information we provide and instead depends on setting up configuration on our SparkContext. The Elasticsearch OutputFormat connector also doesn’t quite have the types to use Spark’s wrappers, so we instead use saveAsHadoopDataSet, which means we need to set more properties by hand. Let’s look at how to read/write some simple data to Elasticsearch in Examples 5-46 and 5-47.

**Example 5-46. Elasticsearch output in Scala**
```scala
val jobConf = new JobConf(sc.hadoopConfiguration)
jobConf.set(“mapred.output.format.class”, “org.elasticsearch.hadoop.mr.EsOutputFormat”)
jobConf.setOutputCommitter(classOf[FileOutputCommitter])
jobConf.set(ConfigurationOptions.ES_RESOURCE_WRITE, “twitter/tweets”)
jobConf.set(ConfigurationOptions.ES_NODES, “localhost”)
FileOutputFormat.setOutputPath(jobConf, new Path(“-”))
output.saveAsHadoopDataset(jobConf)
```
**Example 5-47. Elasticsearch input in Scala**  
```scala
def mapWritableToInput(in: MapWritable): Map[String, String] = {
    in.map{case (k, v) => (k.toString, v.toString)}.toMap
}
val jobConf = new JobConf(sc.hadoopConfiguration)
jobConf.set(ConfigurationOptions.ES_RESOURCE_READ, args(1))
jobConf.set(ConfigurationOptions.ES_NODES, args(2))
val currentTweets = sc.hadoopRDD(jobConf,
    classOf[EsInputFormat[Object, MapWritable]], classOf[Object],
    classOf[MapWritable])
// Extract only the map
// Convert the MapWritable[Text, Text] to Map[String, String]
val tweets = currentTweets.map{ case (key, value) => mapWritableToInput(value) }
```

## Chapter 6. Advanced Spark Programming
We introduce two types of shared variables: **accumulators** to aggregate information and **broadcast** variables to efficiently distribute large values. Building on our existing transformations on RDDs, we introduce `batch operations` for tasks with high setup costs, like querying a database. To expand the range of tools accessible to us, we cover Spark’s methods for interacting with external programs, such as scripts written in R.

Throughout this chapter we build an example using ham radio operators’ call logs as the input. These logs, at the minimum, include the call signs of the stations contacted. Call signs are assigned by country, and each country has its own range of call signs so we can look up the countries involved. Some call logs also include the physical location of the operators, which we can use to determine the distance involved. We include a sample log entry in Example 6-1. The book’s sample repo includes a list of call signs to look up the call logs for and process the results.

**Example 6-1. Sample call log entry in JSON, with some fields removed**
```html
{“address”:“address here”, “band”:“40m”,“callsign”:“KK6JLK”,“city”:“SUNNYVALE”,
“contactlat”:“37.384733”,“contactlong”:“-122.032164”,
“county”:“Santa Clara”,“dxcc”:“291”,“fullname”:“MATTHEW McPherrin”,
“id”:57779,“mode”:“FM”,“mylat”:“37.751952821”,“mylong”:“-122.4208688735”,…}
```

The first set of Spark features we’ll look at are shared variables, which are a special type of variable you can use in Spark tasks. In our example we use Spark’s shared variables to count nonfatal error conditions and distribute a large lookup table.

When our task involves a `large setup time, such as creating a database connection or random-number generator`, it is useful to share this setup work across multiple data items. Using a remote call sign lookup database, we examine how to reuse setup work by operating on a per-partition basis.

### Accumulators
When we normally pass functions to Spark, such as a map() function or a condition for filter(), they can use variables defined outside them in the driver program, but each task running on the cluster gets a new copy of each variable, and updates from these copies are not propagated back to the driver. Spark’s `shared variables`, **accumulators** and **broadcast** variables, relax this restriction for two common types of communication patterns: aggregation of results and broadcasts.

Our first type of shared variable, accumulators, provides a simple syntax for aggregating values from worker nodes back to the driver program.

**Example 6-2. Accumulator empty line count in Python**  
```python
file = sc.textFile(inputFile)
# Create Accumulator[Int] initialized to 0
blankLines = sc.accumulator(0)
def extractCallSigns(line):
    global blankLines # Make the global variable accessible
    if (line == ””):
        blankLines += 1
    return line.split(” “)
callSigns = file.flatMap(extractCallSigns)
callSigns.saveAsTextFile(outputDir + “/callsigns”)
print “Blank lines: %d” % blankLines.value
```
**Example 6-3. Accumulator empty line count in Scala**
```scala
val sc = new SparkContext(…)
val file = sc.textFile(“file.txt”)
val blankLines = sc.accumulator(0) // Create an Accumulator[Int] initialized to 0
val callSigns = file.flatMap(line => {
    if (line == ””) {
        blankLines += 1 // Add to the accumulator
    }
    line.split(” “)
})
callSigns.saveAsTextFile(“output.txt”)
println(“Blank lines: “ + blankLines.value)
```
Note that we will see the right count only after we run the saveAsTextFile() action, because the transformation above it, map(), is lazy, so the sideeffect incrementing of the accumulator will happen only when the lazy map() transformation is forced to occur by the saveAsTextFile() action.

`Of course, it is possible to aggregate values from an entire RDD back to the driver program using actions like reduce()`, but sometimes we need a simple way to aggregate values that, in the process of transforming an RDD, are generated at different scale or granularity than that of the RDD itself. In the previous example, accumulators let us count errors as we load the data, without doing a separate filter() or reduce().

To summarize, accumulators work as follows:  
* We create them in the driver by calling the SparkContext.accumulator(initialValue) method, which produces an accumulator holding an initial value. The return type is an org.apache.spark.Accumulator[T] object, where T is the type of initialValue.  
* Worker code in Spark closures can add to the accumulator with its += method (or add in Java).  
* The driver program can call the value property on the accumulator to access its value (or call value() and setValue() in Java).

`Note that tasks on worker nodes cannot access the accumulator’s value() — from the point of view of these tasks, accumulators are write-only variables`. This allows accumulators to be implemented efficiently, without having to communicate every update.

The type of counting shown here becomes especially handy when there are multiple values to keep track of, or when the same value needs to increase at multiple places in the parallel program. The value of our accumulators is available only in the driver
program, so that is where we place our checks. 
**Example 6-5. Accumulator error count in Python**  
```html
# Create Accumulators for validating call signs
validSignCount = sc.accumulator(0)
invalidSignCount = sc.accumulator(0)
def validateSign(sign):
    global validSignCount, invalidSignCount
    if re.match(r”\A\d?[a-zA-Z]{1,2}\d{1,4}[a-zA-Z]{1,3}\Z”, sign):
        validSignCount += 1
        return True
    else:
        invalidSignCount += 1
        return False
# Count the number of times we contacted each call sign
validSigns = callSigns.filter(validateSign)
contactCount = validSigns.map(lambda sign: (sign, 1)).reduceByKey(lambda (x, y): x + y)
# Force evaluation so the counters are populated
contactCount.count()
if invalidSignCount.value < 0.1 * validSignCount.value:
    contactCount.saveAsTextFile(outputDir + “/contactCount”)
else:
    print “Too many errors: %d in %d” % (invalidSignCount.value, validSignCount.value)
```
#### Accumulators and Fault Tolerance
Spark automatically deals with failed or slow machines by re-executing failed or slow tasks. For example, if the node running a partition of a map() operation crashes, Spark will rerun it on another node; and even if the node does not crash but is simply much slower than other nodes, Spark can preemptively launch a “speculative” copy of the task on another node, and take its result if that finishes. Even if no nodes fail, Spark may have to rerun a task to rebuild a cached value that falls out of memory. The net result is therefore that the same function may run multiple times on the same data depending on what happens on the cluster.

How does this interact with accumulators? The end result is that` for accumulators used in actions, Spark applies each task’s update to each accumulator only once`. Thus, `if we want a reliable absolute value counter, regardless of failures or multiple evaluations, we must put it inside an action like foreach()`.

`For accumulators used in RDD transformations instead of actions, this guarantee does not exist`. An accumulator update within a transformation can occur more than once. One such case of a probably unintended multiple update occurs when a cached but infrequently used RDD is first evicted from the LRU cache and is then subsequently needed. This forces the RDD to be recalculated from its lineage, with the unintended side effect that calls to update an accumulator within the transformations in that lineage are sent again to the driver. Within transformations, accumulators should, consequently, be used only for debugging purposes.

#### Custom Accumulators
So far we’ve seen how to use one of Spark’s built-in accumulator types: integers (Accumulator[Int]) with addition. Out of the box, Spark supports accumulators of type Double, Long, and Float. In addition to these, Spark also includes an API to define custom accumulator types and custom aggregation operations (e.g., finding the maximum of the accumulated values instead of adding them). Custom accumulators need to extend AccumulatorParam, which is covered in the Spark API documentation. Beyond adding to a numeric value, we can use any operation for add, provided that operation is commutative and associative. For example, instead of adding to track the total we could keep track of the maximum value seen so far.

An operation op is **commutative** if a op b = b op a for all values a, b.  
An operation op is **associative** if (a op b) op c = a op (b op c) for all values a, b, and c.  

### Broadcast Variables
Spark’s second type of shared variable, broadcast variables, allows the program to efficiently send `a large, read-only value` to all the worker nodes for use in one or more Spark operations. They come in handy, for example, if your application needs to send a large, read-only lookup table to all the nodes, or even a large feature vector in a machine learning algorithm.

Recall that Spark automatically sends all variables referenced in your closures to the worker nodes. While this is convenient, it can also be inefficient because (1) the default task launching mechanism is optimized for small task sizes, and (2) you might, in fact, use the same variable in multiple parallel operations, but Spark will send it separately for each operation.

As an example, say that we wanted to write a Spark program that looks up countries by their call signs by prefix matching in an array. This is useful for ham radio call signs since each country gets its own prefix, although the prefixes are not uniform in length. If we wrote this naively in Spark, the code might look like Example 6-6.

**Example 6-6. Country lookup in Python**
```python
# Look up the locations of the call signs on the
# RDD contactCounts. We load a list of call sign
# prefixes to country code to support this lookup.
signPrefixes = loadCallSignTable()
def processSignCount(sign_count, signPrefixes):
    country = lookupCountry(sign_count[0], signPrefixes)
    count = sign_count[1]
    return (country, count)
countryContactCounts = (contactCounts
                                            .map(processSignCount)
                                            .reduceByKey((lambda x, y: x+ y)))
```
This program would run, but if we had a larger table (say, with IP addresses instead of call signs), the signPrefixes could easily be several megabytes in size, making it expensive to send that Array from the master alongside each task. In addition, if we used the same signPrefixes object later (maybe we next ran the same code on file2.txt), it would be sent again to each node.

We can fix this by making signPrefixes a broadcast variable. A broadcast variable is simply an object of type `spark.broadcast.Broadcast[T]`, which wraps a value of type T. We can access this value by calling value on the Broadcast object in our tasks. `The value is sent to each node only once, using an efficient, BitTorrent-like communication mechanism`.  
**Example 6-7. Country lookup with Broadcast values in Python**  
```python
# Look up the locations of the call signs on the
# RDD contactCounts. We load a list of call sign
# prefixes to country code to support this lookup.
signPrefixes = sc.broadcast(loadCallSignTable())
def processSignCount(sign_count, signPrefixes):
    country = lookupCountry(sign_count[0], signPrefixes)
    count = sign_count[1]
    return (country, count)
countryContactCounts = (contactCounts
                                            .map(processSignCount)
                                            .reduceByKey((lambda x, y: x+ y)))
countryContactCounts.saveAsTextFile(outputDir + “/countries.txt”)
```

As shown in these examples, the process of using broadcast variables is simple:  
1. Create a Broadcast[T] by calling SparkContext.broadcast on an object of type T. Any type works `as long as it is also Serializable`.  
2. Access its value with the value property (or value() method in Java).  
3. The variable will be sent to each node `only once`, and should be treated as `read-only` (updates will not be propagated to other nodes).

`The easiest way to satisfy the read-only requirement is to broadcast a primitive value or a reference to an immutable object`. In such cases, you won’t be able to change the value of the broadcast variable except within the driver code. However, `sometimes it can be more convenient or more efficient to broadcast a mutable object. If you do that, it is up to you to maintain the read-only condition`. As we did with our call sign prefix table of Array[String], we must make sure that the code we run on our worker nodes does not try to do something like val theArray = broadcastArray.value; theArray(0) = newValue. When run in a worker node, that line will assign newValue to the first array element only in the copy of the array local to the worker node running the code; it will not change the contents of broadcastArray.value on any of the other worker nodes.

#### Optimizing Broadcasts
When we are broadcasting large values, it is important to choose a data serialization format that is both fast and compact, because the time to send the value over the network can quickly become a bottleneck if it takes a long time to either serialize a value or to send the serialized value over the network. `In particular, Java Serialization, the default serialization library used in Spark’s Scala and Java APIs, can be very inefficient out of the box for anything except arrays of primitive types`. You can optimize serialization by selecting a different serialization library using the spark.serializer property (Chapter 8 will describe how to use Kryo, a faster serialization library), or by implementing your own serialization routines for your data types (e.g., using the java.io.Externalizable interface for Java Serialization, or using the reduce() method to define custom serialization for Python’s pickle library).

### Working on a Per-Partition Basis
Working with data on a per-partition basis allows us to `avoid redoing setup work for each data item`. Operations like opening a database connection or creating a random-number generator are examples of setup steps that we wish to avoid doing for each element. Spark has per-partition versions of map and foreach to help reduce the cost of these operations by letting you run code only once for each partition of an RDD.

As Examples 6-10 through 6-12 show, we use the mapPartitions() function, which gives us an iterator of the elements in each partition of the input RDD and expects us to return an iterator of our results.  
**Example 6-10. Shared connection pool in Python**  
```python
def processCallSigns(signs):
    “““Lookup call signs using a connection pool”””
    # Create a connection pool
    http = urllib3.PoolManager()
    # the URL associated with each call sign record
    urls = map(lambda x: “http://73s.com/qsos/%s.json” % x, signs)
    # create the requests (non-blocking)
    requests = map(lambda x: (x, http.request(‘GET’, x)), urls)
    # fetch the results
    result = map(lambda x: (x[0], json.loads(x[1].data)), requests)
    # remove any empty results and return
    return filter(lambda x: x[1] is not None, result)

def fetchCallSigns(input):
    “““Fetch call signs”””
    return input.mapPartitions(lambda callSigns : processCallSigns(callSigns))

contactsContactList = fetchCallSigns(validSigns)
```

```scala
val contactsContactLists = validSigns.distinct().mapPartitions{
    signs =>
    val mapper = createMapper()
    val client = new HttpClient()
    client.start()
    // create http request
    signs.map {sign =>
        createExchangeForSign(sign)
    // fetch responses
    }.map{ case (sign, exchange) =>
        (sign, readExchangeCallLog(mapper, exchange))
    }.filter(x => x._2 != null) // Remove empty CallLogs
}
```

When operating on a per-partition basis, Spark gives our function an Iterator of the elements in that partition. To return values, we return an Iterable.

* mapPartitions()  
f: (Iterator[T]) → Iterator[U]  
Input: Iterator of the elements in that partition  
Output: Iterator of our return elements  
* mapPartitionsWithIndex()  
f: (Int, Iterator[T]) → Iterator[U]  
Input: Integer of partition number, and Iterator of the elements in that partition  
Output: Iterator of our return elements
* foreachPartition()  
f: (Iterator[T]) → Unit
Input: Iterator of the elements  
Output: Nothing  

**Example 6-13. Average without mapPartitions() in Python**
```python
def combineCtrs(c1, c2):
    return (c1[0] + c2[0], c1[1] + c2[1])
def basicAvg(nums):
    “““Compute the average”””
    nums.map(lambda num: (num, 1)).reduce(combineCtrs)
```

**Example 6-14. Average with mapPartitions() in Python**  
```python
def combineCtrs(c1, c2):
    return (c1[0] + c2[0], c1[1] + c2[1])

def partitionCtr(nums):
    “““Compute sumCounter for partition”””
    sumCount = [0, 0]
    for num in nums:
        sumCount[0] += num
        sumCount[1] += 1
    return [sumCount]
def fastAvg(nums):
    “““Compute the avg”””
    sumCount = nums.mapPartitions(partitionCtr).reduce(combineCtrs)
    return sumCount[0] / float(sumCount[1])
```

### Piping to External Programs
Spark provides a general mechanism to pipe data to programs in other languages, like R scripts. Spark provides a pipe() method on RDDs. Spark’s pipe() lets us write parts of jobs using any language we want as long as it can read and write to Unix standard streams.

With pipe(), you can write a transformation of an RDD that reads each RDD element from standard input as a String, manipulates that String however you like, and then writes the result(s) as Strings to standard output. The interface and programming model is restrictive and limited, but sometimes it’s just what you need to do something like make use of a native code function within a map or filter operation. 

Most likely, you’d want to pipe an RDD’s content through some external program or script because you’ve already got complicated software built and tested that you’d like to reuse with Spark. A lot of data scientists have code in R,12 and we can interact with R programs using pipe().

```r
#!/usr/bin/env Rscript
library(“Imap”)
f <- file(“stdin”)
open(f)
while(length(line <- readLines(f,n=1)) > 0) {
    # process line
    contents <- Map(as.numeric, strsplit(line, “,”))
    mydist <- gdist(contents[[1]][1], contents[[1]][2],
                            contents[[1]][3], contents[[1]][4],
                            units=“m”, a=6378137.0, b=6356752.3142, verbose = FALSE)
    write(mydist, stdout())
}
```
Now we need to make finddistance.R available to each of our worker nodes and to actually transform our RDD with our shell script. Both tasks are easy to accomplish in Spark, as you can see in Examples 6-16 through 6-18.

**Example 6-16. Driver program using pipe() to call finddistance.R in Python**
```python
# Compute the distance of each call using an external R program
distScript = “./src/R/finddistance.R”
distScriptName = “finddistance.R”
sc.addFile(distScript)
def hasDistInfo(call):
    “““Verify that a call has the fields required to compute the distance”””
    requiredFields = [“mylat”, “mylong”, “contactlat”, “contactlong”]
    return all(map(lambda f: call[f], requiredFields))
def formatCall(call):
    “““Format a call so that it can be parsed by our R program”””
    return “{0},{1},{2},{3}”.format(
    call[“mylat”], call[“mylong”],
    call[“contactlat”], call[“contactlong”])
pipeInputs = contactsContactList.values().flatMap(
                            lambda calls: map(formatCall, filter(hasDistInfo, calls)))
distances = pipeInputs.pipe(SparkFiles.get(distScriptName))
print distances.collect()
```

**Example 6-17. Driver program using pipe() to call finddistance.R in Scala**
```scala
// Compute the distance of each call using an external R program
// adds our script to a list of files for each node to download with this job
val distScript = “./src/R/finddistance.R”
val distScriptName = “finddistance.R”
sc.addFile(distScript)
val distances = contactsContactLists.values.flatMap(x => x.map(y =>
                            s”$y.contactlay,$y.contactlong,$y.mylat,$y.mylong”)).pipe(Seq(
                            SparkFiles.get(distScriptName)))
println(distances.collect().toList)
```
With SparkContext.addFile(path), The files can then be found on the worker nodes in SparkFiles.getRootDirectory, or located with SparkFiles.get(filename). Of course, this is only one way to make sure that pipe() can find a script on each worker node. You could use another remote copying tool to place the script file in a knowable location on each node.

All the files added with SparkContext.addFile(path) are stored in the same directory, so it’s important to use unique names.

Once the script is available, the pipe() method on RDDs makes it easy to pipe the elements of an RDD through the script. Perhaps a smarter version of findDistance would accept SEPARATOR as a command-line argument. In that case, either of these would do the job, although the first is preferred:  
* rdd.pipe(Seq(SparkFiles.get(“finddistance.R”), “,”))  
* rdd.pipe(SparkFiles.get(“finddistance.R”) + ” ,”)

The [SparkR] project also provides a lightweight frontend to use Spark from within R.

### Numeric RDD Operations
Spark provides several descriptive statistics operations on RDDs containing numeric data. These are in addition to the more complex statistical and machine learning methods we will describe later in Chapter 11.

Spark’s numeric operations are implemented with a streaming algorithm that allows for building up our model one element at a time. The descriptive statistics are `all computed in a single pass over the data and returned as a StatsCounter object by calling stats()`. Table 6-2 lists the methods available on the StatsCounter object.

**Table 6-2. Summary statistics available from StatsCounter**  

Method              |Meaning
-------------------|---------------------------------------------------------------------------------------------------------------------------------
count()               |Number of elements in the RDD
mean()                |Average of the elements
sum()                  |Total
max()                 |Maximum value
min()                  |Minimum value
variance()           |Variance of the elements
sampleVariance()| Variance of the elements, computed for a sample
stdev()               |Standard deviation
sampleStdev()    |Sample standard deviation

If you want to compute only one of these statistics, you can also call the corresponding method directly on an RDD — for example, rdd.mean() or rdd.sum().

In Examples 6-19 through 6-21, we will use summary statistics to remove some outliers from our data. Since we will be going over the same RDD twice (once to compute the summary statistics and once to remove the outliers), we may wish to cache the RDD. Going back to our call log example, we can remove the contact points from our call log that are too far away. 

**Example 6-20. Removing outliers in Scala**
```scala
// Now we can go ahead and remove outliers since those may have misreported locations
// first we need to take our RDD of strings and turn it into doubles.
val distanceDouble = distance.map(string => string.toDouble)
val stats = distanceDoubles.stats()
val stddev = stats.stdev
val mean = stats.mean
val reasonableDistances = distanceDoubles.filter(x => math.abs(x-mean) < 3 * stddev)
println(reasonableDistance.collect().toList)
```

## Chapter 7. Running on a Cluster
The good news is that writing applications for parallel cluster execution uses the same API you’ve already learned in this book. The examples and applications you’ve written so far will run on a cluster “out of the box.” This is one of the benefits of Spark’s higher level API: users can rapidly prototype applications on smaller datasets locally, then run unmodified code on even very large clusters.

Spark can run on a wide variety of cluster managers (Hadoop YARN, Apache Mesos, and Spark’s own built-in Standalone cluster manager) in both on-premise and cloud deployments. We’ll discuss the trade-offs and configurations required for running in each case.

`On-premises` software is installed and run on computers on the premises (in the building) of the person or organisation using the software, rather than at a remote facility, such as at a server farm somewhere on the internet.

### Spark Runtime Architecture

![spark-distribute-structure-img-1]  
**Figure 7-1. The components of a distributed Spark application**  

In distributed mode, Spark uses a master/slave architecture with one central coordinator and many distributed workers. The central coordinator is called the driver. The driver communicates with a potentially large number of distributed workers called executors. The driver runs in its own Java process and each executor is a separate Java process. A driver and its executors are together termed a Spark application.

A Spark application is launched on a set of machines using an external service called a `cluster manager`. As noted, Spark is packaged with a built-in cluster manager called the `Standalone cluster manager`. Spark also works with `Hadoop YARN` and `Apache Mesos`, two popular open source cluster managers.

#### The Driver
The driver is the process where the main() method of your program runs. It is the process running the user code that creates a SparkContext, creates RDDs, and performs transformations and actions.

When the driver runs, it performs two duties:
1. Converting a user program into tasks  
The Spark driver is responsible for converting a user program into units of physical execution called tasks. At a high level, all Spark programs follow the same structure: they create RDDs from some input, derive new RDDs from those using transformations, and perform actions to collect or save data. A Spark program implicitly creates a logical `directed acyclic graph (DAG)` of operations. When the driver runs, it converts this logical graph into a physical `execution plan`. `Spark performs several optimizations, such as “pipelining” map transformations together to merge them, and converts the execution graph into a set of` `stages`. Each stage, in turn, consists of multiple tasks. The tasks are bundled up and prepared to be sent to the cluster. `Tasks` are the smallest unit of work in Spark; a typical user program can launch hundreds or thousands of individual tasks.  
2. Scheduling tasks on executors  
Given a physical execution plan, a Spark driver must coordinate the scheduling of individual tasks on executors. When executors are started they register themselves with the driver, so it has a complete view of the application’s executors at all times. Each executor represents a process capable of running tasks and storing RDD data. The Spark driver will look at the current set of executors and try to schedule each task in an appropriate location, based on data placement. When tasks execute, they may have a side effect of storing cached data. The driver also tracks the location of cached data and uses it to schedule future tasks that access that data. The driver exposes information about the running Spark application through a web interface, which by default is available at port 4040. For instance, in local mode, this UI is available at http://localhost:4040.  

#### Executors
Spark executors are worker processes responsible for running the individual tasks in a given Spark job. `Executors are launched once at the beginning of a Spark application and typically run for the entire lifetime of an application`, though Spark applications can continue if executors fail. Executors have two roles. First, they run the tasks that make up the application and return results to the driver. `Second, they provide in-memory storage for RDDs that are cached by user programs`, through a service called the `Block Manager` that lives within each executor. Because RDDs are cached directly inside of executors, tasks can run alongside the cached data.

For most of this book, you’ve run examples in Spark’s local mode. In this mode, the Spark driver runs along with an executor in the same Java process.

#### Cluster Manager
Spark depends on a cluster manager to launch executors and, in certain cases, to launch the driver. The cluster manager is a pluggable component in Spark. This allows Spark to run on top of different external managers, such as YARN and Mesos, as well as its built-in Standalone cluster manager.

Spark’s documentation consistently uses the terms driver and executor when describing the processes that execute each Spark application. The terms master and worker are used to describe the centralized and distributed portions of the cluster manager. It’s easy to confuse these terms, so pay close attention. For instance, Hadoop YARN runs a master daemon (called the Resource Manager) and several worker daemons called Node Managers. Spark can run both drivers and executors on the YARN worker nodes.

No matter which cluster manager you use, Spark provides a single script you can use to submit your program to it called spark-submit. Through various options, `spark-submit` can connect to different cluster managers and control how many resources your application gets. For some cluster managers, spark-submit can run the driver within the cluster (e.g., on a YARN worker node), while for others, it can run it only on your local machine.

To summarize the concepts in this section, let’s walk through the exact steps that occur when you run a Spark application on a cluster:
1. The user submits an application using spark-submit.
2. spark-submit launches the driver program and invokes the main() method specified by the user.
3. The driver program contacts the cluster manager to ask for resources to launch executors.
4. The cluster manager launches executors on behalf of the driver program.
5. The driver process runs through the user application. Based on the RDD actions and transformations in the program, the driver sends work to executors in the form of tasks.
6. Tasks are run on executor processes to compute and save results.
7. If the driver’s main() method exits or it calls `SparkContext.stop()`, it will terminate the executors and release resources from the cluster manager.

### Deploying Applications with spark-submit
As you’ve learned, Spark provides a single tool for submitting jobs across all cluster managers, called `spark-submit`.
```shell
bin/spark-submit my_script.py
```

When spark-submit is called with nothing but the name of a script or JAR, it simply runs the supplied Spark program locally. Let’s say we wanted to submit this program to a Spark Standalone cluster. We can provide extra flags with the address of a Standalone cluster and a specific size of each executor process we’d like to launch, as shown in Example 7-2.  
**Example 7-2. Submitting an application with extra arguments** 
```shell
bin/spark-submit —master spark://host:7077 —executor-memory 10g my_script.py
```
The —master flag specifies a cluster URL to connect to; in this case, the spark:// URL means a cluster using Spark’s Standalone mode (see Table 7-1).  
**Table 7-1. Possible values for the —master flag in spark-submit**  
Value                       |Explanation
----------------------|------------------------------------------------------------------------------------------------------------------------------
spark://host:port   |Connect to a Spark Standalone cluster at the specified port. By default Spark Standalone masters use port 7077.
mesos://host:port  |Connect to a Mesos cluster master at the specified port. By default Mesos masters listen on port 5050.
yarn                        |Connect to a YARN cluster. `When running on YARN you’ll need to set the HADOOP_CONF_DIR environment variable to point the location of your Hadoop configuration directory, which contains information about the cluster`.
local                        |Run in local mode with a single core.
local[N]                  |Run in local mode with N cores.
local[*]                   |Run in local mode and use as many cores as the machine has.

Apart from a cluster URL, spark-submit provides a variety of options that let you control specific details about a particular run of your application. These options fall roughly into two categories. The first is scheduling information, such as the amount of resources you’d like to request for your job (as shown in Example 7-2). The second is information about the runtime dependencies of your application, such as libraries or files you want to deploy to all worker machines.

**Example 7-3. General format for spark-submit**
```shell
bin/spark-submit [options] <app jar | python file> [app options]
```

[options] are a list of flags for spark-submit. You can enumerate all possible flags by running spark-submit —help.
**Table 7-2. Common flags for spark-submit**  
Flag                            |Explanation
-------------------------|---------------------------------------------------------------------------------------------------------------------------
—master                    |Indicates the cluster manager to connect to. The options for this flag are described in Table 7-1.
—deploymode             |Whether to launch the driver program locally (“client”) or on one of the worker machines inside the cluster (“cluster”). In client mode spark-submit will run your driver on the same machine where spark-submit is itself being invoked. In cluster mode, the driver will be shipped to execute on a worker node in the cluster. The default is client mode.
—executormemory     |The amount of memory to use for executors, in bytes. Suffixes can be used to specify larger quantities such as “512m” (512 megabytes) or “15g” (15 gigabytes).
—drivermemory         |The amount of memory to use for the driver process, in bytes. Suffixes can be used to specify larger quantities such as “512m” (512 megabytes) or “15g” (15 gigabytes).

spark-submit also allows setting arbitrary SparkConf configuration options using either the `—conf prop=value` flag or providing a properties file through `—properties-file` that contains key/value pairs.   

**Example 7-4. Using spark-submit with various options**  
```shell
# Submitting a Java application to Standalone cluster mode
$ ./bin/spark-submit \
    —master spark://hostname:7077 \
    —deploy-mode cluster \
    —class com.databricks.examples.SparkExample \
    —name “Example Program” \
    —jars dep1.jar,dep2.jar,dep3.jar \
    —total-executor-cores 300 \
    —executor-memory 10g \
    myApp.jar “options” “to your application” “go here”
# Submitting a Python application in YARN client mode
$ export HADOP_CONF_DIR=/opt/hadoop/conf
$ ./bin/spark-submit \
    —master yarn \
    —py-files somelib-1.2.egg,otherlib-4.4.zip,other-file.py \
    —deploy-mode client \
    —name “Example Program” \
    —queue exampleQueue \
    —num-executors 40 \
    —executor-memory 10g \
    my_script.py “options” “to your application” “go here”
```

### Packaging Your Code and Dependencies
More often, user programs depend on third-party libraries. If your program imports any libraries that are not in the org.apache.spark package or part of the language library, you need to ensure that all your dependencies are present at the runtime of your Spark application.  

For Python users, there are a few ways to install third-party libraries. Since PySpark uses the existing Python installation on worker machines, you can `install dependency libraries directly on the cluster machines` using standard Python package managers (such as pip or easy_install), or via a manual installation into the site-packages/ directory of your Python installation. Alternatively, you `can submit individual libraries using the —py-files argument to spark-submit` and they will be added to the Python interpreter’s path. Adding libraries manually is more convenient if you do not have access to install packages on the cluster, but do keep in mind potential conflicts with existing packages already installed on the machines.

When you are bundling an application, you should never include Spark itself in the list of submitted dependencies. `spark-submit automatically ensures that Spark is present in the path of your program`.

For Java and Scala users, it is also possible to submit individual JAR files using the —jars flag to spark-submit. This can work well if you have a very simple dependency on one or two libraries and they themselves don’t have any other dependencies. It is more common, however, for users to have Java or Scala projects that depend on several libraries. When you submit an application to Spark, it must ship with its entire transitive dependency graph to the cluster. This is often called an `uber JAR` or an `assembly JAR`, and most Java or Scala build tools can produce this type of artifact.

The most popular build tools for Java and Scala are `Maven` and `sbt (Scala build tool)`. `Either tool can be used with either language`, but Maven is more often used for Java projects and sbt for Scala projects.

**Example 7-5. pom.xml file for a Spark application built with Maven**  
```maven
<project>
    <modelVersion>4.0.0</modelVersion>
    <!— Information about your project —>
    <groupId>com.databricks</groupId>
    <artifactId>example-build</artifactId>
    <name>Simple Project</name>
    <packaging>jar</packaging>
    <version>1.0</version>
    <dependencies>
        <!— Spark dependency —>
        <dependency>
            <groupId>org.apache.spark</groupId>
            <artifactId>spark-core_2.10</artifactId>
            <version>1.2.0</version>
            <scope>provided</scope>
        </dependency>
        <!— Third-party library —>
        <dependency>
            <groupId>net.sf.jopt-simple</groupId>
            <artifactId>jopt-simple</artifactId>
            <version>4.3</version>
        </dependency>
        <!— Third-party library —>
        <dependency>
            <groupId>joda-time</groupId>
            <artifactId>joda-time</artifactId>
            <version>2.0</version>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <!— Maven shade plug-in that creates uber JARs —>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-shade-plugin</artifactId>
                <version>2.3</version>
                <executions>
                    <execution>
                        <phase>package</phase>
                        <goals>
                            <goal>shade</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

**Example 7-6. Packaging a Spark application built with Maven**
```shell
$ mvn package
# In the target directory, we’ll see an uber JAR and the original package JAR
$ ls target/
example-build-1.0.jar
original-example-build-1.0.jar
# Listing the uber JAR will reveal classes from dependency libraries
$ jar tf target/example-build-1.0.jar
… 
joptsimple/HelpFormatter.class
… 
org/joda/time/tz/UTCProvider.class
…
#An uber JAR can be passed directly to spark-submit
$ /path/to/spark/bin/spark-submit —master local … target/example-build-1.0.jar
```

sbt assumes a similar project layout to Maven. At the root of your project you create a build file called build.sbt and your source code is expected to live in src/main/scala   
**Example 7-7. build.sbt file for a Spark application built with sbt 0.13**
```sbt
import AssemblyKeys._
name := “Simple Project”
version := “1.0”
organization := “com.databricks”
scalaVersion := “2.10.3”
libraryDependencies ++= Seq(
    // Spark dependency
    “org.apache.spark” % “spark-core_2.10” % “1.2.0” % “provided”,
    // Third-party libraries
    “net.sf.jopt-simple” % “jopt-simple” % “4.3”,
    “joda-time” % “joda-time” % “2.0”
)
// This statement includes the assembly plug-in capabilities
assemblySettings
// Configure JAR used with the assembly plug-in
jarName in assembly := “my-project-assembly.jar”
// A special option to exclude Scala itself form our assembly JAR, since Spark
// already bundles Scala.
assemblyOption in assembly :=
    (assemblyOption in assembly).value.copy(includeScala = false)
```
The first line in this build file imports some functionality from an sbt build plug-in that supports creating project assembly JARs.  
To enable this plug-in we have to also include a small file in a project/ directory that lists the dependency on the plug-in. Simply create a file called project/assembly.sbt and add the following to it: addSbtPlugin(“com.eed3si9n” % “sbt-assembly” % “0.11.2”). The exact version of sbt-assembly you use might differ if you build with a newer version of sbt

**Example 7-8. Adding the assembly plug-in to an sbt project build**  
```shell
# Display contents of project/assembly.sbt
$ cat project/assembly.sbt
addSbtPlugin(“com.eed3si9n” % “sbt-assembly” % “0.11.2”)
```

**Example 7-9. Packaging a Spark application built with sbt**  
```shell
$ sbt assembly
# In the target directory, we’ll see an assembly JAR
$ ls target/scala-2.10/
my-project-assembly.jar
# Listing the assembly JAR will reveal classes from dependency libraries
$ jar tf target/scala-2.10/my-project-assembly.jar
… 
joptsimple/HelpFormatter.class
… 
org/joda/time/tz/UTCProvider.class
…
#An assembly JAR can be passed directly to spark-submit
$ /path/to/spark/bin/spark-submit —master local …
target/scala-2.10/my-project-assembly.jar
```

One occasionally disruptive issue is dealing with dependency conflicts in cases where a user application and Spark itself both depend on the same library. There are two solutions to this problem. 
* The first is to modify your application to depend on the same version of the third-party library that Spark does. 
* The second is to modify the packaging of your application using a procedure that is often called `“shading.”` The Maven build tool supports shading through advanced configuration of the plug-in shown in Example 7-5 (in fact, the shading capability is why the plug-in is named maven-shade-plugin). Shading allows you to make a second copy of the conflicting package under a different namespace and rewrites your application’s code to use the renamed version. This somewhat bruteforce technique is quite effective at resolving runtime dependency conflicts.

### Scheduling Within and Between Spark Applications
For scheduling in multitenant clusters, `Spark primarily relies on the cluster manager` to share resources between Spark applications. When a Spark application asks for executors from the cluster manager, it may receive more or fewer executors depending on availability and contention in the cluster. Many cluster managers offer the ability to `define queues with different priorities or capacity limits`, and Spark will then submit jobs to such queues.

One special case of Spark applications are those that are long lived, meaning that they are never intended to terminate. An example of a long-lived Spark application is the JDBC server bundled with Spark SQL. `When the JDBC server launches it acquires a set of executors from the cluster manager, then acts as a permanent gateway for SQL queries submitted by users`. Since this single application is scheduling work for multiple users, it needs a finer-grained mechanism to enforce sharing policies. Spark provides such a mechanism through configurable intra-application scheduling policies. `Spark’s internal Fair Scheduler` lets long-lived applications define queues for prioritizing scheduling of tasks. A detailed review of these is beyond the scope of this book; the official documentation on the [Fair Scheduler] provides a good reference.

### Cluster Managers
Spark can run over a variety of cluster managers to access the machines in a cluster. If you only want to run Spark by itself on a set of machines, the built-in Standalone mode is the easiest way to deploy it. However, if you have a cluster that you’d like to share with other distributed applications (e.g., both Spark jobs and Hadoop MapReduce jobs), Spark can also run over two popular cluster managers: Hadoop YARN and Apache Mesos. Finally, for deploying on Amazon EC2, Spark comes with built-in scripts that launch a Standalone cluster and various supporting services.

#### Standalone Cluster Manager
Spark’s Standalone manager offers a simple way to run applications on a cluster. It consists of a `master` and multiple `workers`, each `with a configured amount of memory and CPU cores`. When you submit an application, you can choose how much memory its executors will use, as well as the total number of cores across all executors.

You can start the Standalone cluster manager either by starting a master and workers by hand, or by using launch scripts in Spark’s sbin directory. The launch scripts are the simplest option to use, but require SSH access between your machines and are currently (as of Spark 1.1) available only on Mac OS X and Linux.

To use the cluster launch scripts, follow these steps:  
1. Copy a compiled version of Spark to the same location on all your machines — for example, /home/yourname/spark.
2. Set up password-less SSH access from your master machine to the others. This requires having the same user account on all the machines, creating a private SSH key for it on the master via ssh-keygen, and adding this key(public key?) to the .ssh/authorized_keys file of all the workers. If you have not set this up before, you can follow these commands:  
```shell
# On master: run ssh-keygen accepting default options
$ ssh-keygen -t dsa
# Enter file in which to save the key (/home/you/.ssh/id_dsa): [ENTER]
# Enter passphrase (empty for no passphrase): [EMPTY]
# Enter same passphrase again: [EMPTY]
# On workers:
# copy ~/.ssh/id_dsa.pub from your master to the worker, then use:
$ cat ~/.ssh/id_dsa.pub >> ~/.ssh/authorized_keys
$ chmod 644 ~/.ssh/authorized_keys
```
3. Edit the conf/slaves file on your master and fill in the workers’ hostnames.
4. To start the cluster, run sbin/start-all.sh on your master (it is important to run it there rather than on a worker). If everything started, you should get no prompts for a password, and the cluster manager’s web UI should appear at http://masternode:8080 and show all your workers.
5. To stop the cluster, run bin/stop-all.sh on your master node.

If you are not on a UNIX system or would like to launch the cluster manually, you can also start the master and workers by hand, using the spark-class script in Spark’s bin/ directory. On your master, type:
```shell
bin/spark-class org.apache.spark.deploy.master.Master
```
Then on workers:  
```shell
bin/spark-class org.apache.spark.deploy.worker.Worker spark://masternode:7077
```

To submit an application to the Standalone cluster manager, pass spark://masternode:7077 as the master argument to spark-submit. For example:  
```shell
spark-submit —master spark://masternode:7077 yourapp
```
This cluster URL is also shown in the Standalone cluster manager’s web UI, at http://masternode:8080.

You can also launch spark-shell or pyspark against the cluster in the same way, by passing the —master parameter:
```shell
spark-shell —master spark://masternode:7077
pyspark —master spark://masternode:7077
```

To check that your application or shell is running, look at the cluster manager’s web UI http://masternode:8080 and make sure that (1) your application is connected (i.e., it appears under Running Applications) and (2) it is listed as having more than 0 cores and memory.

Finally, the Standalone cluster manager supports two deploy modes for where the driver program of your application runs. In client mode (the default), the driver runs on the machine where you executed spark-submit, as part of the spark-submit command. This means that you can directly see the output of your driver program, or send input to it (e.g., for an interactive shell), but it requires the machine from which your application was submitted to have fast connectivity to the workers and to stay available for the duration of your application. In contrast, in cluster mode, the driver is launched within the Standalone cluster, as another process on one of the worker nodes, and then it connects back to request executors.

When sharing a Spark cluster among multiple applications, you will need to decide how to allocate resources between the executors. The Standalone cluster manager has a basic scheduling policy that allows capping the usage of each application so that multiple ones may run concurrently.

In the Standalone cluster manager, resource allocation is controlled by two settings:  
1. Executor memory  
You can configure this using the `—executor-memory` argument to spark-submit. `Each application will have at most one executor on each worker`, so this setting controls how much of that worker’s memory the application will claim. By default, this setting is 1 GB — you will likely want to increase it on most servers.  
2. The maximum number of total cores  
This is the total number of cores used across all executors for an application. `By default, this is unlimited; that is, the application will launch executors on every available node in the cluster`. For a multiuser workload, you should instead ask users to cap their usage. You can set this value through the `—total-executor-cores` argument to spark-submit, or by configuring `spark.cores.max` in your Spark configuration file.

Finally, the Standalone cluster manager works by `spreading out each application across the maximum number of executors by default`. For example, suppose that you have a 20- node cluster with 4-core machines, and you submit an application with —executor-memory 1G and —total-executor-cores 8. Then Spark will launch eight executors, each with 1 GB of RAM, on different machines. Spark does this by default to `give applications a chance to achieve data locality for distributed filesystems running on the same machines (e.g., HDFS), because these systems typically have data spread out across all nodes`. If you prefer, you can instead ask Spark to consolidate executors on as few nodes as possible, by setting the config property `spark.deploy.spreadOut` to false in `conf/spark-defaults.conf`. In this case, the preceding application would get only two executors, each with 1 GB RAM and four cores. This setting affects all applications on the Standalone cluster and must be configured before you launch the Standalone cluster manager.

When running in production settings, you will want your Standalone cluster to be available to accept applications even if individual nodes in your cluster go down. Out of the box, the Standalone mode will gracefully support the failure of worker nodes. If you also want the master of the cluster to be highly available, Spark supports using Apache ZooKeeper (a distributed coordination system) to keep multiple standby masters and switch to a new one when any of them fails.

#### Hadoop YARN
Running Spark on YARN in these environments is useful because it lets Spark access HDFS data quickly, on the same nodes where the data is stored.

Using YARN in Spark is straightforward: you set an environment variable that points to your Hadoop configuration directory, then submit jobs to a special master URL with spark-submit. The first step is to figure out your Hadoop configuration directory, and set it as the environment variable HADOOP_CONF_DIR.
```shell
export HADOOP_CONF_DIR=“…”
spark-submit —master yarn yourapp
```

Spark’s interactive shell and pyspark both work on YARN as well; simply set HADOOP_CONF_DIR and pass —master yarn to these applications. Note that these will run only in client mode since they need to obtain input from the user.

When running on YARN, Spark applications use a fixed number of executors, which you can set via the `—num-executors` flag to spark-submit, spark-shell, and so on. `By default, this is only two`, so you will likely need to increase it. You can also set the memory used by each executor via `—executor-memory` and the number of cores it claims from YARN via `—executor-cores`. `On a given set of hardware resources, Spark will usually run better with a smaller number of larger executors (with multiple cores and more memory)`, since it can optimize communication within each executor. Note, however, that some clusters have a limit on the maximum size of an executor (8 GB by default), and will not let you launch larger ones.

Some YARN clusters are configured to schedule applications into multiple “queues” for resource management purposes. Use the `—queue` option to select your queue name.

#### Apache Mesos
Apache Mesos is a general-purpose cluster manager that can run both analytics workloads and long-running services (e.g., web applications or key/value stores) on a cluster. To use Spark on Mesos, pass a mesos:// URI to spark-submit:  
```shell
spark-submit —master mesos://masternode:5050 yourapp
```

You can also configure Mesos clusters to `use ZooKeeper to elect a master when running in multimaster node`. In this case, use a mesos://zk:// URI pointing to a list of ZooKeeper nodes. For example, if you have three ZooKeeper nodes (node1, node2, and node3) on which ZooKeeper is running on port 2181, use the following URI:  
```html
mesos://zk://node1:2181/mesos,node2:2181/mesos,node3:2181/mesos
```

Unlike the other cluster managers, Mesos offers two modes to share resources between executors on the same cluster. 
* In `“fine-grained” mode,` which is the default, executors scale up and down the number of CPUs they claim from Mesos as they execute tasks, and so a machine running multiple executors can dynamically share CPU resources between them.  
* In `“coarse-grained” mode`, Spark allocates a fixed number of CPUs to each executor in advance and never releases them until the application ends, even if the executor is not currently running tasks. You can enable coarse-grained mode by passing `—conf spark.mesos.coarse=true` to spark-submit.

The fine-grained Mesos mode is attractive when multiple users share a cluster to run interactive workloads such as shells, because applications will scale down their number of cores when they’re not doing work and still allow other users’ programs to use the cluster. `The downside, however, is that scheduling tasks through fine-grained mode adds more latency (so very low-latency applications like Spark Streaming may suffer)`, and that applications may need to wait some amount of time for CPU cores to become free to “ramp up” again when the user types a new command. Note, however, that you can use `a mix of scheduling modes` in the same Mesos cluster (i.e., some of your Spark applications might have spark.mesos.coarse set to true and some might not).

As of Spark 1.2, `Spark on Mesos supports running applications only in the “client” deploy mode` — that is, with the driver running on the machine that submitted the application. If you would like to run your driver in the Mesos cluster as well, frameworks like [Aurora] and `Chronos` allow you to submit arbitrary scripts to run on Mesos and monitor them.

You can control resource usage on Mesos through two parameters to spark-submit: `—executor-memory`, to set the memory for each executor, and `—total-executor-cores`, to set the maximum number of CPU cores for the application to claim (across all executors). By default, Spark will launch each executor with as many cores as possible, consolidating the application to the smallest number of executors that give it the desired number of cores. If you do not set —total-executor-cores, it will try to use all available cores in the cluster.

#### Amazon EC2
Spark comes with a built-in script to launch clusters on Amazon EC2. This script launches a set of nodes and then installs the `Standalone cluster manager` on them, so once the cluster is up, you can use it according to the Standalone mode instructions in the previous section. In addition, the EC2 script sets up supporting services such as HDFS, Tachyon, and Ganglia to monitor your cluster. The Spark EC2 script is called spark-ec2.

1. To launch a cluster, you should first create an Amazon Web Services (AWS) account and obtain an access key ID and secret access key.
2. You can log in to a cluster by SSHing into its master node with the .pem file for your keypair.
3. Once you are in the cluster, you can use the Spark installation in /root/spark to run programs. This is a Standalone cluster installation, with the master URL spark://masternode:7077. If you launch an application with spark-submit, it will come correctly configured to submit your application to this cluster automatically. You can view the cluster’s web UI at http://masternode:8080.

In addition to outright terminating clusters, spark-ec2 lets you stop the Amazon instances running your cluster and then start them again later.

While the Spark EC2 script does not provide commands to resize clusters, you can resize them by adding or removing machines to the mycluster-slaves security group.

Spark EC2 clusters come configured with two installations of the Hadoop filesystem that you can use for scratch space.This can be handy to save datasets in a medium that’s faster to access than Amazon S3.
1. An “ephemeral” HDFS installation using the ephemeral drives on the nodes. Most Amazon instance types come with a substantial amount of local space attached on “ephemeral” drives that go away if you stop the instance.
2. A “persistent” HDFS installation on the root volumes of the nodes. This instance persists data even through cluster restarts, but is generally smaller and slower to access than the ephemeral one.  

Apart from these, you will most likely be accessing data from Amazon S3, which you can do using the s3n:// URI scheme in Spark.

#### Which Cluster Manager to Use?
* Start with a Standalone cluster if this is a new deployment. Standalone mode is the easiest to set up and will provide almost all the same features as the other cluster managers if you are running only Spark.  
* If you would like to run Spark alongside other applications, or to use richer resource scheduling capabilities (e.g., queues), both YARN and Mesos provide these features. Of these, YARN will likely be preinstalled in many Hadoop distributions.  
* One advantage of Mesos over both YARN and Standalone mode is its fine-grained sharing option, which lets interactive applications such as the Spark shell scale down their CPU allocation between commands. This makes it attractive in environments where multiple users are running interactive shells.  
* In all cases, it is best to run Spark on the same nodes as HDFS for fast access to storage. You can install Mesos or the Standalone cluster manager on the same nodes manually, or most Hadoop distributions already install YARN and HDFS together.

## Chapter 8. Tuning and Debugging Spark
### Configuring Spark with SparkConf
Tuning Spark often simply means changing the Spark application’s runtime configuration. The primary configuration mechanism in Spark is the **SparkConf** class. A SparkConf instance is required when you are creating a new SparkContext.

**Example 8-2. Creating an application using a SparkConf in Scala**
```scala
// Construct a conf
val conf = new SparkConf()
conf.set(“spark.app.name”, “My Spark App”)
conf.set(“spark.master”, “local[4]”)
conf.set(“spark.ui.port”, “36000”) // Override the default port
// Create a SparkContext with this configuration
val sc = new SparkContext(conf)
```
In addition to set(), the SparkConf class includes a small number of utility methods for setting common parameters. In the preceding three examples, you could also call setAppName() and setMaster() to set the spark.app.name and the spark.master configurations, respectively.

Spark allows setting configurations dynamically through the `spark-submit` tool. When an application is launched with spark-submit, it injects configuration values into the environment. These are detected and automatically filled in when a new SparkConf is constructed. Therefore, user applications can simply construct an “empty” SparkConf and pass it directly to the SparkContext constructor if you are using spark-submit.

The spark-submit tool provides built-in flags for the most common Spark configuration parameters and a generic —conf flag that accepts any Spark configuration value.
```shell
$ bin/spark-submit \
    —class com.example.MyApp \
    —master local[4] \
    —name “My Spark App” \
    —conf spark.ui.port=36000 \
    myApp.jar
```
spark-submit also supports loading configuration values from a file. By default, spark-submit will look for a file called `conf/spark-defaults.conf` in the Spark directory and attempt to read whitespace-delimited key/value pairs from this file. You can also customize the exact location of the file using the `—properties-file` flag to spark-submit,
```shell
$ bin/spark-submit \
    —class com.example.MyApp \
    —properties-file my-config.conf \
    myApp.jar
## Contents of my-config.conf ##
spark.master local[4]
spark.app.name “My Spark App”
spark.ui.port 36000
```

`The SparkConf associated with a given application is immutable` once it is passed to the SparkContext constructor. `That means that all configuration decisions must be made before a SparkContext is instantiated`.

In some cases, the same configuration property might be set in multiple places. For instance, a user might call setAppName() directly on a SparkConf object and also pass the —name flag to spark-submit. In these cases Spark has a specific precedence order. The highest priority is given to configurations declared explicitly in the user’s code using the set() function on a SparkConf object. Next are flags passed to spark-submit, then values in the properties file, and finally default values.

**Table 8-1. Common Spark configuration values**  
spark.storage.blockManagerTimeoutIntervalMs
Option(s)                                                               |Default    |Description
-------------------------------------------------------|------------|--------------------------------------------------------------------------------
spark.executor.memory (—executor-memory)       |512m        |Amount of memory to use in the same format as JVM 512m, 2g). 

spark.executor.cores(—executor-cores)               |1               |-
spark.cores.max(—total-executor-cores)              |(none)       |-
spark.speculation                                                  |false         |Setting to true will enable of tasks. This means tasks will have a second copy node. Enabling this can help straggler tasks in large clusters.
spark.storage.blockManagerTimeoutIntervalMs   |45000       |An internal timeout used of executors. For jobs that collection pauses, tuning value of 100000. In future versions of Spark with a general timeout setting, documentation.
spark.executor.extraJavaOptions                        |-                |-
spark.executor.extraClassPath                             |-                |allows you to manually augment classpath, the recommended dependencies is through submit (not using this option).
spark.executor.extraLibraryPath                         |(empty)      |-
spark.serializer                                                    |org.apache.spark.serializer.JavaSerializer |Can be any subclass org.apache.spark.Serializer
spark.[X].port                                                      |(random)     |Allows setting integer port running Spark applications. clusters where network access possible values of broadcast, replClassServer and executor.
spark.eventLog.enabled                                        |false           |Set to true to enable event completed Spark jobs to Spark’s history server. 
spark.eventLog.dir                                               |file:///tmp/spark-events |The storage location used enabled. This needs to be filesystem such as HDFS. 

Almost all Spark configurations occur through the SparkConf construct, but one important option doesn’t. To set the local storage directories for Spark to use for shuffle data (necessary for standalone and Mesos modes), you export the `SPARK_LOCAL_DIRS` environment variable inside of conf/spark-env.sh to a comma-separated list of storage locations. SPARK_LOCAL_DIRS is described in detail in “Hardware Provisioning”. This is specified differently from other Spark configurations because its value may be different on different physical hosts.

### Components of Execution: Jobs, Tasks, and Stages
To demonstrate Spark’s phases of execution, we’ll walk through an example application and see how user code compiles down to a lower-level execution plan. The application we’ll consider is a simple bit of log analysis in the Spark shell. For input data, we’ll use a text file that consists of log messages of varying degrees of severity, along with some blank lines interspersed (Example 8-6).   

**Example 8-6. input.txt, the source file for our example**  
```html
## input.txt ##
INFO This is a message with content
INFO This is some other content
(empty line)
INFO Here are more messages
WARN This is a warning
(empty line)
ERROR Something bad happened
WARN More details on the bad thing
INFO back to normal messages
```

We want to open this file in the Spark shell and compute how many log messages appear at each level of severity. First let’s create a few RDDs that will help us answer this question, as shown in Example 8-7.  
**Example 8-7. Processing text data in the Scala Spark shell**  
```shell
// Read input file
scala> val input = sc.textFile(“input.txt”)
// Split into words and remove empty lines
scala> val tokenized = input.
        | map(line => line.split(” “)).
        | filter(words => words.size > 0)
// Extract the first word from each line (the log level) and do a count
scala> val counts = tokenized.
        | map(words => (words(0), 1)).
        | reduceByKey{ (a, b) => a + b }
```
After executing these lines in the shell, the program has not performed any actions. Instead, it has implicitly defined a directed acyclic graph (DAG) of RDD objects that will be used later once an action occurs. Each RDD maintains a pointer to one or more parents along with metadata about what type of relationship they have. For instance, when you call val b = a.map() on an RDD, the `RDD b keeps a reference to its parent a`. These pointers allow an RDD to be traced to all of its ancestors.

To display the lineage of an RDD, Spark provides a `toDebugString()` method. In Example 8-8, we’ll look at some of the RDDs we created in the preceding example.  
**Example 8-8. Visualizing RDDs with toDebugString() in Scala**  
```shell
scala> input.toDebugString
res85: String =
(2) input.text MappedRDD[292] at textFile at <console>:13
|   input.text HadoopRDD[291] at textFile at <console>:13
scala> counts.toDebugString
res84: String =
(2) ShuffledRDD[296] at reduceByKey at <console>:17
+-(2) MappedRDD[295] at map at <console>:17
        | FilteredRDD[294] at filter at <console>:15
        | MappedRDD[293] at map at <console>:15
        | input.text MappedRDD[292] at textFile at <console>:13
        | input.text HadoopRDD[291] at textFile at <console>:13
```

The first visualization shows the input RDD. We created this RDD by calling sc.textFile(). The lineage gives us some clues as to what sc.textFile() does since it reveals which RDDs were created in the textFile() function. We can see that it creates a HadoopRDD and then performs a map on it to create the returned RDD. The lineage of counts is more complicated. That RDD has several ancestors, since there are other operations that were performed on top of the input RDD, such as additional maps, filtering, and reduction. The lineage of counts shown here is also displayed graphically on the left side of Figure 8-1.

![spark-execution-plan-img-1]  

Before we perform an action, these RDDs simply store metadata that will help us compute them later. To trigger computation, let’s call an action on the counts RDD and collect() it to the driver.
```scala
scala> counts.collect()
res86: Array[(String, Int)] = Array((ERROR,1), (INFO,4), (WARN,2))
```

Spark’s scheduler creates a physical execution plan to compute the RDDs needed for performing the action. Here when we call collect() on the RDD, every partition of the RDD must be materialized and then transferred to the driver program. `Spark’s scheduler starts at the final RDD` being computed (in this case, counts) and `works backward to find what it must compute`. It visits that RDD’s parents, its parents’ parents, and so on, recursively to develop a physical plan necessary to compute all ancestor RDDs. `In the simplest case, the scheduler outputs a computation stage for each RDD` in this graph where the stage has tasks for each partition in that RDD. Those stages are then executed in reverse order to compute the final required RDD.  

`In more complex cases`, the physical set of stages will not be an exact 1:1 correspondence to the RDD graph. This can occur when `the scheduler performs pipelining`, or collapsing of multiple RDDs into a single stage. `Pipelining occurs when RDDs can be computed from their parents without data movement`. The lineage output shown in Example 8-8 `uses indentation levels to show where RDDs are going to be pipelined together` into physical stages. RDDs that exist at the same level of indentation as their parents will be pipelined during physical execution.

`In addition to pipelining, Spark’s internal scheduler may truncate the lineage of the RDD graph if an existing RDD has already been persisted in cluster memory or on disk`. Spark can “short-circuit” in this case and just begin computing based on the persisted RDD. `A second case in which this truncation can happen is when an RDD is already materialized as a side effect of an earlier shuffle`, even if it was not explicitly persist()ed. This is an under-the-hood optimization that takes advantage of the fact that `Spark shuffle outputs are written to disk`, and exploits the fact that many times portions of the RDD graph are recomputed.

To see the effects of caching on physical execution, let’s cache the counts RDD and see how that truncates the execution graph for future actions (Example 8-10). If you revisit the UI, you should see that caching reduces the number of stages required when executing future computations. Calling collect() a few more times will reveal only one stage executing to perform the action.  

**Example 8-10. Computing an already cached RDD**  
```scala
// Cache the RDD
scala> counts.cache()
// The first subsequent execution will again require 2 stages
scala> counts.collect()
res87: Array[(String, Int)] = Array((ERROR,1), (INFO,4), (WARN,2), (##,1),
((empty,2))
// This execution will only require a single stage
scala> counts.collect()
res88: Array[(String, Int)] = Array((ERROR,1), (INFO,4), (WARN,2), (##,1),
((empty,2))
```
The set of stages produced for a particular action is termed a job. In each case when we invoke actions such as count(), we are creating a job composed of one or more stages.

Once the stage graph is defined, tasks are created and dispatched to an internal scheduler, which varies depending on the deployment mode being used. Stages in the physical plan can depend on each other, based on the RDD lineage, so they will be executed in a specific order. For instance, a stage that outputs shuffle data must occur before one that relies on that data being present. 

A physical stage will launch tasks that each do the same thing but on specific partitions of data. Each task internally performs the same steps:  
1. Fetching its input, either from `data storage (if the RDD is an input RDD), an existing RDD (if the stage is based on already cached data), or shuffle outputs`.
2. Performing the operation necessary to compute RDD(s) that it represents.   
3. Writing output to a shuffle, to external storage, or back to the driver (if it is the final RDD of an action such as count()).

Most logging and instrumentation in Spark is expressed in terms of stages, tasks, and shuffles. Understanding how user code compiles down into the bits of physical execution is an advanced concept, but one that will help you immensely in tuning and debugging applications.

To summarize, the following phases occur during Spark execution:  
* User code defines a DAG (directed acyclic graph) of RDDs  
Operations on RDDs create new RDDs that refer back to their parents, thereby creating a graph.
* Actions force translation of the DAG to an execution plan  
When you call an action on an RDD it must be computed. This requires computing its parent RDDs as well. Spark’s scheduler submits a job to compute all needed RDDs. That job will have one or more stages, which are parallel waves of computation composed of tasks. Each stage will correspond to one or more RDDs in the DAG. A single stage can correspond to multiple RDDs due to pipelining.
* Tasks are scheduled and executed on a cluster  
Stages are processed in order, with individual tasks launching to compute segments of the RDD. Once the final stage is finished in a job, the action is complete.

### Finding Information
Spark records detailed progress information and performance metrics as applications execute. These are presented to the user in two places: `the Spark web UI` and `the logfiles produced by the driver and executor processes`.

#### Spark Web UI
The first stop for learning about the behavior and performance of a Spark application is Spark’s built-in web UI. This is available on `the machine where the driver is running at port 4040 by default`. One caveat is that in the case of the YARN cluster mode, where the application driver runs inside the cluster, you should access the UI through the YARN ResourceManager, which proxies requests directly to the driver.  

* Jobs: Progress and metrics of stages, tasks, and more  
A good first step is to look through the stages that make up a job and see whether some are particularly slow or vary significantly in response time across multiple runs of the same job.
In data-parallel systems such as Spark, a common source of performance issues is skew, which occurs when a small number of tasks take a very large amount of time compared to others. The stage page can help you identify skew by looking at the distribution of different metrics over all tasks.  
In addition to looking at task skew, it can be helpful to identify how much time tasks are spending in each of the phases of the task lifecycle: reading, computing, and writing.  
* Storage: Information for RDDs that are persisted  
In some cases, if many RDDs are cached, older ones will fall out of memory to make space for newer ones. This page will tell you exactly what fraction of each RDD is cached and the quantity of data cached in various storage media (disk, memory, etc.) It can be helpful to scan this page and understand whether important datasets are fitting into memory or not.
* Executors: A list of executors present in the application  
One valuable use of this page is to confirm that your application has the amount of resources you were expecting. A good first step when debugging issues is to scan this page, since a misconfiguration resulting in fewer executors than expected can, for obvious reasons, affect performance. It can also be useful to look for executors with anomalous behaviors, such as a very large ratio of failed to successful tasks. An executor with a high failure rate could indicate a misconfiguration or failure on the physical host in question. Simply removing that host from the cluster can improve performance.  
Another feature in the executors page is the ability to collect a stack trace from executors using the `Thread Dump` button
* Environment: Debugging Spark’s configuration  
This page enumerates the set of active properties in the environment of your Spark application. This page will also enumerate JARs and files you’ve added to your application, which can be useful when you’re tracking down issues such as missing dependencies.

#### Driver and Executor Logs
The exact location of Spark’s logfiles depends on the deployment mode:   
* In Spark’s Standalone mode, application logs are directly displayed in the standalone master’s web UI. They are stored by default in the work/ directory of the Spark distribution on each worker.  
* In Mesos, logs are stored in the work/ directory of a Mesos slave, and accessible from the Mesos master UI.  
* In YARN mode, the easiest way to collect logs is to use YARN’s log collection tool (running yarn logs -applicationId <app ID>) to produce a report containing logs from your application. This will work only after an application has fully finished, since YARN must first aggregate these logs together. For viewing logs of a running application in YARN, you can click through the ResourceManager UI to the Nodes page, then browse to a particular node, and from there, a particular container. YARN will give you the logs associated with output produced by Spark in that container. This process is likely to become less roundabout in a future version of Spark with direct links to the relevant logs.

Spark’s logging subsystem is based on log4j.  Once you’ve tweaked the logging to match your desired level or format, you can add the log4j.properties file using the —files flag of spark-submit. If you have trouble setting the log level in this way, make sure that you are not including any JARs that themselves contain log4j.properties files with your application. `Log4j works by scanning the classpath for the first properties file it finds, and will ignore your customization if it finds properties somewhere else first`.

### Key Performance Considerations
#### Level of Parallelism
an RDD is divided into a set of partitions with each partition containing some subset of the total data. When Spark schedules and runs tasks, it creates a single task for data stored in one partition, and that task will require, by default, a single core in the cluster to execute. 

Out of the box, Spark will infer what it thinks is a good degree of parallelism for RDDs, and this is sufficient for many use cases. Input RDDs typically choose parallelism based on the underlying storage systems. For example, HDFS input RDDs have one partition for each block of the underlying HDFS file. RDDs that are derived from shuffling other RDDs will have parallelism set based on the size of their parent RDDs.  

Spark offers two ways to tune the degree of parallelism for operations. The first is that, during operations that shuffle data, you can always give a degree of parallelism for the produced RDD as a parameter. The second is that any existing RDD can be redistributed to have more or fewer partitions. The `repartition()` operator will randomly shuffle an RDD into the desired number of partitions. `If you know you are shrinking the RDD, you can use the coalesce() operator; this is more efficient than repartition() since it avoids a shuffle operation`. If you think you have too much or too little parallelism, it can help to redistribute your data with these operators.

As an example, let’s say we are reading a large amount of data from S3, but then immediately performing a filter() operation that is likely to exclude all but a tiny fraction of the dataset. By default the RDD returned by filter() will have the same size as its parent and might have many empty or small partitions. In this case you can improve the application’s performance by coalescing down to a smaller RDD, as shown in Example 8-11.   
**Example 8-11. Coalescing a large RDD in the PySpark shell**  
```python
# Wildcard input that may match thousands of files
>>> input = sc.textFile(“s3n://log-files/2014/*.log”)
>>> input.getNumPartitions()
35154
# A filter that excludes almost all data
>>> lines = input.filter(lambda line: line.startswith(“2014-10-17”))
>>> lines.getNumPartitions()
35154
# We coalesce the lines RDD before caching
>>> lines = lines.coalesce(5).cache()
>>> lines.getNumPartitions()
4#
Subsequent analysis can operate on the coalesced RDD…
>>> lines.count()
```

#### Serialization Format
When Spark is `transferring data over the network or spilling data to disk`, it needs to serialize objects into a binary format. This comes into play during shuffle operations, where potentially large amounts of data are transferred. By default Spark will use Java’s built-in serializer. Spark also supports the use of Kryo, a third-party serialization library that improves on Java’s serialization by offering both faster serialization times and a more compact binary representation,` but cannot serialize all types of objects “out of the box”`. Almost all applications will benefit from shifting to Kryo for serialization.

To use Kryo serialization, you can set the `spark.serializer` setting to `org.apache.spark.serializer.KryoSerializer`. `For best performance, you’ll also want to register classes with Kryo that you plan to serialize`, as shown in Example 8-12. `Registering a class allows Kryo to avoid writing full class names with individual objects`, a space savings that can add up over thousands or millions of serialized records. If you want to force this type of registration, you can set `spark.kryo.registrationRequired` to true, and Kryo will throw errors if it encounters an unregistered class.

**Example 8-12. Using the Kryo serializer and registering classes**
```scala
val conf = new SparkConf()
conf.set(“spark.serializer”, “org.apache.spark.serializer.KryoSerializer”)
// Be strict about class registration
conf.set(“spark.kryo.registrationRequired”, “true”)
conf.registerKryoClasses(Array(classOf[MyClass], classOf[MyOtherClass]))
```

Whether using Kryo or Java’s serializer, you may encounter a NotSerializableException if your code refers to a class that does not extend Java’s Serializable interface. It can be difficult to track down which class is causing the problem in this case, since many different classes can be referenced from user code. Many JVMs support a special option to help debug this situation: `“- Dsun.io.serialization.extendedDebugInfo=true”`. You can enable this option this using the `—driver-java-options` and `—executor-java-options` flags to spark-submit. Once you’ve found the class in question, the easiest solution is to simply modify it to implement Serializable. `If you cannot modify the class in question you’ll need to use more advanced workarounds, such as creating a subclass of the type in question that implements Java’s Externalizable interface or customizing the serialization behavior using Kryo`.

#### Memory Management
Spark uses memory in different ways, so understanding and tuning Spark’s use of memory can help optimize your application. Inside of each executor, memory is used for a few purposes:  
* RDD storage  
When you call persist() or cache() on an RDD, its partitions will be stored in memory buffers. Spark will limit the amount of memory used when caching to a certain fraction of the JVM’s overall heap, set by `spark.storage.memoryFraction`. If this limit is exceeded, older partitions will be dropped from memory.  
* Shuffle and aggregation buffers  
When performing shuffle operations, Spark will create intermediate buffers for storing shuffle output data. These buffers are used to store intermediate results of aggregations in addition to buffering data that is going to be directly output as part of the shuffle. Spark will attempt to limit the total amount of memory used in shufflerelated buffers to `spark.shuffle.memoryFraction`.  
* User code  
Spark executes arbitrary user code, so user functions can themselves require substantial memory. For instance, if a user application allocates large arrays or other objects, these will contend for overall memory usage. User code has access to everything left in the JVM heap after the space for RDD storage and shuffle storage are allocated.

By default Spark will leave 60% of space for RDD storage, 20% for shuffle memory, and the remaining 20% for user programs. If your user code is allocating very large objects, it might make sense to decrease the storage and shuffle regions to avoid running out of memory.

In addition to tweaking memory regions, you can improve certain elements of Spark’s default caching behavior for some workloads. Spark’s default cache() operation persists memory using the MEMORY_ONLY storage level. This means that if there is not enough space to cache new RDD partitions, `old ones will simply be deleted and, if they are needed again, they will be recomputed`. It is sometimes better to call persist() with the MEMORY_AND_DISK storage level, which instead drops RDD partitions to disk and simply reads them back to memory from a local store if they are needed again. This can be much cheaper than recomputing blocks and can lead to more predictable performance. This is particularly useful if your RDD partitions are very expensive to recompute (for instance, if you are reading data from a database)

A second improvement on the default caching policy is to cache serialized objects instead of raw Java objects. Caching serialized objects will slightly slow down the cache operation due to the cost of serializing objects, but it can `substantially reduce time spent on garbage collection in the JVM, since many individual records can be stored as a single serialized buffer`. `This is because the cost of garbage collection scales with the number of objects on the heap, not the number of bytes of data`, and this caching method will take many objects and serialize them into a single giant buffer. Consider this option if you are caching large amounts of data (e.g., gigabytes) as objects and/or seeing long garbage collection pauses. Such pauses would be visible in the application UI under the GC Time column for each task.

#### Hardware Provisioning
The main parameters that affect cluster sizing are the amount of memory given to each executor, the number of cores for each executor, the total number of executors, and the number of local disks to use for scratch data.

In all deployment modes, executor memory is set with spark.executor.memory or the — executor-memory flag to spark-submit. The options for number and cores of executors differ depending on deployment mode. In YARN you can set spark.executor.cores or the —executor-cores flag and the —num-executors flag to determine the total count. In Mesos and Standalone mode, Spark will greedily acquire as many cores and executors as are offered by the scheduler. However, both Mesos and Standalone mode support setting `spark.cores.max` to limit the total number of cores across all executors for an application. Local disks are used for scratch storage during shuffle operations.

Broadly speaking, Spark applications will benefit from having more memory and cores. Spark’s architecture allows for linear scaling.  
If you do plan to use caching, the more of your cached data can fit in memory, the better the performance will be.  
One approach is to start by caching a subset of your data on a smaller cluster and extrapolate the total memory you will need to fit larger amounts of the data in memory.

In addition to memory and cores, Spark uses local disk volumes to store intermediate data required during shuffle operations along with RDD partitions that are spilled to disk. Using a larger number of local disks can help accelerate the performance of Spark applications.  In all cases you specify the local directories using a single comma-separated list. It is common to have one local directory for each disk volume available to Spark. Writes will be evenly striped across all local directories provided. Larger numbers of disks will provide higher overall throughput.

One caveat to the “more is better” guideline is when sizing memory for executors. `Using very large heap sizes can cause garbage collection pauses to hurt the throughput of a Spark job`. `It can sometimes be beneficial to request smaller executors (say, 64 GB or less) to mitigate this issue`. Mesos and YARN can, out of the box, support packing multiple, smaller executors onto the same physical host, so requesting smaller executors doesn’t mean your application will have fewer overall resources. In Spark’s Standalone mode, you need to launch multiple workers (determined using SPARK_WORKER_INSTANCES) for a single application to run more than one executor on a host. This limitation will likely be removed in a later version of Spark.  

To dive deeper into tuning Spark, visit the [tuning guide] in the official documentation.

## Chapter 9. Spark SQL
This chapter introduces Spark SQL, Spark’s interface for working with structured and semistructured data. Structured data is any data that has a schema — that is, a known set of fields for each record. When you have this type of data, Spark SQL makes it both easier and more efficient to load and query. In particular, Spark SQL provides three main capabilities (illustrated in Figure 9-1):
1. It can load data from a variety of structured sources (e.g., JSON, Hive, and Parquet).  
2. It lets you query the data using SQL, both inside a Spark program and from external tools that connect to Spark SQL through standard database connectors (JDBC/ODBC), such as business intelligence tools like Tableau.  
3. When used within a Spark program, Spark SQL provides rich integration between SQL and regular Python/Java/Scala code, including the ability to join RDDs and SQL tables, expose custom functions in SQL, and more. Many jobs are easier to write using this combination.

To implement these capabilities, Spark SQL provides a special type of RDD called SchemaRDD. A SchemaRDD is an RDD of Row objects, each representing a record. A SchemaRDD also knows the schema (i.e., data fields) of its rows. While SchemaRDDs look like regular RDDs, internally they store data in a more efficient manner, taking advantage of their schema. In addition, they provide new operations not available on RDDs, such as the ability to run SQL queries. SchemaRDDs can be created from external data sources, from the results of queries, or from regular RDDs.

![spark-sql-usage-img-1]  

### Linking with Spark SQL
Spark SQL can be built with or without Apache Hive, the Hadoop SQL engine. Spark SQL with Hive support allows us to access Hive tables, UDFs (user-defined functions), SerDes (serialization and deserialization formats), and the Hive query language (HiveQL). `It is important to note that including the Hive libraries does not require an existing Hive installation`. In general, it is best to build Spark SQL with Hive support to access these features.

If you have dependency conflicts with Hive that you cannot solve through exclusions or shading, you can also build and link to Spark SQL without Hive. In that case you link to a separate Maven artifact.  

In Java and Scala, the Maven coordinates to link to Spark SQL with Hive are shown in Example 9-1.  
**Example 9-1. Maven coordinates for Spark SQL with Hive support**  
```maven
groupId = org.apache.spark
artifactId = spark-hive_2.10
version = 1.2.0
```
If you can’t include the Hive dependencies, use the artifact ID spark-sql_2.10 instead of spark-hive_2.10.

When programming against Spark SQL we have two entry points depending on whether we need Hive support. The recommended entry point is the **HiveContext** to provide access to HiveQL and other Hive-dependent functionality. The more basic **SQLContext** provides a subset of the Spark SQL support that does not depend on Hive. The separation exists for users who might have conflicts with including all of the Hive dependencies. `Using a HiveContext does not require an existing Hive setup`.

Finally, to connect Spark SQL to an existing Hive installation, you must copy your hive-site.xml file to Spark’s configuration directory ($SPARK_HOME/conf). If you don’t have an existing Hive installation, Spark SQL will still run.  

Note that if you don’t have an existing Hive installation, Spark SQL will create its own Hive metastore (metadata DB) in your program’s work directory, called metastore_db. In addition, if you attempt to create tables using HiveQL’s CREATE TABLE statement (not CREATE EXTERNAL TABLE), they will be placed in the /user/hive/warehouse directory on your default filesystem (either your local filesystem, or HDFS if you have a hdfs-site.xml on your classpath).

### Using Spark SQL in Applications
To use Spark SQL this way, we construct a HiveContext (or SQLContext for those wanting a stripped-down version) based on our SparkContext. This context provides additional functions for querying and interacting with Spark SQL data. Using the HiveContext, we can build SchemaRDDs, which represent our structure data, and operate on them with SQL or with normal RDD operations like map().

Scala users should note that we don’t import HiveContext._, like we do with the SparkContext, to get access to implicits. These implicits are used to convert RDDs with the required type information into Spark SQL’s specialized RDDs for querying. Instead, once we have constructed an instance of the HiveContext we can then import the implicits by adding the code shown in Example 9-3.

**Example 9-3. Scala SQL implicits**  
```scala
// Import Spark SQL
import org.apache.spark.sql.hive.HiveContext
// Or if you can’t have the hive dependencies
import org.apache.spark.sql.SQLContext

// Create a Spark SQL HiveContext
val hiveCtx = …
// Import the implicit conversions
import hiveCtx._

val sc = new SparkContext(…)
val hiveCtx = new HiveContext(sc)
```

**Example 9-4. Java SQL imports**
```java
// Import Spark SQL
import org.apache.spark.sql.hive.HiveContext;
// Or if you can’t have the hive dependencies
import org.apache.spark.sql.SQLContext;
// Import the JavaSchemaRDD
import org.apache.spark.sql.SchemaRDD;
import org.apache.spark.sql.Row;
```

**Example 9-5. Python SQL imports**
```python
# Import Spark SQL
from pyspark.sql import HiveContext, Row
# Or if you can’t include the hive requirements
from pyspark.sql import SQLContext, Row

hiveCtx = HiveContext(sc)
```

To make a query against a table, we call the sql() method on the HiveContext or SQLContext. The first thing we need to do is tell Spark SQL about some data to query. In this case we will load some Twitter data from JSON, and give it a name by registering it as a “temporary table” so we can query it with SQL.  
**Example 9-9. Loading and quering tweets in Scala**
```scala
val input = hiveCtx.jsonFile(inputFile)
// Register the input schema RDD
input.registerTempTable(“tweets”)
// Select tweets based on the retweetCount
val topTweets = hiveCtx.sql(“SELECT text, retweetCount FROM
tweets ORDER BY retweetCount LIMIT 10”)
```
**Example 9-11. Loading and quering tweets in Python**
```python
input = hiveCtx.jsonFile(inputFile)
# Register the input schema RDD
input.registerTempTable(“tweets”)
# Select tweets based on the retweetCount
topTweets = hiveCtx.sql(“““SELECT text, retweetCount FROM
tweets ORDER BY retweetCount LIMIT 10”””)
```

If you have an existing Hive installation, and have copied your hive-site.xml file to $SPARK_HOME/conf, you can also just run hiveCtx.sql to query your existing Hive tables.

#### SchemaRDDs
Both loading data and executing queries return **SchemaRDDs**. SchemaRDDs are similar to tables in a traditional database. Under the hood, a SchemaRDD is an RDD composed of Row objects with additional schema information of the types in each column. Row objects are just wrappers around arrays of basic types (e.g., integers and strings).

One important note: in future versions of Spark, the name SchemaRDD may be changed to DataFrame.

SchemaRDDs are also regular RDDs, so you can operate on them using existing RDD transformations like map() and filter(). However, they provide several additional capabilities. Most importantly, you can register any SchemaRDD as a temporary table to query it via HiveContext.sql or SQLContext.sql. You do so using the SchemaRDD’s registerTempTable() method, as in Examples 9-9 through 9-11.

Temp tables are local to the HiveContext or SQLContext being used, and go away when your application exits.
SchemaRDDs can store several basic types, as well as structures and arrays of these types. They use the HiveQL syntax for type definitions. The last type, structures, is simply represented as other Rows in Spark SQL. All of these types can also be nested within each other

**Table 9-1. Types stored by SchemaRDDs**

Spark SQL/HiveQL type               |Scala type             |Java type                  |Python
--------------------------------------|---------------------|-------------------------|--------------------------------------------------------------
BINARY                                        |Array[Byte]           |byte[]                        |bytearray
ARRAY<DATA_TYPE>                   |Seq                        |List                            |list, tuple, or array
MAP<KEY_TYPE, VAL_TYPE>        |Map                       |Map                            |dict
STRUCT<COL1: COL1_TYPE, …>    |Row                        |Row                            |Row

Row objects represent records inside SchemaRDDs, and are simply fixed-length arrays of fields. In Scala/Java, Row objects have a number of getter functions to obtain the value of each field given its index. The standard getter, get (or apply in Scala), takes a column number and returns an Object type (or Any in Scala) that we are responsible for casting to the correct type. For Boolean, Byte, Double, Float, Int, Long, Short, and String, there is a getType() method, which returns that type. For example, getString(0) would return field 0 as a string, as you can see in Examples 9-12 and 9-13.

**Example 9-12. Accessing the text column (also first column) in the topTweets SchemaRDD in Scala**
```scala
val topTweetText = topTweets.map(row => row.getString(0))
```

In Python, Row objects are a bit different since we don’t have explicit typing. We just access the ith element using row[i]. In addition, Python Rows support named access to their fields, of the form row.column_name, as you can see in Example 9-14. If you are uncertain of what the column names are, we illustrate printing the schema in “JSON”.

**Example 9-14. Accessing the text column in the topTweets SchemaRDD in Python**
```python
topTweetText = topTweets.map(lambda row: row.text)
```

Caching in Spark SQL works a bit differently. `Since we know the types of each column, Spark is able to more efficiently store the data. To make sure that we cache using the memory efficient representation, rather than the full objects, we should use the special hiveCtx.cacheTable(“tableName”) method. When caching a table, Spark SQL represents the data in an in-memory columnar format.` This cached table will remain in memory only for the life of our driver program, so if it exits we will need to recache our data. As with RDDs, we cache tables when we expect to run multiple tasks or queries against the same data.

In Spark 1.2, the regular cache() method on RDDs also results in a cacheTable().  

You can also cache tables using HiveQL/SQL statements. To cache or uncache a table simply run CACHE TABLE tableName or UNCACHE TABLE tableName. This is most commonly used with command-line clients to the JDBC server.

### Loading and Saving Data
Spark SQL supports a number of structured data sources out of the box, letting you get Row objects from them without any complicated loading process. These sources include Hive tables, JSON, and Parquet files. `In addition, if you query these sources using SQL and select only a subset of the fields, Spark SQL can smartly scan only the subset of the data for those fields, instead of scanning all the data like a naive SparkContext.hadoopFile might.`

Apart from these data sources, you can also convert regular RDDs in your program to SchemaRDDs by assigning them a schema. This makes it easy to write SQL queries even when your underlying data is Python or Java objects. Often, SQL queries are more concise when you’re computing many quantities at once (e.g., if you wanted to compute the average age, max age, and count of distinct user IDs in one pass). In addition, you can easily join these RDDs with SchemaRDDs from any other Spark SQL data source.

#### Loading and Saving Data: Apache Hive
When loading data from Hive, Spark SQL supports any Hive-supported storage formats (SerDes), including text files, RCFiles, ORC, Parquet, Avro, and Protocol Buffers. 

To connect Spark SQL to an existing Hive installation, you need to provide a Hive configuration. You do so by copying your hive-site.xml file to Spark’s ./conf/ directory. If you just want to explore, a local Hive metastore will be used if no hive-site.xml is set, and we can easily load data into a Hive table to query later on.

Examples 9-15 through 9-17 illustrate querying a Hive table. Our example Hive table has two columns, key (which is an integer) and value (which is a string).

**Example 9-15. Hive load in Python**
```python
from pyspark.sql import HiveContext
hiveCtx = HiveContext(sc)
rows = hiveCtx.sql(“SELECT key, value FROM mytable”)
keys = rows.map(lambda row: row[0])
```

```scala
Example 9-16. Hive load in Scala
import org.apache.spark.sql.hive.HiveContext
val hiveCtx = new HiveContext(sc)
val rows = hiveCtx.sql(“SELECT key, value FROM mytable”)
val keys = rows.map(row => row.getInt(0))
```

#### Loading and Saving Data: Parquet
Parquet is a popular column-oriented storage format that can `store records with nested fields efficiently`. It is often used with tools in the Hadoop ecosystem, and it supports all of the data types in Spark SQL. Spark SQL provides methods for reading data directly to and from Parquet files.

First, to load data, you can use HiveContext.parquetFile or SQLContext.parquetFile, as shown in Example 9-18.
**Example 9-18. Parquet load in Python**
```python
# Load some data in from a Parquet file with field’s name and favouriteAnimal
rows = hiveCtx.parquetFile(parquetFile)
names = rows.map(lambda row: row.name)
print “Everyone”
print names.collect()
```
You can also register a Parquet file as a Spark SQL temp table and write queries against it. Example 9-19 continues from Example 9-18 where we loaded the data.  
**Example 9-19. Parquet query in Python**  
```python
# Find the panda lovers
tbl = rows.registerTempTable(“people”)
pandaFriends = hiveCtx.sql(“SELECT name FROM people WHERE favouriteAnimal = "panda"”)
print “Panda friends”
print pandaFriends.map(lambda row: row.name).collect()
```
Finally, you can save the contents of a SchemaRDD to Parquet with saveAsParquetFile(), as shown in Example 9-20.
**Example 9-20. Parquet file save in Python**
```python
pandaFriends.saveAsParquetFile(“hdfs://…”)
```

#### Loading and Saving Data: JSON
If you have a JSON file with records fitting the same schema, Spark SQL can infer the schema by scanning the file and let you access fields by name (Example 9-21). If you have ever found yourself staring at a huge directory of JSON records, Spark SQL’s schema inference is a very effective way to start working with the data without writing any special loading code.  

To load our JSON data, all we need to do is call the jsonFile() function on our hiveCtx, as shown in Examples 9-22 through 9-24. If you are curious about what the inferred schema for your data is, you can call printSchema on the resulting SchemaRDD (Example 9-25).

Example 9-21. Input records
```json
{“name”: “Holden”}
{“name”:“Sparky The Bear”, “lovesPandas”:true, “knows”:{“friends”: [“holden”]}}
```

**Example 9-23. Loading JSON with Spark SQL in Scala**
```scala
val input = hiveCtx.jsonFile(inputFile)
```
Example 9-25. Resulting schema from printSchema()
```html
root
|— knows: struct (nullable = true)
|       |— friends: array (nullable = true)
|       |       |— element: string (containsNull = false)
|— lovesPandas: boolean (nullable = true)
|— name: string (nullable = true)
```

As you look at these schemas, a natural question is how to access nested fields and array fields. Both in Python and when we register a table, we can access nested elements by using the . for each level of nesting (e.g., toplevel.nextlevel). You can access array elements in SQL by specifying the index with [element], as shown in Example 9-27.
Example 9-27. SQL query nested and array elements
```sql
select hashtagEntities[0].text from tweets LIMIT 1;
```

#### Loading and Saving Data: From RDDs
In addition to loading data, we can also create a SchemaRDD from an RDD. In Scala, RDDs with case classes are implicitly converted into SchemaRDDs.

For Python we create an RDD of Row objects and then call inferSchema(), as shown in Example 9-28.  
**Example 9-28. Creating a SchemaRDD using Row and named tuple in Python**
```python
happyPeopleRDD = sc.parallelize([Row(name=“holden”, favouriteBeverage=“coffee”)])
happyPeopleSchemaRDD = hiveCtx.inferSchema(happyPeopleRDD)
happyPeopleSchemaRDD.registerTempTable(“happy_people”)
```

With Scala, our old friend implicit conversions handles the inference of the schema for us (Example 9-29).  
**Example 9-29. Creating a SchemaRDD from case class in Scala**  
```scala
case class HappyPerson(handle: String, favouriteBeverage: String)
… // Create a person and turn it into a Schema RDD
val happyPeopleRDD = sc.parallelize(List(HappyPerson(“holden”, “coffee”)))
// Note: there is an implicit conversion
// that is equivalent to sqlCtx.createSchemaRDD(happyPeopleRDD)
happyPeopleRDD.registerTempTable(“happy_people”)
```

### JDBC/ODBC Server
Spark SQL also provides JDBC connectivity, which is useful for connecting business intelligence (BI) tools to a Spark cluster and for sharing a cluster across multiple users. `The JDBC server runs as a standalone Spark driver program that can be shared by multiple clients`. Any client can cache tables in memory, query them, and so on, and `the cluster resources and cached data will be shared among all of them`.

Spark SQL’s JDBC server corresponds to the HiveServer2 in Hive. It is also known as the `“Thrift server”` since it uses the Thrift communication protocol. Note that the JDBC server requires Spark be built with Hive support.

The server can be launched with sbin/start-thriftserver.sh in your Spark directory (Example 9-31). This script takes many of the same options as spark-submit. By default it listens on localhost:10000, but we can change these with either environment variables (HIVE_SERVER2_THRIFT_PORT and HIVE_SERVER2_THRIFT_BIND_HOST), or with Hive configuration properties (hive.server2.thrift.port and hive.server2.thrift.bind.host). You can also specify Hive properties on the command line with —hiveconf property=value.  

**Example 9-31. Launching the JDBC server**
```shell
./sbin/start-thriftserver.sh —master sparkMaster
```
Spark also ships with the **Beeline** client program we can use to connect to our JDBC server.  
**Example 9-32. Connecting to the JDBC server with Beeline**
```shell
holden@hmbp2:~/repos/spark$ ./bin/beeline -u jdbc:hive2://localhost:10000
```
#### Working with Beeline
Within the Beeline client, you can use standard HiveQL commands to create, list, and query tables.
```sql
> CREATE TABLE IF NOT EXISTS mytable (key INT, value STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ‘,’;
> LOAD DATA LOCAL INPATH ‘learning-spark-examples/files/int_string.csv’
INTO TABLE mytable;
```

To list tables, you can use the SHOW TABLES statement (Example 9-34). You can also describe each table’s schema with DESCRIBE tableName

The Beeline shell is great for quick data exploration on cached tables shared by multiple users.

#### Long-Lived Tables and Queries
One of the advantages of using Spark SQL’s JDBC server is we can share cached tables between multiple programs. This is possible since the JDBC Thrift server is a single driver program. To do this, you only need to register the table and then run the CACHE command on it.

#### Standalone Spark SQL Shell
Apart from its JDBC server, Spark SQL also supports a simple shell you can use as a
single process, available through ./bin/spark-sql. This shell connects to the Hive metastore
you have set in conf/hive-site.xml, if one exists, or creates one locally. It is most useful for
local development; in a shared cluster, you should instead use the JDBC server and have
users connect with beeline.

### User-Defined Functions
User-defined functions, or UDFs, allow you to register custom functions in Python, Java, and Scala to call within SQL. They are a very popular way to expose advanced functionality to SQL users in an organization, so that these users can call into it without writing code. Spark SQL makes it especially easy to write UDFs. `It supports both its own UDF interface and existing Apache Hive UDFs`.

Spark SQL offers a built-in method to easily register UDFs by passing in a function in your programming language. In Scala and Python, we can use the native function and lambda syntax of the language, and in Java we need only extend the appropriate UDF class. Our UDFs can work on a variety of types, and we can return a different type than the one we are called with.

**Example 9-36. Python string length UDF**  
```python
# Make a UDF to tell us how long some text is
hiveCtx.registerFunction(“strLenPython”, lambda x: len(x), IntegerType())
lengthSchemaRDD = hiveCtx.sql(“SELECT strLenPython(‘text’) FROM tweets LIMIT 10”)
```

**Example 9-37. Scala string length UDF**
```scala
registerFunction(“strLenScala”, (_: String).length)
val tweetLength = hiveCtx.sql(“SELECT strLenScala(‘tweet’) FROM tweets LIMIT 10”)
```
In Python and Java we also need to specify the return type using one of the SchemaRDD types, listed in Table 9-1. In Java these types are found in org.apache.spark.sql.api.java.DataType and in Python we import the DataType.

Spark SQL can also use existing Hive UDFs. The standard Hive UDFs are already automatically included. If you have a custom UDF, it is important to make sure that the JARs for your UDF are included with your application.  Using a Hive UDF requires that we use the HiveContext instead of a regular SQLContext. To make a Hive UDF available, simply call `hiveCtx.sql(“CREATE TEMPORARY FUNCTION name AS class.function“)`.

### Spark SQL Performance
As alluded to in the introduction, Spark SQL’s higher-level query language and additional type information allows Spark SQL to be more efficient.

Spark SQL is for more than just users who are familiar with SQL. Spark SQL makes it very easy to perform conditional aggregate operations, like counting the sum of multiple columns (as shown in Example 9-40), without having to construct special objects as we discussed in Chapter 6. 
**Example 9-40. Spark SQL multiple sums**
```sql
SELECT SUM(user.favouritesCount), SUM(retweetCount), user.id FROM tweets
GROUP BY user.id
```

Spark SQL is able to use the knowledge of types to more efficiently represent our data. `When caching data, Spark SQL uses an in-memory columnar storage`. This not only takes up less space when cached, but if our subsequent queries depend only on subsets of the data, Spark SQL minimizes the data read.  

`Predicate push-down` allows Spark SQL to move some parts of our query “down” to the engine we are querying. If we wanted to read only certain records in Spark, the standard way to handle this would be to read in the entire dataset and then execute a filter on it. However, in Spark SQL, if the underlying data store supports retrieving only subsets of the key range, or another restriction, Spark SQL is able to push the restrictions in our query down to the data store, resulting in potentially much less data being read.

**Table 9-2. Performance options in Spark SQL**  

Option                                                                      |Default    |Usage
----------------------------------------------------------|------------|-----------------------------------------------------------------------------
spark.sql.codegen                                                     |false         |When true, Spark SQL will compile each query to Java bytecode on the fly. This can `improve performance for large queries`, but codegen can slow down very short queries.
spark.sql.inMemoryColumnarStorage.compressed     |false         |Compress the in-memory columnar storage automatically.
spark.sql.inMemoryColumnarStorage.batchSize       |1000          |The batch size for columnar caching. Larger values may cause out-of-memory problems
spark.sql.parquet.compression.codec                        |snappy       |Which compression codec to use. Possible options include uncompressed, snappy, gzip, and lzo.

Using the JDBC connector, and the Beeline shell, we can set these performance options, and other options, with the set command, as shown in Example 9-41.  
**Example 9-41. Beeline command for enabling codegen**
```shell
beeline> set spark.sql.codegen=true;
SET spark.sql.codegen=true
spark.sql.codegen=true
Time taken: 1.196 seconds
```
In a traditional Spark SQL application we can set these Spark properties on our Spark configuration instead, as shown in Example 9-42.  
**Example 9-42. Scala code for enabling codegen**
```scala
conf.set(“spark.sql.codegen”, “true”)
```

A few options warrant special attention. First is spark.sql.codegen, which causes Spark SQL to compile each query to Java bytecode before running it. Codegen can `make long queries or frequently repeated queries substantially faster`, because it generates specialized code to run them. However, in a setting with very short (1–2 seconds) ad hoc queries, it may add overhead as it has to run a compiler for each query. Codegen is also still experimental, but we recommend trying it for any workload with large queries, or with the same query repeated over and over.

The second option you may need to tune is spark.sql.inMemoryColumnarStorage.batchSize. When caching SchemaRDDs, `Spark SQL groups together the records in the RDD in batches of the size given by this option (default: 1000), and compresses each batch.` Very small batch sizes lead to low compression, but on the other hand, very large sizes can also be problematic, as each batch might be too large to build up in memory. If the rows in your tables are large (i.e., contain hundreds of fields or contain string fields that can be very long, such as web pages), you may need to lower the batch size to avoid out-of-memory errors. If not, the default batch size is likely fine, as there are diminishing returns for extra compression when you go beyond 1,000 records.

We will start by creating a **StreamingContext**, which is the main entry point for streaming functionality. This also sets up an underlying SparkContext that it will use to process the data. `It takes as input a batch interval specifying how often to process new data, which we set to 1 second`. Next, we use socketTextStream() to create a DStream based on text data received on port 7777 of the local machine. Then we transform the DStream with filter() to get only the lines that contain error. Finally, we apply the output operation print() to print some of the filtered lines.  
**Example 10-4. Streaming filter for printing lines containing “error” in Scala**
```scala
// Create a StreamingContext with a 1-second batch size from a SparkConf
val ssc = new StreamingContext(conf, Seconds(1))
// Create a DStream using data received after connecting to port 7777 on the
// local machine
val lines = ssc.socketTextStream(“localhost”, 7777)
// Filter our DStream for lines with “error”
val errorLines = lines.filter(_.contains(“error”))
// Print out the lines with errors
errorLines.print()
```

## Chapter 10. Spark Streaming
It lets users write streaming applications using a very similar API to batch jobs, and thus reuse a lot of the skills and even code they built for those.

Much like Spark is built on the concept of RDDs, Spark Streaming provides an abstraction called DStreams, or discretized streams. A **DStream** is a sequence of data arriving over time. Internally, each DStream is represented as `a sequence of RDDs arriving at each time step` (hence the name “discretized”). DStreams can be created from various input sources, such as Flume, Kafka, or HDFS. Once built, they offer two types of operations: `transformations`, which yield a new DStream, and `output` operations, which write data to an external system. `DStreams provide many of the same operations available on RDDs, plus new operations related to time, such as sliding windows.`

Unlike batch programs, Spark Streaming applications need additional setup in order to operate 24/7. We will discuss `checkpointing`, the main mechanism Spark Streaming provides for this purpose, which lets it store data in a reliable file system such as HDFS. We will also discuss how to restart applications on failure or set them to be automatically restarted.

Before we dive into the details of Spark Streaming, let’s consider a simple example. We will receive a stream of newline-delimited lines of text from a server running at port 7777, filter only the lines that contain the word error, and print them.

Spark Streaming programs are best run as standalone applications built using Maven or sbt. Spark Streaming, while part of Spark, ships as a separate Maven artifact and has some additional imports you will want to add to your project. These are shown in Examples 10- 1 through 10-3.

**Example 10-1. Maven coordinates for Spark Streaming**
```maven
groupId = org.apache.spark
artifactId = spark-streaming_2.10
version = 1.2.0
```
**Example 10-2. Scala streaming imports**
```scala
import org.apache.spark.streaming.StreamingContext
import org.apache.spark.streaming.StreamingContext._
import org.apache.spark.streaming.dstream.DStream
import org.apache.spark.streaming.Duration
import org.apache.spark.streaming.Seconds
```

We will start by creating a **StreamingContext**, which is the main entry point for streaming functionality. This also sets up an underlying SparkContext that it will use to process the data. It takes as input a batch interval specifying how often to process new data, which we set to 1 second. Next, we use socketTextStream() to create a DStream based on text data received on port 7777 of the local machine. Then we transform the DStream with filter() to get only the lines that contain error. Finally, we apply the output operation print() to print some of the filtered lines.

**Example 10-4. Streaming filter for printing lines containing “error” in Scala**
```scala
// Create a StreamingContext with a 1-second batch size from a SparkConf
val ssc = new StreamingContext(conf, Seconds(1))
// Create a DStream using data received after connecting to port 7777 on the
// local machine
val lines = ssc.socketTextStream(“localhost”, 7777)
// Filter our DStream for lines with “error”
val errorLines = lines.filter(_.contains(“error”))
// Print out the lines with errors
errorLines.print()
```

This sets up only the computation that will be done when the system receives data. To start receiving data, we must explicitly call start() on the StreamingContext. Then, Spark Streaming will start to schedule Spark jobs on the underlying SparkContext. This will occur in a separate thread, so to keep our application from exiting, we also need to call awaitTermination to wait for the streaming computation to finish. (See Examples 10-6 and 10-7.)

**Example 10-6. Streaming filter for printing lines containing “error” in Scala**
```scala
// Start our streaming context and wait for it to “finish”
ssc.start()
// Wait for the job to finish
ssc.awaitTermination()
```

Note that a streaming context can be started only once, `and must be started after we set up all the DStreams and output operations we want`.

**Example 10-8. Running the streaming app and providing data on Linux/Mac**
```shell
$ spark-submit —class com.oreilly.learningsparkexamples.scala.StreamingLogInput \
$ASSEMBLY_JAR local[4]
$ nc localhost 7777 # Lets you type input lines to send to the server
<your input here>
```
Windows users can use the ncat command in place of the nc command. ncat is available as part of nmap.

### Architecture and Abstraction
Spark Streaming uses a “micro-batch” architecture, where the streaming computation is treated as a continuous series of batch computations on small batches of data. `Spark Streaming receives data from various input sources and groups it into small batches`. New batches are created `at regular time intervals`. At the beginning of each time interval a new batch is created, and any data that arrives during that interval gets added to that batch. At the end of the time interval the batch is done growing. The size of `the time intervals is determined by a parameter called the batch interval`. The batch interval is typically between 500 milliseconds and several seconds, as configured by the application developer. `Each input batch forms an RDD`, and is processed using Spark jobs to create other RDDs. The processed results can then be pushed out to external systems in batches. This high-level architecture is shown in Figure 10-1.

![spark_stream_architecture_img_1]  
**Figure 10-1. High-level architecture of Spark Streaming**  

As you’ve learned, the programming abstraction in Spark Streaming is a discretized stream or a DStream (shown in Figure 10-2), which is a sequence of RDDs, where each RDD has one time slice of the data in the stream.
![spark_dstream_img_1]  
**Figure 10-2. DStream as a continuous series of RDDs**  

`You can create DStreams either from external input sources, or by applying transformations to other DStreams`. `DStreams support many of the transformations that you saw on RDDs in Chapter 3`. Additionally, DStreams also have new “stateful” transformations that can aggregate data across time.

Apart from transformations, DStreams support output operations, such as the print() used in our example. Output operations are similar to RDD actions in that they write data to an external system, but in Spark Streaming they run periodically on each time step, producing output in batches.

![spark_dstream_transform_example_img_1]  
**Figure 10-3. DStreams and transformation of Examples 10-4 through 10-8**

![spark_stream_components_img_1]  
**Figure 10-4. Spark application UI when running a streaming job**

The execution of Spark Streaming within Spark’s driver-worker components is shown in Figure 10-5. For each input source, Spark Streaming launches receivers, which are tasks running within the application’s executors that collect data from the input source and save it as RDDs. `These receive the input data and replicate it (by default) to another executor for fault tolerance`. This data is stored in the memory of the executors in the same way as cached RDDs.14 The StreamingContext in the driver program then periodically runs Spark jobs to process this data and `combine it with RDDs from previous time steps`.

`Spark Streaming offers the same fault-tolerance properties for DStreams as Spark has for RDDs`: as long as a copy of the input data is still available, it can recompute any state derived from it using the lineage of the RDDs (i.e., by rerunning the operations used to process it). `By default, received data is replicated across two nodes`, as mentioned, so Spark Streaming can tolerate single worker failures. Using just lineage, however, `recomputation could take a long time for data that has been built up since the beginning of the program. Thus, Spark Streaming also includes a mechanism called checkpointing that saves state periodically to a reliable filesystem (e.g., HDFS or S3)`. Typically, you might set up `checkpointing every 5–10 batches of data`. When recovering lost data, Spark Streaming needs only to go back to the last checkpoint.

### Stream Transformations
Transformations on DStreams can be grouped into either `stateless` or `stateful`:  
* In stateless transformations the processing of each batch does `not depend on the data of its previous batches`. They include the common RDD transformations we have seen in Chapters 3 and 4, like map(), filter(), and reduceByKey().  
* Stateful transformations, in contrast, `use data or intermediate results from previous batches` to compute the results of the current batch. `They include transformations based on sliding windows and on tracking state across time`.

#### Stateless Transformations
Stateless transformations, some of which are listed in Table 10-1, are simple RDD transformations being applied on every batch — that is, every RDD in a DStream. We have already seen filter() in Figure 10-3. Many of the RDD transformations discussed in Chapters 3 and 4 are also available on DStreams. Note that key/value DStream transformations like reduceByKey() are made available in Scala by import StreamingContext._.

**Table 10-1. Examples of stateless DStream transformations (incomplete list)**  
* map()
* flatMap()
* filter()
* repartition()
* reduceByKey()
* groupByKey()

Keep in mind that although these functions look like they’re applying to the whole stream, internally each DStream is composed of multiple RDDs (batches), and each stateless transformation applies separately to each RDD. For example, reduceByKey() will reduce data within each time step, but not across time steps. The stateful transformations we cover later allow combining data across time.

**Example 10-10. map() and reduceByKey() on DStream in Scala**
```scala
// Assumes ApacheAccessLog is a utility class for parsing entries from Apache logs
val accessLogDStream = logData.map(line => ApacheAccessLog.parseFromLogLine(line))
val ipDStream = accessLogsDStream.map(entry => (entry.getIpAddress(), 1))
val ipCountsDStream = ipDStream.reduceByKey((x, y) => x + y)
```

Stateless transformations can also combine data from multiple DStreams, again within each time step.  

For example, key/value DStreams have the same join-related transformations as RDDs — namely, cogroup(), join(), leftOuterJoin(), and so on (see “Joins”). We can use these operations on DStreams to perform the underlying RDD operations separately on each batch. Let us consider a join between two DStreams. In Examples 10-12 and 10-13, we have data keyed by IP address, and we join the request count against the bytes transferred.

**Example 10-12. Joining two DStreams in Scala**
```scala
val ipBytesDStream = accessLogsDStream.map(entry => (entry.getIpAddress(), entry.getContentSize()))
val ipBytesSumDStream = ipBytesDStream.reduceByKey((x, y) => x + y)
val ipBytesRequestCountDStream = ipCountsDStream.join(ipBytesSumDStream)
```

We can also merge the contents of two different DStreams using the union() operator as in regular Spark, or using `StreamingContext.union()` for multiple streams.

Finally, if these stateless transformations are insufficient, DStreams provide an advanced operator called transform() that lets you operate `directly on the RDDs inside them`. The transform() operation lets you provide any `arbitrary RDD-to-RDD function` to act on the DStream. This function `gets called on each batch of data in the stream to produce a new stream`. `A common application of transform() is to reuse batch processing code you had written on RDDs`. For example, if you had a function, extractOutliers(), that acted on an RDD of log lines to produce an RDD of outliers (perhaps after running some statistics on the messages), you could reuse it within a transform(), as shown in Examples 10-14 and 10-15.  
**Example 10-14. transform() on a DStream in Scala**  
```scala
val outlierDStream = accessLogsDStream.transform { rdd =>
    extractOutliers(rdd)
}
```
You can also combine and transform data from multiple DStreams together using StreamingContext.transform or DStream.transformWith(otherStream, func).

#### Stateful Transformations
Stateful transformations are operations on DStreams that track data across time; that is, some data from previous batches is used to generate the results for a new batch. The two main types are `windowed operations`, which act over a sliding window of time periods, and `updateStateByKey()`, which is used to track state across events for each key (e.g., to build up an object representing each user session).  

Stateful transformations `require checkpointing` to be enabled in your StreamingContext for fault tolerance. We will discuss checkpointing in more detail in “24/7 Operation”, but for now, you can `enable it by passing a directory to ssc.checkpoint()`, as shown in Example 10-16.  

**Example 10-16. Setting up checkpointing**
```scala
ssc.checkpoint(“hdfs://…”)
```

##### Windowed transformations
Windowed operations compute results across a longer time period than the StreamingContext’s batch interval, by combining results from multiple batches.

All windowed operations need two parameters, `window duration` and `sliding duration`, both of which must be `a multiple of the StreamingContext’s batch interval`. The window duration controls how many previous batches of data are considered, namely the last windowDuration/batchInterval. If we had a source DStream with a batch interval of 10 seconds and wanted to create a sliding window of the last 30 seconds (or last 3 batches) we would set the windowDuration to 30 seconds. The sliding duration, which defaults to the batch interval, controls how frequently the new DStream computes results. If we had the source DStream with a batch interval of 10 seconds and wanted to compute our window only on every second batch, we would set our sliding interval to 20 seconds. Figure 10-6 shows an example.  

![spark_stream_window_example_img_1]  
**Figure 10-6. A windowed stream with a window duration of 3 batches and a slide duration of 2 batches; every two time steps, we compute a result over the previous 3 time steps**  

The simplest window operation we can do on a DStream is window(), which returns a new DStream with the data for the requested window. In other words, each RDD in the DStream resulting from window() will contain data from multiple batches, which we can then process with count(), transform(), and so on. (See Examples 10-17 and 10-18.)

**Example 10-17. How to use window() to count data over a window in Scala**  
```scala
val accessLogsWindow = accessLogsDStream.window(Seconds(30), Seconds(10))
val windowCounts = accessLogsWindow.count()
```

While we can build all other windowed operations on top of window(), Spark Streaming provides a number of other windowed operations for efficiency and convenience. First, `reduceByWindow()` and `reduceByKeyAndWindow()` allow us to perform reductions on each window more efficiently. They take a single reduce function to run on the whole window, such as +. In addition, they have `a special form that allows Spark to compute the reduction incrementally`, `by considering only which data is coming into the window and which data is going out`. This special form `requires an inverse of the reduce function`, such as - for +. It is much more efficient for large windows if your function has an inverse (see Figure 10- 7).

![spark_stream_window_incremental_img_1]  
Figure 10-7. Difference between naive reduceByWindow() and incremental reduceByWindow(), using an inverse function

PS: I think Figure 10-7 is wrong, here is the correct one per my understanding  
![spark_stream_window_incremental_img_2]  

In our log processing example, we can use these two functions to count visits by each IP
address more efficiently, as you can see in Examples 10-19 and 10-20.
Example 10-19. Scala visit counts per IP address
```scala
val ipDStream = accessLogsDStream.map(logEntry => (logEntry.getIpAddress(), 1))
val ipCountDStream = ipDStream.reduceByKeyAndWindow(
    {(x, y) => x + y}, // Adding elements in the new batches entering the window
    {(x, y) => x - y}, // Removing elements from the oldest batches exiting the window
    Seconds(30), // Window duration, PS: should be Seconds(40) to match with Figure 10-7
    Seconds(10)) // Slide duration
```

Finally, for counting data, DStreams offer countByWindow() and countByValueAndWindow() as shorthands. countByWindow() gives us a DStream representing the number of elements in each window. countByValueAndWindow() gives us a DStream with the counts for each value. See Examples 10-21 and 10-22.  
**Example 10-21. Windowed count operations in Scala**  
```scala
val ipDStream = accessLogsDStream.map{entry => entry.getIpAddress()}
val ipAddressRequestCount = ipDStream.countByValueAndWindow(Seconds(30), Seconds(10))
val requestCount = accessLogsDStream.countByWindow(Seconds(30), Seconds(10))
```

##### UpdateStateByKey transformation
Sometimes it’s useful to maintain state across the batches in a DStream (e.g., to track sessions as users visit a site). updateStateByKey() enables this by providing access to a state variable for DStreams of key/value pairs. Given a DStream of (key, event) pairs, it lets you construct a new DStream of (key, state) pairs by taking a function that specifies how to update the state for each key given new events. For example, in a web server log, our events might be visits to the site, where the key is the user ID. Using updateStateByKey(), we could track the last 10 pages each user visited. This list would be our “state” object, and we’d update it as each event arrives.  

To use updateStateByKey(), we provide a function `update(events, oldState)` that takes in the events that have arrived for a key and its previous state, and returns a newState to store for it. This function’s signature is as follows:
* events is a list of events that arrived in the current batch (may be empty).
* oldState is an optional state object, stored within an Option; it might be missing if there was no previous state for the key.
* newState, returned by the function, is also an Option; we can return an empty Option to specify that we want to delete the state.

The result of updateStateByKey() will be `a new DStream` that contains an RDD of (key, state) pairs on each time step.

As a simple example, we’ll use updateStateByKey() to keep a running count of the number of log messages with each HTTP response code. Our keys here are the response codes, our state is an integer representing each count, and our events are page views. Note that unlike our window examples earlier, Examples 10-23 and 10-24 keep an “infinitely growing” count since the beginning of the program.

**Example 10-23. Running count of response codes using updateStateByKey() in Scala**
```scala
def updateRunningSum(values: Seq[Long], state: Option[Long]) = {
    Some(state.getOrElse(0L) + values.size)
}
val responseCodeDStream = accessLogsDStream.map(log => (log.getResponseCode(), 1L))
val responseCodeCountDStream = responseCodeDStream.updateStateByKey(updateRunningSum _)
```

#### Stream Output Operations
Much like lazy evaluation in RDDs, if no output operation is applied on a DStream and any of its descendants, then those DStreams will not be evaluated. And if there are no output operations set in a StreamingContext, then the context will not start.

A common debugging output operation that we have used already is print(). This grabs the first 10 elements from each batch of the DStream and prints the results.

Once we’ve debugged our program, we can also use output operations to save results. Spark Streaming has similar save() operations for DStreams, each of which takes a directory to save files into and an optional suffix. The results of each batch are saved as subdirectories in the given directory, with the time and the suffix in the filename.

**Example 10-26. Saving SequenceFiles from a DStream in Scala**
```scala
val writableIpAddressRequestCount = ipAddressRequestCount.map {
    (ip, count) => (new Text(ip), new LongWritable(count)) }
writableIpAddressRequestCount.saveAsHadoopFiles[
    SequenceFileOutputFormat[Text, LongWritable]](“outputDir”, “txt”)
```

Finally, foreachRDD() is a generic output operation that lets us run arbitrary computations on the RDDs on the DStream. It is similar to transform() in that it gives you access to each RDD. Within foreachRDD(), we can reuse all the actions we have in Spark. For example, a common use case is to write data to an external database such as MySQL, where Spark may not have a saveAs() function, but we might use for eachPartition() on the RDD to write it out. For convenience, foreachRDD() can also give us the time of the current batch, allowing us to output each time period to a different location. See Example 10-28.  

**Example 10-28. Saving data to external systems with foreachRDD() in Scala**
```scala
ipAddressRequestCount.foreachRDD { rdd =>
    rdd.foreachPartition { partition =>
        // Open connection to storage system (e.g. a database connection)
        partition.foreach { item =>
            // Use connection to push item to system
        }
        // Close connection
    }
}
```

### Stream Input Sources
Spark Streaming has built-in support for a number of different data sources. Some “core” sources are built into the Spark Streaming Maven artifact, while others are available through additional artifacts, such as spark-streaming-kafka.

If you are designing a new application, we recommend trying HDFS or Kafka as simple input sources to get started with.

#### Core Sources
The methods to create DStream from the core sources are all available on the StreamingContext. We have already explored one of these sources in the example: `sockets`. Here we discuss two more, `files` and `Akka actors`.

##### Stream of files
Since Spark supports reading from any Hadoop-compatible filesystem, Spark Streaming naturally allows a stream to be created from files written in a directory of a Hadoopcompatible filesystem.

For Spark Streaming to work with the data, it needs to have a `consistent date format for the directory names` and `the files have to be created atomically` (e.g., by moving the file into the directory Spark is monitoring).

**Example 10-29. Streaming text files written to a directory in Scala**
```scala
val logData = ssc.textFileStream(logDirectory)
```

**Example 10-31. Streaming SequenceFiles written to a directory in Scala**
```scala
ssc.fileStream[LongWritable, IntWritable,
    SequenceFileInputFormat[LongWritable, IntWritable]](inputDirectory).map {
        case (x, y) => (x.get(), y.get())
}
```

##### Akka actor stream
The second core receiver is actorStream, which allows using Akka actors as a source for streaming. To construct an actor stream we create an Akka actor and implement the org.apache.spark.streaming.receiver.ActorHelper interface. To copy the input from our actor into Spark Streaming, we need to call the store() function in our actor when we receive new data.

#### Additional Sources
In addition to the core sources, additional receivers for well-known data ingestion systems are packaged as separate components of Spark Streaming. These receivers are still part of Spark, but require extra packages to be included in your build file. Some current receivers include `Twitter`, `Apache Kafka`, `Amazon Kinesis`, `Apache Flume`, and `ZeroMQ`. We can include these additional receivers by adding the Maven artifact `spark-streaming- [projectname]_2.10` with the same version number as Spark.

##### Apache Kafka
[Apache Kafka] is popular input source `due to its speed and resilience`. Using the native support for Kafka, we can easily process the messages for many topics. To use it, we have to include the Maven artifact `spark-streaming-kafka_2.10` to our project. The provided KafkaUtils object works on StreamingContext and JavaStreamingContext to create a DStream of your Kafka messages. `Since it can subscribe to multiple topics, the DStream it creates consists of pairs of topic and message`. To create a stream, we will call the createStream() method with our streaming context, a string containing comma-separated ZooKeeper hosts, the name of our consumer group (a unique name), and a map of topics to number of receiver threads to use for that topic (see Examples 10-32 and 10-33).

**Example 10-32. Apache Kafka subscribing to Panda’s topic in Scala**
```scala
import org.apache.spark.streaming.kafka._
… // Create a map of topics to number of receiver threads to use
val topics = List((“pandas”, 1), (“logs”, 1)).toMap
val topicLines = KafkaUtils.createStream(ssc, zkQuorum, group, topics)
StreamingLogInput.processLines(topicLines.map(_._2))
```

##### Apache Flume
Spark has two different receivers for use with Apache Flume (see Figure 10-8). They are as follows:  
* Push-based receiver  
The receiver `acts as an Avro sink` that Flume pushes data to. 
* Pull-based receiver  
The receiver can `pull data from an intermediate custom sink`, to which other processes are pushing data with Flume.

Both approaches require reconfiguring Flume and running the receiver on a node on a configured port (not your existing Spark or Flume ports). To use either of them, we have to include the Maven artifact spark-streaming-flume_2.10 in our project.

* Push-based receiver  
The push-based approach can be set up quickly but `does not use transactions` to receive data. In this approach, the receiver acts as an Avro sink, and we need to configure Flume to send the data to the Avro sink (Example 10-34). The provided Flume Utils object sets up the receiver to be started on a specific worker’s hostname and port (Examples 10-35 and 10-36). These must match those in our Flume configuration.  
**Example 10-34. Flume configuration for Avro sink**
```properties
a1.sinks = avroSink
a1.sinks.avroSink.type = avro
a1.sinks.avroSink.channel = memoryChannel
a1.sinks.avroSink.hostname = receiver-hostname
a1.sinks.avroSink.port = port-used-for-avro-sink-not-spark-port
```
**Example 10-35. FlumeUtils agent in Scala**
```scala
val events = FlumeUtils.createStream(ssc, receiverHostname, receiverPort)
```

`Despite its simplicity, the disadvantage of this approach is its lack of transactions`. This increases the chance of losing small amounts of data in case of the failure of the worker node running the receiver. Furthermore, if the worker running the receiver fails, the system will try to launch the receiver at a different location, and Flume will need to be reconfigured to send to the new worker. This is often challenging to set up.

* Pull-based receiver   
The newer pull-based approach (added in Spark 1.1) is to set up a specialized Flume sink Spark Streaming will read from, and have the receiver pull the data from the sink. This approach is preferred for resiliency, as the data remains in the sink until Spark Streaming reads and replicates it and tells the sink via a transaction.

To get started, we will need to set up the custom sink as a third-party plug-in for Flume. The latest directions on installing plug-ins are in the Flume documentation. Since the plug-in is written in Scala we need to add both the plug-in and the Scala library to Flume’s plug-ins. For Spark 1.1, the Maven coordinates are shown in Example 10-37.

**Example 10-37. Maven coordinates for Flume sink**
```maven
groupId = org.apache.spark
artifactId = spark-streaming-flume-sink_2.10
version = 1.2.0
groupId = org.scala-lang
artifactId = scala-library
version = 2.10.4
```

Once you have the custom flume sink added to a node, we need to configure Flume to push to the sink, as we do in Example 10-38.  
**Example 10-38. Flume configuration for custom sink**
```properties
a1.sinks = spark
a1.sinks.spark.type = org.apache.spark.streaming.flume.sink.SparkSink
a1.sinks.spark.hostname = receiver-hostname
a1.sinks.spark.port = port-used-for-sync-not-spark-port
a1.sinks.spark.channel = memoryChannel
```

**Example 10-39. FlumeUtils custom sink in Scala**
```scala
val events = FlumeUtils.createPollingStream(ssc, receiverHostname, receiverPort)
```

**Example 10-40. FlumeUtils custom sink in Java**
```java
JavaDStream<SparkFlumeEvent> events = FlumeUtils.createPollingStream(ssc,
receiverHostname, receiverPort);
```

In either case, the DStream is composed of **SparkFlumeEvents**. We can access the underlying **AvroFlumeEvent** through event. If our event body was UTF-8 strings we could get the contents as shown in Example 10-41.  
**Example 10-41. SparkFlumeEvent in Scala**
```scala
// Assuming that our flume events are UTF-8 log lines
val lines = events.map{e => new String(e.event.getBody().array(), “UTF-8”)}
```

In addition to the provided sources, you can also implement your own receiver.

As covered earlier, we can combine multiple DStreams using operations like union(). Through these operators, we can combine data from multiple input DStreams. Sometimes multiple receivers are necessary to increase the aggregate throughput of the ingestion (if a single receiver becomes the bottleneck). Other times different receivers are created on different sources to receive different kinds of data, which are then combined using joins or cogroups.   

It is important to understand how the receivers are executed in the Spark cluster to use multiple ones. Each receiver runs as a long-running task within Spark’s executors, and hence occupies CPU cores allocated to the application. In addition, there need to be available cores for processing the data. This means that in order to run multiple receivers, you should have at least as many cores as the number of receivers, plus however many are needed to run your computation. For example, if we want to run 10 receivers in our streaming application, then we have to allocate at least 11 cores.

### 24/7 Operation
One of the main advantages of Spark Streaming is that it provides `strong fault tolerance guarantees`. As long as the input data is stored reliably, Spark Streaming will always compute the correct result from it, offering `“exactly once” semantics` (i.e., as if all of the data was processed without any nodes failing), even if workers or the driver fail.

To run Spark Streaming applications 24/7, you need some special setup. The first step is setting up **checkpointing** to a reliable storage system, such as HDFS or Amazon S3.16 In addition, we need to worry about `the fault tolerance of the driver program` (which requires special setup code) and of unreliable input sources.

#### Checkpointing
Checkpointing is the main mechanism that needs to be set up for fault tolerance in Spark Streaming. It allows Spark Streaming to periodically save data about the application to a reliable storage system, such as HDFS or Amazon S3, for use in recovering. Specifically, checkpointing serves two purposes:  
* Limiting the state that must be recomputed on failure.  
As discussed in “Architecture and Abstraction”, Spark Streaming can recompute state using the lineage graph of transformations, but checkpointing controls how far back it must go.  
* Providing fault tolerance for the driver.  
If the driver program in a streaming application crashes, you can launch it again and tell it to recover from a checkpoint, in which case Spark Streaming will read how far the previous run of the program got in processing the data and take over from there.

**Example 10-42. Setting up checkpointing**
```scala
ssc.checkpoint(“hdfs://…”)
```

Note that even in local mode, Spark Streaming will complain if you try to run a stateful operation without checkpointing enabled. In that case, you can pass a local filesystem path for checkpointing. But in any production setting, you should use a replicated system such as HDFS, S3, or an NFS filer.

#### Driver Fault Tolerance
Tolerating failures of the driver node requires a special way of creating our StreamingContext, which takes in the checkpoint directory. Instead of simply calling new StreamingContext, we need to use the StreamingContext.getOrCreate() function. From our initial example we would change our code as shown in Examples 10-43 and 10- 44.  

**Example 10-43. Setting up a driver that can recover from failure in Scala**
```scala
def createStreamingContext() = {
    …
    val sc = new SparkContext(conf)
    // Create a StreamingContext with a 1 second batch size
    val ssc = new StreamingContext(sc, Seconds(1))
    ssc.checkpoint(checkpointDir)
}
…
val ssc = StreamingContext.getOrCreate(checkpointDir, createStreamingContext _)
```
When this code is run the first time, assuming that the checkpoint directory does not yet exist, the StreamingContext will be created when you call the factory function. In the factory, you should set the checkpoint directory. After the driver fails, if you restart it and run this code again, getOrCreate() will reinitialize a StreamingContext from the checkpoint directory and resume processing.

On most cluster managers, Spark does not automatically relaunch the driver if it crashes, so you need to monitor it using a tool like monit and restart it.

One place where Spark provides more support is the Standalone cluster manager, which supports a —supervise flag when submitting your driver that lets Spark restart it.

**Example 10-45. Launching a driver in supervise mode**
```shell
./bin/spark-submit —deploy-mode cluster —supervise —master spark://… App.jar
```
When using this option, you will also want the Spark Standalone master to be faulttolerant. You can configure this using ZooKeeper, as described in the Spark documentation. With this setup, your application will have no single point of failure.  

Finally, note that when the driver crashes, executors in Spark will also restart. This may be changed in future Spark versions, but it is expected behavior in 1.2 and earlier versions, as the executors are not able to continue processing data without a driver. Your relaunched driver will start new executors to pick up where it left off.

#### Worker Fault Tolerance
For failure of a worker node, Spark Streaming uses the same techniques as Spark for its fault tolerance. `All the data received from external sources is replicated among the Spark workers`. All RDDs created through transformations of this replicated input data are tolerant to failure of a worker node, as the RDD lineage allows the system to recompute the lost data all the way from the surviving replica of the input data.

#### Receiver Fault Tolerance
The fault tolerance of the workers running the receivers is another important consideration. In such a failure, Spark Streaming restarts the failed receivers on other nodes in the cluster. However, whether it loses any of the received data depends on `the nature of the source` (whether the source can resend data or not) and `the implementation of the receiver` (whether it updates the source about received data or not).

In general, receivers provide the following guarantees:  
* All data read from a reliable filesystem is reliable, because the underlying filesystem is replicated.  
* For unreliable sources such as Kafka, push-based Flume, or Twitter, Spark replicates the input data to other nodes, but it can briefly lose data if a receiver task is down. 

#### Processing Guarantees
Due to Spark Streaming’s worker fault-tolerance guarantees, it can provide `exactly-once semantics` for all transformations — even if a worker fails and some data gets reprocessed, the final transformed result (that is, the transformed RDDs) will be the same as if the data were processed exactly once.

However, when the transformed result is to be pushed to external systems using output operations, `the task pushing the result may get executed multiple times due to failures`, and some data can get pushed multiple times. Since this involves external systems, it is up to the system-specific code to handle this case. We can `either use transactions` to push to external systems (that is, atomically push one RDD partition at a time), or design updates to be idempotent operations (such that multiple runs of an update still produce the same result).

### Streaming UI
Spark Streaming provides a special UI page that lets us look at what applications are doing. This is available in a Streaming tab on the normal Spark UI (typically http://<driver>:4040).

### Streaming Performance Considerations
#### Batch and Window Sizes
The most common question is what minimum batch size Spark Streaming can use. In general, `500 milliseconds has proven to be a good minimum size for many applications`. `The best approach is to start with a larger batch size (around 10 seconds) and work your way down to a smaller batch size`. If the processing times reported in the Streaming UI remain consistent, then you can continue to decrease the batch size, but if they are increasing you may have reached the limit for your application.

In a similar way, for windowed operations, the interval at which you compute a result (i.e., the slide interval) has a big impact on performance. Consider increasing this interval for expensive computations if it is a bottleneck???

#### Steaming's Level of Parallelism
A common way to reduce the processing time of batches is to increase the parallelism. There are three ways to increase the parallelism:  
1. Increasing the number of receivers  
Receivers can sometimes act as a bottleneck if there are too many records for a single machine to read in and distribute. You can add more receivers by creating multiple input DStreams (which creates multiple receivers), and then applying union to merge them into a single stream.  
2. Explicitly repartitioning received data  
If receivers cannot be increased anymore, you can further redistribute the received data by explicitly repartitioning the input stream (or the union of multiple streams) using DStream.repartition. 
3. Increasing parallelism in aggregation  
For operations like reduceByKey(), you can specify the parallelism as a second parameter, as already discussed for RDDs.

#### Garbage Collection and Memory Usage
You can minimize unpredictably large pauses due to GC by enabling Java’s Concurrent Mark-Sweep garbage collector. (PS: why not ParallelScanvenge for better throughput?)

Caching RDDs in serialized form (instead of as native objects) also reduces GC pressure, which is why, by default, RDDs generated by Spark Streaming are stored in serialized form. Using Kryo serialization further reduces the memory required for the in-memory representation of cached data.

Spark also allows us to control how cached/persisted RDDs are evicted from the cache. By default Spark uses an LRU cache. Spark will also explicitly evict RDDs older than a certain time period if you set spark.cleaner.ttl. `By preemptively evicting RDDs that we are unlikely to need from the cache, we may be able to reduce the GC pressure.`

## Miscellaneous
### References

---
[Learning Python]:http://shop.oreilly.com/product/0636920028154.do "Learning Python, 5th Edition Powerful Object-Oriented Programming"
[Head First Python]:http://shop.oreilly.com/product/0636920003434.do "Head First Python A Brain-Friendly Guide"
[Dive into Python]:http://www.diveintopython.net/ "Dive Into Python"
[Machine Learning for Hackers]:http://shop.oreilly.com/product/0636920018483.do "Machine Learning for Hackers Case Studies and Algorithms to Get You Started"
[Doing Data Science]:http://shop.oreilly.com/product/0636920028529.do "Doing Data Science Straight Talk from the Frontline"
[spark_unified_stack_img_1]:/resources/img/java/spark_unified_stack_1.png "Figure 1-1. The Spark stack"
[Code Examples]:https://github.com/databricks/learning-spark "Code Examples"
[Berkeley Data Analytics Stack (BDAS)]:https://amplab.cs.berkeley.edu/software/ "Berkeley Data Analytics Stack (BDAS)"
[SQL programming guide]:http://spark.apache.org/docs/latest/sql-programming-guide.html "SQL programming guide"
[RDD programming guide]:http://spark.apache.org/docs/latest/rdd-programming-guide.html "RDD programming guide"
[Quick Start Guide]:http://spark.apache.org/docs/latest/quick-start.html "Quick Start Guide"
[spark_distributed_execution_img_1]:/resources/img/java/spark_distributed_execution_1.png "Figure 2-3. Components for distributed execution in Spark"
[spark_example_lineage_graph_img_1]:/resources/img/java/spark_example_lineage_graph_1.png "Figure 3-1. RDD lineage graph created during log analysis"
[spark_combinebykey_flow_img_1]:/resources/img/java/spark_combinebykey_flow_1.png "Figure 4-3. combineByKey() sample data flow"
[Twitter’s Elephant Bird package]:https://github.com/kevinweil/elephant-bird "Twitter’s Elephant Bird package"
[Protocol buffers]:https://code.google.com/p/protobuf/ "Protocol buffers"
[Spark Cassandra connector]:https://github.com/datastax/spark-cassandra-connector "Spark Cassandra connector"
[Elasticsearch-Hadoop]:https://github.com/elastic/elasticsearch-hadoop "Elasticsearch-Hadoop"
[SparkR]:http://amplab-extras.github.io/SparkR-pkg/ "SparkR R frontend for Spark"
[spark-distribute-structure-img-1]:/resources/img/java/spark-distribute-structure-1.png "Figure 3-1. RDD lineage graph created during log analysis"
[Fair Scheduler]:http://spark.apache.org/docs/latest/job-scheduling.html "Fair Scheduler"
[Aurora]:http://aurora.apache.org/ "Aurora"
[spark-execution-plan-img-1]:/resources/img/java/spark-execution-plan-1.png "Figure 8-1. RDD transformations pipelined into physical stages"
[tuning guide]:http://spark.apache.org/docs/latest/tuning.html "tuning guide"
[spark-sql-usage-img-1]:/resources/img/java/spark-sql-usage-1.png "Figure 9-1. Spark SQL usage"
[spark_stream_architecture_img_1]:/resources/img/java/spark_stream_architecture_1.png "Figure 10-1. High-level architecture of Spark Streaming"
[spark_dstream_img_1]:/resources/img/java/spark_dstream_1.png "Figure 10-2. DStream as a continuous series of RDDs"
[spark_dstream_transform_example_img_1]:/resources/img/java/spark_dstream_transform_example_1.png "Figure 10-3. DStreams and transformation of Examples 10-4 through 10-8"
[spark_stream_components_img_1]:/resources/img/java/spark_stream_components_1.png "Figure 10-5. Execution of Spark Streaming within Spark’s components"
[spark_stream_window_example_img_1]:/resources/img/java/spark_stream_window_example_1.png "Figure 10-6. A windowed stream with a window duration of 3 batches and a slide duration of 2 batches; every two time steps, we compute a result over the previous 3 time steps"
[Akka actors]:https://akka.io/ "Akka actors"
[Apache Kafka]:http://kafka.apache.org/ "Apache Kafka"
