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

WritableComparator is a general-purpose implementation of RawComparator for WritableComparable classes. It provides two main functions. First, it provides a default implementation of the raw compare() method that `deserializes the objects to be compared` from the stream and invokes the object compare() method. Second, it acts as a factory for RawComparator instances (that Writable implementations have registered). For example, to obtain a comparator for IntWritable, we just use:  
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



## Miscellaneous


---
[hadoop_data_locality_img_1]:/resources/img/java/hadoop_data_locality_1.png "Figure 2-2. Data-local (a), rack-local (b), and off-rack (c) map tasks"
[hadoop_data_flow_img_1]:/resources/img/java/hadoop_data_flow_1.png "Figure 2-4. MapReduce data flow with multiple reduce tasks"
[hadoop_data_flow_img_2]:/resources/img/java/hadoop_data_flow_2.png "Figure 3-2. A client reading data from HDFS"
[hadoop_data_flow_img_3]:/resources/img/java/hadoop_data_flow_3.png "Figure 3-4. A client writing data to HDFS"
[hadoop_data_flow_img_4]:/resources/img/java/hadoop_data_flow_4.png "Figure 4-2. How YARN runs an application"
[hadoop-jvm-compressor-benchmark-1]:https://github.com/ning/jvm-compressor-benchmark "jvm compressor benchmark"
[hadoop_writable_class_hierarchy_img_1]:/resources/img/java/hadoop_writable_class_hierarchy_1.png "Figure 5-1. Writable class hierarchy"
