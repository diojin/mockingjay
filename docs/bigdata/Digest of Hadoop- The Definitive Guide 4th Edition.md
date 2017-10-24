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
The namenode manages the filesystem namespace.

## Miscellaneous


---
[hadoop_data_locality_img_1]:/resources/img/java/hadoop_data_locality_1.png "Figure 2-2. Data-local (a), rack-local (b), and off-rack (c) map tasks"
[hadoop_data_flow_img_1]:/resources/img/java/hadoop_data_flow_1.png "Figure 2-4. MapReduce data flow with multiple reduce tasks"
