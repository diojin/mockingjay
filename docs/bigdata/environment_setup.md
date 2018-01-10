# 			BigData Environment Setup
---
## Indexes
* [Virtual Box with CentOS](#virtual-box-with-centos)
* [Hadoop](#hadoop)
    - [Pseudo Distrubuted Mode](#pseudo-distrubuted-mode)
    - [Distrubuted Mode and Pseudo Distrubuted Mode together](#distrubuted-mode-and-pseudo-distrubuted-mode-together)
    - [Reset Hadoop](#reset-hadoop)
* [Spark](#spark)  
    - [Installation issues](#spark-installation-issues)
        + [sbt installation issues](#sbt-installation-issues)
* [Sqoop](#sqoop)
* [Flume](#flume)
* [Hive](#hive)
* [HBase](#hbase)
* [git](#git)
* [Virtual Box](#virtual-box)
    - [How to clone a virtual machine](#how-to-clone-a-virtual-machine)
    - [Shared Folder with Host Machine](#shared-folder-with-host-machine)
    - [Different network connection configurations](#different-network-connection-configurations)
    - [Increase VDI disk size](#increase-vdi-disk-size)
    - [Misc](#virtualbox-misc)
* [Miscellaneous](#miscellaneous)
    - [virtualenv](#virtualenv)

[hadoop-multi-node-setup-1]  
[hadoop-multi-node-setup-2]  

## Virtual Box with CentOS
1. Download latest VirtualBox: [VirtualBox Download]  
Version: 5.1.28  
2. Download latest CentOS ISO: [centos-download]
Version: CentOS-7 (1708)
```shell
$ cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core) 
```
3. install CentOS on VirtualBox
    1. follow [install-centos-on-virtualbox], which uses CentOS6.4    
    2. Different settings between CentOS6.4 and CentOS7
        1. Select bridged model in network configuration of the VM
        Refer to [Different network connection configurations](#different-network-connection-configurations)
        2. During installation
            1. Select "GNOME Desktop" as SOFTWARE SELECTION
            2. Disable KDUMP
            3. Enable NETWORK

hostname |VM Instance |ip address     |mac address       |Roles
---------|------------|---------------|------------------|---------------------
Matthew  |CentOS1     |192.168.31.215 |08:00:27:db:91:f3 |Master, NameNode, SecondaryNameNode, ResourceManager, JobHistoryServer
Mark     |CentOS2     |192.168.31.245 |08:00:27:e0:a4:67 |NodeManager,DataNode
Luke     |CentOS3     |192.168.31.239 |08:00:27:80:3b:1e |NodeManager,DataNode

>HDFS daemons are NameNode, SecondaryNameNode, and DataNode. YARN damones are ResourceManager, NodeManager, and WebAppProxy. If MapReduce is to be used, then the MapReduce Job History Server will also be running. For large installations, these are generally running on separate hosts.

## Hadoop
1. Create Hadoop user
```shell
$ su
$ useradd -m hadoop -g root -s /bin/bash
# setup password
$ passwd hadoop 
# add user hadoop as administrator
$ visudo            #  equals to "vi /etc/sudoers"
```
In general, it is recommended that HDFS and YARN run as separate users. In the majority of installations, HDFS processes execute as ‘hdfs’. YARN is typically using the ‘yarn’ account.  

2. Required softwares for Linux include  
    [hadoop-setup-single-node]  
    1. Java™ must be installed. JAVA 1.7 or later 
    ```shell
    sudo yum install java-1.8.0-openjdk java-1.8.0-openjdk-devel
    ```
    By default, it is installed under /usr/lib/jvm/java-1.7.0-openjdk-1.7.0.151-2.6.11.1.el7_4.x86_64   
    How to find installation location if there is already one  
    ```shell
    $ rpm -qa | grep java
    ...
    java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64
    $ rpm -ql java-1.8.0-openjdk-1.8.0.144-0.b01.el7_4.x86_64
    ```

    Set up JAVA_HOME environment variable  
    ```shell
    $ vi ~/.bashrc
    export JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.151-2.6.11.1.el7_4.x86_64
    ```

    2. ssh must be installed and sshd must be running to use the Hadoop scripts that manage remote Hadoop daemons.  
        1. Fist check if ssh is already installed  
        ```shell
        $ rpm -qa | grep ssh
        ```
        if there are something like below, then installed already  
        openssh-7.4p1-12.el7_4.x86_64  
        openssh-server-7.4p1-12.el7_4.x86_64  
        libssh2-1.4.3-10.el7_2.1.x86_64  
        openssh-clients-7.4p1-12.el7_4.x86_64   
        otherwise, install them as below.  
        ```shell
        sudo yum install openssh-clients
        sudo yum install openssh-server
        ```
        2. set up key-based ssh  
        for Single Node Cluster  
        ```shell
        cd ~/.ssh/                     # if .ssh doesn't exist, ssh to any server, like localhost at first to create it.
        ssh-keygen -t rsa              # press enter to pass all settings
        cat id_rsa.pub >> authorized_keys 
        chmod 600 ./authorized_keys
        ```
        for Fully-Distributed Mode, refer to setup in 3.3  
3. Hadoop
    1. download and installation  
    ```shell
    $ cd ~
    $ wget http://mirror.bit.edu.cn/apache/hadoop/common/hadoop-2.7.4/
    $ sudo tar -zxf ~/shared/hadoop-2.7.4.tar.gz -C /usr/local
    $ cd /usr/local/
    $ sudo mv hadoop-2.7.4 hadoop  
    $ sudo chown -R hadoop:root hadoop        
    ```
    To test if hadoop is installed correctly  
    ```shell
    $ cd /usr/local/hadoop
    $ ./bin/hadoop version
    ```
    Setup Hadoop Environment Variables  
    ```shell
    $ vi ~/.bashrc
    export HADOOP_HOME=/usr/local/hadoop
    export HADOOP_INSTALL=$HADOOP_HOME
    export HADOOP_MAPRED_HOME=$HADOOP_HOME
    export HADOOP_COMMON_HOME=$HADOOP_HOME
    export HADOOP_HDFS_HOME=$HADOOP_HOME
    export YARN_HOME=$HADOOP_HOME
    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
    export HADOOP_PREFIX=$HADOOP_HOME
    export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
    ```
    It is also traditional to configure HADOOP_PREFIX in the system-wide shell environment configuration. For example, a simple script inside /etc/profile.d
    2. Add FQDN Mapping  
    ```shell
    $ vi /etc/hosts
    192.168.31.215  Matthew
    192.168.31.245  Mark
    192.168.31.239  Luke
    ```
    Change hostname if necessary  
    ```shell
    $ sudo vim /etc/hostname
    # or else
    $ hostnamectl set-hostname {HOSTNAME}
    ```
    3. Configuring Key Based Login  
    It’s required to set up hadoop user to ssh itself without password, as well as other cluster nodes  
    ```shell
    # log to any cluster node, execute the following
    $ ssh-keygen -t rsa
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@Matthew
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@Mark
    $ ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@Luke
    $ chmod 0600 ~/.ssh/authorized_keys
    ```
    What ssh-copy-id does has indeed similar effect to  
    ```shell
    # as for local machine
    $ cat ./id_rsa.pub >> ./authorized_keys
    # as for other server, say "Target" server
    $ scp ~/.ssh/id_rsa.pub hadoop@Target:/home/hadoop/
    # then log to Target
    $ cat ~/id_rsa.pub >> ~/.ssh/authorized_keys
    $ rm ~/id_rsa.pub
    ```
4. Configure Hadoop  
    1. Change 5 configuration files on Master Server under $HADOOP_HOME/etc/hadoop, that is, core-site.xml, hdfs-site.xml, mapred-site.xml, yarn-site.xml, slaves    
        1. Edit core-site.xml  
        ```xml
        <!-- Add the following inside the configuration tag -->
        <property>
            <name>fs.defaultFS</name>
            <value>hdfs://Matthew:9000/</value>
        </property>
        <property>
            <name>hadoop.tmp.dir</name>
            <value>file:/var/tmp/hadoop/distributed</value>
            <description>A base for other temporary directories.</description>
        </property>
        ```
        2. Edit hdfs-site.xml  
        ```xml
        <property>
            <name>dfs.namenode.secondary.http-address</name>
            <value>Matthew:50090</value>
        </property>
        <property>
            <name>dfs.replication</name>
            <value>2</value>
        </property>
        <property>
            <name>dfs.namenode.name.dir</name>
            <value>file:/usr/local/data/hadoop/distributed/dfs/name</value>
        </property>
        <property>
            <name>dfs.datanode.data.dir</name>
            <value>file:/usr/local/data/hadoop/distributed/dfs/data</value>
        </property>
        ```
        3. Edit mapred-site.xml  
        ```xml
        <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>
        <property>
            <name>mapreduce.jobhistory.address</name>
            <value>Matthew:10020</value>
        </property>
        <property>
            <name>mapreduce.jobhistory.webapp.address</name>
            <value>Matthew:19888</value>
        </property>
        <property> 
            <name>mapreduce.map.memory.mb</name> 
            <value>256</value> 
            <description>memory limitation for each map task</description> 
        </property> 
        <property> 
            <name>mapreduce.map.java.opts</name> 
            <value>-Xmx205m</value> 
            <description>Larger heap-size for child jvms of maps</description>
        </property>
        
        <property> 
            <name>mapreduce.reduce.memory.mb</name> 
            <value>256</value> 
            <description>memory limitation for each reduce task</description> 
        </property> 
        <property> 
            <name>mapreduce.reduce.java.opts</name> 
            <value>-Xmx205m</value> 
            <description>Larger heap-size for child jvms of reduces.</description>
        </property>
        <property>  
            <name>yarn.app.mapreduce.am.resource.mb</name>  
            <value>256</value>
        </property>
        <property> 
            <name>yarn.app.mapreduce.am.command-opts</name> 
            <value>-Xmx205m</value>
        </property>
        <property>
            <name>mapreduce.map.cpu.vcores</name>
            <value>1</value>
            <description>The number of virtual cores required for each map task.</description>
        </property>
        <property>
            <name>mapreduce.reduce.cpu.vcores</name>
            <value>1</value>
            <description>The number of virtual cores required for each map task.</description>
        </property>
        ```
        4. Edit yarn-site.xml  
        ```xml
        <property>
            <name>yarn.resourcemanager.hostname</name>
            <value>Matthew</value>
        </property>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
        <property>  
            <name>yarn.nodemanager.resource.memory-mb</name>  
            <value>1024</value>  
            <discription>Available memory for the node, MB</discription>  
        </property>  
        <property>  
            <name>yarn.scheduler.minimum-allocation-mb</name>  
            <value>128</value>  
            <discription>minimal memory for single task，1024MB by default</discription>
        </property>  
        <property>  
            <name>yarn.scheduler.maximum-allocation-mb</name>  
            <value>256</value>  
            <discription>maximum memory for single task，8192MB by default</discription>  
        </property>
        <property>
            <name>yarn.nodemanager.vmem-check-enabled</name>
            <value>false</value>
            <description>Whether virtual memory limits will be enforced for containers</description>
        </property>
        <property>
            <name>yarn.nodemanager.vmem-pmem-ratio</name>
            <value>4</value>
            <description>Ratio between virtual memory to physical memory when setting memory limits for containers, default is 2.1</description>
        </property>
        <property>
            <name>yarn.scheduler.minimum-allocation-vcores</name>
            <value>1</value>
            <description>The minimum allocation for every container request at the RM, in terms of virtual CPU cores. Requests lower than this won't take effect, and the specified value will get allocated the minimum.</description>
        </property>
        <property>
            <name>yarn.scheduler.maximum-allocation-vcores</name>
            <value>1</value>
            <description>The maximum allocation for every container request at the RM, in terms of virtual CPU cores. Requests higher than this won't take effect, and will get capped to this value.</description>
        </property>
        <property>
            <name>yarn.nodemanager.resource.cpu-vcores</name>
            <value>2</value>
            <description>Number of CPU cores that can be allocated for containers.</description>
        </property>
        ```
        5. Edit slaves  
        Servers listed here are DataNode, localhost is not included, so that the Master server Matthew is not DataNode.
        ```json
        Mark
        Luke
        ```

        Key things to remember is:  
        * Values of mapreduce.map.memory.mb and mapreduce.reduce.memory.mb should be at least yarn.scheduler.minimum-allocation-mb
        * Values of mapreduce.map.java.opts and mapreduce.reduce.java.opts should be around "0.8 or 0.75 times the value of" corresponding mapreduce.map.memory.mb and mapreduce.reduce.memory.mb configurations. 
        * Similarly, value of yarn.app.mapreduce.am.command-opts should be "0.8 or 0.75 times the value of" yarn.app.mapreduce.am.resource.mb
        * beyond virtual memory limits issue  
        This is happening on Centos/RHEL 6 due to its aggressive allocation of virtual memory.It can be resolved either by:  
            1. Disable virtual memory usage check by setting yarn.nodemanager.vmem-check-enabled to false;
            2. Increase VM:PM ratio by setting yarn.nodemanager.vmem-pmem-ratio to some higher value.
    2. Edit hadoop-env.sh 
    $HADOOP_HOME/etc/hadoop/hadoop-env.sh  
    ```shell
    export  HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
    export  HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib:$HADOOP_COMMON_LIB_NATIVE_DIR"
    ```
    3. Copy these 5 configuration files as well as hadoop-env.sh to Slaver Servers.  
    4. Format NameNode if it is 1st time started
    Here, execute the command on Matthew  
    ```shell
    hdfs namenode -format
    ```
    5. As for CentOS, stop firewall so that telnet won't be blocked  
    Otherwise, live datanode would be 0.  
        * CentOS7  
        ```shell
        systemctl stop firewalld.service    
        systemctl disable firewalld.service     # diable auto start service
        ```
        * CentOS6.x  
        ```shell
        sudo service iptables stop   
        sudo chkconfig iptables off  
        # or else
        sudo /etc/init.d/iptables stop
        sudo chkconfig iptables off
        ```

5. Start Hadoop
Hadoop needs to be started on Master Server, that is, Matthew. Running following scripts on Master server.    
    1. start-dfs.sh  
    jps result:  
    Matthew(Master)  
    6835 SecondaryNameNode  
    6628 NameNode   
    Mark/Luke(Slaves)  
    4866 DataNode   
    2. start-yarn.sh  
    jps result:  
    Matthew(Master)  
    6835 SecondaryNameNode  
    6628 NameNode  
    `7416 ResourceManager`  
    Mark/Luke(Slaves)  
    `5217 NodeManager`  
    4866 DataNode  
    3. mr-jobhistory-daemon.sh start historyserver  
    jps result:  
    Matthew(Master)  
    6835 SecondaryNameNode  
    6628 NameNode  
    `7830 JobHistoryServer`  
    7416 ResourceManager  
    Mark/Luke(Slaves)  
    5217 NodeManager  
    4866 DataNode  

6. Verift hadoop status:  
    1. run following command on Master Node      
    ```shell
    hdfs dfsadmin -report
    ```
    2. check status by http://Matthew:50070/  

7. Execute one distributed job
Running on Master server Matthew  
    1. create HDFS user directory  
    ```shell
    $ hdfs dfs -mkdir -p /user/hadoop
    ```
    2. copy some files to HDFS  
    ```shell
    $ hdfs dfs -mkdir input
    $ hdfs dfs -put /usr/local/hadoop/etc/hadoop/*.xml input
    ```
    3. Run a MapReduce Job  
    ```shell
    $ hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar grep input output 'dfs[a-z.]+'
    ```
    Use http://Matthew:8088/cluster to monitor the progress.  
    If no response, that might be due to memory size or YARN memory configuration  
    Verify result:  
    ```shell
    $ hdfs dfs -cat output/*
    ```

8. Execute another distributed job
Running on Master server Matthew  
    1. Preparation   
    ```shell
    $ echo "hello world hello Hello" > ~/workspace/tmp/test.txt
    $ hdfs dfs -mkdir /input
    $ hadoop fs -put ~/workspace/tmp/test.txt /input
    ```
    2. Run a MapReduce Job  
    ```shell
    $ hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar wordcount /input /output
    ```

9. stop hadoop  
```shell
stop-yarn.sh
stop-dfs.sh
mr-jobhistory-daemon.sh stop historyserver
```

### Pseudo Distrubuted Mode
Differences of configuration files between Distributed Mode(as shown previously):  
```xml
<?xml version="1.0"?>
<!-- core-site.xml -->
    <!-- mandatory -->
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost/</value>
    </property>

    <!-- not mandatory -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>file:/var/tmp/hadoop/pseudo_distributed</value>
        <description>A base for other temporary directories.</description>
    </property>


<?xml version="1.0"?>
<!-- hdfs-site.xml -->
    <!-- mandatory -->
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>

    <!-- not mandatory -->
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/usr/local/data/hadoop/pseudo_distributed/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/usr/local/data/hadoop/pseudo_distributed/dfs/data</value>
    </property>

<!-- yarn-site.xml -->
    <!-- mandatory -->
    <property>
        <name>yarn.resourcemanager.hostname</name>
        <value>localhost</value>
    </property>

    <!-- not mandatory -->
    <property>
        <name>yarn.nodemanager.resource.cpu-vcores</name>
        <value>1</value>
        <description>Number of CPU cores that can be allocated for containers.</description>
    </property>

<!-- slaves -->
localhost
```
Environment variables settings:  
```shell
export HADOOP_CONF_DIR=/home/hadoop/conf/hadoop/pseudo_distributed
export HADOOP_LOG_DIR=/var/log/hadoop/pseudo_distributed
```

### Distrubuted Mode and Pseudo Distrubuted Mode together
How to set up both distributed mode and pseudo distributed mode on same master server?  
1. store all configuration or executable files under $HADOOP_HOME/etc/hadoop to separate directories, with proper settings respectively shown above   
2. use separate directories for datadir, namedir, and tmpdir    
```xml
<!-- core-site.xml -->
    <!-- not mandatory -->
    <property>
        <name>hadoop.tmp.dir</name>
        <value>file:/var/tmp/hadoop/pseudo_distributed</value>
        <description>A base for other temporary directories.</description>
    </property>

<!-- hdfs-site.xml -->
    <!-- not mandatory -->
    <property>
        <name>dfs.namenode.name.dir</name>
        <value>file:/usr/local/data/hadoop/pseudo_distributed/dfs/name</value>
    </property>
    <property>
        <name>dfs.datanode.data.dir</name>
        <value>file:/usr/local/data/hadoop/pseudo_distributed/dfs/data</value>
    </property>
```
3. use separate directories for logs
4. set up environment variables to designated configuration or log directories  
```shell
export HADOOP_CONF_DIR=/home/hadoop/conf/hadoop/pseudo_distributed
export HADOOP_LOG_DIR=/var/log/hadoop/pseudo_distributed
```
5. format namenode at the first time    
```shell
    hdfs namenode -format
```

### Reset Hadoop
1. Clean up logs under ${HADOOP_HOME}/logs on both master and slaves
2. Clean up all files under ${hadoop.tmp.dir}, ${dfs.namenode.name.dir} and ${dfs.namenode.data.dir}, keep the directories, on both master and slaves  
For slaves, clean up all files under ${hadoop.tmp.dir}/nm-local-dir  
3. format namenode  
```shell
    hdfs namenode -format
```

## Spark
1. Using Spark's "Hadoop Free" Build  
To use these builds, you need to modify SPARK_DIST_CLASSPATH to include Hadoop’s package jars. The most convenient place to do this is by adding an entry in conf/spark-env.sh  
```shell
# If 'hadoop' binary is on your PATH
export SPARK_DIST_CLASSPATH=$(hadoop classpath)

# With explicit path to 'hadoop' binary
export SPARK_DIST_CLASSPATH=$(/path/to/hadoop/bin/hadoop classpath)

# Passing a Hadoop configuration directory
export SPARK_DIST_CLASSPATH=$(hadoop --config /path/to/configs classpath)
```
Download spark-x.x.x-bin-without-hadoop.tgz  

2. Prerequisite  
Spark runs on both Windows and UNIX-like systems (e.g. Linux, Mac OS). It’s easy to run locally on one machine — all you need is to have java installed on your system PATH, or the JAVA_HOME environment variable pointing to a Java installation.  

Spark runs on Java 8+, Python 2.7+/3.4+ and R 3.1+. For the Scala API, Spark 2.2.0 uses Scala 2.11. You will need to use a compatible Scala version (2.11.x).

**Optional installations**  
* sbt  
```shell
$ curl https://bintray.com/sbt/rpm/rpm | sudo tee /etc/yum.repos.d/bintray-sbt-rpm.repo
$ sudo yum install sbt
```
will install it under /usr/share/sbt and /usr/share/doc/sbt, start script is /usr/share/sbt/bin/sbt  
it can be downloaded at [sbt-download-url-1]  
some referencing script   
```shell
wget http://dl.bintray.com/sbt/rpm/sbt-0.13.5.rpm
sudo yum localinstall sbt-0.13.5.rpm
```
**Manually installation**:  
    * extract sbt-x.x.x.tgz to designated path,for instance, /usr/local/sbt
    * add {install_path}/bin to $PATH
    * use {install_path}/bin/sbt script
```shell
## verify if installed successfully
$ sbt sbt-version
```
**Extremely Manually installation**:  
    * only sbt-launch.jar is required, put it under designated path,for instance, /usr/local/sbt
```shell
wget https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.9/sbt-launch.jar -O ./sbt-launch.jar
```
    * create a script as {install_path}/bin/sbt, whose content is as below, 
```shell
#!/bin/bash
SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=256M"
java $SBT_OPTS -jar `dirname $0`/sbt-launch.jar "$@"
```

* Scala  
    * Download scala package and extract it  
    [scala-download-url-1]  
    * config environment variable SCALA_HOME and PATH

* python  
    1. install via EPEL repository  
    Red Hat has added Python 3.4 for CentOS 6 and 7 through the EPEL repository.  
    **[EPEL] How to install Python 3.4 on CentOS 6 & 7**  
    ```shell
    $ sudo yum install -y epel-release
    $ sudo yum install -y python34
    # Install pip3
    $ sudo yum install -y python34-setuptools  # install easy_install-3.4
    $ sudo easy_install-3.4 pip
    # I guess you would like to install virtualenv or virtualenvwrapper
    $ sudo pip3 install virtualenv
    $ sudo pip3 install virtualenvwrapper
    ```
    2. manually compile any version
        1. install dependencies  
        ```shell
        $ yum -y install bzip2-devel expat-devel gdbm-devel ncurses-devel openssl-devel  readline-devel sqlite-devel tk-devel zlib-devel
        # or else install more dependencies if required
        $ yum -y install bzip2-devel bzip2-libs expat-devel gdbm-devel ncurses-devel openssl openssl-devel openssl-static readline readline-devel readline-static sqlite-devel tk-devel zlib-devel
        ```
        2. install python  
        ```shell
        $ wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz
        $ tar -xzvf Python-3.6.0.tgz -C  /tmp
        $ cd /tmp/Python-3.6.0/
        $ ./configure --prefix=/usr/local
        $ make
        $ make altinstall
        ```
        in order to install a collateral version to system default version, use `make altinstall`,  to install on an alternative installation directory, pass --prefix={path} to the `configure` command.   
        3. change environment settings  
        After the make install step: In order to use your new Python installation, it could be, that you still have to add the [prefix]/bin to the $PATH and [prefix]/lib to the $LD_LIBRARY_PATH (depending of the --prefix you passed)  
        python3.6 executables：/usr/local/bin/python3.6  
        pip3 executables：/usr/local/bin/pip3.6  
        pyenv3 executables：/usr/local/bin/pyenv-3.6  
        4. optional, change other possible dependencies  
            1. change /usr/bin/python links, optional, depending on step 3   
            ```shell
            $ cd/usr/bin
            $ mv python python.backup
            $ ln -s /usr/local/bin/python3.6 /usr/bin/python
            $ ln -s /usr/local/bin/python3.6 /usr/bin/python3
            ```
            2. change yum scripts' python dependency, optional?   
            ```shell
            $ cd /usr/bin
            $ ls yum*
            yum yum-config-manager yum-debug-restore yum-groups-manager
            yum-builddep yum-debug-dump yumdownloader
            # change headers from #!/usr/bin/python to #!/usr/bin/python2
            ```
            3. modify gnome-tweak-tool configuration file, optional?  
            ```shell
            $ vi /usr/bin/gnome-tweak-tool
            # from #!/usr/bin/python to #!/usr/bin/python2
            ```
            4. modify urlgrabber configuration file, optional?
            ```shell
            $ vi /usr/libexec/urlgrabber-ext-down
            # from #!/usr/bin/python 改为 #!/usr/bin/python2
            ```

3. Spark Installation   
Simply extract archive file to designated directory  
```shell
$ sudo tar -zxvf spark-2.2.0-bin-without-hadoop.tgz -C /usr/local
```
4. Config environment variables  
    1. Master Server  
        1. edit ~/.bashrc  
        ```shell
        export SPARK_HOME=/usr/local/spark
        export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
        ```
        2. edit slaves  
        ```shell
        $ cd /usr/local/spark/
        $ cp ./conf/slaves.template ./conf/slaves
        # remove localhost from slaves
        $ vi ./conf/slaves
        Mark
        Luke
        ```
        3. edit spark_env.sh          
        ```shell
        $ cp ./conf/spark-env.sh.template ./conf/spark-env.sh
        export SPARK_DIST_CLASSPATH=$($HADOOP_HOME/bin/hadoop classpath)
        export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
        export SPARK_MASTER_IP=192.168.31.215
        ```
    2. copy all spark files and .bashrc to corresponding directories of other slave servers    
    ```shell
    $ tar -zcvf ~/workspace/tmp/spark.tar.gz /usr/local/spark
    $ scp ~/workspace/tmp/spark.tar.gz hadoop@Mark:~/
    $ scp ~/.bashrc hadoop@Mark:~
    $ scp ~/workspace/tmp/spark.tar.gz hadoop@Luke:~/
    $ scp ~/.bashrc hadoop@Luke:~
    ```
    3. on each slave server, extract spark file to designated directory  
    ```shell
    $ sudo tar -zxvf ~/spark.tar.gz -C /usr/local
    ```

5. start spark cluster  
    1. start hadoop server
    2. start master server  
    ```shell
    $ cd /usr/local/spark/
    $ sbin/start-master.sh
    ```
    jps result:  
    Matthew(Master)  
    6835 SecondaryNameNode  
    6628 NameNode  
    7830 JobHistoryServer  
    7416 ResourceManager  
    14891 `Master`  
    3. start slave servers
    ```shell
    $ sbin/start-slaves.sh
    ```
    Mark/Luke(Slaves)  
    5217 NodeManager  
    4866 DataNode  
    37876 `Worker`  
    4. Verification  
    User http://Matthew:8080 to monitor spark cluster status 
6. stop spark server  
```shell
$ sbin/stop-slaves.sh
$ sbin/stop-master.sh
```

### Spark Installation issues
#### sbt installation issues
注意：由于网络的原因，所以当你输入sbt命令的时候，会出现卡着的情况，实际上这是在下载相关的依赖包，一定要耐心等！我直接开了后台进程等让它慢慢下载的，估计好几个小时...另外由于sbt默认的repository是maven，里面有些会被墙, 因此建议使用oschina的repository, 3 ways:  
1. repositories file  
```shell
$ cd ~/.sbt/
$ touch repositories
$ vim repositories
```
Content of repositories is:  
```html
[repositories]  
local  
osc: http://maven.oschina.net/content/groups/public/  
typesafe: http://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly  
sonatype-oss-releases  
maven-central  
sonatype-oss-snapshots  
```
2. change sbt-launch.jar  
```shell
$ wget https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/0.13.9/sbt-launch.jar -O ./sbt-launch.jar      # 下载
$ unzip -q ./sbt-launch.jar
```
需要修改其中的 ./sbt/sbt.boot.properties 文件（vim ./sbt/sbt.boot.properties），将 [repositories] 处修改为如下内容（即增加了一条 oschina 镜像，并且将原有的 https 镜像都改为相应的 http 版）：
```html
[repositories]
  local
  oschina: http://maven.oschina.net/content/groups/public/
  jcenter: http://jcenter.bintray.com/
  typesafe-ivy-releases: http://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly
  maven-central: http://repo1.maven.org/maven2/
```
保存后，重新打包 jar：
```shell
jar -cfM ./sbt-launch.jar .       
```
注意打包时，需要使用 -M 参数，否则 ./META-INF/MANIFEST.MF 会被修改，导致运行时会出现 “./sbt-launch.jar中没有主清单属性” 的错误。  
3. download offline repository packages  
http://pan.baidu.com/s/1eRO8pP4
extract code: jryh

另外有时候输入sbt的时候会提示一个lock文件，这个是在~/.sbt目录下面的boot文件夹下，删除即可。另外查看下载信息可查看boot文件夹下的update.log  

## Sqoop
Unzip binary installation file (sqoop-x.y.z.bin_*) from [hadoop_sqoop_homepage_1] and set environment variable: SQOOP_HOME.  
```shell
export SQOOP_HOME=/usr/local/
export PATH=$PATH:$SQOOP_HOME/bin
```

## Flume
Download a stable release of the Flume binary distribution from the [Flume Download Page], and unpack the tarball in a suitable location:  
```shell
$ export FLUME_HOME=~/sw/apache-flume-x.y.z-bin
$ export PATH=$PATH:$FLUME_HOME/bin
```
A Flume agent can then be started with the `flume-ng` command.

## Hive
**Prerequisite**:   
1. version compatible as per release notes  
2. making sure that the hadoop executable is on the path or setting the HADOOP_HOME environment variable.

**Installation**:  
1. Download a release ([Apache Hive Download]), and unpack the tarball in a suitable place on your workstation:   
```shell
$ tar xzf apache-hive-x.y.z-bin.tar.gz 
```
2. It’s handy to put Hive on your path to make it easy to launch:   
```shell
$ export HIVE_HOME=~/sw/apache-hive-x.y.z-bin % export PATH=$PATH:$HIVE_HOME/bin
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

## HBase 
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

In standalone mode, the HBase master, the regionserver, and a ZooKeeper instance are all run in the same JVM.  

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

Shut down your HBase instance by running:
```shell
$ stop-hbase.sh
```

## git 
https://stackoverflow.com/questions/21820715/how-to-install-latest-version-of-git-on-centos-6-x-7-x  

* Install from 3rd party repository  
```shell
## For CentOS 7.x
$ yum install http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
## For CentOS 6.x
$ yum install http://opensource.wandisco.com/centos/6/git/x86_64/wandisco-git-release-6-1.noarch.rpm

$ yum install git
```
* From a untried but looking-promising source  
Rackspace maintains the ius repository, which contains a reasonably up-to-date git (edit: remove stock git first):   
 ```shell
 $ sudo yum remove git
 $ sudo yum install epel-release
 $ sudo yum install https://centos6.iuscommunity.org/ius-release.rpm
 $ sudo yum install git2u

 ## edit: CentOS 7.2 instructions (thanks ksopyła!):
 $ sudo yum remove git
 $ sudo yum install epel-release 
 $ sudo yum install https://centos7.iuscommunity.org/ius-release.rpm
 $ sudo yum install git2u
 ```
* Compile and Install any version on CentOS 7.x 
    1. Install Compile Tools & Required Packages
    ```shell
    ## Compile Tools
    ## or use yum install "Development Tools"
    $ yum -y groupinstall "Development Tools"
    ## Dependencies
    $ yum -y install zlib-devel perl-CPAN perl-devel perl-ExtUtils-MakeMaker asciidoc xmlto openssl-devel gettext-devel
    ```
    2. Uninstall old Git RPM  
    Now remove any prior installation of Git through RPM file or Yum package manager. If your older version is also compiled through source, then skip this step.  
    ```shell
    $ yum remove git
    ```
    3. Download and Compile Git Source  
    ```shell
    $ cd /usr/src
    $ wget https://www.kernel.org/pub/software/scm/git/git-2.5.3.tar.gz
    $ tar xzf git-2.5.3.tar.gz
    ```

    ```shell
    $ cd git-2.5.3
    $ ./configure --prefix=/usr/local/git
    $ make && make install
    ```
    4. Set up environment variables  
    ```shell
    $ export PATH="/usr/local/git/bin:$PATH"
    ```
    5. Check Git Version  
    ```shell
    $ git --version
    git version 2.5.3
    ```
    http://git-scm.com/book/en/v2/Getting-Started-Installing-Git  
* Compile and Install any version on CentOS 6.x 
    1. Install Required Packages
    ```shell
    $ yum install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
    $ yum install  gcc perl-ExtUtils-MakeMaker
    ```
    2. Uninstall old Git RPM  
    Now remove any prior installation of Git through RPM file or Yum package manager. If your older version is also compiled through source, then skip this step.  
    ```shell
    $ yum remove git
    ```
    3. Download and Compile Git Source  
    ```shell
    $ cd /usr/src
    $ wget https://www.kernel.org/pub/software/scm/git/git-2.5.3.tar.gz
    $ tar xzf git-2.5.3.tar.gz
    ```
    ```shell
    $ cd git-2.5.3
    $ make prefix=/usr/local/git all
    $ make prefix=/usr/local/git install
    $ echo 'export PATH=$PATH:/usr/local/git/bin' >> /etc/bashrc
    ## or
    $ echo 'export PATH=$PATH:/usr/local/git/bin' > /etc/profile.d/git.sh

    $ chmod +x /etc/profile.d/git.sh
    $ source /etc/bashrc
    ```
    4. Check Git Version  
    ```shell
    $ git --version
    git version 2.5.3
    ```
    http://git-scm.com/book/en/v2/Getting-Started-Installing-Git

## Virtual Box
### How to clone a virtual machine
1. VirtualBox下通过复制已存在的vdi文件可以快速创建新的虚拟机
    1. 点击新建(ctrl + n)
    2. 设置虚拟电脑名称和系统类型；
    3. 分配内存大小；
    4. 修改已有的虚拟硬盘文件(vdi文件)的UUID, 然后选择使用  
    ```shell
    cd ${VirtualBox_Install_Dir}
    vboxmanage internalcommands sethduuid “F:\WinXP Lab\WinXP Lab.vdi”
    ```
    问题：利用virtualbox新建了一个VM，然后使用virtualbox提供的复制功能拷贝了一个实例，发现新的VM的网卡eth0的MAC地址和原来的一样，或者eth0不见了  
    解决办法：  
    通过查看新VM的文件/etc/udev/rules.d/70-persistent-net.rules，发现多了几个网卡接口，我们每更新一次网卡MAC地址，都只会在该文件内追加信息。我们有两种方法解决该问题：  
        1. 删除70-persistent-net.rules文件，重启；
        2. 我们只需按照新VM的设置信息将70-persistent-net.rules文件内的多余网卡去掉，然后将正确MAC地址那一行改为对应于eth0即可，然后重启；      
    这几天为了配置hadoop的集群，在配置好伪分布式之后，直接采用复制的方法复制出其他虚拟机。但是复制出来的虚拟机网络有问题。下面是一些探索。使用的虚拟机是VBox。  
    * 首先是VBox虚拟机的复制。选择完全复制，重新分配mac地址。
        * 首先，ifconfig找不到除了lo之外的任何网卡。之前配置伪分布式的时候配置了eth0,eth1,eth2三个网卡。但是现在都找不到了。使用ifconfig -a出现eth4,eth7,但是ip地址等都未设置。出现这种情况是因为/etc/udev/rules.d/70-persistent-net.rules此文件里面是网卡对应的mac地址。复制过来的，所以还保持着原来的网卡与mac地址的对应关系。但是复制出来的虚拟机mac地址已经发生了改变。所以就找不到网卡了。
        * 所以，在/etc/network/interface里面配置的网卡需要改名字。从eth4开始，也可以在/etc/udev/rules.d/70-persistent-net.rules把之前重复的删掉。总之，要让网卡设置与mac地址对应起来。
        * RTNETLINK answers: File exists，这个问题，也是由于上面的问题。（好多博客说是NetworkManager冲突之类，但是自己的ubuntu系统压根没有装。）
        * 这里建议，尽量不要使用复制来配置虚拟机。因为如果新建，好多都默认配置好了。但是复制的话就会牵涉到好多底层的东西。  
    [VirtualBox-copy-VM-reset-network]  

### Shared Folder with Host Machine
1. Start VM Instance
2. Menu -> Devices -> Install Enhancement Functions  
    Might need to install dependencies for CentOS 6.5 before installation, in my case, no need.  
    ```shell
    yum install -y gcc gcc-devel gcc-c++ gcc-c++-devel make kernel kernel-devel
    shutdown -r now
    ```
3. Configure a shared folder for the VM Instance
4. Mount shared folder
```shell
mkdir #{mount_directory}
sudo mount -t vboxsf #{shared_folder_name} #{mount_directory}
#for example
mkdir /home/xingoo/shared
sudo mount -t vboxsf shared_file /home/xingoo/shared
```
By default, the folder is mounted automaticlly under /media/sf_{shared_folder_name}, owned by root, if auto-mounted is selected in VM instance setting

### Different network connection configurations
VMWare提供了三种工作模式(Similar with VirtualBox)，它们是bridged(桥接模式)、NAT(网络地址转换模式)和host-only(主机模式)。   
bridged相当于创建一台独立的电脑。你可以让它跟主机通信，但是网络需要手工配置
host-only是与主机隔离的，但是虚拟机之间是可以相互通信的   
NAT模式优点就是能够上网。   

1. bridged(桥接模式)  
在这种模式下，VMWare虚拟出来的操作系统就像是局域网中的一台独立的主机，它可以访问网内任何一台机器。在桥接模式下，你需要手工为虚拟 系统配置IP地址、子网掩码，而且还要和宿主机器处于同一网段，这样虚拟系统才能和宿主机器进行通信。同时，由于这个虚拟系统是局域网中的一个独立的主机 系统，那么就可以手工配置它的TCP/IP配置信息，以实现通过局域网的网关或路由器访问互联网。  
使用桥接模式的虚拟系统和宿主机器的关系，就像连接在同一个Hub上的两台电脑。想让它们相互通讯，你就需要为虚拟系统配置IP地址和子网掩码，否则就无法通信。  
2. host-only(主机模式)
在某些特殊的网络调试环境中，要求将真实环境和虚拟环境隔离开，这时你就可采用host-only模式。在host-only模式中，所有的虚拟系统是可以相互通信的，但虚拟系统和真实的网络是被隔离开的。  
提示:在host-only模式下，虚拟系统和宿主机器系统是可以相互通信的，相当于这两台机器通过双绞线互连。  
在host-only模式下，虚拟系统的TCP/IP配置信息(如IP地址、网关地址、DNS服务器等)，都是由VMnet1(host-only)虚拟网络的DHCP服务器来动态分配的。  
如果你想利用VMWare创建一个与网内其他机器相隔离的虚拟系统，进行某些特殊的网络调试工作，可以选择host-only模式。
3.  NAT(网络地址转换模式)  
使用NAT模式，就是让虚拟系统借助NAT(网络地址转换)功能，通过宿主机器所在的网络来访问公网。也就是说，使用NAT模式可以实现在虚拟 系统里访问互联网。NAT模式下的虚拟系统的TCP/IP配置信息是由VMnet8(NAT)虚拟网络的DHCP服务器提供的，无法进行手工修改，因此虚拟系统也就无法和本局域网中的其他真实主机进行通讯。采用NAT模式最大的优势是虚拟系统接入互联网非常简单，你不需要进行任何其他的配置，只需要宿主机器能访问互联网即可。

### Increase VDI disk size
[virtualbox-extend-vdi-capacity-url-1]  

对于VMDK是VMware开发并使用的，同时也被SUN的xVM、QEMU、SUSE Studio、.NET DiscUtils支持，所以兼容性会好些  
VDI是Virtual Box 自己的处理格式，而且Virtual Box支持Windows和Linux，所以对于使用VirtualBox的用户比较好  
VHD是Windows专有的处理格式，HDD是Apple专有的处理格式，所以不会支持跨平台，一般不会考虑  
LVM中有PV、VG、LV分别表示物理卷、卷组、逻辑卷  

1. resize VDI or VMDK  
    1. VDI  
    ```shell\Outerhaven\Softwares\VirtualBox\VBoxManage.exe modifyhd CenOS1.vdi --resize 1600;''/.-555555555555555555r5r5r5454ttttttttreetyyyyyyyyyyytyuioip;pl\xvq11q1     ``  e33e3ww2000p;lolollooololoollooloolloloolopllll;ll./.
    ```
    2. VMDK  
    VMDK converts to VDI, then extend  
    ```shell
    $ VBoxManage clonehd "xxxx.vmdk" "cloned.vdi" --format vdi  
    $ VBoxManage modifyhd "cloned.vdi" --resize 16000  //这里的单位是M  
    ```
    then convert back to VMDK
    ```shell
    $ VBoxManage clonehd "cloned.vdi" "resized.vmdk" --format vmdk
    # to list all cloned disks
    $ VBoxManage list hdds   
    ```
    下面就是在打开虚拟机--选个系统--右击--设置--存储--控制器SATA--右边的添加虚拟硬盘--选择克隆的文件就行了。  
2. Use LVM to extend  
LVM（Logic Volume Manager）  
    1. check before operation  
    ```shell
    $ sudo fdisk -l
    ```
    there are something like /dev/sda, /dev/sda1, /dev/sda2, etc.
    2. step 1  
    ```shell
    sudo fdisk /dev/sda
    ```
    input as below,  
    ```html
    Welcome to fdisk (util-linux 2.23.2).

    Changes will remain in memory only, until you decide to write them.
    Be careful before using the write command.


    Command (m for help): n
    Partition type:
       p   primary (2 primary, 0 extended, 2 free)
       e   extended
    Select (default p): p
    Partition number (3,4, default 3): 3
    First sector (16777216-32767999, default 16777216): 
    Using default value 16777216
    Last sector, +sectors or +size{K,M,G} (16777216-32767999, default 32767999): 
    Using default value 32767999
    Partition 3 of type Linux and of size 7.6 GiB is set

    Command (m for help): t
    Partition number (1-3, default 3): 3
    Hex code (type L to list all codes): 8e
    Changed type of partition 'Linux' to 'Linux LVM'

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.

    WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
    The kernel still uses the old table. The new table will be used at
    the next reboot or after you run partprobe(8) or kpartx(8)
    Syncing disks.
    ```
    reboot to make it effective  
    ```shell
    $ sudo reboot
    ```
    3. step 2, format to ext4  
    ```shell
    $ sudo mkfs.ext4 /dev/sda3  
    ```
    4, step 3, check volumn group  
    ```shell
    $ sudo vgdisplay
    ```
    part of result is as below, volumn group name is centos  
    ```html
      --- Volume group ---
      VG Name               centos
      ...
    ```
    5. step 4, create physic volumn  
    ```shell
    $ sudo pvcreate /dev/sda3
    WARNING: ext4 signature detected on /dev/sda3 at offset 1080. Wipe it? [y/n]: y
    Wiping ext4 signature on /dev/sda3.
    Physical volume "/dev/sda3" successfully created.
    ```
    6. step 5, extend pv to volumn group  
    ```shell
    $ sudo vgextend centos /dev/sda3
    ```
    7. step 6, check logic volumn and extend pv to it  
    ```shell
    $ sudo lvdisplay
    --- Logical volume ---
    LV Path                /dev/centos/root
    LV Name                root
    ...
    LV Size                <6.20 GiB
    ...
    ```
    /dev/centos/root is the logic volumn of root, where we want to extend  
    ```shell   
    # extend all available size 
    $ sudo lvextend /dev/centos/root /dev/sda3
    # or else, specify calculated size explicitly  
    $ sudo lvextend -L +6.96 /dev/centos/root 
    ```
    If there is an issue saying "Cannot change VG centos while PVs are missing", run following command    
    ```shell
    $ sudo vgreduce --removemissing centos
    ```

    8. step 7, extend LV's size   
    ```shell
    $ sudo xfs_growfs /dev/centos/root
    # command below is obsolete, only for reference.
    $ sudo resize2fs /dev/centos/root 
    ```
    reboot to make it effect  
    ```shell
    $ sudo reboot
    ```

### VirtualBox Misc
* 如果宿主机是windows经常需要来回的拷贝内容，那么可以打开【共享粘贴板】，步骤为：  
设备-->共享粘贴板-->双向

## Miscellaneous
### virtualenv
VirtualEnv helps you create a Local Environment(not System wide) Specific to the Project you are working upon.  

Hence, As you start working on Multiple projects, your projects would have different Dependencies (e.g different Django versions) hence you would need a different virtual Environment for each Project. VirtualEnv does this for you.

As, you are using VirtualEnv.. Try VirtualEnvWrapper : https://pypi.python.org/pypi/virtualenvwrapper  

It provides some utilities to create switch and remove virtualenvs easily, e.g:

mkvirtualenv <name>: To create a new Virtualenv  
workon <name> : To use a specified virtualenv  
and some others

---
[centos-download]:https://www.centos.org/download/ "CentOS Download"
[VirtualBox Download]:https://www.virtualbox.org/wiki/Downloads "VirtualBox Download"
[install-centos-on-virtualbox]:http://dblab.xmu.edu.cn/blog/164/ "install-centos-on-virtualbox"
[VirtualBox-copy-VM-reset-network]:https://cnzhx.net/blog/copy-centos-and-reset-network-in-vm/ "VirtualBox 中复制 CentOS 虚拟机并重设网络"
[hadoop-setup-single-node]:http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html "Hadoop: Setting up a Single Node Cluster."
[hadoop-multi-node-setup-1]:https://tecadmin.net/set-up-hadoop-multi-node-cluster-on-centos-redhat/ "How to Set Up Hadoop 1.x Multi-Node Cluster on CentOS 7/6"
[hadoop-multi-node-setup-2]:http://dblab.xmu.edu.cn/blog/install-hadoop-cluster/ "Hadoop集群安装配置教程_Hadoop2.6.0_Ubuntu/CentOS"
[sbt-download-url-1]:https://github.com/sbt/sbt/releases/download/v1.0.2/sbt-1.0.2.tgz "sbt download url"
[scala-download-url-1]:http://www.scala-lang.org/download/ "scala download url"
[virtualbox-extend-vdi-capacity-url-1]:http://blog.csdn.net/onlysingleboy/article/details/38562283 "VirtualBox虚拟机linux(CentOS)扩容 (不破坏已有文件 增加原先设置的大小  扩容至根目录)"
[Apache Hive Download]:http://hive.apache.org/downloads.html "Apache Hive Download"
[Apache HBase Download]: http://www.apache.org/dyn/closer.cgi/hbase/ "Apache HBase Download"