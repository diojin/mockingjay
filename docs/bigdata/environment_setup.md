# 			BigData Environment Setup
---
## Indexes
* [Virtual Box with CentOS](#virtual-box-with-centos)
* [Hadoop](#hadoop)
* [Virtual Box](#virtual-box)
    - [How to clone a virtual machine](#how-to-clone-a-virtual-machine)
    - [Shared Folder with Host Machine](#shared-folder-with-host-machine)
    - [Different network connection configurations](#different-network-connection-configurations)
    - [Misc](#virtualbox-misc)
* [Miscellaneous](#miscellaneous)

## Virtual Box with CentOS
1. Download latest VirtualBox: [VirtualBox Download]  
Version: 5.1.28  
2. Download latest CentOS ISO: [centos-download]
Version: CentOS-7 (1708)
3. install CentOS on VirtualBox
    1. follow [install-centos-on-virtualbox], which uses CentOS6.4    
    2. Different settings between CentOS6.4 and CentOS7
        1. Select bridged model in network configuration of the VM
        Refer to [Different network connection configurations](#different-network-connection-configurations)
        2. During installation
            1. Select "GNOME Desktop" as SOFTWARE SELECTION
            2. Disable KDUMP
            3. Enable NETWORK

## Hadoop
1. Create Hadoop user
```shell
> su
> useradd -m hadoop -g root -s /bin/bash
# setup password
> passwd hadoop 
# add user hadoop as administrator
> visudo            #  equals to "vi /etc/sudoers"
```
2. 

1. Required softwares for Linux include  
    [hadoop-setup-single-node]  
    1. Java™ must be installed. JAVA 1.7
    2. ssh must be installed and sshd must be running to use the Hadoop scripts that manage remote Hadoop daemons.


In general, it is recommended that HDFS and YARN run as separate users. In the majority of installations, HDFS processes execute as ‘hdfs’. YARN is typically using the ‘yarn’ account.


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
    May need to install dependencies for CentOS 6.5 before installation
    ```shell
    yum install -y gcc gcc-devel gcc-c++ gcc-c++-devel make kernel kernel-devel
    shutdown -r now
    ```
3. Configure a shared folder for the VM Instance
4. Mount shared folder
```shell
sudo mount -t vboxsf #{shared_folder_name} #{mount_directory}
#for example
sudo mount -t vboxsf shared_file /home/xingoo/shared
```

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

### VirtualBox Misc
* 如果宿主机是windows经常需要来回的拷贝内容，那么可以打开【共享粘贴板】，步骤为：  
设备-->共享粘贴板-->双向

## Miscellaneous

---
[centos-download]:https://www.centos.org/download/ "CentOS Download"
[VirtualBox Download]:https://www.virtualbox.org/wiki/Downloads "VirtualBox Download"
[install-centos-on-virtualbox]:http://dblab.xmu.edu.cn/blog/164/ "install-centos-on-virtualbox"
[VirtualBox-copy-VM-reset-network]:https://cnzhx.net/blog/copy-centos-and-reset-network-in-vm/ "VirtualBox 中复制 CentOS 虚拟机并重设网络"
[hadoop-setup-single-node]:http://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html "Hadoop: Setting up a Single Node Cluster."