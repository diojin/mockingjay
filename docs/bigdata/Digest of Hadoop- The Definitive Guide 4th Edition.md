# 		Digestion of Hadoop- The Definitive Guide, 4th Edition
##							Tom White				
---
## Indexes
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
        + [Task Execution](#task-execution)
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
* [Miscellaneous](#miscellaneous)

## 1. Meet Hadoop
The approach taken by MapReduce may seem like a brute-force approach. The premise is that the `entire dataset—or at least a good portion of it—`can be processed for each query. But this is its power. MapReduce is a batch query processor, and the ability to run an ad hoc query against your whole dataset and get the results in a reasonable time is transformative.

For all its strengths, MapReduce is fundamentally a batch processing system, and is not suitable for interactive analysis. You can’t run a query and get results back in a few seconds or less. 

**YARN** (which stands for Yet Another Resource Negotiator) in Hadoop 2. YARN is a cluster resource management system, which allows any distributed program (not just MapReduce) to run on data in a Hadoop cluster.

In the last few years, there has been a flowering of different processing patterns that work with Hadoop. Here is a sample:  
* Interactive SQL  
By dispensing with MapReduce and using a `distributed query engine` that uses dedicated “always on” daemons (like **Impala**) or container reuse (like **Hive on Tez**), it’s possible to achieve low-latency responses for SQL queries on Hadoop while still scaling up to large dataset sizes.  
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

Hadoop works well on unstructured or semi-structured data because it is designed to interpret the data at processing time (so called schema-on-read). This provides flexibility and avoids the costly data loading phase of an RDBMS, since in Hadoop it is just a file copy.

Relational data is often normalized to retain its integrity and remove redundancy. Normalization poses problems for Hadoop processing because it makes reading a record a nonlocal operation, and one of the central assumptions that Hadoop makes is that it is possible to perform (high-speed) streaming reads and writes.

#### Grid Computing
The high-performance computing (HPC) and grid computing communities have been doing large-scale data processing for years, using such application program interfaces (APIs) as the **Message Passing Interface (MPI)**. Broadly, the approach in HPC is to distribute the work across a cluster of machines, which access a shared filesystem, hosted by a storage area network (SAN). `This works well for predominantly compute-intensive jobs`, but `it becomes a problem when nodes need to access larger data volumes (hundreds of gigabytes, the point at which Hadoop really starts to shine), since the network bandwidth is the bottleneck and compute nodes become idle`.

Hadoop tries to co-locate the data with the compute nodes, so data access is fast because it is local. This feature, known as **data locality**, is at the heart of data processing in Hadoop and is the reason for its good performance. Recognizing that network bandwidth is the most precious resource in a data center environment (it is easy to saturate network links by copying data around), Hadoop goes to great lengths to conserve it by explicitly modeling network topology. Notice that this arrangement does not preclude high-CPU analyses in Hadoop.

**MPI** gives great control to programmers, `but it requires that they explicitly handle the mechanics of the data flow, exposed via low-level C routines and constructs such as sockets, as well as the higher-level algorithms for the analyses`. Processing in Hadoop operates only at the higher level: the programmer thinks in terms of the data model (such as key-value pairs for MapReduce), while the data flow remains implicit.

Distributed processing frameworks like MapReduce spare the programmer from having to think about failure, since the implementation detects failed tasks and reschedules replacements on machines that are healthy. MapReduce is able to do this because it is a **shared-nothing architecture**, meaning that tasks have no dependence on one other. (This is a slight oversimplification, since the output from mappers is fed to the reducers, but this is under the control of the MapReduce system; in this case, `it needs to take more care rerunning a failed reducer than rerunning a failed map, because it has to make sure it can retrieve the necessary map outputs and, if not, regenerate them by running the relevant maps again`.) So from the programmer’s point of view, the order in which the tasks run doesn’t matter. By contrast, MPI programs have to explicitly manage their own checkpointing and recovery, which gives more control to the programmer but makes them more difficult to write.

#### Volunteer Computing
SETI, the Search for Extra-Terrestrial Intelligence, runs a project called SETI@home in which volunteers donate CPU time from their otherwise idle computers to analyze radio telescope data for signs of intelligent life outside Earth.

The SETI@home problem is very CPU-intensive, which makes it suitable for running on hundreds of thousands of computers across the world7 because the time to transfer the work unit is dwarfed by the time to run the computation on it.  

MapReduce is designed to run jobs that last minutes or hours on trusted, dedicated hardware running in a single data center with very high aggregate bandwidth interconnects.

## 2. MapReduce
MapReduce is a programming model for data processing.

### Data Flow  
1. Hadoop divides the input to a MapReduce job into `fixed-size pieces` called input splits, or just **splits**. Hadoop creates one map task for each split, which runs the user-defined map function for each record in the split.   
2. Map tasks write their output to the `local disk`, not to HDFS.  
3. Reduce tasks don’t have the advantage of data locality; the input to a single reduce task is normally the output from all mappers. 
    1. In the present example, we have a single reduce task that is fed by all of the map tasks. Therefore, the `sorted map outputs` have to be transferred across the network to the node where the reduce task is running, where they are `merged` and then passed to the user-defined reduce function.   
    2. When there are multiple reducers, the map tasks `partition` their output, each creating one partition for each reduce task. There can be many keys (and their associated values) in each partition, but `the records for any given key are all in a single partition`. The partitioning can be controlled by a user-defined partitioning function, but normally the default partitioner—which buckets keys using a hash function—works very well.  
4. The output of the reduce is normally `stored in HDFS` for reliability. As explained in Chapter 3, for each HDFS block of the reduce output, the first replica is stored on the local node, with other replicas being stored on off-rack nodes for reliability. 


Having many splits means the time taken to process each split is small compared to the time to process the whole input. So if we are processing the splits in parallel, the processing is better `load balanced` when the splits are small, since a faster machine will be able to process proportionally more splits over the course of the job than a slower machine.

On the other hand, if splits are too small, the overhead of managing the splits and map task creation begins to dominate the total job execution time. For most jobs, `a good split size tends to be the size of an HDFS block, which is 128 MB by default`, although this can be changed for the cluster (for all newly created files) or specified when each file is created.

Hadoop does its best to run the map task on a node where the input data resides in HDFS, because it doesn’t use valuable cluster bandwidth. This is called the **data locality optimization**. Sometimes, however, all the nodes hosting the HDFS block replicas for a map task’s input split are running other map tasks, so the job scheduler will look for a free map slot on a node in the same **rack** as one of the blocks. Very occasionally even this is not possible, so an off-rack node is used, which results in an inter-rack network transfer. The three possibilities are illustrated in Figure 2-2.
![hadoop_data_locality_img_1]  

Map tasks write their output to the local disk, not to HDFS. Why is this? `Map output is intermediate output`: it’s processed by reduce tasks to produce the final output, and `once the job is complete, the map output can be thrown away. So, storing it in HDFS with replication would be overkill`. If the node running the map task fails before the map output has been consumed by the reduce task, then Hadoop will automatically `rerun the map task on another node` to re-create the map output.

The data flow for the general case of multiple reduce tasks is illustrated in Figure 2-4. This diagram makes it clear why the data flow between map and reduce tasks is colloquially known as “the shuffle,” as each reduce task is fed by many map tasks. `The shuffle` is more complicated than this diagram suggests, and tuning it can have a big impact on job execution time  
![hadoop_data_flow_img_1]  

Finally, it’s also possible to have zero reduce tasks. This can be appropriate when you don’t need the shuffle because the processing can be carried out entirely in parallel (a few examples are discussed in “NLineInputFormat” on page 234). In this case, the only off-node data transfer is when the map tasks write to HDFS (see Figure 2-5).  

### Combiner Functions
Many MapReduce jobs are limited by the bandwidth available on the cluster, so it pays to minimize the data transferred between map and reduce tasks.

Hadoop allows the user to specify a combiner function to be `run on the map output`, and the combiner function’s output forms `the input to the reduce function`. Because the combiner function is an optimization, Hadoop does not provide a guarantee of how many times it will call it for a particular map output record, if at all. In other words, calling the combiner function zero, one, or many times should produce the same output from the reducer.  

it can help cut down the amount of data shuffled between the mappers and the reducers

### Hadoop Streaming
Hadoop Streaming uses Unix standard streams as the interface between Hadoop and your program, so you can use any language that can read standard input and write to standard output to write your MapReduce program.

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
Hadoop doesn’t require expensive, highly reliable hardware. It’s designed to run on clusters of commodity hardware (commonly available hardware that can be obtained from multiple vendors) for which the chance of node failure across the cluster is high, at least for large clusters. HDFS is designed to carry on working without a noticeable interruption to the user in the face of such failure.  
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

HDFS blocks are large compared to disk blocks, and the reason is to minimize the cost of seeks. If the block is large enough, the time it takes to transfer the data from the disk can be significantly longer than the time to seek to the start of the block. Thus, transferring a large file made of multiple blocks operates at the disk transfer rate.

A quick calculation shows that if the seek time is around 10 ms and the transfer rate is 100 MB/s, `to make the seek time 1% of the transfer time`, we need to make the block size around 100 MB. The default is actually 128 MB, although many HDFS installations use larger block sizes. `This figure will continue to be revised upward as transfer speeds grow with new generations of disk drives`.

This argument shouldn’t be taken too far, however. Map tasks in MapReduce normally operate on one block at a time, so if you have too few tasks (fewer than nodes in the cluster), your jobs will run slower than they could otherwise.


#### Namenodes and Datanodes
An HDFS cluster has two types of nodes operating in a master−worker pattern: a namenode (the master) and a number of datanodes (workers)
```hadoop
hdfs fsck / -files -blocks
```
The namenode manages the filesystem namespace.It maintains the filesystem tree and the metadata for all the files and directories in the tree. This information is stored persistently on the local disk in the form of two files: the namespace image and the edit log. The namenode also knows the datanodes on which all the blocks for a given file are located; however, it does not store block locations persistently, because this information is reconstructed from datanodes when the system starts.

Datanodes are the workhorses of the filesystem. They store and retrieve blocks when they are told to (by clients or the namenode), and `they report back to the namenode periodically with lists of blocks that they are storing`.

Without the namenode, the filesystem cannot be used. In fact, if the machine running the namenode were obliterated(destroyed), all the files on the filesystem would be lost since there would be no way of knowing how to reconstruct the files from the blocks on the datanodes. For this reason, it is important to make the namenode resilient to failure, and Hadoop provides two mechanisms for this. 
1. The first way is to back up the files that make up the persistent state of the filesystem metadata.  
Hadoop can be configured so that the namenode writes its persistent state to multiple filesystems. `These writes are synchronous and atomic`. The usual configuration choice is to write to local disk as well as a remote NFS mount.  
2. It is also possible to run a secondary namenode, which despite its name does not act as a namenode.  
`Its main role is to periodically merge the namespace image with the edit log` to prevent the edit log from becoming too large. The secondary namenode usually runs on a separate physical machine because `it requires plenty of CPU and as much memory as the namenode to perform the merge`. It keeps a copy of the merged namespace image, which can be used in the event of the namenode failing. However, the state of the secondary namenode lags that of the primary, so in the event of total failure of the primary, data loss is almost certain. The usual course of action in this case is to copy the namenode’s metadata files that are on NFS to the secondary and run it as the new primary. 
3. Note that `it is possible to run a hot standby namenode` instead of a secondary, as discussed in “HDFS High Availability” on page 48.  

#### Block Caching 
Normally a datanode reads blocks from disk, but for frequently accessed files the blocks may be explicitly cached `in the datanode’s memory`, `in an off-heap block cache`. By default, a block is cached in only one datanode’s memory, although the number is configurable on a per-file basis. Job schedulers (for MapReduce, Spark, and other frameworks) can take advantage of cached blocks by running tasks on the datanode where a block is cached, for increased read performance. A small lookup table used in a join is a good candidate for caching, for example.  

Users or applications instruct the namenode which files to cache (and for how long) by adding a cache directive to a cache pool. Cache pools are an administrative grouping for managing cache permissions and resource usage.

#### HDFS Federation
Under federation, each namenode manages a namespace volume, which is made up of the metadata for the namespace, and a block pool containing all the blocks for the files in the namespace. `Namespace volumes are independent of each other`, which means namenodes do not communicate with one another, and furthermore the failure of one namenode does not affect the availability of the namespaces managed by other namenodes.` Block pool storage is not partitioned`, however, so datanodes register with each namenode in the cluster and store blocks from multiple block pools.

#### HDFS High Availability
The combination of replicating namenode metadata on multiple filesystems and using the secondary namenode to create checkpoints protects against data loss, but it does not provide high availability of the filesystem. The namenode is still a single point of failure (SPOF).

To recover from a failed namenode in this situation, an administrator starts a new primary namenode with one of the filesystem metadata replicas and configures datanodes and clients to use this new namenode. The new namenode is not able to serve requests until it has  
1. loaded its namespace image into memory
2. replayed its edit log
3. received enough block reports from the datanodes to leave safe mode.   
On large clusters with many files and blocks, the time it takes for a namenode to start from cold can be 30 minutes or more.

Hadoop 2 remedied this situation by adding support for HDFS high availability (HA). In this implementation, there are `a pair of namenodes in an active-standby configuration`. In the event of the failure of the active namenode, the standby takes over its duties to continue servicing client requests without a significant interruption. A few architectural changes are needed to allow this to happen:  
* The namenodes must use `highly available shared storage to share the edit log`. When a standby namenode comes up, it reads up to the end of the shared edit log to synchronize its state with the active namenode, and then `continues to read new entries` as they are written by the active namenode. 
* Datanodes must `send block reports to both namenodes` because the `block mappings are stored in a namenode’s memory, and not on disk`. 
* Clients must be configured to handle namenode failover, using a mechanism that is transparent to users. 
* The secondary namenode’s role is subsumed by the standby, which takes periodic checkpoints of the active namenode’s namespace. 

There are two choices for the highly available shared storage: an NFS filer, or a **quorum journal manager (QJM)**. The QJM is a dedicated HDFS implementation, designed for the `sole purpose of providing a highly available edit log`, and is the recommended choice for most HDFS installations. The QJM runs as `a group of journal nodes, and each edit must be written to a majority of the journal nodes`.

If the active namenode fails, the standby can take over very quickly (`in a few tens of seconds`) because it has the latest state available in memory: both the latest edit log entries and an up-to-date block mapping. `The actual observed failover time` will be longer in practice (`around a minute or so`), because the system needs to be conservative in deciding that the active namenode has failed.

##### Failover and fencing
The transition from the active namenode to the standby is managed by a new entity in the system called the failover controller.

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
$ hadoop $ hadoop fs -ls /input
Found 2 items
-rw-r--r--   2 hadoop supergroup         24 2017-10-17 21:32 /input/test.txt
drwxr-xr-x   - hadoop supergroup          0 2017-10-26 11:29 /input/test1

```
The first column shows the file mode. The second column is the replication factor of the file. The entry in this column is empty for directories because `the concept of replication does not apply to them—directories are treated as metadata and stored by the namenode, not the datanodes`. The third and fourth columns show the file owner and group. The fifth column is the size of the file in bytes, or `zero for directories`. The sixth and seventh columns are the last modified date and time. Finally, the eighth column is the name of the file or directory.

#### File Permissions in HDFS
HDFS has a permissions model for files and directories that is much like the POSIX model. There are three types of permission: the read permission (r), the write permission (w), and the execute permission (x). The read permission is required to read files or list the contents of a directory. The write permission is required to write a file or, for a directory, to create or delete files or directories in it. The execute permission is ignored for a file because you can’t execute a file on HDFS (unlike POSIX), and for a directory this permission is required to access its children.

Each file and directory has an owner, a group, and a mode. The mode is made up of the permissions for the user who is the owner, the permissions for the users who are members of the group, and the permissions for users who are neither the owners nor members of the group.  

`By default, Hadoop runs with security disabled`, which means that a client’s identity is not authenticated. Because clients are remote, it is possible for a client to become an arbitrary user simply by creating an account of that name on the remote system. This is not possible if security is turned on. Either way, it is worthwhile having permissions enabled (as they are by default; see the `dfs.permissions.enabled` property) to avoid accidental modification or deletion of substantial parts of the filesystem, either by users or by automated tools or programs.

When permissions checking is enabled, the owner permissions are checked if the client’s username matches the owner, and the group permissions are checked if the client is a member of the group; otherwise, the other permissions are checked.

### Hadoop Filesystems
Hadoop has an abstract notion of filesystems, of which HDFS is just one implementation.  

The Java abstract class `org.apache.hadoop.fs.FileSystem` represents the client interface to a filesystem in Hadoop, and there are several concrete implementations

Hadoop provides many interfaces to its filesystems, and it generally uses the `URI scheme` to pick the correct filesystem instance to communicate with.   
For example, the filesystem shell that we met in the previous section operates with all Hadoop filesystems. To list the files in the root directory of the local filesystem, type:   
```shell
$ hadoop fs -ls file:///
```

**Interfaces**:  
1. HTTP  
By exposing its filesystem interface as a Java API, Hadoop makes it awkward for non- Java applications to access HDFS. The `HTTP REST API` exposed by the WebHDFS protocol makes it easier for other languages to interact with HDFS. Note that the HTTP interface is slower than the native Java client, so should be avoided for very large data transfers if possible.  
There are two ways of accessing HDFS over HTTP: directly, where the HDFS daemons serve HTTP requests to clients; and via a proxy (or proxies), which accesses HDFS on the client’s behalf using the usual DistributedFileSystem(Hadoop’s distributed filesystem. HDFS is designed to work efficiently in conjunction with MapReduce.) API.  
It’s common to use a proxy for transfers between Hadoop clusters located in different data centers, or when accessing a Hadoop cluster running in the cloud from an external network.
2. C  
libhdfs and libwebhdfs
3. NFS  
It is possible to mount HDFS on a local client’s filesystem using Hadoop’s NFSv3 gateway.
4. FUSE  
Filesystem in Userspace (FUSE) allows filesystems that are implemented in user space to be integrated as Unix filesystems.

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
            // IOUtils.copyBytes(in, System.out, 4096, false);
    } finally {
        IOUtils.closeStream(in);
    }
}
```

#### Reading Data Using the FileSystem API
A file in a Hadoop filesystem is represented by a `Hadoop Path object` (and not a java.io.File object, since its semantics are too closely tied to the local filesystem). You can think of a Path as a Hadoop filesystem URI, such as hdfs://localhost/user/ tom/quangle.txt.

```java
// hadoop FileSystemCat hdfs://localhost/user/tom/quangle.txt
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
Finally, bear in mind that calling seek() is a relatively expensive operation and should be done sparingly.

#### Writing Data

```java
// FileSystem
public FSDataOutputStream create(Path f) throws IOException;
public FSDataOutputStream append(Path f) throws IOException;
// There’s also an overloaded method for passing a callback interface, 
// Progressable, so your application can be notified of the progress of the 
// data being written to the datanodes
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

The **FileStatus** class encapsulates filesystem metadata for files and directories, including file length, block size, replication, modification time, ownership, and permission information. The method getFileStatus() on FileSystem provides a way of getting a FileStatus object for a single file or directory  

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

Blocks are read in order, with the DFSInputStream opening new connections to datanodes as the client reads through the stream. It will also call the namenode to retrieve the datanode locations for the next batch of blocks as needed

During reading, if the DFSInputStream encounters an error while communicating with a datanode, it will try the next closest one for that block. It will also remember datanodes that have failed so that it doesn’t needlessly retry them for later blocks. The DFSInput Stream also verifies checksums for the data transferred to it from the datanode. If a corrupted block is found, the DFSInputStream attempts to read a replica of the block from another datanode; it also `reports the corrupted block to the namenode`.

#### Network Topology and Hadoop
What does it mean for two nodes in a local network to be “close” to each other? The idea is to use the bandwidth between two nodes as a measure of distance.

Rather than measuring bandwidth between nodes, which can be difficult to do in practice (it requires a quiet cluster, and the number of pairs of nodes in a cluster grows as the square of the number of nodes), Hadoop takes a simple approach in which the network is represented as a tree and the distance between two nodes is the sum of their distances to their closest common ancestor. Levels in the tree are not predefined, but it is common to have levels that correspond to the **data center**, the **rack**, and the node that a process is running on.  
The idea is that the bandwidth available for each of the following scenarios becomes progressively(gradually) less:  
* Processes on the same node
* Different nodes on the same rack
* Nodes on different racks in the same data center
* Nodes in different data centers  
At the time of this writing, Hadoop is not suited for running across data centers.

Finally, it is important to realize that Hadoop cannot magically discover your network topology for you. By default, though, it assumes that the network is flat—a singlelevel hierarchy—or in other words, that all nodes are on a single rack in a single data center.

#### Anatomy of a File Write
![hadoop_data_flow_img_3]  

The DistributedFileSystem returns an FSDataOutputStream for the client to start writing data to. Just as in the read case, FSDataOutputStream wraps a DFSOutputStream, which handles communication with the datanodes and namenode.

As the client writes data (step 3), the DFSOutputStream splits it into packets, which it writes to an internal queue called the **data queue**. The data queue is consumed by the **DataStreamer**, which is responsible for asking the namenode to allocate new blocks by picking a list of suitable datanodes to store the replicas. The list of datanodes forms a pipeline, and here we’ll assume the replication level is three, so there are three nodes in the pipeline. The DataStreamer streams the packets to the first datanode in the pipeline, which stores each packet and forwards it to the second datanode in the pipeline. Similarly, the second datanode stores the packet and forwards it to the third (and last) datanode in the pipeline (step 4).  
The DFSOutputStream also maintains an internal queue of packets that are waiting to be acknowledged by datanodes, called the **ack queue**. A packet is removed from the ack queue only when it has been acknowledged by all the datanodes in the pipeline (step 5).  
`If any datanode fails while data is being written to it`, then the following actions are taken, which are transparent to the client writing the data. First, the pipeline is closed, and `any packets in the ack queue are added to the front of the data queue` so that datanodes that are downstream from the failed node will not miss any packets. The current block on the good datanodes is given a new identity, which is communicated to the namenode, so that the partial block on `the failed datanode will be deleted` if the failed datanode recovers later on. The failed datanode is removed from the pipeline, and `a new pipeline is constructed from the two good datanodes`. The remainder of the block’s data is written to the good datanodes in the pipeline. The namenode notices that the block is under-replicated, and it `arranges for a further replica to be created on another node`. Subsequent blocks are then treated as normal.  
It’s possible, but unlikely, for multiple datanodes to fail while a block is being written. `As long as dfs.namenode.replication.min replicas (which defaults to 1) are written, the write will succeed`, and the block will be asynchronously replicated across the cluster until its target replication factor is reached (dfs.replication, which defaults to 3).  
When the client has finished writing data, it calls close() on the stream (step 6). This action flushes all the remaining packets to the datanode pipeline and waits for acknowledgments before contacting the namenode to signal that the file is complete (step 7). The namenode already knows which blocks the file is made up of (because Data Streamer asks for block allocations), so it only has to wait for blocks to be minimally replicated before returning successfully.  

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

Note that hflush() does not guarantee that the datanodes have written the data to disk, only that it’s in the datanodes’ memory (so in the event of a data center power outage, for example, data could be lost). For this stronger guarantee, use hsync() instead.  
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
distcp is implemented as a MapReduce job where the work of copying is done by the maps that run in parallel across the cluster. There are no reducers. Each file is copied by a single map, and distcp tries to give each map approximately the same amount of data by bucketing files into roughly equal allocations. By default, up to 20 maps are used, but this can be changed by specifying the `-m argument to distcp`

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

There is also a layer of applications that build on the frameworks shown in Figure 4-1. Pig, Hive, and Crunch are all examples of processing frameworks that run on MapReduce, Spark, or Tez (or on all three), and don’t interact with YARN directly.

### Anatomy of a YARN Application Run
YARN provides its core services via two types of long-running daemon: a **resource manager** (one per cluster) to manage the use of resources across the cluster, and **node managers** running on all the nodes in the cluster to launch and monitor containers. A **container** executes an application-specific process with a constrained set of resources (memory, CPU, and so on)  

![hadoop_data_flow_img_4]   

To run an application on YARN, a client contacts the resource manager and asks it to run an **application master** process (step 1 in Figure 4-2). The resource manager then finds a node manager that can `launch the application master in a container` (steps 2a and 2b). Precisely what the application master does once it is running depends on the application. It could simply run a computation in the container it is running in and return the result to the client. Or it could request more containers from the resource managers (step 3), and use them to run a distributed computation (steps 4a and 4b). The latter is what the MapReduce YARN application does, which we’ll look at in more detail in “Anatomy of a MapReduce Job Run” on page 185.  
Notice from Figure 4-2 that `YARN itself does not provide any way for the parts of the application (client, master, process) to communicate with one another`. `Most nontrivial YARN applications use some form of remote communication (such as Hadoop’s RPC layer) to pass status updates and results back to the client`, but these are specific to the application.

#### Resource Requests
YARN has a flexible model for making resource requests. A request for a set of containers can express the amount of computer resources required for each container (memory and CPU), as well as locality constraints for the containers in that request.

In the common case of launching a container to process an HDFS block (to run a map task in MapReduce, say), the application will request a container on one of the nodes hosting the block’s three replicas, or on a node in one of the racks hosting the replicas, or, failing that, on any node in the cluster

A YARN application can make resource requests at any time while it is running. For example, an application can make all of its requests up front, or it can take a more dynamic approach whereby it requests more resources dynamically to meet the changing needs of the application.

Spark takes the first approach, starting a fixed number of executors on the cluster (see “Spark on YARN” on page 571). MapReduce, on the other hand, has two phases: the map task containers are requested up front, but the reduce task containers are not started until later. Also, if any tasks fail, additional containers will be requested so the failed tasks can be rerun.

#### Application Lifespan
The lifespan of a YARN application can vary dramatically, it’s useful to categorize applications in terms of how they map to the jobs that users run.  
1. The simplest case is one application per user job, which is the approach that MapReduce takes.
2. The second model is to run one application per workflow or user session of (possibly unrelated) jobs.  
This approach can be more efficient than the first, since containers can be reused between jobs, and there is also the potential to cache intermediate data between jobs. Spark is an example that uses this model.
3. The third model is a long-running application that is shared by different users.  
Such an application often acts in some kind of coordination role. For example, Apache Slider has a long-running application master for launching other applications on the cluster. This approach is also used by Impala (see “SQL-on-Hadoop Alternatives” on page 484) to provide a proxy application that the Impala daemons communicate with to request cluster resources. The “always on” application master means that users have very lowlatency responses to their queries since the overhead of starting a new application master is avoided.

#### Building YARN Applications
Writing a YARN application from scratch is fairly involved, but in many cases is not necessary, as it is often possible to use an existing application that fits the bill. For example, if you are interested in running a directed acyclic graph (DAG) of jobs, then Spark or Tez is appropriate; or for stream processing, Spark, Samza, or Storm works.

There are a couple of projects that simplify the process of building a YARN application.  
* Apache Slider  
mentioned earlier, makes it possible to run existing distributed applications on YARN. Users can run their own instances of an application (such as HBase) on a cluster, independently of other users, which means that different users can run different versions of the same application. Slider provides controls to change the number of nodes an application is running on, and to suspend then resume a running application. 
* Apache Twill  
is similar to Slider, but in addition provides `a simple programming model` for developing distributed applications on YARN. Twill allows you to define cluster processes as an extension of a Java Runnable, then runs them in YARN containers on the cluster. Twill also provides support for, among other things, `real-time logging` (log events from runnables are streamed back to the client) and `command messages` (sent from the client to runnables).

### YARN Compared to MapReduce 1
The distributed implementation of MapReduce in the original version of Hadoop (version 1 and earlier) is sometimes referred to as “MapReduce 1” to distinguish it from MapReduce 2, the implementation that uses YARN (in Hadoop 2 and later).  

The old and new MapReduce APIs are not the same thing as the MapReduce 1 and MapReduce 2 implementations. All four combinations are supported: both the old and new MapReduce APIs run on both MapReduce 1 and 2.

In MapReduce 1, there are two types of daemon that control the job execution process: a **jobtracker** and one or more **tasktrackers**. The jobtracker coordinates all the jobs run on the system by scheduling tasks to run on tasktrackers. Tasktrackers run tasks and send progress reports to the jobtracker, which keeps a record of the overall progress of each job. If a task fails, the jobtracker can reschedule it on a different tasktracker.

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

The `FIFO Scheduler` has the merit of being simple to understand and not needing any configuration, but it’s `not suitable for shared clusters`. Large applications will use all the resources in a cluster, so each application has to wait its turn. `On a shared cluster it is better to use the Capacity Scheduler or the Fair Scheduler`. Both of these allow longrunning jobs to complete in a timely manner, while still allowing users who are running concurrent smaller ad hoc queries to get results back in a reasonable time.  

With the Capacity Scheduler (ii in Figure 4-3), a separate dedicated queue allows the small job to start as soon as it is submitted, although this is at the cost of overall cluster utilization since the queue capacity is reserved for jobs in that queue (some cluster nodes managed by the dedicate queue are reserved). This means that the large job finishes later than when using the FIFO Scheduler.  

With the Fair Scheduler (iii in Figure 4-3), there is no need to reserve a set amount of capacity, since it will dynamically balance resources between all running jobs. Just after the first (large) job starts, it is the only job running, so it gets all the resources in the cluster. When the second (small) job starts, it is allocated half of the cluster resources so that each job is using its fair share of resources.

The scheduler in use is determined by the setting of `yarn.resourcemanager.scheduler.class`. The Capacity Scheduler is used by default (although the Fair Scheduler is the default in some Hadoop distributions, such as CDH), but this can be changed by setting yarn.resourcemanager.scheduler.class in yarn-site.xml to the fully qualified classname of the scheduler, `org.apache.hadoop.yarn.server.resourcemanager.scheduler.fair.FairScheduler`

Imagine a queue hierarchy that looks like this, which is used in sections below  
```html
root  
├── prod  
└── dev  
    ├── eng  
    └── science  
```

#### Capacity Scheduler Configuration
The Capacity Scheduler allows sharing of a Hadoop cluster along organizational lines, whereby `each organization is allocated a certain capacity of the overall cluster`. Each organization is set up with a dedicated queue that is configured to use a given fraction of the cluster capacity. `Queues may be further divided in hierarchical fashion`, allowing each organization to share its cluster allowance between different groups of users within the organization. `Within a queue, applications are scheduled using FIFO scheduling.`

Capacity Scheduler configuration file, called capacity-scheduler.xml  

A single job does not use more resources than its queue’s capacity. However, if there is more than one job in the queue and there are idle resources available, then the Capacity Scheduler may allocate the spare resources to jobs in the queue, even if that causes the queue’s capacity to be exceeded.7 This behavior is known as **queue elasticity**.  (`yarn.scheduler.capacity.<queue-path>.user-limit-factor` is set to a value larger than 1 (the default))

It is possible to mitigate this by configuring queues with a maximum capacity so that they don’t eat into other queues’ capacities too much. This is at the cost of queue elasticity, of course, so a reasonable trade-off should be found by trial and error. (`yarn.scheduler.capacity.<queue-path>.maximum-capacity`)

##### Queue placement
The way that you specify which queue an application is placed in is specific to the application. For example, in MapReduce, you set the property `mapreduce.job.queuename` to the name of the queue you want to use (the name of queue is the last part of queue path, for example, in example below, prod and eng are OK, but root.dev.eng and dev.eng do not work). If the queue does not exist, then you’ll get an error at submission time. If no queue is specified, applications will be placed in a queue called default.

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

The Fair Scheduler is configured using an allocation file named `fair-scheduler.xml` that is loaded from the classpath. (The name can be changed by setting the property `yarn.scheduler.fair.allocation.file`) In the absence of an allocation file, the Fair Scheduler operates as described earlier: each application is placed in a queue named after the user and queues are created dynamically when users submit their first applications.  

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

Although not shown in this allocation file, queues can be configured with minimum and maximum resources, and a maximum number of running applications. (See the reference page for details.) The minimum resources setting is not a hard limit, but rather is used by the scheduler to prioritize resource allocations. If two queues are below their fair share, then the one that is furthest below its minimum is allocated resources first. The minimum resource setting is also used for preemption, discussed momentarily.

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
Preemption allows the scheduler to kill containers for queues that are running with more than their fair share of resources so that the resources can be allocated to a queue that is under its fair share. Note that preemption reduces overall cluster efficiency, since the terminated containers need to be reexecuted.  

Preemption is enabled globally by setting `yarn.scheduler.fair.preemption` to true. There are two relevant preemption timeout settings: one for minimum share and one for fair share, both specified in seconds. By default, the timeouts are not set, so you need to set at least one to allow containers to be preempted.  
1. minimum share preemption timeout  
If a queue waits for as long as its minimum share preemption timeout without receiving its minimum guaranteed share, then the scheduler may preempt other containers.  
2. fair share preemption timeout  
Likewise, if a queue remains below half of its fair share for as long as the fair share preemption timeout, then the scheduler may preempt other containers.  
#### Delay Scheduling
All the YARN schedulers try to honor locality requests. On a busy cluster, if an application requests a particular node, there is a good chance that other containers are running on it at the time of the request. The obvious course of action is to immediately loosen the locality requirement and allocate a container on the same rack. However, it has been observed in practice that waiting a short time (no more than a few seconds) can dramatically increase the chances of being allocated a container on the requested node, and therefore increase the efficiency of the cluster. This feature is called delay scheduling, and it is supported by both the Capacity Scheduler and the Fair Scheduler.  

Every node manager in a YARN cluster periodically sends a heartbeat request to the resource manager—by default, one per second. Heartbeats carry information about the node manager’s running containers and the resources available for new containers, so each heartbeat is a potential **scheduling opportunity** for an application to run a container.  

For the Capacity Scheduler, delay scheduling is configured by setting `yarn.scheduler.capacity.node-locality-delay` to a positive integer representing the number of scheduling opportunities that it is prepared to miss before loosening the node constraint to match any node in the same rack. 

The Fair Scheduler also uses the number of scheduling opportunities to determine the delay, although it is expressed as a proportion of the cluster size. For example, setting `yarn.scheduler.fair.locality.threshold.node` to 0.5 means that the scheduler should wait until half of the nodes in the cluster have presented scheduling opportunities before accepting another node in the same rack. There is a corresponding property, `yarn.scheduler.fair.locality.threshold.rack`, for setting the threshold before another rack is accepted instead of the one requested.

#### Dominant Resource Fairness
However, when there are multiple resource types in play, things get more complicated. If one user’s application requires lots of CPU but little memory and the other’s requires little CPU and lots of memory, how are these two applications compared?   
The way that the schedulers in YARN address this problem is to look at each user’s dominant resource and use it as a measure of the cluster usage. This approach is called Dominant Resource Fairness, or DRF for short. The idea is best illustrated with a simple example.

Imagine a cluster with a total of 100 CPUs and 10 TB of memory. Application A requests containers of (2 CPUs, 300 GB), and application B requests containers of (6 CPUs, 100 GB). A’s request is (2%, 3%) of the cluster, so memory is dominant since its proportion (3%) is larger than CPU’s (2%). B’s request is (6%, 1%), so CPU is dominant. Since B’s container requests are twice as big in the dominant resource (6% versus 3%), it will be allocated half as many containers under fair sharing. ????

By default DRF is not used, so during resource calculations, only memory is considered and CPU is ignored.

#### YARN Further Reading
This chapter has given a short overview of YARN. For more detail, see Apache Hadoop YARN by Arun C. Murthy et al. (Addison-Wesley, 2014).


## 5. Hadoop I/O

### Data Integrity

A commonly used error-detecting code is CRC-32 (32-bit cyclic redundancy check), which computes a 32-bit integer checksum for input of any size. CRC-32 is used for checksumming in Hadoop’s ChecksumFileSystem, while HDFS uses a more efficient variant called CRC-32C.

HDFS transparently checksums all data written to it and by default verifies checksums when reading data. A separate checksum is created for every `dfs.bytes-per-checksum` bytes of data. The default is 512 bytes, and because a CRC-32C checksum is 4 bytes long, the storage overhead is less than 1%.

Datanodes are responsible for verifying the data they receive before storing the data and its checksum. A client writing data sends it to a pipeline of datanodes (as explained in Chapter 3), and the last datanode in the pipeline verifies the checksum.

When clients read data from datanodes, they verify checksums as well, comparing them with the ones stored at the datanodes. Each datanode keeps a persistent log of checksum verifications, so it knows the last time each of its blocks was verified. When a client successfully verifies a block, it tells the datanode, which updates its log. Keeping statistics such as these is valuable in detecting bad disks.

In addition to block verification on client reads, each datanode runs a DataBlockScanner in a background thread that periodically verifies all the blocks stored on the datanode. This is to guard against corruption due to “bit rot” in the physical storage media. 

Because HDFS stores replicas of blocks, it can “heal” corrupted blocks by copying one of the good replicas to produce a new, uncorrupt replica.
It is possible to disable verification of checksums by passing false to the setVerify Checksum() method on FileSystem before using the open() method to read a file. The same effect is possible from the shell by using the -ignoreCrc option with the -get or the equivalent -copyToLocal command. This feature is useful if you have a corrupt file that you want to inspect so you can decide what to do with it. For example, you might want to see whether it can be salvaged before you delete it.

#### LocalFileSystem
The Hadoop LocalFileSystem performs client-side checksumming. This means that when you write a file called filename, the filesystem client transparently creates a hidden file, `.filename.crc`, in the same directory containing the checksums for each chunk of the file. The chunk size is controlled by the `file.bytes-per-checksum` property, which defaults to 512 bytes.  

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
LZO                 |lzop   |LZO        |.lzo               |No
LZ4                 |N/A    |LZ4        |.lz4               |No
Snappy              |N/A    |Snappy     |.snappy            |No

The different tools have very different compression characteristics.  
* gzip is a generalpurpose compressor and sits in the middle of the space/time trade-off.   
* bzip2 compresses more effectively than gzip, but is slower. bzip2’s decompression speed is faster than its compression speed, but it is still slower than the other formats. 
* LZO, LZ4, and Snappy, on the other hand, all optimize for speed and are around an order of magnitude faster than gzip, but compress less effectively. Snappy and LZ4 are also significantly faster than LZO for decompression.  
* bzip2 is splittable, LZO files are splittable if they have been indexed in a preprocessing step using an indexer tool that comes with the Hadoop LZO libraries

The “Splittable” column in Table 5-1 indicates whether the compression format supports splitting (that is, whether you can seek to any point in the stream and start reading from some point further on). Splittable compression formats are especially suitable for Map‐Reduce

[hadoop-jvm-compressor-benchmark-1]  

A codec is the implementation of a compression-decompression algorithm. In Hadoop, a codec is represented by an implementation of the CompressionCodec interface.  
For large files, you should not use a compression format that does not support splitting on the whole file, because you lose locality and make MapReduce applications very
inefficient.

#### Codecs
**CompressionOutputStream** and **CompressionInputStream** are similar to java.util. zip.DeflaterOutputStream and java.util.zip.DeflaterInputStream, except that both of the former provide the ability to reset their underlying compressor or decompressor. This is important for applications that compress sections of the data stream as separate blocks, such as in a SequenceFile.

**Example 5-1. A program to compress data read from standard input and write it to standard output**   
```java
public class StreamCompressor {
    public static void main(String[] args) throws Exception {
        String codecClassname = args[0];
        Class<?> codecClass = Class.forName(codecClassname);
        Configuration conf = new Configuration();
        CompressionCodec codec = (CompressionCodec)
        ReflectionUtils.newInstance(codecClass, conf);
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
use `io.compression.codecs` configuration property if you have a custom codec that you wish to register

#### Native libraries
For performance, it is preferable to use a native library for compression and decompression.  

The Apache Hadoop binary tarball comes with prebuilt native compression binaries for 64-bit Linux, called libhadoop.so. For other platforms, you will need to compile the libraries yourself, following the BUILDING.txt instructions at the top level of the source tree.  
The native libraries are picked up using the Java system property `java.library.path`. The hadoop script in the etc/hadoop directory sets this property for you, but if you don’t use this script, you will need to set the property in your application.

By default, Hadoop looks for native libraries for the platform it is running on, and loads them automatically if they are found. This means you don’t have to change any configuration settings to use the native libraries. In some circumstances, however, you may wish to disable use of native libraries, such as when you are debugging a compressionrelated problem. You can do this by setting the property `io.native.lib.available` to false, which ensures that the built-in Java equivalents will be used (if they are available).

#### CodecPool
If you are using a native library and you are doing a lot of compression or decompression in your application, consider using CodecPool, which allows you to reuse compressors and decompressors, thereby amortizing the cost of creating these objects.  

**Example 5-3. A program to compress data read from standard input and write it to standard output using a pooled compressor**  
```java
public class PooledStreamCompressor {
    public static void main(String[] args) throws Exception {
        String codecClassname = args[0];
        Class<?> codecClass = Class.forName(codecClassname);
        Configuration conf = new Configuration();
        CompressionCodec codec = (CompressionCodec)
        ReflectionUtils.newInstance(codecClass, conf);
        Compressor compressor = null;
        try {
            compressor = CodecPool.getCompressor(codec);
            CompressionOutputStream out =
            codec.createOutputStream(System.out, compressor);
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

If you are emitting sequence files for your output, you can set the `mapreduce.out put.fileoutputformat.compress.type` property to control the type of compression to use. The default is RECORD, which compresses individual records. Changing this to BLOCK, which compresses groups of records, is recommended because it compresses better

##### Compressing map output
Even if your MapReduce application reads and writes uncompressed data, it may benefit from compressing the intermediate output of the map phase. The map output is written to disk and transferred across the network to the reducer nodes, so by using a fast compressor such as LZO, LZ4, or Snappy, you can get performance gains simply because the volume of data to transfer is reduced.  

mapreduce.map.output.compress, mapreduce.map.output.compress.codec  

```java
Configuration conf = new Configuration();
conf.setBoolean(Job.MAP_OUTPUT_COMPRESS, true);
conf.setClass(Job.MAP_OUTPUT_COMPRESS_CODEC, GzipCodec.class,
CompressionCodec.class);
Job job = new Job(conf);
```

### Serialization
Serialization is the process of turning structured objects into a byte stream for transmission over a network or for writing to persistent storage. Deserialization is the reverse process of turning a byte stream back into a series of structured objects.  

Serialization is used in two quite distinct areas of distributed data processing: for interprocess communication and for persistent storage.  

In Hadoop, interprocess communication between nodes in the system is implemented using remote procedure calls (RPCs). In general, it is desirable that an RPC serialization format is:  
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

**WritableComparator** is a general-purpose implementation of RawComparator for WritableComparable classes. It provides two main functions. First, it provides a default implementation of the raw compare() method that `deserializes the objects to be compared` from the stream and invokes the object compare() method. Second, it acts as a factory for RawComparator instances (that Writable implementations have registered). For example, to obtain a comparator for IntWritable, we just use:  
```java
RawComparator<IntWritable> comparator =
WritableComparator.get(IntWritable.class);

IntWritable w1 = new IntWritable(163);
IntWritable w2 = new IntWritable(67);
assertThat(comparator.compare(w1, w2), greaterThan(0));

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

When it comes to encoding integers, there is a choice between the fixed-length formats (IntWritable and LongWritable) and the variable-length formats (VIntWritable and VLongWritable). The variable-length formats use only a single byte to encode the value if it is small enough (between –112 and 127, inclusive); otherwise, they use the first byte to indicate whether the value is positive or negative, and how many bytes follow. on average, the variable-length encoding will save space. Another advantage of variable-length encodings is that you can switch from VIntWritable to VLongWritable, because their encodings are actually the same.  

##### Text
Text is a Writable for UTF-8 sequences. It can be thought of as the Writable equivalent of java.lang.String.  

The Text class uses an int (with a variable-length encoding) to store the number of bytes in the string encoding, so the maximum value is 2 GB. Furthermore, Text uses standard UTF-8, which makes it potentially easier to interoperate with other tools that understand UTF-8.  

Because of its emphasis on using standard UTF-8, there are some differences between Text and the Java String class. Indexing for the Text class is in terms of position in the encoded byte sequence, but not the Unicode character in the string or the Java char code unit in the string (as how indexing is for String).

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

Another difference from String is that Text is mutable (like all Writable implementations in Hadoop, except NullWritable, which is a singleton).  

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
NullWritable is a special type of Writable, as it has a zero-length serialization. No bytes are written to or read from the stream. It is used as a placeholder; for example, in Map-Reduce, a key or a value can be declared as a NullWritable when you don’t need to use that position, effectively storing a constant empty value. NullWritable can also be useful as a key in a SequenceFile when you want to store a list of values, as opposed to keyvalue pairs. It is an immutable singleton, and the instance can be retrieved by calling NullWritable.get().

##### ObjectWritable and GenericWritable
ObjectWritable is a general-purpose wrapper for the following: Java primitives, String, enum, Writable, null, or arrays of any of these types. It is used in Hadoop RPC to marshal and unmarshal method arguments and return types.  

ObjectWritable is useful when a field can be of more than one type.  

Being a general-purpose mechanism, it wastes a fair amount of space because it writes the classname of the wrapped type every time it is serialized. In cases where the number of types is small and known ahead of time, this can be improved by having a static array of types and using the index into the array as the serialized reference to the type. This is the approach that GenericWritable takes, and you have to subclass it to specify which types to support.

##### Writable collections
The org.apache.hadoop.io package includes six Writable collection types: 
* Array Writable
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

MapWritable is an implementation of java.util.Map<Writable, Writable>, and SortedMapWritable is an implementation of java.util.SortedMap<WritableComparable, Writable>. The type of each key and value field is a part of the serialization format for that field. The type is stored as a single byte that acts as an index into an array of types. The array is populated with the standard types in the org.apache.hadoop.io package, but custom Writable types are accommodated, too, by writing a header that encodes the type array for nonstandard types. As they are implemented, MapWritable and SortedMapWritable use positive byte values for custom types, so a maximum of 127 distinct nonstandard Writable classes can be used in any particular MapWritable or SortedMapWritable instance.  

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
Hadoop has an API for pluggable serialization frameworks. A serialization framework is represented by an implementation of Serialization (in the org.apache.hadoop.io.serializer package). WritableSerialization, for example, is the implementation of Serialization for Writable types.

A Serialization defines a mapping from types to **Serializer** instances (for turning an object into a byte stream) and **Deserializer** instances (for turning a byte stream into an object).  
Set the `io.serializations` property to a comma-separated list of classnames in order to register Serialization implementations. Its default value includes org.apache.ha doop.io.serializer.WritableSerialization and the Avro Specific and Reflect serializations (see “Avro Data Types and Schemas” on page 346), which means that only Writable or Avro objects can be serialized or deserialized out of the box.

Hadoop includes a class called **JavaSerialization** that uses Java Object Serialization. Although it makes it convenient to be able to use standard Java types such as Integer or String in MapReduce programs, Java Object Serialization is not as efficient as Writables, so it’s not worth making this trade-off.

Java Serialization, that is tightly integrated with the language. It looked big and hairy and I thought we needed something lean and mean, where we had precise control over exactly how objects are written and read, since that is central to Hadoop.  
The logic for not using RMI was similar. Effective, high performance inter-process communications are critical to Hadoop. I felt like we’d need to precisely control how things like connections, timeouts and buffers are handled, and RMI gives you little control over those.

##### Serialization IDL
There are a number of other serialization frameworks that approach the problem in a different way: rather than defining types through code, you define them in a languageneutral, declarative fashion, using an interface description language (IDL). The system can then generate types for different languages, which is good for interoperability. They also typically define versioning schemes that make type evolution straightforward.

Apache Thrift [hadoop_apache_thrift_1] and Google Protocol Buffers [hadoop_google_protocol_buffers_1] are both popular serialization frameworks, and both are commonly used as a format for persistent binary data. There is limited support for these as MapReduce formats; however, they are used internally in parts of Hadoop for RPC and data exchange.  

Avro is an IDL-based serialization framework designed to work well with large-scale data processing in Hadoop.

## File-Based Data Structures
For some applications, you need a specialized data structure to hold your data. For doing MapReduce-based processing, putting each blob of binary data into its own file doesn’t scale, so Hadoop developed a number of higher-level containers for these situations.

### SequenceFile
Imagine a logfile where each log record is a new line of text. If you want to log binary types, plain text isn’t a suitable format. Hadoop’s SequenceFile class fits the bill in this situation, providing a persistent data structure for binary key-value pairs. To use it as a logfile format, you would choose a key, such as timestamp represented by a LongWritable, and the value would be a Writable that represents the quantity being logged.

SequenceFiles also work well as containers for smaller files. HDFS and MapReduce are optimized for large files, so packing files into a SequenceFile makes storing and processing the smaller files more efficient

#### Writing a SequenceFile
To create a SequenceFile, use one of its createWriter() static methods, which return a SequenceFile.Writer instance. There are several overloaded versions, but they all require you to specify a stream to write to (either an FSDataOutputStream or a FileSystem and Path pairing), a Configuration object, and the key and value types. Optional arguments include the compression type and codec, a Progressable callback to be informed of write progress, and a Metadata instance to be stored in the SequenceFile header.

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
SequenceFile.Writer has a method called sync() for inserting a sync point at the current position in the stream.

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
            Writable key = (Writable)
            ReflectionUtils.newInstance(reader.getKeyClass(), conf);
            Writable value = (Writable)
            ReflectionUtils.newInstance(reader.getValueClass(), conf);
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

A **sync point** is a point in the stream that can be used to resynchronize with a record boundary if the reader is “lost”—for example, after seeking to an arbitrary position in the stream. Sync points are recorded by SequenceFile.Writer, which inserts a special entry to mark the sync point every few records as a sequence file is being written. Such entries are small enough to incur only a modest storage overhead—less than 1%. Sync points always align with record boundaries.

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
The most powerful way of sorting (and merging) one or more sequence files is to use MapReduce. reducers to use, which determines the number of output partitions. For example, specifying 1 reducer  
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
![hadoop_sequence_file_structure_img_1]  
A sequence file consists of a header followed by one or more records (see Figure 5-2). The first three bytes of a sequence file are the bytes SEQ, which act as a magic number; these are followed by a single byte representing the version number. The header contains other fields, including the names of the key and value classes, compression details, userdefined metadata, and the sync marker. Each file has a randomly generated sync marker.  

The internal format of the records depends on whether compression is enabled, and if it is, whether it is record compression or block compression.  

The format for record compression is almost identical to that for no compression, except the value bytes are compressed using the codec defined in the header.  

![hadoop_sequence_file_structure_img_2]  
Block compression (Figure 5-3) compresses multiple records at once; it is therefore more compact than and should generally be preferred over record compression because it has the opportunity to take advantage of similarities between records. Records are added to a block until it reaches a minimum size in bytes, defined by the io.seqfile.compress.blocksize property; the default is one million bytes. A sync marker is written before the start of every block. The format of a block is a field indicating the number of records in the block, followed by four compressed fields: the key lengths, the keys, the value lengths, and the values.

#### MapFile
A MapFile is a sorted SequenceFile with an index to permit lookups by key. The index is itself a SequenceFile that contains a fraction of the keys in the map (every 128th key, by default). The idea is that the index can be loaded into memory to provide fast lookups from the main data file, which is another SequenceFile containing all the map entries in sorted key order.

MapFile offers a very similar interface to SequenceFile for reading and writing—the main thing to be aware of is that when writing using MapFile.Writer, map entries must be added in order, otherwise an IOException will be thrown.

##### MapFile variants
* SetFile is a specialization of MapFile for storing a set of Writable keys. The keys must be added in sorted order. 
* ArrayFile is a MapFile where the key is an integer representing the index of the element in the array and the value is a Writable value. 
* BloomMapFile is a MapFile that offers a fast version of the get() method, especially for sparsely populated files. The implementation uses a dynamic Bloom filter for testing whether a given key is in the map. The test is very fast because it is inmemory, and it has a nonzero probability of false positives. Only if the test passes (the key is present) is the regular get() method called.

#### Other File Formats and Column-Oriented Formats

**Avro datafiles** are like sequence files in that they are designed for large-scale data processing—they are compact and splittable—but they are portable across different programming languages. Objects stored in Avro datafiles are described by a schema. Avro datafiles are widely supported across components in the Hadoop ecosystem, so they are a good default choice for a binary format.

![hadoop_storage_row_vs_column_img_1]  

Sequence files, map files, and Avro datafiles are all row-oriented file formats, which means that the values for each row are stored contiguously in the file. In a columnoriented format, the rows in a file (or, equivalently, a table in Hive) are broken up into `row splits`, then each split is stored in column-oriented fashion: the values for each row in the first column are stored first, followed by the values for each row in the second column, and so on.  

With row-oriented storage, Lazy deserialization saves some processing cycles by deserializing only the column fields that are accessed, but it can’t avoid the cost of reading each row’s bytes from disk. 

In general, column-oriented formats work well when queries access only a small number of columns in the table. Conversely, roworiented formats are appropriate when a large number of columns of a single row are needed for processing at the same time.

Column-oriented formats need more memory for reading and writing, since they have to buffer a row split in memory, rather than just a single row. Also, it’s not usually possible to control when writes occur (via flush or sync operations), so `column-oriented formats are not suited to streaming writes`, as the current file cannot be recovered if the writer process fails. On the other hand, row-oriented formats like sequence files and Avro datafiles can be read up to the last sync point after a writer failure. It is for this reason that Flume (see Chapter 14) uses row-oriented formats. 

The first column-oriented file format in Hadoop was Hive’s RCFile, short for Record Columnar File. It has since been superseded by Hive’s ORCFile (Optimized Record Columnar File), and Parquet (covered in Chapter 13). `Parquet is a general-purpose columnoriented file format based on Google’s Dremel, and has wide support across Hadoop components`. Avro also has a column-oriented format called Trevni.

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
System properties take priority over properties defined in resource files, This feature is useful for overriding properties on the command line by using 
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

For building MapReduce jobs, you only need to have the hadoop-client dependency, which contains all the Hadoop client-side classes needed to interact with HDFS and MapReduce. For running unit tests, we use junit, and for writing MapReduce tests, we use mrunit. The hadoop-minicluster library contains the “mini-” clusters that are useful for testing with Hadoop clusters running in a single JVM.  

```shell
$ mvn eclipse:eclipse -DdownloadSources=true -DdownloadJavadocs=true
```

#### Managing Configuration
When developing Hadoop applications, it is common to switch between running the application locally and running it on a cluster.

One way to accommodate these variations is to have Hadoop configuration files containing the connection settings for each cluster you run against and specify which one you are using when you run Hadoop applications or tools. As a matter of best practice, it’s recommended to keep these files outside Hadoop’s installation directory tree, as this makes it easy to switch between Hadoop versions without duplicating or losing settings.

Hadoop can be run in one of three modes:  
1. Standalone (or local) mode  
There are no daemons running and everything runs in a single JVM. Standalone mode is suitable for running MapReduce programs during development, since it is easy to test and debug them.  
In standalone mode, there is no further action to take, since the default properties are set for standalone mode and there are no daemons to run.
2. Pseudodistributed mode  
The Hadoop daemons run on the local machine, thus simulating a cluster on a small scale.
3. Fully distributed mode  
The Hadoop daemons run on a cluster of machines.

**Table A-1. Key configuration properties for different modes**  
Component |Property     |Standalone |Pseudodistributed |Fully distributed
----------|-------------|-----------|------------------|-----------------------
Common    |fs.defaultFS |file:/// (default)|hdfs://localhost/ |hdfs://namenode/
HDFS      |dfs.replication |N/A     |1                        |3 (default)
MapReduce |mapreduce.framework.name |local (default) |yarn    |yarn
YARN      |yarn.resourcemanager.hostname |N/A |localhost      |resourcemanager
YARN      |yarn.nodemanager.auxservices  |N/A |mapreduce_shuffle |mapreduce_shuffle

If you do this, you need to set the HADOOP_CONF_DIR environment
variable to the alternative location, or make sure you start the daemons with the --config option:  
```shell
$ start-dfs.sh --config absolute-path-to-config-directory
$ start-yarn.sh --config absolute-path-to-config-directory
$ mr-jobhistory-daemon.sh --config absolute-path-to-config-directory
start historyserver
```

**Pseudodistributed mode configurations**:  
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

The settings in hadoop-localhost.xml point to a namenode and a YARN resource manager both running on localhost:  
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

With this setup, it is easy to use any configuration with the -conf command-line switch. For example, the following command shows a directory listing on the HDFS server running in pseudodistributed mode on localhost:
```shell
$ hadoop fs -conf conf/hadoop-localhost.xml -ls .
```

##### Setting User Identity
The user identity that Hadoop uses for permissions in HDFS is determined by running the whoami command on the client system. Similarly, the group names are derived from the output of running groups on the client system.

If, however, your Hadoop user identity is different from the name of your user account on your client machine, you can explicitly set your Hadoop username by setting the **HADOOP_USER_NAME** environment variable. 

You can also override user group mappings by means of the `hadoop.user.group.static.mapping.overrides` configuration property. For example, `dr.who=;preston=directors,inventors` means that the dr.who user is in no groups, but preston is in the directors and inventors groups.

You can set the user identity that the Hadoop web interfaces run as by setting the `hadoop.http.staticuser.user` property. By default, it is dr.who, which is not a superuser, so system files are not accessible through the web interface.

Tools that come with Hadoop support the -conf option, but it’s straightforward to make your programs (such as programs that run MapReduce jobs) support it, too, using the Tool interface.

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
We make ConfigurationPrinter a subclass of Configured, which is an implementation of the Configurable interface. All implementations of Tool need to implement Configurable (since Tool extends it), and subclassing Configured is often the easiest way to achieve this. The run() method obtains the Configuration using Configura ble’s getConf() method and then iterates over it, printing each property to standard output.

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

A MapDriver can be used to check for zero, one, or more output records, according to the number of times that withOutput() is called. Test ignoresMissingTemperatureRecord() would fail if there were output, since there is no withOutput() called, expecting no output.

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

Now we can run this application against some local files. Hadoop comes with a local job runner, a cut-down version of the MapReduce execution engine for running Map‐Reduce jobs in a single JVM. It’s designed for testing and is very convenient for use in an IDE, since you can run it in a debugger to step through the code in your mapper and reducer. The local job runner is used if mapreduce.framework.name is set to local, which is the default.
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
Hadoop has a set of testing classes, called MiniDFSCluster, MiniMRCluster, and MiniYARNCluster, that provide a programmatic way of creating in-process clusters. Unlike the local job runner, these allow testing against the full HDFS, MapReduce, and YARN machinery. Bear in mind, too, that node managers in a mini-cluster launch separate JVMs to run tasks in, which can make debugging more difficult.  
You can run a mini-cluster from the command line too, with the following:  
```shell
% hadoop jar \
$HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-*-tests.jar \
minicluster
```
Mini-clusters are used extensively in Hadoop’s own automated test suite, but they can be used for testing user code, too. Hadoop’s ClusterMapReduceTestCase abstract class provides a useful base for writing such a test, handles the details of starting and stopping the in-process HDFS and YARN clusters in its setUp() and tearDown() methods, and generates a suitable Configuration object that is set up to work with them. Subclasses need only populate data in HDFS (perhaps by copying from a local file), run a MapReduce job, and confirm the output is as expected. Refer to the MaxTemperatureDriver MiniTest class in the example code that comes with this book for the listing.  

### Running on a Cluster
#### Packaging a Job
For a start, a job’s classes must be packaged into a job JAR file to send to the cluster. Hadoop will find the job JAR automatically by searching for the JAR on the driver’s classpath that contains the class set in the setJarByClass() method (on JobConf or Job). Alternatively, if you want to set an explicit JAR file by its file path, you can use the setJar() method. (The JAR file path may be local or an HDFS file path.)

Creating a job JAR file is conveniently achieved using a build tool such as Ant or Maven.
```shell
$ mvn package -DskipTests
```

If you have a single job per JAR, you can specify the main class to run in the JAR file’s manifest. If the main class is not in the manifest, it must be specified on the command line (as we will see shortly when we run the job). 

Any dependent JAR files can be packaged in a `lib subdirectory` in the job JAR file, although there are other ways to include dependencies, discussed later. Similarly, resource files can be packaged in a `classes subdirectory`.

1. The client classpath  
The user’s client-side classpath set by hadoop jar <jar> is made up of:  
    * The job JAR file
    * Any JAR files in the lib directory of the job JAR file, and the classes directory (if present)
    * The classpath defined by HADOOP_CLASSPATH, if set
if without a job JAR, export HADOOP_CLASSPATH and run hadoop {CLASSNAME}  
```shell
$ export HADOOP_CLASSPATH=target/classes/
$ hadoop v2.MaxTemperatureDriver -conf conf/hadoop-local.xml \
        input/ncdc/micro output
```
2. The task classpath  
On a cluster (including pseudodistributed mode), map and reduce tasks run in separate JVMs, and their classpaths are not controlled by HADOOP_CLASSPATH. HADOOP_CLASSPATH is a client-side setting and only sets the classpath for the driver JVM, which submits the job.  
Instead, the user’s task classpath is comprised of the following:  
* The job JAR file
* Any JAR files contained in the lib directory of the job JAR file, and the classes directory (if present)
* Any files added to the distributed cache using the -libjars option , or the addFileToClassPath() method on DistributedCache (old API), or Job (new API)  
The last option, using the distributed cache, is simplest from a build point of view because dependencies don’t need rebundling in the job JAR. Also, using the distributed cache can mean fewer transfers of JAR files around the cluster, since files may be cached on a node between tasks.  

**Classpath precedence**  
User JAR files are added to the end of both the client classpath and the task classpath, sometimes you need to be able to control the task classpath order so that your classes are picked up first.  
* On the client side  
you can force Hadoop to put the user classpath first in the search order by setting the HADOOP_USER_CLASSPATH_FIRST environment variable to true. 
* For the task classpath  
you can set mapreduce.job.user.classpath.first to true.    
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

Tasks belong to a job, and their IDs are formed by replacing the job prefix of a job ID with a task prefix and adding a suffix to identify the task within the job. For example: `task_1410450250506_0003_m_000003` (000003, the fourth, task IDs are 0-based). The task IDs are created for a job when it is initialized, so they do not necessarily dictate the order in which the tasks will be executed.

Tasks may be executed more than once, due to failure (see “Task Failure” on page 193) or speculative execution (see “Speculative Execution” on page 204), so to identify different instances of a task execution, task attempts are given unique IDs. For example: `attempt_1410450250506_0003_m_000003_0` is the first (0; attempt IDs are 0-based) attempt at running task task_1410450250506_0003_m_000003. Task attempts are allocated during the job run as needed, so their ordering represents the order in which they were created to run.  

#### The MapReduce Web UI
http://resource-manager-host:8088/

##### Job History  
Job history is retained regardless of whether the job was successful.  
Job history files are stored in HDFS by the MapReduce application master, in a directory set by the `mapreduce.jobhistory.done-dir` property. Job history files are kept for one week before being deleted by the system.  
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

We sorted the output, as the reduce output partitions are unordered (owing to the hash partition function).

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
2. We can use a debug statement to log to standard error, in conjunction with updating the task’s status message to prompt us to look in the error log. The web UI makes this easy, as we pass: [will see].
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
Administrators,  Each Hadoop daemon produces a logfile (using log4j, .log)  and another file that combines standard out and error (.out). Written in the directory defined by the HADOOP_LOG_DIR environment variable. It is under $HADOOP_HOME/logs by default. This can be changed using the HADOOP_LOG_DIR setting in hadoop-env.sh. Logfile names (of both types) are a combination of the name of the user running the daemon, the daemon name, and the machine hostname. For example, hadoop-hdfs-datanode-ip-10-45-174-112.log. The username in the logfile name is actually the default for the **HADOOP_IDENT_STRING** setting in hadoop-env.sh

* HDFS audit logs  
Administrators,  A log of all HDFS requests, turned off by default. Written to the namenode’s log, although this is configurable. HDFS can log all filesystem access requests, Audit logging is implemented using log4j logging at the INFO level. (hdfs-audit.log) It can be enabled by adding the following line to hadoop-env.sh:  
```shell
export HDFS_AUDIT_LOGGER="INFO,RFAAUDIT"
```

* MapReduce job history logs  
Users, A log of the events (such as task completion) that occur in the course of running a job. Job history files are stored centrally in HDFS by the MapReduce application master, in JSON format, in a directory set by the `mapreduce.jobhistory.done-dir` property. 

* MapReduce task logs  
Users, Each task child process produces a logfile using log4j (called syslog), a file for data sent to standard out (stdout), and a file for standard error (stderr). Written in the userlogs subdirectory of the directory defined by the YARN_LOG_DIR environment variable.

YARN has a service for log aggregation that takes the task logs for completed applications and moves them to HDFS, where they are stored in a container file for archival purposes. If this service is enabled (by setting yarn.log-aggregation-enable to true on the cluster), then task logs can be viewed by clicking on the logs link in the task attempt web UI, or by using the `mapred job -logs` command. By default, log aggregation is not enabled. In this case, task logs can be retrieved by visiting the node manager’s web UI at http://node-manager-host:8042/logs/userlogs.

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

You can keep the intermediate files for successful tasks, set the property `mapre duce.task.files.preserve.filepattern` to a regular expression that matches the IDs of the tasks whose files you want to keep.  

Another useful property for debugging is `yarn.nodemanager.delete.debug-delay-sec`, which is the number of seconds to wait to delete localized task attempt files, such as the script used to launch the task container JVM. If this is set on the cluster to a reasonably large value (e.g., 600 for 10 minutes), then you have enough time to look at the files before they are deleted.

To examine task attempt files, log into the node that the task failed on and look for the directory for that task attempt. It will be under one of the local MapReduce directories, as set by the mapreduce.cluster.local.dir property. The task attempt directory is in the following location:  
```shell
mapreduce.cluster.local.dir/usercache/user/appcache/application-ID/output
/task-attempt-ID
```

### Tuning a Job
There are a few Hadoop-specific “usual suspects” that are worth checking to see whether they are responsible for a performance problem. You should run through the checklist in Table 6-3 before you start trying to profile or optimize at the task level.

* Number of mappers  
How long are your mappers running for? If they are only running for a few seconds on average, you should see whether there’s a way to have fewer mappers and make them all run longer—a minute or so, as a rule of thumb.  
Suggestion: use **CombineFileInputFormat** to avoid small files. (“small” means significantly smaller than an HDFS block)   
Hadoop works better with a small number of large files than a large number of small files. Compare a 1 GB file broken into eight 128 MB blocks with 10,000 or so 100 KB files. The 10,000 files use one map each, and the job time can be
tens or hundreds of times slower than the equivalent one with a single input file and eight map tasks.  
The situation is alleviated somewhat by CombineFileInputFormat, which was designed to work well with small files. Where FileInputFormat creates a split per file, CombineFileInputFormat packs many files into each split so that each mapper has more to process. Crucially, CombineFileInputFormat takes node and rack locality into account when deciding which blocks to place in the same split, so it does not compromise the speed at which it can process the input in a typical MapReduce job.  
CombineFileInputFormat isn’t just good for small files. It can bring benefits when processing large files, too, since it will generate one split per node, which may be made up of multiple blocks. Essentially, CombineFileInputFormat decouples the amount of data that a mapper consumes from the block size of the files in HDFS.  
Of course, if possible, it is still a good idea to avoid the many small files case, because MapReduce works best when it can operate at the transfer rate of the disks in the cluster, and processing many small files increases the number of seeks that are needed to run a job.  One technique for avoiding the many small files case is to merge small files into larger files by using a sequence file  
* Number of reducers  
Check that you are using more than a single reducer. Reduce tasks should run for five minutes or so and produce at least a block’s worth of data, as a rule of thumb.  
The single reducer default is something of a gotcha for new users to Hadoop. Almost all real-world jobs should set this to a larger number; otherwise, the job will be very slow since all the intermediate data flows through a single reduce task. Choosing the number of reducers for a job is more of an art than a science. Increasing the number of reducers makes the reduce phase shorter, since you get more parallelism. However, if you take this too far, you can have lots of small files, which is suboptimal. One rule of thumb is to aim for reducers that each run for five minutes or so, and which produce at least one HDFS block’s worth of output.
* Combiners  
Check whether your job can take advantage of a combiner to reduce
the amount of data passing through the shuffle.
* Intermediate compression  
Job execution time can almost always benefit from enabling map output compression.
* Custom serialization  
If you are using your own custom Writable objects or custom comparators, make sure you have implemented RawComparator.  
* Shuffle tweaks  
The MapReduce shuffle exposes around a dozen tuning parameters for memory management, which may help you wring out the last bit of performance.  

#### Profiling Tasks
Hadoop allows you to profile a fraction of the tasks in a job and, as each task completes, pulls down the profile information to your machine for later analysis with standard profiling tools.  

To be sure that any tuning is effective, you should compare the new execution time with the old one running on a real cluster. Even this is easier said than done, since job execution times can vary due to resource contention with other jobs and the decisions the scheduler makes regarding task placement. To get a good idea of job execution time under these circumstances, perform a series of runs (with and without the change) and check whether any improvement is statistically significant.

**The HPROF profiler**  
There are a number of configuration properties to control profiling, which are also exposed via convenience methods on JobConf. Enabling profiling is as simple as setting the property `mapreduce.task.profile` to true

This runs the job as normal, but adds an -agentlib parameter to the Java command used to launch the task containers on the node managers. You can control the precise parameter that is added by setting the `mapreduce.task.profile.params` property. The default uses HPROF, a profiling tool that comes with the JDK that, although basic, can give valuable information about a program’s CPU and heap usage.  

It doesn’t usually make sense to profile all tasks in the job, so by default only those with IDs 0, 1, and 2 are profiled (for both maps and reduces). You can change this by setting `mapreduce.task.profile.maps` and `mapreduce.task.profile.reduces` to specify the range of task IDs to profile. The profile output for each task is saved with the task logs in the userlogs subdirectory of the node manager’s local log directory (alongside the syslog, stdout, and stderr files), and can be retrieved in the way described in “Hadoop Logs” on page 172, according to whether log aggregation is enabled or not

### MapReduce Workflows
When the processing gets more complex, this complexity is generally manifested by having more MapReduce jobs, rather than having more complex map and reduce functions. In other words, as a rule of thumb, think about adding more jobs, rather than adding complexity to jobs.  

For more complex problems, it is worth considering a higher-level language than Map‐Reduce, such as Pig, Hive, Cascading, Crunch, or Spark.  

Finally, the book Data-Intensive Text Processing with MapReduce by Jimmy Lin and Chris Dyer (Morgan & Claypool Publishers, 2010) is a great resource for learning more about MapReduce algorithm design and is highly recommended.

#### Decomposing a Problem into MapReduce Jobs
A mapper commonly performs input format parsing, projection (selecting the 
relevant fields), and filtering (removing records that are not of interest).  In the mappers you have seen so far, we have implemented all of these functions in a single mapper. However, there is a case for splitting these into distinct mappers and chaining them into a single mapper using the **ChainMapper** library class that comes with Hadoop. Combined with a ChainReducer, you can run a chain of mappers, followed by a reducer and another chain of mappers, in a single MapReduce job.

#### JobControl
When there is more than one job in a MapReduce workflow, the question arises: how do you manage the jobs so they are executed in order? There are several approaches, and the main consideration is whether you have a `linear chain` of jobs or a more complex `directed acyclic graph (DAG)` of jobs.

For a linear chain, the simplest approach is to run each job one after another, waiting until a job completes successfully before running the next: The approach is similar with the new MapReduce API, except you need to examine the Boolean return value of the waitForCompletion() method on Job: true means the job succeeded, and false means it failed.  

For anything more complex than a linear chain, there are libraries that can help orchestrate your workflow (although they are also suited to linear chains, or even one-off jobs). The simplest is in the org.apache.hadoop.mapreduce.jobcontrol package: the **JobControl** class. (There is an equivalent class in the org.apache.hadoop.mapred.job control package, too.) An instance of JobControl represents a graph of jobs to be run. You add the job configurations, then tell the JobControl instance the dependencies between jobs. You run the JobControl in a thread, and it runs the jobs in dependency order. You can poll for progress, and when the jobs have finished, you can query for all the jobs’ statuses and the associated errors for any failures. If a job fails, JobControl won’t run its dependencies.

JobControl, which runs on the client machine submitting the jobs  

#### Apache Oozie
Apache Oozie is a system for running workflows of dependent jobs. It is composed of two main parts: a workflow engine that stores and runs workflows composed of different types of Hadoop jobs (MapReduce, Pig, Hive, and so on), and a coordinator engine that runs workflow jobs based on predefined schedules and data availability. Oozie has been designed to scale, and it can manage the timely execution of thousands of workflows in a Hadoop cluster, each composed of possibly dozens of constituent jobs.  

Oozie makes `rerunning failed workflows` more tractable, since no time is wasted running successful parts of a workflow. Anyone who has managed a complex batch system knows how difficult it can be to catch up from jobs missed due to downtime or failure, and will appreciate this feature.

Unlike JobControl, which runs on the client machine submitting the jobs, Oozie runs as a service in the cluster, and clients submit workflow definitions for immediate or later execution. In Oozie parlance, a workflow is a DAG of action nodes and control-flow nodes.

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

The Oozie specification lists all the EL functions that Oozie supports. 

##### Packaging and deploying an Oozie workflow application
A workflow application is made up of the workflow definition plus all the associated resources (such as MapReduce JAR files, Pig scripts, and so on) needed to run it. Applications must adhere to a simple directory structure, and are deployed to HDFS so that they can be accessed by Oozie. For this workflow application, we’ll put all of the files in a base directory called max-temp-workflow, as shown diagrammatically here:   

max-temp-workflow/  
├── lib/  
│ └── hadoop-examples.jar  
└── workflow.xml  

The workflow definition file workflow.xml must appear in the top level of this directory. JAR files containing the application’s MapReduce classes are placed in the lib directory.

##### Running an Oozie workflow job
For this we use the oozie command-line tool, a client program for communicating with an Oozie server. For convenience, we export the OOZIE_URL environment variable to tell the oozie command which Oozie server to use (here we’re using one running locally):  
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
4. The MapReduce application master, which coordinates the tasks running the Map‐Reduce job. The application master and the MapReduce tasks run in containers that are scheduled by the resource manager and managed by the node managers.
5. The distributed filesystem (normally HDFS, covered in Chapter 3), which is used for sharing job files between the other entities.

Not discussed in this section are the `job history server daemon` (for retaining job history data) and the `shuffle handler auxiliary service` (for serving map outputs to reduce tasks).

##### Job Submission
The submit() method on Job creates an internal **JobSubmitter** instance and calls submitJobInternal() on it. Having submitted the job, waitForCompletion() polls the job’s progress once per second and reports the progress to the console if it has changed since the last report. When the job completes successfully, the job counters are displayed. Otherwise, the error that caused the job to fail is logged to the console.

The job submission process implemented by JobSubmitter does the following:  
* Asks the resource manager for a new application ID, used for the MapReduce job ID (step 2).  
* Checks the output specification of the job. For example, if the output directory has not been specified or it already exists, the job is not submitted and an error is thrown to the MapReduce program. 
* Computes the input splits for the job. If the splits cannot be computed (because the input paths don’t exist, for example), the job is not submitted and an error is thrown to the MapReduce program. 
* Copies the resources needed to run the job, including the job JAR file, the configuration file, and the computed input splits, to `the shared filesystem in a directory named after the job ID` (step 3). The job JAR is copied with a high replication factor (controlled by the `mapreduce.client.submit.file.replication` property, which defaults to 10) so that there are lots of copies across the cluster for the node managers to access when they run tasks for the job. 
* Submits the job by calling submitApplication() on the resource manager (step 4).

##### Job Initialization
When the resource manager receives a call to its submitApplication() method, it hands off the request to the YARN scheduler. The scheduler allocates a container, and the resource manager then launches the application master’s process there, under the node manager’s management (steps 5a and 5b). 

The application master for MapReduce jobs is a Java application whose main class is **MRAppMaster**. It initializes the job by creating a number of bookkeeping objects to keep track of the job’s progress, as it will receive progress and completion reports from the tasks (step 6). Next, it retrieves the input splits computed in the client from the shared filesystem (step 7). `It then creates a map task object for each split`, as well as a number of reduce task objects determined by the `mapreduce.job.reduces` property (set by the setNumReduceTasks() method on Job). Tasks are given IDs at this point.

The application master must decide how to run the tasks that make up the MapReduce job. If the job is small, the application master may choose to run the tasks in the same JVM as itself. This happens when it judges that the overhead of allocating and running tasks in new containers outweighs the gain to be had in running them in parallel, compared to running them sequentially on one node. Such a job is said to be uberized, or run as an **uber task**. 

What qualifies as a small job? By default, a small job is one that has less than 10 mappers, only one reducer, and an input size that is less than the size of one HDFS block.  
* mapreduce.job.ubertask.maxmaps
* mapreduce.job.ubertask.maxreduces
* mapreduce.job.ubertask.maxbytes
* mapreduce.job.ubertask.enable

Finally, before any tasks can be run, the application master calls the setupJob() method on the **OutputCommitter**. For FileOutputCommitter, which is the default, it will create the final output directory for the job and the temporary working space for the task output.

##### Task Assignment
If the job does not qualify for running as an uber task, then the application master `requests containers for all the map and reduce tasks` in the job from the resource manager (step 8). Requests for map tasks are made first and with a higher priority than those for reduce tasks, since all the map tasks must complete before the sort phase of the reduce can start (see “Shuffle and Sort” on page 197). `Requests for reduce tasks are not made until 5% of map tasks have completed` (see “Reduce slow start” on page 308).

Reduce tasks can run anywhere in the cluster, but requests for map tasks have data locality constraints that the scheduler tries to honor (see “Resource Requests” on page 81). In the optimal case, the task is data local—that is, running on the same node that the split resides on. Alternatively, the task may be rack local: on the same rack, but not the same node, as the split.

Requests also specify memory requirements and CPUs for tasks.  
* mapreduce.map.memory.mb
* mapreduce.reduce.memory.mb
* mapreduce.map.cpu.vcores
* mapreduce.reduce.cpu.vcores

##### Task Execution
Once a task has been assigned resources for a container on a particular node by the resource manager’s scheduler, the application master starts the container by contacting the node manager (steps 9a and 9b). The task is executed by a Java application whose main class is **YarnChild**. Before it can run the task, it localizes the resources that the task needs, including the job configuration and JAR file, and any files from the distributed cache (step 10; see “Distributed Cache” on page 274). Finally, it runs the map or reduce task (step 11). 

The YarnChild runs `in a dedicated JVM`, so that any bugs in the user-defined map and reduce functions (or even in YarnChild) don’t affect the node manager. 

Each task can perform setup and commit actions, which are run in the same JVM as the task itself and are determined by the **OutputCommitter** for the job (see “Output Committers” on page 206). For file-based jobs, the commit action moves the task output from a temporary location to its final location. The commit protocol ensures that when speculative execution is enabled (see “Speculative Execution” on page 204), only one of the duplicate tasks is committed and the other is aborted.

##### Streaming
![hadoop_streaming_img_1]  

Streaming runs special map and reduce tasks for the purpose of launching the usersupplied executable and communicating with it (Figure 7-2). 

The Streaming task communicates with the process (which may be written in any language) using standard input and output streams. During execution of the task, the Java process passes input key-value pairs to the external process, which runs it through the user-defined map or reduce function and passes the output key-value pairs back to the Java process. From the node manager’s point of view, it is as if the child process ran the map or reduce code itself.

#### Progress and Status Updates
A job and each of its tasks have a status, which includes such things as the state of the job or task (e.g., running, successfully completed, failed), the progress of maps and reduces, the values of the job’s counters, and a status message or description (which may be set by user code).

When a task is running, it keeps track of its progress (i.e., the proportion of the task completed). For map tasks, this is the proportion of the input that has been processed. For reduce tasks, it’s a little more complex, but the system can still estimate the proportion of the reduce input processed. It does this by dividing the total progress into three parts, corresponding to the three phases of the shuffle (see “Shuffle and Sort” on page 197, Copy, Sort, Reduce)

Progress reporting is important, as Hadoop will not fail a task that’s making progress. All of the following operations constitute progress:  
* Reading an input record (in a mapper or reducer)
* Writing an output record (in a mapper or reducer)
* Setting the status description (via Reporter’s or TaskAttemptContext’s setSta
tus() method)
* Incrementing a counter (using Reporter’s incrCounter() method or Counter’s
increment() method)
* Calling Reporter’s or TaskAttemptContext’s progress() method

As the map or reduce task runs, the child process communicates with its parent application master through the umbilical interface. The task reports its progress and status (including counters) back to its `application master, which has an aggregate view of the job`, every three seconds over the umbilical interface.

The resource manager web UI displays all the running applications with links to the web UIs of their respective `application masters`, each of which displays further details on the MapReduce job, including its progress. During the course of the job, the client receives the latest status by `polling the application master` every second (the interval is set via `mapreduce.client.progressmonitor.pollinterval`). Clients can also use Job’s getStatus() method to obtain a JobStatus instance, which contains all of the status information for the job.

#### Job Completion
When the application master receives a notification that the last task for a job is complete, it changes the status for the job to “successful.” Then, when the Job polls for status, it learns that the job has completed successfully, so it prints a message to tell the user and then returns from the waitForCompletion() method. Job statistics and counters are printed to the console at this point. 

The application master also sends an HTTP job notification if it is configured to do so. This can be configured by clients wishing to receive callbacks, via the mapreduce.job.end-notification.url property. 

Finally, on job completion, the application master and the task containers clean up their working state (so intermediate output is deleted), and the OutputCommitter’s commit Job() method is called. Job information is archived by the job history server to enable later interrogation by users if desired.

### Failures
#### Task Failure
The task JVM reports the error back to its parent application master before it exits. The application master marks the task attempt as failed, and frees up the container so its resources are available for another task.  

For Streaming tasks, if the Streaming process exits with a nonzero exit code, it is marked as failed. This behavior is governed by the `stream.non.zero.exit.is.failure` property (the default is true).

Another failure mode is the sudden exit of the task JVM, in this case, the node manager notices that the process has exited and informs the application master so it can mark the attempt as failed.

Hanging tasks are dealt with differently. The application master notices that it hasn’t received a progress update for a while and proceeds to mark the task as failed. The task JVM process will be killed automatically after this period. The timeout period after which tasks are considered failed is normally 10 minutes and can be configured on a per-job basis (or a cluster basis) by setting the `mapreduce.task.timeout` property to a value in milliseconds. Setting the timeout to a value of zero disables the timeout.  

If a Streaming process hangs, the node manager will kill it (along with the JVM that launched it) only in the following circumstances: either `yarn.nodemanager.container-executor.class` is set to org.apache.ha doop.yarn.server.nodemanager.LinuxContainerExecutor, or the default container executor is being used and the setsid command is available on the system (so that the task JVM and any processes it launches are in the same process group). In any other case, orphaned Streaming processes will accumulate on the system, which will impact utilization over time.

When the application master is notified of a task attempt that has failed, it will reschedule execution of the task. The application master will try to avoid rescheduling the task on a node manager where it has previously failed. Furthermore, if a task fails four times (by default), it will not be retried again. (`mapreduce.map.maxattempts` property for map tasks and `mapreduce.reduce.maxattempts` for reduce tasks). 

A task attempt may also be killed, which is different from it failing. A task attempt may be killed because it is a speculative duplicate, or because the node manager it was running on failed and the application master marked all the task attempts running on it as killed. Killed task attempts do not count against the number of attempts to run the task.

For some applications, it is undesirable to abort the job if a few tasks fail, as it may be possible to use the results of the job despite some failures.  `mapreduce.map.failures.maxpercent` and `mapreduce.reduce.failures.maxpercent`

#### Application Master Failure
Applications in YARN are retried in the event of failure. The maximum number of attempts to run a MapReduce application master is controlled by the `mapreduce.am.max-attempts` property. The default value is 2.  

The way recovery works is as follows. An application master sends `periodic heartbeats` to the resource manager, and in the event of application master failure, the resource manager will detect the failure and start a new instance of the master running in a new container (managed by a node manager). In the case of the MapReduce application master, `it will use the job history to recover the state of the tasks that were already run by the (failed) application so they don’t have to be rerun`. Recovery is enabled by default, but can be disabled by setting `yarn.app.mapreduce.am.job.recovery.enable` to false.

The MapReduce client polls the application master for progress reports, but if its application master fails, the client needs to locate the new instance. During job initialization, the client asks the resource manager for the application master’s address, and then caches it so it doesn’t overload the resource manager with a request every time it needs to poll the application master. If the application master fails, however, the client will experience a timeout when it issues a status update, at which point the client will go back to the resource manager to ask for the new application master’s address.

#### Node Manager Failure
If a node manager fails by crashing or running very slowly, it will stop sending heartbeats to the resource manager (or send them very infrequently). The resource manager will notice a node manager that has stopped sending heartbeats if it hasn’t received one for 10 minutes (this is configured, in milliseconds, via the `yarn.resourcemanager.nm.liveness-monitor.expiry-interval-ms` property) and remove it from its pool of nodes to schedule containers on.  

Any task or application master running on the failed node manager will be recovered using the mechanisms described in the previous two sections. In addition, the application master arranges for map tasks that were run and completed successfully on the failed node manager to be rerun if they belong to incomplete jobs, since their intermediate output residing on the failed node manager’s local filesystem may not be accessible to the reduce task.  

Node managers may be blacklisted if the number of failures for the application is high, even if the node manager itself has not failed. `Blacklisting is done by the application master`, and for MapReduce the application master will try to reschedule tasks on different nodes if more than three tasks fail on a node manager. The user may set the threshold with the `mapreduce.job.maxtaskfailures.per.tracker` job property.  

Note that the resource manager does not do blacklisting across applications (at the time of writing), so tasks from new jobs may be scheduled on bad nodes even if they have been blacklisted by an application master running an earlier job.

#### Resource Manager Failure
In the default configuration, the resource manager is a single point of failure, since in the (unlikely) event of machine failure, all running jobs fail—and can’t be recovered.  

To achieve high availability (HA), it is necessary to run a pair of resource managers in an active-standby configuration. If the active resource manager fails, then the standby can take over without a significant interruption to the client.

Information about all the running applications is stored in a highly available state store (backed by ZooKeeper or HDFS), so that the standby can recover the core state of the failed active resource manager. Node manager information is not stored in the state store since it can be reconstructed relatively quickly by the new resource manager as the node managers send their first heartbeats. (Note also that tasks are not part of the resource manager’s state, since they are managed by the application master. Thus, the amount of state to be stored is therefore much more manageable than that of the jobtracker in MapReduce 1.)

When the new resource manager starts, it reads the application information from the state store, then restarts the application masters for all the applications running on the cluster. In practice, the application master restart is not an issue for MapReduce applications since they recover the work done by completed tasks.

The transition of a resource manager from standby to active is handled by a failover controller. The default failover controller is an automatic one, which uses ZooKeeper leader election to ensure that there is only a single active resource manager at one time. Unlike in HDFS HA (see “HDFS High Availability” on page 48), the failover controller does not have to be a standalone process, and is embedded in the resource manager by default for ease of configuration. It is also possible to configure manual failover, but this is not recommended.

Clients and node managers must be configured to handle resource manager failover, since there are now two possible resource managers to communicate with. They try connecting to each resource manager in a round-robin fashion until they find the active one. If the active fails, then they will retry until the standby becomes active.

### Shuffle and Sort
MapReduce makes the guarantee that the input to every reducer is sorted by key. The process by which the system performs the sort—and transfers the map outputs to the reducers as inputs—is known as the shuffle.  

The shuffle is an area of the codebase where refinements and improvements are continually being made, so the following description necessarily conceals many details. In many ways, the shuffle is the heart of MapReduce and is where the “magic” happens.


#### The Map Side
![hadoop_shuffle_process_img_1]  
When the map function starts producing output, it is not simply written to disk. The process is more involved, and takes advantage of buffering writes in memory and doing some presorting for efficiency reasons.

Each map task has a circular memory buffer that it writes the output to. The buffer is 100 MB by default (the size can be tuned by changing the `mapreduce.task.io.sort.mb` property). When the contents of the buffer reach a certain threshold size (`mapre duce.map.sort.spill.percent`, which has the default value 0.80, or 80%), a background thread will start to spill the contents to disk. Map outputs will continue to be written to the buffer while the spill takes place, but if the buffer fills up during this time, the map will block until the spill is complete. Spills are written in round-robin fashion to the directories specified by the `mapreduce.cluster.local.dir` property, in a jobspecific subdirectory.

Before it writes to disk, the thread first divides the data into partitions corresponding to the reducers that they will ultimately be sent to. Within each partition, the background thread performs an in-memory sort by key, and if there is a `combiner function`, it is run on the output of the sort. Running the combiner function makes for a more compact map output, so there is less data to write to local disk and to transfer to the reducer.

Each time the memory buffer reaches the spill threshold, a new spill file is created, so after the map task has written its last output record, there could be several spill files. Before the task is finished, `the spill files are merged into a single partitioned and sorted output file`. The configuration property `mapreduce.task.io.sort.factor` controls the maximum number of streams to merge at once; the default is 10.  

If there are at least three spill files (set by the `mapreduce.map.combine.minspills` property), the `combiner` is run again before the output file is written. Recall that combiners may be run repeatedly over the input without affecting the final result.

It is often a good idea to compress the map output as it is written to disk, by default, the output is not compressed, but it is easy to enable this by setting `mapreduce.map.output.compress` to true. The compression library to
use is specified by `mapreduce.map.output.compress.codec`.

The output file’s partitions are made available to the reducers over HTTP. The maximum number of worker threads used to serve the file partitions is controlled by the `mapreduce.shuffle.max.threads` property; this setting is per node manager, not per map task. The default of 0 sets the maximum number of threads to twice the number of processors on the machine.

#### The Reduce Side
1. copy phrase  
The map output file is sitting on the local disk of the machine that ran the map task (note that although map outputs always get written to local disk, reduce outputs may not be). The reduce task needs the map output for its particular partition from several map tasks across the cluster. The map tasks may finish at different times, so the reduce task starts copying their outputs as soon as each completes. This is known as the copy phase of the reduce task.  
The reduce task has a small number of copier threads so that it can fetch map outputs in parallel. The default is 5 threads, but this number can be changed by setting the `mapreduce.reduce.shuffle.parallelcopies` property.  
How do reducers know which machines to fetch map output from?  
As map tasks complete successfully, they notify their `application master` using the heartbeat mechanism. Therefore, for a given job, the application master knows the mapping between map outputs and hosts. A thread in the reducer periodically asks the master for map output hosts until it has retrieved them all. Hosts do not delete map outputs from disk as soon as the first reducer has retrieved them, as the reducer may subsequently fail. Instead, they wait until they are told to delete them by the application master, which is after the job has completed.  
Map outputs are copied to the reduce task JVM’s memory if they are small enough (the buffer’s size is controlled by `mapreduce.reduce.shuffle.input.buffer.percent`, which specifies the proportion of the heap to use for this purpose); otherwise, they are copied to disk. When the in-memory buffer reaches a threshold size (controlled by `mapreduce.reduce.shuffle.merge.percent`) or reaches a threshold number of map outputs (`mapreduce.reduce.merge.inmem.threshold`), it is merged and spilled to disk. If a `combiner` is specified, it will be run during the merge to reduce the amount of data written to disk.  
As the copies accumulate on disk, a background thread merges them into larger, sorted files. This saves some time merging later on. `Note that any map outputs that were compressed (by the map task) have to be decompressed in memory in order to perform a merge on them.`  
2. sort phrase  
When all the map outputs have been copied, the reduce task moves into the sort phase (which should properly be called the merge phase, as the sorting was carried out on the map side), which merges the map outputs, maintaining their sort ordering. This is done in rounds. For example, if there were 50 map outputs and the merge factor was 10 (the default, controlled by the `mapreduce.task.io.sort.factor` property, just like in the map’s merge), there would be five rounds. Each round would merge 10 files into 1, so at the end there would be 5 intermediate files.  
The number of files merged in each round is actually more subtle than this example suggests. The goal is to merge the minimum number of files to get to the merge factor for the final round. So if there were 40 files, the merge would not merge 10 files in each of the four rounds to get 4 files. Instead, the first round would merge only 4 files, and the subsequent three rounds would merge the full 10 files. The 4 merged files and the 6 (as yet unmerged) files make a total of 10 files for the final round. The process is illustrated in Figure 7-5. Note that this does not change the number of rounds; it’s just an optimization to minimize the amount of data that is written to disk, since `the final round always merges directly into the reduce`.
3. reduce phrase  
Rather than have a final round that merges these five files into a single sorted file, the merge `saves a trip to disk` by directly feeding the reduce function in what is the last phase: the reduce phase. This final merge can come from `a mixture of in-memory and on-disk segments`.  
During the reduce phase, the reduce function is invoked for each key in the sorted output. `The output of this phase is written directly to the output filesystem, typically HDFS`. In the case of HDFS, because the node manager is also running a datanode, the first block replica will be written to the local disk.  

#### Configuration Tuning
The relevant settings, which can be used on a per-job basis (except where noted), are summarized in Tables 7-1 and 7-2, along with the defaults, which are good for general-purpose jobs.  

The general principle is to give the shuffle as much memory as possible. However, there is a trade-off, in that you need to make sure that your map and reduce functions get enough memory to operate. This is why it is best to write your map and reduce functions to use as little memory as possible—certainly they should not use an unbounded amount of memory (avoid accumulating values in a map, for example).

The amount of memory given to the JVMs in which the map and reduce tasks run is set by the mapred.child.java.opts property. You should try to make this as large as possible for the amount of memory on your task nodes;  

On the map side, the best performance can be obtained by avoiding multiple spills to disk; one is optimal. If you can estimate the size of your map outputs, you can set the mapreduce.task.io.sort.* properties appropriately to minimize the number of spills. In particular, you should increase `mapreduce.task.io.sort.mb` if you can. There is a MapReduce counter, SPILLED_RECORDS, for both map and reduce phrases.  

In April 2008, Hadoop won the general-purpose terabyte sort benchmark, and one of the optimizations used was keeping the intermediate data in memory on the reduce side. 

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

It’s important to understand that speculative execution does not work by launching two duplicate tasks at about the same time so they can race each other. This would be wasteful of cluster resources. Rather, the scheduler tracks the progress of all tasks of the same type (map and reduce) in a job, and only launches speculative duplicates for the small proportion that are running significantly slower than the average. When a task completes successfully, any duplicate tasks that are running are killed since they are no longer needed. So, if the original task completes before the speculative task, the speculative task is killed; on the other hand, if the speculative task finishes first, the original is killed.  

Speculative execution is turned on by default. It can be enabled or disabled independently
for map tasks and reduce tasks, on a cluster-wide basis, or on a per-job basis.

* mapreduce.map.speculative
* mapreduce.reduce.speculative
* yarn.app.mapreduce.am.job.speculator.class  
org.apache.hadoop.mapreduce.v2.app.speculate.DefaultSpeculator
* yarn.app.mapreduce.am.job.task.estimator.class  
org.apache.hadoop.mapreduce.v2.app.speculate.LegacyTaskRuntimeEstimator

Speculative execution is turned on by default. It can be enabled or disabled independently for map tasks and reduce tasks, on a cluster-wide basis, or on a per-job basis.

Why would you ever want to turn speculative execution off?  
* On a busy cluster, speculative execution can reduce overall throughput  
The goal of speculative execution is to reduce job execution time, but this comes at the cost of cluster efficiency. On a busy cluster, speculative execution can reduce overall throughput, since redundant tasks are being executed in an attempt to bring down the execution time for a single job. For this reason, some cluster administrators prefer to turn it off on the cluster and have users explicitly turn it on for individual jobs. This was especially relevant for older versions of Hadoop, when speculative execution could be overly aggressive in scheduling speculative tasks.  
* There is a good case for turning off speculative execution for reduce tasks  since any duplicate reduce tasks have to fetch the same map outputs as the original task, and this can significantly increase network traffic on the cluster.  
* Another reason for turning off speculative execution is for nonidempotent tasks.  
However, in many cases it is possible to write tasks to be idempotent and use an OutputCommitter to promote the output to its final location when the task succeeds.  

#### Output Committers
Hadoop MapReduce uses a commit protocol to ensure that jobs and tasks either succeed or fail cleanly. The behavior is implemented by the OutputCommitter in use for the job, which is set in the old MapReduce API by calling the setOutputCommitter() on Job Conf or by setting `mapred.output.committer.class` in the configuration. In the new MapReduce API, the OutputCommitter is determined by the OutputFormat, via its getOutputCommitter() method. The default is FileOutputCommitter, which is appropriate for file-based MapReduce.  
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

The setupJob() method is called before the job is run, and is typically used to perform initialization. For FileOutputCommitter, the method creates the final output directory, ${mapreduce.output.fileoutputformat.outputdir}, and a temporary working space for task output, _temporary, as a subdirectory underneath it. 

If the job succeeds, the commitJob() method is called, which in the default file-based implementation deletes the temporary working space and` creates a hidden empty marker file in the output directory called _SUCCESS to indicate to filesystem clients that the job completed successfully`. If the job did not succeed, abortJob() is called with a state object indicating whether the job failed or was killed (by a user, for example). In the default implementation, this will delete the job’s temporary working space.

The operations are similar at the task level. The setupTask() method is called before the task is run, and the default implementation doesn’t do anything.

The commit phase for tasks is optional and may be disabled by returning false from needsTaskCommit(). `This saves the framework from having to run the distributed commit protocol for the task`, and neither commitTask() nor abortTask() is called. FileOutputCommitter will skip the commit phase when no output has been written by a task. 

If a task succeeds, commitTask() is called, which in the default implementation moves the temporary task output directory (which has the task attempt ID in its name to avoid conflicts between task attempts) to the final output path, ${mapreduce.output.fileoutputformat.outputdir}. Otherwise, the framework calls abortTask(), which deletes the temporary task output directory.

The usual way of writing output from map and reduce tasks is by using **OutputCollector** to collect key-value pairs. Some applications need more flexibility than a single keyvalue pair model, so these applications write output files directly from the map or reduce task to a distributed filesystem, such as HDFS.

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

The partition function operates on the intermediate key and value types (K2 and V2) and returns the partition index. In practice, the partition is determined solely by the key (the value is ignored):
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
The default partitioner is HashPartitioner, which hashes a record’s key to determine which partition the record belongs in. Each partition is processed by a reduce task:  
```java
public class HashPartitioner<K, V> extends Partitioner<K, V> {
    public int getPartition(K key, V value,
        int numReduceTasks) {
        return (key.hashCode() & Integer.MAX_VALUE) % numReduceTasks;
    }
}
```
You may have noticed that we didn’t set the number of map tasks. The reason for this is that the number is equal to the number of splits that the input is turned into, which is driven by the size of the input and the file’s block size (if the file is in HDFS).

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

An InputSplit has a length in bytes and a set of storage locations, which are just hostname strings. Notice that a split doesn’t contain the input data; it is just a reference to the data. The storage locations are used by the MapReduce system to place map tasks as close to the split’s data as possible, and the size is used to order the splits so that the largest get processed first, in an attempt to minimize the job runtime (this is an instance of a greedy approximation algorithm).  

As a MapReduce application writer, you don’t need to deal with InputSplits directly, as they are created by an InputFormat (an InputFormat is responsible for creating the input splits and dividing them into records).
```java
public abstract class InputFormat<K, V> {
    public abstract List<InputSplit> getSplits(JobContext context)
    throws IOException, InterruptedException;
    public abstract RecordReader<K, V>
    createRecordReader(InputSplit split, TaskAttemptContext context)
    throws IOException, InterruptedException;
}
```
The `client` running the job calculates the splits for the job by calling getSplits(), then sends them to the `application master`, which uses their storage locations to schedule map tasks that will process them on the cluster. `The map task` passes the split to the createRecordReader() method on InputFormat to obtain a RecordReader for that split. A RecordReader is little more than an iterator over records, and the map task uses one to generate record key-value pairs, which it passes to the map function. We can see this by looking at the Mapper’s run() method:  
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

**MultithreadedMapper** is an implementation that runs mappers concurrently in a configurable number of threads (set by mapreduce.mapper.multithreadedmapper.threads). For most data processing tasks, it confers no advantage over the default implementation. However, for mappers that spend a long time processing each record —because they contact external servers, for example—it allows multiple mappers to run in one JVM with little contention.

**FileInputFormat** is the base class for all implementations of InputFormat that use files as their data source (see Figure 8-2). It provides two things: a place to define which files are included as the input to a job, and an implementation for generating splits for the input files. The job of dividing splits into records is performed by subclasses.    

![hadoop_inputformat_class_hierarchy_img_1]  

**Given a set of files, how does FileInputFormat turn them into splits?**  FileInputFor mat splits only large files—here, “large” means larger than an HDFS block. The split size is normally the size of an HDFS block, which is appropriate for most applications; however, it is possible to control this value by setting various Hadoop properties,  
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
Hadoop comes with a class for this purpose called **StreamXmlRecordReader** (which is in the org.apache.hadoop.streaming.mapreduce package, although it can be used outside of Streaming). You can use it by setting your input format to StreamInputFor mat and setting the stream.recordreader.class property to org.apache.hadoop.streaming.mapreduce.StreamXmlRecordReader. The reader is configured by setting job configuration properties to tell it the patterns for the start and end tags.  

See Mahout’s XmlInputFormat for an improved XML input format.

#### Binary Input

##### SequenceFileInputFormat
Hadoop’s sequence file format stores sequences of binary key-value pairs. Sequence files are well suited as a format for MapReduce data because they are splittable (they have sync points so that readers can synchronize with record boundaries from an arbitrary point in the file, such as the start of a split), they support compression as a part of the format, and they can store arbitrary types using a variety of serialization frameworks. (These topics are covered in “SequenceFile” on page 127.)

To use data from sequence files as the input to MapReduce, you can use SequenceFi leInputFormat. The keys and values are determined by the sequence file, and you need to make sure that your map input types correspond. SequenceFileInputFormat can read map files as well as sequence files.  

##### SequenceFileAsTextInputFormat
SequenceFileAsTextInputFormat is a variant of SequenceFileInputFormat that converts the sequence file’s keys and values to Text objects. The conversion is performed by calling toString() on the keys and values. This format makes sequence files suitable input for Streaming.

##### SequenceFileAsBinaryInputFormat
SequenceFileAsBinaryInputFormat is a variant of SequenceFileInputFormat that retrieves the sequence file’s keys and values as opaque binary objects. They are encapsulated as **BytesWritable** objects, and the application is free to interpret the underlying byte array as it pleases. In combination with a process that creates sequence files with SequenceFile.Writer’s appendRaw() method or SequenceFileAsBinaryOutputFormat, this provides a way to use any binary data types with MapReduce (packaged as a sequence file), although plugging into Hadoop’s serialization mechanism is normally a cleaner alternative.

##### FixedLengthInputFormat  
FixedLengthInputFormat is for reading fixed-width binary records from a file, when the records are not separated by delimiters. The record size must be set via fixed lengthinputformat.record.length.

#### Multiple Inputs
What often happens, however, is that the data format evolves over time, so you have to write your mapper to cope with all of your legacy formats. Or you may have data sources that provide the same type of data but in different formats. This arises in the case of performing joins of different datasets; These cases are handled elegantly by using the MultipleInputs class, which allows you to specify which InputFormat and Mapper to use on a per-path basis.

#### Database Input (and Output)
DBInputFormat is an input format for reading data from a relational database, using JDBC. Because it doesn’t have any sharding capabilities, you need to be careful not to overwhelm the database from which you are reading by running too many mappers. For this reason, it is best used for loading relatively small datasets, perhaps for joining with larger datasets from HDFS using MultipleInputs.  

The corresponding output format is DBOutputFormat, which is useful for dumping job outputs (of modest size) into a database. 

For an alternative way of moving data between relational databases and HDFS, consider using **Sqoop**, which is described in Chapter 15. 

HBase’s TableInputFormat is designed to allow a MapReduce program to operate on data stored in an HBase table. TableOutputFormat is for writing MapReduce outputs into an HBase table.

### Output Formats
![hadoop_outputformat_class_hierarchy_img_1]  

#### Text Output
The default output format, TextOutputFormat, writes records as lines of text. Its keys and values may be of any type, since TextOutputFormat turns them to strings by calling toString() on them. Each key-value pair is separated by a tab character, although that may be changed using the mapreduce.output.textoutputformat.separator property.

You can suppress the key or the value from the output (or both, making this output format equivalent to NullOutputFormat, which emits nothing) using a NullWritable type. This also causes no separator to be written

#### Binary Output
##### SequenceFileOutputFormat
As the name indicates, SequenceFileOutputFormat writes sequence files for its output. This is a good choice of output if it forms the input to a further MapReduce job, since it is compact and is readily compressed. Compression is controlled via the static methods on SequenceFileOutputFormat.  

##### SequenceFileAsBinaryOutputFormat
SequenceFileAsBinaryOutputFormat—the counterpart to SequenceFileAsBinaryInputFormat—writes keys and values in raw binary format into a sequence file container.  

##### MapFileOutputFormat  
MapFileOutputFormat writes map files as output. The keys in a MapFile must be added in order, so you need to ensure that your reducers emit keys in sorted order.

##### Multiple Outputs
Sometimes there is a need to have more control over the naming of the files or to produce multiple files per reducer. MapReduce comes with the MultipleOutputs class to help you do this.  

It is generally a bad idea to allow the number of partitions to be rigidly fixed by the application, since this can lead to small or unevensized partitions.

It is much better to let the cluster drive the number of partitions for a job, the idea being that the more cluster resources there are available, the faster the job can complete. This is why the default HashPartitioner works so well: it works with any number of partitions and ensures each partition has a good mix of keys, leading to more evenly sized partitions.

###### MultipleOutputs  
MultipleOutputs allows you to write data to files whose names are derived from the output keys and values, or in fact from an arbitrary string. This allows each reducer (or mapper in a map-only job) to create more than a single file. Filenames are of the form name-m-nnnnn for map outputs and name-r-nnnnn for reduce outputs, where name is an arbitrary name that is set by the program and nnnnn is an integer designating the part number, starting from 00000.

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
FileOutputFormat subclasses will create output (part-r-nnnnn) files, even if they are empty. Some applications prefer that empty files not be created, which is where Lazy OutputFormat helps. It is a wrapper output format that ensures that the output file is created only when the first record is emitted for a given partition. To use it, call its setOutputFormatClass() method with the JobConf and the underlying output format. 

Streaming supports a -lazyOutput option to enable LazyOutputFormat.

## Miscellaneous


---
[hadoop_data_locality_img_1]:/resources/img/java/hadoop_data_locality_1.png "Figure 2-2. Data-local (a), rack-local (b), and off-rack (c) map tasks"
[hadoop_data_flow_img_1]:/resources/img/java/hadoop_data_flow_1.png "Figure 2-4. MapReduce data flow with multiple reduce tasks"
[hadoop_data_flow_img_2]:/resources/img/java/hadoop_data_flow_2.png "Figure 3-2. A client reading data from HDFS"
[hadoop_data_flow_img_3]:/resources/img/java/hadoop_data_flow_3.png "Figure 3-4. A client writing data to HDFS"
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

