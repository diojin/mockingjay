# 		Digestion of Hadoop- The Definitive Guide, 4th Edition
##							Tom White				
---
## Indexes
* [0. Recommendations](#0-recommendations)
    - [Useful URLs](#useful-urls)
* [1. Meet Hadoop](#1-meet-hadoop)
    - [Comparison with Other Systems](#comparison-with-other-systems)
* [2. MapReduce](#2-mapreduce)
    - [Data Flow](#data-flow)
    - [Combiner Functions](#combiner-functions)
    - [Hadoop Streaming](#hadoop-streaming)
* [3. The Hadoop Distributed Filesystem](#3-the-hadoop-distributed-filesystem)
    - [The Design of HDFS](#the-design-of-hdfs)
    - [HDFS Concepts](#hdfs-concepts)
        + [Blocks](#blocks)
        + [Namenodes and Datanodes](#namenodes-and-datanodes)
        + [Block Caching](#block-caching)
        + [HDFS Federation](#hdfs-federation)
        + [HDFS High Availability](#hdfs-high-availability)
            * [Failover and fencing](#failover-and-fencing)
    - [The Command-Line Interface](#the-command-line-interface)
        + [File Permissions in HDFS](#file-permissions-in-hdfs)
    - [Hadoop Filesystems](#hadoop-filesystems)
    - [The Java Interface](#the-java-interface)
        + [Reading Data from a Hadoop URL](#reading-data-from-a-hadoop-url)
        + [Reading Data Using the FileSystem API](#reading-data-using-the-filesystem-api)
    - [Data Flow](#data-flow)
        + [Anatomy of a File Read](#anatomy-of-a-file-read)
        + [Network Topology and Hadoop](#network-topology-and-hadoop)
        + [Anatomy of a File Write](#anatomy-of-a-file-write)
            * [Replica Placement](#replica-placement)
        + [Coherency Model](#coherency-model)
    - [Parallel Copying with distcp](#parallel-copying-with-distcp)
* [4. YARN](#4-yarn)
    - [Anatomy of a YARN Application Run](#anatomy-of-a-yarn-application-run)
        + [Resource Requests](#resource-requests)
        + [Application Lifespan](#application-lifespan)
        + [Building YARN Applications](#building-yarn-applications)
    - [YARN Compared to MapReduce 1](#yarn-compared-to-mapreduce-1)
    - [Scheduling in YARN](#scheduling-in-yarn)
        + [Capacity Scheduler Configuration](#capacity-scheduler-configuration)
        + [Fair Scheduler Configuration](#fair-scheduler-configuration)
    - [Delay Scheduling](#delay-scheduling)
    - [Dominant Resource Fairness](#dominant-resource-fairness)
    - [YARN Further Reading](#yarn-further-reading)
* [5. Hadoop I/O](#5-hadoop-i/o)
    - [Data Integrity](#data-integrity)
        + [LocalFileSystem](#localfilesystem)
        + [ChecksumFileSystem](#checksumfilesystem)
    - [Compression](#compression)
        + [Codecs](#codecs)
        + [Native libraries](#native-libraries)
        + [Using Compression in MapReduce](#using-compression-in-mapreduce)
    - [Serialization](#serialization)
        + [The Writable Interface](#the-writable-interface)
        + [WritableComparable and comparators](#writablecomparable-and-comparators)
        + [Writable Classes](#writable-classes)
        + [Implementing a Custom Writable](#implementing-a-custom-writable)
            * [Implementing a RawComparator for speed](#implementing-a-rawcomparator-for-speed)
        + [Serialization Frameworks](#serialization-frameworks)
    - [File-Based Data Structures](#file-based-data-structures)
        + [SequenceFile](#sequencefile)
            * [Writing a SequenceFile](#writing-a-sequencefile)
            * [Reading a SequenceFile](#reading-a-sequencefile)
            * [Displaying a SequenceFile with the command-line interface](#displaying-a-sequencefile-with-the-command-line-interface)
            * [Sorting and merging SequenceFiles](#sorting-and-merging-sequencefiles)
            * [The SequenceFile format](#the-sequencefile-format)
        + [MapFile](#mapfile)
        + [Other File Formats and Column-Oriented Formats](#other-file-formats-and-column-oriented-formats)
* [6. Developing a MapReduce Application](#6-developing-a-mapreduce-application)
    - [The Configuration API](#the-configuration-api)
    - [Setting Up the Development Environment](#setting-up-the-development-environment)
        + [Managing Configuration](#managing-configuration)
            * [Setting User Identity](#setting-user-identity)
        + [GenericOptionsParser, Tool, and ToolRunner](#genericoptionsparser-tool-and-toolrunner)
    - [Writing a Unit Test with MRUnit](#writing-a-unit-test-with-mrunit)
    - [Running Locally on Test Data](#running-locally-on-test-data)
        + [Running a Job in a Local Job Runner](#running-a-job-in-a-local-job-runner)
        + [Testing the Driver](#testing-the-driver)
    - [Running on a Cluster](#running-on-a-cluster)
        + [Packaging a Job](#packaging-a-job)
        + [Launching a Job](#launching-a-job)
            * [Job, Task, and Task Attempt IDs](#job-task-and-task-attempt-ids)
        + [The MapReduce Web UI](#the-mapreduce-web-ui)
            * [Job History](#job-history)
        + [Retrieving the Results](#retrieving-the-results)
        + [Debugging a Job](#debugging-a-job)
        + [Hadoop Logs](#hadoop-logs)
        + [Remote Debugging](#remote-debugging)
    - [Tuning a Job](#tuning-a-job)
        + [Profiling Tasks](#profiling-tasks)
    - [MapReduce Workflows](#mapreduce-workflows)
        + [Decomposing a Problem into MapReduce Jobs](#decomposing-a-problem-into-mapreduce-jobs)
        + [JobControl](#jobcontrol)
            * [Defining an Oozie workflow](#defining-an-oozie-workflow)
            * [Packaging and deploying an Oozie workflow application](#packaging-and-deploying-an-oozie-workflow-application)
            * [Running an Oozie workflow job](#running-an-oozie-workflow-job)
* [7. How MapReduce Works](#7-how-mapreduce-works)
    - [Anatomy of a MapReduce Job Run](#anatomy-of-a-mapreduce-job-run)
        + [Job Submission](#job-submission)
        + [Job Initialization](#job-initialization)
        + [Task Assignment](#task-assignment)
        + [Task Execution](#task-execution-1)
        + [Streaming](#streaming)
        + [Progress and Status Updates](#progress-and-status-updates)
        + [Job Completion](#job-completion)
    - [Failures](#failures)
        + [Task Failure](#task-failure)
        + [Application Master Failure](#application-master-failure)
        + [Node Manager Failure](#node-manager-failure)
        + [Resource Manager Failure](#resource-manager-failure)
    - [Shuffle and Sort](#shuffle-and-sort)
        + [The Map Side](#the-map-side)
        + [The Reduce Side](#the-reduce-side)
        + [Configuration Tuning](#configuration-tuning)
    - [Task Execution](#task-execution)
        + [The Task Execution Environment](#the-task-execution-environment)
            * [Streaming environment variables](#streaming-environment-variables)
        + [Speculative Execution](#speculative-execution)
        + [Output Committers](#output-committers)
* [8. MapReduce Types and Formats](#8-mapreduce-types-and-formats)
    - [MapReduce Types](#mapreduce-types)
        + [The Default MapReduce Job](#the-default-mapreduce-job)
            * [The default Streaming job](#the-default-streaming-job)
            * [Keys and values in Streaming](#keys-and-values-in-streaming)
    - [Input Formats](#input-formats)
        + [Input Splits and Records](#input-splits-and-records)
            * [Preventing splitting](#preventing-splitting)
        + [Text Input](#text-input)
            * [TextInputFormat](#textinputformat)
            * [KeyValueTextInputFormat](#keyvaluetextinputformat)
            * [NLineInputFormat](#nlineinputformat)
            * [XML](#xml)
        + [Binary Input](#binary-input)
            * [SequenceFileInputFormat](#sequencefileinputformat)
            * [SequenceFileAsTextInputFormat](#sequencefileastextinputformat)
            * [SequenceFileAsBinaryInputFormat](#sequencefileasbinaryinputformat)
            * [FixedLengthInputFormat](#fixedlengthinputformat)
        + [Multiple Inputs](#multiple-inputs)
        + [Database Input (and Output)](#database-input-and-output)
    - [Output Formats](#output-formats)
        + [Text Output](#text-output)
        + [Binary Output](#binary-output)
            * [SequenceFileOutputFormat](#sequencefileoutputformat)
            * [SequenceFileAsBinaryOutputFormat](#sequencefileasbinaryoutputformat)
            * [MapFileOutputFormat](#mapfileoutputformat)
            * [Multiple Outputs](#multiple-outputs)
            * [Lazy Output](#lazy-output)
* [9. MapReduce Features](#9-mapreduce-features)
    - [Counters](#counters)
        + [Built-in Counters](#built-in-counters)
            * [Task counters](#task-counters)
            * [Job counters](#job-counters)
        + [User-Defined Java Counters](#user-defined-java-counters)
        + [User-Defined Streaming Counters](#user-defined-streaming-counters)
    - [Sorting](#sorting)
        + [Controlling Sort Order](#controlling-sort-order)
        + [Partial Sort](#partial-sort)
        + [Total Sort](#total-sort)
        + [Secondary Sort](#secondary-sort)
            * [Streaming Secondary Sort](#streaming-secondary-sort)
    - [Joins](#joins)
        + [Map-Side Joins](#map-side-joins)
        + [Reduce-Side Joins](#reduce-side-joins)
    - [Side Data Distribution](#side-data-distribution)
        + [Using the Job Configuration](#using-the-job-configuration)
        + [Distributed Cache](#distributed-cache)
            * [The distributed cache API](#the-distributed-cache-api)
    - [MapReduce Library Classes](#mapreduce-library-classes)
* [10. Setting Up a Hadoop Cluster](#10-setting-up-a-hadoop-cluster)
    - [Cluster Sizing](#cluster-sizing)
    - [Network Topology](#network-topology)
        + [Rack awareness](#rack-awareness)
    - [Cluster Setup and Installation](#cluster-setup-and-installation)
    - [Hadoop Configuration](#hadoop-configuration)
        + [Configuration Management](#configuration-management)
        + [Environment Settings](#environment-settings)
        + [Important Hadoop Daemon Properties](#important-hadoop-daemon-properties)
            * [Memory settings in YARN and MapReduce](#memory-settings-in-yarn-and-mapreduce)
            * [CPU settings in YARN and MapReduce](#cpu-settings-in-yarn-and-mapreduce)
        + [Hadoop Daemon Addresses and Ports](#hadoop-daemon-addresses-and-ports)
        + [Other Hadoop Properties](#other-hadoop-properties)
    - [Security](#security)
        + [Kerberos and Hadoop](#kerberos-and-hadoop)
        + [Delegation Tokens](#delegation-tokens)
        + [Other Security Enhancements](#other-security-enhancements)
    - [Hadoop Benchmarks](#hadoop-benchmarks)
        + [Benchmarking MapReduce with TeraSort](#benchmarking-mapreduce-with-terasort)
* [11. Administering Hadoop](#11-administering-hadoop)
    - [HDFS Persistent Data Structures](#hdfs-persistent-data-structures)
        + [Namenode directory structure](#namenode-directory-structure)
        + [Datanode directory structure](#datanode-directory-structure)
    - [HDFS Safe Mode](#hdfs-safe-mode)
    - [HDFS Audit Logging](#hdfs-audit-logging)
    - [HDFS Tools](#hdfs-tools)
    - [Monitoring](#monitoring)
        + [Logging](#logging)
            * [Setting log levels](#setting-log-levels)
            * [Getting stack traces](#getting-stack-traces)
        + [Metrics and JMX](#metrics-and-jmx)
    - [Maintenance](#maintenance)
        + [Routine Administration Procedures](#routine-administration-procedures)
            * [Metadata backups](#metadata-backups)
            * [Data backups](#data-backups)
    - [Commissioning and Decommissioning Nodes](#commissioning-and-decommissioning-nodes)
    - [Upgrades](#upgrades)
        + [HDFS data and metadata upgrades](#hdfs-data-and-metadata-upgrades)
        + [Compatibility](#compatibility)
* [14. Flume](#14-flume)
    - [Installing Flume](#installing-flume)
    - [An Flume Example](#an-flume-example)
    - [Transactions and Reliability](#transactions-and-reliability)
        + [Batching](#flume-batching)
    - [The HDFS Sink](#the-hdfs-sink)
        + [Partitioning and Interceptors](#partitioning-and-interceptors)
        + [HDFS Sink File Formats](#hdfs-sink-file-formats)
    - [Fan Out](#fan-out)
        + [Delivery Guarantees](#delivery-guarantees)
        + [Near-Real-Time Indexing](#near-real-time-indexing)
        + [Replicating and Multiplexing Selectors](#replicating-and-multiplexing-selectors)
    - [Distribution: Agent Tiers](#distribution-agent-tiers)
        + [Delivery Guarantees](#delivery-guarantees)
    - [Integrating Flume with Applications](#integrating-flume-with-applications)
* [15. Sqoop](#15-sqoop)
    - [Sqoop Connectors](#sqoop-connectors)
    - [Imports: A Deeper Look](#imports-a-deeper-look)
        + [Incremental Imports](#incremental-imports)
        + [Direct-Mode Imports](#direct-mode-imports)
    - [Working with Imported Data](#working-with-imported-data)
    - [Performing an Export](#performing-an-export)
    - [Exports: A Deeper Look](#exports-a-deeper-look)
        + [Exports and Transactionality](#exports-and-transactionality)
        + [Exports and SequenceFiles](#exports-and-sequencefiles)
* [17. Hive](#17-hive)
    - [Installing Hive](#installing-hive)
        + [The Hive Shell](#the-hive-shell)
    - [An Hive Example](#an-hive-example)
    - [Configuring Hive](#configuring-hive)
    - [Hive Services](#hive-services)
    - [Hive clients](#hive-clients)
    - [The Metastore](#the-hive-metastore)
    - [Comparison with Traditional Databases](#comparison-with-traditional-databases)
        + [Schema on Read Versus Schema on Write](#schema-on-read-versus-schema-on-write)
        + [Updates, Transactions, and Indexes](#updates-transactions-and-indexes)
        + [SQL-on-Hadoop Alternatives](#sql-on-hadoop-alternatives)
    - [Hive Tables](#hive-tables)
        + [Managed Tables and External Tables](#managed-tables-and-external-tables)
        + [Partitions and Buckets](#partitions-and-buckets)
        + [Storage Formats](#storage-formats)
            * [The default storage format: Delimited text](#the-default-storage-format-delimited-text)
            * [Binary storage formats: Sequence files, Avro datafiles, Parquet files, RCFiles, and ORCFiles](#binary-storage-formats-sequence-files-avro-datafiles-parquet-files-rcfiles-and-orcfiles)
            * [Storage handlers](#storage-handlers)
        + [Importing Data](#hive-importing-data)
        + [Altering Tables](#hive-altering-tables)
        + [Dropping Tables](#hive-dropping-tables)
    - [Querying Data](#hive-querying-data)
        + [Hive Sorting and Aggregating](#hive-sorting-and-aggregating)
        + [MapReduce Scripts](#mapreduce-scripts)
        + [Hive Joins](#hive-joins)
        + [Subqueries](#hive-subqueries)
        + [Views](#hive-views)
    - [Hive User-Defined Functions](#hive-user-defined-functions)
        + [Writing a UDF](#writing-a-udf)
        + [Writing a UDAF](#writing-a-udaf)
* [20. HBase](#20-hbase)
    - [Whirlwind Tour of the Data Model](#whirlwind-tour-of-the-data-model)
        + [Regions](#hbase-regions)
        + [Locking](#hbase-locking)
    - [HBase Implementation](#hbase-implementation)
    - [HBase Installation](#hbase-installation)
    - [HBase Clients](#hbase-clients)
        + [HBase Clients: Java](#hbase-clients-java)
        + [HBase Clients: MapReduce](#hbase-clients-mapreduce)
        + [HBase Clients: REST and Thrift](#hbase-clients-rest-and-thrift)
    - [Building an Online Query Application](#building-an-online-query-application)
        + [Load distribution](#load-distribution)
        + [Bulk load](#hbase-bulk-load)
        + [Online Queries](#hbase-online-queries)
    - [HBase Versus RDBMS](#hbase-versus-rdbms)
    - [HBase Praxis](#hbase-praxis)
* [Chapter 21. ZooKeeper](#chapter-21-zookeeper)
    - [Installing and Running ZooKeeper](#installing-and-running-zookeeper)
    - [The ZooKeeper Service](#the-zookeeper-service)
        + [Zookeeper Data Model](#zookeeper-data-model)
        + [Zookeeper operations](#zookeeper-operations)
        + [Zookeeper Implementation](#zookeeper-implementation)
        + [Zookeeper Consistency](#zookeeper-consistency)
        + [ZooKeeper Session](#zookeeper-session)
            * [ZooKeeper Time](#zookeeper-time)
        + [ZooKeeper States](#zookeeper-states)
    - [ZooKeeper State](#zookeeper-state)
        + [A Configuration Service](#a-configuration-service)
        + [The Resilient ZooKeeper Application](#the-resilient-zookeeper-application)
        + [A Lock Service](#a-lock-service)
    - [ZooKeeper in Production](#zookeeper-in-production)
        + [ZooKeeper Configuration](#zookeeper-configuration)
* [Miscellaneous](#miscellaneous)

## 0. Recommendations

This chapter has given a short overview of YARN. For more detail, see Apache Hadoop YARN by Arun C. Murthy et al. (Addison-Wesley, 2014).

Finally, the book **Data-Intensive Text Processing with MapReduce by Jimmy Lin and Chris Dyer (Morgan & Claypool Publishers, 2010)** is a great resource for learning more about MapReduce algorithm design and is highly recommended.

These chapters still offer valuable information about how Hadoop works from an operations point of view For more in-depth information, I highly recommend [Hadoop Operations] by Eric Sammer (O’Reilly, 2012).

There’s a lot to security in Hadoop, and this section only covers the highlights. For more, readers are referred to [Hadoop Security] by Ben Spivey and Joey Echeverria (O’Reilly, 2014).  

For more detail, see [Using Flume] by Hari Shreedharan (O’Reilly, 2014). There is also a lot of practical information about designing ingest pipelines (and building Hadoop applications in general) in [Hadoop Application Architectures] by Mark Grover, Ted Malaska, Jonathan Seidman, and Gwen Shapira (O’Reilly, 2014). 

For more information on using Sqoop, consult the [Apache Sqoop Cookbook] by Kathleen Ting and Jarek Jarcec Cecho (O’Reilly, 2013).  

For more information about Hive, see [Programming Hive] by Edward Capriolo, Dean Wampler, and Jason Rutherglen (O’Reilly, 2012).

In this chapter, we only scratched the surface of what’s possible with HBase. For more in-depth information, consult the project’s Reference Guide([Apache HBase ™ Reference Guide]), [HBase: The Definitive Guide] by Lars George (O’Reilly, 2011, new edition forthcoming), or [HBase in Action] by Nick Dimiduk and Amandeep Khurana (Manning, 2012).

The HBase project was started toward the end of 2006 by Chad Walters and Jim Kellerman at Powerset. It was modeled after Google’s Bigtable, which had just been published. Fay Chang et al., “Bigtable: A Distributed Storage System for Structured Data,” November 2006. [Bigtable: A Distributed Storage System for Structured Data,]  

However, this section is not exhaustive, so you should consult the [ZooKeeper Administrator’s Guide] for detailed, up-to-date instructions, including supported platforms, recommended hardware, maintenance procedures, dynamic reconfiguration (to change the servers in a running ensemble), and configuration properties.

For more in-depth information about ZooKeeper, see [ZooKeeper] by Flavio Junqueira and Benjamin Reed (O’Reilly, 2013).


### Useful URLs
* http://node-manager-host:8042/logs/userlogs  
* http://resource-manager-host:8088/  
    - http://resource-manager-host:8088/conf shows the configuration that the resource manager is running with.  
    - http://resource-manager-host:8088/logLevel and set the log name  
    - http://resource-manager-host:8088/stacks,  where you can get a thread dump for a resource manager  
* http://datanode:50075/blockScannerReport   
* http://namenode-host:50070/jmx , where you can view namenode metrics.


## 1. Meet Hadoop
The approach taken by MapReduce may seem like a brute-force approach. The premise is that the `entire dataset—or at least a good portion of it—`can be processed for each query. But this is its power. MapReduce is a batch query processor, and the ability to run an ad hoc query against your whole dataset and get the results in a reasonable time is transformative.

For all its strengths, MapReduce is fundamentally a batch processing system, and is not suitable for interactive analysis. You can’t run a query and get results back in a few seconds or less. 

**YARN** (which stands for Yet Another Resource Negotiator) in Hadoop 2. YARN is a cluster resource management system, which allows any distributed program (not just MapReduce) to run on data in a Hadoop cluster.

In the last few years, there has been a flowering of different processing patterns that work with Hadoop. Here is a sample:  
* Interactive SQL  
By dispensing with MapReduce and using a `distributed query engine` that uses dedicated “always on” daemons (like **Impala**) or `container reuse` (like **Hive on Tez**), it’s possible to achieve low-latency responses for SQL queries on Hadoop while still scaling up to large dataset sizes.  
* Iterative processing  
Many algorithms—such as those in machine learning—are iterative in nature, so it’s much more efficient to hold each intermediate working set in memory, compared to loading from disk on each iteration. The architecture of MapReduce does not allow this, but it’s straightforward with **Spark**, for example, and it enables a highly exploratory style of working with datasets.  
* Stream processing  
Streaming systems like **Storm**, **Spark Streaming**, or **Samza** make it possible to run real-time, distributed computations on unbounded streams of data and emit results to Hadoop storage or external systems.  
* Search  
The **Solr** search platform can run on a Hadoop cluster, indexing documents as they are added to HDFS, and serving search queries from indexes stored in HDFS.

### Comparison with Other Systems

#### Relational Database Management Systems
The answer to these questions comes from another trend in disk drives: `seek time is improving more slowly than transfer rate`. Seeking is the process of moving the disk’s head to a particular place on the disk to read or write data. It characterizes the latency of a disk operation, whereas the transfer rate corresponds to a disk’s bandwidth.  

If the data access pattern is dominated by seeks, it will take longer to read or write large portions of the dataset than streaming through it, which operates at the transfer rate. On the other hand, for updating a small proportion of records in a database, a traditional B-Tree (the data structure used in relational databases, which is limited by the rate at which it can perform seeks) works well. For updating the majority of a database, a BTree is less efficient than MapReduce, which uses Sort/Merge to rebuild the database.

MapReduce is a good fit for problems that need to analyze the whole dataset in a batch fashion, particularly for ad hoc analysis. An RDBMS is good for point queries or updates, where the dataset has been indexed to deliver low-latency retrieval and update times of a relatively small amount of data.

**Table 1-1. RDBMS compared to MapReduce**  

Factors             |Traditional RDBMS      |MapReduce
--------------------|-----------------------|----------------------------------
Data size           |Gigabytes              |Petabytes
Access              |Interactive and batch  |Batch
Updates             |Read and write many times |Write once, read many times
Transactions        |ACID                   |None
Structure           |Schema-on-write        |Schema-on-read
Integrity           |High                   |Low
Scaling             |Nonlinear              |Linear

Hadoop works well on unstructured or semi-structured data because it is designed to interpret the data at processing time (`so called schema-on-read`). This provides flexibility and avoids the costly data loading phase of an RDBMS, since in Hadoop it is just a file copy.

Relational data is often normalized to retain its integrity and remove redundancy. Normalization poses problems for Hadoop processing because it makes reading a record a nonlocal operation, and one of the central assumptions that Hadoop makes is that it is possible to perform (high-speed) streaming reads and writes.

#### Grid Computing
The high-performance computing (HPC) and grid computing communities have been doing large-scale data processing for years, using such application program interfaces (APIs) as the **Message Passing Interface (MPI)**. Broadly, the approach in HPC is to distribute the work across a cluster of machines, `which access a shared filesystem, hosted by a storage area network (SAN)`. `This works well for predominantly compute-intensive jobs`, but `it becomes a problem when nodes need to access larger data volumes (hundreds of gigabytes, the point at which Hadoop really starts to shine), since the network bandwidth is the bottleneck and compute nodes become idle`.

Hadoop tries to co-locate the data with the compute nodes, so data access is fast because it is local. This feature, known as **data locality**, is at the heart of data processing in Hadoop and is the reason for its good performance. Recognizing that network bandwidth is the most precious resource in a data center environment (it is easy to saturate network links by copying data around), Hadoop goes to great lengths to conserve it by explicitly modeling network topology. Notice that this arrangement does not preclude high-CPU analyses in Hadoop.

**MPI** gives great control to programmers, `but it requires that they explicitly handle the mechanics of the data flow, exposed via low-level C routines and constructs such as sockets, as well as the higher-level algorithms for the analyses`. Processing in Hadoop operates only at the higher level: the programmer thinks in terms of the data model (such as key-value pairs for MapReduce), while the data flow remains implicit.

Distributed processing frameworks like MapReduce spare the programmer from having to think about failure, since the implementation detects failed tasks and reschedules replacements on machines that are healthy. MapReduce is able to do this because it is a **shared-nothing architecture**, meaning that tasks have no dependence on one other. (This is a slight oversimplification, since the output from mappers is fed to the reducers, but this is under the control of the MapReduce system; in this case, `it needs to take more care rerunning a failed reducer than rerunning a failed map, because it has to make sure it can retrieve the necessary map outputs and, if not, regenerate them by running the relevant maps again`.) So from the programmer’s point of view, the order in which the tasks run doesn’t matter. By contrast, MPI programs have to explicitly manage their own checkpointing and recovery, which gives more control to the programmer but makes them more difficult to write.

#### Volunteer Computing
SETI, the Search for Extra-Terrestrial Intelligence, runs a project called SETI@home in which volunteers donate CPU time from their otherwise idle computers to analyze radio telescope data for signs of intelligent life outside Earth.

The SETI@home problem is very CPU-intensive, which makes it suitable for running on hundreds of thousands of computers across the world because the time to transfer the work unit is dwarfed by the time to run the computation on it.  

MapReduce is designed to run jobs that last minutes or hours on trusted, dedicated hardware running in a single data center with very high aggregate bandwidth interconnects.

## 2. MapReduce
MapReduce is a programming model for data processing.

### Data Flow  
1. Hadoop divides the input to a MapReduce job into `fixed-size pieces` called input splits, or just **splits**. Hadoop creates `one map task for each split`, which runs the user-defined map function for each record in the split.   
2. Map tasks write their output to the `local disk`, not to HDFS.  
3. Reduce tasks don’t have the advantage of data locality; the input to a single reduce task is normally the output from all mappers. 
    1. In the present example, we have a single reduce task that is fed by all of the map tasks. Therefore, the `sorted map outputs` have to be transferred across the network to the node where the reduce task is running, where they are `merged` and then passed to the user-defined reduce function.   
    2. When there are multiple reducers, the map tasks `partition` their output, each creating one partition for each reduce task. There can be many keys (and their associated values) in each partition, but `the records for any given key are all in a single partition`. The partitioning can be controlled by a user-defined partitioning function, but normally the default partitioner—which buckets keys using a hash function—works very well.  
4. The output of the reduce is normally `stored in HDFS` for reliability. As explained in Chapter 3, for each HDFS block of the reduce output, the first replica is stored on the local node, with other replicas being stored on off-rack nodes for reliability. 


Having many splits means the time taken to process each split is small compared to the time to process the whole input. So if we are processing the splits in parallel, the processing is better `load balanced` when the splits are small, since a faster machine will be able to process proportionally more splits over the course of the job than a slower machine.

On the other hand, if splits are too small, the overhead of managing the splits and map task creation begins to dominate the total job execution time. For most jobs, `a good split size tends to be the size of an HDFS block, which is 128 MB by default`, although this can be changed for the cluster (for all newly created files) or specified when each file is created.

Hadoop does its best to run the map task on a node where the input data resides in HDFS, because it doesn’t use valuable cluster bandwidth. This is called the **data locality optimization**. Sometimes, however, all the nodes hosting the HDFS block replicas for a map task’s input split are running other map tasks, so the job scheduler will look for a free map slot on a node in the same **rack** as one of the blocks. Very occasionally even this is not possible, so an off-rack node is used, which results in an inter-rack network transfer. The three possibilities are illustrated in Figure 2-2.
![hadoop_data_locality_img_1]  

Map tasks write their output to the local disk, not to HDFS. Why is this? `Map output is intermediate output`: it’s processed by reduce tasks to produce the final output, and `once the job is complete, the map output can be thrown away. So, storing it in HDFS with replication would be overkill`. If the node running the map task fails before the map output has been consumed by the reduce task, then Hadoop will automatically `rerun the map task on another node` to re-create the map output.(PS: if the map output is not designed to endure node failure, why not maintain it in memory at all?)

The data flow for the general case of multiple reduce tasks is illustrated in Figure 2-4. This diagram makes it clear why the data flow between map and reduce tasks is colloquially known as “the shuffle,” as each reduce task is fed by many map tasks. `The shuffle` is more complicated than this diagram suggests, and tuning it can have a big impact on job execution time  
![hadoop_data_flow_img_1]  

Finally, it’s also possible to have zero reduce tasks. This can be appropriate when you don’t need the shuffle because the processing can be carried out entirely in parallel (a few examples are discussed in “NLineInputFormat” on page 234). In this case, the only off-node data transfer is when the map tasks write to HDFS (see Figure 2-5).  

### Combiner Functions
Many MapReduce jobs are limited by the bandwidth available on the cluster, so it pays to minimize the data transferred between map and reduce tasks.

Hadoop allows the user to specify a combiner function to be `run on the map output`, and the combiner function’s output forms `the input to the reduce function`. Because the combiner function is an optimization, Hadoop does not provide a guarantee of how many times it will call it for a particular map output record, if at all. In other words, calling the combiner function zero, one, or many times should produce the same output from the reducer.  

it can help cut down the amount of data shuffled between the mappers and the reducers

### Hadoop Streaming
Hadoop Streaming uses Unix standard streams as the interface between Hadoop and your program, so you can use `any language` that can read standard input and write to standard output to write your MapReduce program.

Streaming is naturally suited for text processing. Map input data is passed over standard input to your map function, which processes it line by line and writes lines to standard output. A map output key-value pair is written as a `single tab-delimited line`. Input to the reduce function is in the same format—a tab-separated key-value pair—passed over standard input. The reduce function reads `lines from standard input, which the framework guarantees are sorted by key`, and writes its results to standard output.

It’s worth drawing out a design difference between Streaming and the Java MapReduce API. The Java API is geared toward processing your map function `one record at a time`. The framework calls the map() method on your Mapper for each record in the input, whereas with Streaming the map program can decide how to process the input— for example, it could easily read and process multiple lines at a time since it’s in control of the reading. `The user’s Java map implementation is “pushed” records, but it’s still possible to consider multiple lines at a time by accumulating previous lines in an instance variable in the Mapper`. In this case, you need to implement the cleanup() method so that you know when the last record has been read, so you can finish processing the last group of lines.  
Alternatively, you could use “pull”-style processing in the new MapReduce API  

As for Reducer, in contrast to the Java API, where you are provided an iterator over each key group, in Streaming you have to find key group boundaries in your program.  

## 3. The Hadoop Distributed Filesystem
Hadoop comes with a distributed filesystem called HDFS, which stands for Hadoop Distributed Filesystem. (You may sometimes see references to “DFS”—informally or in older documentation or configurations—which is the same thing.) HDFS is Hadoop’s flagship filesystem and is the focus of this chapter, but Hadoop actually has a general purpose filesystem abstraction, so we’ll see along the way how Hadoop integrates with other storage systems (such as the local filesystem and Amazon S3).

### The Design of HDFS
HDFS is a filesystem designed for storing very large files with streaming data access patterns, running on clusters of commodity hardware

* Very large files  
“Very large” in this context means files that are hundreds of megabytes, gigabytes, or terabytes in size. There are Hadoop clusters running today that store petabytes of data.  
* Streaming data access  
HDFS is built around the idea that the most efficient data processing pattern is a write-once, read-many-times pattern. A dataset is typically generated or copied from source, and then various analyses are performed on that dataset over time. Each analysis will involve a large proportion, if not all, of the dataset, so the time to read the whole dataset is more important than the latency in reading the first record.  
* Commodity hardware  
Hadoop doesn’t require expensive, highly reliable hardware. It’s designed to run on clusters of commodity hardware (commonly available hardware that can be obtained from multiple vendors) `for which the chance of node failure across the cluster is high, at least for large clusters`. HDFS is designed to carry on working without a noticeable interruption to the user in the face of such failure.  
Hadoop is designed to run on commodity hardware. That means that you are not tied to expensive, proprietary offerings from a single vendor; rather, you can choose standardized, commonly available hardware from any of a large range of vendors to build your cluster.  
Hardware specifications rapidly become obsolete, but for the sake of illustration, a typical choice of machine for running an HDFS datanode and a YARN node manager in 2014 would have had the following specifications:  

Hardware        |Detail
----------------|--------------------------------------------------------------
Processor       |Two hex/octo-core 3 GHz CPUs
Memory          |64−512 GB ECC RAM1
Storage         |12−24 × 1−4 TB SATA disks
Network         |Gigabit Ethernet with link aggregation

ECC memory is strongly recommended, as several Hadoop users have reported seeing many checksum errors when using non-ECC memory on Hadoop clusters.  

HDFS clusters do not benefit from using RAID (redundant array of independent disks) for datanode storage (although RAID is recommended for the namenode’s disks, to protect against corruption of its metadata). The redundancy that RAID provides is not needed, since HDFS handles it by replication between nodes.

It is also worth examining the applications for which using HDFS does not work so well. Although this may change in the future, these are areas where HDFS is not a good fit today:  
* Low-latency data access  
Applications that require low-latency access to data, in the tens of milliseconds range, will not work well with HDFS. Remember, HDFS is optimized for delivering a high throughput of data, and this may be at the expense of latency. `HBase (see Chapter 20) is currently a better choice for low-latency access`.  
* Lots of small files  
Because the namenode holds filesystem metadata in memory, the limit to the number of files in a filesystem is governed by the amount of memory on the namenode. `As a rule of thumb, each file, directory, and block takes about 150 bytes`. So, for example, if you had one million files, each taking one block, you would need at least 300 MB of memory. Although storing millions of files is feasible, billions is beyond the capability of current hardware.  
* Multiple writers, arbitrary file modifications  
Files in HDFS may be written to by `a single writer`. Writes are always made at the end of the file, `in append-only fashion`. There is no support for multiple writers or for modifications at arbitrary offsets in the file. (These might be supported in the future, but they are likely to be relatively inefficient.)

### HDFS Concepts
#### Blocks
HDFS, too, has the concept of a block, but it is a much larger unit—128 MB by default. Unlike a filesystem for a single disk, a file in HDFS that is smaller than a single block does not occupy a full block’s worth of underlying storage.

`HDFS blocks are large compared to disk blocks, and the reason is to minimize the cost of seeks`. If the block is large enough, the time it takes to transfer the data from the disk can be significantly longer than the time to seek to the start of the block. Thus, transferring a large file made of multiple blocks operates at the disk transfer rate.

A quick calculation shows that if the seek time is around 10 ms and the transfer rate is 100 MB/s, `to make the seek time 1% of the transfer time`, we need to make the block size around 100 MB. The default is actually 128 MB, although many HDFS installations use larger block sizes. `This figure will continue to be revised upward as transfer speeds grow with new generations of disk drives`.

This argument shouldn’t be taken too far, however. `Map tasks in MapReduce normally operate on one block at a time`, so if you have too few tasks (fewer than nodes in the cluster), your jobs will run slower than they could otherwise.


#### Namenodes and Datanodes
An HDFS cluster has two types of nodes operating in a master−worker pattern: a namenode (the master) and a number of datanodes (workers)
```hadoop
hdfs fsck / -files -blocks
```
The namenode manages the filesystem namespace. It maintains the filesystem tree and the metadata for all the files and directories in the tree. This information is stored persistently on the local disk in the form of two files: `the namespace image and the edit log`. The namenode also knows the datanodes on which all the blocks for a given file are located; however, `it does not store block locations persistently, because this information is reconstructed from datanodes when the system starts`.

Datanodes are the workhorses of the filesystem. They store and retrieve blocks when they are told to (by clients or the namenode), and `they report back to the namenode periodically with lists of blocks that they are storing`.

Without the namenode, the filesystem cannot be used. In fact, if the machine running the namenode were obliterated(destroyed), all the files on the filesystem would be lost since there would be no way of knowing how to reconstruct the files from the blocks on the datanodes. For this reason, it is important to make the namenode resilient to failure, and Hadoop provides two mechanisms for this. 
1. The first way is to back up the files that make up the persistent state of the filesystem metadata.  
Hadoop can be configured so that the namenode writes its persistent state to multiple filesystems. `These writes are synchronous and atomic`. The usual configuration choice is to write to local disk as well as a remote NFS mount.  
2. It is also possible to run a secondary namenode, which despite its name does not act as a namenode.  
`Its main role is to periodically merge the namespace image with the edit log` to prevent the edit log from becoming too large. The secondary namenode usually runs on a separate physical machine because `it requires plenty of CPU and as much memory as the namenode to perform the merge`. `It keeps a copy of the merged namespace image`, which can be used in the event of the namenode failing. However, the state of the secondary namenode lags that of the primary, so in the event of total failure of the primary, data loss is almost certain. The usual course of action in this case is to copy the namenode’s metadata files that are on NFS to the secondary and run it as the new primary. 
3. Note that `it is possible to run a hot standby namenode` instead of a secondary, as discussed in “HDFS High Availability” on page 48.  

#### Block Caching 
Normally a datanode reads blocks from disk, but for frequently accessed files the blocks may be `explicitly` cached `in the datanode’s memory`, `in an off-heap block cache`. By default, a block is cached in only one datanode’s memory, although the number is configurable on a per-file basis. `Job schedulers (for MapReduce, Spark, and other frameworks) can take advantage of cached blocks by running tasks on the datanode where a block is cached, for increased read performance`.    

Users or applications `instruct the namenode` which files to cache (and for how long) by adding a cache directive to a **cache pool**. `Cache pool`s are an administrative grouping for managing cache permissions and resource usage.

#### HDFS Federation
`Under federation, each namenode manages a `**namespace volume**`, which is made up of the metadata for the namespace, and a block pool containing all the blocks for the files in the namespace`. `Namespace volumes are independent of each other`, which means namenodes do not communicate with one another, and furthermore the failure of one namenode does not affect the availability of the namespaces managed by other namenodes.` Block pool storage is not partitioned`, however, so datanodes register with each namenode in the cluster and store blocks from multiple block pools.

#### HDFS High Availability
The combination of replicating namenode metadata on multiple filesystems and using the secondary namenode to create checkpoints protects against data loss, but it does not provide high availability of the filesystem. The namenode is still a single point of failure (SPOF).

To recover from a failed namenode in this situation, an administrator starts a new primary namenode with one of the filesystem metadata replicas and configures datanodes and clients to use this new namenode. The new namenode is not able to serve requests until it has  
1. loaded its namespace image into memory
2. replayed its edit log
3. received enough block reports from the datanodes to leave safe mode.   

On large clusters with many files and blocks, the time it takes for a namenode to start from cold can be `30 minutes or more`.

Hadoop 2 remedied this situation by adding support for HDFS high availability (HA). In this implementation, there are `a pair of namenodes in an active-standby configuration`. In the event of the failure of the active namenode, the standby takes over its duties to continue servicing client requests without a significant interruption. A few architectural changes are needed to allow this to happen:  
* The namenodes must use `highly available shared storage to share the edit log`. When a standby namenode comes up, it reads up to the end of the shared edit log to synchronize its state with the active namenode, and then `continues to read new entries` as they are `written by the active namenode`. 
* Datanodes must `send block reports to both namenodes` because the `block mappings are stored in a namenode’s memory, and not on disk`. 
* Clients must be configured to handle namenode failover, using a mechanism that is transparent to users. 
* The secondary namenode’s role is subsumed by the standby, which takes periodic checkpoints of the active namenode’s namespace. 

There are two choices for the highly available shared storage: an NFS filer, or a **quorum journal manager (QJM)**. The QJM is a dedicated HDFS implementation, designed for the `sole purpose of providing a highly available edit log`, and is the recommended choice for most HDFS installations. The QJM runs as `a group of journal nodes, and each edit must be written to a majority of the journal nodes`.

If the active namenode fails, the standby can take over very quickly (`in a few tens of seconds`) because it has the latest state available in memory: both the latest edit log entries and an up-to-date block mapping. `The actual observed failover time` will be longer in practice (`around a minute or so`), because the system needs to be conservative in deciding that the active namenode has failed.

##### Failover and fencing
The transition from the active namenode to the standby is managed by a new entity in the system called the **failover controller**.

Failover may also be initiated manually by an administrator, for example, in the case of routine maintenance. This is known as a graceful failover, since the failover controller arranges an orderly transition for both namenodes to switch roles.

In the case of an ungraceful failover, however, it is impossible to be sure that the failed namenode has stopped running. For example, a slow network or a network partition can trigger a failover transition, even though the previously active namenode is still running and thinks it is still the active namenode. The HA implementation goes to great lengths to `ensure that the previously active namenode is prevented from doing any damage and causing corruption`—a method known as **fencing**.

The QJM only allows one namenode to write to the edit log at one time;

### The Command-Line Interface
```html
The general command line syntax is
bin/hadoop command [genericOptions] [commandOptions]

Generic options supported are
-conf <configuration file>     specify an application configuration file
-D <property=value>            use value for given property
-fs <local|namenode:port>      specify a namenode
-jt <local|resourcemanager:port>    specify a ResourceManager
-files <comma separated list of files>    specify comma separated files to be copied to the map reduce cluster
-libjars <comma separated list of jars>    specify comma separated jar files to include in the classpath.
-archives <comma separated list of archives>    specify comma separated archives to be unarchived on the compute machines 
```

```shell
$ hadoop fs -help
$ hadoop fs -copyFromLocal input/docs/quangle.txt /user/tom/quangle.txt
$ hadoop fs -ls /input
Found 2 items
-rw-r--r--   2 hadoop supergroup         24 2017-10-17 21:32 /input/test.txt
drwxr-xr-x   - hadoop supergroup          0 2017-10-26 11:29 /input/test1
```
The first column shows the file mode. The second column is the replication factor of the file. The entry in this column is empty for directories because `the concept of replication does not apply to them—directories are treated as metadata and stored by the namenode, not the datanodes`. The third and fourth columns show the file owner and group. The fifth column is the size of the file in bytes, or `zero for directories`. The sixth and seventh columns are the last modified date and time. Finally, the eighth column is the name of the file or directory.

#### File Permissions in HDFS
HDFS has a permissions model for files and directories that is much like the POSIX model. There are three types of permission: the read permission (r), the write permission (w), and the execute permission (x). The read permission is required to read files or list the contents of a directory. The write permission is required to write a file or, for a directory, to create or delete files or directories in it. The execute permission is ignored for a file because you can’t execute a file on HDFS (unlike POSIX), and for a directory this permission is required to access its children.

Each file and directory has an owner, a group, and a mode. The mode is made up of the permissions for the user who is the owner, the permissions for the users who are members of the group, and the permissions for users who are neither the owners nor members of the group.  

`By default, Hadoop runs with security disabled`, which means that a client’s identity is not authenticated. Because clients are remote, it is possible for a client to become an arbitrary user simply by creating an account of that name on the remote system. This is not possible if security is turned on. Either way, it is worthwhile `having permissions enabled` (as they are by default; see the `dfs.permissions.enabled` property) to avoid accidental modification or deletion of substantial parts of the filesystem, either by users or by automated tools or programs.

When permissions checking is enabled, the owner permissions are checked if the client’s username matches the owner, and the group permissions are checked if the client is a member of the group; otherwise, the other permissions are checked.

`There is a concept of a superuser, which is the identity of the namenode process. Permissions checks are not performed for the superuser`.

### Hadoop Filesystems
Hadoop has an abstract notion of filesystems, of which HDFS is just one implementation.  

The Java abstract class `org.apache.hadoop.fs.FileSystem` represents the client interface to a filesystem in Hadoop, and there are several concrete implementations

The main ones that ship with Hadoop are described in Table 3-1.  
**Table 3-1. Hadoop filesystems**  

Filesystem      |URI scheme |Java implementation    |Description
----------------|-----------|-----------------------|--------------------------
Local           |file       |LocalFileSystem        |A filesystem for a locally connected disk with client-side checksums. Use RawLocalFileSystem for a local filesystem with no checksums.   
HDFS            |hdfs       |DistributedFileSystem  |Hadoop’s distributed filesystem. HDFS is designed to work efficiently in conjunction with MapReduce 
WebHDFS         |webhdfs    |WebHdfsFileSystem      |A filesystem providing authenticated read/write access to HDFS over HTTP.  
Secure WebHDFS  |swebhdfs   |SWebHdfsFileSystem     |The HTTPS version of WebHDFS
HAR             |har        |HarFileSystem          |A filesystem layered on another filesystem for archiving files. Hadoop Archives are used for packing lots of files in HDFS into a single archive file to reduce the namenode’s memory usage. Use the hadoop archive command to create HAR files.
View            |viewfs     |ViewFileSystem         |A client-side mount table for other Hadoop filesystems. Commonly used to create mount points for federated namenodes
FTP             |ftp        |FTPFileSystem          |A filesystem backed by an FTP server.
S3              |s3a        |S3AFileSystem          |A filesystem backed by Amazon S3. Replaces the older s3n (S3 native) implementation.
Azure           |wasb       |NativeAzureFileSystem  |A filesystem backed by Microsoft Azure.
Swift           |swift      |SwiftNativeFileSystem  |A filesystem backed by OpenStack Swift.

Hadoop provides many interfaces to its filesystems, and it generally uses the `URI scheme` to pick the correct filesystem instance to communicate with.   
For example, the filesystem shell that we met in the previous section operates with all Hadoop filesystems(for example, hadoop fs -ls /input). To list the files in the root directory of the local filesystem, type:   
```shell
$ hadoop fs -ls file:///
```

**Interfaces**:  
1. HTTP  
By exposing its filesystem interface as a Java API, Hadoop makes it awkward for non-Java applications to access HDFS. The `HTTP REST API` exposed by the WebHDFS protocol makes it easier for other languages to interact with HDFS. `Note that the HTTP interface is slower than the native Java client, so should be avoided for very large data transfers if possible`.  
There are two ways of accessing HDFS over HTTP: `directly`, where the HDFS daemons serve HTTP requests to clients; and `via a proxy` (or proxies), which accesses HDFS on the client’s behalf using the usual DistributedFileSystem API.  
It’s common to use a proxy for transfers between Hadoop clusters located in different data centers, or when accessing a Hadoop cluster running in the cloud from an external network.  
2. C  
libhdfs and libwebhdfs
3. NFS  
It is possible to mount HDFS on a local client’s filesystem using Hadoop’s NFSv3 gateway.
4. FUSE  
Filesystem in Userspace (FUSE) allows filesystems that are implemented in user space to be integrated as Unix filesystems. At the time of writing, the Hadoop NFS gateway is the more robust solution to mounting HDFS, so should be preferred over Fuse-DFS.  

### The Java Interface
Hadoop **FileSystem** class: the API for interacting with one of Hadoop’s filesystems.  
In Hadoop 2 and later, there is a new filesystem interface called **FileContext** with better handling of multiple filesystems (so a single FileContext can resolve multiple filesystem schemes, for example) and a cleaner, more consistent interface. FileSystem is still more widely used, however.  

#### Reading Data from a Hadoop URL

```java
static {
    URL.setURLStreamHandlerFactory(new FsUrlStreamHandlerFactory());
}

public static void main(String[] args) throws Exception {
    InputStream in = null;
    try {
        in = new URL("hdfs://host/path").openStream();
        // process in ...
        // for example
        IOUtils.copyBytes(in, System.out, 4096, false);
    } finally {
        IOUtils.closeStream(in);
    }
}
```

#### Reading Data Using the FileSystem API
A file in a Hadoop filesystem is represented by a `Hadoop Path object` (and not a java.io.File object, since its semantics are too closely tied to the local filesystem). You can think of a Path as a Hadoop filesystem URI, such as hdfs://localhost/user/ tom/quangle.txt.

```java
// To execute: hadoop FileSystemCat hdfs://localhost/user/tom/quangle.txt
public class FileSystemCat {
    public static void main(String[] args) throws Exception {
        String uri = args[0];
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(uri), conf);
        InputStream in = null;
        try {
            in = fs.open(new Path(uri));
            IOUtils.copyBytes(in, System.out, 4096, false);
            in.seek(0); // go back to the start of the file
            IOUtils.copyBytes(in, System.out, 4096, false);
        } finally {
            IOUtils.closeStream(in);
        }
    }
}
```

The open() method on FileSystem actually returns an **FSDataInputStream** rather than a standard java.io class. This class is a specialization of java.io.DataInputStream with support for `random access`, so you can read from any part of the stream. It implements Seekable and PositionedReadable interface.  
```java
public interface Seekable {
    void seek(long pos) throws IOException;
    long getPos() throws IOException;
}
/**
* All of these methods preserve the current offset in the file and are thread safe
* The read() method reads up to length bytes from the given position in the 
* file into the buffer at the given offset in the buffer. The return value is 
* the number of bytes actually read.
*/
public interface PositionedReadable {
    public int read(long position, byte[] buffer, int offset, int length)
    throws IOException;
    public void readFully(long position, byte[] buffer, int offset, int length)
    throws IOException;
    public void readFully(long position, byte[] buffer) throws IOException;
}
```
FSDataInputStream is `not designed for concurrent access`; therefore, it’s better to create multiple instances.  
Finally, bear in mind that `calling seek() is a relatively expensive operation` and should be done sparingly.

#### Writing Data

```java
// FileSystem
public FSDataOutputStream create(Path f) throws IOException;
public FSDataOutputStream append(Path f) throws IOException;
/** 
* There’s also an overloaded method for passing a callback interface, 
* Progressable, so your application can be notified of the progress of the 
* data being written to the datanodes
*/
public interface Progressable {
    public void progress();
}

OutputStream out = fs.create(new Path(dst), new Progressable() {
    public void progress() {
        System.out.print(".");
    }
});
```

The create() method on FileSystem returns an FSDataOutputStream, which, like **FSDataInputStream**, has a method for querying the current position in the file. FSDataOutputStream does not permit seeking. This is because HDFS allows only sequential writes to an open file or appends to an already written file. 

The **FileStatus** class encapsulates filesystem metadata for files and directories, including file length, block size, replication, modification time, ownership, and permission information. The method getFileStatus() on FileSystem provides a way of getting a FileStatus object for a single file or directory.  

**File glob**  
It is a common requirement to process sets of files in a single operation. For example, a MapReduce job for log processing might analyze a month’s worth of files contained in a number of directories. Rather than having to enumerate each file and directory to specify the input, it is convenient to `use wildcard characters to match multiple files` with a single expression, an operation that is known as **globbing**.   
Hadoop provides two FileSystem methods for processing globs:  
```java
public FileStatus[] globStatus(Path pathPattern) throws IOException 
public FileStatus[] globStatus(Path pathPattern, PathFilter filter) throws IOException
```

```java
fs.globStatus(new Path("/2007/*/*"), new RegexExcludeFilter("^.*/2007/12/31$"));

public boolean delete(Path f, boolean recursive) throws IOException;
```

### Data Flow
#### Anatomy of a File Read
![hadoop_data_flow_img_2]  

The client opens the file it wishes to read by calling open() on the FileSystem object, which for HDFS is an instance of DistributedFileSystem (step 1 in Figure 3-2). DistributedFileSystem calls the namenode, `using remote procedure calls (RPCs)`, to determine the locations of the first few blocks in the file (step 2). For each block, the namenode returns the addresses of the datanodes that have a copy of that block. Furthermore, `the datanodes are sorted according to their proximity to the client` (according to the topology of the cluster’s network; see “Network Topology and Hadoop” on page 70). If the client is itself a datanode (in the case of a MapReduce task, for instance), the client will read from the local datanode if that datanode hosts a copy of the block (see also Figure 2-2 and “Short-circuit local reads” on page 308).

The DistributedFileSystem returns an FSDataInputStream (an input stream that supports file seeks) to the client for it to read data from. FSDataInputStream in turn wraps a **DFSInputStream**, which manages the datanode and namenode I/O.

When the end of the block is reached, DFSInputStream will close the connection to the datanode, then find the best datanode for the next block (step 5)

Blocks are read in order, with the DFSInputStream opening new connections to datanodes as the client reads through the stream. `It will also call the namenode to retrieve the datanode locations for the next batch of blocks as needed`

During reading, if the DFSInputStream encounters an error while communicating with a datanode, it will try the next closest one for that block. It will also remember datanodes that have failed so that it doesn’t needlessly retry them for later blocks. The DFSInputStream also `verifies checksums for the data` transferred to it from the datanode. `If a corrupted block is found, the DFSInputStream attempts to read a replica of the block from another datanode`; it also `reports the corrupted block to the namenode`.

#### Network Topology and Hadoop
What does it mean for two nodes in a local network to be “close” to each other? The idea is to `use the bandwidth between two nodes as a measure of distance`.

Rather than measuring bandwidth between nodes, which can be difficult to do in practice (`it requires a quiet cluster`, and the number of pairs of nodes in a cluster grows as the square of the number of nodes), Hadoop takes a simple approach in which the network is represented as a tree and the distance between two nodes is the sum of their distances to their closest common ancestor. Levels in the tree are not predefined, but it is common to have levels that correspond to the **data center**, the **rack**, and `the node that a process is running on`.  
The idea is that the bandwidth available for each of the following scenarios becomes progressively(gradually) less:  
* Processes on the same node
* Different nodes on the same rack
* Nodes on different racks in the same data center
* Nodes in different data centers  
At the time of this writing, Hadoop is not suited for running across data centers.

Finally, it is important to realize that Hadoop cannot magically discover your network topology for you. By default, though, it assumes that the network is flat—a single level hierarchy—or in other words, that all nodes are on a single rack in a single data center.

#### Anatomy of a File Write
![hadoop_data_flow_img_3]  

The DistributedFileSystem returns an FSDataOutputStream for the client to start writing data to. Just as in the read case, FSDataOutputStream wraps a DFSOutputStream, which handles communication with the datanodes and namenode.

As the client writes data (step 3), the **DFSOutputStream** `splits it into packets`, which it writes to an internal queue called the **data queue**. The data queue is consumed by the **DataStreamer**, which is responsible for asking the namenode to allocate new blocks by picking a list of suitable datanodes to store the replicas. The list of datanodes forms a pipeline, and here we’ll assume the replication level is three, so there are three nodes in the pipeline. The DataStreamer streams the packets to the first datanode in the pipeline, which stores each packet and forwards it to the second datanode in the pipeline. Similarly, the second datanode stores the packet and forwards it to the third (and last) datanode in the pipeline (step 4).  
The **DFSOutputStream** also maintains an internal queue of packets that are waiting to be acknowledged by datanodes, called the **ack queue**. A packet is removed from the ack queue only when it has been acknowledged by all the datanodes in the pipeline (step 5).  
`If any datanode fails while data is being written to it`, then the following actions are taken, which are transparent to the client writing the data. First, the pipeline is closed, and `any packets in the ack queue are added to the front of the data queue` so that datanodes that are downstream from the failed node will not miss any packets. `The current block on the good datanodes is given a new identity`, which is communicated to the namenode, so that the partial block on `the failed datanode will be deleted` if the failed datanode recovers later on. The failed datanode is removed from the pipeline, and `a new pipeline is constructed from the two good datanodes`. The remainder of the block’s data is written to the good datanodes in the pipeline. The namenode notices that the block is under-replicated, and it `arranges for a further replica to be created on another node`. Subsequent blocks are then treated as normal.  
It’s possible, but unlikely, for multiple datanodes to fail while a block is being written. `As long as dfs.namenode.replication.min replicas (which defaults to 1) are written, the write will succeed`, and `the block will be asynchronously replicated across the cluster until its target replication factor is reached` (dfs.replication, which defaults to 3).  
When the client has finished writing data, it calls close() on the stream (step 6). This action flushes all the remaining packets to the datanode pipeline and waits for acknowledgments before contacting the namenode to signal that the file is complete (step 7). The namenode already knows which blocks the file is made up of (because `DataStreamer asks for block allocations`), so it only has to wait for blocks to be minimally replicated before returning successfully.  

##### Replica Placement  
How does the namenode choose which datanodes to store replicas on? There’s a tradeoff between reliability and write bandwidth and read bandwidth here.

Hadoop’s default strategy is to place the first replica on the same node as the client (for clients running outside the cluster, a node is chosen at random, although the system tries not to pick nodes that are too full or too busy). The second replica is placed on a different rack from the first (off-rack), chosen at random. The third replica is placed on the same rack as the second, but on a different node chosen at random. Further replicas are placed on random nodes in the cluster, although the system tries to avoid placing too many replicas on the same rack.

#### Coherency Model
A coherency model for a filesystem describes the data visibility of reads and writes for a file. HDFS trades off some POSIX requirements for performance, so some operations may behave differently than you expect them to.  

After creating a file, it is visible in the filesystem namespace, as expected. However, any content written to the file is not guaranteed to be visible, even if the stream is flushed. So, the file appears to have a length of zero.  
```java
Path p = new Path("p");
OutputStream out = fs.create(p);
out.write("content".getBytes("UTF-8"));
out.flush();
assertThat(fs.getFileStatus(p).getLen(), is(0L));
```
Once more than a block’s worth of data has been written, the first block will be visible to new readers. This is true of subsequent blocks, too: it is always the current block being written that is not visible to other readers.    
HDFS provides a way to force all buffers to be flushed to the datanodes via the hflush() method on FSDataOutputStream. After a successful return from hflush(), HDFS guarantees that the data written up to that point in the file has reached all the datanodes in the write pipeline and is visible to all new readers:  
```java
Path p = new Path("p");
FSDataOutputStream out = fs.create(p);
out.write("content".getBytes("UTF-8"));
out.hflush();
assertThat(fs.getFileStatus(p).getLen(), is(((long) "content".length())));
```

`Note that hflush() does not guarantee that the datanodes have written the data to disk, only that it’s in the datanodes’ memory (so in the event of a data center power outage, for example, data could be lost)`. For this stronger guarantee, use hsync() instead.  
Closing a file in HDFS performs an implicit hflush(), too.  
The behavior of hsync() is similar to that of the fsync() system call in POSIX that commits buffered data for a file descriptor. For example, using the standard Java API to write a local file, we are guaranteed to see the content after flushing the stream and synchronizing:
```java
FileOutputStream out = new FileOutputStream(localFile);
out.write("content".getBytes("UTF-8"));
out.flush(); // flush to operating system
out.getFD().sync(); // sync to disk
assertThat(localFile.length(), is(((long) "content".length())));
```
With no calls to hflush() or hsync(), you should be prepared to lose up to a block of data in the event of client or system failure. so you should call hflush() at suitable points. Though the hflush() operation is designed to not unduly tax HDFS, it does have some overhead (and hsync() has more), so there is a trade-off between data robustness and throughput.

### Parallel Copying with distcp
Hadoop comes with a useful program called **distcp** for copying data to and from Hadoop filesystems in parallel.

```shell
$ hadoop distcp file1 file2
$ hadoop distcp dir1 dir2
## If we changed a file in the dir1 subtree, we could synchronize the change with dir2 by running:
$ hadoop distcp -update dir1 dir2
```
distcp is implemented as a MapReduce job where the work of copying is done by the maps that run in parallel across the cluster. There are no reducers. `Each file is copied by a single map`, and distcp tries to give each map approximately the same amount of data by bucketing files into roughly equal allocations. By default, up to 20 maps are used, but this can be changed by specifying the `-m argument to distcp`

A very common use case for distcp is for transferring data between two HDFS clusters. For example, the following creates a backup of the first cluster’s /foo directory on the second:  
```shell
$ hadoop distcp -update -delete -p hdfs://namenode1/foo hdfs://namenode2/foo 
```
The -delete flag causes distcp to delete any files or directories from the destination that are not present in the source, and -p means that file status attributes like permissions, block size, and replication are preserved. 

If the two clusters are running incompatible versions of HDFS, then you can use the webhdfs protocol to distcp between them:  
```shell
$ hadoop distcp webhdfs://namenode1:50070/foo webhdfs://namenode2:50070/foo
```
Another variant is to use an HttpFs proxy as the distcp source or destination (again using the webhdfs protocol)

## 4. YARN
Apache YARN (Yet Another Resource Negotiator) is Hadoop’s cluster resource management system. YARN was introduced in Hadoop 2 to improve the MapReduce implementation, but it is general enough to support other distributed computing paradigms as well.  

YARN provides APIs for requesting and working with cluster resources, but these APIs are not typically used directly by user code. Instead, users write to higher-level APIs provided by distributed computing frameworks, which themselves are built on YARN and hide the resource management details from the user. The situation is illustrated in Figure 4-1, which shows some distributed computing frameworks (MapReduce, Spark, Tez and so on) running as YARN applications on the cluster compute layer (YARN) and the cluster storage layer (HDFS and HBase).

![hadoop_yarn_layout_img_1]  

There is also a layer of applications that build on the frameworks shown in Figure 4-1. Pig, Hive, and Crunch are all examples of processing frameworks that run on MapReduce, Spark, or Tez (or on all three), and don’t interact with YARN directly.

### Anatomy of a YARN Application Run
YARN provides its core services via two types of long-running daemon: a **resource manager** (`one per cluster`) to manage the use of resources across the cluster, and **node managers** running on all the nodes in the cluster to launch and monitor containers. A **container** executes an application-specific process with a constrained set of resources (memory, CPU, and so on)  

![hadoop_data_flow_img_4]   

To run an application on YARN, a client contacts the resource manager and asks it to run an **application master** process (step 1 in Figure 4-2). The resource manager then finds a node manager that can `launch the application master in a container` (steps 2a and 2b). Precisely what the application master does once it is running depends on the application. It could simply run a computation in the container it is running in and return the result to the client. Or it could request more containers from the resource managers (step 3), and use them to run a distributed computation (steps 4a and 4b). The latter is what the MapReduce YARN application does, which we’ll look at in more detail in “Anatomy of a MapReduce Job Run” on page 185.  
Notice from Figure 4-2 that `YARN itself does not provide any way for the parts of the application (client, master, process) to communicate with one another`. `Most nontrivial YARN applications use some form of remote communication (such as Hadoop’s RPC layer) to pass status updates and results back to the client`, but these are specific to the application.

#### Resource Requests
YARN has a flexible model for making resource requests. A request for a set of containers can express the amount of computer resources required for each container (memory and CPU), as well as `locality constraints for the containers in that request`.

In the common case of launching a container to process an HDFS block (to run a map task in MapReduce, say), the application will request a container on one of the nodes hosting the block’s three replicas, or on a node in one of the racks hosting the replicas, or, failing that, on any node in the cluster

A YARN application can make resource requests at any time while it is running. For example, an application can make all of its requests up front, or it can take a more dynamic approach whereby it requests more resources dynamically to meet the changing needs of the application.

`Spark takes the first approach, starting a fixed number of executors on the cluster` (see “Spark on YARN” on page 571). `MapReduce, on the other hand, has two phases: the map task containers are requested up front`, but the reduce task containers are not started until later. Also, if any tasks fail, additional containers will be requested so the failed tasks can be rerun.

#### Application Lifespan
The lifespan of a YARN application can vary dramatically, it’s useful to categorize applications in terms of how they map to the jobs that users run.  
1. The simplest case is `one application per user job`, which is the approach that `MapReduce takes`.
2. The second model is to run `one application per workflow or user session` of (possibly unrelated) jobs.  
This approach can be more efficient than the first, since containers can be reused between jobs, and there is also the potential to cache intermediate data between jobs. `Spark is an example that uses this model`.
3. The third model is a long-running application that is shared by different users.  
Such an application often acts in some kind of coordination role. For example, Apache Slider has a long-running application master for launching other applications on the cluster. This approach is also used by Impala (see “SQL-on-Hadoop Alternatives” on page 484) to provide a proxy application that the Impala daemons communicate with to request cluster resources. The “always on” application master means that users have very low latency responses to their queries since the overhead of starting a new application master is avoided.

#### Building YARN Applications
Writing a YARN application from scratch is fairly involved, but in many cases is not necessary, as it is often possible to use an existing application that fits the bill. For example, if you are interested in running a directed acyclic graph (DAG) of jobs, then Spark or Tez is appropriate; or for stream processing, Spark, Samza, or Storm works.

There are a couple of projects that simplify the process of building a YARN application.  
* Apache Slider  
mentioned earlier, makes it possible to run existing distributed applications on YARN. `Users can run their own instances of an application (such as HBase) on a cluster, independently of other users`, which means that different users can run different versions of the same application. Slider provides controls to change the number of nodes an application is running on, and to suspend then resume a running application. 
* Apache Twill  
is similar to Slider, but in addition provides `a simple programming model` for developing distributed applications on YARN. Twill allows you to define cluster processes as an extension of a Java Runnable, then runs them in YARN containers on the cluster. Twill also provides support for, among other things, `real-time logging` (log events from runnables are streamed back to the client) and `command messages` (sent from the client to runnables).

### YARN Compared to MapReduce 1
The distributed implementation of MapReduce in the original version of Hadoop (version 1 and earlier) is sometimes referred to as “MapReduce 1” to distinguish it from MapReduce 2, the implementation that uses YARN (in Hadoop 2 and later).  

The old and new MapReduce APIs are not the same thing as the MapReduce 1 and MapReduce 2 implementations. All four combinations are supported: both the old and new MapReduce APIs run on both MapReduce 1 and 2.

In MapReduce 1, there are two types of daemon that control the job execution process: a **jobtracker** and one or more **tasktracker**s. The jobtracker coordinates all the jobs run on the system by scheduling tasks to run on tasktrackers. Tasktrackers run tasks and send progress reports to the jobtracker, which keeps a record of the overall progress of each job. If a task fails, the jobtracker can reschedule it on a different tasktracker.

`In MapReduce 1, the jobtracker takes care of both job scheduling (matching tasks with tasktrackers) and task progress monitoring` (keeping track of tasks, restarting failed or slow tasks, and doing task bookkeeping, such as maintaining counter totals). By contrast, in YARN these responsibilities are handled by separate entities: the resource manager and an application master (one for each MapReduce job). 

The jobtracker is also responsible for storing job history for completed jobs, although it is possible to run a `job history server` as a separate daemon to take the load off the jobtracker. In YARN, the equivalent role is the `timeline server`, which stores application history. As of Hadoop 2.5.1, the YARN timeline server does not yet store MapReduce job history, so a MapReduce job history server daemon is still needed.

The YARN equivalent of a tasktracker is a node manager. The mapping is summarized as  

MapReduce 1         |YARN
--------------------|----------------------------------------------------------
Jobtracker          |Resource manager, application master, timeline server
Tasktracker         |Node manager
Slot                |Container

YARN was designed to address many of the limitations in MapReduce 1. The benefits to using YARN include the following:  
* Scalability  
YARN can run on larger clusters than MapReduce 1.  
MapReduce 1 hits scalability bottlenecks in the region of 4,000 nodes and 40,000 tasks, stemming from the fact that the jobtracker has to manage both jobs and tasks. YARN overcomes these limitations by virtue of its `split resource manager/application master architecture`: it is designed to scale up to 10,000 nodes and 100,000 tasks (`by a factor of 2.5`).  
This `dedicated application master` is actually closer to the original Google MapReduce paper, which describes how a master process is started to coordinate map and reduce tasks running on a set of workers.  

* Availability  
With the jobtracker’s responsibilities split between the resource manager and application master in YARN, making the service highly available became `a divide-and-conquer problem`: provide HA for the resource manager, then for YARN applications (on a per-application basis). And indeed, `Hadoop 2 supports HA both for the resource manager and for the application master for MapReduce jobs`.  

* Utilization  
In MapReduce 1, each tasktracker is configured with a `static allocation` of `fixed-size` “slots,” which are divided into map slots and reduce slots at configuration time. A map slot can only be used to run a map task, and a reduce slot can only be used for a reduce task.  
In YARN, a node manager manages a pool of resources, rather than a fixed number of designated slots. MapReduce running on YARN will not hit the situation where a reduce task has to wait because only map slots are available on the cluster, which can happen in MapReduce 1.   
Furthermore, `resources in YARN are fine grained`, so an application can make a request for what it needs, rather than for an indivisible slot, which may be too big (which is wasteful of resources) or too small (which may cause a failure) for the particular task.  

* Multitenancy  
`In some ways, the biggest benefit of YARN is that it opens up Hadoop to other types of distributed application beyond MapReduce`. MapReduce is just one YARN application among many. It is even possible for users to run different versions of MapReduce on the same YARN cluster, which makes the process of upgrading MapReduce more manageable. (Note, however, that some parts of MapReduce, such as the job history server and the shuffle handler, as well as YARN itself, still need to be upgraded across the cluster.)

### Scheduling in YARN
Three schedulers are available in YARN: the FIFO, Capacity, and Fair Schedulers.  

The **FIFO Scheduler** has the merit of being `simple` to understand and not needing any configuration, but it’s `not suitable for shared clusters`. Large applications will use all the resources in a cluster, so each application has to wait its turn. `On a shared cluster it is better to use the Capacity Scheduler or the Fair Scheduler`. Both of these allow longrunning jobs to complete in a timely manner, while still allowing users who are running concurrent smaller ad hoc queries to get results back in a reasonable time.  

With the **Capacity Scheduler** (ii in Figure 4-3), a separate dedicated queue allows the small job to start as soon as it is submitted, although this is `at the cost of overall cluster utilization` since the queue capacity is reserved for jobs in that queue (some cluster nodes managed by the dedicate queue are reserved). This means that the large job finishes later than when using the FIFO Scheduler.  

With the **Fair Scheduler** (iii in Figure 4-3), there is no need to reserve a set amount of capacity, since it will dynamically balance resources between all running jobs. Just after the first (large) job starts, it is the only job running, so it gets all the resources in the cluster. When the second (small) job starts, it is allocated half of the cluster resources so that each job is using its fair share of resources.

The scheduler in use is determined by the setting of `yarn.resourcemanager.scheduler.class`. The Capacity Scheduler is used by default (although the Fair Scheduler is the default in some Hadoop distributions, such as CDH), but this can be changed by setting yarn.resourcemanager.scheduler.class in `yarn-site.xml` to the fully qualified classname of the scheduler, `org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler`

#### Capacity Scheduler Configuration
The Capacity Scheduler allows sharing of a Hadoop cluster along organizational lines, whereby `each organization is allocated a certain capacity of the overall cluster`. Each organization is set up with a dedicated queue that is configured to use a given fraction of the cluster capacity. `Queues may be further divided in hierarchical fashion`, allowing each organization to share its cluster allowance between different groups of users within the organization. `Within a queue, applications are scheduled using FIFO scheduling.`

Capacity Scheduler configuration file, called `capacity-scheduler.xml`  

A single job does not use more resources than its queue’s capacity. However, if there is more than one job in the queue and there are idle resources available, then the Capacity Scheduler may allocate the spare resources to jobs in the queue, even if that causes the queue’s capacity to be exceeded. This behavior is known as **queue elasticity**.  (`yarn.scheduler.capacity.<queue-path>.user-limit-factor` is set to a value larger than 1 (the default))

It is possible to mitigate this by configuring queues with a maximum capacity so that they don’t eat into other queues’ capacities too much. This is at the cost of queue elasticity, of course, so a reasonable trade-off should be found by trial and error. (`yarn.scheduler.capacity.<queue-path>.maximum-capacity`)

##### Queue placement
The way that you specify which queue an application is placed in is specific to the application. For example, in MapReduce, you set the property `mapreduce.job.queuename` to the name of the queue you want to use (the name of queue is the last part of queue path, for example, in example below, prod and eng are OK, but root.dev.eng and dev.eng do not work). If the queue does not exist, then you’ll get an error at submission time. `If no queue is specified, applications will be placed in a queue called default`.

Imagine a queue hierarchy that looks like this, which is used in sections below  
```html
root  
├── prod  
└── dev  
    ├── eng  
    └── science  
```

The listing in Example 4-1 shows a sample Capacity Scheduler configuration file, called `capacity-scheduler.xml`, for this hierarchy.
```xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>yarn.scheduler.capacity.root.queues</name>
        <value>prod,dev</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.dev.queues</name>
        <value>eng,science</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.prod.capacity</name>
        <value>40</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.dev.capacity</name>
        <value>60</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.dev.maximum-capacity</name>
        <value>75</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.dev.eng.capacity</name>
        <value>50</value>
    </property>
    <property>
        <name>yarn.scheduler.capacity.root.dev.science.capacity</name>
        <value>50</value>
    </property>
</configuration>
```

#### Fair Scheduler Configuration
Figure 4-3 showed how fair sharing works for applications in the same queue; however, fair sharing actually works between queues, too.  

The Fair Scheduler is configured using an allocation file named `fair-scheduler.xml` that is loaded from the classpath. (The name can be changed by setting the property `yarn.scheduler.fair.allocation.file`) In the absence of an allocation file, the Fair Scheduler operates as described earlier: `each application is placed in a queue named after the user and queues are created dynamically when users submit their first applications`.  

```xml
<?xml version="1.0"?>
<allocations>
    <defaultQueueSchedulingPolicy>fair</defaultQueueSchedulingPolicy>
    <queue name="prod">
        <weight>40</weight>
        <schedulingPolicy>fifo</schedulingPolicy>
    </queue>
    <queue name="dev">
        <weight>60</weight>
        <queue name="eng" />
        <queue name="science" />
    </queue>
    <queuePlacementPolicy>
        <rule name="specified" create="false" />
        <rule name="primaryGroup" create="false" />
        <rule name="default" queue="dev.eng" />
    </queuePlacementPolicy>
</allocations>
```
The queue hierarchy is defined using nested queue elements. All queues are children of the root queue, even if not actually nested in a root queue element.  
Queues can have weights, which are used in the fair share calculation.  
When setting weights, remember to consider the default queue and dynamically created queues (such as queues named after users). These are not specified in the allocation file, but still have weight 1.  

Queues can have different scheduling policies. The default policy for queues can be set in the top-level **defaultQueueSchedulingPolicy** element; if it is omitted, `fair scheduling` is used. Despite its name, the Fair Scheduler also supports a FIFO (fifo) policy on queues, as well as Dominant Resource Fairness (drf), described later in the chapter.

The policy for a particular queue can be overridden using the schedulingPolicy element for that queue.

Although not shown in this allocation file, queues can be configured with minimum and maximum resources, and a maximum number of running applications. (See the reference page for details.) The minimum resources setting is not a hard limit, but rather is used by the scheduler to prioritize resource allocations. `If two queues are below their fair share, then the one that is furthest below its minimum is allocated resources first`. The minimum resource setting is also used for preemption, discussed momentarily.

##### Queue placement
The Fair Scheduler uses a rules-based system to determine which queue an application is placed in. In the example above, the queuePlacementPolicy element contains a list of rules, each of which is tried in turn until a match occurs.   
* The first rule, specified, places an application in the queue it specified; if none is specified, or if the specified queue doesn’t exist, then the rule doesn’t match and the next rule is tried.  
* The primaryGroup rule tries to place an application in a queue with the name of the user’s primary Unix group; if there is no such queue, rather than creating it, the next rule is tried.  
* The default rule is a catch-all and always places the application in the dev.eng queue.

The queuePlacementPolicy can be omitted entirely, in which case the default behavior is as if it had been specified with the following:  
```xml
<queuePlacementPolicy>
    <rule name="specified" />
    <rule name="user" />
</queuePlacementPolicy>
```
In other words, unless the queue is explicitly specified, the user’s name is used for the queue, creating it if necessary.  

It’s also possible to set this policy without using an allocation file, by setting `yarn.scheduler.fair.user-as-default-queue` to false so that applications will be placed in the default queue rather than a per-user queue. In addition, `yarn.scheduler.fair.allow-undeclared-pools` should be set to false so that users can’t create queues on the fly.

##### Preemption
Preemption allows the scheduler to kill containers for queues that are running with more than their fair share of resources so that the resources can be allocated to a queue that is under its fair share. Note that `preemption reduces overall cluster efficiency, since the terminated containers need to be reexecuted`.  

Preemption is enabled globally by setting `yarn.scheduler.fair.preemption` to true. There are two relevant preemption timeout settings: one for minimum share and one for fair share, both specified in seconds. By default, the timeouts are not set, so you need to set at least one to allow containers to be preempted.  
1. minimum share preemption timeout  
If a queue waits for as long as its minimum share preemption timeout without receiving its minimum guaranteed share, then the scheduler may preempt other containers.  
2. fair share preemption timeout  
Likewise, if a queue remains below `half of its fair share` for as long as the fair share preemption timeout, then the scheduler may preempt other containers.  
#### Delay Scheduling
All the YARN schedulers try to honor locality requests. On a busy cluster, if an application requests a particular node, there is a good chance that other containers are running on it at the time of the request. The obvious course of action is to immediately loosen the locality requirement and allocate a container on the same rack. However, it has been observed in practice that waiting a short time (no more than a few seconds) can dramatically increase the chances of being allocated a container on the requested node, and therefore increase the efficiency of the cluster. This feature is called delay scheduling, and it is `supported by both the Capacity Scheduler and the Fair Scheduler`.  

`Every node manager in a YARN cluster periodically sends a heartbeat request to the resource manager—by default, one per second`. Heartbeats carry information about the node manager’s running containers and the resources available for new containers, so each heartbeat is a potential **scheduling opportunity** for an application to run a container.  

For the Capacity Scheduler, delay scheduling is configured by setting `yarn.scheduler.capacity.node-locality-delay` to a positive integer representing the number of scheduling opportunities that it is prepared to miss before loosening the node constraint to match any node in the same rack. 

The Fair Scheduler also uses the number of scheduling opportunities to determine the delay, although it is expressed as a proportion of the cluster size. For example, setting `yarn.scheduler.fair.locality.threshold.node` to 0.5 means that the scheduler should wait until half of the nodes in the cluster have presented scheduling opportunities before accepting another node in the same rack. There is a corresponding property, `yarn.scheduler.fair.locality.threshold.rack`, for setting the threshold before another rack is accepted instead of the one requested.

#### Dominant Resource Fairness
However, when there are multiple resource types in play, things get more complicated. If one user’s application requires lots of CPU but little memory and the other’s requires little CPU and lots of memory, how are these two applications compared?   
The way that the schedulers in YARN address this problem is to look at each user’s dominant resource and use it as a measure of the cluster usage. This approach is called Dominant Resource Fairness, or DRF for short. The idea is best illustrated with a simple example.

Imagine a cluster with a total of 100 CPUs and 10 TB of memory. Application A requests containers of (2 CPUs, 300 GB), and application B requests containers of (6 CPUs, 100 GB). A’s request is (2%, 3%) of the cluster, so memory is dominant since its proportion (3%) is larger than CPU’s (2%). B’s request is (6%, 1%), so CPU is dominant. Since B’s container requests are twice as big in the dominant resource (6% versus 3%), it will be allocated half as many containers under fair sharing.( Before under fair sharing, the products of DRF * number of containers are equal.)  

By default DRF is not used, so during resource calculations, only memory is considered and CPU is ignored.  

#### YARN Further Reading
This chapter has given a short overview of YARN. For more detail, see Apache Hadoop YARN by Arun C. Murthy et al. (Addison-Wesley, 2014).


## 5. Hadoop I/O

### Data Integrity
A commonly used error-detecting code is CRC-32 (32-bit cyclic redundancy check), which computes a 32-bit integer checksum for input of any size. `CRC-32 is used for checksumming in Hadoop’s ChecksumFileSystem, while HDFS uses a more efficient variant called CRC-32C`.

`HDFS transparently checksums all data written to it and by default verifies checksums when reading data`. A separate checksum is created for every `dfs.bytes-per-checksum` bytes of data. The default is 512 bytes, and because a CRC-32C checksum is 4 bytes long, `the storage overhead is less than 1%`.

Datanodes are responsible for verifying the data they receive before storing the data and its checksum. A client writing data sends it to a pipeline of datanodes (as explained in Chapter 3), and `the last datanode in the pipeline verifies the checksum`.

When clients read data from datanodes, they verify checksums as well, comparing them with the ones stored at the datanodes. `Each datanode keeps a persistent log of checksum verifications`, so it knows the last time each of its blocks was verified. When a client successfully verifies a block, it tells the datanode, which updates its log. Keeping statistics such as these is valuable in detecting bad disks.

In addition to block verification on client reads, each datanode runs a **DataBlockScanner** in a background thread that periodically verifies all the blocks stored on the datanode. This is to guard against corruption due to “bit rot” in the physical storage media. 

Because HDFS stores replicas of blocks, it can “heal” corrupted blocks by copying one of the good replicas to produce a new, uncorrupt replica.
`It is possible to disable verification of checksums` by passing false to the setVerifyChecksum() method on FileSystem before using the open() method to read a file. The same effect is possible from the shell by using the `-ignoreCrc` option with the -get or the equivalent -copyToLocal command. This feature is useful if you have a corrupt file that you want to inspect so you can decide what to do with it. For example, you might want to see whether it can be salvaged before you delete it.

#### LocalFileSystem
`The Hadoop LocalFileSystem performs client-side checksumming`. This means that when you write a file called filename, the filesystem client transparently creates a hidden file, `.filename.crc`, in the same directory containing the checksums for each chunk of the file. The chunk size is controlled by the `file.bytes-per-checksum` property, which defaults to 512 bytes.  

Checksums are fairly cheap to compute (in Java, they are implemented in native code)

It is, however, possible to disable checksums, which is typically done when the underlying filesystem supports checksums natively.  
1. Globally, setting the property `fs.file.impl` to the value `org.apache.hadoop.fs.RawLocalFileSystem`
2. directly create a RawLocalFileSystem instance  
```java
Configuration conf = ...
FileSystem fs = new RawLocalFileSystem();
fs.initialize(null, conf);
```

#### ChecksumFileSystem
LocalFileSystem uses ChecksumFileSystem to do its work, and this class makes it easy to add checksumming to other (nonchecksummed) filesystems, as ChecksumFileSystem is just a wrapper around FileSystem. The general idiom is as follows:  
```java
FileSystem rawFs = ...
FileSystem checksummedFs = new ChecksumFileSystem(rawFs);
```

If an error is detected by ChecksumFileSystem when reading a file, it will call its reportChecksumFailure() method. The default implementation does nothing, but LocalFileSystem moves the offending file and its checksum to a side directory on the same device called `bad_files`.

### Compression
The tools listed in Table 5-1 typically give some control over this trade-off at compression time by offering nine different options: –1 means optimize for speed, and -9 means optimize for space.
```java
$ gzip -1 files
```

**Table 5-1. A summary of compression formats**  

Compression format  |Tool   |Algorithm  |Filename extension |Splittable?
--------------------|-------|-----------|-------------------|------------------
DEFLATE             |N/A    |DEFLATE    |.deflate           |No
gzip                |gzip   |DEFLATE    |.gz                |No
bzip2               |bzip2  |bzip2      |.bz2               |Yes
LZO                 |lzop   |LZO        |.lzo               |"No"
LZ4                 |N/A    |LZ4        |.lz4               |No
Snappy              |N/A    |Snappy     |.snappy            |No

The different tools have very different compression characteristics.  
* gzip is a general-purpose compressor and sits in the middle of the space/time trade-off.   
* bzip2 compresses more effectively than gzip, but is slower. bzip2’s decompression speed is faster than its compression speed, but it is still slower than the other formats. 
* LZO, LZ4, and Snappy, on the other hand, all optimize for speed and are around `an order of magnitude faster than gzip`, but compress less effectively. `Snappy and LZ4 are also significantly faster than LZO for decompression`.  
* bzip2 is splittable, LZO files are splittable if they have been indexed in a preprocessing step using an indexer tool that comes with the Hadoop LZO libraries

The “Splittable” column in Table 5-1 indicates whether the compression format supports splitting (that is, whether you can seek to any point in the stream and start reading from some point further on). Splittable compression formats are especially suitable for Map‐Reduce.

[hadoop-jvm-compressor-benchmark-1]  

A codec is the implementation of a compression-decompression algorithm. In Hadoop, a codec is represented by an implementation of the **CompressionCodec** interface.  
`For large files, you should not use a compression format that does not support splitting on the whole file, because you lose locality and make MapReduce applications very inefficient`.

#### Codecs
**CompressionOutputStream** and **CompressionInputStream** are similar to java.util. zip.DeflaterOutputStream and java.util.zip.DeflaterInputStream, except that both of the former provide `the ability to reset their underlying compressor or decompressor`. This is important for applications that compress sections of the data stream as separate blocks, such as in a SequenceFile.

**Example 5-1. A program to compress data read from standard input and write it to standard output**   
```java
public class StreamCompressor {
    public static void main(String[] args) throws Exception {
        String codecClassname = args[0];
        Class<?> codecClass = Class.forName(codecClassname);
        Configuration conf = new Configuration();
        CompressionCodec codec = (CompressionCodec)ReflectionUtils.newInstance(codecClass, conf);
        CompressionOutputStream out = codec.createOutputStream(System.out);
        IOUtils.copyBytes(System.in, out, 4096, false);
        out.finish();
    }
}
```

**Example 5-2. A program to decompress a compressed file using a codec inferred from the file’s extension**  
```java
public class FileDecompressor {
    public static void main(String[] args) throws Exception {
        String uri = args[0];
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(uri), conf);
        Path inputPath = new Path(uri);
        CompressionCodecFactory factory = new CompressionCodecFactory(conf);
        CompressionCodec codec = factory.getCodec(inputPath);
        if (codec == null) {
            System.err.println("No codec found for " + uri);
            System.exit(1);
        }
        String outputUri =
            CompressionCodecFactory.removeSuffix(uri, codec.getDefaultExtension());
        InputStream in = null;
        OutputStream out = null;
        try {
            in = codec.createInputStream(fs.open(inputPath));
            out = fs.create(new Path(outputUri));
            IOUtils.copyBytes(in, out, conf);
        } finally {
            IOUtils.closeStream(in);
            IOUtils.closeStream(out);
        }
    }
}
```
use `io.compression.codecs` configuration property if you have a custom codec that you wish to register.

#### Native libraries
For performance, it is preferable to use a native library for compression and decompression.  

The Apache Hadoop binary tarball comes with prebuilt native compression binaries for 64-bit Linux, called `libhadoop.so`. For other platforms, you will need to compile the libraries yourself, following the BUILDING.txt instructions at the top level of the source tree.  
The native libraries are picked up using the Java system property `java.library.path`. The hadoop script in the etc/hadoop directory sets this property for you, but if you don’t use this script, you will need to set the property in your application.

By default, Hadoop looks for native libraries for the platform it is running on, and loads them automatically if they are found. `This means you don’t have to change any configuration settings to use the native libraries`. In some circumstances, however, you may wish to disable use of native libraries, such as when you are debugging a compression related problem. You can do this by setting the property `io.native.lib.available` to false, which ensures that the built-in Java equivalents will be used (if they are available).

#### CodecPool
If you are using a native library and you are doing a lot of compression or decompression in your application, consider using CodecPool, which allows you to reuse compressors and decompressors, thereby amortizing the cost of creating these objects.  

**Example 5-3. A program to compress data read from standard input and write it to standard output using a pooled compressor**  
```java
public class PooledStreamCompressor {
    public static void main(String[] args) throws Exception {
        String codecClassname = args[0];
        Class<?> codecClass = Class.forName(codecClassname);
        Configuration conf = new Configuration();
        CompressionCodec codec = (CompressionCodec)ReflectionUtils.newInstance(codecClass, conf);
        Compressor compressor = null;
        try {
            compressor = CodecPool.getCompressor(codec);
            CompressionOutputStream out = codec.createOutputStream(System.out, compressor);
            IOUtils.copyBytes(System.in, out, 4096, false);
            out.finish();
        } finally {
            CodecPool.returnCompressor(compressor);
        }
    }
}
```

#### Using Compression in MapReduce

For large files, you should not use a compression format that does not support splitting on the whole file, because you lose locality and make MapReduce applications very inefficient.

Hadoop applications process large datasets, so you should strive to take advantage of compression. Which compression format you use depends on such considerations as file size, format, and the tools you are using for processing. Here are some suggestions, arranged roughly in order of most to least effective:  
* Use a container file format such as sequence files, Avro datafiles, ORCFiles, or Parquet files, all of which support both compression and splitting. A fast compressor such as LZO, LZ4, or Snappy is generally a good choice. 
* Use a compression format that supports splitting, such as bzip2 (although bzip2 is fairly slow), or one that can be indexed to support splitting, such as LZO. 
* Split the file into chunks in the application, and compress each chunk separately using any supported compression format (it doesn’t matter whether it is splittable). In this case, you should choose the chunk size so that the compressed chunks are approximately the size of an HDFS block. 
* Store the files uncompressed.

In order to compress the output of a MapReduce job, in the job configuration, set the `mapreduce.output.fileoutputformat.compress` property to true and set the `mapreduce.output.fileoutputformat.compress.codec` property to the classname of the compression codec you want to use. Alternatively, you can use the static convenience methods on **FileOutputFormat** to set these properties, as shown in Example 5-4.  
**Example 5-4. Application to run the maximum temperature job producing compressed output**  
```java
public class MaxTemperatureWithCompression {
    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: MaxTemperatureWithCompression <input path> " +
                "<output path>");
            System.exit(-1);
        }
        Job job = new Job();
        job.setJarByClass(MaxTemperature.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileOutputFormat.setCompressOutput(job, true);
        FileOutputFormat.setOutputCompressorClass(job, GzipCodec.class);
        job.setMapperClass(MaxTemperatureMapper.class);
        job.setCombinerClass(MaxTemperatureReducer.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
```
```shell
$ hadoop MaxTemperatureWithCompression input/ncdc/sample.txt.gz output
```

If you are emitting sequence files for your output, you can set the `mapreduce.output.fileoutputformat.compress.type` property to control the type of compression to use. The default is RECORD, which compresses individual records. Changing this to BLOCK, which compresses groups of records, is recommended because it compresses better

##### Compressing map output
Even if your MapReduce application reads and writes uncompressed data, it may benefit from compressing the intermediate output of the map phase. The map output is written to disk and transferred across the network to the reducer nodes, so by using a fast compressor such as LZO, LZ4, or Snappy, you can get performance gains simply because the volume of data to transfer is reduced.  

`mapreduce.map.output.compress`, `mapreduce.map.output.compress.codec`  

```java
Configuration conf = new Configuration();
conf.setBoolean(Job.MAP_OUTPUT_COMPRESS, true);
conf.setClass(Job.MAP_OUTPUT_COMPRESS_CODEC, GzipCodec.class, CompressionCodec.class);
Job job = new Job(conf);
```

### Serialization
Serialization is the process of turning structured objects into a byte stream for transmission over a network or for writing to persistent storage. Deserialization is the reverse process of turning a byte stream back into a series of structured objects.  

Serialization is used in two quite distinct areas of distributed data processing: for interprocess communication and for persistent storage.  

`In Hadoop, interprocess communication between nodes in the system is implemented using remote procedure calls (RPCs)`. In general, it is desirable that an RPC serialization format is:  
* Compact  
* Fast
* Extensible  
Protocols change over time to meet new requirements, so it should be straightforward to evolve the protocol in a controlled manner for clients and servers. For example, it should be possible to add a new argument to a method call and have the new servers accept messages in the old format (without the new argument) from old clients.  
* Interoperable  
For some systems, it is desirable to be able to support clients that are written in different languages to the server, so the format needs to be designed to make this possible.

It turns out, the four desirable properties of an RPC’s serialization format are also crucial for a persistent storage format.  

Hadoop uses its own serialization format, **Writable**, which is certainly compact and fast, but not so easy to extend or use from languages other than Java. Writables are central to Hadoop (most MapReduce programs use them for their key and value types).  
Avro (a serialization system that was designed to overcome some of the limitations of Writables)

#### The Writable Interface

```java
package org.apache.hadoop.io;
import java.io.DataOutput;
import java.io.DataInput;
import java.io.IOException;
public interface Writable {
    void write(DataOutput out) throws IOException;
    void readFields(DataInput in) throws IOException;
}
```

```java
IntWritable writable = new IntWritable();
writable.set(163);

public static byte[] serialize(Writable writable) throws IOException {
    ByteArrayOutputStream out = new ByteArrayOutputStream();
    // DataOutputStream implements DataOutput. 
    DataOutputStream dataOut = new DataOutputStream(out);
    writable.write(dataOut);
    dataOut.close();
    return out.toByteArray();
}

byte[] bytes = serialize(writable);
assertThat(bytes.length, is(4));

// Hadoop StringUtils
assertThat(StringUtils.byteToHexString(bytes), is("000000a3"));

public static byte[] deserialize(Writable writable, byte[] bytes)
throws IOException {
    ByteArrayInputStream in = new ByteArrayInputStream(bytes);
    // DataInputStream implements DataInput. 
    DataInputStream dataIn = new DataInputStream(in);
    writable.readFields(dataIn);
    dataIn.close();
    return bytes;
}

IntWritable newWritable = new IntWritable();
deserialize(newWritable, bytes);
assertThat(newWritable.get(), is(163));
```

#### WritableComparable and comparators
```java
package org.apache.hadoop.io;
public interface WritableComparable<T> extends Writable, Comparable<T> {
}
```
Comparison of types is crucial for MapReduce, where there is a sorting phase during which keys are compared with one another. One optimization that Hadoop provides is the **RawComparator** extension of Java’s Comparator:  
```java
package org.apache.hadoop.io;
import java.util.Comparator;
public interface RawComparator<T> extends Comparator<T> {
    public int compare(byte[] b1, int s1, int l1, byte[] b2, int s2, int l2);
}
```
This interface permits implementors to compare records read from a stream without deserializing them into objects, thereby avoiding any overhead of object creation.  

**WritableComparator** is a general-purpose implementation of RawComparator for WritableComparable classes. It provides two main functions. First, it provides a default implementation of the raw compare() method that `deserializes the objects to be compared from the stream and invokes the object compare() method`. Second, it acts as `a factory for RawComparator instances` (that Writable implementations have registered). For example, to obtain a comparator for IntWritable, we just use:  
```java
RawComparator<IntWritable> comparator =
    WritableComparator.get(IntWritable.class);
// first
IntWritable w1 = new IntWritable(163);
IntWritable w2 = new IntWritable(67);
assertThat(comparator.compare(w1, w2), greaterThan(0));

//second
byte[] b1 = serialize(w1);
byte[] b2 = serialize(w2);
assertThat(comparator.compare(b1, 0, b1.length, b2, 0, b2.length),
    greaterThan(0));
```

#### Writable Classes
![hadoop_writable_class_hierarchy_img_1]  

There are Writable wrappers for all the Java primitive types (see Table 5-7, all of which implement WritableComparable as well
) except char (which can be stored in an IntWritable).

Some other WriteableComparable implementations are Text, NullWritable, BytesWritable, MD5Hash. 

When it comes to encoding integers, there is a choice between the fixed-length formats (IntWritable and LongWritable) and the variable-length formats (VIntWritable and VLongWritable). The variable-length formats use only a single byte to encode the value if it is small enough (between –112 and 127, inclusive); otherwise, they use the first byte to indicate whether the value is positive or negative, and how many bytes follow. on average, `the variable-length encoding will save space`. Another advantage of variable-length encodings is that you can switch from VIntWritable to VLongWritable, because their encodings are actually the same.  

##### Text
Text is a Writable for **UTF-8** sequences. It can be thought of as the Writable equivalent of java.lang.String.  

`The Text class uses an int (with a variable-length encoding) to store the number of bytes in the string encoding, so the maximum value is 2 GB`. Furthermore, Text uses standard UTF-8, which makes it potentially easier to interoperate with other tools that understand UTF-8.  

Because of its emphasis on using standard UTF-8, there are some differences between Text and the Java String class. `Indexing for the Text class is in terms of position in the encoded byte sequence, but not the Unicode character in the string or the Java char code unit in the string (as how indexing is for String).(PS: the latters are in term of Unicode character)`

Iterating over the Unicode characters in Text is complicated by the use of byte offsets for indexing, since you can’t just increment the index. The idiom for iteration is a little obscure (see Example 5-6): turn the Text object into a java.nio.ByteBuffer, then repeatedly call the bytesToCodePoint() static method on Text with the buffer.  
**Example 5-6. Iterating over the characters in a Text object**  
```java
public class TextIterator {
    public static void main(String[] args) {
        Text t = new Text("\u0041\u00DF\u6771\uD801\uDC00");
        ByteBuffer buf = ByteBuffer.wrap(t.getBytes(), 0, t.getLength());
        int cp;
        while (buf.hasRemaining() && (cp = Text.bytesToCodePoint(buf)) != -1) {
            System.out.println(Integer.toHexString(cp));
        }
    }
}
```

`Another difference from String is that Text is mutable` (like all Writable implementations in Hadoop, except NullWritable, which is a singleton).  

getBytes() doesn't return the actual size, but return current capacity, which is the case for BytesWritable  
```java
Text t = new Text("hadoop");
t.set(new Text("pig"));
// getLength is accurate
assertThat(t.getLength(), is(3));
assertThat("Byte length not shortened", t.getBytes().length,
is(6));
```

```java
// convert to String
assertThat(new Text("hadoop").toString(), is("hadoop"));
```

##### NullWritable
NullWritable is a special type of Writable, as it has a zero-length serialization. No bytes are written to or read from the stream. It is used as a placeholder; for example, in Map-Reduce, a key or a value can be declared as a NullWritable when you don’t need to use that position, effectively storing a constant empty value. NullWritable can also be useful as a key in a SequenceFile when you want to store a list of values, as opposed to key-value pairs. It is an immutable singleton, and the instance can be retrieved by calling NullWritable.get().

##### ObjectWritable and GenericWritable
ObjectWritable is a general-purpose wrapper for the following: Java primitives, String, enum, Writable, null, or arrays of any of these types. `It is used in Hadoop RPC to marshal and unmarshal method arguments and return types`.  

ObjectWritable is useful when a field can be of more than one type.  

Being a general-purpose mechanism, it wastes a fair amount of space because it writes the classname of the wrapped type every time it is serialized. In cases where the number of types is small and known ahead of time, this can be improved by having a static array of types and using the index into the array as the serialized reference to the type. This is the approach that GenericWritable takes, and you have to subclass it to specify which types to support.

##### Writable collections
The org.apache.hadoop.io package includes six Writable collection types: 
* ArrayWritable
* ArrayPrimitiveWritable
* TwoDArrayWritable
* MapWritable
* SortedMapWritable
* EnumSetWritable

In contexts where the Writable is defined by type, such as in SequenceFile keys or values or as input to MapReduce in general, you need to subclass ArrayWritable (or TwoDArrayWritable, as appropriate) to set the type statically. Though there is no need to subclass ArrayPrimitiveWritable to set the type. For example:  
```java
public class TextArrayWritable extends ArrayWritable {
    public TextArrayWritable() {
        super(Text.class);
    }
}
```

MapWritable is an implementation of java.util.Map<Writable, Writable>, and SortedMapWritable is an implementation of java.util.SortedMap<WritableComparable, Writable>. The type of each key and value field is a part of the serialization format for that field. The type is stored as `a single byte` that acts as an index into `an array of types`. The array is populated with the standard types in the org.apache.hadoop.io package, but custom Writable types are accommodated, too, by writing a header that encodes the type array for nonstandard types. As they are implemented, MapWritable and SortedMapWritable use positive byte values for custom types, so a maximum of 127 distinct nonstandard Writable classes can be used in any particular MapWritable or SortedMapWritable instance.  

A general set can be emulated by using a MapWritable (or a SortedMapWritable for a sorted set) with NullWritable values.  

There is also EnumSetWritable for sets of enum types.   

For lists of a single type of Writable, ArrayWritable is adequate, but to store different types of Writable in a single list, you can use GenericWritable to wrap the elements in an ArrayWritable. Alternatively, you could write a general ListWritable using the ideas from MapWritable.  

#### Implementing a Custom Writable
Because Writables are at the heart of the MapReduce data path, tuning the binary representation can have a significant effect on performance.  
If you are considering writing a custom Writable, it may be worth trying another serialization framework, like **Avro**, that allows you to define custom types declaratively.

**Example 5-7. A Writable implementation that stores a pair of Text objects**  
```java
import java.io.*;
import org.apache.hadoop.io.*;
public class TextPair implements WritableComparable<TextPair> {
    private Text first;
    private Text second;
    // ...
    @Override
    public void write(DataOutput out) throws IOException {
        first.write(out);
        second.write(out);
    }
    @Override
    public void readFields(DataInput in) throws IOException {
        first.readFields(in);
        second.readFields(in);
    }
    @Override
    public int hashCode() {
        return first.hashCode() * 163 + second.hashCode();
    }
    @Override
    public boolean equals(Object o) {
        if (o instanceof TextPair) {
            TextPair tp = (TextPair) o;
            return first.equals(tp.first) && second.equals(tp.second);
        }
        return false;
    }
    @Override
    public String toString() {
        return first + "\t" + second;
    }
    @Override
    public int compareTo(TextPair tp) {
        int cmp = first.compareTo(tp.first);
        if (cmp != 0) {
            return cmp;
        }
        return second.compareTo(tp.second);
    }
}
```
The hashCode() method is used by the **HashPartitioner** (the default partitioner in MapReduce) to choose a reduce partition, so you should make sure that you write a good hash function that mixes well to ensure reduce partitions are of a similar size.  

If you plan to use your custom Writable with TextOutputFormat, you must implement its toString() method. TextOutputFormat calls toString() on keys and values for their output representation.

##### Implementing a RawComparator for speed
when TextPair is being used as a key in MapReduce, it will have to be deserialized into an object for the compareTo() method to be invoked. What if it were possible to compare two TextPair objects just by looking at their serialized representations?

```java
public static class Comparator extends WritableComparator {
    private static final Text.Comparator TEXT_COMPARATOR = new Text.Comparator();
    public Comparator() {
        super(TextPair.class);
    }
    @Override
    public int compare(byte[] b1, int s1, int l1,
        byte[] b2, int s2, int l2) {
        try {
            /**
            * Each is made up of the length of the variable-length integer
            * (returned by decodeVIntSize() on WritableUtils) and 
            * the value it is encoding (returned by readVInt()).
            */             
            int firstL1 = WritableUtils.decodeVIntSize(b1[s1]) + readVInt(b1, s1);
            int firstL2 = WritableUtils.decodeVIntSize(b2[s2]) + readVInt(b2, s2);
            int cmp = TEXT_COMPARATOR.compare(b1, s1, firstL1, b2, s2, firstL2);
            if (cmp != 0) {
                return cmp;
            }
            return TEXT_COMPARATOR.compare(b1, s1 + firstL1, l1 - firstL1,
                b2, s2 + firstL2, l2 - firstL2);
        } catch (IOException e) {
            throw new IllegalArgumentException(e);
        }
    }
}
static {
    WritableComparator.define(TextPair.class, new Comparator());
}
```

The static block registers the raw comparator so that whenever MapReduce sees the TextPair class, it knows to use the raw comparator as its default comparator.

The utility methods on WritableUtils are very handy, too  

#### Serialization Frameworks
Hadoop has an API for pluggable serialization frameworks. A serialization framework is represented by an implementation of **Serialization** (in the org.apache.hadoop.io.serializer package). **WritableSerialization**, for example, is the implementation of Serialization for Writable types.

A Serialization defines a mapping from types to **Serializer** instances (for turning an object into a byte stream) and **Deserializer** instances (for turning a byte stream into an object).  
Set the `io.serializations` property to a comma-separated list of classnames in order to register Serialization implementations. `Its default value includes org.apache.hadoop.io.serializer.WritableSerialization and the Avro Specific and Reflect serializations` (see “Avro Data Types and Schemas” on page 346), which means that only Writable or Avro objects can be serialized or deserialized out of the box.

Hadoop includes a class called **JavaSerialization** that uses Java Object Serialization. Although it makes it convenient to be able to use standard Java types such as Integer or String in MapReduce programs, `Java Object Serialization is not as efficient as Writables`, so it’s not worth making this trade-off.

Java Serialization, that is tightly integrated with the language. It looked big and hairy and I thought we needed something lean and mean, where we had precise control over exactly how objects are written and read, since that is central to Hadoop.  
The logic for not using RMI was similar. `Effective, high performance inter-process communications are critical to Hadoop. I felt like we’d need to precisely control how things like connections, timeouts and buffers are handled, and RMI gives you little control over those.`

##### Serialization IDL
There are a number of other serialization frameworks that approach the problem in a different way: rather than defining types through code, you define them in a language-neutral, declarative fashion, using an interface description language (IDL). The system can then generate types for different languages, which is good for interoperability. They also typically define versioning schemes that make type evolution straightforward.

Apache Thrift [hadoop_apache_thrift_1] and Google Protocol Buffers [hadoop_google_protocol_buffers_1] are both popular serialization frameworks, and both are commonly used as a format for persistent binary data. There is limited support for these as MapReduce formats; however, they are used internally in parts of Hadoop for RPC and data exchange.  

Avro is an IDL-based serialization framework designed to work well with large-scale data processing in Hadoop.

## File-Based Data Structures
For some applications, you need a specialized data structure to hold your data. For doing MapReduce-based processing, putting each blob of binary data into its own file doesn’t scale, so Hadoop developed a number of higher-level containers for these situations.

### SequenceFile
Imagine a logfile where `each log record is a new line of text`. If you want to log binary types, plain text isn’t a suitable format. Hadoop’s SequenceFile class fits the bill in this situation, providing a persistent data structure for `binary key-value pairs`. To use it as a logfile format, you would choose a key, such as timestamp represented by a LongWritable, and the value would be a Writable that represents the quantity being logged.

`SequenceFiles also work well as containers for smaller files`. HDFS and MapReduce are optimized for large files, so packing files into a SequenceFile makes storing and processing the smaller files more efficient.

#### Writing a SequenceFile
To create a SequenceFile, use one of its createWriter() static methods, which return a SequenceFile.Writer instance. There are several overloaded versions, but they all require you to specify a stream to write to (either an FSDataOutputStream or a FileSystem and Path pairing), a Configuration object, and the key and value types. Optional arguments include the compression type and codec, a Progressable callback to be informed of write progress, and `a Metadata instance to be stored in the SequenceFile header`.

**Example 5-10. Writing a SequenceFile**
```java
public class SequenceFileWriteDemo {
    private static final String[] DATA = {
        "One, two, buckle my shoe",
        "Three, four, shut the door",
        "Five, six, pick up sticks",
        "Seven, eight, lay them straight",
        "Nine, ten, a big fat hen"
    };
    public static void main(String[] args) throws IOException {
        String uri = args[0];
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(uri), conf);
        Path path = new Path(uri);
        IntWritable key = new IntWritable();
        Text value = new Text();
        SequenceFile.Writer writer = null;
        try {
            writer = SequenceFile.createWriter(fs, conf, path,
                key.getClass(), value.getClass());
            for (int i = 0; i < 100; i++) {
                key.set(100 - i);
                value.set(DATA[i % DATA.length]);
                System.out.printf("[%s]\t%s\t%s\n", writer.getLength(), key, value);
                writer.append(key, value);
            }
        } finally {
            IOUtils.closeStream(writer);
        }
    }
}
```

```shell
$ hadoop SequenceFileWriteDemo numbers.seq
[128] 100 One, two, buckle my shoe
[173] 99 Three, four, shut the door
...
[359] 95 One, two, buckle my shoe
...
```

There are two ways to seek to  a given position in a sequence file.  
1. seek() method, seek at record boundary
```java
// 359 is boundary, but 360 is not
reader.seek(359);
assertThat(reader.next(key, value), is(true));
assertThat(((IntWritable) key).get(), is(95));

reader.seek(360);
reader.next(key, value); // fails with IOException
```
2. find a record boundary makes use of sync points  
The sync(long position) method on SequenceFile.Reader positions the reader at the next sync point after position, or eof if no sync point  
```java
// 360 is not boundary, 2021 is the next boundary  
reader.sync(360);
assertThat(reader.getPosition(), is(2021L));
assertThat(reader.next(key, value), is(true));
assertThat(((IntWritable) key).get(), is(59));
```
SequenceFile.Writer has a method called sync() for `inserting a sync point at the current position` in the stream.

Sync points come into their own when using sequence files as input to MapReduce, since they permit the files to be split and different portions to be processed independently by separate map tasks.

#### Reading a SequenceFile
Reading sequence files from beginning to end is a matter of creating an instance of SequenceFile.Reader and iterating over records by repeatedly invoking one of the next() methods. Which one you use depends on the serialization framework you are using.

**Example 5-11. Reading a SequenceFile**  
```java
public class SequenceFileReadDemo {
    public static void main(String[] args) throws IOException {
        String uri = args[0];
        Configuration conf = new Configuration();
        FileSystem fs = FileSystem.get(URI.create(uri), conf);
        Path path = new Path(uri);
        SequenceFile.Reader reader = null;
        try {
            reader = new SequenceFile.Reader(fs, path, conf);
            Writable key = (Writable)ReflectionUtils.newInstance(reader.getKeyClass(), conf);
            Writable value = (Writable)ReflectionUtils.newInstance(reader.getValueClass(), conf);
            long position = reader.getPosition();
            while (reader.next(key, value)) {
                // sync point
                String syncSeen = reader.syncSeen() ? "*" : "";
                System.out.printf("[%s%s]\t%s\t%s\n", position, syncSeen, key, value);
                position = reader.getPosition(); // beginning of next record
            }
        } finally {
            IOUtils.closeStream(reader);
        }
    }
}
```
```shell
$ hadoop SequenceFileReadDemo numbers.seq
...
[1976] 60 One, two, buckle my shoe
[2021*] 59 Three, four, shut the door
```

A **sync point** is a point in the stream that can be used to resynchronize with a record boundary if the reader is “lost”—for example, after seeking to an arbitrary position in the stream. `Sync points are recorded by SequenceFile.Writer, which inserts a special entry to mark the sync point every few records as a sequence file is being written`. Such entries are small enough to incur only a modest storage overhead—less than 1%. `Sync points always align with record boundaries`.

#### Displaying a SequenceFile with the command-line interface
The hadoop fs command has a -text option to display sequence files in textual form. It can recognize gzipped files, sequence files, and Avro 
datafiles; otherwise, it assumes the input is plain text.
```shell
$ hadoop fs -text numbers.seq | head
100 One, two, buckle my shoe
99 Three, four, shut the door
98 Five, six, pick up sticks
97 Seven, eight, lay them straight
```

#### Sorting and merging SequenceFiles
The most powerful way of sorting (and merging) one or more sequence files is to use MapReduce. MapReduce is inherently parallel and will let you specify the number of reducers to use, which determines the number of output partitions. For example, specifying 1 reducer  
```shell
$ hadoop jar \
    $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
    sort -r 1 \
    -inFormat org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat \
    -outFormat org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat \
    -outKey org.apache.hadoop.io.IntWritable \
    -outValue org.apache.hadoop.io.Text \
    numbers.seq sorted
$ hadoop fs -text sorted/part-r-00000 | head
1 Nine, ten, a big fat hen
2 Seven, eight, lay them straight
...
```

An alternative is the SequenceFile.Sorter class, which has a number of sort() and merge() methods. These functions predate MapReduce and are lower-level functions than MapReduce (for example, to get parallelism, you need to partition your data manually).

#### The SequenceFile format  

**Figure 5-2. The internal structure of a sequence file with no compression and with record compression**  
![hadoop_sequence_file_structure_img_1]  
A sequence file consists of a header followed by one or more records (see Figure 5-2). The first three bytes of a sequence file are the bytes SEQ, which act as a magic number; these are followed by a single byte representing the version number. The header contains other fields, including the names of the key and value classes, compression details, user-defined metadata, and the sync marker. `Each file has a randomly generated sync marker`.  

The internal format of the records depends on whether compression is enabled, and if it is, whether it is record compression or block compression.  

The format for record compression is almost identical to that for no compression, except the value bytes are compressed using the codec defined in the header.  

**Figure 5-3. The internal structure of a sequence file with block compression**  
![hadoop_sequence_file_structure_img_2]  
Block compression (Figure 5-3) compresses multiple records at once; it is therefore more compact than and should generally be preferred over record compression because it has the opportunity to take advantage of similarities between records. Records are added to a block until it reaches a minimum size in bytes, defined by the `io.seqfile.compress.blocksize` property; the default is one million bytes. A sync marker is written before the start of every block. The format of a block is a field indicating the number of records in the block, followed by four compressed fields: the key lengths, the keys, the value lengths, and the values.

#### MapFile
A MapFile is a `sorted SequenceFile` with an index to permit lookups by key. `The index is itself a SequenceFile that contains a fraction of the keys in the map (every 128th key, by default)`. The idea is that the index can be loaded into memory to provide fast lookups from `the main data file, which is another SequenceFile containing all the map entries in sorted key order`.

MapFile offers a very similar interface to SequenceFile for reading and writing—the main thing to be aware of is that when writing using MapFile.Writer, `map entries must be added in order, otherwise an IOException will be thrown`.

##### MapFile variants
* SetFile is a specialization of MapFile for storing a set of Writable keys. The keys must be added in sorted order. 
* ArrayFile is a MapFile where the key is an integer representing the index of the element in the array and the value is a Writable value. 
* BloomMapFile is a MapFile that offers a fast version of the get() method, especially for sparsely populated files. The implementation uses a dynamic Bloom filter for testing whether a given key is in the map. The test is very fast because it is in memory, and it has a nonzero probability of false positives. Only if the test passes (the key is present) is the regular get() method called.

#### Other File Formats and Column-Oriented Formats  
**Avro datafiles** are like sequence files in that they are designed for large-scale data processing—they are compact and splittable—but they are `portable across different programming languages`. Objects stored in Avro datafiles are described by a schema. `Avro datafiles are widely supported across components in the Hadoop ecosystem, so they are a good default choice for a binary format`.

![hadoop_storage_row_vs_column_img_1]  

`Sequence files, map files, and Avro datafiles are all row-oriented file formats`, which means that the values for each row are stored contiguously in the file. In a column-oriented format, the rows in a file (or, equivalently, a table in Hive) are broken up into `row splits`, then each split is stored in column-oriented fashion: the values for each row in the first column are stored first, followed by the values for each row in the second column, and so on.  

With row-oriented storage, Lazy deserialization saves some processing cycles by deserializing only the column fields that are accessed, but it can’t avoid the cost of reading each row’s bytes from disk. 

In general, column-oriented formats work well when queries access only a small number of columns in the table. Conversely, row-oriented formats are appropriate when a large number of columns of a single row are needed for processing at the same time.

`Column-oriented formats need more memory for reading and writing, since they have to buffer a row split in memory, rather than just a single row`. Also, it’s not usually possible to control when writes occur (via flush or sync operations), so `column-oriented formats are not suited to streaming writes`, as the current file cannot be recovered if the writer process fails. On the other hand, row-oriented formats like sequence files and Avro datafiles can be read up to the last sync point after a writer failure. It is for this reason that `Flume (see Chapter 14) uses row-oriented formats`. 

The first column-oriented file format in Hadoop was Hive’s `RCFile, short for Record Columnar File`. It has since been superseded by Hive’s `ORCFile (Optimized Record Columnar File)`, and Parquet (covered in Chapter 13). `Parquet is a general-purpose column-oriented file format based on Google’s Dremel, and has wide support across Hadoop components`. `Avro also has a column-oriented format called Trevni.`

## 6. Developing a MapReduce Application

### The Configuration API
Components in Hadoop are configured using Hadoop’s own configuration API. An instance of the Configuration class (found in the org.apache.hadoop.conf package) represents a collection of configuration properties and their values. Each property is named by a String, and the type of a value may be one of several, including Java primitives such as boolean, int, long, and float; other useful types such as String, Class, and java.io.File and collections of Strings.

Configurations read their properties from resources—XML files with a simple structure for defining name-value pairs. See Example 6-1.  
**Example 6-1. A simple configuration file, configuration-1.xml**  
```xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>color</name>
        <value>yellow</value>
        <description>Color</description>
    </property>
    <property>
        <name>size</name>
        <value>10</value>
        <description>Size</description>
    </property>
    <property>
        <name>weight</name>
        <value>heavy</value>
        <final>true</final>
        <description>Weight</description>
    </property>
    <property>
        <name>size-weight</name>
        <value>${size},${weight}</value>
        <description>Size and weight</description>
    </property>
</configuration>
```

```java
Configuration conf = new Configuration();
conf.addResource("configuration-1.xml");
assertThat(conf.get("color"), is("yellow"));
assertThat(conf.getInt("size", 0), is(10));
assertThat(conf.get("breadth", "wide"), is("wide"));
```

Things get interesting when more than one resource is used to define a Configuration. Properties defined in resources that are added later override the earlier definitions.  
However, properties that are marked as final cannot be overridden in later definitions.  
`System properties take priority over properties defined in resource files`, This feature is useful for overriding properties on the command line by using 
-Dproperty=value JVM arguments.  
```java
System.setProperty("size", "14");
```

Note that although configuration properties can be defined in terms of system properties, unless system properties are redefined using configuration properties, they are not accessible through the configuration API. Hence:
```java
// length is not in properties file
System.setProperty("length", "2");
assertThat(conf.get("length"), is((String) null));
```

### Setting Up the Development Environment

**Example 6-3. A Maven POM for building and testing a MapReduce application**  
```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>com.hadoopbook</groupId>
    <artifactId>hadoop-book-mr-dev</artifactId>
    <version>4.0</version>
    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <hadoop.version>2.7.4</hadoop.version>
    </properties>
    <dependencies>
        <!-- Hadoop main client artifact -->
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-client</artifactId>
            <version>${hadoop.version}</version>
        </dependency>
        <!-- Unit test artifacts -->
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.11</version>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>org.apache.mrunit</groupId>
            <artifactId>mrunit</artifactId>
            <version>1.1.0</version>
            <classifier>hadoop2</classifier>
            <scope>test</scope>
        </dependency>
        <!-- Hadoop test artifact for running mini clusters -->
        <dependency>
            <groupId>org.apache.hadoop</groupId>
            <artifactId>hadoop-minicluster</artifactId>
            <version>${hadoop.version}</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <finalName>hadoop-examples</finalName>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.1</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-jar-plugin</artifactId>
                <version>2.5</version>
                <configuration>
                    <outputDirectory>${basedir}</outputDirectory>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

For building MapReduce jobs, you only need to have the `hadoop-client` dependency, which contains all the Hadoop client-side classes needed to interact with HDFS and MapReduce. For running unit tests, we use `junit`, and for writing MapReduce tests, we use `mrunit`. The `hadoop-minicluster` library contains the “mini-” clusters that are useful for `testing with Hadoop clusters running in a single JVM`.  

```shell
$ mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true
```

#### Managing Configuration
When developing Hadoop applications, it is common to switch between running the application locally and running it on a cluster.

One way to accommodate these variations is to have Hadoop configuration files containing the connection settings for each cluster you run against and specify which one you are using when you run Hadoop applications or tools. As a matter of best practice, it’s recommended to keep these files outside   Hadoop’s installation directory tree, as this makes it easy to switch between Hadoop versions without duplicating or losing settings.

Hadoop can be run in one of three modes:  
1. Standalone (or local) mode  
`There are no daemons running and everything runs in a single JVM`. Standalone mode is suitable for running MapReduce programs during development, since it is easy to test and debug them.  
In standalone mode, there is no further action to take, since the default properties are set for standalone mode and there are no daemons to run.
2. Pseudo distributed mode  
The Hadoop daemons run on the local machine, thus simulating a cluster on a small scale.
3. Fully distributed mode  
The Hadoop daemons run on a cluster of machines.

**Table A-1. Key configuration properties for different modes**  

Component |Property     |Standalone |Pseudo distributed |Fully distributed
----------|-------------|-----------|-------------------|----------------------
Common    |fs.defaultFS |file:/// (default)|hdfs://localhost/ |hdfs://namenode/
HDFS      |dfs.replication |N/A     |1                        |3 (default)
MapReduce |mapreduce.framework.name |local (default) |yarn    |yarn
YARN      |yarn.resourcemanager.hostname |N/A |localhost      |resourcemanager
YARN      |yarn.nodemanager.auxservices  |N/A |mapreduce_shuffle |mapreduce_shuffle

If you do this, you need to set the **HADOOP_CONF_DIR** environment
variable to the alternative location, or make sure you start the daemons with the --config option:  
```shell
$ start-dfs.sh --config absolute-path-to-config-directory
$ start-yarn.sh --config absolute-path-to-config-directory
$ mr-jobhistory-daemon.sh --config absolute-path-to-config-directory start historyserver
```

**Pseudo distributed mode configurations**:  
```xml
<?xml version="1.0"?>
<!-- core-site.xml -->
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost/</value>
    </property>
</configuration>
<?xml version="1.0"?>
<!-- hdfs-site.xml -->
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>
<?xml version="1.0"?>
<!-- mapred-site.xml -->
<configuration>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
</configuration>
<?xml version="1.0"?>
<!-- yarn-site.xml -->
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>localhost</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
</configuration>
```

For the purposes of this book, we assume the existence of a directory called conf that contains three configuration files: hadoop-local.xml, hadoop-localhost.xml, and hadoop-cluster.xml, Note that there is nothing special about the names of these.

The hadoop-local.xml file contains the default Hadoop configuration for the default filesystem and the local (in-JVM) framework for running MapReduce jobs:
```xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>file:///</value>
    </property>
    <property>
        <name>mapreduce.framework.name</name>
        <value>local</value>
    </property>
</configuration>
```

The settings in hadoop-localhost.xml (pseudo distributed mode) point to a namenode and a YARN resource manager both running on localhost:  
```xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost/</value>
    </property>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address</name>
        <value>localhost:8032</value>
    </property>
</configuration>
```

Finally, hadoop-cluster.xml contains details of the cluster’s namenode and YARN resource manager addresses (in practice, you would name the file after the name of the cluster, rather than “cluster” as we have here, such as hadoop-host1.xml):  
```xml
<?xml version="1.0"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode/</value>
    </property>
    <property>
        <name>mapreduce.framework.name</name>
        <value>yarn</value>
    </property>
    <property>
        <name>yarn.resourcemanager.address</name>
        <value>resourcemanager:8032</value>
    </property>
</configuration>
```

With this setup, it is easy to use any configuration with the -conf command-line switch. For example, the following command shows a directory listing on the HDFS server running in pseudo distributed mode on localhost:
```shell
$ hadoop fs -conf conf/hadoop-localhost.xml -ls .
```

##### Setting User Identity
The user identity that Hadoop uses for permissions in HDFS is determined by running the `whoami` command on the client system. Similarly, the group names are derived from the output of running `groups` on the client system.

If, however, your Hadoop user identity is different from the name of your user account on your client machine, you can explicitly set your Hadoop username by setting the **HADOOP_USER_NAME** environment variable. 

You can also override user group mappings by means of the `hadoop.user.group.static.mapping.overrides` configuration property. For example, `dr.who=;preston=directors,inventors` means that the dr.who user is in no groups, but preston is in the directors and inventors groups.

You can set the user identity that the Hadoop web interfaces run as by setting the `hadoop.http.staticuser.user` property. By default, it is dr.who, which is not a superuser, so system files are not accessible through the web interface.

Tools that come with Hadoop support the -conf option, but it’s straightforward to make your programs (such as programs that run MapReduce jobs) support it, too, using the **Tool** interface.

#### GenericOptionsParser, Tool, and ToolRunner
Hadoop comes with a few helper classes for making it easier to run jobs from the command line. GenericOptionsParser is a class that interprets common Hadoop command-line options and sets them on a Configuration object for your application to use as desired. You don’t usually use GenericOptionsParser directly, as it’s more convenient to implement the Tool interface and run your application with the ToolRunner, which uses GenericOptionsParser internally.  
```java
public class ConfigurationPrinter extends Configured implements Tool {
    static {
        Configuration.addDefaultResource("hdfs-default.xml");
        Configuration.addDefaultResource("hdfs-site.xml");
        Configuration.addDefaultResource("yarn-default.xml");
        Configuration.addDefaultResource("yarn-site.xml");
        Configuration.addDefaultResource("mapred-default.xml");
        Configuration.addDefaultResource("mapred-site.xml");
    }
    @Override
    public int run(String[] args) throws Exception {
        Configuration conf = getConf();
        for (Entry<String, String> entry: conf) {
            System.out.printf("%s=%s\n", entry.getKey(), entry.getValue());
        }
        return 0;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new ConfigurationPrinter(), args);
        System.exit(exitCode);
    }
}
```
We make ConfigurationPrinter a subclass of **Configured**, which is an implementation of the Configurable interface. `All implementations of Tool need to implement Configurable (since Tool extends it), and subclassing Configured is often the easiest way to achieve this`. The run() method obtains the Configuration using Configurable’s getConf() method and then iterates over it, printing each property to standard output.

`Be aware that some properties have no effect when set in the client configuration`. For example, if you set yarn.nodemanager.resource.memory-mb in your job submission with the expectation that it would change the amount of memory available to the node managers running your job, you would be disappointed, because this property is honored only if set in the node manager’s yarn-site.xml file. In general, you can tell the component where a property should be set by its name, so the fact that yarn.nodemanager.resource.memory-mb starts with yarn.nodemanager gives you a clue that it can be set only for the node manager daemon.

Do not confuse setting Hadoop properties using the `-D property=value` option to GenericOptionsParser (and ToolRunner) with setting JVM system properties using the `-Dproperty=value` option to the java command.  
JVM system properties are retrieved from the java.lang.System class, but Hadoop properties are accessible only from a Configuration object. So, the following command will print nothing.  
```shell
$ HADOOP_OPTS='-Dcolor=yellow' \ hadoop ConfigurationPrinter | grep color
```

### Writing a Unit Test with MRUnit
MRUnit is used in conjunction with a standard test execution framework, such as JUnit, so you can run the tests for MapReduce jobs in your normal development environment.

**Example 2-3. Mapper for the maximum temperature example**  
```java
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
public class MaxTemperatureMapper
extends Mapper<LongWritable, Text, Text, IntWritable> {
    private static final int MISSING = 9999;
    @Override
    public void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
        String line = value.toString();
        String year = line.substring(15, 19);
        int airTemperature;
        if (line.charAt(87) == '+') { // parseInt doesn't like leading plus signs
            airTemperature = Integer.parseInt(line.substring(88, 92));
        } else {
            airTemperature = Integer.parseInt(line.substring(87, 92));
        }
        String quality = line.substring(92, 93);
        if (airTemperature != MISSING && quality.matches("[01459]")) {
            context.write(new Text(year), new IntWritable(airTemperature));
        }
    }
}
```

**Example 2-4. Reducer for the maximum temperature example**
```java
import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;
public class MaxTemperatureReducer
extends Reducer<Text, IntWritable, Text, IntWritable> {
    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context)
    throws IOException, InterruptedException {
        int maxValue = Integer.MIN_VALUE;
        for (IntWritable value : values) {
            maxValue = Math.max(maxValue, value.get());
        }
        context.write(key, new IntWritable(maxValue));
    }
}
```

**Example 2-5. Application to find the maximum temperature in the weather dataset**
```java
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
public class MaxTemperature {
    public static void main(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.println("Usage: MaxTemperature <input path> <output path>");
            System.exit(-1);
        }
        Job job = new Job();
        job.setJarByClass(MaxTemperature.class);
        job.setJobName("Max temperature");
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        job.setMapperClass(MaxTemperatureMapper.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
```

**Example 6-5. Unit test for MaxTemperatureMapper**  
```java
import java.io.IOException;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mrunit.mapreduce.MapDriver;
import org.junit.*;
public class MaxTemperatureMapperTest {
    @Test
    public void processesValidRecord() throws IOException, InterruptedException {
        Text value = new Text("0043011990999991950051518004+68750+023550FM-12+0382" +
                                      // Year ^^^^
            "99999V0203201N00261220001CN9999999N9-00111+99999999999");
                                  // Temperature ^^^^^
        new MapDriver<LongWritable, Text, Text, IntWritable>()
        .withMapper(new MaxTemperatureMapper())
        .withInput(new LongWritable(0), value)
        .withOutput(new Text("1950"), new IntWritable(-11))
        .runTest();
    }
    @Test
    public void ignoresMissingTemperatureRecord() throws IOException,
    InterruptedException {
        Text value = new Text("0043011990999991950051518004+68750+023550FM-12+0382" +
                                      // Year ^^^^
            "99999V0203201N00261220001CN9999999N9+99991+99999999999");
                                  // Temperature ^^^^^
        new MapDriver<LongWritable, Text, Text, IntWritable>()
        .withMapper(new MaxTemperatureMapper())
        .withInput(new LongWritable(0), value)
        .runTest();
    }
    @Test
    public void returnsMaximumIntegerInValues() throws IOException,
    InterruptedException {
        new ReduceDriver<Text, IntWritable, Text, IntWritable>()
        .withReducer(new MaxTemperatureReducer())
        .withInput(new Text("1950"),
            Arrays.asList(new IntWritable(10), new IntWritable(5)))
        .withOutput(new Text("1950"), new IntWritable(10))
        .runTest();
    }
}
```

A MapDriver can be used to check for zero, one, or more output records, `according to the number of times that withOutput() is called`. Test ignoresMissingTemperatureRecord() would fail if there were output, since there is no withOutput() called, expecting no output.

### Running Locally on Test Data
#### Running a Job in a Local Job Runner

**Example 6-10. Application to find the maximum temperature**  
```java
public class MaxTemperatureDriver extends Configured implements Tool {
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.printf("Usage: %s [generic options] <input> <output>\n",
                getClass().getSimpleName());
            ToolRunner.printGenericCommandUsage(System.err);
            return -1;
        }
        Job job = new Job(getConf(), "Max temperature");
        job.setJarByClass(getClass());
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        job.setMapperClass(MaxTemperatureMapper.class);
        job.setCombinerClass(MaxTemperatureReducer.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MaxTemperatureDriver(), args);
        System.exit(exitCode);
    }
}
```

Now we can run this application against some local files. Hadoop comes with a local job runner, a cut-down version of the MapReduce execution engine for running Map‐Reduce jobs in a single JVM. It’s designed for testing and is very convenient for use in an IDE, since you can run it in a debugger to step through the code in your mapper and reducer. The local job runner is used if `mapreduce.framework.name` is set to local, which is the default.
```shell
$ mvn compile
$ export HADOOP_CLASSPATH=target/classes/
$ hadoop v2.MaxTemperatureDriver -conf conf/hadoop-local.xml \
input/ncdc/micro output

# Equivalently, we could use the -fs and -jt options provided by GenericOptionsParser:
$ hadoop v2.MaxTemperatureDriver -fs file:/// -jt local input/ncdc/micro output
```

This command executes MaxTemperatureDriver using input from the local input/ncdc/micro directory, producing output in the local output directory. Note that although we’ve set -fs so we use the local filesystem (file:///), the local job runner will actually work fine against any filesystem, including HDFS (and it can be handy to do this if you have a few files that are on HDFS).

We can examine the output on the local filesystem:  
```shell
$ cat output/part-r-00000
1949 111
1950 22
```

#### Testing the Driver
Apart from the flexible configuration options offered by making your application implement Tool, you also make it more testable because it allows you to inject an arbitrary Configuration. There are two approaches to doing this.  
1. The first is to use the local job runner and run the job against a test file on the local filesystem.  
**Example 6-11. A test for MaxTemperatureDriver that uses a local, in-process job runner**  
```java
@Test
public void test() throws Exception {
    Configuration conf = new Configuration();
    conf.set("fs.defaultFS", "file:///");
    conf.set("mapreduce.framework.name", "local");
    conf.setInt("mapreduce.task.io.sort.mb", 1);
    Path input = new Path("input/ncdc/micro");
    Path output = new Path("output");
    FileSystem fs = FileSystem.getLocal(conf);
    fs.delete(output, true); // delete old output
    MaxTemperatureDriver driver = new MaxTemperatureDriver();
    driver.setConf(conf);
    int exitCode = driver.run(new String[] {
        input.toString(), output.toString() });
    assertThat(exitCode, is(0));
    checkOutput(conf, output);
}
```
2. The second way of testing the driver is to run it using a “mini-” cluster.  
Hadoop has a set of testing classes, called **MiniDFSCluster**, **MiniMRCluster**, and **MiniYARNCluster**, that provide a programmatic way of creating in-process clusters. Unlike the local job runner, these allow testing against the full HDFS, MapReduce, and YARN machinery. Bear in mind, too, that `node managers in a mini-cluster launch separate JVMs to run tasks in, which can make debugging more difficult`.  
You can run a mini-cluster from the command line too, with the following:  
```shell
% hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-*-tests.jar \
minicluster
```
Mini-clusters are used extensively in Hadoop’s own automated test suite, but they can be used for testing user code, too. Hadoop’s **ClusterMapReduceTestCase** abstract class provides a useful base for writing such a test, handles the details of starting and stopping the in-process HDFS and YARN clusters in its setUp() and tearDown() methods, and generates a suitable Configuration object that is set up to work with them. Subclasses need only populate data in HDFS (perhaps by copying from a local file), run a MapReduce job, and confirm the output is as expected. Refer to the MaxTemperatureDriver MiniTest class in the example code that comes with this book for the listing.  

### Running on a Cluster
#### Packaging a Job
For a start, `a job’s classes must be packaged into a job JAR file to send to the cluster`. Hadoop will find the job JAR automatically by searching for the JAR on the driver’s classpath that contains the class set in the setJarByClass() method (on JobConf or Job). Alternatively, if you want to set an explicit JAR file by its file path, you can use the setJar() method. (The JAR file path may be local or an HDFS file path.)

Creating a job JAR file is conveniently achieved using a build tool such as Ant or Maven.
```shell
$ mvn package -DskipTests
```

`If you have a single job per JAR, you can specify the main class to run in the JAR file’s manifest. If the main class is not in the manifest, it must be specified on the command line`.   
```shell
$ unset HADOOP_CLASSPATH
$ hadoop jar hadoop-examples.jar v2.MaxTemperatureDriver \
-conf conf/hadoop-cluster.xml input/ncdc/all max-temp
```

Any dependent JAR files can be packaged in a `lib subdirectory` in the job JAR file, although there are other ways to include dependencies, discussed later. Similarly, resource files can be packaged in a `classes subdirectory`.

1. The client classpath  
The user’s client-side classpath set by hadoop jar <jar> is made up of:  
    * The job JAR file
    * Any JAR files in the lib directory of the job JAR file, and the classes directory (if present)
    * The classpath defined by HADOOP_CLASSPATH, if set.  
if without a job JAR, export HADOOP_CLASSPATH and run `hadoop {CLASSNAME}`  
```shell
$ export HADOOP_CLASSPATH=target/classes/
$ hadoop v2.MaxTemperatureDriver -conf conf/hadoop-local.xml \
        input/ncdc/micro output
```
2. The task classpath  
On a cluster (including pseudo distributed mode), map and reduce tasks run in separate JVMs, and their classpaths are not controlled by HADOOP_CLASSPATH. HADOOP_CLASSPATH is a client-side setting and only sets the classpath for the driver JVM, which submits the job.  
Instead, the user’s task classpath is comprised of the following:  
    * The job JAR file
    * Any JAR files contained in the lib directory of the job JAR file, and the classes directory (if present)
    * Any files added to the `distributed cache` using the -libjars option , or the addFileToClassPath() method on DistributedCache (old API), or Job (new API)  
    The last option, using the distributed cache, is simplest from a build point of view because dependencies don’t need rebundling in the job JAR. Also, using the distributed cache can mean fewer transfers of JAR files around the cluster, since `files may be cached on a node between tasks`.  

**Classpath precedence**  
`User JAR files are added to the end of both the client classpath and the task classpath`, sometimes you need to be able to control the task classpath order so that your classes are picked up first.  
* On the client side  
you can force Hadoop to put the user classpath first in the search order by setting the `HADOOP_USER_CLASSPATH_FIRST` environment variable to true. 
* For the task classpath  
you can set `mapreduce.job.user.classpath.first` to true.    
Note that by setting these options you change the class loading for Hadoop framework dependencies (but only in your job), which could potentially cause the job submission or task to fail, so use these options with caution.

#### Launching a Job
```shell
$ unset HADOOP_CLASSPATH
$ hadoop jar hadoop-examples.jar v2.MaxTemperatureDriver \
-conf conf/hadoop-cluster.xml input/ncdc/all max-temp
```

##### Job, Task, and Task Attempt IDs
In Hadoop 2, MapReduce job IDs are generated from YARN application IDs that are created by the YARN resource manager.  

The format of an application ID is composed of the time that the resource manager (not the application) started and an incrementing counter maintained by the resource manager to uniquely identify the application to that instance of the resource manager. For example, `application_1410450250506_0003` (0003, the third, application IDs are 1-based)  

The corresponding job ID is created simply by replacing the application prefix of an a pplication ID with a job prefix: `job_1410450250506_0003`  

Tasks belong to a job, and their IDs are formed by replacing the job prefix of a job ID with a task prefix and adding a suffix to identify the task within the job. For example: `task_1410450250506_0003_m_000003` (000003, the fourth, task IDs are 0-based). `The task IDs are created for a job when it is initialized, so they do not necessarily dictate the order in which the tasks will be executed`.

Tasks may be executed more than once, due to failure (see “Task Failure” on page 193) or speculative execution (see “Speculative Execution” on page 204), so to identify different instances of a task execution, task attempts are given unique IDs. For example: `attempt_1410450250506_0003_m_000003_0` is the first (0; attempt IDs are 0-based) attempt at running task task_1410450250506_0003_m_000003. `Task attempts are allocated during the job run as needed, so their ordering represents the order in which they were created to run`.  

#### The MapReduce Web UI
http://resource-manager-host:8088/

##### Job History  
Job history is retained regardless of whether the job was successful.  
Job history files are stored in HDFS `by the MapReduce application master`, in a directory set by the `mapreduce.jobhistory.done-dir` property. Job history files are kept for one week before being deleted by the system.  
```shell
mapred job -history
```
Task attempts may be marked as killed (on the MapReduce job page) if they are speculative execution duplicates, if the node they are running on dies, or if they are killed by a user.

#### Retrieving the Results
Once the job is finished, there are various ways to retrieve the results. Each reducer produces one output file, for example, there are 30 part files named part-r-00000 to partr-00029 in the output directory.

The -getmerge option to the hadoop fs command is useful here, as it gets all the files in the directory specified in the source pattern and merges them into a single file on the local filesystem.  
```shell
hadoop fs -getmerge {output_directory} {target_filename}
```

We sorted the output, as `the reduce output partitions are unordered` (owing to the hash partition function).

#### Debugging a Job

**Example 6-7. A class for parsing weather records in NCDC format**
```java
public class NcdcRecordParser {
    private static final int MISSING_TEMPERATURE = 9999;
    private String year;
    private int airTemperature;
    private String quality;
    public void parse(String record) {
        year = record.substring(15, 19);
        String airTemperatureString;
        // Remove leading plus sign as parseInt doesn't like them (pre-Java 7)
        if (record.charAt(87) == '+') {
            airTemperatureString = record.substring(88, 92);
        } else {
            airTemperatureString = record.substring(87, 92);
        }
        airTemperature = Integer.parseInt(airTemperatureString);
        quality = record.substring(92, 93);
    }
    public void parse(Text record) {
        parse(record.toString());
    }
    public boolean isValidTemperature() {
        return airTemperature != MISSING_TEMPERATURE && quality.matches("[01459]");
    }
    public String getYear() {
        return year;
    }
    public int getAirTemperature() {
        return airTemperature;
    }
}
```

1. always use log
2. We can use a debug statement to log to standard error, in conjunction with `updating the task’s status message` to prompt us to look in the error log. The web UI makes this easy, as we pass: [will see].
3. We also create a custom counter(statistics figure) to count the total number of abnormal records.
4. If the amount of log data you produce in the course of debugging is large  
    1. write the information to the map’s output, rather than to standard error, for analysis and aggregation by the reduce task.  
    This approach usually necessitates structural changes to your program, so start with the other technique first. 
    2. write a program (in MapReduce, of course) to analyze the logs produced by your job.

```java
public class MaxTemperatureMapper
extends Mapper<LongWritable, Text, Text, IntWritable> {
    enum Temperature {
        OVER_100
    }
    private NcdcRecordParser parser = new NcdcRecordParser();
    @Override
    public void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
        parser.parse(value);
        if (parser.isValidTemperature()) {
            int airTemperature = parser.getAirTemperature();
            if (airTemperature > 1000) {
                System.err.println("Temperature over 100 degrees for input: " + value);
                context.setStatus("Detected possibly corrupt record: see logs.");
                context.getCounter(Temperature.OVER_100).increment(1);
            }
            context.write(new Text(parser.getYear()), new IntWritable(airTemperature));
        }
    }
}
```

Counters are accessible via the web UI or the command line:  
```java
$ mapred job -counter job_1410450250506_0006 \
'v3.MaxTemperatureMapper$Temperature' OVER_100
3
```
The -counter option takes the job ID, counter group name (which is the fully qualified classname here), and counter name (the enum name)

```java
@Test
public void parsesMalformedTemperature() throws IOException,
InterruptedException {
    Text value = new Text("0335999999433181957042302005+37950+139117SAO +0004" +
                                  // Year ^^^^
        "RJSN V02011359003150070356999999433201957010100005+353");
                              // Temperature ^^^^^
    Counters counters = new Counters();
    new MapDriver<LongWritable, Text, Text, IntWritable>()
    .withMapper(new MaxTemperatureMapper())
    .withInput(new LongWritable(0), value)
    .withCounters(counters)
    .runTest();
    Counter c = counters.findCounter(MaxTemperatureMapper.Temperature.MALFORMED);
    assertThat(c.getValue(), is(1L));
}
```

#### Hadoop Logs
* System daemon logs  
Primary audience: Administrators,  Each Hadoop daemon produces a logfile (using log4j, .log)  and `another file that combines standard out and error (.out)`. Written in the directory defined by the `HADOOP_LOG_DIR` environment variable. It is under `$HADOOP_HOME/logs` by default. This can be changed using the HADOOP_LOG_DIR setting in hadoop-env.sh. Logfile names (of both types) are a combination of the name of the user running the daemon, the daemon name, and the machine hostname. For example, hadoop-hdfs-datanode-ip-10-45-174-112.log. The username in the logfile name is actually the default for the **HADOOP_IDENT_STRING** setting in hadoop-env.sh

* HDFS audit logs  
Administrators,  A log of all HDFS requests, turned off by default. Written to the namenode’s log, although this is configurable. HDFS can log all filesystem access requests, Audit logging is implemented using log4j logging at the INFO level. (hdfs-audit.log) It can be enabled by adding the following line to hadoop-env.sh:  
    ```shell
    $ export HDFS_AUDIT_LOGGER="INFO,RFAAUDIT"
    ```

* MapReduce job history logs  
Users, A log of the events (such as task completion) that occur in the course of running a job. Job history files are `stored centrally in HDFS` by the MapReduce `application master`, in JSON format, in a directory set by the `mapreduce.jobhistory.done-dir` property. 

* MapReduce task logs  
Users, Each task child process produces a logfile using log4j (called syslog), a file for data sent to standard out (stdout), and a file for standard error (stderr). Written in the `userlogs` subdirectory of the directory defined by the `YARN_LOG_DIR` environment variable.  
YARN has a service for **log aggregation** that takes the task logs for completed applications and `moves them to HDFS`, where they are stored in a container file for archival purposes. If this service is enabled (by setting yarn.log-aggregation-enable to true on the cluster), then task logs can be viewed by clicking on the logs link in the task attempt web UI, or by using the `mapred job -logs` command. By default, log aggregation is not enabled. In this case, task logs can be retrieved by visiting the node manager’s web UI at http://node-manager-host:8042/logs/userlogs.

```java
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.hadoop.mapreduce.Mapper;
public class LoggingIdentityMapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT>
extends Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    private static final Log LOG = LogFactory.getLog(LoggingIdentityMapper.class);
    @Override
    @SuppressWarnings("unchecked")
    public void map(KEYIN key, VALUEIN value, Context context)
    throws IOException, InterruptedException {
        // Log to stdout file
        System.out.println("Map key: " + key);
        // Log to syslog file
        LOG.info("Map key: " + key);
        if (LOG.isDebugEnabled()) {
            LOG.debug("Map value: " + value);
        }
        context.write((KEYOUT) key, (VALUEOUT) value);
    }
}
```

To enable this, set `mapreduce.map.log.level` or `mapreduce.reduce.log.level`, as appropriate. 

There are some controls for managing the retention and size of task logs. By default, logs are deleted after a minimum of three hours (you can set this using the `yarn.nodemanager.log.retain-seconds` property, although this is ignored if log aggregation is enabled). You can also set a cap on the maximum size of each logfile using the `mapreduce.task.userlog.limit.kb` property, which is 0 by default, meaning there is no cap.

Sometimes you may need to debug a problem that you suspect is occurring in the JVM running a Hadoop command, rather than on the cluster. You can send DEBUG-level logs to the console by using an invocation like this:  
```shell
$ HADOOP_ROOT_LOGGER=DEBUG,console hadoop fs -text /foo/bar
```

#### Remote Debugging
There are a few other options available.
* Reproduce the failure locally
* Use JVM debugging options  
`mapred.child.java.opts`,  JVM options, for example, set it to `-XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/path/to/dumps`  
* Use task profiling

You can set `mapreduce.task.files.preserve.failedtasks` to true to keep a failed task’s files.

You can keep the intermediate files for successful tasks, set the property `mapreduce.task.files.preserve.filepattern` to a regular expression that matches the IDs of the tasks whose files you want to keep.  

Another useful property for debugging is `yarn.nodemanager.delete.debug-delay-sec`, which is the number of seconds to wait to delete localized task attempt files, such as the script used to launch the task container JVM. If this is set on the cluster to a reasonably large value (e.g., 600 for 10 minutes), then you have enough time to look at the files before they are deleted.

To examine task attempt files, log into the node that the task failed on and look for the directory for that task attempt. It will be under one of the local MapReduce directories, as set by the `mapreduce.cluster.local.dir` property. The task attempt directory is in the following location:  
```shell
{mapreduce.cluster.local.dir}/usercache/user/appcache/application-ID/output
/task-attempt-ID
```

### Tuning a Job
There are a few Hadoop-specific “usual suspects” that are worth checking to see whether they are responsible for a performance problem. You should run through the checklist in Table 6-3 before you start trying to profile or optimize at the task level.

* Number of mappers  
How long are your mappers running for? If they are only running for a few seconds on average, you should see whether there’s a way to have fewer mappers and make them all run longer—`a minute or so, as a rule of thumb`.  
Suggestion: use **CombineFileInputFormat** to avoid small files. (“small” means significantly smaller than an HDFS block)   
Hadoop works better with a small number of large files than a large number of small files. Compare a 1 GB file broken into eight 128 MB blocks with 10,000 or so 100 KB files. The 10,000 files use one map each, and the job time can be
tens or hundreds of times slower than the equivalent one with a single input file and eight map tasks.  
The situation is alleviated somewhat by CombineFileInputFormat, which was designed to work well with small files. Where `FileInputFormat creates a split per file`, CombineFileInputFormat packs many files into each split so that each mapper has more to process. `Crucially, CombineFileInputFormat takes node and rack locality into account` when deciding which blocks to place in the same split, so it does not compromise the speed at which it can process the input in a typical MapReduce job.  
CombineFileInputFormat isn’t just good for small files. It can bring benefits when processing large files, too, since it will `generate one split per node`, which may be made up of multiple blocks. Essentially, CombineFileInputFormat decouples the amount of data that a mapper consumes from the block size of the files in HDFS.  
Of course, if possible, it is still a good idea to avoid the many small files case, because `MapReduce works best when it can operate at the transfer rate of the disks in the cluster`, and `processing many small files increases the number of seeks that are needed to run a job`.  `One technique for avoiding the many small files case is to merge small files into larger files by using a sequence file`.  
* Number of reducers  
Check that you are using more than a single reducer. `Reduce tasks should run for five minutes or so and produce at least a block’s worth of data, as a rule of thumb`.  
The single reducer default is something of a gotcha for new users to Hadoop. Almost all real-world jobs should set this to a larger number; otherwise, the job will be very slow since all the intermediate data flows through a single reduce task. Choosing the number of reducers for a job is more of an art than a science. Increasing the number of reducers makes the reduce phase shorter, since you get more parallelism. However, if you take this too far, you can have lots of small files, which is suboptimal. One rule of thumb is to aim for reducers that each run for five minutes or so, and which produce at least one HDFS block’s worth of output.
* Combiners  
Check whether your job can take advantage of a combiner to reduce
the amount of data passing through the shuffle.
* Intermediate compression  
Job execution time can almost always benefit from `enabling map output compression`.
* Custom serialization  
If you are using your own custom Writable objects or custom comparators, make sure you have implemented RawComparator.  
* Shuffle tweaks  
The MapReduce shuffle exposes around a dozen tuning parameters for memory management, `which may help you wring out the last bit of performance`.  

#### Profiling Tasks
Hadoop allows you to `profile a fraction of the tasks` in a job and, as each task completes, pulls down the profile information to your machine for later analysis with standard profiling tools.  

To be sure that any tuning is effective, you should compare the new execution time with the old one running on a real cluster. Even this is easier said than done, since job execution times can vary due to resource contention with other jobs and the decisions the scheduler makes regarding task placement. `To get a good idea of job execution time under these circumstances, perform a series of runs (with and without the change) and check whether any improvement is statistically significant`.

**The HPROF profiler**  
There are a number of configuration properties to control profiling, which are also exposed via convenience methods on JobConf. Enabling profiling is as simple as setting the property `mapreduce.task.profile` to true

This runs the job as normal, but adds an `-agentlib` parameter to the Java command used to launch the task containers on the node managers. You can control the precise parameter that is added by setting the `mapreduce.task.profile.params` property. `The default uses HPROF, a profiling tool that comes with the JDK` that, although basic, can give valuable information about a program’s CPU and heap usage.  

It doesn’t usually make sense to profile all tasks in the job, so by default only those with IDs 0, 1, and 2 are profiled (for both maps and reduces). You can change this by setting `mapreduce.task.profile.maps` and `mapreduce.task.profile.reduces` to specify the range of task IDs to profile. The profile output for each task is saved with the task logs in the userlogs subdirectory of the node manager’s local log directory (alongside the syslog, stdout, and stderr files), and can be retrieved in the way described in “Hadoop Logs” on page 172, according to whether log aggregation is enabled or not.

### MapReduce Workflows
`When the processing gets more complex, this complexity is generally manifested by having more MapReduce jobs, rather than having more complex map and reduce functions`. In other words, as a rule of thumb, think about adding more jobs, rather than adding complexity to jobs.  

For more complex problems, it is worth considering a higher-level language than Map‐Reduce, such as Pig, Hive, Cascading, Crunch, or Spark.  

Finally, the book **Data-Intensive Text Processing with MapReduce by Jimmy Lin and Chris Dyer (Morgan & Claypool Publishers, 2010)** is a great resource for learning more about MapReduce algorithm design and is highly recommended.

#### Decomposing a Problem into MapReduce Jobs
A mapper commonly performs `input format parsing`, `projection` (selecting the 
relevant fields), and `filtering` (removing records that are not of interest).  In the mappers you have seen so far, we have implemented all of these functions in a single mapper. However, there is a case for splitting these into distinct mappers and chaining them into a single mapper using the **ChainMapper** library class that comes with Hadoop. Combined with a **ChainReducer**, you can run a chain of mappers, followed by a reducer and another chain of mappers, in a single MapReduce job.

#### JobControl
When there is more than one job in a MapReduce workflow, the question arises: how do you manage the jobs so they are executed in order? There are several approaches, and the main consideration is whether you have a `linear chain` of jobs or a more complex `directed acyclic graph (DAG)` of jobs.

For a linear chain, the simplest approach is to run each job one after another, waiting until a job completes successfully before running the next: The approach is similar with the new MapReduce API, except you need to examine the Boolean return value of the waitForCompletion() method on Job: true means the job succeeded, and false means it failed.  

For anything more complex than a linear chain, there are libraries that can help orchestrate your workflow (although they are also suited to linear chains, or even one-off jobs). The simplest is in the org.apache.hadoop.mapreduce.jobcontrol package: the **JobControl** class. (There is an equivalent class in the org.apache.hadoop.mapred.jobcontrol package, too.) An instance of JobControl represents a graph of jobs to be run. You add the job configurations, then tell the JobControl instance the dependencies between jobs. You run the JobControl in a thread, and it runs the jobs in dependency order. You can poll for progress, and when the jobs have finished, you can query for all the jobs’ statuses and the associated errors for any failures. If a job fails, JobControl won’t run its dependencies.

`JobControl, which runs on the client machine submitting the jobs`.  

#### Apache Oozie
Apache Oozie is a system for running workflows of dependent jobs. It is composed of two main parts: `a workflow engine` that stores and runs workflows composed of different types of Hadoop jobs (MapReduce, Pig, Hive, and so on), and `a coordinator engine` that runs workflow jobs based on `predefined schedules` and `data availability`. Oozie has been designed to `scale`, and it can manage the `timely execution of thousands of workflows` in a Hadoop cluster, each composed of possibly dozens of constituent jobs.  

Oozie makes `rerunning failed workflows` more tractable, `since no time is wasted running successful parts of a workflow`. Anyone who has managed a complex batch system knows how difficult it can be to catch up from jobs missed due to downtime or failure, and will appreciate this feature.

Unlike JobControl, which runs on the client machine submitting the jobs, `Oozie runs as a service in the cluster`, and clients submit workflow definitions for immediate or later execution. `In Oozie parlance, a workflow is a DAG of action nodes and control-flow nodes`.

An action node performs a workflow task, such as moving files in HDFS; running a MapReduce, Streaming, Pig, or Hive job; performing a Sqoop import; or running an arbitrary shell script or Java program. A control-flow node governs the workflow execution between actions by allowing such constructs as conditional logic (so different execution branches may be followed depending on the result of an earlier action node) or parallel execution. When the workflow completes, Oozie can make an HTTP callback to the client to inform it of the workflow status. It is also possible to receive callbacks every time the workflow enters or exits an action node.

##### Defining an Oozie workflow
Workflow definitions are written in XML using the Hadoop Process Definition Language, Example 6-14 shows a simple Oozie workflow definition for running a single MapReduce job.  

**Example 6-14. Oozie workflow definition to run the maximum temperature MapReduce job**
```xml
<workflow-app xmlns="uri:oozie:workflow:0.1" name="max-temp-workflow">
    <start to="max-temp-mr"/>
    <action name="max-temp-mr">
        <map-reduce>
            <job-tracker>${resourceManager}</job-tracker>
            <name-node>${nameNode}</name-node>
            <prepare>
                <delete path="${nameNode}/user/${wf:user()}/output"/>
            </prepare>
            <configuration>
                <property>
                    <name>mapred.mapper.new-api</name>
                    <value>true</value>
                </property>
                <property>
                    <name>mapred.reducer.new-api</name>
                    <value>true</value>
                </property>
                <property>
                    <name>mapreduce.job.map.class</name>
                    <value>MaxTemperatureMapper</value>
                </property>
                <property>
                    <name>mapreduce.job.combine.class</name>
                    <value>MaxTemperatureReducer</value>
                </property>
                <property>
                    <name>mapreduce.job.reduce.class</name>
                    <value>MaxTemperatureReducer</value>
                </property>
                <property>
                    <name>mapreduce.job.output.key.class</name>
                    <value>org.apache.hadoop.io.Text</value>
                </property>
                <property>
                    <name>mapreduce.job.output.value.class</name>
                    <value>org.apache.hadoop.io.IntWritable</value>
                </property>
                <property>
                    <name>mapreduce.input.fileinputformat.inputdir</name>
                    <value>/user/${wf:user()}/input/ncdc/micro</value>
                </property>
                <property>
                    <name>mapreduce.output.fileoutputformat.outputdir</name>
                    <value>/user/${wf:user()}/output</value>
                </property>
            </configuration>
        </map-reduce>
        <ok to="end"/>
        <error to="fail"/>
    </action>
    <kill name="fail">
        <message>MapReduce failed, error message[${wf:errorMessage(wf:lastErrorNode())}]
        </message>
    </kill>
    <end name="end"/>
</workflow-app>
```

This workflow has three control-flow nodes and one action node: a start control node, a map-reduce action node, a kill control node, and an end control node.  

The Oozie specification lists all the `EL functions` that Oozie supports. 

##### Packaging and deploying an Oozie workflow application
A workflow application is made up of the workflow definition plus all the associated resources (such as MapReduce JAR files, Pig scripts, and so on) needed to run it. Applications must adhere to a simple directory structure, and are deployed to HDFS so that they can be accessed by Oozie. For this workflow application, we’ll put all of the files in a base directory called max-temp-workflow, as shown diagrammatically here:   

max-temp-workflow/  
├── lib/  
│ └── hadoop-examples.jar  
└── workflow.xml  

The workflow definition file workflow.xml must appear in the top level of this directory. JAR files containing the application’s MapReduce classes are placed in the lib directory.

##### Running an Oozie workflow job
For this we use the `oozie command-line tool, a client program for communicating with an Oozie server`. For convenience, we export the OOZIE_URL environment variable to tell the oozie command which Oozie server to use (here we’re using one running locally):  
```shell
$ export OOZIE_URL="http://localhost:11000/oozie"
$ oozie job -config ch06-mr-dev/src/main/resources/max-temp-workflow.properties \
-run

# job: 0000001-140911033236814-oozie-oozi-W
```

Here are the contents of the properties file:  
```json
nameNode=hdfs://localhost:8020
resourceManager=localhost:8032
oozie.wf.application.path=${nameNode}/user/${user.name}/max-temp-workflow
```

## 7. How MapReduce Works
### Anatomy of a MapReduce Job Run
![hadoop_mr_flow_img_1]  


At the highest level, there are five independent entities:  
1. The client, which submits the MapReduce job.
2. The YARN resource manager, which coordinates the allocation of compute resources on the cluster.
3. The YARN node managers, which launch and monitor the compute containers on machines in the cluster.
4. The MapReduce application master, which coordinates the tasks running the Map‐Reduce job. `The application master and the MapReduce tasks run in containers` that are scheduled by the resource manager and managed by the node managers.
5. The distributed filesystem (normally HDFS, covered in Chapter 3), which is used for sharing job files between the other entities.

Not discussed in this section are the `job history server daemon` (for retaining job history data) and the `shuffle handler auxiliary service` (for serving map outputs to reduce tasks).

##### Job Submission
The submit() method on **Job** creates an internal **JobSubmitter** instance and calls submitJobInternal() on it. Having submitted the job, `waitForCompletion()` `polls the job’s progress once per second` and reports the progress to the console if it has changed since the last report. `When the job completes successfully, the job counters are displayed`. Otherwise, the error that caused the job to fail is logged to the console.

The job submission process implemented by **JobSubmitter** does the following:  
* Asks the resource manager for a new application ID, used for the MapReduce job ID (step 2).  
* Checks the output specification of the job. For example, if the output directory has not been specified or it already exists, the job is not submitted and an error is thrown to the MapReduce program. 
* `Computes the input splits for the job`. If the splits cannot be computed (because the input paths don’t exist, for example), the job is not submitted and an error is thrown to the MapReduce program. 
* Copies the resources needed to run the job, including the job JAR file, the configuration file, and the computed input splits, to `the shared filesystem in a directory named after the job ID` (step 3). The job JAR is copied with a high replication factor (controlled by the `mapreduce.client.submit.file.replication` property, which defaults to 10) so that there are lots of copies across the cluster for the node managers to access when they run tasks for the job. 
* Submits the job by calling submitApplication() on the resource manager (step 4).

##### Job Initialization
When the resource manager receives a call to its submitApplication() method, it hands off the request to the **YARN scheduler**. `The scheduler allocates a container, and the resource manager then launches the application master’s process there, under the node manager’s management (steps 5a and 5b)`. 

The application master for MapReduce jobs is a Java application whose main class is **MRAppMaster**. It `initializes the job by creating a number of bookkeeping objects to keep track of the job’s progress`, as it will receive progress and completion reports from the tasks (step 6). Next, it retrieves the input splits computed in the client from the shared filesystem (step 7). `It then creates a map task object for each split`, as well as a number of reduce task objects determined by the `mapreduce.job.reduces` property (set by the setNumReduceTasks() method on Job). Tasks are given IDs at this point.

`The application master must decide how to run the tasks that make up the MapReduce job`. If the job is small, the application master may choose to run the tasks in the same JVM as itself. This happens when it judges that the overhead of allocating and running tasks in new containers outweighs the gain to be had in running them in parallel, compared to running them sequentially on one node. `Such a job is said to be uberized`, or run as an **uber task**. 

What qualifies as a small job? By default, a small job is one that has less than 10 mappers, only one reducer, and an input size that is less than the size of one HDFS block.  
* mapreduce.job.ubertask.maxmaps
* mapreduce.job.ubertask.maxreduces
* mapreduce.job.ubertask.maxbytes
* mapreduce.job.ubertask.enable

Finally, before any tasks can be run, the application master calls the setupJob() method on the **OutputCommitter**. For **FileOutputCommitter**, which is the default, it will create the final output directory for the job and the temporary working space for the task output.

##### Task Assignment
If the job does not qualify for running as an uber task, then the application master `requests containers for all the map and reduce tasks` in the job from the resource manager (step 8). Requests for map tasks are made first and with a higher priority than those for reduce tasks, since all the map tasks must complete `before the sort phase of the reduce` can start (see “Shuffle and Sort” on page 197). `Requests for reduce tasks are not made until 5% of map tasks have completed` (see “Reduce slow start” on page 308).

Reduce tasks can run anywhere in the cluster, but requests for map tasks have data locality constraints that the scheduler tries to honor (see “Resource Requests” on page 81). In the optimal case, the task is data local—that is, running on the same node that the split resides on. Alternatively, the task may be rack local: on the same rack, but not the same node, as the split.

Requests also specify memory requirements and CPUs for tasks.  
* mapreduce.map.memory.mb
* mapreduce.reduce.memory.mb
* mapreduce.map.cpu.vcores
* mapreduce.reduce.cpu.vcores

##### Task Execution 1
Once a task has been assigned resources for a container on a particular node by the resource manager’s scheduler, `the application master starts the container by contacting the node manager` (steps 9a and 9b). The task is executed by a Java application whose main class is **YarnChild**. Before it can run the task, it localizes the resources that the task needs, including the job configuration and JAR file, and any files from the distributed cache (step 10; see “Distributed Cache” on page 274). Finally, it runs the map or reduce task (step 11). 

The YarnChild runs `in a dedicated JVM`, so that any bugs in the user-defined map and reduce functions (or even in YarnChild) don’t affect the node manager. 

Each task can perform setup and commit actions, which are run in the same JVM as the task itself and are determined by the **OutputCommitter** for the job (see “Output Committers” on page 206). For file-based jobs, the commit action moves the task output from a temporary location to its final location. The commit protocol ensures that when speculative execution is enabled (see “Speculative Execution” on page 204), only one of the duplicate tasks is committed and the other is aborted.

##### Streaming
![hadoop_streaming_img_1]  
**Figure 7-2. The relationship of the Streaming executable to the node manager and the task container**  

Streaming runs special map and reduce tasks for the purpose of launching the `user-supplied executable` and communicating with it (Figure 7-2). 

The Streaming task communicates with the process (`which may be written in any language`) using standard input and output streams. During execution of the task, the Java process passes input key-value pairs to the external process, which runs it through the user-defined map or reduce function and passes the output key-value pairs back to the Java process. From the node manager’s point of view, it is as if the child process ran the map or reduce code itself.

#### Progress and Status Updates
A job and each of its tasks have a status, which includes such things as the state of the job or task (e.g., running, successfully completed, failed), the progress of maps and reduces, the values of the job’s counters, and a status message or description (which may be set by user code).

When a task is running, it keeps track of its progress (i.e., the proportion of the task completed). For map tasks, this is `the proportion of the input` that has been processed. For reduce tasks, it’s a little more complex, but the system can still estimate the proportion of the reduce input processed. It does this by dividing the total progress into three parts, corresponding to the three phases of the shuffle (see “Shuffle and Sort” on page 197, Copy, Sort, Reduce). For example, if the task has run the reducer on half its input, the task’s progress is 5/6, since it has completed the copy and sort phases (1/3 each) and is halfway through the reduce phase (1/6).   

Progress reporting is important, as Hadoop will not fail a task that’s making progress. All of the following operations constitute progress:  
* Reading an input record (in a mapper or reducer)
* Writing an output record (in a mapper or reducer)
* Setting the status description (via Reporter’s or TaskAttemptContext’s setStatus() method)
* Incrementing a counter (using Reporter’s incrCounter() method or Counter’s
increment() method)
* Calling Reporter’s or TaskAttemptContext’s progress() method

As the map or reduce task runs, the child process communicates with its parent application master through the umbilical interface. The task reports its progress and status (including counters) back to its `application master, which has an aggregate view of the job`, `every three seconds over the umbilical interface`.

The resource manager web UI displays all the running applications with links to the web UIs of their respective `application masters`, each of which displays further details on the MapReduce job, including its progress. During the course of the job, the client receives the latest status by `polling the application master` every second (the interval is set via `mapreduce.client.progressmonitor.pollinterval`). Clients can also use Job’s getStatus() method to obtain a **JobStatus** instance, which contains all of the status information for the job.

#### Job Completion
When the application master receives a notification that the last task for a job is complete, it changes the status for the job to “successful.” Then, when the Job polls for status, it learns that the job has completed successfully, so it prints a message to tell the user and then returns from the waitForCompletion() method. Job statistics and counters are printed to the console at this point. 

The application master also sends an HTTP job notification if it is configured to do so. This can be configured by clients wishing to receive callbacks, via the `mapreduce.job.end-notification.url` property. 

Finally, on job completion, the application master and the task containers clean up their working state (so intermediate output is deleted), and the OutputCommitter’s commitJob() method is called. Job information is archived by the job history server to enable later interrogation by users if desired.

### Failures
#### Task Failure
The task JVM reports the error back to its parent application master before it exits. The application master marks the task attempt as failed, and `frees up the container so its resources are available for another task`.  

For Streaming tasks, if the Streaming process exits with a nonzero exit code, it is marked as failed. This behavior is governed by the `stream.non.zero.exit.is.failure` property (the default is true).

Another failure mode is the sudden exit of the task JVM, in this case, the `node manager notices that the process has exited and informs the application master so it can mark the attempt as failed`.

`Hanging tasks are dealt with differently. The application master notices that it hasn’t received a progress update for a while and proceeds to mark the task as failed`. `The task JVM process will be killed automatically after this period`. The timeout period after which tasks are considered failed is normally 10 minutes and can be configured on a per-job basis (or a cluster basis) by setting the `mapreduce.task.timeout` property to a value in milliseconds. `Setting the timeout to a value of zero disables the timeout. ` 

If a Streaming process hangs, the node manager will kill it (along with the JVM that launched it) only in the following circumstances: either `yarn.nodemanager.container-executor.class` is set to org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor, or the default container executor is being used and the setsid command is available on the system (so that the task JVM and any processes it launches are in the same process group). `In any other case, orphaned Streaming processes will accumulate on the system`, which will impact utilization over time.

`When the application master is notified of a task attempt that has failed, it will reschedule execution of the task`. `The application master will try to avoid rescheduling the task on a node manager where it has previously failed`. Furthermore, if a task fails four times (by default), it will not be retried again. (`mapreduce.map.maxattempts` property for map tasks and `mapreduce.reduce.maxattempts` for reduce tasks). 

A task attempt may also be killed, which is different from it failing. A task attempt may be killed because it is a speculative duplicate, or because the node manager it was running on failed and the application master marked all the task attempts running on it as killed. Killed task attempts do not count against the number of attempts to run the task.

For some applications, it is undesirable to abort the job if a few tasks fail, as it may be possible to use the results of the job despite some failures.  `mapreduce.map.failures.maxpercent` and `mapreduce.reduce.failures.maxpercent`

#### Application Master Failure
Applications in YARN are retried in the event of failure. The maximum number of attempts to run a MapReduce application master is controlled by the `mapreduce.am.max-attempts` property. The default value is 2.  

The way recovery works is as follows. An application master sends `periodic heartbeats` to the resource manager, and in the event of application master failure, the resource manager will detect the failure and start a new instance of the master running in a new container (managed by a node manager). In the case of the MapReduce application master, `it will use the job history to recover the state of the tasks that were already run by the (failed) application so they don’t have to be rerun`. Recovery is enabled by default, but can be disabled by setting `yarn.app.mapreduce.am.job.recovery.enable` to false.

`The MapReduce client polls the application master for progress reports`, but if its application master fails, the client needs to locate the new instance. `During job initialization, the client asks the resource manager for the application master’s address, and then caches it` so it doesn’t overload the resource manager with a request every time it needs to poll the application master. `If the application master fails, however, the client will experience a timeout when it issues a status update, at which point the client will go back to the resource manager to ask for the new application master’s address`.

#### Node Manager Failure
If a node manager fails by crashing or running very slowly, it will stop sending heartbeats to the resource manager (or send them very infrequently). The resource manager will notice a node manager that has stopped sending heartbeats if it hasn’t received one for 10 minutes (this is configured, in milliseconds, via the `yarn.resourcemanager.nm.liveness-monitor.expiry-interval-ms` property) and `remove it from its pool of nodes to schedule containers on`.  

`Any task or application master running on the failed node manager will be recovered using the mechanisms described in the previous two sections.` In addition, the application master arranges for map tasks that were run and completed successfully on the failed node manager to be rerun if they belong to incomplete jobs, since their intermediate output residing on the failed node manager’s local filesystem may not be accessible to the reduce task.  

Node managers may be blacklisted if the number of failures for the application is high, even if the node manager itself has not failed. `Blacklisting is done by the application master`, and for MapReduce the application master will try to reschedule tasks on different nodes if more than three tasks fail on a node manager. The user may set the threshold with the `mapreduce.job.maxtaskfailures.per.tracker` job property.  

`Note that the resource manager does not do blacklisting across applications` (at the time of writing), so tasks from new jobs may be scheduled on bad nodes even if they have been blacklisted by an application master running an earlier job.

#### Resource Manager Failure
`In the default configuration, the resource manager is a single point of failure`, since in the (unlikely) event of machine failure, all running jobs fail—and `can’t be recovered`.  

`To achieve high availability (HA), it is necessary to run a pair of resource managers in an active-standby configuration`. If the active resource manager fails, then the standby can take over without a significant interruption to the client.

`Information about all the running applications is stored in a highly available state store (backed by ZooKeeper or HDFS)`, so that the standby can recover the core state of the failed active resource manager. Node manager information is not stored in the state store since it can be reconstructed relatively quickly by the new resource manager as the node managers send their first heartbeats. (Note also that tasks are not part of the resource manager’s state, since they are managed by the application master. Thus, the amount of state to be stored is therefore much more manageable than that of the jobtracker in MapReduce 1.)

When the new resource manager starts, it reads the application information from the state store, then `restarts the application masters for all the applications running on the cluster`. In practice, the application master restart is not an issue for MapReduce applications since they recover the work done by completed tasks.

The transition of a resource manager from standby to active is handled by a `failover controller`. The default failover controller is an automatic one, which uses `ZooKeeper leader election` to ensure that there is only a single active resource manager at one time. Unlike in HDFS HA (see “HDFS High Availability” on page 48), the failover controller does not have to be a standalone process, and is embedded in the resource manager by default for ease of configuration. It is also possible to configure manual failover, but this is not recommended.

`Clients and node managers` must be configured to handle resource manager failover, since there are now two possible resource managers to communicate with. They `try connecting to each resource manager in a round-robin fashion until they find the active one`. If the active fails, then they will retry until the standby becomes active.

### Shuffle and Sort
MapReduce makes the guarantee that the input to every reducer is sorted by key. The process by which the system performs the sort—and transfers the map outputs to the reducers as inputs—is known as the shuffle.  

The shuffle is an area of the codebase where refinements and improvements are continually being made, so the following description necessarily conceals many details. In many ways, the shuffle is the heart of MapReduce and is where the “magic” happens.


#### The Map Side
![hadoop_shuffle_process_img_1]  
When the map function starts producing output, it is not simply written to disk. The process is more involved, and takes advantage of buffering writes in memory and doing some presorting for efficiency reasons.

Each map task has a `circular memory buffer` that it writes the output to. The buffer is 100 MB by default (the size can be tuned by changing the `mapreduce.task.io.sort.mb` property). When the contents of the buffer reach a certain threshold size (`mapreduce.map.sort.spill.percent`, which has the default value 0.80, or 80%), a background thread will start to spill the contents to disk. `Map outputs will continue to be written to the buffer while the spill takes place`, but if the buffer fills up during this time, the map will block until the spill is complete. Spills are written in round-robin fashion to the directories specified by the `mapreduce.cluster.local.dir` property, in a job specific subdirectory.

Before it writes to disk, the thread first divides the data into partitions corresponding to the reducers that they will ultimately be sent to. Within each partition, the background thread performs an in-memory sort by key, and if there is a `combiner function`, it is run on the output of the sort. Running the combiner function makes for a more compact map output, so there is less data to write to local disk and to transfer to the reducer.

Each time the memory buffer reaches the spill threshold, a new spill file is created, so after the map task has written its last output record, there could be several spill files. Before the task is finished, `the spill files are merged into a single partitioned and sorted output file`. The configuration property `mapreduce.task.io.sort.factor` controls the maximum number of streams to merge at once; the default is 10.  

If there are at least three spill files (set by the `mapreduce.map.combine.minspills` property), the `combiner` is run again before the output file is written. Recall that combiners may be run repeatedly over the input without affecting the final result.

It is often a good idea to compress the map output as it is written to disk, by default, the output is not compressed, but it is easy to enable this by setting `mapreduce.map.output.compress` to true. The compression library to
use is specified by `mapreduce.map.output.compress.codec`.

The output file’s partitions are made available to the reducers over HTTP. The maximum number of worker threads used to serve the file partitions is controlled by the `mapreduce.shuffle.max.threads` property; this setting is per node manager, not per map task. The default of 0 sets the maximum number of threads to twice the number of processors on the machine.

#### The Reduce Side
1. copy phrase  
The map output file is sitting on the local disk of the machine that ran the map task (note that although map outputs always get written to local disk, reduce outputs may not be). The reduce task needs the map output for its particular partition from several map tasks across the cluster. `The map tasks may finish at different times, so the reduce task starts copying their outputs as soon as each completes`. This is known as the copy phase of the reduce task.  
The reduce task has a small number of copier threads so that it can fetch map outputs in parallel. The default is 5 threads, but this number can be changed by setting the `mapreduce.reduce.shuffle.parallelcopies` property.  
How do reducers know which machines to fetch map output from?  
As map tasks complete successfully, they notify their `application master` using the heartbeat mechanism. Therefore, for a given job, the `application master knows the mapping between map outputs and hosts`. `A thread in the reducer periodically asks the master for map output hosts` until it has retrieved them all. Hosts do not delete map outputs from disk as soon as the first reducer has retrieved them, as the reducer may subsequently fail. Instead, they wait until they are told to delete them by the application master, which is after the job has completed.  
Map outputs are copied to the reduce task JVM’s memory if they are small enough (the buffer’s size is controlled by `mapreduce.reduce.shuffle.input.buffer.percent`, which specifies the proportion of the heap to use for this purpose); otherwise, they are copied to disk. When the in-memory buffer reaches a threshold size (controlled by `mapreduce.reduce.shuffle.merge.percent`) or reaches a threshold number of map outputs (`mapreduce.reduce.merge.inmem.threshold`), it is `merged` and spilled to disk. If a `combiner` is specified, it will be run during the merge to reduce the amount of data written to disk.  
As the copies accumulate on disk, a background thread merges them into larger, sorted files. This saves some time merging later on. `Note that any map outputs that were compressed (by the map task) have to be decompressed in memory in order to perform a merge on them.`  
2. sort phrase  
`When all the map outputs have been copied, the reduce task moves into the sort phase` (which should properly be called the merge phase, as the sorting was carried out on the map side), which merges the map outputs, maintaining their sort ordering. This is done in rounds. For example, if there were 50 map outputs and the **merge factor** was 10 (the default, controlled by the `mapreduce.task.io.sort.factor` property, just like in the map’s merge), there would be five rounds. Each round would merge 10 files into 1, so at the end there would be 5 intermediate files.  
The number of files merged in each round is actually more subtle than this example suggests. `The goal is to merge the minimum number of files to get to the merge factor for the final round`. So if there were 40 files, the merge would not merge 10 files in each of the four rounds to get 4 files. Instead, the first round would merge only 4 files, and the subsequent three rounds would merge the full 10 files. The 4 merged files and the 6 (as yet unmerged) files make a total of 10 files for the final round. The process is illustrated in Figure 7-5. Note that this does not change the number of rounds; `it’s just an optimization to minimize the amount of data that is written to disk`, since `the final round always merges directly into the reduce`.
3. reduce phrase  
Rather than have a final round that merges these five files into a single sorted file, the merge `saves a trip to disk` by directly feeding the reduce function in what is the last phase: the reduce phase. This final merge can come from `a mixture of in-memory and on-disk segments`.  
During the reduce phase, the reduce function is invoked for each key in the sorted output. `The output of this phase is written directly to the output filesystem, typically HDFS`. In the case of HDFS, because the node manager is also running a datanode, the first block replica will be written to the local disk.  

#### Configuration Tuning
The relevant settings, which can be used on a per-job basis (except where noted), are summarized in Tables 7-1 and 7-2, along with the defaults, which are good for general-purpose jobs.  

`The general principle is to give the shuffle as much memory as possible`. `However, there is a trade-off, in that you need to make sure that your map and reduce functions get enough memory to operate. This is why it is best to write your map and reduce functions to use as little memory as possible`—certainly they should not use an unbounded amount of memory (avoid accumulating values in a map, for example).

The amount of memory given to the JVMs in which the map and reduce tasks run is set by the `mapred.child.java.opts` property. You should try to make this as large as possible for the amount of memory on your task nodes;  

`On the map side, the best performance can be obtained by avoiding multiple spills to disk; one is optimal`. If you can estimate the size of your map outputs, you can set the mapreduce.task.io.sort.* properties appropriately to minimize the number of spills. In particular, you should increase `mapreduce.task.io.sort.mb` if you can. There is a MapReduce counter, SPILLED_RECORDS, for both map and reduce phrases.  

In April 2008, Hadoop won the general-purpose terabyte sort benchmark, and `one of the optimizations used was keeping the intermediate data in memory on the reduce side`. 

More generally, Hadoop uses a buffer size of 4 KB by default, which is low, so you should increase this across the cluster (by setting `io.file.buffer.size`; see also “Other Hadoop Properties” on page 307).  

**Table 7-1. Map-side tuning properties**  

Property name                   |Default |Description
--------------------------------|--------|-------------------------------------
mapreduce.task.io.sort.mb       |100     |The size, in megabytes, of the memory buffer to use while sorting map output.  
mapreduce.map.sort.spill.percent|0.80    |The threshold usage proportion for both the map output memory buffer and the record boundaries index to start the process of spilling to disk.  
mapreduce.task.io.sort.factor   |10      |The maximum number of streams to merge at once when sorting files. This property is also used in the reduce. It’s fairly common to increase this to 100.  
mapreduce.map.combine.minspills |3       |The minimum number of spill files needed for the combiner to run (if a combiner is specified).  
mapreduce.map.output.compress   |false   |Whether to compress map outputs.  
mapreduce.map.output.compress.codec |org.apache.hadoop.io.compress.DefaultCodec |The compression codec to use for map outputs.  
mapreduce.shuffle.max.threads   |0       |The number of worker threads per node manager for serving the map outputs to reducers. This is a cluster-wide setting and cannot be set by individual jobs. 0 means use the Netty default of twice the number of available processors.  

**Table 7-2. Reduce-side tuning properties**  

Property name                                   |Default |Description
------------------------------------------------|--------|---------------------
mapreduce.reduce.shuffle.parallelcopies         |5       |The number of threads used to copy map outputs to the reducer.  
mapreduce.reduce.shuffle.maxfetchfailures       |10      |The number of times a reducer tries to fetch a map output before reporting the error.  
mapreduce.task.io.sort.factor                   |10      |The maximum number of streams to merge at once when sorting files. This property is also used in the map.  
mapreduce.reduce.shuffle.input.buffer.percent   |0.70    |The proportion of total heap size to be allocated to the map outputs buffer during the copy phase of the shuffle.  
mapreduce.reduce.shuffle.merge.percent          |0.66    |The threshold usage proportion for the map outputs buffer (defined by mapred.job.shuffle.input.buffer.percent) for starting the process of merging the outputs and spilling to disk.  
mapreduce.reduce.merge.inmem.threshold          |1000    |The threshold number of map outputs for starting the process of merging the outputs and spilling to disk. A value of 0 or less means there is no threshold, and the spill behavior is governed solely by mapreduce.reduce.shuffle.merge.percent.  
mapreduce.reduce.input.buffer.percent           |0.0     |The proportion of total heap size to be used for retaining map outputs in memory during the reduce. For the reduce phase to begin, the size of map outputs in memory must be no more than this size. `By default, all map outputs are merged to disk before the reduce begins, to give the reducers as much memory as possible`. However, if your reducers require less memory, this value may be increased to minimize the number of trips to disk.

### Task Execution
#### The Task Execution Environment
Hadoop provides information to a map or reduce task about the environment in which it is running, such as job id, task id, attempt id, partition id and so forth, through Context interface. 

##### Streaming environment variables
Hadoop sets job configuration parameters as environment variables for Streaming programs. However, it replaces nonalphanumeric characters with underscores to make sure they are valid names. The following Python expression illustrates how you can retrieve the value of the mapreduce.job.id property from within a Python Streaming script:  
```python
os.environ["mapreduce_job_id"] 
```
You can also set environment variables for the Streaming processes launched by Map‐Reduce by supplying the -cmdenv option to the Streaming launcher program (once for each variable you wish to set). For example, the following sets the MAGIC_PARAMETER environment variable:  
```shell
-cmdenv MAGIC_PARAMETER=abracadabra
```

#### Speculative Execution
The MapReduce model is to break jobs into tasks and run the tasks in parallel to make the overall job execution time smaller than it would be if the tasks ran sequentially. `This makes the job execution time sensitive to slow-running tasks`, as it takes only one slow task to make the whole job take significantly longer than it would have done otherwise. When a job consists of hundreds or thousands of tasks, the possibility of a few straggling tasks is very real.

Tasks may be slow for various reasons, including hardware degradation or software misconfiguration, but the causes may be hard to detect because the tasks still complete successfully, albeit after a longer time than expected. Hadoop doesn’t try to diagnose and fix slow-running tasks; instead, it tries to detect when a task is running slower than expected and launches another equivalent task as a backup. This is termed `speculative execution` of tasks.  

It’s important to understand that speculative execution does not work by launching two duplicate tasks at about the same time so they can race each other. This would be wasteful of cluster resources. Rather, `the scheduler tracks the progress of all tasks of the same type (map and reduce) in a job, and only launches speculative duplicates for the small proportion that are running significantly slower than the average`. `When a task completes successfully, any duplicate tasks that are running are killed` since they are no longer needed. So, if the original task completes before the speculative task, the speculative task is killed; on the other hand, if the speculative task finishes first, the original is killed.  

Speculative execution is turned on by default. It can be enabled or disabled independently
for map tasks and reduce tasks, on a cluster-wide basis, or on a per-job basis.

* mapreduce.map.speculative
* mapreduce.reduce.speculative
* yarn.app.mapreduce.am.job.speculator.class  
org.apache.hadoop.mapreduce.v2.app.speculate.DefaultSpeculator
* yarn.app.mapreduce.am.job.task.estimator.class  
org.apache.hadoop.mapreduce.v2.app.speculate.LegacyTaskRuntimeEstimator

Why would you ever want to turn speculative execution off?  
* On a busy cluster, speculative execution can reduce overall throughput  
The goal of speculative execution is to reduce job execution time, but this comes at the cost of cluster efficiency. On a busy cluster, speculative execution can reduce overall throughput, since redundant tasks are being executed in an attempt to bring down the execution time for a single job. For this reason, `some cluster administrators prefer to turn it off on the cluster and have users explicitly turn it on for individual jobs. This was especially relevant for older versions of Hadoop, when speculative execution could be overly aggressive in scheduling speculative tasks`.  
* There is a good case for turning off speculative execution for reduce tasks  since any duplicate reduce tasks have to fetch the same map outputs as the original task, and this can significantly increase network traffic on the cluster.  
* Another reason for turning off speculative execution is for nonidempotent tasks.  
`However, in many cases it is possible to write tasks to be idempotent and use an OutputCommitter to promote the output to its final location when the task succeeds`.  

#### Output Committers
Hadoop MapReduce uses a commit protocol to ensure that jobs and tasks either succeed or fail cleanly. The behavior is implemented by the OutputCommitter in use for the job, which is set in the old MapReduce API by calling the setOutputCommitter() on JobConf or by setting `mapred.output.committer.class` in the configuration. `In the new MapReduce API, the OutputCommitter is determined by the OutputFormat`, via its getOutputCommitter() method. The default is FileOutputCommitter, which is appropriate for file-based MapReduce.  
```java
public abstract class OutputCommitter {
    public abstract void setupJob(JobContext jobContext) throws IOException;
    public void commitJob(JobContext jobContext) throws IOException { }
    public void abortJob(JobContext jobContext, JobStatus.State state)
    throws IOException { }
    public abstract void setupTask(TaskAttemptContext taskContext)
    throws IOException;
    public abstract boolean needsTaskCommit(TaskAttemptContext taskContext)
    throws IOException;
    public abstract void commitTask(TaskAttemptContext taskContext)
    throws IOException;
    public abstract void abortTask(TaskAttemptContext taskContext)
    throws IOException;
}
```

The framework ensures that in the event of multiple task attempts for a particular task, only one will be committed; the others will be aborted.

The setupJob() method is called before the job is run, and is typically used to perform initialization. For FileOutputCommitter, the method creates the final output directory, `${mapreduce.output.fileoutputformat.outputdir}`, and a temporary working space for task output, _temporary, as a subdirectory underneath it. 

If the job succeeds, the commitJob() method is called, which in the default file-based implementation deletes the temporary working space and` creates a hidden empty marker file in the output directory called _SUCCESS to indicate to filesystem clients that the job completed successfully`. If the job did not succeed, abortJob() is called with a state object indicating whether the job failed or was killed (by a user, for example). In the default implementation, this will delete the job’s temporary working space.

The operations are similar at the task level. The setupTask() method is called before the task is run, and the default implementation doesn’t do anything.

The commit phase for tasks is optional and may be disabled by returning false from needsTaskCommit(). `This saves the framework from having to run the distributed commit protocol for the task`, and neither commitTask() nor abortTask() is called. FileOutputCommitter will skip the commit phase when no output has been written by a task. 

If a task succeeds, commitTask() is called, which in the default implementation moves the temporary task output directory (which has the task attempt ID in its name to avoid conflicts between task attempts) to the final output path, `${mapreduce.output.fileoutputformat.outputdir}`. Otherwise, the framework calls abortTask(), which deletes the temporary task output directory.

The usual way of writing output from map and reduce tasks is by using **OutputCollector** to collect key-value pairs. Some applications need more flexibility than a single key-value pair model, so these applications write output files directly from the map or reduce task to a distributed filesystem, such as HDFS.

Care needs to be taken to ensure that multiple instances of the same task don’t try to write to the same file. As we saw in the previous section, the OutputCommitter protocol solves this problem. If applications write side files in their tasks’ working directories, the side files for tasks that successfully complete will be promoted to the output directory automatically, whereas failed tasks will have their side files deleted. 

A task may find its working directory by retrieving the value of the `mapreduce.task.output.dir` property from the job configuration. Alternatively, a MapReduce program using the Java API may call the getWorkOutputPath() static method on FileOutputFormat to get the Path object representing the working directory. The framework creates the working directory before executing the task, so you don’t need to create it.

## 8. MapReduce Types and Formats
### MapReduce Types
The map and reduce functions in Hadoop MapReduce have the following general form:   
```scala
map: (K1, V1) → list(K2, V2)  
reduce: (K2, list(V2)) → list(K3, V3)  
```

The Java API mirrors this general form:  
```java
public class Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    public class Context extends MapContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
        // ...
    }
    protected void map(KEYIN key, VALUEIN value,
        Context context) throws IOException, InterruptedException {
        // ...
    }
}
public class Reducer<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    public class Context extends ReducerContext<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
        // ...
    }
    protected void reduce(KEYIN key, Iterable<VALUEIN> values,
        Context context) throws IOException, InterruptedException {
        // ...
    }
}
```
The context objects are used for emitting key-value pairs, and they are parameterized by the output types so that the signature of the write() method is:  
```java
public class Context<...> {
    public void write(KEYOUT key, VALUEOUT value)
    throws IOException, InterruptedException;
}
```

If a combiner function is used,   
```scala
map: (K1, V1) → list(K2, V2)
combiner: (K2, list(V2)) → list(K2, V2)
reduce: (K2, list(V2)) → list(K3, V3)
```
Often the combiner and reduce functions are the same, in which case K3 is the same as K2, and V3 is the same as V2.  

The partition function `operates on the intermediate key and value types` (K2 and V2) and returns the partition index. In practice, the partition is determined solely by the key (the value is ignored):
```scala
partition: (K2, V2) → integer
```
Or in Java:  
```java
public abstract class Partitioner<KEY, VALUE> {
    public abstract int getPartition(KEY key, VALUE value, int numPartitions);
}
```

It may seem strange that these methods for setting the intermediate and final output types exist at all. After all, why can’t the types be determined from a combination of the mapper and the reducer? The answer has to do with a limitation in Java generics: type erasure means that the type information isn’t always present at runtime, so Hadoop has to be given it explicitly. This also means that it’s possible to configure a MapReduce job with incompatible types, because the configuration isn’t checked at compile time.

#### The Default MapReduce Job
What happens when you run MapReduce without setting a mapper or a reducer?  
```java
public class MinimalMapReduce extends Configured implements Tool {
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 2) {
            System.err.printf("Usage: %s [generic options] <input> <output>\n",
                getClass().getSimpleName());
            ToolRunner.printGenericCommandUsage(System.err);
            return -1;
        }
        Job job = new Job(getConf());
        job.setJarByClass(getClass());
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MinimalMapReduce(), args);
        System.exit(exitCode);
    }
}
```
Example 8-1 shows a program that has exactly the same effect as MinimalMapReduce, but explicitly sets the job settings to their defaults.  

**Example 8-1. A minimal MapReduce driver, with the defaults explicitly set**  
```java
public class MinimalMapReduceWithDefaults extends Configured implements Tool {
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setInputFormatClass(TextInputFormat.class);
        job.setMapperClass(Mapper.class);
        job.setMapOutputKeyClass(LongWritable.class);
        job.setMapOutputValueClass(Text.class);
        job.setPartitionerClass(HashPartitioner.class);
        job.setNumReduceTasks(1);
        job.setReducerClass(Reducer.class);
        job.setOutputKeyClass(LongWritable.class);
        job.setOutputValueClass(Text.class);
        job.setOutputFormatClass(TextOutputFormat.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MinimalMapReduceWithDefaults(), args);
        System.exit(exitCode);
    }
}
public class JobBuilder {
    public static Job parseInputAndOutput(Tool tool, Configuration conf,
        String[] args) throws IOException {
        if (args.length != 2) {
            printUsage(tool, "<input> <output>");
            return null;
        }
        Job job = new Job(conf);
        job.setJarByClass(tool.getClass());
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        return job;
    }
    public static void printUsage(Tool tool, String extraArgsUsage) {
        System.err.printf("Usage: %s [genericOptions] %s\n\n",
            tool.getClass().getSimpleName(), extraArgsUsage);
        GenericOptionsParser.printGenericCommandUsage(System.err);
    }
}
```

The default input format is TextInputFormat, which produces keys of type LongWritable (the offset of the beginning of the line in the file) and values of type Text (the line of text).

The default mapper is just the Mapper class, which writes the input key and value unchanged to the output:  
```java
public class Mapper<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    protected void map(KEYIN key, VALUEIN value,
        Context context) throws IOException, InterruptedException {
        context.write((KEYOUT) key, (VALUEOUT) value);
    }
}
```
The default partitioner is HashPartitioner, which hashes a record’s key to determine which partition the record belongs in. `Each partition is processed by a reduce task`:  
```java
public class HashPartitioner<K, V> extends Partitioner<K, V> {
    public int getPartition(K key, V value,
        int numReduceTasks) {
        return (key.hashCode() & Integer.MAX_VALUE) % numReduceTasks;
    }
}
```
`You may have noticed that we didn’t set the number of map tasks`. `The reason for this is that the number is equal to the number of splits that the input is turned into, which is driven by the size of the input and the file’s block size (if the file is in HDFS)`.

The default reducer is Reducer, again a generic type, which simply writes all its input to its output:  
```java
public class Reducer<KEYIN, VALUEIN, KEYOUT, VALUEOUT> {
    protected void reduce(KEYIN key, Iterable<VALUEIN> values, Context context
        Context context) throws IOException, InterruptedException {
        for (VALUEIN value: values) {
            context.write((KEYOUT) key, (VALUEOUT) value);
        }
    }
}
```
The default output format is TextOutputFormat, which writes out records, one per line, by converting keys and values to strings and separating them with a tab character. This is why the output is tab-separated: it is a feature of TextOutputFormat.

##### The default Streaming job
In Streaming, the default job is similar, but not identical, to the Java equivalent. The basic form is:  
```shell
$ hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
-input input/ncdc/sample.txt \
-output output \
-mapper /bin/cat
```
When we specify a non-Java mapper and the default text mode is in effect (-io text), Streaming does something special. It doesn’t pass the key to the mapper process; it just passes the value. (For other input formats, the same effect can be achieved by setting stream.map.input.ignoreKey to true.) This is actually very useful because the key is just the line offset in the file and the value is the line, which is all most applications are interested in. The overall effect of this job is to perform a sort of the input.  

With more of the defaults spelled out, the command looks like this (notice that Streaming uses the old MapReduce API classes):  
```shell
$ hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
    -input input/ncdc/sample.txt \
    -output output \
    -inputformat org.apache.hadoop.mapred.TextInputFormat \
    -mapper /bin/cat \
    -partitioner org.apache.hadoop.mapred.lib.HashPartitioner \
    -numReduceTasks 1 \
    -reducer org.apache.hadoop.mapred.lib.IdentityReducer \
    -outputformat org.apache.hadoop.mapred.TextOutputFormat
    -io text
```
The -mapper and -reducer arguments take a command or a Java class. A combiner may optionally be specified using the -combiner argument.

##### Keys and values in Streaming
A Streaming application can control the separator that is used when a key-value pair is turned into a series of bytes and sent to the map or reduce process over standard input. The default is a tab character, but it is useful to be able to change it in the case that the keys or values themselves contain tab characters.

Similarly, when the map or reduce writes out key-value pairs, they may be separated by a configurable separator. Furthermore, the key from the output can be composed of more than the first field: it can be made up of the first n fields (defined by `stream.num.map.output.key.fields` or `stream.num.reduce.output.key.fields`), with the value being the remaining fields.

![hadoop_stream_mr_data_flow_img_1]  

### Input Formats
Hadoop can process many different types of data formats, from flat text files to databases.  

#### Input Splits and Records 
Input splits are represented by the Java class InputSplit  
```java
public abstract class InputSplit {
    public abstract long getLength() throws IOException, InterruptedException;
    public abstract String[] getLocations() throws IOException,
    InterruptedException;
}
```

An InputSplit has a length in bytes and a set of storage locations, which are just hostname strings. Notice that a split doesn’t contain the input data; it is just a reference to the data. The storage locations are used by the MapReduce system to place map tasks as close to the split’s data as possible, and `the size is used to order the splits so that the largest get processed first`, in an attempt to minimize the job runtime (this is an instance of a greedy approximation algorithm).  

`As a MapReduce application writer, you don’t need to deal with InputSplits directly, as they are created by an InputFormat` (an InputFormat is responsible for creating the input splits and dividing them into records).
```java
public abstract class InputFormat<K, V> {
    public abstract List<InputSplit> getSplits(JobContext context)
        throws IOException, InterruptedException;
    public abstract RecordReader<K, V>
        createRecordReader(InputSplit split, TaskAttemptContext context)
        throws IOException, InterruptedException;
}
```
The `client` running the job calculates the splits for the job by calling getSplits()(PS: should be JobSubmitter invoking getSplits()), then sends them to the `application master`, which uses their storage locations to schedule map tasks that will process them on the cluster. `The map task` passes the split to the createRecordReader() method on InputFormat to obtain a RecordReader for that split. A RecordReader is little more than an iterator over records, and the map task uses one to generate record key-value pairs, which it passes to the map function. We can see this by looking at the Mapper’s run() method:  
```java
public void run(Context context) throws IOException, InterruptedException {
    setup(context);
    while (context.nextKeyValue()) {
        map(context.getCurrentKey(), context.getCurrentValue(), context);
    }
    cleanup(context);
}
```

Although it’s not shown in the code snippet, for reasons of efficiency, `RecordReader implementations will return the same key and value objects on each call to getCurrentKey() and getCurrentValue(). Only the contents of these objects are changed by the reader’s nextKeyValue() method.` This can be a surprise to users, who might expect keys and values to be immutable and not to be reused. This causes problems when a reference to a key or value object is retained outside the map() method, as its value can change without warning. If you need to do this, make a copy of the object you want to hold on to. For example, for a Text object, you can use its copy constructor: new Text(value).   
The situation is similar with reducers. In this case, the value objects in the reducer’s iterator are reused, so you need to copy any that you need to retain between calls to the iterator (see Example 9-11)  
**Example 9-11. Reducer for joining tagged station records with tagged weather records**  
```java
public class JoinReducer extends Reducer<TextPair, Text, Text, Text> {
    @Override
    protected void reduce(TextPair key, Iterable<Text> values, Context context)
    throws IOException, InterruptedException {
        Iterator<Text> iter = values.iterator();
        Text stationName = new Text(iter.next());
        while (iter.hasNext()) {
            Text record = iter.next();
            Text outValue = new Text(stationName.toString() + "\t" + record.toString());
            context.write(key.getFirst(), outValue);
        }
    }
}
```

**MultithreadedMapper** is an implementation that runs mappers concurrently in a configurable number of threads (set by `mapreduce.mapper.multithreadedmapper.threads`). For most data processing tasks, it confers no advantage over the default implementation. However, for mappers that spend a long time processing each record —because they contact external servers, for example—it allows multiple mappers to run in one JVM with little contention.

**FileInputFormat** is the base class for all implementations of InputFormat that use files as their data source (see Figure 8-2). It provides two things: a place to define which files are included as the input to a job, and an implementation for generating splits for the input files. The job of dividing splits into records is performed by subclasses.    

![hadoop_inputformat_class_hierarchy_img_1]  

**Given a set of files, how does FileInputFormat turn them into splits?**   
FileInputFormat splits only large files—here, “large” means larger than an HDFS block. `The split size is normally the size of an HDFS block`, which is appropriate for most applications; however, it is possible to control this value by setting various Hadoop properties,  
1. mapreduce.input.fileinputformat.split.minsize
2. mapreduce.input.fileinputformat.split.maxsize
3. dfs.blocksize

The split size is calculated by the following formula (see the computeSplitSize() method in FileInputFormat):  
max(minimumSize, min(maximumSize, blockSize))  
and by default:  
minimumSize < blockSize < maximumSize  
so the split size is blockSize.  

##### Preventing splitting
There are a couple of ways to ensure that an existing file is not split.  
1. The first (quick -and- dirty) way is to increase the minimum split size to be larger than the largest file in your system.  
Setting it to its maximum value, Long.MAX_VALUE, has this effect. 
2. The second is to subclass the concrete subclass of FileInputFormat that you want to use, to override the isSplitable() method to return false.  
```java
public class NonSplittableTextInputFormat extends TextInputFormat {
    @Override
    protected boolean isSplitable(JobContext context, Path file) {
        return false;
    }
}
```

#### Text Input
Hadoop excels at processing unstructured text.  

##### TextInputFormat
TextInputFormat is the default InputFormat. Each record is a line of input. The key, a LongWritable, is the byte offset within the file of the beginning of the line. The value is the contents of the line, excluding any line terminators (e.g., newline or carriage return), and is packaged as a Text object.

The logical records that FileInputFormats define usually do not fit neatly into HDFS blocks. For example, a TextInputFormat’s logical records are lines, which will cross HDFS boundaries more often than not. This has no bearing on the functioning of your program—lines are not missed or broken, for example—but `it’s worth knowing about because it does mean that data-local maps (that is, maps that are running on the same host as their input data) will perform some remote reads.` The slight overhead this causes is not normally significant.

##### KeyValueTextInputFormat
It is common for each line in a file to be a key-value pair, separated by a delimiter such as a tab character. For example, this is the kind of output produced by TextOutputFormat, Hadoop’s default OutputFormat. To interpret such files correctly, KeyValueTextInputFormat is appropriate.

##### NLineInputFormat
With TextInputFormat and KeyValueTextInputFormat, each mapper receives a variable number of lines of input. The number depends on the size of the split and the length of the lines. If you want your mappers to receive a fixed number of lines of input, then NLineInputFormat is the InputFormat to use. Like with TextInputFormat, the keys are the byte offsets within the file and the values are the lines themselves.

Usually, having a map task for a small number of lines of input is inefficient (due to the overhead in task setup), but there are applications that take a small amount of input data and run an extensive (i.e., CPU-intensive) computation for it, then emit their output. Simulations are a good example. By creating an input file that specifies input parameters, one per line, you can perform a parameter sweep: run a set of simulations in parallel to find how a model varies as the parameter changes.  

If you have long-running simulations, you may fall afoul of task timeouts. When a task doesn’t report progress for more than 10 minutes, the application master assumes it has failed and aborts the process. The best way to guard against this is to report progress periodically, by writing a status message or incrementing a counter, for example.

Another example is using Hadoop to bootstrap data loading from multiple data
sources, such as databases.

##### XML
Hadoop comes with a class for this purpose called **StreamXmlRecordReader** (which is in the org.apache.hadoop.streaming.mapreduce package, although it can be used outside of Streaming). You can use it by setting your input format to StreamInputFormat and setting the stream.recordreader.class property to org.apache.hadoop.streaming.mapreduce.StreamXmlRecordReader. The reader is configured by setting job configuration properties to tell it `the patterns for the start and end tags`.  

See Mahout’s XmlInputFormat for an improved XML input format.

#### Binary Input

##### SequenceFileInputFormat
Hadoop’s sequence file format stores sequences of binary key-value pairs. Sequence files are well suited as a format for MapReduce data because they are splittable (they have sync points so that readers can synchronize with record boundaries from an arbitrary point in the file, such as the start of a split), they support compression as a part of the format, and they can store arbitrary types using a variety of serialization frameworks. (These topics are covered in “SequenceFile” on page 127.)

To use data from sequence files as the input to MapReduce, you can use SequenceFileInputFormat. The keys and values are determined by the sequence file, and you need to make sure that your map input types correspond. SequenceFileInputFormat can read map files as well as sequence files.  

##### SequenceFileAsTextInputFormat
SequenceFileAsTextInputFormat is a variant of SequenceFileInputFormat that `converts the sequence file’s keys and values to Text objects`. The conversion is performed `by calling toString()` on the keys and values. `This format makes sequence files suitable input for Streaming`.

##### SequenceFileAsBinaryInputFormat
SequenceFileAsBinaryInputFormat is a variant of SequenceFileInputFormat that `retrieves the sequence file’s keys and values as opaque binary objects`. They are encapsulated as **BytesWritable** objects, and the application is free to interpret the underlying byte array as it pleases. In combination with a process that creates sequence files with SequenceFile.Writer’s appendRaw() method or SequenceFileAsBinaryOutputFormat, this provides a way to use any binary data types with MapReduce (packaged as a sequence file), although plugging into Hadoop’s serialization mechanism is normally a cleaner alternative.

##### FixedLengthInputFormat  
FixedLengthInputFormat is for reading fixed-width `binary records` from a file, when the records are not separated by delimiters. The record size must be set via `fixedlengthinputformat.record.length`.

#### Multiple Inputs
What often happens, however, is that the data format evolves over time, so you have to write your mapper to cope with all of your legacy formats. Or you may have data sources that provide the same type of data but in different formats. This arises in the case of performing joins of different datasets; These cases are handled elegantly by using the **MultipleInputs** class, which allows you `to specify which InputFormat and Mapper to use on a per-path basis`.

#### Database Input (and Output)
DBInputFormat is an input format for reading data from a relational database, using JDBC. Because it doesn’t have any sharding capabilities, you need to be careful not to overwhelm the database from which you are reading by running too many mappers. For this reason, it is best used for loading relatively small datasets, perhaps for joining with larger datasets from HDFS using MultipleInputs.  

The corresponding output format is DBOutputFormat, which is useful for dumping job outputs (of modest size) into a database. 

For an alternative way of moving data between relational databases and HDFS, consider using **Sqoop**, which is described in Chapter 15. 

HBase’s **TableInputFormat** is designed to allow a MapReduce program to operate on data stored in an **HBase** table. TableOutputFormat is for writing MapReduce outputs into an HBase table.

### Output Formats
![hadoop_outputformat_class_hierarchy_img_1]  

#### Text Output
The default output format, TextOutputFormat, writes records as lines of text. `Its keys and values may be of any type, since TextOutputFormat turns them to strings by calling toString() on them`. Each key-value pair is separated by a tab character, although that may be changed using the `mapreduce.output.textoutputformat.separator property`.

You can suppress the key or the value from the output (or both, making this output format equivalent to NullOutputFormat, which emits nothing) using a NullWritable type. This also causes no separator to be written

#### Binary Output
##### SequenceFileOutputFormat
As the name indicates, SequenceFileOutputFormat writes sequence files for its output. This is a good choice of output if it forms the input to a further MapReduce job, since it is compact and is readily compressed. Compression is controlled via the static methods on SequenceFileOutputFormat.  

##### SequenceFileAsBinaryOutputFormat
SequenceFileAsBinaryOutputFormat—the counterpart to SequenceFileAsBinaryInputFormat—writes keys and values in raw binary format into a sequence file container.  

##### MapFileOutputFormat  
MapFileOutputFormat writes map files as output. `The keys in a MapFile must be added in order, so you need to ensure that your reducers emit keys in sorted order`.

##### Multiple Outputs
Sometimes there is a need to have `more control over the naming of the files` or to `produce multiple files per reducer`. MapReduce comes with the MultipleOutputs class to help you do this.  

`It is generally a bad idea to allow the number of partitions to be rigidly fixed by the application, since this can lead to small or unevensized partitions.`

`It is much better to let the cluster drive the number of partitions for a job, the idea being that the more cluster resources there are available, the faster the job can complete.` This is why the default HashPartitioner works so well: it works with any number of partitions and ensures each partition has a good mix of keys, leading to more evenly sized partitions.

###### MultipleOutputs  
MultipleOutputs allows you to write data to files whose names are derived from the output keys and values, or in fact from an arbitrary string. This allows each reducer (or mapper in a map-only job) to create more than a single file. Filenames are of the form `name-m-nnnnn` for map outputs and `name-r-nnnnn` for reduce outputs, where name is an arbitrary name that is set by the program and nnnnn is an integer designating the part number, starting from 00000.

```java
@Override
protected void reduce(Text key, Iterable<Text> values, Context context)
throws IOException, InterruptedException {
    for (Text value : values) {
        parser.parse(value);
        String basePath = String.format("%s/%s/part",
            parser.getStationId(), parser.getYear());
        multipleOutputs.write(NullWritable.get(), value, basePath);
    }
}

@Override
public int run(String[] args) throws Exception {
    // ...
    job.setMapperClass(StationMapper.class);
    job.setMapOutputKeyClass(Text.class);
    job.setReducerClass(MultipleOutputsReducer.class);
    job.setOutputKeyClass(NullWritable.class);
    return job.waitForCompletion(true) ? 0 : 1;
}
```

MultipleOutputs delegates to the mapper’s OutputFormat.

##### Lazy Output
FileOutputFormat subclasses will create output (part-r-nnnnn) files, even if they are empty. Some applications prefer that `empty files not be created, which is where LazyOutputFormat helps`. It is a wrapper output format that ensures that the output file is created only when the first record is emitted for a given partition. To use it, call its setOutputFormatClass() method with the JobConf and the underlying output format. 

Streaming supports a -lazyOutput option to enable LazyOutputFormat.

## 9. MapReduce Features
### Counters
#### Built-in Counters
Counters are divided into groups, and there are several groups for the built-in counters.  Each group either contains task counters (which are updated as a task progresses) or job counters (which are updated as a job progresses).  
* MapReduce task counters  
org.apache.hadoop.mapreduce.TaskCounter
* Job counters  
org.apache.hadoop.mapreduce.JobCounter
* Filesystem counters  
org.apache.hadoop.mapreduce.FileSystemCounter
* FileInputFormat counters  
org.apache.hadoop.mapreduce.lib.input.FileInputFormatCounter
* FileOutputFormat counters  
org.apache.hadoop.mapreduce.lib.output.FileOutputFormatCounter

##### Task counters
Task counters gather information about tasks over the course of their execution, and `the results are aggregated over all the tasks in a job`.  

Task counters are maintained by each task attempt, and periodically sent to the `application master` so they can be globally aggregated.  `Task counters are sent in full every time`, rather than sending the counts since the last transmission, since this guards against errors due to lost messages.

Counter values are definitive only once a job has successfully completed. However, some counters provide useful diagnostic information as a task is progressing, and it can be useful to monitor them with the web UI. For example, PHYSICAL_MEMORY_BYTES, VIRTUAL_MEMORY_BYTES, and COMMITTED_HEAP_BYTES provide an indication of how memory usage varies over the course of a particular task attempt.

##### Job counters
Job counters (Table 9-6) are maintained by the application master, so they don’t need to be sent across the network, unlike all other counters, including user-defined ones.  

#### User-Defined Java Counters
Counters are defined by a Java enum, which serves to group related counters. A job may define an arbitrary number of enums, each with an arbitrary number of fields. The name of the enum is the `group name`, and the enum’s fields are the `counter names`. `Counters are global`: the MapReduce framework aggregates them across all maps and reduces to produce a grand total at the end of the job.

```java
public class MaxTemperatureWithCounters extends Configured implements Tool {
    enum Temperature {
        MISSING,
        MALFORMED
    }
    static class MaxTemperatureMapperWithCounters
    extends Mapper<LongWritable, Text, Text, IntWritable> {
        private NcdcRecordParser parser = new NcdcRecordParser();
        @Override
        protected void map(LongWritable key, Text value, Context context)
        throws IOException, InterruptedException {
            parser.parse(value);
            if (parser.isValidTemperature()) {
                int airTemperature = parser.getAirTemperature();
                context.write(new Text(parser.getYear()),
                    new IntWritable(airTemperature));
            } else if (parser.isMalformedTemperature()) {
                System.err.println("Ignoring possibly corrupt input: " + value);
                context.getCounter(Temperature.MALFORMED).increment(1);
            } else if (parser.isMissingTemperature()) {
                context.getCounter(Temperature.MISSING).increment(1);
            }
            // dynamic counter
            // public Counter getCounter(String groupName, String counterName);
            context.getCounter("TemperatureQuality", parser.getQuality()).increment(1);
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        job.setMapperClass(MaxTemperatureMapperWithCounters.class);
        job.setCombinerClass(MaxTemperatureReducer.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MaxTemperatureWithCounters(), args);
        System.exit(exitCode);
    }
}
```

```html
Air Temperature Records
    Malformed=3
    Missing=66136856
TemperatureQuality
    0=1
    1=973422173
    2=1246032
    4=10764500
    5=158291879
    6=40066
    9=66136858
```
Notice that the counters for temperature have been made more readable by using a resource bundle named after the enum (using an underscore as a separator for nested classes)—in this case MaxTemperatureWithCounters_Temperature.properties, which contains the display name mappings.

`The two ways of creating and accessing counters—using enums and using strings`—are actually equivalent because Hadoop turns enums into strings to send counters over RPC. Enums are slightly easier to work with, provide type safety, and are suitable for most jobs. For the odd occasion when you need `to create counters dynamically, you can use the String interface`.

In addition to using the web UI and the command line (using mapred job -counter), you can retrieve counter values using the Java API. You can do this while the job is running, although it is more usual to get counters at the end of a job run, when they are stable.
```java
import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.util.*;
public class MissingTemperatureFields extends Configured implements Tool {
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 1) {
            JobBuilder.printUsage(this, "<job ID>");
            return -1;
        }
        String jobID = args[0];
        Cluster cluster = new Cluster(getConf());
        Job job = cluster.getJob(JobID.forName(jobID));
        // either because the ID was incorrectly specified or because the job is no longer in the job history.
        if (job == null) {
            System.err.printf("No job with ID %s found.\n", jobID);
            return -1;
        }
        if (!job.isComplete()) {
            System.err.printf("Job %s is not complete.\n", jobID);
            return -1;
        }
        Counters counters = job.getCounters();
        long missing = counters.findCounter(
            MaxTemperatureWithCounters.Temperature.MISSING).getValue();
        long total = counters.findCounter(TaskCounter.MAP_INPUT_RECORDS).getValue();
        System.out.printf("Records with missing temperature fields: %.2f%%\n",
            100.0 * missing / total);
        return 0;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MissingTemperatureFields(), args);
        System.exit(exitCode);
    }
}
```

#### User-Defined Streaming Counters
A Streaming MapReduce program can increment counters by `sending a specially formatted line to the standard error stream`, which is co-opted as a control channel in this case. The line must have the following format:   
```html
reporter:counter:group,counter,amount 
```
This snippet in Python shows how to increment the “Missing” counter in the “Temperature” group by 1:   
```python
sys.stderr.write("reporter:counter:Temperature,Missing,1\n")
```
In a similar way, a status message may be sent with a line formatted like this:   
```html
reporter:status:message
```

### Sorting
The ability to sort data is at the heart of MapReduce.  

Storing temperatures as Text objects doesn’t work for sorting purposes, because signed integers don’t sort lexicographically.  One commonly used workaround for this problem—particularly in text-based Streaming applications—is to add an offset to eliminate all negative numbers and to left pad with zeros so all numbers are the same number of characters(PS: perhaps by adding the absolute value of the largest negtive number) However, see “Streaming” on page 266 for another approach.

Example 9-3. A MapReduce program for transforming the weather data into SequenceFile format
```java
public class SortDataPreprocessor extends Configured implements Tool {
    static class CleanerMapper
    extends Mapper<LongWritable, Text, IntWritable, Text> {
        private NcdcRecordParser parser = new NcdcRecordParser();
        @Override
        protected void map(LongWritable key, Text value, Context context)
        throws IOException, InterruptedException {
            parser.parse(value);
            if (parser.isValidTemperature()) {
                context.write(new IntWritable(parser.getAirTemperature()), value);
            }
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setMapperClass(CleanerMapper.class);
        job.setOutputKeyClass(IntWritable.class);
        job.setOutputValueClass(Text.class);
        job.setNumReduceTasks(0);
        job.setOutputFormatClass(SequenceFileOutputFormat.class);
        SequenceFileOutputFormat.setCompressOutput(job, true);
        SequenceFileOutputFormat.setOutputCompressorClass(job, GzipCodec.class);
        SequenceFileOutputFormat.setOutputCompressionType(job,
            CompressionType.BLOCK);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new SortDataPreprocessor(), args);
        System.exit(exitCode);
    }
}
```

#### Controlling Sort Order
The sort order for keys is controlled by a RawComparator, which is found as follows:   
1. If the property `mapreduce.job.output.key.comparator.class` is set, either explicitly or by calling setSortComparatorClass() on Job, then an instance of that class is used. (In the old API, the equivalent method is setOutputKeyComparator Class() on JobConf.)   
2. Otherwise, keys must be a subclass of WritableComparable, and the registered comparator for the key class is used.   
```java
RawComparator<IntWritable> comparator =
WritableComparator.get(IntWritable.class);
```
3. If there is no registered comparator, then a RawComparator is used. The RawComparator deserializes the byte streams being compared into objects and delegates to the WritableComparable’s compareTo() method.

#### Partial Sort
```shell
$ hadoop jar hadoop-examples.jar SortByTemperatureUsingHashPartitioner \ 
-D mapreduce.job.reduces=30 input/ncdc/all-seq output-hashsort
```
This command produces 30 output files, each of which is sorted. However, there is no easy way to combine the files (by concatenation, for example, in the case of plain-text files) to produce a globally sorted file.  
For many applications, this doesn’t matter. For example, having a partially sorted set of files is fine when you want to do lookups by key.

#### Total Sort
**How can you produce a globally sorted file using Hadoop?**  
* The naive answer is to use a single partition.  
* A better answer is to use Pig (“Sorting Data” on page 465), Hive (“Sorting and Aggregating” on page 503), Crunch, or Spark, all of which can sort with a single command.
* Instead, it is possible to produce a set of sorted files that, if concatenated, would form a globally sorted file.   
The secret to doing this is to use a partitioner that respects the total order of the output. (PS: a little bit like bucket sort). Although this approach works, you have to choose your partition sizes carefully to ensure that they are fairly even, so job times aren’t dominated by a single reducer.  

Although we could use this information to construct a very even set of partitions, the fact that we needed to run a job that used the entire dataset to construct them is not ideal. `It’s possible to get a fairly even set of partitions by sampling the key space`. The idea behind sampling is that you look at a small subset of the keys to approximate the key distribution, which is then used to construct partitions. Luckily, we don’t have to write the code to do this ourselves, as `Hadoop comes with a selection of samplers`.

The **InputSampler** class defines a nested Sampler interface whose implementations return a sample of keys given an InputFormat and Job:  
```java
public interface Sampler<K, V> {
    K[] getSample(InputFormat<K, V> inf, Job job)
        throws IOException, InterruptedException;
}
```
This interface usually is not called directly by clients. Instead, the writePartitionFile() static method on InputSampler is used, which creates a sequence file to store the keys that define the partitions:  
```java
public static <K, V> void writePartitionFile(Job job, Sampler<K, V> sampler)
    throws IOException, ClassNotFoundException, InterruptedException
```
PS: The content of the sequence file is, for example, the sampler chose –5.6°C, 13.9°C, and 22.0°C as partition boundaries (for four partitions).

The sequence file is used by **TotalOrderPartitioner** to create partitions for the sort job (PS: requires storing the sequence file to DistributedCache at first). Example 9-5 puts it all together.   

**Example 9-5. A MapReduce program for sorting a SequenceFile with IntWritable keys using the TotalOrderPartitioner to globally sort the data**  
```java
public class SortByTemperatureUsingTotalOrderPartitioner extends Configured
implements Tool {
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setInputFormatClass(SequenceFileInputFormat.class);
        job.setOutputKeyClass(IntWritable.class);
        job.setOutputFormatClass(SequenceFileOutputFormat.class);
        SequenceFileOutputFormat.setCompressOutput(job, true);
        SequenceFileOutputFormat.setOutputCompressorClass(job, GzipCodec.class);
        SequenceFileOutputFormat.setOutputCompressionType(job,
            CompressionType.BLOCK);
        job.setPartitionerClass(TotalOrderPartitioner.class);
        // RandomSampler(a uniform probability, maximum number of samples, maximum number of splits to sample)
        InputSampler.Sampler<IntWritable, Text> sampler =
            new InputSampler.RandomSampler<IntWritable, Text>(0.1, 10000, 10);
        InputSampler.writePartitionFile(job, sampler);
        // Add to DistributedCache
        Configuration conf = job.getConfiguration();
        String partitionFile = TotalOrderPartitioner.getPartitionFile(conf);
        URI partitionUri = new URI(partitionFile);
        job.addCacheFile(partitionUri);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(
            new SortByTemperatureUsingTotalOrderPartitioner(), args);
        System.exit(exitCode);
    }
}
```
Samplers run on the client, making it important to limit the number of splits that are downloaded so the sampler runs quickly. In practice, the time taken to run the sampler is a small fraction of the overall job time.   
The InputSampler writes a partition file that we need to share with the tasks running on the cluster by adding it to the distributed cache.
```shell
 $ hadoop jar hadoop-examples.jar SortByTemperatureUsingTotalOrderPartitioner \ 
 -D mapreduce.job.reduces=30 input/ncdc/all-seq output-totalsort
```
The program produces 30 output partitions, each of which is internally sorted; in addition, for these partitions, all the keys in partition i are less than the keys in partition i + 1.

* SplitSampler  
Your input data determines the best sampler to use. For example, **SplitSampler**, which samples only the first n records in a split, is not so good for sorted data, because it doesn’t select keys from throughout the split.  
* IntervalSampler  
On the other hand, **IntervalSampler** chooses keys at regular intervals through the split and makes a better choice for sorted data.  
* RandomSampler  
**RandomSampler** is a good general-purpose sampler. 
* User define sampler  
If none of these suits your application (and remember that the point of sampling is to produce partitions that are approximately equal in size), you can write your own implementation of the Sampler interface.  

One of the nice properties of InputSampler and TotalOrderPartitioner is that you are free to choose the number of partitions—that is, the number of reducers. However, TotalOrderPartitioner will work only if the partition boundaries are distinct. One problem with choosing a high number is that you may get collisions if you have a small key space.

#### Secondary Sort
The MapReduce framework sorts the records by key before they reach the reducers. `For any particular key, however, the values are not sorted. The order in which the values appear is not even stable from one run to the next`.  
However, it is possible to `impose an order on the VALUES` by sorting and grouping the keys in a particular way.  

To summarize, there is a recipe here to get the effect of sorting by value:  
* Make the key a composite of the natural key and the natural value. 
* The sort comparator should order by the composite key (i.e., the natural key and natural value). (PS: the same sort comparator is for both map sort and reduce sort phrase)  
* The partitioner and grouping comparator for the composite key should consider only the natural key for partitioning and grouping.  
PS: grouping comparator should work after sort comparator and generate list(V2) for the reducer, it always retains the first composite key.  
```scala
map: (K1, V1) → list(K2, V2)
combiner: (K2, list(V2)) → list(K2, V2)
reduce: (K2, list(V2)) → list(K3, V3)
```

To illustrate the idea, consider the MapReduce program for calculating the maximum temperature for each year. If we arranged for the values (temperatures) to be sorted in descending order, we wouldn’t have to iterate through them to find the maximum; instead, we could take the first for each year and ignore the rest. (This approach isn’t the most efficient way to solve this particular problem, but it illustrates how secondary sort works in general.)  
To achieve this, we change our keys to be composite: a combination of year and temperature. We want the sort order for keys to be by year (ascending) and then by temperature (descending).  

```java
public class MaxTemperatureUsingSecondarySort
extends Configured implements Tool {
    static class MaxTemperatureMapper
    extends Mapper<LongWritable, Text, IntPair, NullWritable> {
        private NcdcRecordParser parser = new NcdcRecordParser();
        @Override
        protected void map(LongWritable key, Text value,
            Context context) throws IOException, InterruptedException {
            parser.parse(value);
            if (parser.isValidTemperature()) {
                context.write(new IntPair(parser.getYearInt(),
                    parser.getAirTemperature()), NullWritable.get());
            }
        }
    }
    static class MaxTemperatureReducer
    extends Reducer<IntPair, NullWritable, IntPair, NullWritable> {
        @Override
        protected void reduce(IntPair key, Iterable<NullWritable> values,
            Context context) throws IOException, InterruptedException {
            context.write(key, NullWritable.get());
        }
    }
    public static class FirstPartitioner
    extends Partitioner<IntPair, NullWritable> {
        @Override
        public int getPartition(IntPair key, NullWritable value, int numPartitions) {
            // multiply by 127 to perform some mixing
            return Math.abs(key.getFirst() * 127) % numPartitions;
        }
    }
    public static class KeyComparator extends WritableComparator {
        protected KeyComparator() {
            super(IntPair.class, true);
        }
        @Override
        public int compare(WritableComparable w1, WritableComparable w2) {
            IntPair ip1 = (IntPair) w1;
            IntPair ip2 = (IntPair) w2;
            int cmp = IntPair.compare(ip1.getFirst(), ip2.getFirst());
            if (cmp != 0) {
                return cmp;
            }
            return -IntPair.compare(ip1.getSecond(), ip2.getSecond()); //reverse
        }
    }
    public static class GroupComparator extends WritableComparator {
        protected GroupComparator() {
            super(IntPair.class, true);
        }
        @Override
        public int compare(WritableComparable w1, WritableComparable w2) {
            IntPair ip1 = (IntPair) w1;
            IntPair ip2 = (IntPair) w2;
            return IntPair.compare(ip1.getFirst(), ip2.getFirst());
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setMapperClass(MaxTemperatureMapper.class);
        job.setPartitionerClass(FirstPartitioner.class);
        job.setSortComparatorClass(KeyComparator.class);
        job.setGroupingComparatorClass(GroupComparator.class);
        job.setReducerClass(MaxTemperatureReducer.class);
        job.setOutputKeyClass(IntPair.class);
        job.setOutputValueClass(NullWritable.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new MaxTemperatureUsingSecondarySort(), args);
        System.exit(exitCode);
    }
}
```
In the mapper, we create a key representing the year and temperature, using an IntPair Writable implementation (user defined). We don’t need to carry any information in the value, because `we can get the first (maximum) temperature in the reducer from the key`, so we use a NullWritable. `The reducer emits the first key`, which, due to the secondary sorting, is an IntPair for the year and its maximum temperature.  

Many applications need to access all the sorted values, not just the first value as we have provided here. To do this, you need to populate the value fields since in the reducer you can retrieve only the first key. This necessitates some unavoidable duplication of information between key and value.  

##### Streaming Secondary Sort
To do a secondary sort in Streaming, we can take advantage of a couple of library classes that Hadoop provides. Here’s the driver that we can use to do a secondary sort.  
```shell
$ hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming-*.jar \
-D stream.num.map.output.key.fields=2 \
-D mapreduce.partition.keypartitioner.options=-k1,1 \
-D mapreduce.job.output.key.comparator.class=\
        org.apache.hadoop.mapred.lib.KeyFieldBasedComparator \
-D mapreduce.partition.keycomparator.options="-k1n -k2nr" \
-files secondary_sort_map.py,secondary_sort_reduce.py \
-input input/ncdc/all \
-output output-secondarysort-streaming \
-mapper ch09-mr-features/src/main/python/secondary_sort_map.py \
-partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner \
-reducer ch09-mr-features/src/main/python/secondary_sort_reduce.py
```

**Example 9-7. Map function for secondary sort in Python, secondary_sort_map.py**  
```python
#!/usr/bin/env python
import re
import sys
for line in sys.stdin:
    val = line.strip()
    (year, temp, q) = (val[15:19], int(val[87:92]), val[92:93])
    if temp == 9999:
        sys.stderr.write("reporter:counter:Temperature,Missing,1\n")
    elif re.match("[01459]", q):
        print "%s\t%s" % (year, temp)
```
Our map function (Example 9-7) emits records with year and temperature fields. We want to treat the combination of both of these fields as the key, so we set stream.num.map.output.key.fields to 2. This means that values will be empty, just like in the Java case.  
`In the Java version, we had to set the grouping comparator; however, in Streaming, groups are not demarcated in any way`, so in the reduce function we have to `detect the group boundaries ourselves` by looking for when the year changes (Example 9-8).  

**Example 9-8. Reduce function for secondary sort in Python**  
```python
#!/usr/bin/env python
import sys
last_group = None
for line in sys.stdin:
    val = line.strip()
    (year, temp) = val.split("\t")
    group = year
    if last_group != group:
        print val
        last_group = group
```

Finally, note that **KeyFieldBasedPartitioner** and **KeyFieldBasedComparator** are not confined to use in Streaming programs; they are applicable to Java MapReduce programs, too.  

### Joins
MapReduce can perform joins between large datasets, but writing the code to do joins from scratch is fairly involved. Rather than writing MapReduce programs, you might consider using a higher-level framework such as Pig, Hive, Cascading, Cruc, or Spark, in which join operations are a core part of the implementation.  
![hadoop_mr_join_example_img_1]  

If the join is performed by the mapper it is called a map-side join, whereas if it is performed by the reducer it is called a reduce-side join.  
How we implement the join depends on how large the datasets are and how they are partitioned. If one dataset is large (the weather records) but the other one is small enough to be distributed to each node in the cluster (as the station metadata is, via “Side Data Distribution”), the join can be effected by a MapReduce job that brings the records for each station together (a partial sort on station ID, for example).

If both datasets are too large for either to be copied to each node in the cluster, we can still join them using MapReduce with a map-side or reduce-side join, depending on how the data is structured.  

#### Map-Side Joins
A map-side join between large inputs works by performing the join `before the data reaches the map function`. For this to work, though, the inputs to each map must be partitioned and sorted in a particular way. `Each input dataset must be divided into the same number of partitions, and it must be sorted by the same key (the join key) in each source. All the records for a particular key must reside in the same partition`. This may sound like a strict requirement (and it is), but it actually fits the description of the output of a MapReduce job.  

A map-side join can be used to join the outputs of several jobs that had the same number of reducers, the same keys, and output files that are not splittable (by virtue of being smaller than an HDFS block or being gzip compressed, for example)

You use a **CompositeInputFormat** from the org.apache.hadoop.mapreduce.join package to run a map-side join. The input sources and `join type (inner or outer)` for CompositeInputFormat are configured through a join expression that is written according to a simple grammar.

#### Reduce-Side Joins
A reduce-side join is more general than a map-side join, in that the input datasets don’t have to be structured in any particular way, but it is `less efficient because both datasets have to go through the MapReduce shuffle`. The basic idea is that the `mapper tags each record with its source and uses the join key as the map output key`(PS: for example, label each source as 0, 1, ..., and tag either the join key or value with source label, moreover, for tagging the join key, it is still required to use only the original join key in both partitioner and group comparator),  so that the records with the same key are brought together in the reducer. We use several ingredients to make this work in practice:  
* Multiple inputs  
The input sources for the datasets generally have different formats, so it is very convenient to use the **MultipleInputs** class to separate the logic for parsing and tagging each source.  
* Secondary sort  
As described, the reducer will see the records from both sources that have the same key, but they are not guaranteed to be in any particular order. However, to perform the join, it is important to have the data from one source before that from the other. For the weather data join, the station record must be the first of the values seen for each key, so the reducer can fill in the weather records with the station name and emit them straightaway. Of course, `it would be possible to receive the records in any order if we buffered them in memory`, but this should be avoided because the number of records in any group may be very large and exceed the amount of memory available to the reducer.  

**Example 9-9. Mapper for tagging station records for a reduce-side join**  
```java
public class JoinStationMapper
extends Mapper<LongWritable, Text, TextPair, Text> {
    private NcdcStationMetadataParser parser = new NcdcStationMetadataParser();
    @Override
    protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
        if (parser.parse(value)) {
            context.write(new TextPair(parser.getStationId(), "0"),
                new Text(parser.getStationName()));
        }
    }
}
```
**Example 9-10. Mapper for tagging weather records for a reduce-side join** 
```java
public class JoinRecordMapper
extends Mapper<LongWritable, Text, TextPair, Text> {
    private NcdcRecordParser parser = new NcdcRecordParser();
    @Override
    protected void map(LongWritable key, Text value, Context context)
    throws IOException, InterruptedException {
        parser.parse(value);
        context.write(new TextPair(parser.getStationId(), "1"), value);
    }
}
```
The reducer knows that it will receive the station record first, so it extracts its name from the value and writes it out as a part of every output record (Example 9-11).   
**Example 9-11. Reducer for joining tagged station records with tagged weather records**  
```java
public class JoinReducer extends Reducer<TextPair, Text, Text, Text> {
    @Override
    protected void reduce(TextPair key, Iterable<Text> values, Context context)
    throws IOException, InterruptedException {
        Iterator<Text> iter = values.iterator();
        Text stationName = new Text(iter.next());
        while (iter.hasNext()) {
            Text record = iter.next();
            Text outValue = new Text(stationName.toString() + "\t" + record.toString());
            context.write(key.getFirst(), outValue);
        }
    }
}
```

`The code assumes that every station ID in the weather records has exactly one matching record in the station dataset. If this were not the case, we would need to generalize the code to put the tag into the value objects, by using another TextPair`. The reduce() method would then be able to tell which entries were station names and detect (and handle) missing or duplicate entries before processing the weather records.  

Tying the job together is the driver class, shown in Example 9-12. `The essential point here is that we partition and group on the first part of the key`, the station ID, which we do with a custom Partitioner (KeyPartitioner) and a custom group comparator, FirstComparator (from TextPair).  

**Example 9-12. Application to join weather records with station names**  
```java
public class JoinRecordWithStationName extends Configured implements Tool {
    public static class KeyPartitioner extends Partitioner<TextPair, Text> {
        @Override
        public int getPartition(TextPair key, Text value, int numPartitions) {
            return (key.getFirst().hashCode() & Integer.MAX_VALUE) % numPartitions;
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 3) {
            JobBuilder.printUsage(this, "<ncdc input> <station input> <output>");
            return -1;
        }
        Job job = new Job(getConf(), "Join weather records with station names");
        job.setJarByClass(getClass());
        Path ncdcInputPath = new Path(args[0]);
        Path stationInputPath = new Path(args[1]);
        Path outputPath = new Path(args[2]);
        MultipleInputs.addInputPath(job, ncdcInputPath,
            TextInputFormat.class, JoinRecordMapper.class);
        MultipleInputs.addInputPath(job, stationInputPath,
            TextInputFormat.class, JoinStationMapper.class);
        FileOutputFormat.setOutputPath(job, outputPath);
        job.setPartitionerClass(KeyPartitioner.class);
        job.setGroupingComparatorClass(TextPair.FirstComparator.class);
        job.setMapOutputKeyClass(TextPair.class);
        job.setReducerClass(JoinReducer.class);
        job.setOutputKeyClass(Text.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(new JoinRecordWithStationName(), args);
        System.exit(exitCode);
    }
}
```

### Side Data Distribution
Side data can be defined as extra read-only data needed by a job to process the main dataset. The challenge is to make side data available to all the map or reduce tasks (which are spread across the cluster) in a convenient and efficient fashion.  

#### Using the Job Configuration
You can set arbitrary `key-value pairs` in the job configuration using the various setter methods on Configuration (or JobConf in the old MapReduce API). This is very useful when you need to pass `a small piece of metadata` to your tasks.  

In the task, you can retrieve the data from the configuration returned by Context’s getConfiguration() method. (In the old API, it’s a little more involved: override the configure() method in the Mapper or Reducer and use a getter method on the JobConf object passed in to retrieve the data. It’s very common to store the data in an instance field so it can be used in the map() or reduce() method)  

Usually a primitive type is sufficient to encode your metadata, but for arbitrary objects you can either handle the serialization yourself (if you have an existing mechanism for turning objects to strings and back) or use Hadoop’s **Stringifier** class. The DefaultStringifier uses Hadoop’s serialization framework to serialize objects.  

You shouldn’t use this mechanism for transferring more than `a few kilobytes of data`, because it can put pressure on the memory usage in MapReduce components. The job configuration is always read `by the client, the application master, and the task JVM`, and each time the configuration is read, `all of its entries are read into memory`, even if they are not used.  

#### Distributed Cache
Rather than serializing side data in the job configuration, `it is preferable to distribute datasets using Hadoop’s distributed cache mechanism`. This provides a service for copying files and archives to the task nodes in time for the tasks to use them when they run. `To save network bandwidth, files are normally copied to any particular node once per job`.  

For tools that use GenericOptionsParser (this includes many of the programs in this book; see “GenericOptionsParser, Tool, and ToolRunner” on page 148), you can specify the files to be distributed as a comma-separated list of URIs as the argument to the `-files` option. Files can be on the local filesystem, on HDFS, or on another Hadoop-readable filesystem (such as S3). If no scheme is supplied, then the files are assumed to be local. (This is true even when the default filesystem is not the local filesystem.)  
You can also copy archive files (JAR files, ZIP files, tar files, and gzipped tar files) to your tasks using the `-archives` option; these are `unarchived on the task node`.  
The `-libjars` option will add JAR files to the classpath of the mapper and reducer tasks. This is useful if you haven’t bundled library JAR files in your job JAR file.

Let’s see how to use the distributed cache to share a metadata file for station names. The command we will run is:  
```Shell
$ hadoop jar hadoop-examples.jar \
MaxTemperatureByStationNameUsingDistributedCacheFile \
-files input/ncdc/metadata/stations-fixed-width.txt input/ncdc/all output
```

**Example 9-13. Application to find the maximum temperature by station, showing station names from a lookup table passed as a distributed cache file**  
```java
public class MaxTemperatureByStationNameUsingDistributedCacheFile
extends Configured implements Tool {
    static class StationTemperatureMapper
    extends Mapper<LongWritable, Text, Text, IntWritable> {
        private NcdcRecordParser parser = new NcdcRecordParser();
        @Override
        protected void map(LongWritable key, Text value, Context context)
        throws IOException, InterruptedException {
            parser.parse(value);
            if (parser.isValidTemperature()) {
                context.write(new Text(parser.getStationId()),
                    new IntWritable(parser.getAirTemperature()));
            }
        }
    }
    static class MaxTemperatureReducerWithStationLookup
            extends Reducer<Text, IntWritable, Text, IntWritable> {
        private NcdcStationMetadata metadata;
        @Override
        protected void setup(Context context)
        throws IOException, InterruptedException {
            metadata = new NcdcStationMetadata();
            metadata.initialize(new File("stations-fixed-width.txt"));
        }
        @Override
        protected void reduce(Text key, Iterable<IntWritable> values,
            Context context) throws IOException, InterruptedException {
            String stationName = metadata.getStationName(key.toString());
            int maxValue = Integer.MIN_VALUE;
            for (IntWritable value : values) {
                maxValue = Math.max(maxValue, value.get());
            }
            context.write(new Text(stationName), new IntWritable(maxValue));
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        Job job = JobBuilder.parseInputAndOutput(this, getConf(), args);
        if (job == null) {
            return -1;
        }
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        job.setMapperClass(StationTemperatureMapper.class);
        job.setCombinerClass(MaxTemperatureReducer.class);
        job.setReducerClass(MaxTemperatureReducerWithStationLookup.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(
            new MaxTemperatureByStationNameUsingDistributedCacheFile(), args);
        System.exit(exitCode);
    }
}
```
We use the reducer’s setup() method to retrieve the cache file using its original name, relative to the working directory of the task.

You can use the distributed cache for `copying files that do not fit in memory`. Hadoop map files are very useful in this regard, since they serve as an on-disk lookup format (see “MapFile” on page 135). Because map files are collections of files with a defined directory structure, you should put them into an archive format (JAR, ZIP, tar, or gzipped tar) and add them to the cache using the -archives option.

**How it works**  
`When you launch a job`(loaded once per job, not per task), Hadoop copies the files specified by the -files, -archives, and -libjars options to the distributed filesystem (normally HDFS). Then, before a task is run, the `node manager` copies the files from the distributed filesystem to `a local disk—the cache—`so the task can access the files. The files are said to be localized at this point. From the task’s point of view, the files are just there, symbolically linked from the task’s working directory. In addition, files specified by -libjars are added to the task’s classpath before it is launched.  

`The node manager also maintains a reference count for the number of tasks using each file in the cache`. Before the task has run, the file’s reference count is incremented by 1; then, after the task has run, the count is decreased by 1. Only when the file is not being used (when the count reaches zero) is it eligible for deletion. Files are deleted to make room for a new file when the node’s cache exceeds a certain size—10 GB by default— using a least-recently used policy. The cache size may be changed by setting the configuration property `yarn.nodemanager.localizer.cache.target-size-mb`.  

Although this design doesn’t guarantee that subsequent tasks from the same job running on the same node will find the file they need in the cache, it is very likely that they will: tasks from a job are usually scheduled to run at around the same time, so there isn’t the opportunity for enough other jobs to run to cause the original task’s file to be deleted from the cache.

##### The distributed cache API
Here are the pertinent methods in Job:  
```java
public void addCacheFile(URI uri)
public void addCacheArchive(URI uri)
public void setCacheFiles(URI[] files)
public void setCacheArchives(URI[] archives)
public void addFileToClassPath(Path file)
public void addArchiveToClassPath(Path archive)
```

The URIs referenced in the add or set methods must be files `in a shared filesystem` that exist when the job is run. On the other hand, the filenames specified as a GenericOptionsParser option (e.g., - files) may refer to local files, in which case they `get copied to the default shared filesystem (normally HDFS) on your behalf`.  
This is the key difference between using the Java API directly and using GenericOptionsParser: `the Java API does not copy the file specified in the add or set method to the shared filesystem`, whereas the GenericOptionsParser does.

### MapReduce Library Classes
classes                                                                                     |Description
---------------------------------------------------------------------|-------------------------------------------------------------------------------
ChainMapper, ChainReducer                                                     |Run a chain of mappers in a single mapper and a reducer followed by a chain of mappers in a single reducer, respectively. (Symbolically, M+RM*, where M is a mapper and R is a reducer.) `This can substantially reduce the amount of disk I/O incurred compared to running multiple MapReduce jobs`.
FieldSelectionMapReduce (old API)                                         |as below
FieldSelectionMapper and FieldSelectionReducer (new API)   |A mapper and reducer that can select fields (like the Unix cut command) from the input keys and values and emit them as output keys and values.
IntSumReducer, LongSumReducer                                           |Reducers that sum integer values to produce a total for every key.
InverseMapper                                                                        |`A mapper that swaps keys and values.`
MultithreadedMapRunner (old API)                                         |as below
MultithreadedMapper (new API)                                             |A mapper (or map runner in the old API) that runs mappers concurrently in separate threads. Useful for mappers that are `not CPU-bound`.
TokenCounterMapper                                                              |A mapper that tokenizes the input value into words (using Java’s StringTokenizer) and emits each word along with a count of 1.
RegexMapper                                                                          |A mapper that finds matches of a regular expression in the input value and emits the matches along with a count of 1.

## 10. Setting Up a Hadoop Cluster
There are a few options when it comes to getting a Hadoop cluster, from building your own, to running on rented hardware or using an offering that provides Hadoop as a hosted service in the cloud. The number of hosted options is too large to list here, but even if you choose to build a Hadoop cluster yourself, there are still a number of installation options:  
1. Apache tarballs  
2. Packages  
RPM and Debian packages are available from the **Apache Bigtop project** [hadoop_apache_bigtop_1] , as well as from all the Hadoop vendors. work well with configuration management tools like **Puppet**.
3. Hadoop cluster management tools  
**Cloudera Manager** and **Apache Ambari** are examples of dedicated tools for installing and managing a Hadoop cluster over its whole lifecycle. They provide a simple web UI, and are the recommended way to set up a Hadoop cluster for most users and operators. These tools encode a lot of operator knowledge about running Hadoop. For example, they use heuristics based on the hardware profile (among other factors) to choose good defaults for Hadoop configuration settings. For more complex setups, like HA, or secure Hadoop, the management tools provide well-tested wizards for getting a working cluster in a short amount of time. Finally, they add extra features that the other installation options don’t offer, such as `unified monitoring and log search`, and `rolling upgrades (so you can upgrade the cluster without experiencing downtime)`.

These chapters still offer valuable information about how Hadoop works from an operations point of view For more in-depth information, I highly recommend [Hadoop Operations] by Eric Sammer (O’Reilly, 2012).

**Why Not Use RAID?**  
HDFS clusters do not benefit from using RAID (redundant array of independent disks) for datanode storage (although RAID is recommended for the namenode’s disks, to protect against corruption of its metadata). The redundancy that RAID provides is not needed, since HDFS handles it by replication between nodes.  
Furthermore, RAID striping (RAID 0), which is commonly used to increase performance, turns out to be `slower than the JBOD (just a bunch of disks) configuration used by HDFS`, which round-robins HDFS blocks between all disks. This is because `RAID 0 read and write operations are limited by the speed of the slowest-responding disk in the RAID array`. In JBOD, disk operations are independent, so the average speed of operations is greater than that of the slowest disk. Disk performance often shows considerable variation in practice, even for disks of the same model. In some benchmarking carried out on a Yahoo! cluster, JBOD performed 10% faster than RAID 0 in one test (Gridmix) and 30% better in another (HDFS write throughput).  
Finally, `if a disk fails in a JBOD configuration, HDFS can continue to operate without the failed disk`, whereas with RAID, failure of a single disk causes the whole array (and hence the node) to become unavailable.

### Cluster Sizing
How large should your cluster be? You can get a good feel for this by `considering storage capacity`.  
For example, if your data grows by 1 TB a day and you have three-way HDFS replication, you need an additional 3 TB of raw storage per day. `Allow some room for intermediate files and logfiles (around 30%, say)`, and this is in the range of one (2014-vintage) machine per week. In practice, you wouldn’t buy a new machine each week and add it to the cluster. The value of doing a back-of-the-envelope calculation like this is that it gives you a feel for how big your cluster should be. In this example, a cluster that holds two years’ worth of data needs 100 machines.  

For a small cluster (on the order of 10 nodes), it is usually acceptable to run the namenode and the resource manager on a single master machine (as long as at least one copy of the namenode’s metadata is stored on a remote filesystem). However, as the cluster gets larger, there are good reasons to separate them.  

The namenode has high memory requirements, as it holds file and block metadata for the entire namespace in memory. The secondary namenode, although idle most of the time, has a comparable memory footprint to the primary when it creates a checkpoint.

Aside from simple resource requirements, the main reason to run masters on separate machines is for high availability. Both HDFS and YARN support configurations where they can run masters in active-standby pairs. If the active master fails, then the standby, running on separate hardware, takes over with little or no interruption to the service. In the case of HDFS, the standby performs the checkpointing function of the secondary namenode (so you don’t need to run both of a standby and a secondary namenode).

### Network Topology
A common Hadoop cluster architecture consists of a two-level network topology, as illustrated in Figure 10-1. Typically there are 30 to 40 servers per rack (only 3 are shown in the diagram), with a 10 Gb switch for the rack and an uplink to a core switch or router (at least 10 Gb or better). The salient point is that the aggregate bandwidth between nodes on the same rack is much greater than that between nodes on different racks.  

![hadoop_network_topology_img_1]  
**Figure 10-1. Typical two-level network architecture for a Hadoop cluster**  

#### Rack awareness
To get maximum performance out of Hadoop, it is important to configure Hadoop so that it knows the topology of your network. If your cluster runs on a single rack, then there is nothing more to do, since this is the default. However, for multirack clusters, you need to map nodes to racks. This allows Hadoop to prefer within-rack transfers (where there is more bandwidth available) to off-rack transfers when placing MapReduce tasks on nodes. HDFS will also be able to place replicas more intelligently to trade off performance and resilience.  

`Network locations such as nodes and racks are represented in a tree`, which reflects the network “distance” between locations. The namenode uses the network location when determining where to place block replicas (see “Network Topology and Hadoop” on page 70); the MapReduce scheduler uses network location to determine where the closest replica is for input to a map task.  

For the network in Figure 10-1, the rack topology is described by two network locations —say, /switch1/rack1 and /switch1/rack2. Because there is only one top-level switch in this cluster, the locations can be simplified to /rack1 and /rack2.

The Hadoop configuration must specify a map between node addresses and network locations. The map is described by a Java interface, **DNSToSwitchMapping**, whose signature is:  
```java
public interface DNSToSwitchMapping {
    public List<String> resolve(List<String> names);
}
```
The names parameter is a list of IP addresses, and the return value is a list of corresponding network location strings. `net.topology.node.switch.mapping.impl`, the default implementation is **ScriptBasedMapping**, which runs a user-defined script to determine the mapping. The script’s location is controlled by the property `net.topology.script.file.name`.  The Hadoop wiki has an example [hadoop_topology_script_1]. 

If no script location is specified, the default behavior is to map all nodes to a single network location, called /default-rack.

For the network in our example, we would map node1, node2, and node3 to /rack1, and node4, node5, and node6 to /rack2.

### Cluster Setup and Installation
1. Installing Java
2. Creating Unix User Accounts
The HDFS, MapReduce, and YARN services are usually run as separate users, named hdfs, mapred, and yarn, respectively. They all belong to the same hadoop group.
3. Installing Hadoop
4. Configuring SSH
5. Configuring Hadoop  
6. Formatting the HDFS Filesystem  
The formatting process creates an empty filesystem by creating the storage directories and the initial versions of the namenode’s persistent data structures. Datanodes are not involved in the initial formatting process.
7. Starting and Stopping the Daemons  
The file `slaves`, which contains a list of the machine hostnames or IP addresses, tells Hadoop which machines are in the cluster.   
It resides in Hadoop’s configuration directory, or by HADOOP_SLAVES setting in hadoop-env.sh  
Also, this file does not need to be distributed to worker nodes.  
    1. start-dfs.sh  
    The HDFS daemons are started by running the following command as the hdfs user:  start-dfs.sh  
    By default, this finds the namenode’s hostname from `fs.defaultFS`. In slightly more detail, the start-dfs.sh script does the following:  
        * Starts a namenode on each machine returned by executing `hdfs getconf -namenodes`
        * Starts a datanode on each machine listed in the slaves file
        * Starts a secondary namenode on each machine returned by executing `hdfs get conf -secondarynamenodes`
    2. start-yarn.sh  
    the resource manager is always run on the machine from which the start-yarn.sh script was run. More specifically, the script:  
        * Starts a resource manager on the local machine
        * Starts a node manager on each machine listed in the slaves file
    Also provided are stop-dfs.sh and stop-yarn.sh scripts to stop the daemons started by the corresponding start scripts.  
    These scripts start and stop Hadoop daemons using the `hadoop-daemon.sh` script (or the `yarn-daemon.sh` script, in the case of YARN). If you use the aforementioned scripts, you shouldn’t call hadoop-daemon.sh directly. But if you need to control Hadoop daemons from another system or from your own scripts, the hadoop-daemon.sh script is a good integration point. Likewise, hadoop-daemons.sh (with an “s”) is handy for starting the same daemon on a set of hosts.  
    3. mr-jobhistory-daemon.sh  
    Finally, there is only one MapReduce daemon—the job history server, which is started as follows, as the mapred user:
    ```shell
    $ mr-jobhistory-daemon.sh start historyserver
    ```
8. Creating User Directories  
```shell
$ hadoop fs -mkdir /user/username
$ hadoop fs -chown username:username /user/username
# sets a 1 TB limit
$ hdfs dfsadmin -setSpaceQuota 1t /user/username
```

### Hadoop Configuration

Filename                                |Description
---------------------------------|-------------------------------------------------------------------------------------------------------------------
hadoop-metrics2 .properties |Properties for controlling how metrics are published in Hadoop (see “Metrics and JMX” on page 331)
log4j.properties                    |Properties for system logfiles, the namenode audit log, and the task log for the task JVM process (“Hadoop Logs” on page 172)
hadoop-policy.xml                  |Configuration settings for access control lists when running Hadoop in secure mode
hadoop-env.sh                       |Environment variables that are used in the scripts to run Hadoop
mapred-env.sh                       |Environment variables that are used in the scripts to run MapReduce (overrides variables set in hadoop-env.sh)
yarn-env.sh                           |Environment variables that are used in the scripts to run YARN (but not for HDFS,overrides variables set in hadoop-env.sh)
core-site.xml                        |Configuration settings for Hadoop Core, such as I/O settings that are common to HDFS, MapReduce, and YARN
hdfs-site.xml                        |Configuration settings for HDFS daemons: the namenode, the secondary namenode, and the datanodes
mapred-site.xml                   |Configuration settings for MapReduce daemons: the job history server
yarn-site.xml                        |Configuration settings for YARN daemons: the resource manager, the web app proxy server, and the node managers
slaves                                   |A list of machines (one per line) that each run a datanode and a node manager  

These files are all found in the `etc/hadoop` directory of the Hadoop distribution. The configuration directory can be relocated to another part of the filesystem (outside the Hadoop installation, which makes upgrades marginally easier) as long as daemons are started with the `--config` option (or, equivalently, with the `HADOOP_CONF_DIR` environment variable set) specifying the location of this directory on the local filesystem.

#### Configuration Management
Hadoop does not have a single, global location for configuration information. Instead, each Hadoop node in the cluster has its own set of configuration files, and it is up to administrators to ensure that they are kept in sync across the system. There are parallel shell tools that can help do this, such as **dsh** or **pdsh**. This is an area where Hadoop cluster management tools like `Cloudera Manager` and `Apache Ambari` really shine, since they take care of propagating changes across the cluster.

Hadoop is designed so that it is possible to have a single set of configuration files that are used for all master and worker machines.  
To have the concept of a `class` of machine and maintain a separate configuration for each class. Hadoop doesn’t provide tools to do this, but there are several excellent tools for doing precisely this type of configuration management, such as Chef, Puppet, CFEngine, and Bcfg2.

#### Environment Settings

* hadoop-env.sh   
    1. JAVA_HOME  
    if not set, JAVA_HOME shell environment variable
    2. HADOOP_HEAPSIZE  
    for each daemon, 1000MB by default  
    Surprisingly, there are no corresponding environment variables for HDFS daemons, despite it being very common to give the namenode more heap space.  
    3. HADOOP_NAMENODE_OPTS, HADOOP_SECONDARYNAMENODE_OPTS  
    (secondary) namenode’s memory,  to include a JVM option for setting the memory size, for example, -Xmx2000m  
    For name node memory allocation, as a rule of thumb for sizing purposes, you can conservatively allow 1,000 MB per 1 million blocks of storage.  
    Secondary namenode's memory requirements are comparable to the primary namenode’s.   
    4. HADOOP_LOG_DIR  
    System logfiles(System daemons logs) produced by Hadoop are stored in $HADOOP_HOME/logs by default. A common choice is /var/log/hadoop.  
    5. HADOOP_IDENT_STRING
    The username in the system daemon's logfile name.  
    6. SSH settings  
        1. ConnectTimeout  
        2. StrictHostKeyChecking  
        3. HADOOP_SSH_OPTS  
        To pass extra options to SSH, see the ssh and ssh_config manual pages for more SSH settings.
* yarn-env.sh
    1. YARN_RESOURCEMANAGER_HEAPSIZE

#### Important Hadoop Daemon Properties
To find the actual configuration of a running daemon, visit the /conf page on its web server. For example, http://resource-manager-host:8088/conf shows the configuration that the resource manager is running with.

**Example 10-1. A typical core-site.xml configuration file**  
```xml
<?xml version="1.0"?>
<!-- core-site.xml -->
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://namenode/</value>
    </property>
</configuration>
```
**Example 10-2. A typical hdfs-site.xml configuration file**  
```xml
<?xml version="1.0"?>
<!-- hdfs-site.xml -->
<configuration>
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>/disk1/hdfs/name,/remote/hdfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>/disk1/hdfs/data,/disk2/hdfs/data</value>
    </property>
    <property>
        <name>dfs.namenode.checkpoint.dir</name>
        <value>/disk1/hdfs/namesecondary,/disk2/hdfs/namesecondary</value>
    </property>
</configuration>
```
**Example 10-3. A typical yarn-site.xml configuration file**
```xml
<?xml version="1.0"?>
<!-- yarn-site.xml -->
<configuration>
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>resourcemanager</value>
    </property>
    <property>
        <name>yarn.nodemanager.local-dirs</name>
        <value>/disk1/nm-local-dir,/disk2/nm-local-dir</value>
    </property>
    <property>
        <name>yarn.nodemanager.aux-services</name>
        <value>mapreduce_shuffle</value>
    </property>
    <property>
        <name>yarn.nodemanager.resource.memory-mb</name>
        <value>16384</value>
    </property>
    <property>
        <name>yarn.nodemanager.resource.cpu-vcores</name>
        <value>16</value>
    </property>
</configuration>
```

##### HDFS
1. fs.defaultFS  
The URI defines the hostname and port that `the namenode’s RPC server runs on. The default port is 8020`.  
default:  `file:///`  
`fs.defaultFS` is used to specify `both the HDFS namenode and the default filesystem`, it means HDFS has to be the default filesystem in the server configuration. Bear in mind, however, that it is possible to specify a different filesystem as the default in the client configuration, for convenience.  
For example, if you use both HDFS and S3 filesystems, then you have a choice of specifying either (of HDFS or S3) as the default in the client configuration, which allows you to refer to the default with a relative URI and the other with an absolute URI.  
In Example 10-1, the relative URI /a/b is resolved to hdfs://namenode/a/b.   
2. dfs.namenode.name.dir  
The property `dfs.namenode.name.dir` specifies a list of directories where the namenode stores persistent filesystem metadata (the edit log and the filesystem image). A copy of each metadata file is stored in each directory for redundancy.   
default: `file://${hadoop.tmp.dir}/dfs/name`   
3. dfs.datanode.data.dir  
It specifies a list of directories for a datanode to store its blocks in. Unlike the namenode, which uses multiple directories for redundancy, a datanode `round-robins writes between its storage directories`, so `for performance you should specify a storage directory for each local disk`. `Read performance also benefits from having multiple disks for storage`, because blocks will be spread across them and concurrent reads for distinct blocks will be correspondingly spread across disks.  
For maximum performance, you should mount storage disks with the **noatime** option. This setting means that last accessed time information is not written on file reads, which gives `significant performance gains`.   
default: `file://${hadoop.tmp.dir}/dfs/data`  
4. dfs.namenode.checkpoint.dir  
To configure where the secondary namenode stores its checkpoints of the filesystem. The checkpointed filesystem image is stored in each checkpoint directory for redundancy.  
default: `file://${hadoop.tmp.dir}/dfs/namesecondary`

Note that the storage directories for HDFS are under Hadoop’s temporary directory by default (this is configured via the `hadoop.tmp.dir` property, whose default is /tmp/hadoop-$ {user.name}). Therefore, it is critical that these properties are set so that data is not lost by the system when it clears out temporary directories.

##### YARN
1. yarn.resourcemanager.hostname  
the hostname or IP address of the machine running the resource manager. Many of the resource manager’s server addresses are derived from this property.    
2. yarn.resourcemanager.address  
The hostname and port(8032 by default) that the resource manager’s RPC server runs on.  
The hostname defaults to yarn.resourcemanager.hostname.   
3. yarn.nodemanager.local-dirs  
It controls the location of local temporary storage for YARN containers,  which holds intermediate data and working files of  MapReduce jobs.   
default: `${hadoop.tmp.dir}/nm-local-dir`  
The directories are used in round-robin fashion.  
Typically, you will use the same disks and partitions (but different directories) for YARN local storage as you use for datanode block storage.  
4. yarn.nodemanager.aux-services  
Unlike MapReduce 1, YARN doesn’t have tasktrackers to serve map outputs to reduce tasks, so for this function it relies on `shuffle handlers`, which are long-running auxiliary services running in node managers. Because YARN is a general-purpose service, the MapReduce shuffle handlers need to be enabled explicitly in yarn-site.xml by setting the yarn.nodemanager.aux-services property to mapreduce_shuffle.  
A service is implemented by the class defined by the property `yarn.nodemanager.auxservices.servicename.class`  

Property name                                       |Default value  |Description
--------------------------------------------|-----------------|--------------------------------------------------------------------------------------
yarn.nodemanager.resource.cpu-vcores |8                     |The number of CPU cores that may be allocated to `containers` being run by the nodemanager.  
yarn.nodemanager.resource.memory-mb|8192                |The amount of physical memory (in MB) that may be allocated to `containers` being run by the node manager.
yarn.nodemanager.vmem-pmem-ratio    |2.1                    |The ratio of virtual to physical memory for containers. Virtual memory usage may exceed the allocation by this amount.

##### Memory settings in YARN and MapReduce
YARN treats memory in a more fine-grained manner than the slot-based model used in MapReduce 1.  
In the YARN model, node managers allocate memory from a pool, so the number of tasks that are running on a particular node depends on the sum of their memory requirements.  

* yarn.nodemanager.resource.memory-mb  
Set aside enough memory for a datanode daemon(1000MB by default) and a node manager daemon(1000MB by default), as well as other processes that are running on the machine, and the remainder can be dedicated to `the node manager’s containers` by setting the configuration property `yarn.nodemanager.resource.memory-mb` to the total allocation in MB. (The default is 8,192 MB, which is normally too low for most setups.)  

The next step is to determine how to set memory options for individual jobs. `There are two main controls: one for the size of the container allocated by YARN, and another for the heap size of the Java process run in the container`.  

The memory controls for MapReduce are all set by the client in the job configuration. The YARN settings are cluster settings and cannot be modified by the client.  

`Container sizes` are determined by `mapreduce.map.memory.mb` and `mapreduce.reduce.memory.mb`; both default to 1,024 MB. These settings are used by the application master when negotiating for resources in the cluster, and also by the node manager, which runs and monitors the task containers. `The heap size of the Java process` is set by `mapred.child.java.opts`, and defaults to 200 MB. You can also set the Java options separately for map and reduce tasks (see Table 10-4).

**Table 10-4. MapReduce job memory properties (set by the client)**  

Property name                           |Default value      |Description
-----------------------------------|--------------------|--------------------------------------------------------------------------------------------
mapreduce.map.memory.mb       |1024                    |The amount of memory for map containers.
mapreduce.reduce.memory.mb  |1024                    |The amount of memory for reduce containers.
mapred.child.java.opts              |-Xmx200m           |The JVM options used to launch the container process that runs map and reduce tasks. In addition to memory settings, this property can include JVM properties for debugging, for example.
mapreduce.map.java.opts          |-Xmx200m           |The JVM options used for the child process that runs map tasks.
mapreduce.reduce.java.opts     |-Xmx200m           |The JVM options used for the child process that runs reduce tasks.

For example, suppose mapred.child.java.opts is set to -Xmx800m and mapreduce.map.memory.mb is left at its default value of 1,024 MB. When a map task is run, the node manager will allocate a 1,024 MB container (decreasing the size of its pool by that amount for the duration of the task) and will launch the task JVM configured with an 800 MB maximum heap size. Note that the JVM process will have a larger memory footprint than the heap size, and the overhead will depend on such things as the native libraries that are in use, the size of the permanent generation space, and so on. The important thing is that the physical memory used by the JVM process, including any processes that it spawns, such as Streaming processes, does not exceed its allocation (1,024 MB). If a container uses more memory than it has been allocated, then it may be terminated by the node manager and marked as failed.

YARN schedulers impose a minimum or maximum on memory allocations. The default minimum is 1,024 MB (set by `yarn.scheduler.minimum-allocation-mb`), and the default maximum is 8,192 MB (set by `yarn.scheduler.maximum-allocation-mb`).

The multiple is expressed by the `yarn.nodemanager.vmem-pmem-ratio property`, which defaults to 2.1. In the example used earlier, the virtual memory threshold above which the task may be terminated is 2,150 MB, which is 2.1 × 1,024 MB.  

##### CPU settings in YARN and MapReduce
The number of cores that a node manager can allocate to containers is controlled by the `yarn.nodemanager.resource.cpu-vcores` property. It should be set to the total number of cores on the machine, `minus a core for each daemon process running on the machine` (datanode, node manager, and any other long-running processes).

MapReduce jobs can control the number of cores allocated to map and reduce containers by setting `mapreduce.map.cpu.vcores` and `mapreduce.reduce.cpu.vcores`. Both default to 1, an appropriate setting for normal single-threaded MapReduce tasks, which can only saturate a single core.  

While the number of cores is tracked during scheduling (so a container won’t be allocated on a machine where there are no spare cores, for example), `the node manager will not, by default, limit actual CPU usage of running containers`. This means that a container can abuse its allocation by using more CPU than it was given, possibly starving other containers running on the same host. `YARN has support for enforcing CPU limits using Linux cgroups`. The node manager’s container executor class (`yarn.nodemanager.container-executor.class`) must be set to use the **LinuxContainerExecutor** class, which in turn must be configured to use cgroups (see the properties under `yarn.nodemanager.linux-container-executor`).  

#### Hadoop Daemon Addresses and Ports
`Hadoop daemons generally run both an RPC server for communication between daemons (Table 10-5) and an HTTP server to provide web pages for human consumption` (Table 10-6). Each server is configured by setting the network address and port number to listen on.

It is often desirable for servers to bind to multiple network interfaces. By setting `yarn.resourcemanager.hostname` to the (externally resolvable) hostname or IP address and `yarn.resourcemanager.bind-host` to 0.0.0.0, you ensure that the resource manager will bind to all addresses on the machine, while at the same time providing a resolvable address for node managers and clients.  

In addition to an RPC server, `datanodes run a TCP/IP server for block transfers`. The server address and port are set by the `dfs.datanode.address` property , which has a default value of 0.0.0.0:50010

There is also a setting for controlling which network interfaces the datanodes use as their IP addresses (for HTTP and RPC servers). The relevant property is dfs.data node.dns.interface, which is set to default to use the default network interface. You can set this explicitly to report the address of a particular interface (eth0, for example).  

#### Other Hadoop Properties
* Cluster membership  
To aid in the addition and removal of nodes in the future, you can specify a file containing `a list of authorized machines` that may join the cluster `as datanodes or node managers`. The file is specified using the `dfs.hosts` and `yarn.resourcemanager.nodes.include-path` properties (for datanodes and node managers, respectively), and the corresponding `dfs.hosts.exclude `and `yarn.resourcemanager.nodes.exclude-path` properties specify the files used for decommissioning.  
* Buffer size  
Hadoop uses a buffer size of 4 KB (4,096 bytes) for its I/O operations. This is a conservative setting, and with modern hardware and operating systems, `you will likely see performance benefits by increasing it`; 128 KB (131,072 bytes) is a common choice. Set the value in bytes using the `io.file.buffer.size` property in core-site.xml.  
* HDFS block size  
The HDFS block size is 128 MB by default, but many clusters use more (e.g., 256 MB) to ease memory pressure on the namenode and to give mappers more data to work on. Use the `dfs.blocksize` property in hdfs-site.xml to specify the size in bytes.
* Reserved storage space  
By default, datanodes will try to use all of the space available in their storage directories. If you want to reserve some space on the storage volumes for non-HDFS use, you can set `dfs.datanode.du.reserved` to the amount, in bytes, of space to reserve.
* Trash  
Hadoop filesystems have a trash facility, in which deleted files are not actually deleted but rather are moved to a trash folder, where they remain for a minimum period before being permanently deleted by the system. The minimum period in minutes that a file will remain in the trash is set using the `fs.trash.interval` configuration property in core-site.xml. By default, the trash interval is zero, which disables trash.  
When trash is enabled, users each have their own trash directories called .Trash in their home directories.  
API:  Trash.moveToTrash(),  Trash.expunge()  
HDFS will automatically delete files in trash folders, but other filesystems will not, so you have to arrange for this to be done periodically.  
```shell
$ hadoop fs -expunge
```
* Reduce slow start  
By default, schedulers wait until 5% of the map tasks in a job have completed before scheduling reduce tasks for the same job. For large jobs, this can cause problems with cluster utilization, since they take up reduce containers while waiting for the map tasks to complete. Setting `mapreduce.job.reduce.slowstart.completedmaps` to a higher value, such as 0.80 (80%), can help improve throughput.  
* Short-circuit local reads  
When reading a file from HDFS, the client contacts the datanode and the data is sent to the client via a TCP connection. `If the block being read is on the same node as the client, then it is more efficient for the client to bypass the network and read the block data directly from the disk`. This is termed a short-circuit local read, and can `make applications like HBase perform better`.  
You can enable short-circuit local reads by setting `dfs.client.read.shortcircuit` to true. Short-circuit local reads are implemented using `Unix domain sockets`, which use a local path for client-datanode communication. The path is set using the property `dfs.domain.socket.path`, and must be a path that only the datanode user (typically hdfs) or root can create, such as /var/run/hadoop-hdfs/dn_socket.  

### Security
There’s a lot to security in Hadoop, and this section only covers the highlights. For more, readers are referred to [Hadoop Security] by Ben Spivey and Joey Echeverria (O’Reilly, 2014).  

Early versions of Hadoop assumed that HDFS and MapReduce clusters would be used by a group of cooperating users within a secure environment. The measures for restricting access were designed to prevent accidental data loss, rather than to prevent unauthorized access to data.

Hadoop itself does not manage user credentials; instead, it relies on Kerberos, however, Kerberos doesn’t manage permissions. Kerberos says that a user is who she says she is (Authentication); it’s Hadoop’s job to determine whether that user has permission to perform a given action (Authorization).  

#### Kerberos and Hadoop
At a high level, there are three steps that a client must take to access a service when using Kerberos, each of which involves a message exchange with a server:  
1. Authentication.  
The client authenticates itself to the `Authentication Server` and receives a timestamped `Ticket-Granting Ticket (TGT)`.  
2. Authorization.  
The client uses the TGT to request a service ticket from the `Ticket- Granting Server`.  
3. Service request.  
The client uses the service ticket to authenticate itself to the server that is providing the service the client is using. In the case of Hadoop, this might be the namenode or the resource manager.  

Together, the Authentication Server and the Ticket Granting Server form the `Key Distribution Center (KDC)`. The process is shown graphically in Figure 10-2.  
![hadoop_kerberos_img_1]  
**Figure 10-2. The three-step Kerberos ticket exchange protocol**  

The authorization and service request steps are not user-level actions; the client performs these steps on the user’s behalf. The authentication step, however, is normally carried out explicitly by the user using the `kinit` command, which will prompt for a password. However, this doesn’t mean you need to enter your password every time you run a job or access HDFS, `since TGTs last for 10 hours by default` (and can be renewed for up to a week). It’s common to automate authentication at operating system login time, thereby providing single sign-on to Hadoop.  
In cases where you don’t want to be prompted for a password (for running an unattended MapReduce job, for example), you can create a Kerberos `keytab` file using the `ktutil` command. A keytab is a file that stores passwords and may be supplied to kinit with the -t option.  

To use Kerberos authentication with Hadoop, you need to install, configure, and run a KDC (Hadoop does not come with one). Your organization may already have a KDC you can use (an Active Directory installation, for example); if not, you can set up an `MIT Kerberos 5 KDC`.  
1. The first step is to enable Kerberos authentication by setting the `hadoop.security.authentication` property in core-site.xml to `kerberos`.
2. We also need to enable service-level authorization by setting `hadoop.security.authorization` to true in the core-site.xml
3. You may configure access control lists (ACLs) in the `hadoop-policy.xml` configuration file to control which users and groups have permission to connect to each Hadoop service. Services are defined at the protocol level, so there are ones for MapReduce job submission, namenode communication, and so on.

#### Delegation Tokens
In a distributed system such as HDFS or MapReduce, there are many client-server interactions, each of which must be authenticated. For example, an HDFS read operation will involve multiple calls to the namenode and calls to one or more datanodes. `Instead of using the three-step Kerberos ticket exchange protocol to authenticate each call, which would present a high load on the KDC on a busy cluster`, Hadoop uses delegation tokens to allow later authenticated access without having to contact the KDC again.

A delegation token is generated by the server (the namenode, in this case) and can be thought of as a shared secret between the client and the server. On the first RPC call to the namenode, the client has no delegation token, so it uses Kerberos to authenticate. As a part of the response, it gets a delegation token from the namenode. In subsequent calls it presents the delegation token, which the namenode can verify (since it generated it using a secret key), and hence the client is authenticated to the server. (PS: isn't this done by kerberos? why kerberos needs authentication for each subsequent calls?)

When it wants to perform operations on HDFS blocks, the client uses a special kind of delegation token, called a `block access token`, that the namenode passes to the client in response to a metadata request. The client uses the block access token to authenticate itself to datanodes. This property is enabled by setting `dfs.block.access.token.enable` to true.

Delegation tokens are automatically obtained for the default HDFS instance, but if your job needs to access other HDFS clusters, you can load the delegation tokens for these by setting the mapreduce.job.hdfs-servers job property to a comma-separated list of HDFS URIs.

#### Other Security Enhancements
* Tasks can be run using the operating system account for the user who submitted the job, rather than the user running the node manager.  
This feature is enabled by setting `yarn.nodemanager.container-executor.class` to `org.apache.hadoop.yarn.server.nodemanager.LinuxContainerExecutor`. In addition, administrators need to ensure that each user is given an account on every node in the cluster (typically using LDAP).
* When tasks are run as the user who submitted the job, the distributed cache (see “Distributed Cache” on page 274) is secure.  Files go in a private cache, readable only by the owner. Files that are world-readable are put in a shared cache (the insecure default);
* Users can view and modify only their own jobs, not others. This is enabled by setting `mapreduce.cluster.acls.enabled` to true. There are two job configuration properties, `mapreduce.job.acl-view-job` and `mapreduce.job.acl-modify-job`, which may be set to a comma-separated list of users to control who may view or modify a particular job. 
* The shuffle is secure, preventing a malicious user from requesting another user’s map outputs.
* When appropriately configured, `it’s no longer possible for a malicious user to run a rogue secondary namenode, datanode, or node manager that can join the cluster and potentially compromise data stored in the cluster`.  
This is enforced by requiring daemons to authenticate with the master node they are connecting to. To enable this feature, you first need to configure Hadoop to use a keytab previously generated with the ktutil command. For a datanode, for example, you would set the dfs.datanode.keytab.file property to the keytab filename and dfs.data node.kerberos.principal to the username to use for the datanode. Finally, the ACL for the DataNodeProtocol (which is used by datanodes to communicate with the namenode) must be set in hadoop-policy.xml, by restricting `security.datanode.protocol.acl` to the datanode’s username.  
* A datanode may be run on a privileged port (one lower than 1024), so a client may be reasonably sure that it was started securely. 
* A task may communicate only with its parent application master, thus preventing an attacker from obtaining MapReduce data from another user’s job. 
* Various parts of Hadoop can be configured `to encrypt network data`, including RPC (hadoop.rpc.protection), HDFS block transfers (dfs.encrypt.data.transfer), the MapReduce shuffle (mapreduce.shuffle.ssl.enabled), and the web UIs (hadokop.ssl.enabled). Work is ongoing to encrypt data “at rest,” too, so that HDFS blocks can be stored in encrypted form, for example.

### Hadoop Benchmarks
Hadoop comes with several benchmarks that you can run very easily with minimal setup cost. Benchmarks are packaged in the tests JAR file, and you can get a list of them, with descriptions, by invoking the JAR file with no arguments:
```shell
$ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-*-tests.jar
```
Most of the benchmarks show usage instructions when invoked with no arguments:  
```shell
$ hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-*-tests.jar TestDFSIO
TestDFSIO.1.7
Missing arguments.
Usage: TestDFSIO [genericOptions] -read [-random | -backward |
-skip [-skipSize Size]] | -write | -append | -clean [-compression codecClassName]
[-nrFiles N] [-size Size[B|KB|MB|GB|TB]] [-resFile resultFileName]
[-bufferSize Bytes] [-rootDir]
```
#### Benchmarking MapReduce with TeraSort
Hadoop comes with a MapReduce program called **TeraSort** that does a total sort of its input (In 2008, TeraSort was used to break the world record for sorting 1 TB of data). It is very useful for benchmarking HDFS and MapReduce together, as the full input dataset is transferred through the shuffle. 
1. generate some random data  
```shell
# 10t is 10 trillion
$ hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
teragen -Dmapreduce.job.maps=1000 10t random-data
```
2. perform the sort  
```shell
$ hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
terasort random-data sorted-data
```
3. validate the results  
```shell
$ hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
teravalidate sorted-data report
```

**There are many more Hadoop benchmarks, but the following are widely used**:  
* TestDFSIO tests the I/O performance of HDFS. It does this by using a MapReduce job as a convenient way to read or write files in parallel. 
* MRBench (invoked with mrbench) runs a small job a number of times. It acts as a good counterpoint to TeraSort, as it checks whether small job runs are responsive. 
* NNBench (invoked with nnbench) is useful for load-testing namenode hardware. 
* Gridmix is a suite of benchmarks designed to model a realistic cluster workload by mimicking a variety of data-access patterns seen in practice. See the documentation in the distribution for how to run Gridmix. 
* SWIM, or the Statistical Workload Injector for MapReduce, is a repository of real-life MapReduce workloads that you can use to generate representative test workloads for your system. 
* TPCx-HS is a standardized benchmark based on TeraSort from the Transaction Processing Performance Council.

For tuning, it is best to include a few jobs that are representative of the jobs that your users run, so your cluster is tuned for these and not just for the standard benchmarks. If this is your first Hadoop cluster and you don’t have any user jobs yet, then either Gridmix or SWIM is a good substitute.

## 11. Administering Hadoop

### HDFS Persistent Data Structures

#### Namenode directory structure
A running namenode has a directory structure like this:  
```html
${dfs.namenode.name.dir}/
├── current
│ ├── VERSION
│ ├── edits_0000000000000000001-0000000000000000019
│ ├── edits_inprogress_0000000000000000020
│ ├── fsimage_0000000000000000000
│ ├── fsimage_0000000000000000000.md5
│ ├── fsimage_0000000000000000019
│ ├── fsimage_0000000000000000019.md5
│ └── seen_txid
└── in_use.lock
```
The **VERSION** file is a Java properties file that contains information about the version of HDFS that is running. Here are the contents of a typical file:  
```json
#Mon Sep 29 09:54:36 BST 2014
namespaceID=1342387246
clusterID=CID-01b5c398-959c-4ea8-aae6-1e0d9bd8b142
cTime=0
storageType=NAME_NODE
blockpoolID=BP-526805057-127.0.0.1-1411980876842
layoutVersion=-57
```
* layoutVersion   
The layoutVersion is a negative integer that defines the version of HDFS’s persistent data structures. `Whenever the layout changes, the version number is decremented`. `When this happens, HDFS needs to be upgraded`, since a newer namenode (or datanode) will not operate if its storage layout is an older version. Upgrading HDFS is covered in “Upgrades” on page 337.  
* namespaceID  
The namespaceID is a unique identifier for the filesystem namespace, which is created when the namenode is first formatted. 
* clusterID  
The clusterID is a unique identifier for the HDFS cluster as a whole; this is important for HDFS federation, where a cluster is made up of multiple namespaces and each namespace is managed by one namenode. 
* blockpoolID  
The blockpoolID is a unique identifier for the block pool containing all the files in the namespace managed by this namenode.
* cTime  
The cTime property marks the creation time of the namenode’s storage. For newly formatted storage, the value is always zero, but it is updated to a timestamp whenever the filesystem is upgraded.   
* in_use.lock  
The in_use.lock file is a lock file that the namenode uses to lock the storage directory. This prevents another namenode instance from running at the same time with (and possibly corrupting) the same storage directory.

#### The filesystem image and edit log

When a filesystem client performs a write operation (such as creating or moving a file), the transaction is first recorded in the edit log. The namenode also has an in-memory representation of the filesystem metadata, which it(is?) updates after the edit log has been modified. `The in-memory metadata is used to serve read requests`.

Conceptually the edit log is a single entity, but it is represented as a number of files on disk. Each file is called a segment, and has the prefix edits and a suffix that indicates the transaction IDs contained in it. Only one file is open for writes at any one time (edits_inprogress_0000000000000000020 in the preceding example), and it is flushed and synced after every transaction, before a success code is returned to the client. For namenodes that write to multiple directories, the write must be flushed and synced to every copy before returning successfully. This ensures that no transaction is lost due to machine failure.

Each fsimage file is a complete persistent checkpoint of the filesystem metadata. (The suffix indicates the last transaction in the image.) However, `it is not updated for every filesystem write operation`, because writing out the fsimage file, which can grow to be gigabytes in size, would be very slow. This does not compromise resilience because if the namenode fails, then the latest state of its metadata can be reconstructed by loading the latest fsimage from disk into memory, and then applying each of the transactions from the relevant point onward in the edit log. In fact, this is precisely what the namenode does when it starts up (see “Safe Mode” on page 322).

Each fsimage file contains `a serialized form of all the directory and file inodes` in the filesystem. Each inode is an internal representation of a file or directory’s metadata and contains such information as the file’s replication level, modification and access times, access permissions, `block size, and the blocks the file is made up of`. For directories, the modification time, permissions, and quota metadata are stored.  
`An fsimage file does not record the datanodes on which the blocks are stored`. Instead, the namenode `keeps this mapping in memory`, which it constructs by asking the datanodes for their block lists when they join the cluster and periodically afterward to ensure the namenode’s block mapping is up to date.

![hadoop_secondary_namenode_checkpoint_img_1]  
**Figure 11-1. The checkpointing process**  

The solution is to run the secondary namenode, whose purpose is to produce checkpoints of the primary’s in-memory filesystem metadata. The checkpointing process proceeds as follows:  
1. The secondary asks the primary to roll its in-progress edits file, so new edits go to a new file. `The primary also updates the seen_txid file in all its storage directories`(Why now, fsimage_seen_txid.ckpt isn't ready now).  
2. The secondary retrieves the latest fsimage and edits files from the primary (using HTTP GET).  
3. The secondary loads fsimage into memory, applies each transaction from edits, then creates a new merged fsimage file.  
4. The secondary sends the new fsimage back to the primary (using HTTP PUT), and the primary saves it as a temporary .ckpt file.   
5. The primary renames the temporary fsimage file to make it available.

At the end of the process, the primary has an up-to-date fsimage file and a short inprogress edits file (it is not necessarily empty, as it may have received some edits while the checkpoint was being taken). It is possible for an administrator to run this process manually while the namenode is in safe mode, using the `hdfs dfsadmin -saveNamespace` command.

This procedure makes it clear why the secondary has similar memory requirements to the primary (since it loads the fsimage into memory), which is the reason that the secondary needs a dedicated machine on large clusters. 

The schedule for checkpointing is controlled by two configuration parameters. The secondary namenode checkpoints every hour (`dfs.namenode.checkpoint.period` in seconds), or sooner if the edit log has reached one million transactions since the last checkpoint (`dfs.namenode.checkpoint.txns`), which it checks every minute (`dfs.namenode.checkpoint.check.period` in seconds).

The layout of the secondary’s checkpoint directory (`dfs.namenode.checkpoint.dir`) is identical to the namenode’s. This is by design, since in the event of total namenode failure, it allows recovery from a secondary namenode. This can be achieved either by copying the relevant storage directory to a new namenode or, if the secondary is taking over as the new primary namenode, by using the -importCheckpoint option when starting the namenode daemon.  
The -importCheckpoint option will load the namenode metadata from the latest checkpoint in the directory defined by the dfs.namenode.checkpoint.dir property, but only if there is no metadata in the dfs.namenode.name.dir directory, to ensure that there is no risk of overwriting precious metadata.

#### Datanode directory structure
Unlike namenodes, datanodes do not need to be explicitly formatted, because they create
their storage directories automatically on startup. Here are the key files and directories:
```html
${dfs.datanode.data.dir}/
├── current
│ ├── BP-526805057-127.0.0.1-1411980876842
│ │ └── current
│ │ ├── VERSION
│ │ ├── finalized
│ │ │ ├── blk_1073741825
│ │ │ ├── blk_1073741825_1001.meta
│ │ │ ├── blk_1073741826
│ │ │ └── blk_1073741826_1002.meta
│ │ └── rbw
│ └── VERSION
└── in_use.lock
```

HDFS blocks are stored in files with a blk_ prefix; they consist of the raw bytes of a portion of the file being stored(PS: a file containing multiple blocks). Each block has an associated metadata file with a .meta suffix. It is made up of a header with version and type information, followed by a series of checksums for sections of the block.  
Each block belongs to a block pool, and each block pool has its own storage directory that is formed from its ID (it’s the same block pool ID from the namenode’s VERSION file, BP-526805057-127.0.0.1-1411980876842 in this case). 
`When the number of blocks in a directory grows to a certain size, the datanode creates a new subdirectory in which to place new blocks and their accompanying metadata`. It creates a new subdirectory every time the number of blocks in a directory reaches 64 (set by the `dfs.datanode.numblocks` configuration property). `The effect is to have a tree with high fan-out, so even for systems with a very large number of blocks, the directories will be only a few levels deep`, and avoids the problems that most operating systems encounter when there are a large number of files (tens or hundreds of thousands) in a single directory.

### HDFS Safe Mode
`When the namenode starts, the first thing it does is load its image file (fsimage) into memory and apply the edits from the edit log`. Once it has reconstructed a consistent in-memory image of the filesystem metadata, it creates a new fsimage file (effectively doing the checkpoint itself, without recourse to the secondary namenode) and an empty edit log. `During this process, the namenode is running in safe mode, which means that it offers only a read-only view of the filesystem to clients.`   
Strictly speaking, in safe mode, only filesystem operations that access the filesystem metadata (such as producing a directory listing) are guaranteed to work. Reading a file will work only when the blocks are available on the current set of datanodes in the cluster, and file modifications (writes, deletes, or renames) will always fail.

Safe mode is needed to give the datanodes time to check in to the namenode with their block lists, so the namenode can be informed of enough block locations to run the filesystem effectively. `If the namenode didn’t wait for enough datanodes to check in, it would start the process of replicating blocks to new datanodes, which would be unnecessary in most cases`. Indeed, while in safe mode, the namenode does not issue any block-replication or deletion instructions to datanodes.

Safe mode is exited when the minimal replication condition is reached, plus an extension time of 30 seconds. The minimal replication condition is when 99.9% of the blocks in the whole filesystem meet their minimum replication level (which defaults to 1 and is set by `dfs.namenode.replication.min`; see Table 11-1). `dfs.namenode.safemode.threshold-pct` and `dfs.namenode.safemode.extension`  

When you are starting a newly formatted HDFS cluster, the namenode does not go into safe mode, since there are no blocks in the system.

To see whether the namenode is in safe mode, you can use the dfsadmin command:  
```shell
$ hdfs dfsadmin -safemode get
Safe mode is ON
```
The front page of the HDFS web UI provides another indication of whether the namenode is in safe mode.  
Sometimes you want to wait for the namenode to exit safe mode before carrying out a command, particularly in scripts. The wait option achieves this:  
```shell
$ hdfs dfsadmin -safemode wait
# command to read or write a file
```
An administrator has the ability to make the namenode enter or leave safe mode at anytime. It is sometimes necessary to do this when carrying out maintenance on the cluster or after upgrading a cluster, to confirm that data is still readable. To enter safe mode, use the following command:  
```shell
$ hdfs dfsadmin -safemode enter
Safe mode is ON
```
You can use this command when the namenode is still in safe mode while starting up to ensure that it never leaves safe mode.   Another way of making sure that the namenode stays in safe mode indefinitely is to set the property `dfs.namenode.safemode.threshold-pct` to a value over 1.  
You can make the namenode leave safe mode by using the following:  
```shell
$ hdfs dfsadmin -safemode leave
Safe mode is OFF
```

### HDFS Audit Logging
HDFS can log all filesystem access requests, a feature that some organizations require for auditing purposes. Audit logging is implemented using log4j logging at the INFO level. In the default configuration it is disabled, but it’s easy to enable by adding the following line to hadoop-env.sh:  
```shell
export HDFS_AUDIT_LOGGER="INFO,RFAAUDIT" 
```
A log line is written to the audit log (`hdfs-audit.log`) for every HDFS event. Here’s an example for a list status request on /user/tom:  
```html
2014-09-30 21:35:30,484 INFO FSNamesystem.audit: allowed=true ugi=tom
(auth:SIMPLE) ip=/127.0.0.1 cmd=listStatus src=/user/tom dst=null
perm=null proto=rpc
```

### HDFS Tools
* dfsadmin  
The dfsadmin tool is a multipurpose tool for finding information about the state of HDFS, as well as for performing administration operations on HDFS. It is invoked as hdfs dfsadmin and requires superuser privileges.
* Filesystem check (fsck)   
Hadoop provides an fsck utility for checking the health of files in HDFS. The tool looks for blocks that are missing from all datanodes, as well as under- or over-replicated blocks, and etc. Here is an example of checking the whole filesystem for a small cluster:   
```shell
$ hdfs fsck /
```
```html
......................Status: HEALTHY
Total size: 511799225 B
Total dirs: 10
Total files: 22
Total blocks (validated): 22 (avg. block size 23263601 B)
Minimally replicated blocks: 22 (100.0 %)
Over-replicated blocks: 0 (0.0 %)
Under-replicated blocks: 0 (0.0 %)
Mis-replicated blocks: 0 (0.0 %)
Default replication factor: 3
Average block replication: 3.0
Corrupt blocks: 0
Missing replicas: 0 (0.0 %)
Number of data-nodes: 4
Number of racks: 1
The filesystem under path '/' is HEALTHY
```
Note that fsck retrieves all of its information from the namenode; it does not communicate with any datanodes to actually retrieve any block data.     

    1. Not problem cases  
        1. Over-replicated blocks  
        HDFS will automatically delete excess replicas  
        2. Under-replicated blocks  
        HDFS will automatically create new replicas.   
        You can get information about the blocks being replicated (or waiting to be replicated) using `hdfs dfsadmin -metasave`.  
        3. Misreplicated blocks   
        These are blocks that do not satisfy the block replica placement policy, HDFS will automatically re-replicate misreplicated blocks so that they satisfy the rack placement policy.   
    2. Problems  
        1. Corrupt blocks   
        These are blocks whose replicas are all corrupt.  
        Blocks with at least one noncorrupt replica are not reported as corrupt; the namenode will replicate the noncorrupt replica until the target replication is met.  
        2. Missing replicas  
        These are blocks with no replicas anywhere in the cluster  
    Corrupt or missing blocks are the biggest cause for concern, as they mean data has been lost. By default, fsck leaves files with corrupt or missing blocks, but you can tell it to perform one of the following actions on them:  
    * Move the affected files to the /lost+found directory in HDFS, using the -move option.  
    Files are broken into chains of contiguous blocks to aid any salvaging efforts you may attempt.   
    * Delete the affected files, using the -delete option.  
    Files cannot be recovered after being deleted.  
The fsck tool provides an easy way to find out which blocks are in any particular file. For example:  
```shell
$ hdfs fsck /user/tom/part-00007 -files -blocks -racks
```
* Datanode block scanner  
`Every datanode runs a block scanner`, which periodically verifies all the blocks stored on the datanode.  
It employs a throttling mechanism to preserve disk bandwidth on the datanode.  
Blocks are verified every three weeks to guard against disk errors over time (this period is controlled by the `dfs.datanode.scan.period.hours` property, which defaults to 504 hours). Corrupt blocks are reported to the namenode to be fixed.  
http://datanode:50075/blockScannerReport   
http://datanode:50075/blockScannerReport?listblocks  
* Balancer  
Over time, the distribution of blocks across datanodes can become unbalanced.  An unbalanced cluster can affect locality for MapReduce, and it puts a greater strain on the highly utilized datanodes, so it’s best avoided.  
The `balancer` program is a Hadoop daemon that redistributes blocks by moving them from overutilized datanodes to underutilized datanodes.  
It moves blocks until the cluster is deemed to be balanced, which means that the utilization of every datanode (ratio of used space on the node to total capacity of the node) differs from the utilization of the cluster (ratio of used space on the cluster to total capacity of the cluster) by no more than a given threshold percentage(-threshold argument, 10% by default). You can start the balancer with:  
```shell
$ start-balancer.sh
```
At any one time, only one balancer may be running on the cluster.  
The balancer is designed to run in the background without unduly taxing the cluster or interfering with other clients using the cluster. `It limits the bandwidth that it uses to copy a block from one node to another`. The default is a modest 1 MB/s, but this can be changed by setting the `dfs.datanode.balance.bandwidthPerSec` property in hdfs-site.xml, specified in bytes.  

### Monitoring
In addition to the facilities described next, some administrators run test jobs on a periodic basis as a test of the cluster’s health.
#### Logging
##### Setting log levels
Hadoop daemons have a web page for changing the log level for any log4j log name, which can be found at /logLevel in the daemon’s web UI.  For example,  visit http://resource-manager-host:8088/logLevel and set the log name org.apache.hadoop.yarn.server.resourcemanager to level DEBUG.  

The same thing can be achieved from the command line as follows:  
```shell
$ hadoop daemonlog -setlevel resource-manager-host:8088 \
org.apache.hadoop.yarn.server.resourcemanager DEBUG
```

Or change the log4j.properties file in the configuration directory.

Log levels changed in this way are reset when the daemon restarts.  

##### Getting stack traces
Hadoop daemons expose a web page (/stacks in the web UI) that produces a thread dump for all running threads in the `daemon’s JVM`. For example, you can get a thread dump for a resource manager from http://resource-manager-host:8088/stacks

#### Metrics and JMX
Metrics belong to a context; “dfs", “mapred,” “yarn,” and “rpc” are examples of different contexts. Hadoop daemons usually collect metrics under several contexts. For example, datanodes collect metrics for the “dfs” and “rpc” contexts.  

**How Do Metrics Differ from Counters?**  
`The main difference is their scope: metrics are collected by Hadoop daemons, whereas counters (see “Counters” on page 247) are collected for MapReduce tasks and aggregated for the whole job`. They have different audiences, too: broadly speaking, metrics are for administrators, and counters are for MapReduce users.

The way they are collected and aggregated is also different. Counters are a MapReduce feature, and the MapReduce system ensures that counter values are propagated from the task JVMs where they are produced back to the application master, and finally back to the client running the MapReduce job. (`Counters are propagated via RPC heartbeats`; see “Progress and Status Updates” on page 190.) `Both the task process and the application master perform aggregation.`  
The collection mechanism for metrics is decoupled from the component that receives the updates, and there are `various pluggable outputs, including local files, Ganglia, and JMX`. `The daemon collecting the metrics performs aggregation on them` before they are sent to the output.

`All Hadoop metrics are published to JMX` (Java Management Extensions), so you can use standard JMX tools like JConsole (which comes with the JDK) to view them. For remote monitoring, you must set the JMX system property `com.sun.management.jmxremote.port` (and others for security) to allow access. To do this for the namenode, say, you would set the following in hadoop-env.sh: 
```shell
HADOOP_NAMENODE_OPTS="-Dcom.sun.management.jmxremote.port=8004"
```
You can also view JMX metrics (in JSON format) gathered by a particular Hadoop daemon by connecting to its /jmx web page. This is handy for debugging. For example, you can view namenode metrics at http://namenode-host:50070/jmx.  

Hadoop comes with a number of metrics sinks for publishing metrics to external systems, such as local files or the Ganglia monitoring system. Sinks are configured in the `hadoop-metrics2.properties` file; see that file for sample configuration settings.

### Maintenance
#### Routine Administration Procedures
##### Metadata backups
**To backup namenode’s persistent metadata**.    
A straightforward way to make backups is to use the dfsadmin command to download a copy of the namenode’s most recent fsimage:  
```shell
$ hdfs dfsadmin -fetchImage fsimage.backup
```

You can write a script to run this command from an offsite location to store archive copies of the fsimage. The script should additionally test the integrity of the copy. `This can be done by starting a local namenode daemon and verifying that it has successfully read the fsimage and edits files into memory` (by scanning the namenode log for the appropriate success message, for example). Or else, Hadoop comes with an `Offline Image Viewer` and an `Offline Edits Viewer`, which can be used to check the integrity of the fsimage and edits files, Type `hdfs oiv` and `hdfs oev` to invoke these tools.

##### Data backups
Do not make the mistake of thinking that HDFS replication is a substitute for making backups. Bugs in HDFS can cause replicas to be lost, and so can hardware failures. Although Hadoop is expressly designed so that hardware failure is very unlikely to result in data loss, the possibility can never be completely ruled out, particularly when combined with software bugs or human error.  

The `distcp` tool is ideal for making backups to other HDFS clusters or other Hadoop filesystems (such as S3) because it can copy files in parallel. 

HDFS allows administrators and users to take **snapshots** of the filesystem. A snapshot is a read-only copy of a filesystem subtree at a given point in time. `Snapshots are very efficient since they do not copy data`; `they simply record each file’s metadata and block list, which is sufficient to reconstruct the filesystem contents at the time the snapshot was taken.`  
Snapshots are not a replacement for data backups, but they are a useful tool for point-in-time data recovery for files that were mistakenly deleted by users.  

#### Commissioning and Decommissioning Nodes
Datanodes that are permitted to connect to the namenode are specified in a file whose name is specified by the `dfs.hosts` property. The file resides on the namenode’s local filesystem.  
Similarly, node managers that may connect to the resource manager are specified in a file whose name is specified by the `yarn.resourcemanager.nodes.include-path` property.  
In most cases, there is one shared file, referred to as the `include` file, that both dfs.hosts and yarn.resourcemanager.nodes.include-path refer to, since nodes in the cluster run both datanode and node manager daemons.

The file (or files) specified by the `dfs.hosts` and `yarn.resourcemanager.nodes.include-path` properties is different from the `slaves` file. The former is used by the namenode and resource manager to determine which worker nodes may connect. The **slaves** file is used by the `Hadoop control scripts` to perform clusterwide operations, such as cluster restarts. It is `never used by the Hadoop daemons`.

**To add new nodes to the cluster**:  
1. Add the network addresses of the new nodes to the include file.  
2. Update the namenode with the new set of permitted datanodes using this command:  
```shell
$ hdfs dfsadmin -refreshNodes
```
3. Update the resource manager with the new set of permitted node managers using:  
```shell
$ yarn rmadmin -refreshNodes 
```
4. Update the slaves file with the new nodes, so that they are included in future operations performed by the Hadoop control scripts. 
5. Start the new datanodes and node managers. 
6. Check that the new datanodes and node managers appear in the web UI.  

`HDFS will not move blocks from old datanodes to new datanodes to balance the cluster. To do this, you should run the balancer` described in “Balancer” on page 329.

The way to decommission datanodes is to inform the namenode of the nodes that you wish to take out of circulation, so that it can `replicate the blocks to other datanodes before the datanodes are shut down`.  

The decommissioning process is controlled by an exclude file, which is set for HDFS by the `dfs.hosts.exclude` property and for YARN by the `yarn.resourcemanager.nodes.exclude-path` property. It is often the case that these properties refer to the same file. The exclude file lists the nodes that are not permitted to connect to the cluster.

The rules for whether a node manager may connect to the resource manager are simple: a node manager may connect only if it appears in the include file and does not appear in the exclude file.  
For HDFS, the rules are slightly different. If a datanode appears in both the include and the exclude file, then it may connect, but only to be decommissioned.  

**To remove nodes from the cluster:**  
1. Add the network addresses of the nodes to be decommissioned to the exclude file. `Do not update the include file at this point`.  
2. Update the namenode with the new set of permitted datanodes, using this command:  
```shell
$ hdfs dfsadmin -refreshNodes 
```
3. Update the resource manager with the new set of permitted node managers using:  
```shell
$ yarn rmadmin -refreshNodes
```
4. Go to the web UI and check whether the admin state has changed to “Decommission In Progress” for the datanodes being decommissioned. They will start copying their blocks to other datanodes in the cluster.  
5. When all the datanodes report their state as “Decommissioned,” all the blocks have been replicated. Shut down the decommissioned nodes.  
6. Remove the nodes from the include file, and run:   
```shell
$ hdfs dfsadmin -refreshNodes 
$ yarn rmadmin -refreshNodes
```
7. Remove the nodes from the slaves file.

#### Upgrades
The most important consideration is the HDFS upgrade. If the layout version of the filesystem has changed, then `the upgrade will automatically migrate` the filesystem data and metadata to a format that is compatible with the new version. As with any procedure that involves data migration, there is a risk of data loss, so you should be sure that `both your data and the metadata are backed up` (see “Routine Administration Procedures” on page 332).  

`Upgrading a cluster when the filesystem layout has not changed is fairly straightforward`: install the new version of Hadoop on the cluster (and on clients at the same time), shut down the old daemons, update the configuration files, and then start up the new daemons and switch clients to use the new libraries. This process is reversible, so rolling back an upgrade is also straightforward. After every successful upgrade, you should perform a couple of final cleanup steps:  
1. Remove the old installation and configuration files from the cluster. 
2. Fix any deprecation warnings in your code and configuration.

Upgrades are where Hadoop cluster management tools like Cloudera Manager and Apache Ambari come into their own. They simplify the upgrade process and also make it easy to do `rolling upgrades`, where nodes are upgraded in batches (or one at a time for master nodes), so that clients don’t experience service interruptions.

Part of the planning process should include `a trial run on a small test cluster` with a copy of data that you can afford to lose. A trial run will allow you to familiarize yourself with the process, customize it to your particular cluster configuration and toolset, and iron out any snags before running the upgrade procedure on a production cluster. A test cluster also has the benefit of being available to test client upgrades on. You can read about general compatibility concerns for clients in the following sidebar.

##### HDFS data and metadata upgrades
If you use the procedure just described to upgrade to a new version of HDFS and it expects a different layout version, following procedures are required.

The most reliable way of finding out whether you need to upgrade the filesystem is by `performing a trial on a test cluster`.

With these preliminaries out of the way, here is the high-level procedure for upgrading a cluster when the filesystem layout needs to be migrated:  
1. Ensure that any previous upgrade is finalized before proceeding with another upgrade.  
```shell
$ $NEW_HADOOP_HOME/bin/hdfs dfsadmin -finalizeUpgrade
$ $NEW_HADOOP_HOME/bin/hdfs dfsadmin -upgradeProgress status
There are no upgrades in progress.
```
2. Shut down the YARN and MapReduce daemons.
3. Shut down HDFS, and back up the namenode directories.
4. Install the new version of Hadoop on the cluster and on clients.
5. Start HDFS with the -upgrade option.  
```shell
$ $NEW_HADOOP_HOME/bin/start-dfs.sh -upgrade
```
This causes the namenode to upgrade its metadata, placing the previous version in a new directory called previous under dfs.namenode.name.dir. Similarly, datanodes upgrade their storage directories, preserving the old copy in a directory called previous.  
6. Wait until the upgrade is complete.
```shell
$ $NEW_HADOOP_HOME/bin/hdfs dfsadmin -upgradeProgress status
```
7. Perform some sanity checks on HDFS.  
(e.g., check files and blocks using fsck, test basic file operations). You might choose to put HDFS into safe mode while you are running some of these checks (the ones that are read-only) to prevent others from making changes.  
8. Start the YARN and MapReduce daemons.
9. Roll back or finalize the upgrade (optional).  
    1. Roll back  
    First, shut down the new daemons:  
    ```shell
    $ $NEW_HADOOP_HOME/bin/stop-dfs.sh
    ```
    Then start up the old version of HDFS with the -rollback option:  
    ```shell
    $ $OLD_HADOOP_HOME/bin/start-dfs.sh -rollback
    ```

An upgrade of HDFS makes a copy of the previous version’s metadata and data. `Doing an upgrade does not double the storage requirements of the cluster, as the datanodes use hard links to keep two references (for the current and previous version) to the same block of data`. This design makes it straightforward to roll back to the previous version of the filesystem, if you need to. You should understand that any changes made to the data on the upgraded system will be lost after the rollback completes, however.   

You can keep only the previous version of the filesystem, which means you can’t roll back several versions. Therefore, to carry out another upgrade to HDFS data and metadata, you will need to delete the previous version, a process called `finalizing the upgrade`. Once an upgrade is finalized, there is no procedure for rolling back to a previous version.

##### Compatibility
There are several aspects to consider: API compatibility, data compatibility, and wire compatibility.  

API compatibility concerns the contract between user code and the published Hadoop APIs, such as the Java MapReduce APIs. Major releases (e.g., from 1.x.y to 2.0.0) are allowed to break API compatibility, so user programs may need to be modified and recompiled. Minor releases (e.g., from 1.0.x to 1.1.0) and point releases (e.g., from 1.0.1 to 1.0.2) should not break compatibility.  
Hadoop uses a classification scheme for API elements to denote their stability. The preceding rules for API compatibility cover those elements that are marked InterfaceStability.Stable. Some elements of the public Hadoop APIs, however, are marked with the InterfaceStability.Evolving or InterfaceStability.Unstable annotations, which mean they are allowed to break compatibility on minor and point releases, respectively.

Data compatibility concerns persistent data and metadata formats, such as the format in which the HDFS namenode stores its persistent data. The formats can change across minor or major releases, but `the change is transparent to users because the upgrade will automatically migrate the data`. There may be some restrictions about upgrade paths, and these are covered in the release notes.

Wire compatibility concerns the interoperability between clients and servers via wire protocols such as RPC and HTTP. The rule for wire compatibility is that the `client must have the same major release number as the server, but may differ in its minor or point release number`.  The fact that internal client and server versions can be mixed allows Hadoop 2 to support `rolling upgrades`.

## 14. Flume
For more detail, see [Using Flume] by Hari Shreedharan (O’Reilly, 2014). There is also a lot of practical information about designing ingest pipelines (and building Hadoop applications in general) in [Hadoop Application Architectures] by Mark Grover, Ted Malaska, Jonathan Seidman, and Gwen Shapira (O’Reilly, 2014). 

Many systems produce streams of data that we would like to aggregate, store, and analyze using Hadoop—and these are the systems that Apache Flume is an ideal fit for.

Flume is designed for `high-volume ingestion` of `event-based data` into Hadoop. The canonical example is using Flume to collect logfiles from a bank of web servers, then moving the log events from those files into new aggregated files in HDFS for processing. The usual destination (or sink in Flume parlance) is `HDFS`. However, Flume is flexible enough to write to other systems, like `HBase or Solr`.

To use Flume, we need to run a Flume agent, which is a long-lived Java process that runs sources and sinks, connected by channels. A source in Flume produces events and delivers them to the channel, which stores the events until they are forwarded to the sink. You can think of the source-channel-sink combination as a basic Flume building block.

`A Flume installation is made up of a collection of connected agents running in a distributed topology`. Agents on the edge of the system (co-located on web server machines, for example) collect data and forward it to agents that are responsible for aggregating and then storing the data in its final destination. `Agents are configured to run a collection of particular sources and sinks, so using Flume is mainly a configuration exercise in wiring the pieces together`. In this chapter, we’ll see how to build Flume topologies for data ingestion that you can use as a part of your own Hadoop pipeline.

### Installing Flume
Download a stable release of the Flume binary distribution from the [Flume Download Page], and unpack the tarball in a suitable location:  
```shell
$ export FLUME_HOME=~/sw/apache-flume-x.y.z-bin
$ export PATH=$PATH:$FLUME_HOME/bin
```
A Flume agent can then be started with the `flume-ng` command.

### An Flume Example
To show how Flume works, let’s start with a setup that:  
1. Watches a local directory for new text files
2. Sends each line of each file to the console as files are added

In this example, the Flume agent runs a single source-channel-sink, configured using a Java properties file. The configuration controls the types of sources, sinks, and channels that are used, as well as how they are connected together. For this example, we’ll use the configuration in Example 14-1.
```properties
agent1.sources = source1
agent1.sinks = sink1
agent1.channels = channel1

agent1.sources.source1.channels = channel1
agent1.sinks.sink1.channel = channel1

agent1.sources.source1.type = spooldir
agent1.sources.source1.spoolDir = /tmp/spooldir

agent1.sinks.sink1.type = logger

agent1.channels.channel1.type = file
```
Property names form a hierarchy with the agent name at the top level. In this example, we have a single agent, called agent1.
In this case, agent1.sources.source1.type is set to `spooldir`, which is a spooling directory source that monitors a spooling directory for new files. The spooling directory source defines a spoolDir property.  
The sink is a logger sink for logging events to the console. It too must be connected to the channel (with the `agent1.sinks.sink1.channel` property).1 The channel is `a file channel, which means that events in the channel are persisted to disk for durability`. 

Note that a source has a channels property (plural) but a sink has a channel property (singular). This is because `a source can feed more than one channel` (see “Fan Out” on page 388), but `a sink can only be fed by one channel`. `It’s also possible for a channel to feed multiple sinks`. This is covered in “Sink Groups” on page 395.  
```shell
$ flume-ng agent \
--conf-file spool-to-logger.properties \
--name agent1 \
--conf $FLUME_HOME/conf \
-Dflume.root.logger=INFO,console
```
The Flume properties file from Example 14-1 is specified with the --conf-file flag. The agent name must also be passed in with --name (since a Flume properties file can define several agents, we have to say which one to run). The --conf flag tells Flume where to find its general configuration, such as environment settings.

In a new terminal, create a file in the spooling directory. The spooling directory source expects files to be immutable. To prevent partially written files from being read by the source, we write the full contents to a hidden file. Then, `we do an atomic rename` so the source can read it:  
```shell
$ echo "Hello Flume" > /tmp/spooldir/.file1.txt 
$ mv /tmp/spooldir/.file1.txt /tmp/spooldir/file1.txt
```

Back in the agent’s terminal, we see that Flume has detected and processed the file:  
```html
Preparing to move file /tmp/spooldir/file1.txt to
/tmp/spooldir/file1.txt.COMPLETED
Event: { headers:{} body: 48 65 6C 6C 6F 20 46 6C 75 6D 65 Hello Flume }

...
2017-11-22 15:00:13,520 (pool-4-thread-1) [INFO - org.apache.flume.client.avro.ReliableSpoolingFileEventReader.rollCurrentFile(ReliableSpoolingFileEventReader.java:433)] Preparing to move file /tmp/spooldir/msg2 to /tmp/spooldir/msg2.COMPLETED
2017-11-22 15:00:14,135 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:95)] Event: { headers:{} body: 48 65 6C 6C 6F 20 46 6C 75 6D 65                Hello Flume }
2017-11-22 15:00:14,168 (SinkRunner-PollingRunner-DefaultSinkProcessor) [INFO - org.apache.flume.sink.LoggerSink.process(LoggerSink.java:95)] Event: { headers:{} body: 48 65 6C 6C 6F 20 46 6C 75 6D 65 20 32          Hello Flume 2 }
```
The spooling directory source ingests the file by `splitting it into lines and creating a Flume event for each line`. `Events have optional headers and a binary body, which is the UTF-8 representation of the line of text. The body is logged by the logger sink in both hexadecimal and string form`. The file we placed in the spooling directory was only one line long, so only one event was logged in this case. `We also see that the file was renamed to file1.txt.COMPLETED by the source, which indicates that Flume has completed processing it and won’t process it again`.

### Transactions and Reliability
`Flume uses separate transactions to guarantee delivery from the source to the channel and from the channel to the sink`.  

Similarly, a transaction is used for the delivery of the events from the channel to the sink. `If for some unlikely reason the events could not be logged, the transaction would be rolled back and the events would remain in the channel for later redelivery`.

`The source will only mark the file as completed once the transactions encapsulating the delivery of the events to the channel have been successfully committed`.

`The channel we are using is a file channel, which has the property of being durable: once an event has been written to the channel, it will not be lost, even if the agent restarts`. (Flume also provides a memory channel that does not have this property, since events are stored in memory. With this channel, events are lost if the agent restarts. Depending on the application, this might be acceptable. The trade-off is that `the memory channel has higher throughput than the file channel`.)

The major caveat here is that every event will reach the sink `at least once`—that is, duplicates are possible. Duplicates can be produced in sources or sinks: for example, after an agent restart, the spooling directory source will redeliver events for an uncompleted file, even if some or all of them had been committed to the channel before the restart. After a restart, the logger sink will re-log any event that was logged but not committed (which could happen if the agent was shut down between these two operations).  

At-least-once semantics might seem like a limitation, but in practice it is an acceptable performance trade-off. The stronger semantics of **exactly once** `require a two-phase commit protocol`, which is expensive. `This choice is what differentiates Flume (at-least-once semantics) as a high-volume parallel event ingest system from more traditional enterprise messaging systems (exactly-once semantics)`. With at-least-once semantics, duplicate events can be removed further down the processing pipeline. Usually this takes the form of `an application-specific deduplication job` written in MapReduce or Hive.

#### Flume Batching
For efficiency, Flume tries to process events in batches for each transaction, where possible, rather than one by one. Batching helps file channel performance in particular, since every transaction results in a local disk write and fsync call. (batchSize property)

### The HDFS Sink
The point of Flume is to deliver large amounts of data into a Hadoop data store, so let’s look at how to configure a Flume agent to deliver events to an HDFS sink. The configuration in Example 14-2 updates the previous example to use an HDFS sink.  
**Example 14-2. Flume configuration using a spooling directory source and an HDFS sink**  
```properties
agent1.sources = source1
agent1.sinks = sink1
agent1.channels = channel1

agent1.sources.source1.channels = channel1
agent1.sinks.sink1.channel = channel1

agent1.sources.source1.type = spooldir
agent1.sources.source1.spoolDir = /tmp/spooldir

agent1.sinks.sink1.type = hdfs
agent1.sinks.sink1.hdfs.path = /tmp/flume
agent1.sinks.sink1.hdfs.filePrefix = events
agent1.sinks.sink1.hdfs.fileSuffix = .log
agent1.sinks.sink1.hdfs.inUsePrefix = _
agent1.sinks.sink1.hdfs.fileType = DataStream

agent1.channels.channel1.type = file
```
Events will now be delivered to the HDFS sink and written to a file. Files in the process of being written to have a .tmp in-use suffix added to their name to indicate that they are not yet complete. In this example, we have also set hdfs.inUsePrefix to be _ (underscore; by default it is empty), which causes files in the process of being written to have that prefix added to their names. `This is useful since MapReduce will ignore files that have a _ prefix`. So, a typical temporary filename would be _events.1399295780136.log.tmp; the number is a timestamp generated by the HDFS sink.  

`hdfs.fileType` is set to DataStream, it is for plain text.

A file is kept open by the HDFS sink until it has either been open for a given time (default 30 seconds, controlled by the `hdfs.rollInterval` property), has reached a given size (default 1,024 bytes, set by `hdfs.rollSize`), or has had a given number of events written to it (default 10, set by `hdfs.rollCount`). If any of these criteria are met, the file is closed and its in-use prefix and suffix are removed. New events are written to a new file (which will have an in-use prefix and suffix until it is rolled).

After 30 seconds, we can be sure that the file has been rolled and we can take a look at its contents:  
```shell
$ hadoop fs -cat /tmp/flume/events.1399295780136.log
Hello
Again
```

The HDFS sink writes files as the user who is running the Flume agent, unless the `hdfs.proxyUser` property is set, in which case files will be written as that user.

#### Partitioning and Interceptors
Large datasets are often organized into partitions, so that processing can be restricted to particular partitions if only a subset of the data is being queried. For Flume event data, it’s very common to partition by time. A process can be run periodically that transforms completed partitions (to remove duplicate events, for example).

It’s easy to change the example to store data in partitions by setting `hdfs.path` to include subdirectories that use time format escape sequences:  
```properties
agent1.sinks.sink1.hdfs.path = /tmp/flume/year=%Y/month=%m/day=%d
```

`The partition that a Flume event is written to is determined by the timestamp header on the event`. `Events don’t have this header by default, but it can be added using a Flume interceptor`. **Interceptor**s are components that can modify or drop events in the flow; they are `attached to sources, and are run on events before the events have been placed in a channel`. The following extra configuration lines add a timestamp interceptor to source1, which adds a timestamp header to every event produced by the source:  
```properties
agent1.sources.source1.interceptors = interceptor1
agent1.sources.source1.interceptors.interceptor1.type = timestamp
```

Using the timestamp interceptor ensures that the timestamps closely reflect the times at which the events were created. For some applications, using a timestamp for when the event was written to HDFS might be sufficient—although, be aware that when there are multiple tiers of Flume agents there can be a significant difference between creation time and write time, especially in the event of agent downtime (see “Distribution: Agent Tiers” on page 390). For these cases, the HDFS sink has a setting, `hdfs.useLocal` TimeStamp, that will use a timestamp generated by the Flume agent running the HDFS sink.

#### HDFS Sink File Formats
For the HDFS sink, the file format used is controlled using `hdfs.fileType` and a combination of a few other properties.  

If unspecified, `hdfs.file`Type defaults to `SequenceFile`, which will write events to a sequence file with `LongWritable` keys that contain the event timestamp (or the current time if the timestamp header is not present) and `BytesWritable` values that contain the event body. It’s possible to use Text Writable values in the sequence file instead of BytesWritable by setting `hdfs.writeFormat` to Text.

The configuration is a little different for Avro files. The hdfs.fileType property is set to DataStream, just like for plain text. Additionally, `serializer` (note the lack of an hdfs. prefix) must be set to `avro_event`. To enable compression, set the `serializer.compressionCodec` property. Here is an example of an HDFS sink configured to write Snappy-compressed Avro files:
```properties
agent1.sinks.sink1.type = hdfs
agent1.sinks.sink1.hdfs.path = /tmp/flume
agent1.sinks.sink1.hdfs.filePrefix = events
agent1.sinks.sink1.hdfs.fileSuffix = .avro
agent1.sinks.sink1.hdfs.fileType = DataStream
agent1.sinks.sink1.serializer = avro_event
agent1.sinks.sink1.serializer.compressionCodec = snappy
```
An event is represented as an Avro record with two fields: headers, an Avro map with string values, and body, an Avro bytes field.   

If you want to use a custom Avro schema, there are a couple of options. If you have Avro in-memory objects that you want to send to Flume, then the Log4jAppender is appropriate. It allows you to log an Avro Generic, Specific, or Reflect object using a log4j Logger and send it to an Avro source running in a Flume agent (see “Distribution: Agent Tiers” on page 390). In this case, the `serializer` property for the HDFS sink should be set to `org.apache.flume.sink.hdfs.AvroEventSerializer$Builder`, and the Avro schema set in the header (see the class documentation).  
Alternatively, if the events are not originally derived from Avro objects, you can write a custom serializer to convert a Flume event into an Avro object with a custom schema. The helper class **AbstractAvroEventSerializer** in the `org.apache.flume.serialization` package is a good starting point.  

### Fan Out
Fan out is the term for delivering events from one source to multiple channels, so they reach multiple sinks. For example, the configuration in Example 14-3 delivers events to both an HDFS sink (sink1a via channel1a) and a logger sink (sink1b via channel1b).  
**Example 14-3. Flume configuration using a spooling directory source, fanning out to an HDFS sink and a logger sink**  
```properties
agent1.sources = source1
agent1.sinks = sink1a sink1b
agent1.channels = channel1a channel1b

agent1.sources.source1.channels = channel1a channel1b

agent1.sinks.sink1a.channel = channel1a
agent1.sinks.sink1b.channel = channel1b

agent1.sources.source1.type = spooldir
agent1.sources.source1.spoolDir = /tmp/spooldir

agent1.sinks.sink1a.type = hdfs
agent1.sinks.sink1a.hdfs.path = /tmp/flume
agent1.sinks.sink1a.hdfs.filePrefix = events
agent1.sinks.sink1a.hdfs.fileSuffix = .log
agent1.sinks.sink1a.hdfs.fileType = DataStream

agent1.sinks.sink1b.type = logger

agent1.channels.channel1a.type = file
agent1.channels.channel1b.type = memory
```
#### Delivery Guarantees
Flume uses `a separate transaction` to deliver `each batch of events` from the spooling directory source `to each channel`.  

If either of these transactions fails (if a channel is full, for example), then the events will not be removed from the source, and will be retried later.  

In this case, since we don’t mind if some events are not delivered to the logger sink, we can designate its channel as `an optional channel`, so that if the transaction associated with it fails, this will not cause events to be left in the source and tried again later. (Note that if the agent fails before both channel transactions have committed, then the affected events will be redelivered after the agent restarts—this is true even if the uncommitted channels are marked as optional.) To do this, we set the `selector.optional` property on the source, passing it a space-separated list of channels:  
```properties
agent1.sources.source1.selector.optional = channel1b
```

#### Near-Real-Time Indexing
Indexing events for search is a good example of where fan out is used in practice. A single source of events is sent to both an HDFS sink (this is the main repository of events, so a required channel is used) and a Solr (or Elasticsearch) sink, to build a search index (using an optional channel). The MorphlineSolrSink extracts fields from Flume events and transforms them into a Solr document (using a Morphline configuration file), which is then loaded into a live Solr search server. The process is called near real time since ingested data appears in search results in a matter of seconds.

#### Replicating and Multiplexing Selectors
In normal fan-out flow, events are replicated to all channels—but sometimes more selective behavior might be desirable, so that some events are sent to one channel and others to another. This can be achieved by setting a multiplexing selector on the source, and `defining routing rules that map particular event header values to channels`. See the [Flume User Guide] for configuration details.

### Distribution: Agent Tiers
**How do we scale a set of Flume agents?**  
If there is one agent running on every node producing raw data, then with the setup described so far, at any particular time each file being written to HDFS will consist entirely of the events from one node. `It would be better if we could aggregate the events from a group of nodes in a single file, since this would result in fewer, larger files. Also, if needed, files can be rolled more often since they are being fed by a larger number of nodes, leading to a reduction between the time when an event is created and when it’s available for analysis`.

![hadoop_flume_tier_img_1]  
**Figure 14-3. Using a second agent tier to aggregate Flume events from the first tier**  

`Aggregating Flume events is achieved by having tiers of Flume agents`. The first tier collects events from the original sources (such as web servers) and sends them to a smaller set of agents in the second tier, which aggregate events from the first tier before writing them to HDFS (see Figure 14-3). Further tiers may be warranted for very large numbers of source nodes.  

`Tiers are constructed by using a special sink that sends events over the network, and a corresponding source that receives events`. The `Avro sink` sends events over `Avro RPC to an Avro source` running in another Flume agent. There is also a `Thrift sink` that does the same thing using `Thrift RPC`, and is paired with a `Thrift source`.

Don’t be confused by the naming: `Avro sinks and sources do not provide the ability to write (or read) Avro files. They are used only to distribute events between agent tiers, and to do so they use Avro RPC to communicate (hence the name)`. `If you need to write events to Avro files, use the HDFS sink`, described in “File Formats” on page 387.

Example 14-4 shows a two-tier Flume configuration. Two agents are defined in the file, named agent1 and agent2. An agent of type agent1 runs in the first tier, and has a spooldir source and an Avro sink connected by a file channel. The agent2 agent runs in the second tier, and has an Avro source that listens on the port that agent1’s Avro sink sends events to. The sink for agent2 uses the same HDFS sink configuration from Example 14-2.

Notice that since there are two file channels running on the same machine, they are configured to point to different data and checkpoint directories (they are in the user’s home directory by default). This way, they don’t try to write their files on top of one another.  

**Example 14-4. A two-tier Flume configuration using a spooling directory source and an HDFS sink**  
```properties
# First-tier agent
agent1.sources = source1
agent1.sinks = sink1
agent1.channels = channel1

agent1.sources.source1.channels = channel1
agent1.sinks.sink1.channel = channel1

agent1.sources.source1.type = spooldir
agent1.sources.source1.spoolDir = /tmp/spooldir

agent1.sinks.sink1.type = avro
agent1.sinks.sink1.hostname = localhost
agent1.sinks.sink1.port = 10000

agent1.channels.channel1.type = file
agent1.channels.channel1.checkpointDir=/tmp/agent1/file-channel/checkpoint
agent1.channels.channel1.dataDirs=/tmp/agent1/file-channel/data

# Second-tier agent
agent2.sources = source2
agent2.sinks = sink2
agent2.channels = channel2

agent2.sources.source2.channels = channel2
agent2.sinks.sink2.channel = channel2

agent2.sources.source2.type = avro
agent2.sources.source2.bind = localhost
agent2.sources.source2.port = 10000

agent2.sinks.sink2.type = hdfs
agent2.sinks.sink2.hdfs.path = /tmp/flume
agent2.sinks.sink2.hdfs.filePrefix = events
agent2.sinks.sink2.hdfs.fileSuffix = .log
agent2.sinks.sink2.hdfs.fileType = DataStream

agent2.channels.channel2.type = file
agent2.channels.channel2.checkpointDir=/tmp/agent2/file-channel/checkpoint
agent2.channels.channel2.dataDirs=/tmp/agent2/file-channel/data
```

Each agent is run independently, using the same --conf-file parameter but different agent --name parameters:  
```shell
$ flume-ng agent --conf-file spool-to-hdfs-tiered.properties --name agent1 ...
and:
$ flume-ng agent --conf-file spool-to-hdfs-tiered.properties --name agent2 ...
```

#### Delivery Guarantees
`In the context of the Avro sink-source connection, transactions ensure that events are reliably delivered from one agent to the next`.  
The operation to read a batch of events from the file channel in agent1 by the Avro sink will be wrapped in a transaction. The transaction will only be committed once the Avro sink has received the (synchronous) confirmation that the write to the Avro source’s RPC endpoint was successful. This confirmation will only be sent once agent2’s transaction wrapping the operation to write the batch of events to its file channel has been successfully committed. Thus, the Avro sink-source pair guarantees that an event is delivered from one Flume agent’s channel to another Flume agent’s channel (at least once).

If either agent is not running, then clearly events cannot be delivered to HDFS. For example, if agent1 stops running, then files will accumulate in the spooling directory, to be processed once agent1 starts up again. Also, any events in an agent’s own file channel at the point the agent stopped running will be available on restart, due to the durability guarantee that file channel provides.

If agent2 stops running, then events will be stored in agent1’s file channel until agent2 starts again. Note, however, that channels necessarily have a limited capacity; `if agent1’s channel fills up while agent2 is not running, then any new events will be lost`. By default, a file channel will not recover more than one million events (this can be overridden by its capacity property), and it will stop accepting events if the free disk space for its checkpoint directory falls below 500 MB (controlled by the mini mumRequiredSpace property).  

Both these scenarios assume that the agent will eventually recover, but that is not always the case (if the hardware it is running on fails, for example). If agent1 doesn’t recover, then `the loss is limited to the events in its file channel that had not been delivered to agent2 before agent1 shut down`. In the architecture described here, there are multiple first-tier agents like agent1, so other nodes in the tier can take over the function of the failed node. For example, if the nodes are running load-balanced web servers, then other nodes will absorb the failed web server’s traffic, and they will generate new Flume events that are delivered to agent2. Thus, no new events are lost.

An unrecoverable agent2 failure is more serious, however. Any events in the channels of upstream first-tier agents (agent1 instances) will be lost, and all new events generated by these agents will not be delivered either. The solution to this problem is for agent1 `to have multiple redundant Avro sinks`, arranged in a `sink group`,(PS: active standby agent2 node is not eligible here) so that if the destination agent2 Avro endpoint is unavailable, it can try another sink from the group. We’ll see how to do this in the next section.  

### Sink Groups
A sink group allows multiple sinks to be `treated as one, for failover or load-balancing purposes` (see Figure 14-5). If a second-tier agent is unavailable, then events will be delivered to another second-tier agent and on to HDFS without disruption.

To configure a sink group, the agent’s sinkgroups property is set to define the sink group’s name; then the sink group lists the sinks in the group, and also the type of the **sink processor**, `which sets the policy for choosing a sink`. Example 14-5 shows the configuration for load balancing between two Avro endpoints.  

**Example 14-5. A Flume configuration for load balancing between two Avro endpoints using a sink group**  
```properties
agent1.sources = source1
agent1.sinks = sink1a sink1b
agent1.sinkgroups = sinkgroup1
agent1.channels = channel1

agent1.sources.source1.channels = channel1

agent1.sinks.sink1a.channel = channel1
agent1.sinks.sink1b.channel = channel1

agent1.sinkgroups.sinkgroup1.sinks = sink1a sink1b
agent1.sinkgroups.sinkgroup1.processor.type = load_balance
agent1.sinkgroups.sinkgroup1.processor.backoff = true

agent1.sources.source1.type = spooldir
agent1.sources.source1.spoolDir = /tmp/spooldir

agent1.sinks.sink1a.type = avro
agent1.sinks.sink1a.hostname = localhost
agent1.sinks.sink1a.port = 10000

agent1.sinks.sink1b.type = avro
agent1.sinks.sink1b.hostname = localhost
agent1.sinks.sink1b.port = 10001

agent1.channels.channel1.type = file
```
The processor type is set to **load_balance**, which attempts to distribute the event flow over both sinks in the group, using a `round-robin` selection mechanism (you can change this using the `processor.selector` property). `By default, sink unavailability is not remembered by the sink processor, so failing sinks are retried for every batch of events being delivered. This can be inefficient, so we have set the processor.backoff property to change the behavior so that failing sinks are blacklisted for an exponentially increasing timeout period` (up to a maximum period of 30 seconds, controlled by processor.selector.maxTimeOut).

There is another type of processor, **failover**, that instead of load balancing events across sinks uses a preferred sink if it is available, and fails over to another sink in the case that the preferred sink is down. ``The failover sink processor maintains a priority order for sinks in the group``, and attempts delivery in order of priority. If the sink with the highest priority is unavailable the one with the next highest priority is tried, and so on. Failed sinks are blacklisted for an increasing timeout period (up to a maximum period of 30 seconds, controlled by `processor.maxpenalty`).

**Example 14-6. Flume configuration for second-tier agent in a load balancing scenario**
```properties
# agent2a
agent2a.sources = source2a
agent2a.sinks = sink2a
agent2a.channels = channel2a

agent2a.sources.source2a.channels = channel2a
agent2a.sinks.sink2a.channel = channel2a

agent2a.sources.source2a.type = avro
agent2a.sources.source2a.bind = localhost
agent2a.sources.source2a.port = 10000

agent2a.sinks.sink2a.type = hdfs
agent2a.sinks.sink2a.hdfs.path = /tmp/flume
agent2a.sinks.sink2a.hdfs.filePrefix = events-a
agent2a.sinks.sink2a.hdfs.fileSuffix = .log
agent2a.sinks.sink2a.hdfs.fileType = DataStream

agent2a.channels.channel2a.type = file

# agent2b
agent2b.sources = source2b
agent2b.sinks = sink2b
agent2b.channels = channel2b

agent2b.sources.source2b.channels = channel2b
agent2b.sinks.sink2b.channel = channel2b

agent2b.sources.source2b.type = avro
agent2b.sources.source2b.bind = localhost
agent2b.sources.source2b.port = 10001

agent2b.sinks.sink2b.type = hdfs
agent2b.sinks.sink2b.hdfs.path = /tmp/flume
agent2b.sinks.sink2b.hdfs.filePrefix = events-b
agent2b.sinks.sink2b.hdfs.fileSuffix = .log
agent2b.sinks.sink2b.hdfs.fileType = DataStream

agent2b.channels.channel2b.type = file
```
![hadoop_flume_tier_load_balance_img_1]  
**Figure 14-6. Load balancing between two agents**  

In the more usual case of agents running on different machines, the hostname can be used to make the filename unique by configuring a host interceptor (see Table 14-1) and including the %{host} escape sequence in the file path, or prefix:  
```properties
agent2.sinks.sink2.hdfs.filePrefix = events-%{host}
```

###  Integrating Flume with Applications
An Avro source is an RPC endpoint that accepts Flume events, making it possible to `write an RPC client` to send events to the endpoint, which can be embedded in any application that wants to introduce events into Flume. The Flume SDK is a module that provides a Java **RpcClient** class for sending Event objects to an `Avro endpoint` (`an Avro source running in a Flume agent, usually in another tier`).   
Clients can be configured to fail over or load balance between endpoints, and `Thrift endpoints (Thrift sources)` are supported too.   

The Flume embedded agent offers similar functionality: it is a cut-down Flume agent that runs in a Java application. It has a single special source that your application sends Flume Event objects to by calling a method on the **EmbeddedAgent** object; the only sinks that are supported are Avro sinks, but it can be configured with multiple sinks for failover or load balancing. 

Both the SDK and the embedded agent are described in more detail in the [Flume Developer Guide].

## 15. Sqoop
For more information on using Sqoop, consult the [Apache Sqoop Cookbook] by Kathleen Ting and Jarek Jarcec Cecho (O’Reilly, 2013).   

Often, valuable data in an organization is stored in structured data stores such as relational database management systems (RDBMSs). Apache Sqoop is an open source tool that allows users to extract data `from a structured data store` into Hadoop for further processing. `This processing can be done with MapReduce programs or other higher-level tools such as Hive.` (It’s even possible to use Sqoop to move data `from a database into HBase`.) When the final results of an analytic pipeline are available, Sqoop can export these results back to the data store for consumption by other clients.

>Latest stable release is 1.4.6 (download, documentation). Latest cut of Sqoop2 is 1.99.7 (download, documentation). Note that 1.99.7 is not compatible with 1.4.6 and not feature complete, it is not intended for production deployment.
Last Published: 2017-03-16

**Installation**:    
Unzip binary installation file (sqoop-x.y.z.bin_*) from [hadoop_sqoop_homepage_1] and set environment variable: SQOOP_HOME.    
```shell
export SQOOP_HOME=/usr/local/sqoop
export PATH=$PATH:$SQOOP_HOME/bin
```

```shell
$  sqoop help
usage: sqoop COMMAND [ARGS]
```
```html
Available commands:
  codegen            Generate code to interact with database records
  create-hive-table  Import a table definition into Hive
  eval               Evaluate a SQL statement and display the results
  export             Export an HDFS directory to a database table
  help               List available commands
  import             Import a table from a database to HDFS
  import-all-tables  Import tables from a database to HDFS
  import-mainframe   Import datasets from a mainframe server to HDFS
  job                Work with saved jobs
  list-databases     List available databases on a server
  list-tables        List available tables in a database
  merge              Merge results of incremental imports
  metastore          Run a standalone Sqoop metastore
  version            Display version information

See 'sqoop help COMMAND' for information on a specific command.
```
An alternate way of running a Sqoop tool is to use a tool-specific script. This script will be named sqoop-toolname (e.g., sqoop-help, sqoop-import, etc.). Running these scripts from the command line is identical to running sqoop help or sqoop import.

`Sqoop 2` is a `rewrite` of Sqoop that addresses the architectural limitations of Sqoop 1. For example, Sqoop 1 is a command-line tool and does not provide a Java API, so it’s difficult to embed it in other programs. Also, `in Sqoop 1 every connector has to know about every output format, so it is a lot of work to write new connectors`. Sqoop 2 has a server component that runs jobs, as well as a range of clients: `a command-line interface (CLI)`, `a web UI, a REST API, and a Java API`. Sqoop 2 also will be able to use `alternative execution engines`, such as Spark. Note that Sqoop 2’s CLI is not compatible with Sqoop 1’s CLI.   
Sqoop 2 is under active development but does not yet have feature parity with Sqoop 1, whose latest release 1.99.7 (by 2017-03-16) is not compatible with 1.4.6 and not feature complete, it is not intended for production deployment.  

### Sqoop Connectors
Sqoop has `an extension framework` that makes it possible to import data from—and export data to—any external storage system that has `bulk data transfer capabilities`. A Sqoop connector is a modular component that uses this framework to enable Sqoop imports and exports. Sqoop ships with connectors for working with a range of popular databases, including MySQL, PostgreSQL, Oracle, SQL Server, DB2, and Netezza. There is also a generic JDBC connector for connecting to any database that supports Java’s JDBC protocol. Sqoop provides `optimized MySQL, PostgreSQL, Oracle, and Netezza connectors` that use database-specific APIs to perform bulk transfers more efficiently (this is discussed more in “Direct-Mode Imports” on page 411).   
As well as the built-in Sqoop connectors, various third-party connectors are available for data stores, ranging from enterprise data warehouses (such as Teradata) to NoSQL stores (such as Couchbase). These connectors must be downloaded separately and can be added to an existing Sqoop installation by following the instructions that come with the connector.  

### A Sample Import from Mysql
Sample source table:
```sql
CREATE TABLE widgets(id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
widget_name VARCHAR(64) NOT NULL,
price DECIMAL(10,2),
design_date DATE,
version INT,
design_comment VARCHAR(100));

INSERT INTO widgets VALUES (NULL, 'sprocket', 0.25, '2010-02-10', 1, 'Connects two gizmos');
INSERT INTO widgets VALUES (NULL, 'gizmo', 4.00, '2009-11-30', 4, NULL);
INSERT INTO widgets VALUES (NULL, 'gadget', 99.99, '1983-08-13', 13, 'Our flagship product');
```

1. install mysql
Users of Debian-based Linux systems (e.g., Ubuntu) can type `sudo apt-get install mysql-client mysqlserver`.  
Red Hat users can type `sudo yum install mysql mysql-server`.  
2. Before going any further, you need to download the JDBC driver JAR file for MySQL (Connector/J) and add it to Sqoop’s classpath, which is simply achieved by placing it in Sqoop’s lib directory.  
3. import  
```shell
## specify only 1 map task
$ sqoop import --connect jdbc:mysql://hostname/hadoopguide \
> --table widgets -m 1
```
Logs as below:  
```html
...
14/10/28 21:36:23 INFO tool.CodeGenTool: Beginning code generation
...
14/10/28 21:36:28 INFO mapreduce.Job: Running job: job_1413746845532_0008
14/10/28 21:36:35 INFO mapreduce.Job: Job job_1413746845532_0008 running in
uber mode : false
14/10/28 21:36:35 INFO mapreduce.Job: map 0% reduce 0%
14/10/28 21:36:41 INFO mapreduce.Job: map 100% reduce 0%
14/10/28 21:36:41 INFO mapreduce.Job: Job job_1413746845532_0008 completed
successfully
...
14/10/28 21:36:41 INFO mapreduce.ImportJobBase: Retrieved 3 records.
```
`Sqoop’s import tool will run a MapReduce job` that connects to the MySQL database and reads the table. By default, this will use 4 map tasks in parallel to speed up the import process. Each task will write its imported results to a different file, but all in a common directory.  
```shell
$ hadoop fs -cat widgets/part-m-00000
1,sprocket,0.25,2010-02-10,1,Connects two gizmos
2,gizmo,4.00,2009-11-30,4,null
3,gadget,99.99,1983-08-13,13,Our flagship product
```

#### Text and Binary File Formats
Sqoop is capable of importing into a few different file formats. Text files (the default) offer a human-readable representation of data, platform independence, and the simplest structure. However, they cannot hold binary fields (such as database columns of type VARBINARY), and distinguishing between null values and String-based fields containing the value "null" can be problematic (although using the --null-string import option allows you to control the representation of null values).  
To handle these conditions, `Sqoop also supports SequenceFiles, Avro datafiles, and Parquet files`. `These binary formats provide the most precise representation possible of the imported data`. They also allow data to be compressed while retaining MapReduce’s ability to process different sections of the same file in parallel. However, `current versions of Sqoop cannot load Avro datafiles or SequenceFiles into Hive` (`although you can load Avro into Hive manually, and Parquet can be loaded directly into Hive by Sqoop`). `Another disadvantage of SequenceFiles is that they are Java specific`, whereas Avro and Parquet files can be processed by a wide range of languages.  

### Generated Code
In addition to writing the contents of the database table to HDFS, Sqoop also provides you with a generated Java source file (widgets.java) written to the current local directory. 
Sqoop can use generated code to handle the deserialization of table-specific data from the database source before writing it to HDFS.  

`The generated class (widgets) is capable of holding a single record retrieved from the imported table`(each instance of the class refers to only a single record).   It can manipulate such a record in MapReduce or store it in a SequenceFile in HDFS. (SequenceFiles written by Sqoop during the import process will store each imported row in the “value” element of the SequenceFile’s key-value pair format, using the generated class.)

We can use a different Sqoop tool to generate source code without performing an import; this generated code will still examine the database table to determine the appropriate data types for each field:  
```shell
$ sqoop codegen --connect jdbc:mysql://localhost/hadoopguide \
 --table widgets --class-name Widget
```

If you’re working with records imported to SequenceFiles, it is inevitable that you’ll need to use the generated classes (to deserialize data from the SequenceFile storage). You can work with text-file-based records without using generated code, but as we’ll see in “Working with Imported Data” on page 412, Sqoop’s generated code can handle some tedious aspects of data processing for you.

Recent versions of Sqoop support Avro-based serialization and schema generation as well (see Chapter 12)

### Imports: A Deeper Look

You still need to download `the JDBC driver` itself and install it on your Sqoop client. For cases where Sqoop does not know which JDBC driver is appropriate, users can specify the JDBC driver explicitly with the `--driver` argument.

Before the import can start, Sqoop uses JDBC to examine the table it is to import. It retrieves a list of all the columns and their SQL data types. These SQL types (VARCHAR, INTEGER, etc.) can then be mapped to Java data types (String, Integer, etc.), which will hold the field values in MapReduce applications. Sqoop’s code generator will use this information to create a table-specific class to hold a record extracted from the table.
```java
public Integer get_id();
public String get_widget_name();
public java.math.BigDecimal get_price();
...
```
The generated class also implements **DBWritable** interface  
```java
public void readFields(ResultSet __dbResults) throws SQLException;
public void write(PreparedStatement __dbStmt) throws SQLException;
```
The write() method shown here allows Sqoop to insert new Widget rows into a table, a process called exporting. Exports are discussed in “Performing an Export” on page 417.  

The MapReduce job launched by Sqoop uses an InputFormat that can read sections of a table from a database via JDBC. The **DataDrivenDBInputFormat** provided with Hadoop partitions a query’s results over several map tasks.   
Reading a table is typically done with a simple query such as:  
```sql
SELECT col1,col2,col3,... FROM tableName WHERE...
```
Using metadata about the table, Sqoop will guess a good column to use for splitting the table (`typically the primary key for the table, if one exists`), this is `splitting column`. DataDrivenDBInputFormat at first queries the range of splitting column, by `select min(splitting_column), max(splitting_column) from source_table`, then split evenly the range of table rows to several sections, the number of which equals to the number of map tasks.  
The primary key column may not be uniformly distributed, so users can specify a particular splitting column when running an import job (via the `--split-by` argument), to tune the job to the data’s actual distribution.

After generating the deserialization code(the genearted class) and configuring the InputFormat(DataDrivenDBInputFormat), Sqoop sends the job to the MapReduce cluster. Map tasks execute the queries and deserialize rows from the ResultSet into instances of the generated class, which are either stored directly in SequenceFiles or transformed into delimited text before being written to HDFS.  

Users can also specify a WHERE clause to include in queries via the `--where` argument, which bounds the rows of the table to import. User-supplied WHERE clauses are applied before task splitting is performed, and are pushed down into the queries executed by each task.

For more control—to perform column transformations, for example—users can specify a `--query` argument.

When importing data to HDFS, it is important that you ensure access to a consistent snapshot of the source data. (`Map tasks` reading from a database in parallel are running in separate processes. Thus, `they cannot share a single database transaction.`) `The best way to do this is to ensure that any processes that update existing rows of a table are disabled during the import`.

#### Incremental Imports
Sqoop will import rows that have a column value (for the column specified with --check-column) that is greater than some specified value (set via --last-value).  
* --incremental append  
The value specified as --last-value can be a row ID that is strictly increasing, such as an AUTO_INCREMENT primary key in MySQL. This is suitable for the case where new rows are added to the database table, but existing rows are not updated. This mode is called append mode, and is activated via `--incremental append`. 
* --incremental lastmodified  
Another option is timebased incremental imports (specified by `--incremental lastmodified`), which is appropriate when existing rows may be updated, and there is a column (the check column) that records the last modified time of the update.  

`At the end of an incremental import, Sqoop will print out the value to be specified as --last-value on the next import`. This is useful when running incremental imports manually, but for running periodic imports it is better to use `Sqoop’s saved job facility, which automatically stores the last value and uses it on the next job run`. Type `sqoop job --help` for usage instructions for saved jobs.

#### Direct-Mode Imports
Some databases, however, offer specific tools designed to extract data quickly. For example, MySQL’s **mysqldump** application can read from a table with `greater throughput than a JDBC channel`. The use of these external tools is referred to as direct mode in Sqoop’s documentation. Direct mode must be specifically enabled by the user (via the `--direct` argument), as it is not as general purpose as the JDBC approach. (For example, MySQL’s direct mode cannot handle large objects, such as CLOB or BLOB columns, and that’s why Sqoop needs to use a JDBC-specific API to load these columns into HDFS.)  

For databases that provide such tools, Sqoop can use these to great effect. A direct-mode import from MySQL is usually much more efficient (in terms of map tasks and time required) than a comparable JDBC-based import. Sqoop will still launch multiple map tasks in parallel. These tasks will then `spawn instances of the mysqldump program and read its output`. `Sqoop can also perform direct-mode imports from PostgreSQL, Oracle, and Netezza`. 

Even when direct mode is used to access the contents of a database, `the metadata is still queried through JDBC`.

### Working with Imported Data
Each autogenerated class has several overloaded methods named parse() that operate on the data represented as Text, CharSequence, char[], or other common types.  

Package the generated class with other classes(for example, sqoop-examples.jar, main class is MaxWidgetId), run command like below  
```shell
$ HADOOP_CLASSPATH=$SQOOP_HOME/sqoop-version.jar hadoop jar \
sqoop-examples.jar MaxWidgetId -libjars $SQOOP_HOME/sqoop-version.jar
```
This command line ensures that Sqoop is on the classpath locally (via $HADOOP_CLASSPATH) when running the MaxWidgetId.run() method, as well as when map tasks are running on the cluster (via the -libjars argument).

The autogenerated class implements the Writable(DBWritable) interface provided by Hadoop, which allows the object to be sent via Hadoop’s serialization mechanism, as well as written to and read from SequenceFiles.  

Avro-based imports can be processed using the APIs described in “Avro MapReduce” on page 359. With the Generic Avro mapping, the MapReduce program does not need to use schema-specific generated code (although this is an option too, by using Avro’s Specific compiler; Sqoop does not do the code generation in this case).

#### Imported Data and Hive
3 steps to import data to Hive with sqoop.  
1. importing data to HDFS by sqoop as previous chapter shows
2. create Hive table  
Sqoop can generate a Hive table based on a table from an existing relational data source.  
```shell
$ sqoop create-hive-table --connect jdbc:mysql://localhost/hadoopguide \
--table widgets --fields-terminated-by ','
```
3. loading the HDFS-resident data into Hive 

To import to Hive in 1 step:  
```shell
$ sqoop import --connect jdbc:mysql://localhost/hadoopguide \
--table widgets -m 1 --hive-import
```

Hive’s type system is less rich than that of most SQL systems. Many SQL types do not have direct analogues in Hive. When Sqoop generates a Hive table definition for an import, it uses the best Hive type available to hold a column’s values. This may result in a decrease in precision. When this occurs, Sqoop will provide you with a warning message.

### Importing Large Objects
Most databases provide the capability to store large amounts of data in a single field. Depending on whether this data is textual or binary in nature, it is usually represented as a CLOB or BLOB column in the table.  

In particular, most tables are physically laid out on disk as in Figure 15-2. When scanning through rows to determine which rows match the criteria for a particular query, this typically involves reading all columns of each row from disk. If large objects were stored “inline” in this fashion, they would adversely affect the performance of such scans. Therefore, large objects are often stored externally from their rows, as in Figure 15-3. Accessing a large object often requires “opening” it through the reference contained in the row.  
![hadoop_clob_blob_storage_img_1]  
**Figure 15-3. Large objects are usually held in a separate area of storage; the main row storage contains indirect references to the large objects**  

The difficulty of working with large objects in a database suggests that a system such as `Hadoop`, which is much better suited to storing and processing large, complex data objects, is `an ideal repository for such information.` `Sqoop can extract large objects from tables and store them in HDFS for further processing`.

As in a database, MapReduce typically materializes every record before passing it along to the mapper. If individual records are truly large, this can be very inefficient. If the contents of a large object field are relevant only for a small subset of the total number of records used as input to a MapReduce program, it would be inefficient to fully materialize all these records. Furthermore, depending on the size of the large object, full materialization in memory may be impossible.  

To overcome these difficulties, Sqoop will store imported large objects in a separate file called a **LobFile**, if they are larger than a threshold size of 16 MB (configurable via the `sqoop.inline.lob.length.max setting`, in bytes). Each record in a LobFile holds a single large object. `The LobFile format allows clients to hold a reference to a record without accessing the record contents`. When records are accessed, this is done through a java.io.InputStream (for binary objects) or java.io.Reader (for character-based objects).  

When a record is imported, the “normal” fields will be materialized together in a text file, along with a reference to the LobFile where a CLOB or BLOB column is stored.  
```html
2,gizmo,4.00,2009-11-30,4,null,externalLob(lf,lobfile0,100,5011714)
```

The generated class uses BlobRef/ClobRef referencing these columns, but not actually containing its contents. the BlobRef.getDataStream() method actually opens the LobFile and returns an InputStream.

The BlobRef and ClobRef classes cache references to underlying LobFiles within a map task. If you do access the clob/blob fields of several sequentially ordered records, they will take advantage of the existing file pointer’s alignment on the next record body.

### Performing an Export
By contrast, an export uses HDFS as the source of data and a remote database as the destination.

`Before exporting a table from HDFS to a database, we must prepare the database to receive the data by creating the target table`. Although Sqoop can infer which Java types are appropriate to hold SQL data types, this translation does not work in both directions (for example, there are several possible SQL column definitions that can hold data in a Java String; this could be CHAR(64), VARCHAR(200), or something else entirely). Consequently, you must determine which types are most appropriate.

We are going to export the zip_profits table from Hive.  
```shell
% sqoop export --connect jdbc:mysql://localhost/hadoopguide -m 1 \
--table sales_by_zip --export-dir /user/hive/warehouse/zip_profits \
--input-fields-terminated-by '\0001'
```

```html
...
14/10/29 12:05:08 INFO mapreduce.ExportJobBase: Transferred 176 bytes in 13.5373
seconds (13.0011 bytes/sec)
14/10/29 12:05:08 INFO mapreduce.ExportJobBase: Exported 3 records.
```
Hive used its default delimiters: a Ctrl-A character (Unicode 0x0001) between fields and a newline at the end of each record.  
In the example syntax, the escape sequence is enclosed in single quotes to ensure that the shell processes it literally. Without the quotes, the leading backslash itself may need to be escaped (e.g., `--input-fields-terminated-by \\0001`).

### Exports: A Deeper Look
`The Sqoop performs exports is very similar in nature to how Sqoop performs imports` (see Figure 15-4). Before performing the export, `Sqoop picks a strategy based on the database connect string`. `For most systems, Sqoop uses JDBC`. Sqoop then `generates a Java class` based on the target table definition. This generated class has the ability to parse records from text files and insert values of the appropriate types into a table (in addition to the ability to read the columns from a ResultSet). `A MapReduce job is then launched` that reads the source datafiles from HDFS, parses the records using the generated class, and executes the chosen export strategy.  

The JDBC-based export strategy builds up `batch INSERT` statements that will each add multiple records to the target table.  

`For MySQL, Sqoop can employ a direct-mode strategy using mysqlimport`. Each map task spawns a mysqlimport process that it communicates with via a named FIFO file on the local filesystem. Data is then streamed into mysqlimport via the FIFO channel, and from there into the database.

Sqoop uses the **CombineFileInputFormat** class to group the input files into a smaller number of map tasks.

#### Exports and Transactionality
Due to the parallel nature of the process, often an export is not an atomic operation.  

To solve this problem, `Sqoop can export to a temporary staging table and then, at the end of the job—if the export has succeeded—move the staged data into the destination table in a single transaction`. You can specify a staging table with the `--staging-table` option. The staging table must already exist and have the same schema as the destination. It must also be empty, unless the `--clear-staging-table` option is also supplied.  
Using a staging table is `slower`, since the data must be written twice: first to the staging table, then to the destination table. The export process also uses `more space` while it is running, since there are two copies of the data while the staged data is being copied to the destination.  

#### Exports and SequenceFiles
Sqoop can also export delimited text files that were not Hive tables.  

`Sqoop can export records stored in SequenceFiles to an output table too`, although some restrictions apply. A SequenceFile cannot contain arbitrary record types. Sqoop’s export tool will read objects from SequenceFiles and send them directly to the OutputCollector, which passes the objects to the database export OutputFormat. To work with Sqoop, `the record must be stored in the “value” portion of the SequenceFile’s key-value pair format` and must subclass the `org.apache.sqoop.lib.SqoopRecord` abstract class (as is done by all classes generated by Sqoop).

If you use the codegen tool (sqoop-codegen) to generate a SqoopRecord implementation for a record based on your export target table, you can write a MapReduce program that populates instances of this class and writes them to SequenceFiles. sqoop-export can then export these SequenceFiles to the table.  

`You can suppress code generation and instead use an existing record class and JAR` by providing the `--class-name` and `--jar-file` arguments to Sqoop. Sqoop will use the specified class, loaded from the specified JAR, when exporting records.

In the following example, we reimport the widgets table as SequenceFiles, and then export it back to the database in a different table:  
```shell
## During the import, we specified the SequenceFile format and indicated that we wanted
## the JAR file to be placed in the current directory (with --bindir) so we can reuse it.
$ sqoop import --connect jdbc:mysql://localhost/hadoopguide \
--table widgets -m 1 --class-name WidgetHolder --as-sequencefile \
--target-dir widget_sequence_files --bindir .

## prompt: 
...
14/10/29 12:25:03 INFO mapreduce.ImportJobBase: Retrieved 3 records.

$ mysql hadoopguide
mysql> CREATE TABLE widgets2(id INT, widget_name VARCHAR(100),
price DOUBLE, designed DATE, version INT, notes VARCHAR(200));

## suppress code generation and instead use an existing record class
$ sqoop export --connect jdbc:mysql://localhost/hadoopguide \
--table widgets2 -m 1 --class-name WidgetHolder \
--jar-file WidgetHolder.jar --export-dir widget_sequence_files

## prompt: 
...
14/10/29 12:28:17 INFO mapreduce.ExportJobBase: Exported 3 records.
```

## 17. Hive
For more information about Hive, see [Programming Hive] by Edward Capriolo, Dean Wampler, and Jason Rutherglen (O’Reilly, 2012).

### Installing Hive
In normal use, Hive runs on your workstation and `converts your SQL query into a series of jobs for execution on a Hadoop cluster`. Hive organizes data into tables, which provide a means for attaching structure to data stored in HDFS. Metadata—such as table schemas— is stored in a database called the **metastore**.

When starting out with Hive, it is convenient to run the metastore on your local machine. In this configuration, which is the default, the Hive table definitions that you create will be local to your machine, so you can’t share them with other users. We’ll see how to configure a shared remote metastore, which is the norm in production environments, in “The Metastore” on page 480.

**Prerequisite**:   
1. version compatible as per release notes with Hadoop
2. making sure that the hadoop executable is on the path or setting the HADOOP_HOME environment variable.

**Installation**:  
1. Download a release ([Apache Hive Download]), and unpack the tarball in a suitable place on your workstation:   
```shell
$ tar xzf apache-hive-x.y.z-bin.tar.gz 
```
2. It’s handy to put Hive on your path to make it easy to launch:   
```shell
$ export HIVE_HOME=~/sw/apache-hive-x.y.z-bin 
$ export PATH=$PATH:$HIVE_HOME/bin
```
3. initiate metastore per Hive2  
Running hive, even though it fails, creates a metastore_db directory `in the directory from which you ran hive`:  
    1. Before you run hive for the first time, run  
    ```shell
    $ schematool -initSchema -dbType derby 
    ```
    2. If you already ran hive and then tried to initSchema and it failed:  
    ```shell
    ## run this command under the directory where the initSchema was previously ran
    $ mv metastore_db metastore_db.tmp
    ```
    3. Re run  
    ```shell
    $ schematool -initSchema -dbType derby 
    ```
4. Now type hive to launch the Hive shell:  
```shell
$ hive
hive>
```

3 types of Hive metastore:  
1. Embeded Derby, by default
2. Local
for example, use a local Mysql Server
3. Remote  
for example, use a remote DB Server  

Hive-on-MR is deprecated in Hive 2 and may not be available in the future versions. Consider using a different execution engine (i.e. spark, tez) or using Hive 1.X releases.  

PS: Maybe following materials are based on Hive 1.X releases.   

#### The Hive Shell

The Hive shell is the primary way that we will interact with Hive, by issuing commands in HiveQL. HiveQL is Hive’s query language, a dialect of SQL. It is `heavily influenced by MySQL`, so if you are familiar with MySQL, you should feel at home using Hive.

Like SQL, HiveQL is generally `case insensitive` (except for string comparisons).  

For a fresh install, the command takes a few seconds to run as it lazily creates the metastore database on your machine. (The database stores its files in a directory called metastore_db, which is relative to the location from which you ran the hive command.)

```shell
$ hive
hive>

$ hive -f script.q

## For short scripts, you can use the -e option to specify the commands inline, in which
## case the final semicolon is not required
$ hive -e 'SELECT * FROM dummy'
```

```sql
hive> SHOW TABLES;

```

Here’s one way of populating a single-row table:  
```shell
$ echo 'X' > /tmp/dummy.txt
$ hive -e "CREATE TABLE dummy (value STRING); \
LOAD DATA LOCAL INPATH '/tmp/dummy.txt' \
OVERWRITE INTO TABLE dummy"
```

Other useful Hive shell features include the ability to `run commands on the host operating system by using a ! prefix to the command` and the ability to `access Hadoop filesystems using the dfs command`.

### An Hive Example
Just like an RDBMS, Hive organizes its data into tables.

```sql
CREATE TABLE records (year STRING, temperature INT, quality INT)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t';
```
Hive expects there to be three fields in each row, corresponding to the table columns, with fields separated by tabs and rows by newlines.
```sql
hive> LOAD DATA LOCAL INPATH 'tmp/data.txt' OVERWRITE INTO TABLE records;
```
Running this command tells Hive to put the specified local file in its warehouse directory. `This is a simple filesystem operation`. `There is no attempt, for example, to parse the file and store it in an internal database format`, because `Hive does not mandate any particular file format. Files are stored verbatim; they are not modified by Hive`.

In this example, we are storing Hive tables on the local filesystem (fs.defaultFS is set to its default value of file:///). Tables are stored as directories under Hive’s warehouse directory, which is controlled by the `hive.metastore.warehouse.dir` property and defaults to /user/hive/warehouse. Thus, the files for the records table are found in the /user/hive/warehouse/records directory on the local filesystem(PS: the table name in this example happens to be "records"):   
```shell
$ ls /user/hive/warehouse/records/ 
data.txt
```
The OVERWRITE keyword in the LOAD DATA statement tells Hive to delete any existing files in the directory for the table. If it is omitted, the new files are simply added to the table’s directory (`unless they have the same names, in which case they replace the old files`).

Now that the data is in Hive, we can run a query against it:
```sql
hive> SELECT year, MAX(temperature)
> FROM records
> WHERE temperature != 9999 AND quality IN (0, 1, 4, 5, 9)
> GROUP BY year;

```

### Configuring Hive
Hive is configured using an XML configuration file like Hadoop’s. The file is called `hive-site.xml` and is located in Hive’s conf directory. This file is where you can set properties that you want to set every time you run Hive. The same directory contains hive-default.xml, which documents the properties that Hive exposes and their default values. You can override the configuration directory that Hive looks for in hive-site.xml by passing the --config option to the hive command:  
```shell
$ hive --config /Users/tom/dev/hive-conf
```
Alternatively, you can set the `HIVE_CONF_DIR` environment variable to the configuration directory for the same effect.

The hive-site.xml file is a natural place to put the cluster connection details: you can specify the filesystem and resource manager using the usual Hadoop properties, `fs.defaultFS` and `yarn.resourcemanager.address`. Metastore configuration settings (covered in “The Metastore” on page 480) are commonly found in hive-site.xml, too.

`Hive also permits you to set properties on a per-session basis`, by passing the `-hiveconf` option to the hive command. For example, the following command sets the cluster (in this case, to a pseudodistributed cluster) for the duration of the session:  
```shell
$ hive -hiveconf fs.defaultFS=hdfs://localhost \  
-hiveconf mapreduce.framework.name=yarn \  
-hiveconf yarn.resourcemanager.address=localhost:8032
```

`You can change settings from within a session, too, using the SET command`. This is useful for changing Hive settings for a particular query. For example, the following command ensures buckets are populated according to the table definition (see “Buckets” on page 493):  
```sql
hive> SET hive.enforce.bucketing=true;
```
To see the current value of any property, use SET with just the property name:  
```sql
hive> SET hive.enforce.bucketing;
hive.enforce.bucketing=true
```

**Execution engines**  
Hive was originally written to use MapReduce as its execution engine, and that is still the default. It is now also possible to run Hive using Apache Tez as its execution engine, and work is underway to support Spark (see Chapter 19), too. Both Tez and Spark are general directed acyclic graph (DAG) engines that offer more flexibility and higher performance than MapReduce. For example, unlike MapReduce, where intermediate job output is materialized to HDFS, `Tez and Spark can avoid replication overhead by writing the intermediate output to local disk, or even store it in memory` (at the request of the Hive planner).
```sql
hive> SET hive.execution.engine=tez;
```

**Logging**  
You can find Hive’s error log on the local filesystem at `${java.io.tmpdir}/${user.name}/hive.log`.  
The logging configuration is in `conf/hive-log4j.properties`.  
```shell
$ hive -hiveconf hive.log.dir='/tmp/${user.name}'
$ hive -hiveconf hive.root.logger=DEBUG,console
```

### Hive Services
The Hive shell is only one of several services that you can run using the hive command. You can specify the service to run using the --service option. Type `hive --service help` to get a list of available service names;

![hadoop_hive_services_img_1]  
**Figure 17-1. Hive architecture**  

* cli  
The command-line interface to Hive (the shell). This is the default service.  
* hiveserver2  
Runs Hive as a server exposing a Thrift service, `enabling access from a range of clients written in different languages`. HiveServer 2 improves on the original Hive‐Server by supporting authentication and multiuser concurrency. Applications using the Thrift, JDBC, and ODBC connectors need to run a Hive server to communicate with Hive. Set the hive.server2.thrift.port configuration property to specify the port the server will listen on (defaults to 10000).  
* beeline  
A command-line interface to Hive that works in embedded mode (like the regular CLI), or by connecting to a HiveServer 2 process using JDBC.  
* hwi  
The Hive Web Interface. A simple web interface that can be used as an alternative to the CLI without having to install any client software. See also [Hue] for a more fully featured Hadoop web interface that includes applications for running Hive queries and browsing the Hive metastore.  
* jar  
The Hive equivalent of hadoop jar, a convenient way to run Java applications that includes both Hadoop and Hive classes on the classpath.  
* metastore  
`By default, the metastore is run in the same process as the Hive service`. Using this service, it is possible to run the metastore as a standalone (remote) process. Set the METASTORE_PORT environment variable (or use the -p command-line option) to specify the port the server will listen on (defaults to 9083).

### Hive clients
If you run Hive as a server (`hive --service hiveserver2`), there are a number of different mechanisms for connecting to it from applications (the relationship between Hive clients and Hive services is illustrated in Figure 17-1):  
* Thrift Client  
`The Hive server is exposed as a Thrift service`, so it’s possible to `interact with it using any programming language that supports Thrift`. `There are third-party projects providing clients for Python and Ruby`; for more details, see the Hive wiki.  
* JDBC driver  
Hive provides a `Type 4 (pure Java) JDBC driver`, defined in the class `org.apache.hadoop.hive.jdbc.HiveDriver`. When configured with a JDBC URI of the form `jdbc:hive2://host:port/dbname`, a Java application will connect to a Hive server running in a separate process at the given host and port. (`The driver makes calls to an interface implemented by the Hive Thrift Client using the Java Thrift bindings.`)  
You may alternatively choose to connect to Hive via JDBC in `embedded mode` using the URI jdbc:hive2://. In this mode, Hive runs in the same JVM as the application invoking it; there is no need to launch it as a standalone server, since it does not use the Thrift service or the Hive Thrift Client.  
The Beeline CLI uses the JDBC driver to communicate with Hive. 
* ODBC driver  
An ODBC driver allows applications that support the ODBC protocol (such as `business intelligence software`) to connect to Hive. The Apache Hive distribution does not ship with an ODBC driver, but several vendors make one freely available. (Like the JDBC driver, ODBC drivers use Thrift to communicate with the Hive server.) 

### The Hive Metastore
The metastore is the central repository of Hive metadata. `The metastore is divided into two pieces: a service and the backing store for the data`. By default, the metastore service runs in the same JVM as the Hive service and contains an embedded Derby database instance backed by the local disk. This is called the embedded metastore configuration (see Figure 17-2). 

Using an `embedded metastore` is a simple way to get started with Hive; however, only `one embedded Derby database can access the database files on disk at any one time`, which means you can have only one Hive session open at a time that accesses the same metastore. Trying to start a second session produces an error when it attempts to open a connection to the metastore.

The solution to supporting multiple sessions (and therefore multiple users) is to use a standalone database. This configuration is referred to as a `local metastore`, since the `metastore service still runs in the same process as the Hive service` but connects to a database running in a separate process, either on the same machine or on a remote machine. `Any JDBC-compliant database` may be used by setting the javax.jdo.option.* configuration properties listed in Table 17-1.3  

Going a step further, there’s another metastore configuration called a `remote metastore`, `where one or more metastore servers run in separate processes to the Hive service`. This brings better manageability and security because the database tier can be completely firewalled off, and the clients no longer need the database credentials.

![hadoop_hive_metastore_configuration_img_1]  
**Figure 17-2. Metastore configurations**  

### Comparison with Traditional Databases

#### Schema on Read Versus Schema on Write
In a traditional database, This design is sometimes called `schema on write` because the data is checked against the schema when it is written into the database.  

Hive, on the other hand, doesn’t verify the data when it is loaded, but rather when a query is issued. This is called schema on read.  

There are trade-offs between the two approaches. Schema on read makes for a `very fast initial load`, since the data does not have to be read, parsed, and serialized to disk in the database’s internal format. The load operation is just a file copy or move. `It is more flexible, too`: consider having two schemas for the same underlying data, depending on the analysis being performed. (This is possible in Hive using external tables; see “Managed Tables and External Tables” on page 490.) 

Schema on write makes `query time performance faster because the database can index columns and perform compression on the data`. The trade-off, however, is that it takes longer to load data into the database. `Furthermore, there are many scenarios where the schema is not known at load time, so there are no indexes to apply, because the queries have not been formulated yet`. These scenarios are where Hive shines.

#### Updates, Transactions, and Indexes
Updates, transactions, and indexes are mainstays of traditional databases. Yet, until recently, these features have not been considered a part of Hive’s feature set. This is because Hive was built to operate over HDFS data using MapReduce, where `full-table scans are the norm and a table update is achieved by transforming the data into a new table`. For a data warehousing application that runs over large portions of the dataset, this works well.  

Hive has long supported `adding new rows in bulk` to an existing table by using INSERT INTO to add new data files to a table. From release 0.14.0, finer-grained changes are possible, so you can call INSERT INTO TABLE...VALUES to `insert small batches of values` computed in SQL. In addition, `it is possible to UPDATE and DELETE rows` in a table.  

`HDFS does not provide in-place file updates`, so changes resulting from inserts, updates, and deletes are stored in small delta files. `Delta files are periodically merged into the base table files by MapReduce jobs` that are run in the background `by the metastore`. These features only work `in the context of transactions` (introduced in Hive 0.13.0), so the table they are being used on needs to have transactions enabled on it. Queries reading the table are guaranteed to see a consistent snapshot of the table.  

`Hive also has support for table- and partition-level locking.` Locks prevent, for example, one process from dropping a table while another is reading from it. `Locks are managed transparently using ZooKeeper,` so the user doesn’t have to acquire or release them, although it is possible to get information about which locks are being held via the SHOW LOCKS statement. By default, locks are not enabled.  

There are currently two index types: `compact and bitmap`. (`The index implementation was designed to be pluggable`, so it’s expected that a variety of implementations will emerge for different use cases.)   

Compact indexes store the HDFS `block numbers of each value`, rather than each file offset, so they don’t take up much disk space but are still effective for the case where values are clustered together in nearby rows. Bitmap indexes use compressed bitsets to efficiently store the rows that a particular value appears in, and they are usually appropriate for low-cardinality columns (such as gender or country).

#### SQL-on-Hadoop Alternatives
In the years since Hive was created, many other SQL-on-Hadoop engines have emerged to address some of Hive’s limitations.  

Cloudera Impala, [Apache Impala] an open source interactive SQL engine, was one of the first, giving `an order of magnitude performance boost compared to Hive running on MapReduce`.  Impala `uses a dedicated daemon that runs on each datanode` in the cluster. When a client runs a query it contacts an arbitrary node running an Impala daemon, which acts as `a coordinator node` for the query. The coordinator sends work to other Impala daemons in the cluster and combines their results into the full result set for the query. `Impala uses the Hive metastore and supports Hive formats and most HiveQL constructs (plus SQL-92), so in practice it is straightforward to migrate between the two systems, or to run both on the same cluster.`

Other prominent open source Hive alternatives include `Presto from Facebook`, `Apache Drill`, and `Spark SQL`. `Presto and Drill have similar architectures to Impala`, although Drill targets SQL:2011 rather than HiveQL. Spark SQL uses Spark as its underlying engine, and lets you embed SQL queries in Spark programs.

`Spark SQL` is different to using the Spark execution engine from within Hive (“Hive on Spark,” see “Execution engines” on page 477). `Hive on Spark provides all the features of Hive` since it is a part of the Hive project. `Spark SQL`, on the other hand, is a new SQL engine that `offers some level of Hive compatibility`.

`Apache Phoenix` takes a different approach entirely: it provides `SQL on HBase`. SQL access is through a JDBC driver that `turns queries into HBase scans` and `takes advantage of HBase coprocessors to perform server-side aggregation`. Metadata is stored in HBase, too.

### HiveQL
Hive’s SQL dialect, called HiveQL, is a mixture of `SQL-92, MySQL, and Oracle’s SQL dialect`. The level of SQL-92 support has improved over time, and will likely continue to get better. `HiveQL also provides features from later SQL standards, such as window functions (also known as analytic functions) from SQL:2003`. Some of Hive’s nonstandard extensions to SQL were inspired by MapReduce, such as multitable inserts (see “Multitable insert” on page 501) and the TRANSFORM, MAP, and REDUCE clauses (see “MapReduce Scripts” on page 503).

**Table 17-2. A high-level comparison of SQL and HiveQL**   

Feature                 |SQL                                                            |HiveQL 
---------------------|------------------------------------------------|------------------------------------------------------------------------------
Updates                |UPDATE, INSERT, DELETE                        |UPDATE, INSERT, DELETE
Transactions         |Supported                                                   |Limited support
Indexes                |Supported                                                   |Supported
Data types            |Integral, floating-point, fixed-point, text and binary strings, temporal      |Boolean, integral, floating-point, fixed-point, text and binary strings, temporal, array, map, struct
Functions              |Hundreds of built-in functions                    |Hundreds of built-in functions  
Multitable inserts |Not supported                                            |Supported
CREATE TABLE...AS SELECT    |Not valid SQL-92, but found in some databases      |Supported 
SELECT                |SQL-92                                                      |SQL-92. `SORT BY for partial ordering`, LIMIT to limit number of rows returned
Joins                    |SQL-92, or variants (join tables in the FROM clause, join condition in the WHERE clause)  |Inner joins, outer joins, `semi joins`, map joins, cross joins
Subqueries           |In any clause (correlated or noncorrelated)       |In the FROM, WHERE, or HAVING clauses (uncorrelated subqueries not supported)(PS: should only support uncorrelated subqueries)
Views                   |Updatable (materialized or nonmaterialized)      |Read-only (materialized views not supported)
Extension points  |User-defined functions, stored procedures        |User-defined functions, MapReduce scripts

Hive supports both primitive and complex data types. Primitives include numeric, Boolean, string, and timestamp types. The complex data types include `arrays, maps, and structs`.

Note that the literals shown are those used from within HiveQL; they are not the serialized forms used in the table’s storage format.

Type        | Description                                                                                               |Literal examples
-----------|----------------------------------------------------------------------------------|------------------------------------------------------
ARRAY    |An ordered collection of fields. The fields must all be of the same type.  |array(1, 2) 
MAP        |An unordered collection of key-value pairs. `Keys must be primitives`; values may be any type. For a particular map, the keys must be the same type, and the values must be the same type.                          |map('a', 1, 'b', 2)
STRUCT  |A collection of named fields. The fields may be of different types.          |struct('a', 1, 1.0), named_struct('col1', 'a', 'col2', 1, 'col3', 1.0)  
UNION   |A value that may be one of a number of defined data types. The value is tagged with an integer (zeroindexed) representing its data type in the union.                                                                      |create_union(1, 'a', 63)

* The literal forms for arrays, maps, structs, and unions are provided as functions. That is, array, map, struct, and create_union are built-in Hive functions.
* For unname STRUCT struct('a', 1, 1.0), The columns are named col1, col2, col3, etc.

Hive’s primitive types correspond roughly to Java’s, although some names are influenced by MySQL’s type names.

The DECIMAL data type is used to represent arbitrary-precision decimals, like Java’s BigDecimal. DECIMAL(5,2) stores numbers between −999.99 and 999.99.

Complex types `permit an arbitrary level of nesting`.  
```sql
CREATE TABLE complex (
    c1 ARRAY<INT>,
    c2 MAP<STRING, INT>,
    c3 STRUCT<a:STRING, b:INT, c:DOUBLE>,
    c4 UNIONTYPE<STRING, INT>
);

hive> SELECT c1[0], c2['b'], c3.c, c4 FROM complex;
1 2 1.0 {1:63}
```

Hive comes with a large number of built-in functions—too many to list here—divided into categories that include mathematical and statistical functions, string functions, date functions (for operating on string representations of dates), conditional functions, aggregate functions, and `functions for working with XML (using the xpath function) and JSON`.  

You can retrieve a list of functions from the Hive shell by typing `SHOW FUNCTIONS`. To get brief usage instructions for a particular function, use the DESCRIBE command:  
```sql
hive> DESCRIBE FUNCTION length;
length(str | binary) - Returns the length of str or number of bytes in binary
data
```

The implicit conversion rules can be summarized as follows. Any numeric type can be implicitly converted to a wider type, or to a text type (STRING, VARCHAR, CHAR). `All the text types can be implicitly converted to another text type. Perhaps surprisingly, they can also be converted to DOUBLE or DECIMAL`. BOOLEAN types cannot be converted to any other type, and they cannot be implicitly converted to any other type in expressions. TIMESTAMP and DATE can be implicitly converted to a text type.  

You can perform explicit type conversion using `CAST`. For example, CAST('1' AS INT) will convert the string '1' to the integer value 1. If the cast fails—as it does in CAST('X' AS INT), for example—the expression returns NULL.

### Hive Tables
A Hive table is logically made up of the data being stored and the associated metadata describing the layout of the data in the table. The data typically resides in HDFS, although it may `reside in any Hadoop filesystem`, including the local filesystem or S3. Hive stores the metadata in a relational database and not in, say, HDFS.

#### Managed Tables and External Tables
When you create a table in Hive, by default Hive will manage the data, which means that Hive `moves the data` into its warehouse directory(managed tables). Alternatively, you may create an external table, which tells Hive to `refer to` the data that is at an existing location outside the warehouse directory.  

The difference between the two table types is seen in the LOAD and DROP semantics.

When you load data into a managed table, it is moved into Hive’s warehouse directory.  For example, this:
```sql
CREATE TABLE certain_managed_table (dummy STRING);
LOAD DATA INPATH '/user/tom/data.txt' INTO table certain_managed_table;
```
will move the file hdfs://user/tom/data.txt into Hive’s warehouse directory for the certain_managed_table table, which is hdfs://user/hive/warehouse/certain_managed_table. 

The load operation is very fast because it is just a move or rename within a filesystem. However, bear in mind that `Hive does not check that the files in the table directory conform to the schema declared for the table, even for managed tables`.

If the table is later dropped, using:
```sql
DROP TABLE certain_managed_table;
```
the table, including its metadata and its data, is deleted.  It bears repeating that since the` initial LOAD performed a move operation`, and the DROP performed a delete operation, the data no longer exists anywhere.

An external table behaves differently. `You control the creation and deletion of the data`.  The location of the external data is specified at table creation time:  
```sql
CREATE EXTERNAL TABLE certain_external_table (dummy STRING)
LOCATION '/user/tom/certain_external_table';
LOAD DATA INPATH '/user/tom/data.txt' INTO TABLE certain_external_table;
```
With the EXTERNAL keyword, Hive knows that it is not managing the data, so it `doesn’t move it to its warehouse directory`. Indeed, `it doesn’t even check whether the external location exists at the time it is defined`. This is a useful feature because it means you can create the data lazily after creating the table. 

When you drop an external table, Hive will leave the data untouched and `only delete the metadata`.

**So how do you choose which type of table to use?**   
`In most cases, there is not much difference between the two (except of course for the difference in DROP semantics), so it is a just a matter of preference.` `As a rule of thumb, if you are doing all your processing with Hive, then use managed tables, but if you wish to use Hive and other tools on the same dataset, then use external tables`. A common pattern is to use an external table to access an initial dataset stored in HDFS (created by another process), then use a Hive transform to move the data into a managed Hive table. This works the other way around, too; `an external table (not necessarily on HDFS)` can be used to `export data from Hive` for other applications to use.  
Another reason for using external tables is when you wish to `associate multiple schemas with the same dataset`.

#### Partitions and Buckets
Hive organizes tables into partitions—a way of dividing a table into coarse-grained parts based on the value of a partition column, such as a date.  

A table may be partitioned in multiple dimensions.

```sql
CREATE TABLE logs (ts BIGINT, line STRING)
PARTITIONED BY (dt STRING, country STRING);

LOAD DATA LOCAL INPATH 'input/hive/partitions/file1'
INTO TABLE logs
PARTITION (dt='2001-01-01', country='GB');
```

At the filesystem level, partitions are `simply nested subdirectories of the table directory`.
After loading a few more files into the logs table, the directory structure might look like this:
```html
/user/hive/warehouse/logs
    ├── dt=2001-01-01/
    │ ├── country=GB/
    │ │ ├── file1
    │ │ └── file2
    │ └── country=US/
    │ └── file3
    └── dt=2001-01-02/
        ├── country=GB/
        │ └── file4
        └── country=US/
        ├── file5
        └── file6
```

```sql
hive> SHOW PARTITIONS logs;
dt=2001-01-01/country=GB
dt=2001-01-01/country=US
dt=2001-01-02/country=GB
dt=2001-01-02/country=US
```

One thing to bear in mind is that the column definitions in the PARTITIONED BY clause are full-fledged table columns, called `partition columns`; however, `the datafiles do not contain values for these columns`, since they are derived from the directory names.
You can use partition columns in SELECT statements in the usual way. Hive performs input pruning to scan only the relevant partitions. For example:
```sql
SELECT ts, dt, line
FROM logs
WHERE country='GB';
```
will only scan file1, file2, and file4. Notice, too, that the query returns the values of the dt partition column, which Hive reads from the directory names since they are not in the datafiles.

There are two reasons why you might want to organize your tables (or partitions) into **bucket**s.   
* The first is to enable more efficient queries.  
Bucketing imposes extra structure on the table, which Hive can take advantage of when performing certain queries. In particular, a join of two tables that are bucketed on the same columns—which include the join columns—can be efficiently `implemented as a map-side join`.   
* The second reason to bucket a table is to make sampling more efficient.  
When working with large datasets, it is very convenient to try out queries on a fraction of your dataset while you are in the process of developing or refining them.  

First, let’s see how to tell Hive that a table should be bucketed. We use the `CLUSTERED BY` clause to specify the columns to bucket on and the number of buckets:  
```sql
CREATE TABLE bucketed_users (id INT, name STRING)
CLUSTERED BY (id) INTO 4 BUCKETS;
```
Here we are using the user ID to determine the bucket (which Hive does by `hashing the value and reducing modulo the number of buckets`), so any particular bucket will effectively have a random set of users in it.

This optimization (map-side join) also works when `the number of buckets in the two tables are multiples of each other; they do not have to have exactly the same number of buckets`.

`The data within a bucket may additionally be sorted by one or more columns. This allows even more efficient map-side joins, since the join of each bucket becomes an efficient merge sort`(PS: for hadoop map side join, the tables are required to be sorted by same keys, which are joint keys). The syntax for declaring that a table has sorted buckets is:  
```sql
CREATE TABLE bucketed_users (id INT, name STRING) 
CLUSTERED BY (id) SORTED BY (id ASC) INTO 4 BUCKETS;
```

How can we make sure the data in our table is bucketed? Although it’s possible to load data generated outside Hive into a bucketed table, it’s often easier to get Hive to do the bucketing, usually from an existing table. It is advisable to get Hive to perform the bucketing.  

Take an unbucketed users table:  
```sql
hive> SELECT * FROM users;
0 Nat
2 Joe
3 Kay
4 Ann
```

`To populate the bucketed table, we need to set the hive.enforce.bucketing property to true so that Hive knows to create the number of buckets declared in the table definition. Then it is just a matter of using the INSERT command`:  
```sql
INSERT OVERWRITE TABLE bucketed_users
SELECT * FROM users;
```
`Physically, each bucket is just a file in the table (or partition) directory`. The filename is not important, but bucket n is the nth file when arranged in lexicographic order. In fact, `buckets correspond to MapReduce output file partitions`: a job will produce as many buckets (output files) as reduce tasks. We can see this by looking at the layout of the bucketed_users table we just created. Running this command:  
```shell
hive> dfs -ls /user/hive/warehouse/bucketed_users;
000000_0
000001_0
000002_0
000003_0

hive> dfs -cat /user/hive/warehouse/bucketed_users/000000_0;
0Nat
4Ann
```

We can see the same thing by sampling the table using the **TABLESAMPLE** clause, which restricts the query to a fraction of the buckets in the table rather than the whole table, Bucket numbering is 1-based:  
```sql
hive> SELECT * FROM bucketed_users
> TABLESAMPLE(BUCKET 1 OUT OF 4 ON id);
4 Ann
0 Nat
```

It’s possible to sample a number of buckets by specifying a different proportion (which need not be an exact multiple of the number of buckets, as sampling is not intended to be a precise operation). For example, this query returns half of the buckets:  
```sql
hive> SELECT * FROM bucketed_users
> TABLESAMPLE(BUCKET 1 OUT OF 2 ON id);
4 Ann
0 Nat
2 Joe
```
Sampling a bucketed table is very efficient because the query only has to read the buckets that match the TABLESAMPLE clause. Contrast this with sampling a nonbucketed table using the rand() function, where the whole input dataset is scanned, even if only a very small sample is needed:  
```sql
hive> SELECT * FROM users
> TABLESAMPLE(BUCKET 1 OUT OF 4 ON rand());
2 Joe
```

#### Storage Formats
There are two dimensions that govern table storage in Hive: `the row format and the file format`.  

* The row format  
The row format dictates how rows, and the fields in a particular row, are stored. In Hive parlance, the row format is defined by a **SerDe**, a portmanteau word for a Serializer-Deserializer.  
When `acting as a deserializer, which is the case when querying a table`, a SerDe will deserialize a row of data from the bytes in the file to objects used internally by Hive to operate on that row of data. `When used as a serializer, which is the case when performing an INSERT or CTAS (see “Importing Data” on page 500)(PS: short for Creat Table As Select)`, the table’s SerDe will serialize Hive’s internal representation of a row of data into the bytes that are written to the output file.  
`The table’s SerDe is not used for the load operation`.

* The file format  
The file format dictates the container format for fields in a row. The simplest format is a plain-text file, but there are row-oriented and column-oriented binary formats available, too.  

##### The default storage format: Delimited text
When you create a table with no `ROW FORMAT` or `STORED AS` clauses, the default format is delimited text with one row per line. `hive.default.fileformat`

The default row delimiter is the Ctrl-A character from the set of ASCII control codes (it has ASCII code 1).

For nested types, however, this isn’t the whole story, and in fact the level of the nesting determines the delimiter. For an array of arrays, for example, the delimiters for the outer array are Ctrl-B characters, as expected, but for the inner array they are Ctrl-C characters, the next delimiter in the list. If you are unsure which delimiters Hive uses for a particular nested structure, you can run a command like:  
```sql
CREATE TABLE nested
AS
SELECT array(array(1, 2), array(3, 4))
FROM dummy;
```
and then use `hexdump` or something similar to examine the delimiters in the output file.

Hive actually supports eight levels of delimiters, corresponding to ASCII codes 1, 2, ... 8, but you can override only the first three.

Thus, the statement:
```sql
CREATE TABLE ...;
```
is identical to the more explicit:
```
CREATE TABLE ...
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\001'
    COLLECTION ITEMS TERMINATED BY '\002'
    MAP KEYS TERMINATED BY '\003'
    LINES TERMINATED BY '\n'
    STORED AS TEXTFILE;
```

Internally, Hive uses a SerDe called **LazySimpleSerDe** for this delimited format, along with the `line-oriented MapReduce text input and output formats` we saw in Chapter 8. The “lazy” prefix comes about because it deserializes fields lazily—only as they are accessed. However, `it is not a compact format` because fields are stored in a verbose textual format.

`The simplicity of the format` has a lot going for it, such as making it easy to process with other tools, including MapReduce programs or `Streaming`, but `there are more compact and performant binary storage formats` that you might consider using.

##### Binary storage formats: Sequence files, Avro datafiles, Parquet files, RCFiles, and ORCFiles

The two row-oriented formats supported natively in Hive are Avro datafiles (see Chapter 12) and sequence files (see “SequenceFile” on page 127). Both are general-purpose, splittable, compressible formats; in addition, Avro supports schema evolution and multiple language bindings. From Hive 0.14.0, a table can be stored in Avro format using:  
```sql
SET hive.exec.compress.output=true; 
SET avro.output.codec=snappy; 
CREATE TABLE ... STORED AS AVRO;
```

Hive has native support for the Parquet (see Chapter 13), RCFile, and ORCFile column-oriented binary formats (see “Other File Formats and Column-Oriented Formats” on page 136). Here is an example of creating a copy of a table in Parquet format using CREATE TABLE...AS SELECT (see “CREATE TABLE...AS SELECT” on page 501):  
```sql
CREATE TABLE users_parquet STORED AS PARQUET
AS
SELECT * FROM users;
```

##### Using a custom SerDe: RegexSerDe
Let’s see how to use a custom SerDe for loading data. We’ll use a contrib SerDe that uses a regular expression for reading the fixed-width station metadata from a text file:  
```sql
CREATE TABLE stations (usaf STRING, wban STRING, name STRING)
    ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
    WITH SERDEPROPERTIES (
    "input.regex" = "(\\d{6}) (\\d{5}) (.{29}) .*"
    );
```
`input.regex` is the regular expression pattern to be `used during deserialization` to turn the line of text forming the row into a set of columns. Java regular expression syntax is used for the matching, and columns are formed from capturing groups of parentheses.

To populate the table, we use a LOAD DATA statement as before:  
```sql
LOAD DATA LOCAL INPATH "input/ncdc/metadata/stations-fixed-width.txt"
INTO TABLE stations;
```
`The table’s SerDe is not used for the load operation.`

As this example demonstrates, **RegexSerDe** can be useful for getting data into Hive, but `due to its inefficiency` it should not be used for general-purpose storage. `Consider copying the data into a binary storage format instead`.

##### Storage handlers
`Storage handlers are used for storage systems that Hive cannot access natively, such as HBase`. Storage handlers are specified using a STORED BY clause, instead of the ROW FORMAT and STORED AS clauses.

#### Hive Importing Data
1. We’ve already seen how to use the LOAD DATA operation to import data into a Hive table (or partition) by copying or moving files to the table’s directory.   
2. You can also populate a table with data from another Hive table using an INSERT statement   
Here’s an example of an INSERT statement:  
```sql
INSERT OVERWRITE TABLE target
SELECT col1, col2
FROM source;
```
For partitioned tables, you can specify the partition to insert into `by supplying a PARTITION clause`:  
```sql
INSERT OVERWRITE TABLE target
PARTITION (dt='2001-01-01')
SELECT col1, col2
FROM source;
```
The OVERWRITE keyword means that the contents of the target table or partition are replaced by the results of the SELECT statement. If you want to add records to an already populated nonpartitioned table or partition, use `INSERT INTO TABLE`.  
You can specify the partition dynamically by determining the partition value from the  SELECT statement:  
```sql
INSERT OVERWRITE TABLE target
PARTITION (dt)
SELECT col1, col2, dt
FROM source;
```
This is known as a `dynamic partition insert`.  
From Hive 0.14.0, you can use the `INSERT INTO TABLE...VALUES` statement  
3. at creation time using the **CTAS** construct, which is an abbreviation used to refer to `CREATE TABLE...AS SELECT`.  
```sql
CREATE TABLE target
AS
SELECT col1, col2
FROM source;
```

##### Multitable insert
In HiveQL, you can turn the INSERT statement around and start with the FROM clause for the same effect(not limited to multitable insert):  
```sql
FROM source
INSERT OVERWRITE TABLE target
SELECT col1, col2;
```

This so-called `multitable insert` is more efficient than multiple INSERT statements because `the source table needs to be scanned only once` to produce the multiple disjoint outputs.  
Here’s an example that computes various statistics over the weather dataset:  
```sql
FROM records2
INSERT OVERWRITE TABLE stations_by_year
    SELECT year, COUNT(DISTINCT station)
    GROUP BY year
INSERT OVERWRITE TABLE records_by_year
    SELECT year, COUNT(1)
    GROUP BY year
INSERT OVERWRITE TABLE good_records_by_year
    SELECT year, COUNT(1)
    WHERE temperature != 9999 AND quality IN (0, 1, 4, 5, 9)
    GROUP BY year;
```

#### Hive Altering Tables
Because Hive uses the schema-on-read approach, `it’s flexible in permitting a table’s definition to change` after the table has been created. The general caveat, however, is that in many cases, it is `up to you to ensure` that the data is changed to reflect the new structure.

```sql
ALTER TABLE source RENAME TO target;
```
ALTER TABLE moves the underlying table directory(not external table) so that it reflects the new name.

```sql
ALTER TABLE target ADD COLUMNS (col3 STRING);
```
Because `Hive does not permit updating existing records`, you will need to arrange for the underlying files to be updated by another mechanism. For this reason, it is more common to `create a new table` that defines new columns and populates them using a SELECT statement.  

Changing a column’s metadata, such as a column’s name or data type, is more straightforward, assuming that the old data type can be interpreted as the new data type.

#### Hive Dropping Tables
The DROP TABLE statement deletes the data and metadata for a table. In the case of external tables, only the metadata is deleted; the data is left untouched.

If you want to delete all the data in a table but keep the table definition, use TRUNCATE TABLE. For example:
```sql
TRUNCATE TABLE my_table;
```

In a similar vein, if you want to create a new, empty table with the same schema as another table, then use the LIKE keyword:  
```sql
CREATE TABLE new_table LIKE existing_table;
```

### Hive Querying Data
#### Hive Sorting and Aggregating
Sorting data in Hive can be achieved by using a standard `ORDER BY` clause. `ORDER BY performs a parallel total sort` of the input (like that described in “Total Sort” on page 259). When a globally sorted result is not required—and in many cases it isn’t—you can use Hive’s nonstandard extension, `SORT BY`, instead. `SORT BY produces a sorted file per reducer`.

In some cases, you want to `control which reducer a particular row goes to`—typically so you can perform some subsequent aggregation. This is what Hive’s `DISTRIBUTE BY` clause does. Here’s an example to sort the weather dataset by year and temperature, in such a way as to ensure that all the rows for a given year end up in the same reducer partition (same effect as secondary sort):  
```sql
hive> FROM records2
> SELECT year, temperature
> DISTRIBUTE BY year
> SORT BY year ASC, temperature DESC;
1949 111
1949 78
1950 22
1950 0
1950 -11
```
If the columns for SORT BY and DISTRIBUTE BY are the same, you can use CLUSTER BY as a shorthand for specifying both.

#### MapReduce Scripts
`Using an approach like Hadoop Streaming`, the `TRANSFORM, MAP, and REDUCE clauses` make it possible to invoke an external script or program from Hive.  

Suppose we want to use a script to filter out rows that don’t meet some condition, such as the script in Example 17-1, which removes poor-quality readings.  

**Example 17-1. Python script to filter out poor-quality weather records**  
```python
#!/usr/bin/env python
import re
import sys

for line in sys.stdin:
    (year, temp, q) = line.strip().split()
    if (temp != "9999" and re.match("[01459]", q)):
        print "%s\t%s" % (year, temp)
```

We can use the script as follows:  
```sql
hive> ADD FILE /Users/tom/book-workspace/hadoop-book/ch17-hive/src/main/python/is_good_quality.py;
hive> FROM records2
> SELECT TRANSFORM(year, temperature, quality)
> USING 'is_good_quality.py'
> AS year, temperature;
1950 0
1950 22
1950 -11
1949 111
1949 78
```

This example has no reducers. If we use a nested form for the query, we can specify a map and a reduce function. This time we use the MAP and REDUCE keywords, but SELECT TRANSFORM in both cases would have the same result.
```sql
FROM (
    FROM records2
    MAP year, temperature, quality
    USING 'is_good_quality.py'
    AS year, temperature) map_output
REDUCE year, temperature
USING 'max_temperature_reduce.py'
AS year, temperature;
```

#### Hive Joins
```sql
hive> SELECT * FROM sales;
Joe 2
Hank 4
Ali 0
Eve 3
Hank 2
hive> SELECT * FROM things;
2 Tie
4 Coat
3 Hat
1 Scarf
```

* Inner joins  
```sql
hive> SELECT sales.*, things.*
> FROM sales JOIN things ON (sales.id = things.id);
Joe 2 2 Tie
Hank 4 4 Coat
Eve 3 3 Hat
Hank 2 2 Tie

hive> SELECT sales.*, things.*
FROM sales, things
WHERE sales.id = things.id;
```
`Hive only supports equijoins`.  
`The order of the tables in the JOIN clauses is significant`. `It’s generally best to have the largest table last`(PS: internally, if both tables are not bucketed on the joined keys, reducer side join would be used, the first table will be cached for later joining with the second, hence the largest table should come last. If they are bucketed, it shouldn't matter.), but see the Hive wiki for more details, including how to `give hints to the Hive planner`.  
A single join is implemented as a single MapReduce job, but multiple joins can be performed in less than one MapReduce job per join if the same column is used in the join condition. You can see how many MapReduce jobs Hive will use for any particular query by prefixing it with the EXPLAIN (EXPLAIN EXTENDED) keyword:  
```sql
EXPLAIN
SELECT sales.*, things.*
FROM sales JOIN things ON (sales.id = things.id);
```
* Outer joins  
LEFT OUTER JOIN, RIGHT OUTER JOIN, FULL OUTER JOIN
* Semi joins  
```sql
SELECT *
FROM things
WHERE things.id IN (SELECT id from sales);
```
Consider this `IN subquery`, it is equivalent to:     
```sql
hive> SELECT *
> FROM things LEFT SEMI JOIN sales ON (sales.id = things.id);
2 Tie
4 Coat
3 Hat
```
* Map joins  
Consider the original inner join again:  
```sql
SELECT sales.*, things.*
FROM sales JOIN things ON (sales.id = things.id);
```
If `one table is small enough to fit in memory`, as things is here, Hive can load it into memory to perform the join in each of the mappers. This is called a map join.   
`The job to execute this query has no reducers`, so `this query would not work for a RIGHT or FULL OUTER JOIN, since absence of matching can be detected only in an aggregating (reduce) ste` across all the inputs`.   
Map joins can take advantage of bucketed tables (see “Buckets” on page 493), since a mapper working on a bucket of the left table needs to load only the corresponding buckets of the right table to perform the join. The syntax for the join is the same as for the in-memory case shown earlier; however, you also need to enable the optimization with the following:  
```sql
SET hive.optimize.bucketmapjoin=true;
```

#### Hive Subqueries
`Hive has limited support for subqueries, permitting a subquery in the FROM clause of a SELECT statement, or in the WHERE clause in certain cases`.  

`Hive allows uncorrelated subqueries`(PS: contradict what is in Table 17-2. A high-level comparison of SQL and HiveQL), where the subquery is a self-contained query referenced by an IN or EXISTS statement in the WHERE clause. `Correlated subqueries, where the subquery references the outer query, are not currently supported`.  

#### Hive Views
In Hive, a view is not materialized to disk when it is created; rather, the view’s SELECT statement is executed when the statement that refers to the view is run.  
```sql
DESCRIBE EXTENDED view_name
```

Views in Hive are read-only, so there is no way to load or insert data into an underlying base table via a view.

### Hive User-Defined Functions
`A user-defined function (UDF) have to be written in Java, the language that Hive itself is written in`. For other
languages, consider using a `SELECT TRANSFORM` query, which allows you to stream data through a user-defined script.

There are 3 types of UDF in Hive: (regular) UDFs, user-defined aggregate functions (UDAFs), and user-defined table-generating functions (UDTFs). They differ in the number of rows that they accept as input and produce as output.
1. (regular) UDFs  
A UDF operates on a single row and produces a single row as its output. Most functions, such as mathematical functions and string functions, are of this type.
2. user-defined aggregate functions (UDAFs)  
A UDAF works on multiple input rows and creates a single output row. Aggregate functions include such functions as COUNT and MAX.
3. user-defined table-generating functions (UDTFs)  
A UDTF operates on a single row and produces multiple rows—a table—as output.   

```sql
CREATE TABLE arrays (x ARRAY<STRING>)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\001'
    COLLECTION ITEMS TERMINATED BY '\002';

## source data file, ^B is \002
a^Bb
c^Bd^Be
```

```sql
hive> SELECT * FROM arrays;
["a","b"]
["c","d","e"]

## a UDTF explode
hive> SELECT explode(x) AS y FROM arrays;
a
b
c
d
e
```
SELECT statements using UDTFs have some restrictions (e.g., they cannot retrieve additional column expressions), which make them less useful in practice. For this reason, Hive supports `LATERAL VIEW` queries, which are more powerful. LATERAL VIEW queries are not covered here, but you may find out more about them in the Hive wiki.

#### Writing a UDF

**Example 17-2. A UDF for stripping characters from the ends of strings**  
```sql
package com.hadoopbook.hive;
import org.apache.commons.lang.StringUtils;
import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;
public class Strip extends UDF {
    private Text result = new Text();
    public Text evaluate(Text str) {
        if (str == null) {
            return null;
        }
        result.set(StringUtils.strip(str.toString()));
        return result;
    } 
    public Text evaluate(Text str, String stripChars) {
        if (str == null) {
            return null;
        }
        result.set(StringUtils.strip(str.toString(), stripChars));
        return result;
    }
}
```
A UDF must satisfy the following two properties:  
* A UDF must be a subclass of org.apache.hadoop.hive.ql.exec.UDF.
* A UDF must implement at least one evaluate() method.  

`The evaluate() method is not defined by an interface`, since it may take an arbitrary number of arguments, of arbitrary types, and it may return a value of arbitrary type. Hive introspects the UDF to find the evaluate() method that matches the Hive function that was invoked.

Hive actually supports Java primitives in UDFs (and a few other types, such as java.util.List and java.util.Map), so a signature like:  
```java
public String evaluate(String str)
```
would work equally well.
```sql
CREATE FUNCTION strip AS 'com.hadoopbook.hive.Strip'
USING JAR '/path/to/hive-examples.jar';
```
```sql
DROP FUNCTION strip;
```
It’s also possible to create a function for the duration of the Hive session, so it is not persisted in the metastore, using the `TEMPORARY` keyword:   
```sq;
ADD JAR /path/to/hive-examples.jar;
CREATE TEMPORARY FUNCTION strip AS 'com.hadoopbook.hive.Strip';
```

When using temporary functions, it may be useful to create a `.hiverc` file in your home directory containing the commands to define your UDFs. The file will be automatically run at the beginning of each Hive session.  

Alternative to ADD JAR, 
* hive --auxpath /path/to/hive-examples.jar
* set the HIVE_AUX_JARS_PATH environment variable

#### Writing a UDAF
**Example 17-3. A UDAF for calculating the maximum of a collection of integers**  
```java
package com.hadoopbook.hive;
import org.apache.hadoop.hive.ql.exec.UDAF;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;
import org.apache.hadoop.io.IntWritable;
public class Maximum extends UDAF {
    public static class MaximumIntUDAFEvaluator implements UDAFEvaluator {
        private IntWritable result;
        public void init() {
            result = null;
        }
        public boolean iterate(IntWritable value) {
            if (value == null) {
                return true;
            }
            if (result == null) {
                result = new IntWritable(value.get());
            } else {
                result.set(Math.max(result.get(), value.get()));
            }
            return true;
        }
        public IntWritable terminatePartial() {
            return result;
        }
        public boolean merge(IntWritable other) {
            return iterate(other);
        }
        public IntWritable terminate() {
            return result;
        }
    }
}
```
A UDAF must be a subclass of `org.apache.hadoop.hive.ql.exec.UDAF` and contain one or more nested static classes implementing org.apache.hadoop.hive.ql.ex ec.UDAFEvaluator.  

An evaluator must implement 5 methods, described in turn here (the flow is illustrated in Figure 17-3):  
1. init()  
The init() method initializes the evaluator and resets its internal state.  
2. iterate()  
The iterate() method is called every time there is a new value to be aggregated.  
We return true to indicate that the input value was valid.  
3. terminatePartial()  
The terminatePartial() method is called when Hive wants a result for the partial aggregation.  
4. merge()  
The merge() method is called when Hive decides to combine one partial aggregation with another. The method takes a single object, whose type must correspond to the return type of the terminatePartial() method.  
5. terminate()  
The terminate() method is called when the final result of the aggregation is needed.  

**Figure 17-3. Data flow with partial results for a UDAF**  
![hadoop_hive_udaf_flow_img_1]  

```java
package com.hadoopbook.hive;
import org.apache.hadoop.hive.ql.exec.UDAF;
import org.apache.hadoop.hive.ql.exec.UDAFEvaluator;
import org.apache.hadoop.hive.serde2.io.DoubleWritable;
public class Mean extends UDAF {
    public static class MeanDoubleUDAFEvaluator implements UDAFEvaluator {
        public static class PartialResult {
            double sum;
            long count;
        }
        private PartialResult partial;
        public void init() {
            partial = null;
        }
        public boolean iterate(DoubleWritable value) {
            if (value == null) {
                return true;
            }
            if (partial == null) {
                partial = new PartialResult();
            }
            partial.sum += value.get();
            partial.count++;
            return true;
        }
        public PartialResult terminatePartial() {
            return partial;
        }
        public boolean merge(PartialResult other) {
            if (other == null) {
                return true;
            }
            if (partial == null) {
                partial = new PartialResult();
            }
            partial.sum += other.sum;
            partial.count += other.count;
            return true;
        }
        public DoubleWritable terminate() {
            if (partial == null) {
                return null;
            }
            return new DoubleWritable(partial.sum / partial.count);
        }
    }
}
```

## 20. HBase  
In this chapter, we only scratched the surface of what’s possible with HBase. For more in-depth information, consult the project’s Reference Guide([Apache HBase ™ Reference Guide]), [HBase: The Definitive Guide] by Lars George (O’Reilly, 2011, new edition forthcoming), or [HBase in Action] by Nick Dimiduk and Amandeep Khurana (Manning, 2012).

HBase is a `distributed column-oriented` database built on top of HDFS. HBase is the Hadoop application to use when you require `real-time read/write random access to very large datasets`.

Although there are countless strategies and implementations for database storage and retrieval, most solutions—especially those of the relational variety—are not built with very large scale and distribution in mind. Many vendors offer replication and partitioning solutions to grow the database beyond the confines of a single node, but these add-ons are generally an afterthought and are complicated to install and maintain. They also severely compromise the RDBMS feature set. Joins, complex queries, triggers, views, and foreign-key constraints become prohibitively expensive to run on a scaled RDBMS, or do not work at all.

HBase approaches the scaling problem from the opposite direction. It is built from the ground up to scale linearly just by adding nodes. `HBase is not relational and does not support SQL`, but given the proper problem space, it is able to do what an RDBMS cannot: `host very large, sparsely populated tables on clusters made from commodity hardware`.

But see the `Apache Phoenix` project, mentioned in “SQL-on-Hadoop Alternatives” on page 484, and `Trafodion`, a transactional SQL database built on HBase.

The HBase project was started toward the end of 2006 by Chad Walters and Jim Kellerman at Powerset. It was modeled after Google’s Bigtable, which had just been published. Fay Chang et al., “Bigtable: A Distributed Storage System for Structured Data,” November 2006. [Bigtable: A Distributed Storage System for Structured Data,]  

### Whirlwind Tour of the Data Model

Applications store data in labeled tables. Tables are made of rows and columns. `Table cells`—the intersection of row and column coordinates—are `versioned`. By default, their version is a timestamp auto-assigned by HBase at the time of cell insertion. `A cell’s content is an uninterpreted array of bytes.`

![hadoop_hbase_data_model_img_1]  
**Figure 20-1. The HBase data model, illustrated for a table storing photos**  

`Table row keys are also byte arrays`, `so theoretically anything can serve as a row key`, from strings to binary representations of long or even serialized data structures. Table rows are sorted by row key, aka the `table’s primary key`. `The sort is byte-ordered`. All table accesses are via the primary key.

`HBase doesn’t support indexing of other columns in the table (also known as secondary indexes). However, there are several strategies for supporting the types of query that secondary indexes provide`, each with different trade-offs between storage space, processing load, and query execution time; see the [HBase Reference Guide] for a discussion.  

Row columns are grouped into `column families`. All column family members have a common prefix, and the column family qualifier. The column family and the qualifier are always separated by a colon character (:).  For examlpe,  the columns info:format and info:geo are both members of the info column family. 

A table’s column families must be specified up front as part of the table schema definition, but `new column family members can be added on demand`. For example, a new column info:camera can be offered by a client as part of an update, and its value persisted, as long as the column family info already exists on the table.  

`Physically, all column family members are stored together on the filesystem.` So although earlier we described HBase as a column-oriented store, it would be more accurate if it were described as a `column-family-oriented store`. `Because tuning and storage specifications are done at the column family level`, `it is advised that all column family members have the same general access pattern and size characteristics`. For the photos table, the image data, which is large (megabytes), is stored in a separate column family from the metadata, which is much smaller in size (kilobytes).

`In synopsis, HBase tables are like those in an RDBMS, only cells are versioned, rows are sorted, and columns can be added on the fly by the client as long as the column family they belong to preexists`.

#### HBase Regions
Tables are automatically partitioned horizontally by HBase into regions. Each region comprises a subset of a table’s rows. `A region is denoted by the table it belongs to, its first row (inclusive), and its last row (exclusive)`. Initially, a table comprises a single region, but as the region grows it eventually crosses a configurable size threshold, at which point it `splits at a row boundary into two new regions of approximately equal size`. Until this first split happens, all loading will be against the single server hosting the original region. As the table grows, the number of its regions grows. `Regions are the units that get distributed over an` **HBase cluster**. In this way, a table that is too big for any one server can be carried by a cluster of servers, with each node hosting a subset of the table’s total regions. This is also the means by which the loading on a table gets distributed. The online set of sorted regions comprises the table’s total content.

#### HBase Locking  
`Row updates are atomic, no matter how many row columns constitute the row-level transaction`. This keeps the locking model simple.

### HBase Implementation

![hadoop_hbase_implementation_img_1]  
**Figure 20-2. HBase cluster members**

HBase is made up of `an HBase master node` orchestrating a cluster of one or more `regionserver workers` (see Figure 20-2). 

The HBase master is responsible for bootstrapping a virgin install, for assigning regions to registered regionservers, and for recovering regionserver failures. `The master node is lightly loaded.` 

The regionservers carry zero or more regions and field client read/write requests. They also `manage region splits`, informing the HBase master about the new daughter regions so it can manage the offlining of parent regions and assignment of the replacement daughters.

`HBase depends on ZooKeeper` (Chapter 21), and `by default it manages a ZooKeeper instance as the authority on cluster state`, `although it can be configured to use an existing ZooKeeper cluster instead`.  

The ZooKeeper ensemble `hosts vitals such as the location of the hbase:meta catalog table and the address of the current cluster master`. `Assignment of regions is mediated via ZooKeeper` in case participating servers crash mid-assignment. `Hosting the assignment transaction state in ZooKeeper` makes it so recovery can pick up on the assignment where the crashed server left off. At a minimum, when bootstrapping a client connection to an HBase cluster, the client must be passed the location of the ZooKeeper ensemble. Thereafter,` the client navigates the ZooKeeper hierarchy to learn cluster attributes such as server locations.`  

Regionserver worker nodes are listed in the HBase `conf/regionservers` file, as you would list datanodes and node managers in the Hadoop etc/hadoop/slaves file. Start and stop scripts are like those in Hadoop and use the same SSH-based mechanism for running remote commands. A cluster’s site-specific configuration is done in the HBase conf/ hbase-site.xml and conf/hbase-env.sh files, which have the same format as their equivalents in the Hadoop parent project (see Chapter 10).

Where there is commonality to be found, whether in a service or type, `HBase typically directly uses or subclasses the parent Hadoop implementation`. When this is not possible, HBase will follow the Hadoop model where it can.  What this means for you, the user, is that you can leverage any Hadoop familiarity in your exploration of HBase. HBase deviates from this rule only when adding its specializations.

`HBase persists data via the Hadoop filesystem API. Most people using HBase run it on HDFS for storage`, though by default, and unless told otherwise, HBase writes to the local filesystem. The local filesystem is fine for experimenting with your initial HBase install, but thereafter, the first configuration made in an HBase cluster usually involves pointing HBase at the HDFS cluster it should use.

Internally, HBase keeps a special catalog table named `hbase:meta`, within which it maintains the current list, state, and locations of `all user-space regions` afloat on the cluster. Entries in hbase:meta are `keyed by region name`, where a region name is made up of the name of the table the region belongs to, the region’s start row, its time of creation, and finally, an MD5 hash of all of these (i.e., a hash of table name, start row, and creation timestamp). Here is an example region name for a region in the table TestTable whose start row is xyz:  
TestTable,xyz,1279729913622.1b6e176fb8d8aa88fd4ab6bc80247ece.  

As noted previously, row keys are sorted, so finding the region that hosts a particular row is a matter of a lookup to find the largest entry whose key is less than or equal to that of the requested row key. As regions transition—are split, disabled, enabled, deleted, or redeployed by the region load balancer, or redeployed due to a regionserver crash— the catalog table is updated so the state of all regions on the cluster is kept current.

Fresh clients `connect to the ZooKeeper cluster first` to learn the location of hbase:meta. The client then `does a lookup against the appropriate hbase:meta region` to figure out the hosting user-space region and its location. Thereafter, the client `interacts directly with the hosting regionserver`.

To save on having to make `three round-trips per row operation`, `clients cache all they learn while doing lookups for hbase:meta.` They cache locations as well as user-space region start and stop rows, so they can figure out hosting regions themselves without having to go back to the hbase:meta table. `Clients continue to use the cached entries as they work, until there is a fault`. When this happens—i.e., when the region has moved— the client consults the hbase:meta table again to learn the new location. If the consulted hbase:meta region has moved, then ZooKeeper is reconsulted.

Writes arriving at a regionserver are first appended to a `commit log` and then added to an in-memory `memstore`. When a memstore fills, its content is flushed to the filesystem.

`The commit log is hosted on HDFS`, `so it remains available through a regionserver crash`. When the master notices that a regionserver is no longer reachable, usually because the server’s znode has expired in ZooKeeper, it `splits the dead regionserver’s commit log by region. `On reassignment and before they reopen for business, regions that were on the dead regionserver will pick up their just-split files of not-yet-persisted edits and replay them to bring themselves up to date with the state they had just before the failure(PS: these surely aren't done by region itself, probably by region server).

`When reading, the region’s(PS: regionserver's) memstore is consulted first`. If `sufficient versions` are found reading memstore alone, the query completes there. Otherwise, `flush files are consulted in order, from newest to oldest`, either until versions sufficient to satisfy the query are found or until we run out of flush files.

`A background process compacts flush files` once their number has exceeded a threshold, rewriting many files as one, because the fewer files a read consults, the more performant it will be. On compaction, the process `cleans out versions beyond the schema-configured maximum` and `removes deleted and expired cells`. `A separate process running in the regionserver monitors flush file sizes, splitting the region` when they grow in excess of the configured maximum.

### HBase Installation

1. Download a stable release from [Apache HBase Download] and unpack it on your local filesystem
2. JAVA_HOME environment variable is set properly.
3. hbase environment variables
```shell
$ export HBASE_HOME=/usr/local/hbase
$ export PATH=$PATH:$HBASE_HOME/bin
```
4. change setting to prevent zookeeper error  
```html
2017-12-02 14:44:32,056 ERROR [main] zookeeper.RecoverableZooKeeper: ZooKeeper exists failed after 4 attempts
2017-12-02 14:44:32,059 WARN  [main] zookeeper.ZKUtil: hconnection-0x544e81490x0, quorum=localhost:2181, baseZNode=/hbase Unable to set watcher on znode (/hbase/hbaseid)
org.apache.zookeeper.KeeperException$ConnectionLossException: KeeperErrorCode = ConnectionLoss for /hbase/hbaseid
```
```xml
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>file:///usr/local/hbase</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.clientPort</name>
    <value>2182</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>/usr/local/hbase/zookeeper</value>
  </property>
  <property>
    <name>hbase.master</name>
    <value>localhost:60000</value>
    <description>The host and port that the HBase master runs at.</description>
  </property>
</configuration>
```

To start a standalone instance of HBase that uses a temporary directory on the local filesystem for persistence, use this:  
```shell
$ start-hbase.sh
```
By default, HBase writes to `/${java.io.tmpdir}/hbase-${user.name}`.  `hbase.tmp.dir` in hbase-site.xml. 

`In standalone mode, the HBase master, the regionserver, and a ZooKeeper instance are all run in the same JVM.`  

To administer your HBase instance, launch the HBase shell as follows:
```html
$ hbase shell
HBase Shell; enter 'help<RETURN>' for list of supported commands.
Type "exit<RETURN>" to leave the HBase Shell
Version 0.98.7-hadoop2, r800c23e2207aa3f9bddb7e9514d8340bcfb89277, Wed Oct 8
15:58:11 PDT 2014
hbase(main):001:0>
```
This will bring up a JRuby IRB interpreter that has had some HBase-specific commands added to it.  

To create a table, you must name your table and define its schema. `A table’s schema comprises table attributes and the list of table column families`. `Column families themselves have attributes that you in turn set at schema definition time`. Examples of column family attributes include whether the family content should `be compressed on the filesystem` and `how many versions of a cell to keep`.  

Schemas can be edited later by offlining the table using the shell `disable` command, making the necessary alterations using `alter`, then putting the table back online with `enable`.

To create a table named test with a single column family named data using defaults for table and column family attributes, enter:  
```sql
hbase(main):001:0> create 'test', 'data'
0 row(s) in 0.9810 seconds

hbase(main):002:0> list
TABLE
test
1 row(s) in 0.0260 seconds
```

See the `help` output for examples of adding table and column family attributes when specifying a schema.

To insert data into three different rows and columns in the data column family, get the first row, and then list the table content, do the following:
```shell
hbase(main):001:0> put 'test', 'row1', 'data:1', 'value1'
0 row(s) in 1.1020 seconds

hbase(main):002:0> put 'test', 'row2', 'data:2', 'value2'
0 row(s) in 0.1030 seconds

hbase(main):003:0> put 'test', 'row3', 'data:3', 'value3'
0 row(s) in 0.0460 seconds

hbase(main):004:0> get 'test', 'row1'
COLUMN                               CELL                                                                                                    
 data:1                              timestamp=1512201377001, value=value1                                                                   
1 row(s) in 0.1900 seconds

hbase(main):005:0> scan 'test'
ROW                                  COLUMN+CELL                                                                                             
 row1                                column=data:1, timestamp=1512201377001, value=value1                                                    
 row2                                column=data:2, timestamp=1512201402962, value=value2                                                    
 row3                                column=data:3, timestamp=1512201414233, value=value3                                                    
3 row(s) in 0.1780 seconds
```
Notice how we added three new columns without changing the schema.  

To remove the table, you must first disable it before dropping it:  
```shell
hbase(main):006:0> disable 'test'
0 row(s) in 2.7610 seconds

hbase(main):007:0> drop 'test'
0 row(s) in 1.3920 seconds

hbase(main):008:0> list
TABLE                                                                                                                                        
0 row(s) in 0.0360 seconds

=> []
```

Shut down your HBase instance by running:
```shell
$ stop-hbase.sh
```

### HBase Clients

#### HBase Clients: Java
HBase, like Hadoop, is written in Java. Example 20-1 shows the Java version of how you
would do the shell operations listed in the previous section.
```java
public class ExampleClient {
    public static void main(String[] args) throws IOException {
        Configuration config = HBaseConfiguration.create();
        // Create table
        HBaseAdmin admin = new HBaseAdmin(config);
        try {
            TableName tableName = TableName.valueOf("test");
            HTableDescriptor htd = new HTableDescriptor(tableName);
            HColumnDescriptor hcd = new HColumnDescriptor("data");
            htd.addFamily(hcd);
            admin.createTable(htd);
            HTableDescriptor[] tables = admin.listTables();
            if (tables.length != 1 &&
                Bytes.equals(tableName.getName(), tables[0].getTableName().getName())) {
                throw new IOException("Failed create of table");
            }
            // Run some operations -- three puts, a get, and a scan -- against the table.
            HTable table = new HTable(config, tableName);
            try {
                for (int i = 1; i <= 3; i++) {
                    byte[] row = Bytes.toBytes("row" + i);
                    Put put = new Put(row);
                    byte[] columnFamily = Bytes.toBytes("data");
                    byte[] qualifier = Bytes.toBytes(String.valueOf(i));
                    byte[] value = Bytes.toBytes("value" + i);
                    put.add(columnFamily, qualifier, value);
                    table.put(put);
                }
                Get get = new Get(Bytes.toBytes("row1"));
                Result result = table.get(get);
                System.out.println("Get: " + result);
                Scan scan = new Scan();
                ResultScanner scanner = table.getScanner(scan);
                try {
                    for (Result scannerResult : scanner) {
                        System.out.println("Scan: " + scannerResult);
                    }
                } finally {
                    scanner.close();
                }
                // Disable then drop the table
                admin.disableTable(tableName);
                admin.deleteTable(tableName);
            } finally {
                table.close();
            }
        } finally {
            admin.close();
        }
    }
}
```
Most of the HBase classes are found in the `org.apache.hadoop.hbase` and `org.apache.hadoop.hbase.client` packages.  

From HBase 1.0, there is a new client API. In their place, clients should use the new **ConnectionFactory** class to create a **Connection** object, then call `getAdmin()` or `getTable()` to retrieve an **Admin** or **Table** instance, as appropriate.  

HBase scanners are like cursors in a traditional database or Java iterators, except—unlike the latter—they have to be closed after use.  
In the Scan instance, you can pass the row at which to start and stop the scan, which columns in a row to return in the row result, and a filter to run on the server side.  
`Scanners will, under the covers, fetch batches of 100 rows at a time, bringing them client-side and returning to the server to fetch the next batch only after the current batch has been exhausted`. `hbase.client.scanner.caching`  
Alternatively, you can set how many rows to cache on the Scan instance itself via the setCaching() method.   
Higher caching values will enable faster scanning but will eat up more memory in the client. `Also, avoid setting the caching so high that the time spent processing the batch client-side exceeds the scanner timeout period`. `If a client fails to check back with the server before the scanner timeout expires, the server will go ahead and garbage collect resources consumed by the scanner server-side.` The default scanner timeout is 60 seconds, and can be changed by setting `hbase.client.scanner.timeout.period`. Clients will see an **UnknownScannerException** if the scanner timeout has expired.

```shell
$ mvn package
$ export HBASE_CLASSPATH=hbase-examples.jar
$ hbase ExampleClient
Get: keyvalues={row1/data:1/1414932826551/Put/vlen=6/mvcc=0}
Scan: keyvalues={row1/data:1/1414932826551/Put/vlen=6/mvcc=0}
Scan: keyvalues={row2/data:2/1414932826564/Put/vlen=6/mvcc=0}
Scan: keyvalues={row3/data:3/1414932826566/Put/vlen=6/mvcc=0}
```

#### HBase Clients: MapReduce
HBase classes and utilities in the `org.apache.hadoop.hbase.mapreduce` package facilitate using HBase as a source and/or sink in MapReduce jobs. The **TableInputFormat** class makes splits on region boundaries so maps are handed a single region to work on. The **TableOutputFormat** will write the result of the reduce into HBase.  

PS:  In short,   
* getting from HBase  
    - TableInputFormat
    - Mapper subclasses TableMapper, key is ImmutableByteWritable  
* storing to HBase  
    - TableOutputFormat
    - Mapper merely outputs a list of PUT by context.write(null, PUT)
    - no Reducer

```java
public class SimpleRowCounter extends Configured implements Tool {
    static class RowCounterMapper extends TableMapper<ImmutableBytesWritable, Result> {
        public static enum Counters { ROWS }
        @Override
        public void map(ImmutableBytesWritable row, Result value, Context context) {
            context.getCounter(Counters.ROWS).increment(1);
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("Usage: SimpleRowCounter <tablename>");
            return -1;
        }
        String tableName = args[0];
        Scan scan = new Scan();
        scan.setFilter(new FirstKeyOnlyFilter());
        Job job = new Job(getConf(), getClass().getSimpleName());
        job.setJarByClass(getClass());
        TableMapReduceUtil.initTableMapperJob(tableName, scan,
            RowCounterMapper.class, ImmutableBytesWritable.class, Result.class, job);
        job.setNumReduceTasks(0);
        job.setOutputFormatClass(NullOutputFormat.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(HBaseConfiguration.create(),
            new SimpleRowCounter(), args);
        System.exit(exitCode);
    }
}
```

The RowCounterMapper nested class is a subclass of the HBase **TableMapper** abstract class, a specialization of org.apache.hadoop.mapreduce.Mapper that sets the map input types passed by `TableInputFormat`. Input keys are ImmutableBytesWritable objects (row keys), and values are Result objects (row results from a scan).   

For large tables the MapReduce program is preferable.  

#### HBase Clients: REST and Thrift
`HBase ships with REST and Thrift interfaces`. These are useful when the interacting application is written in a language other than Java. In both cases, `a Java server hosts an instance of the HBase client brokering REST and Thrift application requests` into and out of the HBase cluster. Consult the Reference Guide for information on running the services, and the client interfaces.  

### Building an Online Query Application
The existing weather dataset described in previous chapters contains observations for tens of thousands of stations over 100 years, and this data is growing without bound.

For the sake of this example, let us allow that the dataset is massive, that the observations run to the billions, and that the rate at which temperature updates arrive is significant —say, hundreds to thousands of updates per second from around the world and across the whole range of weather stations. Also, let us allow that it is a requirement that the online application must display the most up-to-date observation within a second or so of receipt.   

The first size requirement should preclude our use of a simple RDBMS instance and make HBase a candidate store. The second latency requirement rules out plain HDFS. A MapReduce job could build initial indices that allowed random access over all of the observation data, but keeping up this index as the updates arrive is not what HDFS and MapReduce are good at.

In our example, there will be two tables:   
* stations  
This table holds station data. Let the `row key be the stationid`. Let this table have `a column family info` that acts as a key-value dictionary for station information. Let the dictionary keys be the column names info:name, info:location, and info:description. This table is static, and in this case, the info family closely mirrors a typical RDBMS table design.  
* observations  
This table holds temperature observations. Let the `row key be a composite key of stationid plus a reverse-order timestamp`(Long.MAX_VALUE - timestamp). Give this table `a column family data` that will contain `one column, airtemp`, with the observed temperature as the column value.

We rely on the fact that station IDs are a fixed length. In some cases, you will need to `zero-pad number` components so row keys sort properly. Otherwise, you will run into the issue where 10 sorts before 2, say, when only the byte order is considered (02 sorts before 10). Also, `if your keys are integers, use a binary representation rather than persisting the string version of a number. The former consumes less space`.

In the shell, define the tables as follows:  
```shell
hbase(main):001:0> create 'stations', {NAME => 'info'}
0 row(s) in 0.9600 seconds

hbase(main):002:0> create 'observations', {NAME => 'data'}
0 row(s) in 0.1770 seconds
```

All access in HBase is via primary key, so the key design should lend itself to how the data is going to be queried. One thing to keep in mind when designing schemas is that a defining attribute of column(-family)-oriented stores, such as HBase, is `the ability to host wide and sparsely populated tables at no incurred cost`. 

`See Daniel J. Abadi, “Column-Stores for Wide and Sparse Data,” January 2007`.

`There is no native database join facility in HBase`, but wide tables can make it so that there is no need for database joins to pull from secondary or tertiary tables. A wide row can sometimes be made to hold all data that pertains to a particular primary key.

`There are a relatively small number of stations, so their static data is easily inserted using any of the available interfaces`. The example code includes a Java application for doing this, which is run as follows:  
```shell
$ hbase HBaseStationImporter input/ncdc/metadata/stations-fixed-width.txt
```

However, let’s assume that there are billions of individual observations to be loaded. This kind of import is normally an extremely complex and long-running database operation, but MapReduce and HBase’s distribution model allow us to make full use of the cluster. `We’ll copy the raw input data onto HDFS, and then run a MapReduce job that can read the input and write to HBase`.

**Example 20-3. A MapReduce application to import temperature data from HDFS into an HBase table**  
```java
public class HBaseTemperatureImporter extends Configured implements Tool {
    static class HBaseTemperatureMapper<K> extends Mapper<LongWritable, Text, K, Put> {
        private NcdcRecordParser parser = new NcdcRecordParser();
        @Override
        public void map(LongWritable key, Text value, Context context) throws
        IOException, InterruptedException {
            parser.parse(value.toString());
            if (parser.isValidTemperature()) {
                byte[] rowKey = RowKeyConverter.makeObservationRowKey(parser.getStationId(),
                    parser.getObservationDate().getTime());
                Put p = new Put(rowKey);
                // HBaseTemperatureQuery.DATA_COLUMNFAMILY = data
                // HBaseTemperatureQuery.AIRTEMP_QUALIFIER = airtemp
                p.add(HBaseTemperatureQuery.DATA_COLUMNFAMILY,
                    HBaseTemperatureQuery.AIRTEMP_QUALIFIER,
                    Bytes.toBytes(parser.getAirTemperature()));
                context.write(null, p);
            }
        }
    }
    @Override
    public int run(String[] args) throws Exception {
        if (args.length != 1) {
            System.err.println("Usage: HBaseTemperatureImporter <input>");
            return -1;
        }
        Job job = new Job(getConf(), getClass().getSimpleName());
        job.setJarByClass(getClass());
        FileInputFormat.addInputPath(job, new Path(args[0]));
        job.getConfiguration().set(TableOutputFormat.OUTPUT_TABLE, "observations");
        job.setMapperClass(HBaseTemperatureMapper.class);
        job.setNumReduceTasks(0);
        job.setOutputFormatClass(TableOutputFormat.class);
        return job.waitForCompletion(true) ? 0 : 1;
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(HBaseConfiguration.create(),
            new HBaseTemperatureImporter(), args);
        System.exit(exitCode);
    }
}

public class RowKeyConverter {
    private static final int STATION_ID_LENGTH = 12;
    /**
    * @return A row key whose format is: <station_id> <reverse_order_timestamp>
    */
    public static byte[] makeObservationRowKey(String stationId,
        long observationTime) {
        byte[] row = new byte[STATION_ID_LENGTH + Bytes.SIZEOF_LONG];
        Bytes.putBytes(row, 0, Bytes.toBytes(stationId), 0, STATION_ID_LENGTH);
        long reverseOrderTimestamp = Long.MAX_VALUE - observationTime;
        Bytes.putLong(row, STATION_ID_LENGTH, reverseOrderTimestamp);
        return row;
    }
}
```
It’s convenient to use **TableOutputFormat** since it manages the creation of an HTable instance for us, which otherwise we would do in the `mapper’s setup()` method (along with a call to close() in the `cleanup()` method). `TableOutputFormat also disables the HTable auto-flush feature`, so that `calls to put() are buffered for greater efficiency`.

```shell
$ hbase HBaseTemperatureImporter input/ncdc/all
```

#### Load distribution

Watch for the phenomenon where an import walks in lockstep through the table, with all clients(PS: as in Example 20-3, the Mappers) in concert pounding one of the table’s regions (and thus, a single node), then moving on to the next, and so on, rather than evenly distributing the load over all regions. This is usually brought on by some interaction between sorted input and how the splitter works. `Randomizing the ordering of your row keys prior to insertion may help`. In our example, given the distribution of stationid values and how TextInputFormat makes splits(PS: as in Example 20-3, HashPartitioner is used by default, hence results in even distributed insertion), the upload should be sufficiently distributed.  

`If a table is new, it will have only one region, and all updates will be to this single region until it splits. This will happen even if row keys are randomly distributed.` This startup phenomenon means uploads run slowly at first, until there are sufficient regions distributed so all cluster members are able to participate in the uploads. `Do not confuse this phenomenon with that noted in the previous paragraph. Both of these problems can be avoided by using bulk loads.`

#### HBase Bulk load
HBase has an efficient facility for bulk loading HBase by writing its internal data format directly into the filesystem from MapReduce. Going this route, it’s possible to load an HBase instance `at rates that are an order of magnitude or more beyond those attainable by writing via the HBase client API`.

Bulk loading is a two-step process.  
* The first step uses **HFileOutputFormat2** to `write HFiles to an HDFS directory using a MapReduce job`.  
Since rows have to be written in order, the job must perform `a total sort` (see “Total Sort” on page 259) of the row keys. The `configureIncrementalLoad()` method of HFileOutputFormat2 does all the necessary configuration for you.  
* The second step of the bulk load involves moving the HFiles from HDFS into an existing HBase table.  
The table can be live during this process. The example code includes a class called **HBaseTemperatureBulkImporter** for loading the observation data using a bulk load.

#### HBase Online Queries
To implement the online query application, we will use the HBase Java API directly.

**Station queries**  
```java
static final byte[] INFO_COLUMNFAMILY = Bytes.toBytes("info");
static final byte[] NAME_QUALIFIER = Bytes.toBytes("name");
static final byte[] LOCATION_QUALIFIER = Bytes.toBytes("location");
static final byte[] DESCRIPTION_QUALIFIER = Bytes.toBytes("description");
public Map<String, String> getStationInfo(HTable table, String stationId)
throws IOException {
    Get get = new Get(Bytes.toBytes(stationId));
    get.addFamily(INFO_COLUMNFAMILY);
    Result res = table.get(get);
    if (res == null) {
        return null;
    }
    Map<String, String> resultMap = new LinkedHashMap<String, String>();
    resultMap.put("name", getValue(res, INFO_COLUMNFAMILY, NAME_QUALIFIER));
    resultMap.put("location", getValue(res, INFO_COLUMNFAMILY,
        LOCATION_QUALIFIER));
    resultMap.put("description", getValue(res, INFO_COLUMNFAMILY,
        DESCRIPTION_QUALIFIER));
    return resultMap;
}
private static String getValue(Result res, byte[] cf, byte[] qualifier) {
    byte[] value = res.getValue(cf, qualifier);
    return value == null? "": Bytes.toString(value);
}
```
We can already see how there is a need for utility functions when using HBase. `There are an increasing number of abstractions being built atop HBase to deal with this low-level interaction`, but it’s important to understand how this works and how storage choices make a difference.

`One of the strengths of HBase over a relational database is that you don’t have to specify all the columns up front`. So, if each station now has at least these three attributes but there are hundreds of optional ones, `in the future we can just insert them without modifying the schema`. (Our application’s reading and writing code would, of course, need to be changed. The example code might change in this case to looping through Result rather than grabbing each value explicitly.)

**Observation queries**  
Queries of the observations table take the form of a station ID, a start time, and a maximum number of rows to return.
```java
public class HBaseTemperatureQuery extends Configured implements Tool {
    static final byte[] DATA_COLUMNFAMILY = Bytes.toBytes("data");
    static final byte[] AIRTEMP_QUALIFIER = Bytes.toBytes("airtemp");
    public NavigableMap<Long, Integer> getStationObservations(HTable table,
        String stationId, long maxStamp, int maxCount) throws IOException {
        byte[] startRow = RowKeyConverter.makeObservationRowKey(stationId, maxStamp);
        NavigableMap<Long, Integer> resultMap = new TreeMap<Long, Integer>();
        Scan scan = new Scan(startRow);
        scan.addColumn(DATA_COLUMNFAMILY, AIRTEMP_QUALIFIER);
        ResultScanner scanner = table.getScanner(scan);
        try {
            Result res;
            int count = 0;
            while ((res = scanner.next()) != null && count++ < maxCount) {
                byte[] row = res.getRow();
                byte[] value = res.getValue(DATA_COLUMNFAMILY, AIRTEMP_QUALIFIER);
                Long stamp = Long.MAX_VALUE -
                    Bytes.toLong(row, row.length - Bytes.SIZEOF_LONG, Bytes.SIZEOF_LONG);
                Integer temp = Bytes.toInt(value);
                resultMap.put(stamp, temp);
            }
        } finally {
            scanner.close();
        }
        return resultMap;
    }
    public int run(String[] args) throws IOException {
        if (args.length != 1) {
            System.err.println("Usage: HBaseTemperatureQuery <station_id>");
            return -1;
        }
        HTable table = new HTable(HBaseConfiguration.create(getConf()), "observations");
        try {
            NavigableMap<Long, Integer> observations =
            getStationObservations(table, args[0], Long.MAX_VALUE, 10).descendingMap();
            for (Map.Entry<Long, Integer> observation : observations.entrySet()) {
            // Print the date, time, and temperature
                System.out.printf("%1$tF %1$tR\t%2$s\n", observation.getKey(),
                    observation.getValue());
            }
            return 0;
        } finally {
            table.close();
        }
    }
    public static void main(String[] args) throws Exception {
        int exitCode = ToolRunner.run(HBaseConfiguration.create(),
            new HBaseTemperatureQuery(), args);
        System.exit(exitCode);
    }
}
```

```shell
$ hbase HBaseTemperatureQuery 011990-99999
1902-12-31 20:00 -106
1902-12-31 13:00 -83
1902-12-30 20:00 -78
...
```

If the observations were stored with the actual timestamps(not in reverse order), we would be able to get only the oldest observations for a given offset and limit efficiently. Getting the newest would mean getting all of the rows and then grabbing the newest off the end. It’s much more efficient to get the first n rows, then exit the scanner (this is sometimes called an “earlyout” scenario).

HBase 0.98 added the ability to do reverse scans, which means it is now possible to store observations in chronological order and scan backward from a given starting row. `Reverse scans are a few percent slower than forward scans`. To reverse a scan, call setReversed(true) on the Scan object before starting the scan.

### HBase Versus RDBMS
Strictly speaking, an RDBMS is a database that follows [Codd’s 12 rules].

Here is a synopsis of how the typical RDBMS scaling story runs. The following list presumes a successful growing service:  
* Initial public launch  
Move from local workstation to a shared, remotely hosted MySQL instance with a well-defined schema.
* Service becomes more popular; too many reads hitting the database  
Add **memcached** to cache common queries. Reads are now no longer strictly ACID; cached data must expire.
* Service continues to grow in popularity; too many writes hitting the database  
Scale MySQL vertically by buying a `beefed-up server` with 16 cores, 128 GB of RAM, and banks of 15k RPM hard drives. Costly.
* New features increase query complexity; now we have too many joins  
Denormalize your data to reduce joins. (That’s not what they taught me in DBA school!)
* Rising popularity swamps the server; things are too slow  
Stop doing any server-side computations.  
* Some queries are still too slow  
Periodically prematerialize the most complex queries, and try to stop joining in most cases.  
* Reads are OK, but writes are getting slower and slower  
Drop secondary indexes and triggers (no indexes?).   

At this point, there are no clear solutions for how to solve your scaling problems. In any case, `you’ll need to begin to scale horizontally`. You can attempt to build some type of `partitioning on your largest tables`, or look into some of the commercial solutions that provide `multiple master capabilities`.  

Countless applications, businesses, and websites have successfully achieved scalable, fault-tolerant, and distributed data systems built on top of RDBMSs and are likely using many of the previous strategies. But what you end up with is something that is no longer a true RDBMS, sacrificing features and conveniences for compromises and complexities. `Any form of slave replication or external caching introduces weak consistency into your now denormalized data`. `The inefficiency of joins and secondary indexes means almost all queries become primary key lookups`. `A multiwriter setup likely means no real joins at all`, and `distributed transactions are a nightmare`. There’s now `an incredibly complex network topology to manage with an entirely separate cluster for caching`. Even with this system and the compromises made, you will still worry about your primary master crashing and the daunting possibility of having 10 times the data and 10 times the load in a few months.

**Enter HBase, which has the following characteristics**:  
* No real indexes  
Rows are stored sequentially, as are the columns within each row. Therefore, no issues with index bloat, and insert performance is independent of table size.  
* Automatic partitioning  
As your tables grow, they will automatically be split into regions and distributed across all available nodes.
* Scale linearly and automatically with new nodes  
Add a node, point it to the existing cluster, and run the regionserver. `Regions will automatically rebalance`, and load will spread evenly.
* Commodity hardware  
Clusters are built on $1,000–$5,000 nodes rather than $50,000 nodes. RDBMSs are I/O hungry, requiring more costly hardware.
* Fault tolerance  
Lots of nodes means each is relatively insignificant. No need to worry about individual node downtime.  
* Batch processing  
MapReduce integration allows fully parallel, distributed jobs against your data with locality awareness.  

### HBase Praxis
HBase’s use of HDFS is very different from how it’s used by MapReduce. In MapReduce, generally, HDFS files are opened with their content streamed through a map task and then closed.` In HBase, datafiles are opened on cluster startup and kept open so that we avoid paying the costs associated with opening files on each access`. Because of this, HBase tends to see issues not normally encountered by MapReduce clients:  
* Running out of file descriptors  
Because we keep files open, on a loaded cluster it doesn’t take long before we run into system- and Hadoop-imposed limits.  
`The default limit on the number of file descriptors per process is 1,024. When we exceed the filesystem ulimit, we’ll see the complaint about “Too many open files” in logs`, but often we’ll first see indeterminate behavior in HBase. The fix requires increasing the file descriptor ulimit count; 10,240 is a common setting. Consult the HBase Reference Guide for how to increase the ulimit on your cluster.
* Running out of datanode threads  
Similarly, the Hadoop datanode has an upper bound on the number of threads it can run at any one time. Hadoop 1 had a low default of 256 for this setting (dfs.datanode.max.xcievers), which would cause HBase to behave erratically. Hadoop 2 increased the default to 4,096, so you are much less likely to see a problem for recent versions of HBase (which only run on Hadoop 2 and later). You can change the setting by configuring `dfs.datanode.max.transfer.threads` (the new name for this property) in hdfs-site.xml

HBase runs a web server on the master to present a view on the state of your running cluster. By default, it listens on port 60010.  

Hadoop has a metrics system that can be used to emit vitals over a period to a context (this is covered in “Metrics and JMX” on page 331). Enabling Hadoop metrics, and in particular tying them to Ganglia or emitting them via JMX, will give you views on what is happening on your cluster, both currently and in the recent past. HBase also adds metrics of its own—request rates, counts of vitals, resources used. See the file `hadoopmetrics2-hbase.properties` under the HBase conf directory.

At StumbleUpon, the first production feature deployed on HBase was keeping counters for the stumbleupon.com frontend. Counters were previously kept in MySQL, but the rate of change was such that drops were frequent, and the load imposed by the counter writes was such that web designers self imposed limits on what was counted. Using the incrementColumnValue() method on HTable, counters can be incremented many thousands of times a second.  

## Chapter 21. ZooKeeper
ZooKeeper also has the following characteristics:  
1. ZooKeeper is simple  
ZooKeeper is, at its core, a `stripped-down filesystem` that exposes a few simple operations and `some extra abstractions`, such as ordering and notifications.   
2. ZooKeeper is expressive  
The ZooKeeper primitives are a rich set of building blocks that can be used to build a large class of `coordination data structures and protocols`. Examples include distributed queues, distributed locks, and leader election among a group of peers.  
3. ZooKeeper is highly available   
4. ZooKeeper facilitates loosely coupled interactions  
ZooKeeper interactions support participants that do not need to know about one another. For example, ZooKeeper can be used as a rendezvous mechanism so that processes that otherwise don’t know of each other’s existence (or network details) can discover and interact with one another. `Coordinating parties may not even be contemporaneous`, since one process may leave a message in ZooKeeper that is read by another after the first has shut down.   
5. ZooKeeper is a library  
ZooKeeper provides an open source, shared repository of implementations and recipes of `common coordination patterns`. Individual programmers are spared the burden of writing common protocols themselves (which is often difficult to get right). Over time, the community can add to and improve the libraries, which is to everyone’s benefit.   
6. ZooKeeper is highly performant, too.   
At Yahoo!, where it was created, the throughput for a ZooKeeper cluster has been benchmarked at over 10,000 operations per second for write-dominant workloads generated by hundreds of clients. For workloads where reads dominate, which is the norm, the throughput is several times higher.

### Installing and Running ZooKeeper

```shell
$ tar -xzvf zookeeper-x.y.z.tar.gz -C /usr/local
# add following settings to environment variables
$ export ZOOKEEPER_HOME=/usr/local/zookeeper-x.y.z
$ export PATH=$PATH:$ZOOKEEPER_HOME/bin
```

Before running the ZooKeeper service, we need to set up a configuration file. The configuration file is conventionally called `zoo.cfg` and placed in the $ZOOKEEPER_HOME/conf subdirectory or in the directory defined by the ZOOCFGDIR environment variable, if set). Here’s an example:  
```properties
tickTime=2000
dataDir=/Users/tom/zookeeper
clientPort=2181
```

This is a standard Java properties file, and the three properties defined in this example are the minimum required for running ZooKeeper in standalone mode. Briefly, tickTime is the basic time unit in ZooKeeper (specified in milliseconds), dataDir is the local filesystem location where ZooKeeper stores persistent data, and clientPort is the port ZooKeeper listens on for client connections (2181 is a common choice).

With a suitable configuration defined, we are now ready to start a local ZooKeeper server:
```shell
$ zkServer.sh start
```
To check whether ZooKeeper is running, send the ruok command (“Are you OK?”) to the client port using nc (telnet works, too):
```shell
$ echo ruok | nc localhost 2181
imok
```
That’s ZooKeeper saying, “I’m OK.”

Table 21-1 lists the commands, known as the “four-letter words,” for managing ZooKeeper.  

1. `mntr`  
Lists server statistics in Java properties format, suitable as a source for monitoring systems such as Ganglia and Nagios.
2. ZooKeeper exposes statistics via JMX.  
3. There are also monitoring tools and recipes in the src/contrib directory of the distribution.
4. From version 3.5.0 of ZooKeeper, there is an inbuilt web server for providing the same information as the four-letter words. Visit http://localhost:8080/commands for a list of commands.

One way of understanding ZooKeeper is to `think of it as providing a high-availability filesystem`. It doesn’t have files and directories, but a unified concept of a node, called a **znode**, that `acts both as a container of data (like a file) and a container of other znodes` (like a directory). `Znodes form a hierarchical namespace`. For example, a natural way to build a membership list is to create a parent znode with the name of the group and child znodes with the names of the group members (servers)

```html
-- /zoo
    |-- /zoo/duck
    |-- /zoo/goat
    |-- /zoo/cow
```

```java
public class ConnectionWatcher implements Watcher {
        private static final int SESSION_TIMEOUT = 5000;
        protected ZooKeeper zk;
        private CountDownLatch connectedSignal = new CountDownLatch(1);
        public void connect(String hosts) throws IOException, InterruptedException {
                zk = new ZooKeeper(hosts, SESSION_TIMEOUT, this);
                connectedSignal.await();
        }
        @Override
        public void process(WatchedEvent event) {
                if (event.getState() == KeeperState.SyncConnected) {
                        connectedSignal.countDown();
                }
        }
        public void close() throws InterruptedException {
                zk.close();
        }
}
```

```java
public class CreateGroup extends ConnectionWatcher {
        public void create(String groupName) throws KeeperException,
        InterruptedException {
                String path = "/" + groupName;
                String createdPath = zk.create(path, null/*data*/, Ids.OPEN_ACL_UNSAFE,
                        CreateMode.PERSISTENT);
                System.out.println("Created " + createdPath);
        }

        public static void main(String[] args) throws Exception {
                CreateGroup createGroup = new CreateGroup();
                createGroup.connect(args[0]);
                createGroup.create(args[1]);
                createGroup.close();
        }
}
```
When the main() method is run, it creates a CreateGroup instance and then calls its connect() method. This method instantiates a new **ZooKeeper** object, which is the central class of the client API and the one that maintains the connection between the client and the ZooKeeper service. The constructor takes three arguments:  
1. the host address (and optional port, which defaults to 2181) of the ZooKeeper service  
2. the second is the session timeout in milliseconds (which we set to 5 seconds)
3. an instance of a **Watcher** object.  
`The Watcher object receives callbacks from ZooKeeper to inform it of various events`. In this scenario, CreateGroup is a Watcher, so we pass this to the ZooKeeper constructor.

When a ZooKeeper instance is created, it starts a thread to connect to the ZooKeeper service. The call to the constructor returns immediately, so it is important to wait for the connection to be established before using the ZooKeeper object. We make use of Java’s CountDownLatch class (in the java.util.concurrent package) to block until the ZooKeeper instance is ready. This is where the Watcher comes in. The Watcher interface has a single method:  
```java
public void process(WatchedEvent event); 
```
When the client has connected to ZooKeeper, the Watcher receives a call to its process() method with an event indicating that it has connected.

The create() method. In this method, we create a new ZooKeeper znode using the create() method on the ZooKeeper instance. The arguments it takes are the path (represented by a string), the contents of the znode (a byte array null here), an access control list (or ACL for short, which here is completely open, allowing any client to read from or write to the znode), and the nature of the znode to be created.  

`Znodes may be ephemeral or persistent`. An ephemeral znode will be deleted by the ZooKeeper service when the client that created it disconnects, either explicitly or because the client terminates for whatever reason. A persistent znode, on the other hand, is not deleted when the client disconnects. We want the znode representing a group to live longer than the lifetime of the program that creates it, so we create a persistent znode.

```shell
$ export CLASSPATH=ch21-zk/target/classes/:$ZOOKEEPER_HOME/*:\
$ZOOKEEPER_HOME/lib/*:$ZOOKEEPER_HOME/conf
$ java CreateGroup localhost zoo
Created /zoo
```

```java
public class JoinGroup extends ConnectionWatcher {
        public void join(String groupName, String memberName) throws KeeperException,
        InterruptedException {
                String path = "/" + groupName + "/" + memberName;
                String createdPath = zk.create(path, null/*data*/, Ids.OPEN_ACL_UNSAFE,
                        CreateMode.EPHEMERAL);
                System.out.println("Created " + createdPath);
        }
        public static void main(String[] args) throws Exception {
                JoinGroup joinGroup = new JoinGroup();
                joinGroup.connect(args[0]);
                joinGroup.join(args[1], args[2]);
                // stay alive until process is killed or thread is interrupted
                Thread.sleep(Long.MAX_VALUE);
        }
}

public class ListGroup extends ConnectionWatcher {
        public void list(String groupName) throws KeeperException,
        InterruptedException {
                String path = "/" + groupName;
                try {
                        List<String> children = zk.getChildren(path, false);
                        if (children.isEmpty()) {
                                System.out.printf("No members in group %s\n", groupName);
                                System.exit(1);
                        }
                        for (String child : children) {
                                System.out.println(child);
                        }
                } catch (KeeperException.NoNodeException e) {
                        System.out.printf("Group %s does not exist\n", groupName);
                        System.exit(1);
                }
        }
        public static void main(String[] args) throws Exception {
                ListGroup listGroup = new ListGroup();
                listGroup.connect(args[0]);
                listGroup.list(args[1]);
                listGroup.close();
        }
}
```

In the list() method, we call getChildren() with a znode path and `a watch flag` to retrieve a list of child paths for the znode, which we print out. `Placing a watch on a znode causes the registered Watcher to be triggered if the znode changes state`. Although we’re not using it here, watching a znode’s children would permit a program to get notifications of members joining or leaving the group, or of the group being deleted.

```shell
$ java ListGroup localhost zoo
No members in group zoo

$ java JoinGroup localhost zoo duck &
$ java JoinGroup localhost zoo cow &
$ java JoinGroup localhost zoo goat &
$ goat_pid=$!

$ java ListGroup localhost zoo
goat
duck
cow

$ kill $goat_pid
$ java ListGroup localhost zoo
duck
cow
```

```shell
$ zkCli.sh -server localhost ls /zoo
[cow, duck]
```

`ZooKeeper will delete a znode only if the version number specified is the same as the version number of the znode it is trying to delete` — an optimistic locking mechanism that allows clients to detect conflicts over znode modification. You can bypass the version check, however, by using a version number of –1 to delete the znode regardless of its version number.  
```java
zk.delete(path, -1);
```

`There is no recursive delete operation in ZooKeeper`, so you have to delete child znodes before parents.

`Znodes are referenced by paths`, which in ZooKeeper are represented as slash-delimited Unicode character strings, `like filesystem paths in Unix`. Paths must be absolute, so they must begin with a slash character. Furthermore, they are canonical, which means that each path has a single representation, and so paths do not undergo resolution. In ZooKeeper, “.” does not have this special meaning and is actually illegal as a path component(neither does ".."). The string `“zookeeper” is a reserved word` and may not be used as a path component. In particular, ZooKeeper uses the /zookeeper subtree to store management information, such as information on quotas.  

### The ZooKeeper Service
#### Zookeeper Data Model
ZooKeeper maintains a hierarchical tree of nodes called znodes. `A znode stores data and has an associated ACL`. ZooKeeper is designed for coordination (which typically uses small datafiles), not high-volume data storage, so there is `a limit of 1 MB` on the amount of data that may be stored in any znode. 

`Data access(read/write) is atomic`.  

ZooKeeper does not support an append operation.

Znodes have some properties that are very useful for building distributed applications.
1. Ephemeral znodes  
An ephemeral znode may not have children, not even ephemeral ones.  
Even though `ephemeral nodes are tied to a client session`, they are visible to all clients(subject to their ACL policies, of course).  
2. Sequence numbers   
A sequential znode is given a sequence number by ZooKeeper as a part of its name. If a znode is created with the sequential flag set, then the value of `a monotonically increasing counter` (maintained by the parent znode)(PS: may not at same incremental interval) is appended to its name.  
Sequence numbers can be used to `impose a global ordering` on events in a distributed system and may be used by the client to infer the ordering. In A Lock Service, you will learn how to `use sequential znodes to build a shared lock`.  
3. Watch  
Watches allow clients to `get notifications` when a znode changes in some way. Watches are set by operations on the ZooKeeper service and are triggered by other operations on the service.   
Watchers are triggered only once.(PS: need to register the same again for merely 1 more notification, so on and so forth).  
In A Configuration Service demonstrating how to use watches to update configuration across a cluster

#### Zookeeper operations

**Table 21-2. Operations in the ZooKeeper service**  

Operation                           |Description
-------------------------------|---------------------------------------------------------------------------------------------------------------------
create                                 |Creates a znode (the parent znode must already exist)
delete                                 |Deletes a znode (the znode must not have any children)
exists                                  |Tests whether a znode exists and retrieves its metadata
getACL, setACL                   |Gets/sets the ACL for a znode
getChildren                         |Gets a list of the children of a znode
getData, setData                |Gets/sets the data associated with a znode
sync                                    |Synchronizes a client’s view of a znode with ZooKeeper

Update operations in ZooKeeper are conditional. A `delete` or `setData` operation has to specify the `version number` of the znode that is being updated (which is found from a previous exists call). If the version number does not match, the update will fail. `Updates are a nonblocking operation`, so a client that loses an update (because another process updated the znode in the meantime) can decide whether to try again or take some other action, and it can do so without blocking the progress of any other process.

Although ZooKeeper can be viewed as a filesystem, there are some filesystem primitives that it does away with `in the name of simplicity`. Because files are small and are written and read in their entirety, there is `no need to provide open, close, or seek operations`.  

The sync operation is not like fsync() in POSIX filesystems. As mentioned earlier, writes in ZooKeeper are atomic, and a successful write operation is guaranteed to have been written to persistent storage on `a majority of ZooKeeper servers`. However, `it is permissible for reads to lag the latest state of the ZooKeeper service, and the sync operation exists to allow a client to bring itself up to date`.

* Multiupdate  
`multi`, that batches together multiple primitive operations into a single unit that either succeeds or fails in its entirety.

There are two core language bindings for ZooKeeper clients, one for Java and one for C; there are also contrib bindings for Perl, Python, and REST clients. For each binding, there is a choice between performing operations `synchronously` or `asynchronously`.  
```java
// synchronous API
public Stat exists(String path, Watcher watcher) throws KeeperException, InterruptedException
// Asynchronous API
public void exists(String path, Watcher watcher, StatCallback cb, Object ctx)
```
In the Java API, all the asynchronous methods have void return types, since the result of the operation is conveyed `via a callback`.

**SHOULD I USE THE SYNCHRONOUS OR ASYNCHRONOUS API?**   
Both APIs offer the same functionality, so the one you use is `largely a matter of style`. The asynchronous API is appropriate if you have an `event-driven programming model`, for example.  
`The asynchronous API allows you to pipeline requests, which in some scenarios can offer better throughput`.(PS: a bit like CompletionService) Imagine that you want to read a large batch of znodes and process them independently. Using the synchronous API, each read would block until it returned, whereas with the asynchronous API, you can fire off all the asynchronous reads very quickly and process the responses in a separate thread as they come back.

* Watch triggers  
The read operations exists, getChildren, and getData may have watches set on them, and the watches are triggered by write operations: create, delete, and setData. `ACL operations do not participate in watches`.  

![hadoop_zookeeper_watch_triggers_img_1]   

To discover which children have changed after a NodeChildrenChanged event, you need to call getChildren again to retrieve the new list of children. Similarly, to discover the new data for a NodeDataChanged event, you need to call getData. `In both of these cases, the state of the znodes may have changed between receiving the watch event and performing the read operation`, so you should bear this in mind when writing applications.

* ACLs  
There are a few authentication schemes that ZooKeeper provides:
1. digest  
The client is authenticated by a username and password.
2. sasl  
The client is authenticated using Kerberos.
3. ip  
The client is authenticated by its IP address.

In addition, ZooKeeper has a pluggable authentication mechanism, which makes it possible `to integrate third-party authentication systems` if needed.  

#### Zookeeper Implementation
The ZooKeeper service can run in two modes.   
1. In standalone mode, there is a single ZooKeeper server, which is useful for testing due to its simplicity (it can even be embedded in unit tests) but provides no guarantees of high availability or resilience.  
2. replicated mode  
In production, ZooKeeper runs in replicated mode on a cluster of machines called an ensemble. ZooKeeper achieves high availability through replication, and can provide a service as long as `a majority of` the machines in the ensemble are up.

Conceptually, ZooKeeper is very simple: `all it has to do is ensure that every modification to the tree of znodes is replicated to a majority of the ensemble`. If a minority of the machines fail, then a minimum of one machine will survive with the latest state. The other remaining replicas will eventually catch up with this state.

ZooKeeper uses a protocol called **Zab** that runs in two phases, which may be repeated indefinitely:  
1. Phase 1: Leader election  
The machines in an ensemble go through a process of electing a distinguished member, called the leader. The other machines are termed followers. This phase is finished once `a majority (or quorum) of followers have synchronized their state with the leader`. 
2. Phase 2: Atomic broadcast   
All write requests are forwarded to `the leader, which broadcasts the update to the followers`. When `a majority have persisted the change`, the leader commits the update, and the client gets a response saying the update succeeded. The protocol for achieving consensus is designed to be atomic, so a change either succeeds or fails. `It resembles a two-phase commit`.

**DOES ZOOKEEPER USE PAXOS?** NO.  
Google’s Chubby Lock Service, which shares similar goals with ZooKeeper, is based on Paxos.

If the leader fails, the remaining machines hold another leader election and continue as before with the new leader. If the old leader later recovers, it then starts as a follower.  

`Leader election is very fast`.

All machines in the ensemble `write updates to disk before updating their in-memory copies of the znode tree`.  

`Read requests may be serviced from any machine, and because they involve only a lookup from memory, they are very fast`.

#### Zookeeper Consistency
The terms “leader” and “follower” for the machines in an ensemble are apt because they make the point that `a follower may lag the leader by a number of updates`. This is a consequence of the fact that `only a majority and not all members of the ensemble need to have persisted a change before it is committed`.

`Every update` made to the znode tree is given `a globally unique identifier`, called a zxid (which stands for `“ZooKeeper transaction ID”`). `Updates are ordered`, so if zxid z1 is less than z2, then z1 happened before z2, according to ZooKeeper (which is the single authority on ordering in the distributed system).

![hadoop_zookeeper_consistency_img_1]  
**Figure 21-2. Reads are satisfied by followers, whereas writes are committed by the leader**  

*The following guarantees for data consistency flow from ZooKeeper’s design*:  
1. Sequential consistency  
Updates `from any particular client` are applied in the order that they are sent. This means that if a client updates the znode z to the value a, and in a later operation, it updates z to the value b, then no client will ever see z with value a after it has seen it with value b (if no other updates are made to z).  
2. Atomicity  
3. Single system image  
A client will see the same view of the system, regardless of the server it connects to. This means that if a client connects to a new server `during the same session`, it will not see an older state of the system than the one it saw with the previous server. When a server fails and a client tries to connect to another in the ensemble, `a server that is behind the one that failed will not accept connections from the client until it has caught up with the failed server`.  
4. Durability  
Once an update has succeeded, it will persist and will not be undone. This means updates will survive server failures.  
5. Timeliness  
`The lag in any client’s view of the system is bounded`, so it will not be out of date by more than some multiple of tens of seconds. This means that rather than allow a client to see data that is very stale, `a server will shut down, forcing the client to switch to a more up-to-date server`.

For performance reasons, `reads are satisfied from a ZooKeeper server’s memory and do not participate in the global ordering of writes`. This property can lead to the appearance of inconsistent ZooKeeper states from clients that communicate through a mechanism outside ZooKeeper: for example, client A updates znode z from a to a’, A tells B to read z, and B reads the value of z as a, not a’. This is perfectly compatible with the guarantees that ZooKeeper makes (the condition that it does not promise is called `“simultaneously consistent cross-client views”`). To prevent this condition from happening, B should call sync on z before reading z’s value. The sync operation forces the ZooKeeper server to which B is connected to “catch up” with the leader, so that when B reads z’s value, it will be the one that A set (or a later value).

Slightly confusingly, the sync operation is available only as an asynchronous call. This is because you don’t need to wait for it to return, since `ZooKeeper guarantees that any subsequent operation will happen after the sync completes on the server, even if the operation is issued before the sync completes`.(PS: that means for operation sequence sync(); getData(), getData() will get value after sync )

#### ZooKeeper Session
A ZooKeeper client is configured with the list of servers in the ensemble. On startup, it tries to connect to one of the servers in the list. If the connection fails, it tries another server in the list, and so on, until it either successfully connects to one of them or fails because all ZooKeeper servers are unavailable.  

Once a connection has been made with a ZooKeeper server, the server creates a new `session` for the client. A **session** has `a timeout period that is decided on by the application that creates it`. If the server hasn’t received a request within the timeout period, it may expire the session. 

Sessions are kept alive by the client `sending ping requests` (also known as **heartbeats**) whenever the session is idle for longer than a certain period. (by the ZooKeeper client library).

Failover to another ZooKeeper server is handled automatically by the `ZooKeeper client`, and crucially, sessions (and associated ephemeral znodes) are still valid after another server takes over from the failed one.

Also, if the application tries to perform an operation while the client is reconnecting to another server, the operation will fail. This underlines the importance of handling connection loss exceptions in real-world ZooKeeper applications.

##### ZooKeeper Time
1. tick time  
the fundamental period of time in ZooKeeper and is used by servers in the ensemble to define the schedule on which their interactions run. Other settings are defined in terms of tick time, or are at least constrained by it.  
The session timeout, for example, may not be less than 2 ticks or more than 20. If you attempt to set a session timeout outside this range, it will be modified to fall within the range.  
A common tick time setting is 2 seconds (2,000 milliseconds). This translates to an allowable session timeout of between 4 and 40 seconds.  
2.  session timeout  
`Every session is given a unique identity` and password by the server, and if these are passed to ZooKeeper while a connection is being made, it is possible to `recover a session` (as long as it hasn’t expired).  
`As a general rule, the larger the ZooKeeper ensemble, the larger the session timeout should be`. Connection timeouts, read timeouts, and ping periods are all defined internally as a function of the number of servers in the ensemble, so as the ensemble grows, these periods decrease. Consider increasing the timeout if you experience frequent connection loss.

##### ZooKeeper States

![hadoop_zookeeper_client_state_img_1]   

```java
// ZooKeeper object
public States getState()
```

A newly constructed ZooKeeper instance is in the CONNECTING state while it tries to establish a connection with the ZooKeeper service. Once a connection is established, it goes into the CONNECTED state.

The ZooKeeper instance may transition to a third state, CLOSED, if either the close() method is called or the session times out, as indicated by a KeeperState of type Expired.

### Building Applications with ZooKeeper
#### A Configuration Service
At the simplest level, ZooKeeper can act as a highly available store for configuration, allowing application participants to retrieve or update configuration files. Using ZooKeeper watches, it is possible to create an active configuration service, where interested clients are notified of changes in configuration.

#### The Resilient ZooKeeper Application
Every ZooKeeper operation in the Java API declares two types of exception in its throws clause: **InterruptedException** and **KeeperException**.

A **KeeperException** is thrown if the ZooKeeper server signals an error or if there is a communication problem with the server. For different error cases, there are various subclasses of KeeperException. Every subclass of KeeperException has a corresponding code with information about the type of error. For example, for KeeperException.NoNodeException, the code is KeeperException.Code.NONODE (an enum value).

**KeeperExceptions fall into three broad categories**  
1. State exceptions  
A state exception occurs when the operation fails because it cannot be applied to the znode tree.
2. Recoverable exceptions  
Recoverable exceptions are those from which the application can `recover within the same ZooKeeper session`. A recoverable exception is manifested by KeeperException.ConnectionLossException, which means that the connection to ZooKeeper has been lost. ZooKeeper will try to reconnect, and in most cases the reconnection will succeed and ensure that the session is intact.   
The program needs a way of detecting whether its update was applied by encoding information in the znode’s pathname or its data.  
3. Unrecoverable exceptions   
In some cases, the ZooKeeper session becomes invalid — perhaps because of a timeout or because the session was closed (both of these scenarios get a KeeperException.SessionExpiredException), or perhaps because authentication failed (KeeperException.AuthFailedException). In any case, all ephemeral nodes associated with the session will be lost, so the application needs to rebuild its state before reconnecting to ZooKeeper.  

#### A Lock Service
Distributed locks can be used for leader election in a large distributed system, where the leader is the process that holds the lock at any point in time.

To implement a distributed lock using ZooKeeper, we use sequential znodes to impose an order on the processes vying for the lock. The idea is simple:   
first, designate a lock znode, typically describing the entity being locked on (say, /leader);   
then, clients that want to acquire the lock create `sequential ephemeral znodes` as children of the lock znode. At any point in time, the client with the lowest sequence number holds the lock.  
For example, if two clients create the znodes at /leader/lock-1 and /leader/lock-2 around the same time, then the client that created /leader/lock-1 holds the lock, since its znode has the lowest sequence number. The lock may be released simply by deleting the znode /leader/lock-1; alternatively, if the client process dies, it will be deleted by virtue of being an ephemeral znode. The client that created /leader/lock-2 will then hold the lock because it has the next lowest sequence number. It ensures it will be notified that it has the lock by creating a watch that fires when znodes go away.  

The `ZooKeeper service` is the arbiter of order because it assigns the sequence numbers. 

**The pseudocode for lock acquisition is as follows**:  
1. Create an ephemeral sequential znode named `lock-` under the lock znode, and remember its actual pathname (the return value of the create operation).
2. Get the children of the lock znode and set a watch.
3. If the pathname of the znode created in step 1 has the lowest number of the children returned in step 2, then the lock has been acquired. Exit.
4. Wait for the notification from the watch set in step 2, and go to step 2.

`The “herd effect”` refers to a large number of clients being notified of the same event when only a small number of them can actually proceed.   

In this case, only one client will successfully acquire the lock, and the process of maintaining and sending watch events to all clients causes traffic spikes, which put pressure on the ZooKeeper servers.   

To avoid the herd effect, the condition for notification needs to be refined. The key observation for implementing locks is that `a client needs to be notified only when the child znode with the previous sequence number goes away`, not when any child znode is deleted (or created).

Another problem with the lock algorithm as it stands is that it doesn’t handle the case when `the create operation fails due to connection loss`. Recall that in this case we do not know whether the operation succeeded or failed. Creating a sequential znode is a nonidempotent operation, so we can’t simply retry, because if the first create had succeeded we would have an orphaned znode that would never be deleted (until the client session ended, at least). Deadlock would be the unfortunate result.

By embedding an identifier in the znode name, if it suffers a connection loss, it can check to see whether any of the children of the lock node have its identifier in their names. The client’s session identifier is a long integer that is unique for the ZooKeeper service and therefore ideal for the purpose of identifying a client across connection loss events. `The znode name becomes lock-<sessionId>-<sequenceNumber>`.

`If a client’s ZooKeeper session expires`, the ephemeral znode created by the client will be deleted, effectively relinquishing the lock (or at least forfeiting the client’s turn to acquire the lock). The application using the lock should realize that it no longer holds the lock, clean up its state, and then start again by creating a new lock object and trying to acquire it. `Notice that it is the application that controls this process, not the lock implementation`, since it cannot second-guess how the application needs to clean up its state.

ZooKeeper comes with `a production-quality lock implementation` in Java called **WriteLock** that is very easy for clients to use.

#### More Distributed Data Structures and Protocols
There are many distributed data structures and protocols that can be built with ZooKeeper, such as barriers, queues, and two-phase commit. One interesting thing to note is that these are synchronous protocols, even though we use asynchronous ZooKeeper primitives (such as notifications) to build them.    

The [ZooKeeper website] describes several such data structures and protocols in pseudocode. ZooKeeper comes with implementations of some of these standard recipes (including locks, leader election, and queues); they can be found in the `recipes` directory of the distribution.   

The [Apache Curator project] also provides an extensive set of ZooKeeper recipes, as well as a simplified ZooKeeper client.

[BookKeeper] is a highly available and reliable logging service. It can be used to provide write-ahead logging, which is a common technique for ensuring data integrity in storage systems. In a system using `write-ahead logging`, every write operation is written to the transaction log before it is applied. BookKeeper is a ZooKeeper subproject, and you can find more information on how to use
it, as well as Hedwig, at http://zookeeper.apache.org/bookkeeper/.

**Hedwig** is a topic-based ipublish-subscribe system built on BookKeeper. Thanks to its ZooKeeper underpinnings, Hedwig is a highly available service and guarantees message delivery even if subscribers are offline for extended periods of time.

### ZooKeeper in Production
However, this section is not exhaustive, so you should consult the [ZooKeeper Administrator’s Guide] for detailed, up-to-date instructions, including supported platforms, recommended hardware, maintenance procedures, dynamic reconfiguration (to change the servers in a running ensemble), and configuration properties.

ZooKeeper machines should be located to minimize the impact of machine and network failure. In practice, this means that servers should be spread across racks, power supplies, and switches, so that the failure of any one of these does not cause the ensemble to lose a majority of its servers.

For applications that require `low-latency service` (on the order of a few milliseconds), it is important to run all the servers in an ensemble `in a single data center`. `Some use cases don’t require low-latency responses, however, which makes it feasible to spread servers across data centers (at least two per data center) for extra resilience`. Example applications in this category are `leader election and distributed coarse-grained locking`, both of which have relatively infrequent state changes, so the overhead of a few tens of milliseconds incurred by inter-data-center messages is not significant relative to the overall functioning of the service.

ZooKeeper has the concept of an **observer node**, which is `like a non-voting follower`. Because they do not participate in the vote for consensus during write requests, observers allow a ZooKeeper cluster to` improve read performance without hurting write performance`. Observers can be used to good advantage to allow a ZooKeeper cluster to span data centers without impacting latency as much as regular voting followers. This is achieved by placing the voting members in one data center and observers in the other.

ZooKeeper is a highly available system, and it is critical that it can perform its functions in a timely manner. `Therefore, ZooKeeper should run on machines that are dedicated to ZooKeeper alone`. Having other applications contend for resources can cause ZooKeeper’s performance to degrade significantly.

`Configure ZooKeeper to keep its transaction log on a different disk drive from its snapshots`. By default, both go in the directory specified by the dataDir property, but if you specify a location for dataLogDir, the transaction log will be written there. By having its own dedicated device (not just a partition), a ZooKeeper server can maximize the rate at which it writes log entries to disk, which it `does sequentially without seeking`. `Because all writes go through the leader, write throughput does not scale by adding servers, so it is crucial that writes are as fast as possible`.

#### ZooKeeper Configuration

Configurations for zookeeper servers have two parts:  
1. Each server in the ensemble of ZooKeeper servers has a numeric identifier that is unique within the ensemble and must fall between 1 and 255. The server number is specified in plain text in a file named `myid` in the directory specified by the `dataDir` property.  
2. The ZooKeeper configuration file must include a line for each server, of the form:  
```properties
server.n=hostname:port:port
```
The value of n is replaced by the server number. There are two port settings: the first is the port that followers use to connect to the leader, and the second is used for leader election.   
We also need to give every server all the identities and network locations of the others in the ensemble. Here is a sample configuration for a three-machine replicated ZooKeeper ensemble:   
```properties
tickTime=2000
dataDir=/disk1/zookeeper
dataLogDir=/disk2/zookeeper
clientPort=2181
initLimit=5
syncLimit=2
server.1=zookeeper1:2888:3888
server.2=zookeeper2:2888:3888
server.3=zookeeper3:2888:3888
```

Servers listen on three ports: 2181 for client connections; 2888 for follower connections, if they are the leader; and 3888 for other server connections during the leader election phase. When a ZooKeeper server starts up, it reads the `myid` file to determine which server it is, and then reads the configuration file to determine the ports it should listen on and to discover the network addresses of the other servers in the ensemble.   

Clients connecting to this ZooKeeper ensemble should use zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 as the host string in the constructor for the ZooKeeper object.

For more in-depth information about ZooKeeper, see [ZooKeeper] by Flavio Junqueira and Benjamin Reed (O’Reilly, 2013).

## Miscellaneous

---
[hadoop_data_locality_img_1]:/resources/img/java/hadoop_data_locality_1.png "Figure 2-2. Data-local (a), rack-local (b), and off-rack (c) map tasks"
[hadoop_data_flow_img_1]:/resources/img/java/hadoop_data_flow_1.png "Figure 2-4. MapReduce data flow with multiple reduce tasks"
[hadoop_data_flow_img_2]:/resources/img/java/hadoop_data_flow_2.png "Figure 3-2. A client reading data from HDFS"
[hadoop_data_flow_img_3]:/resources/img/java/hadoop_data_flow_3.png "Figure 3-4. A client writing data to HDFS"
[hadoop_yarn_layout_img_1]:/resources/img/java/hadoop_yarn_layout_1.png "Figure 4-1. YARN applications"
[hadoop_data_flow_img_4]:/resources/img/java/hadoop_data_flow_4.png "Figure 4-2. How YARN runs an application"
[hadoop-jvm-compressor-benchmark-1]:https://github.com/ning/jvm-compressor-benchmark "jvm compressor benchmark"
[hadoop_writable_class_hierarchy_img_1]:/resources/img/java/hadoop_writable_class_hierarchy_1.png "Figure 5-1. Writable class hierarchy"
[hadoop_apache_thrift_1]:http://thrift.apache.org/ "Apache Thrift"
[hadoop_google_protocol_buffers_1]:https://code.google.com/p/protobuf/ "Google Protocol Buffers"
[hadoop_sequence_file_structure_img_1]:/resources/img/java/hadoop_sequence_file_structure_1.png "Figure 5-2. The internal structure of a sequence file with no compression and with record compression"
[hadoop_sequence_file_structure_img_2]:/resources/img/java/hadoop_sequence_file_structure_2.png "Figure 5-3. The internal structure of a sequence file with block compression"
[hadoop_storage_row_vs_column_img_1]:/resources/img/java/hadoop_storage_row_vs_column_1.png "Figure 5-4. Row-oriented versus column-oriented storage"
[hadoop_mr_flow_img_1]:/resources/img/java/hadoop_mr_flow_1.png "Figure 7-1. How Hadoop runs a MapReduce job"
[hadoop_streaming_img_1]:/resources/img/java/hadoop_streaming_1.png "Figure 7-2. The relationship of the Streaming executable to the node manager and the task container"
[hadoop_shuffle_process_img_1]:/resources/img/java/hadoop_shuffle_process_1.png "Figure 7-4. Shuffle and sort in MapReduce"
[hadoop_stream_mr_data_flow_img_1]:/resources/img/java/hadoop_stream_mr_data_flow_1.png "Figure 8-1. Where separators are used in a Streaming MapReduce job"
[hadoop_inputformat_class_hierarchy_img_1]:/resources/img/java/hadoop_inputformat_class_hierarchy_1.png "Figure 8-2. InputFormat class hierarchy"
[hadoop_outputformat_class_hierarchy_img_1]:/resources/img/java/hadoop_outputformat_class_hierarchy_1.png "Figure 8-4. OutputFormat class hierarchy"
[hadoop_mr_join_example_img_1]:/resources/img/java/hadoop_mr_join_example_1.png "Figure 9-2. Inner join of two datasets"
[hadoop_apache_bigtop_1]:http://bigtop.apache.org/ "Apache Bigtop project"
[Hadoop Operations]:http://shop.oreilly.com/product/0636920025085.do "Hadoop Operations A Guide for Developers and Administrators"
[hadoop_network_topology_img_1]:/resources/img/java/hadoop_network_topology_1.png "Figure 10-1. Typical two-level network architecture for a Hadoop cluster"
[hadoop_topology_script_1]:https://wiki.apache.org/hadoop/topology_rack_awareness_scripts "Topology Scripts"
[Hadoop Security]:http://shop.oreilly.com/product/0636920033332.do "Hadoop Security Protecting Your Big Data Platform"
[hadoop_kerberos_img_1]:/resources/img/java/hadoop_kerberos_1.png "Figure 10-2. The three-step Kerberos ticket exchange protocol"
[hadoop_secondary_namenode_checkpoint_img_1]:/resources/img/java/hadoop_secondary_namenode_checkpoint_1.png "Figure 11-1. The checkpointing process"
[hadoop_sqoop_homepage_1]:http://sqoop.apache.org/ "Apache Sqoop"
[hadoop_clob_blob_storage_img_1]:/resources/img/java/hadoop_clob_blob_storage_1.png "Figure 15-3. Large objects are usually held in a separate area of storage; the main row storage contains indirect references to the large objects"
[Apache Sqoop Cookbook]:http://shop.oreilly.com/product/0636920029519.do "Apache Sqoop Cookbook Unlocking Hadoop for Your Relational Database"
[Flume Download Page]:http://flume.apache.org/download.html "Flume Download Page"
[Flume User Guide]:http://flume.apache.org/FlumeUserGuide.html "Flume User Guide"
[hadoop_flume_tier_img_1]:/resources/img/java/hadoop_flume_tier_1.png "Figure 14-3. Using a second agent tier to aggregate Flume events from the first tier"
[hadoop_flume_tier_load_balance_img_1]:/resources/img/java/hadoop_flume_tier_load_balance_1.png "Figure 14-6. Load balancing between two agents"
[Flume Developer Guide]:http://flume.apache.org/FlumeDeveloperGuide.html "Flume Developer Guide"
[Using Flume]:http://shop.oreilly.com/product/0636920030348.do "Using Flume Flexible, Scalable, and Reliable Data Streaming"
[Hadoop Application Architectures]:http://shop.oreilly.com/product/0636920033196.do "Hadoop Application Architectures Designing Real-World Big Data Applications"
[Apache Hive Download]:http://hive.apache.org/downloads.html "Apache Hive Download"
[hadoop_hive_services_img_1]:/resources/img/java/hadoop_hive_services_1.png "Figure 17-1. Hive architecture"
[Hue]:http://gethue.com/ "Hue Query. Explore. Repeat. Hue is an open source smart Analytics Workbench."
[hadoop_hive_metastore_configuration_img_1]:/resources/img/java/hadoop_hive_metastore_configuration_1.png "Figure 17-2. Metastore configurations"
[Apache Impala]:http://impala.apache.org/ "Apache Impala"
[hadoop_hive_udaf_flow_img_1]:/resources/img/java/hadoop_hive_udaf_flow_1.png "Figure 17-3. Data flow with partial results for a UDAF"
[Programming Hive]:http://shop.oreilly.com/product/0636920023555.do "Programming Hive Data Warehouse and Query Language for Hadoop"
[Bigtable: A Distributed Storage System for Structured Data,]:http://research.google.com/archive/bigtable.html "Bigtable: A Distributed Storage System for Structured Data"  
[hadoop_hbase_data_model_img_1]:/resources/img/java/hadoop_hbase_data_model_1.png "Figure 20-1. The HBase data model, illustrated for a table storing photos"
[HBase Reference Guide]:http://hbase.apache.org/book.html "HBase Reference Guide"
[hadoop_hbase_implementation_img_1]:/resources/img/java/hadoop_hbase_implementation_1.png "Figure 20-2. HBase cluster members"
[Apache HBase Download]: http://www.apache.org/dyn/closer.cgi/hbase/ "Apache HBase Download"
[Codd’s 12 rules]:https://en.wikipedia.org/wiki/Codd%27s_12_rules "Codd’s 12 rules"
[Apache HBase ™ Reference Guide]:http://hbase.apache.org/book.html "Apache HBase ™ Reference Guide"
[HBase: The Definitive Guide]:http://shop.oreilly.com/product/0636920014348.do "HBase: The Definitive Guide Random Access to Your Planet-Size Data"
[HBase in Action]:https://www.manning.com/books/hbase-in-action "HBase in Action"
[hadoop_zookeeper_watch_triggers_img_1]:/resources/img/java/hadoop_zookeeper_watch_triggers_1.png "Table 21-3. Watch creation operations and their corresponding triggers"
[hadoop_zookeeper_consistency_img_1]:/resources/img/java/hadoop_zookeeper_consistency_1.png "Figure 21-2. Reads are satisfied by followers, whereas writes are committed by the leader"
[hadoop_zookeeper_client_state_img_1]:/resources/img/java/hadoop_zookeeper_client_state_1.png "Figure 21-3. ZooKeeper state transitions"
[Apache Curator project]:http://curator.apache.org/ "Welcome to Apache Curator"
[ZooKeeper website]:http://zookeeper.apache.org/ "Apache ZooKeeper"
[BookKeeper]:http://zookeeper.apache.org/bookkeeper/ "BookKeeper"
[ZooKeeper Administrator’s Guide]:http://zookeeper.apache.org/doc/current/zookeeperAdmin.html "ZooKeeper Administrator's Guide"
[ZooKeeper]:http://shop.oreilly.com/product/0636920028901.do "ZooKeeper Distributed Process Coordination"
