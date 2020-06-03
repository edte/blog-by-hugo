查看 linux 硬件信息



proc 目录，在许多类 [Unix](https://zh.wikipedia.org/wiki/Unix) 计算机系统中， **procfs** 是 [进程](https://zh.wikipedia.org/wiki/进程) [文件系统](https://zh.wikipedia.org/wiki/文件系统) (file system) 的缩写，包含一个伪文件系统（启动时动态生成的文件系统），用于通过[内核](https://zh.wikipedia.org/wiki/内核)访问进程信息。这个文件系统通常被挂载到 `/proc` [目录](https://zh.wikipedia.org/wiki/目录_(文件系统))。由于 `/proc` 不是一个真正的文件系统，它也就不占用存储空间，只是占用有限的内存。这个目录可以用来查看许多硬件信息





ifconfig 命令，

ip 命令，是个网络管理命令

du 命令，显示每个文件和目录的磁盘使用空间。

df 命令用于显示目前在 Linux 系统上的文件系统的磁盘使用情况统计。

**lsblk 命令** 用于列出所有可用块设备的信息

lscpu 命令用于查看 cpu 信息

lshw 命令，lshw 命令读取 /proc 目录，可以查看许多硬件信息

uname 命令用于打印当前系统相关信息（内核版本号、硬件架构、主机名称和操作系统类型等）

lspci 命令，顾名思义，就是显示所有的 pci 设备信息。

lsusb 命令，显示所有的 usb 设备信息。

dmesg 命令，用于显示开机信息。开机信息亦保存在 /var/log 目录中，名称为 dmesg 的文件里。

## cpu

lscpu 命令

查看 /proc/cpuinfo 目录

lshw 命令



## 查看系统体系结构。

uname -a



## 操作系统/内核

uname 命令

cat /proc/version



## 计算机名

hostname

##  列出加载的内核模块

lsmod

proc/modules 目录



## 查看环境变量

env



## 查看网卡硬件信息

```
lspci | grep -i 'eth'
```

## 查看系统的所有网络接口

```
ifconfig -a
```

```
ip link show
```

## 查看硬盘和分区分布

```
lsblk
```

## 看硬盘和分区的详细信息

```
fdisk -l
```

## 查看内存硬件信息

dmidecode -t memory

## 查看 bios 信息

```
dmidecode -t bios
```

## 查看显卡型号

lspci -vnn | grep VGA -A 12 

lshw -C display

lspci |grep VGA

## 查看当前 Linux 系统上所使用的显卡驱动名称

sudo lshw -c video | grep configuration



## 查看内存信息

cat /proc/meminfo



## 查看键盘和鼠标

cat /proc/bus/input/devices



##  查看所有进程

ps -ef             

## 实时显示进程状态

top

## 查看所有网络接口的属性

ifconfig

## 查看防火墙设置

iptables -L            

## 查看路由表

route -n

## 查看所有监听端口

netstat -lntp

## 查看所有已经建立的连接

netstat -antp

## 查看挂接的分区状态

mount | column -t      

## 查看所有分区

fdisk -l               

## 查看所有交换分区

swapon -s

## 查看内存使用量和交换区使用量

free -m

##  查看各分区使用情况

df -h

## 查看指定目录的大小

du -sh <目录名>

## 查看内存总量

grep MemTotal /proc/meminfo 

## 查看空闲内存量

grep MemFree /proc/meminfo 

## 查看系统运行时间、用户数、负载

uptime

## 查看系统负载

cat /proc/loadavg