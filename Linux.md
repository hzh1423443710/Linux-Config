# Linux

## 用户和权限

**相关配置文件:**

```bash
/etc/passwd		# 用户配置
/etc/shadow		# 加密后的用户密码
/etc/group		# 组配置
```

- passwd

```bash
$ passwd -S <user> 	# 查看用户密码状态(--status)
```

- useradd, userdel

```bash
# useradd 后自动创建的目录
`/home/user`
`/var/spool/mail/user`
`/var/mail/user`

$ useradd -g <gid> <user>	# 创建用户 并指定gid和主组
$ useradd -G <group> <user>	# 创建用户 并指定附加组

$ userdel -r 				# 连带删除 创建的目录
```

- usermod

```bash
$ usermod -s /sbin/nologin <username>	# 指定 禁用登录shell
$ usermod -G <group>... <user>			# 设置 用户的附加组
$ usermod -g <gid> <user>				# 修改 用户组id和主组
```

- gpasswd

```bash
$ gpasswd -a <user> <group>				# 添加 用户到组
$ gpasswd -M <user0,user1,...> <group>	# 设置 组的成员列表(--member)
$ gpasswd -d <user> <group>				# 从组中删除用户
```

- mode权限位

umask配置文件: `/etc/bashrc` `~/.bashrc`

**uid**(rel uid)与**euid**(effective uid)与**suid**(SetUID),**sgid**(SetGID)

> uid : 真正执行可执行文件的用户id
>
> euid: 如果设置了suid, euid为可执行文件的属主, 否则等于uid
>
> suid: SetUID, 可以让用户以文件属主的用户运行程序

```bash
# 修改mode
$ chmod <u|g|o|a> <+|-|=> <rwx> <file>
$ chmod <mode> <file>
$ chmod u+s <exe-file>						# 给可执行文件添加SetUID权限

# 修改owner或group -R 递归
$ chown <owner> <file>
$ chown <owner>:[group] <file>
$ chown [owner]:<group> <file>

# 修改group -R 递归
$ chgrp <group> <file>

# 修改权限掩码 目录默认777 文件默认666
# real mode = default mode - umask
$ umask <mask>
```

- ACL(Access Control List)

```bash
$ chacl getfacl setacl
$ getfacl -e <file>			# 查看 所有有效权限

# -m (--modify)
$ setfacl -m <u:user:rwx> <file>	# 设置 file对用户 user0 的权限为rwx
$ setfacl -m <g:group:rwx> <file>	# 设置 file对群组  group 的权限为rwx

# -x (--remove) 删除 指定<用户>或<群组>的ACL权限
$ setfacl -x <u:user> <file>		# 删除 file对user的ACL

# -b (--remove-all) 删除 所有的acl权限
$ setfacl -b <file>

# d (--default) 设置 目录的默认ACL权限
$ setfacl -m <d:u:user:rw> <dir>	# dir目录下新建的文件 user都有rw权限

# -R 递归设置ACL权限
$ setfacl -m <u:user:rx> -R <dir>

# -k 删除默认ACL权限
$ setfacl -k <file>					# 删除 设置的默认ACL权限

# m 设置ACL中的mask
$ setfacl -m <m:rwx> <file>			# 设置 文件file的mask为rwx
```



## 软件管理

### rpm

- 相关参数

```bash
# 安装(包全名)
-ivh <rpm>		# 安装.install verbose 显示进度

# 卸载(包名)
-evh <rpm> 		# 卸载(erase)
--nodeps		# 不检测依赖
--prefix		# 指定安装路径
--test			# 测试安装 只检测依赖不实际安装
--allmatche		# 存在多个版本,批量卸载

# 升级(包全名)
-Uvh <rpm>		# 更新/安装(无需旧版本)
-Fvh <rpm>		# 只更新(需有旧版本)

# 查询(指定包名)
-q <pkgname>	# 查询 软件包是否安装
-qa				# 查看 所有已安装的软件包(all)
-qp <rpm>		# 查询 未安装的信息
-qf	<file>		# 查询 文件属于哪个包(file)
-qi <pkgname>	# 查看 详细信息(info)
-qR <pkgname>	# 查询 依赖
-ql <pkgname>	# 查询 已安装软件包中包含的所有文件及各自安装路径(list)
-qc <pkgname>	# 查看 已安装软件包配套的配置文件(config)
-qd <pkgname>	# 查看 已安装软件包配套的帮助文档(doc)
```

- 构建rpm

```bash
$ dnf install rpm-build	# 安装rpm-build
$ rpmbuild [OPTIONS] <specfile>
$ -ba		# source and binary packages from <specfile>
$ -bb		# binary package only from <specfile>
$ -bs		# source package only from <specfile>
```

```bash
# specfile
# -- spec preamble
Name:
Version:
Release:
Summary:
License:
...
# -- spec body
%description
%build
%pre
%install
%files
%changelog
```



### yum/dnf

- 用法(root): yum和dnf命令一致, dnf执行更快

```bash
# 查询
$ dnf list installed
$ dnf list all
$ dnf list						# 查询 所有已安装和可安装的软件包
$ dnf list <pkgname>			# 查询 软件包的安装情况
$ dnf info <pkgname>			# 查询 软件包的详细信息
$ dnf search <keyword>			# 查询 含有keyword的包

# 安装
$ dnf install -y <pkgname>
# 升级
$ dnf -y update [pkgname]		# 升级 所有包或pkgname
# 卸载
$ dnf remove <pkgname>

$ dnf repolist [all|enabled|disabled] # 查看已配置的软件仓库
$ dnf clean all 				# 清理缓存
$ dnf makecache 				# 创建缓存 查看yum仓库是否配置成功
$ dnf provides <file> 			# 查询file是哪个包提供的(绝对路径)
$ dnf repoquery --list <pkgname># 等价于 rpm -ql <pkgname>		

# 只下载不安装zsh
$ dnf download --resolve zsh
$ dnf install  --downloadonly zsh --downloaddir=./
```

- 管理软件组

```bash
$ dnf group
$ dnf grouplist					# 查询 所有软件组
$ yum groupinfo <grpname>		# 查询 软件组,如yum groupinfo server
$ yum groupinstall <grpname>	# 安装 软件组
$ yum groupremove <grpname>		# 卸载 软件组
```

- dnf配置

配置文件:`/etc/dnf/dnfconf`

```bash
[main]                			# 全局配置                                   
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True	# 
skip_if_unavailable=False

# 配置 软件仓库
[Local]                                   
name=local
baseurl=file:///mnt
enabled=1
gpgcheck=0
```



### 软件源

- 配置yum仓库

配置文件:`/etc/yum.repos.d/`下的`*.repo`, 格式如下

```bash
[NAME]		# 容器名称
name=		# 描述
baseurl=	# ftp:// 或 file:// 或 http:// 或 本地yum源
enabled=	# enable=0 则表示此容器不生效
gpgcheck= 	# 如果为 1 则表示 RPM 的数字证书生效；如果为 0 则表示 RPM 的数字证书不生效。
gpgkey=		# 数字证书的公钥文件保存位置
```

- 创建本地yum源

```bash
$ yum install createrepo
$ createrepo --database <dir> # 将dir作为本地仓库目录,生成元数据信息
```



### config-manager

```bash
# 安装config-manager
$ yum -y install yum-utils					# yum
$ dnf install 'dnf-command(config-manager)'	# dnf

# 将url.repo 写入到yum/etc/yum.repos.d/下
$ yum-config-manager --add-repo <url>

# 启用/关闭 仓库 name为repo文件中的[]的内容
--enable <name> 
--disable <name>
```



## 磁盘管理

**分区标准:**

- MBR(Master Boot Record)

  位于第一个扇区,总大小512bytes, 主引导程序(Boot loader)446bytes, 分区表(Partition table)16*4bytes,因此最多4个主分区(3个主分区+1个拓展分区)

  MBR最多支持SCSI接口15个分区(12个逻辑分区),IDE接口63个分区(60个逻辑分区)

- GPT

**磁盘和分区命名规则:**

- SSD,SAS,SATA硬盘 用sd来标
- IDE硬盘          用hd来标识
- virtio磁盘       用vd标识
- xxyn: 第y块xx磁盘的第n个分区

**文件系统:**

- NTFS: 基于安全性的文件系统
- NFS: 网络文件系统
- ext: 标准Linux文件系统
- xfs: 日志文件系统



**磁盘查看:**

```bash
# df (disk free)
$ df -HT		# 查看 T(filesystem)和partition, H:1M=1000K h:1M=1024
$ df -H <dir>	# 查看 目录所在分区

# du (disk used)
$ du -sh <file> # 查看 文件或目录占用的磁盘空间
$ du -ah <file> # 统计子目录

# 查看或设置ext文件系统的卷标LABLE
$ e2lable <dev> [label] 

$ lsblk -f		# 查看块设备及文件系统
$ blkid			# 查看块设备UUID TYPE LABLE
```

**磁盘分区:**

```bash
# 重新读取分区表信息
$ partprobe

# 只MBR分区
$ fdisk -l 		# 查看 硬盘和分区

# 支持MBR,GPT分区
$ parted  
$ parted [<dev> -l] # 列出所有设备的分区
# 子命令
 $ select <dev>		# 选择设备
 $ print
 $ mklable/mktable	# 创建 分区表 gpt msdos
 $ rm <NUM>			# 删除 分区
 $ mkpart <name> <fs> <start> <end>	# 创建 gpt分区
 $ mkpart <primary/extended> <fs> <start> <end>	# 创建 msdos分区
```

**磁盘分区标签:**

```bash
$ wipefs <devfile>		# 查看磁盘上的文件系统签名 DEVICE TYPE UUID LABLE
$ wipefs -a <devfile>	# 擦除
```

### 格式化

```bash
$ fsck [opt] <dev>		# 检测和修复文件系统
# 格式化磁盘 写入文件系统
$ mkfs -t <dev>
$ mkfs.* <dev>
```

### 挂载

**临时挂载mount**

```bash
# 查看所有挂载的信息
$ mount
$ -v	# verbose
$ -t	# 挂载时指定文件系统, 要与mkfs指定的相同 不写会自动检测
$ -a 	# 检查并挂载/etc/fstab中的条目

# 1.使用设备名挂载
$ mount <dev> <mountpoint>
# 2.使用UUID挂载
$ mount -U <uuid> <mountpoint>
$ mount UUID="" <mountpoint>
# 3.使用LABEL挂载
$ mount -L <label> <mountpoint>
$ mount LABEL="" <mountpoint>

$ umount 	# 取消挂载
```

**持久化挂载**

- 配置文件:`/etc/fstab`

- 默认options:defaults <=> rw,suid,dev,exec,auto,nouser,async

- fstab文件格式:

```bash
<file system>     <dir>      <type>     <options>             <dump> <pass>
tmpfs             /tmp       tmpfs      nodev,nosuid           0        0
/dev/sda1         /          ext4       defaults,noatime       0        1
/dev/sda2         none       swap       defaults               0        0
# 第5个字段 0不备份 1备份
# 第6个字段 0不被fsck检查 1和2代表检测的优先级,1>2
```

### LVM逻辑卷

- 物理卷(pv) 

  ```bash
  $ pvs			# 显示简略信息
  $ pvdispaly		# 显示详细信息
  $ pvcreate		# create a phycial volume
  $ pvscan
  ```

- 卷组(vg) 

  ```bash
  $ vgs			# 显示简略信息
  $ vgdisplay		# 显示详细信息
  $ vgcreate		# create a volume group
  $ vgscan
  ```

- 逻辑卷(lv)

  - ```bash
    $ lvs 			# 显示简略信息
    $ lvdisplay		# 显示详细信息
    $ lvcreate		# create a logical volume
    $ lvscan		# 扫描所有的逻辑卷并显示状态,设备路径,大小
    $ lvextend -L 10G <lv>		# 扩容
    $ lvresize
    $ lvreduce
    ```
    
  - 逻辑卷缩容顺序:
  
    ```bash
    resize2fs: 缩容先缩容文件系统
    ```
  



### swap

```bash
$ mkswap
$ swapon
$ swapoff
```



## 服务管理

**用法:**

```bash
$ systemctl list-unit-files					# 列出 所有的单元文件
$ systemctl list-units --type service		# 列出 已加载的服务
$ systemctl --type=service --state running 	# 列出 运行的服务
$ systemctl status <service>				# 查看 服务状态

$ systemctl start   <service>				# 启动 服务
$ systemctl stop    <service>				# 停止 服务
$ systemctl restart <service>				# 重启 服务
$ systemctl reload  <service>				# 重新加载 配置文件
$ systemctl enable  <service>				# 开启 开机自启
$ systemctl disable <service>				# 关闭 开机自启
```

**nginx.service**

```bash
vim /lib/systemd/system/nginx.service
[Unit]
Description=nginx service
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/usr/local/nginx/sbin/nginx -s reload
ExecStop=/usr/local/nginx/sbin/nginx -s quit
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```



## 进程管理

### 进程状态

| 状态 |                            含义                            |
| :--: | :--------------------------------------------------------: |
|  D   | 不可中断的休眠状态(通常是I/O的进程)，可以处理信号，有 延迟 |
|  R   |          可执行状态&运行状态(在运行队列里的状态)           |
|  S   |    可中断的休眠状态之中（等待某事件完成），可以处理信号    |
|  T   |            停止或被追踪（被作业控制信号所停止）            |
|  Z   |                          僵尸进程                          |
|  X   |                         死掉的进程                         |
|  <   |                       高优先级的进程                       |
|  N   |                       低优先级的进程                       |
|  L   |                      有些页被锁进内存                      |
|  s   |      Session leader（进程的领导者），在它下面有子进程      |
|  t   |                   追踪期间被调试器所停止                   |
|  +   |                      位于前台的进程组                      |

> 1号进程(init/systemd) 接管孤儿进程

### 相关命令

**查看进程**

```bash
$ ps   					# 查看 当前终端运行的进程
$ ps -aux 	 			# 列出 所有进程
$ ps -ef       			# 显示所有命令,连带命令行
$ ps -eo pid,ppid,sid,pgrp,nlwp,cmd,stat # 格式化输出
$ pstree 	  			# 查看 进程树
$ top					# 任务管理器

$ kill -KILL -<pgrp> 	# 发给进程组
$ setsid 				# 创建一个新的会话
$ nohup <cmd>			# 忽略SIGHUP信号运行命令
$ strace				# 跟踪进程信号 strace -e trace=signal -p `<pid>`
```

**控制前台与后台进程**

```bash
# Ctrl + Z,  Ctrl + C
$ fg [%n]				# 将当前终端的后台作业切换到前台运行
$ bg [%n]				# 将当前终端的暂停作业切换到后台运行
$ ./a.out &				# 在后台执行
$ jobs					# 查看后台工作
```



### 优先级

- PRI:进程的优先级,表示程序被CPU执行的先后顺序,值越小进程的优先级别越高

- NI: nice值, 表示进程可被执行的优先级的修正数值, nice值不是进程的优先级, 但可以影响进程的优先值

| 优先级（PRI）范围 | **描述**   |
| ----------------- | ---------- |
| 0—99              | 实时进程   |
| 100—139           | 非实时进程 |

```bash
$ ps -l	# 长格式输出
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S     0    7249    7248  0  80   0 -  6069 do_wai pts/2    00:00:00 bash
0 S     0    7315    7249  0  80   0 - 62884 futex_ pts/2    00:00:03 fish
4 R     0    9814    7315  0  80   0 -  6504 -      pts/2    00:00:00 ps
# 调整nice值
$ nice [-n niceness] cmd	# niceness [-19,20]
$ renice [-n nicene] -p <pid> | -g <pgrp> | -u <user>
```



## 网络管理

网卡连接和路由的配置目录: `/etc/sysconfig/network-scripts/`

网络连接配置文件: `ifcfg-<con-name>`

路由配置文件:`route-<con-name>`

> **修改/删除/添加网络连接配置文件,重启NetworkManager服务或reapply网卡设备使配置立即生效**

| **参数**           | **说明**                                           |
| ------------------ | -------------------------------------------------- |
| **TYPE**           | 配置文件接口类型                                   |
| **BOOTPROTO**      | 系统启动地址协议(dncp,none)                        |
| **ONBOOT**         | 系统启动时是否激活                                 |
| **IPADDR**         | IP 地址                                            |
| **NETMASK**        | 子网掩码                                           |
| **GATEWAY**        | 网关地址                                           |
| **BROADCAST**      | 广播地址                                           |
| **HWADDR/MACADDR** | MAC 地址，只需设置其中一个，同时设置时不能相互冲突 |
| **PEERDNS**        | 是否指定 DNS，如果使用 DHCP 协议，默认为 yes       |
| **DNS{1, 2}**      | DNS 地址                                           |
| **USERCTL**        | 用户权限控制                                       |
| **NAME**           | 网络连接名称                                       |
| **DEVICE**         | 物理接口名称                                       |

| **Nmcli con modify**                | **Ifcfg-\***                            | **目的**                       |
| :---------------------------------- | :-------------------------------------- | :----------------------------- |
| **ipv4.method** manual              | **BOOTPROTO=**none或者static            | 静态指定ipv4的地址             |
| **ipv4.method** auto                | **BOOTPROTO=**dhcp                      | 动态获取ipv4的地址             |
| **ipv4.addresses**  ip地址/掩码长度 | **IPADDR=**x.x.x.x  **PREFIX=**掩码长度 | 设置静态ip地址及掩码长度       |
| **ipv4.gateway**  x.x.x.x           | **GATEWAY=**x.x.x.x                     | 设置网关地址                   |
| **ipv4.dns**      x.x.x.x           | **DNS1=**x.x.x.x                        | 设置dns地址                    |
| **autoconnect**  (yes\|no)          | **ONBOOT=**(yes\|no)                    | 设置是否自动连接               |
| **connection.id** ensxx             | **NAME=**ensxx                          | 配置网络连接名                 |
| **connection.interface-name** ensxx | **DEVICE=**ensxx                        | 配置网络连接所绑定的网络接口名 |

### nmcli

管理和配置 NetworkManager守护进程 控制的网络连接

nmcli: 命令方式编辑网络

nmtui: 文本交互界面编辑网络

连接(connection): 供设备使用的配置

设备(device): 网络接口

> **同一个设备可以存在多个连接,但只能有一个活动连接**
>
> **网关可以从VMware的网络编辑器中查看**

```bash
# con为ifcf-<con-name>中的con-name
# 连接
$ nmcli connection show [--active]		# 显示 连接(所有/活跃)
$ nmcli connection show <con>			# 显示 连接的详细信息
$ nmclie connection reload <con>		# 重新 加载连接的配置文件
# 设备
$ nmcli device status 					# 显示 设备状态
$ nmcli device show [dev]				# 显示 设备信息
$ nmcli device disconnect <dev>			# 断开 在dev上的连接
$ nmcli device reapply <dev>			# 重新 应用网络设备 使配置生效

# con-name:连接名 type:连接类型 ifname:物理网卡
# 添加 连接 
$ nmcli connection add con-name <name> type <Ethernet> ifname <ens33>
# 启动 关闭 连接
$ nmcli connection up <con>
$ nmcli connection down <con>
# 删除 连接
$ nmcli connection delete <con>
# 修改 连接
$ nmcli connection modify <con> ipv4.addresses <ip>/<24> gw4 <gw> ipv4.dns 8.8.8.8 autoconnect yes ipv4.method manual 				# 修改为静态ip
$ nmcli conn mod [+|-]ipv4.addresses <ip>/<24>	 # 添加或删除ip
```

### ip

```bash
# 查看NetworkManager配置下的ip地址
$ nmcli device show ens33 | grep ADDRESS
$ ip addr show [dev]
$ ifconfig [dev]
```

### DNS

域名解析服务器(Domain Name Server)

DNS解析配置文件:`/etc/resolv.conf`

**公共DNS**

- 谷歌:8.8.8.8, 8.8.4.4
- 中国电信:114.114.114.114, 114.114.115.115

**查看NetworkManager配置下的DNS列表**

```bash
$ nmcli device show ens33 | grep DNS
```

**查询DNS**

```bash
$ nslookup domain [dns-server]
# Example
$ nslookup cn.bing.com 114.114.115.115
Server:		114.114.115.115			# DNS ip地址
Address:	114.114.115.115#53		# DNS ip和端口

Non-authoritative answer:			# 非权威答案
Name:	cn.bing.com					# 域名
Address: 202.89.233.100				# 域名的ip地址
Name:	cn.bing.com
Address: 202.89.233.101
```

### 设置主机名

主机名文件: `/etc/hostname` 

- 临时设置: `hostname <new-name>`
- 永久设置: `hostnamectl set-hostname <new-name>`
- 修改 `/etc/hostname` 配置文件

### 主机解析

本地域名解析配置文件: `/etc/hosts`

格式: `ip<TAB>domain1.com domain2.com ...`

```bash
# 格式
$ ip<TAB>domain.com
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
39.156.66.18    www.baidu.com	baidu.com
39.156.66.14    www.baidu.com	baidu.com
# 注释取消 某条记录
```

> **可以删除当前网络连接的DNS进行测试**

### 路由

主机路由: 指定网络的一台主机

网络路由: 指定网络

```bash
# 查看NetworkManager配置下的路由表
$ nmcli device show ens33 | grep ROUTE
$ route -n
$ ip route show

# 添加/删除 路由(主机路由 网络路由)
$ route {add|del} {-net|-host} <dst> netmask <mask> [<gw> gateway] dev <dev>
# 添加 一条到192.168.77.0网络, 下一跳(gw)为192.168.72.2的路由, 从网卡ens33发送
$ route add -net 192.168.77.0 netmask 255.255.255.0 gw 192.168.72.2 dev ens33
# 删除 到192.168.77.0网络, 下一跳(gw)为192.168.72.2的路由, 从网卡ens33发送
$ route del -net 192.168.77.0 netmask 255.255.255.0 dev ens33

# nmcli 给连接添加静态路由
$ nmcli connection modify static1 +ipv4.routes "192.168.77.0/24 192.168.72.2"
```



## 任务管理

atd, crond 后台守护进程

### at

单次执行任务

用户执行权限配置文件:`/etc/at.allow` `/etc/at.deny`

任务搜索目录: `/var/spool/at` (at创建的任务文件存储目录)

> - **系统中有at.allow文件: 只有at.allow中的用户才可以使用at命令**
> - **两个文件有共同用户, at.allow优先级更高**
> - **系统中无at.allow文件: 除了at.deny中的用户都可以使用at命令**
> - **2个文件都不存在: 只有root才可以使用at命令**

```bash
$ at [选项] [时间]
$ -m				# 发送mail给用户
$ -c <num>			# 查询 任务内容(/var/spool/at下的任务文件)
$ -t 				# 指定 执行时间
$ -q <a-z>			# 队列 优先级a-z从低到高
$ -d				# 等价于atrm
$ -l				# 等价于 atq
$ -f <file>			# 执行脚本

$ atrm <num>...		# 删除 作业队列中的任务
$ atq				# 查看当前待执行的一次性计划任务
```

Example:

```bash
$ at now +1min			# 交互式(Ctrl+D退出)
```

### crontab

创建（编辑）、查看、删除用户的周期性计划任务

crond 进程每分钟会定期检查是否有要执行的任务,如果有,则会自动执行该任务

用户执行权限配置文件:`/etc/cron.allow` `/etc/cron.deny`

crond扫描任务的目录:`/var/spool/cron/`

系统级别配置任务:`/etc/crontab`

日志文件:`/var/log/cron`	用户查看任务是否顺利执行

**用户级别的计划任务**

普通用户可以配置的任务, 以当前身份去执行

``` bash
$ crontab
$ -u 		# 设置 某个用户的cron服务(root)
$ -l		# 列出 某个用户cron服务的详细内容
$ -r		# 删除 某个用户的cron服务
$ -e		# 编辑 某个用户的cron服务
```

**系统级别的计划任务**

root用户可以配置任何任务, 以任意用户身份去执行改任务

```bash
# crontab 文件格式
# 分(0-59) 时(0-23) 日(1-31) 月(1-12) 周(0-6) 执行此命令的用户 命令
# * * * * * username cmd
*  : 所有取值
*/5: 每5个单位
1-5: 从几到几
1,3: 离散的数字

# Example
$ 0  17  *  *  1-5			# 周一到周五每天17:00
$ 30  8  *  *1,3,5			# 每周一，三，五的8:30
$ 0  8-18/2  *  * *			# 8点到18点间每隔两小时
$ 1 10  */3  *  *			# 每隔3天的10点零1分执行
```



## 文本处理

### 正则

| 通配符 | 描述                                                         | 拓展正则 |
| :----- | :----------------------------------------------------------- | :------: |
| `[]`   | 匹配[]中的任意一字符, [a-z] [A-Z] [0-9]                      |          |
| `()`   | 标记 子表达式 起止位置                                       |    √     |
| `*`    | 匹配 前面的子表达式 零或多次                                 |          |
| `+`    | 匹配 前面的子表达式 一或多次                                 |    √     |
| `?`    | 匹配 前面的子表达式 零或一次                                 |    √     |
| `\`    | 转义字符                                                     |          |
| `.`    | 匹配除 `\n`（换行）外的任意单个字符                          |          |
| `{}`   | `{n}` 表示匹配前面子表达式 n 次;`{n,}` 匹配至少 n 次;`{n,m}` 匹配 n 至 m 次 |          |
| `|`    | 表明前后两项二选一                                           |    √     |
| `$`    | 匹配 字符串的结尾                                            |          |
| `^`    | 匹配 字符串的开头,                                           |          |
| [^abc] | 匹配 除abc的所有字符                                         |          |
| \s     | 表示 任意多个空白字符（包括空格和\t 没有\n)                  |    √     |
| \S     | 表示 不是空白的字符                                          |    √     |
| \w     | 表示 [0-9A-Za-z_]                                            |    √     |
| \b     | 表示单词的结束(\b并不占据位置进行匹配，它只检测接下来的字符是否为\w) |    √     |
| \W     | 和\w相反, 表示`[^0-9A-Za-z]`                                 |    √     |

**取代分组**

```bash
# 1. 调换日期位置
$ cat world
2023 11 11
2022 12 10
# \1是第一个括号内容 \2是第二个括号内容
$ cat world | sed -r 's/([0-9]{1,4}) ([0-9]{1,2}) ([0-9]{1,2})/\2-\3 \1/'
11-11 2023
12-10 2022
# 2. 注释1-10行
$ sed -r '1,10 s/(.*)/# \1/' < hello
```

**Example**

```bash
$ ls /bin | grep -n "^man\|man$"	# 以man开头 或 以man结尾
$ ls /bin | grep -E "^$"			# 匹配空行
```



### 文本命令

- **tee: 从标准输入读 同时写入到标准输出和文件**

```bash
$ ls | tee <file>
```

- **tr: 转换或删除 字符**

```bash
$ tr 'a-z' 'A-Z' < file
$ tr -d
```

- **sort: 排序**

```bash
$ -r 		# --reverse
$ -u 		# --unique
$ -o <file> # --output
$ -n 		# --numeric-sort
$ -R		# --random-sort
$ -f		# --ignore-case
```

- **uniq: 去重**

```bash
 -c			# 显示 重复次数
 -i			# 忽略 大小写
```

- **cut: 列处理**

```bash
$ cut -d<delimiter> -f<n1,n2> <file>
$ -d			# 分隔符
$ -f<n1,n2>		# n1到n2列
```

- **grep,egrep: 行过滤**

```bash
-E		# 拓展正则
-i		# 忽略大小写
-n		# 显示行号
-R 		# 递归
-v		# 反转匹配(invert-match)
-c   	# 打印 匹配的个数
-l		# 列出 匹配的文件名
```

- **sed: 单行或多行处理 从标准输入或文件中读取内存缓冲区, 对每一行做处理**

```bash
$ sed [options] command [input-file]
# [选项]
$ -n			# 取消默认全文打印,只显示命令操作行
$ -i			# 写入文件,不用-i修改的是内存缓冲区
$ -e			# 多次编辑 不需要管道符
$ -r/E			# 支持拓展正则(|不需要转义)
# sed command
$ a 			# append 指定行后 追加 一行/多行
$ i				# insert 指定行前 插入 一行/多行
$ d 			# delete 删除 一行/范围删除 
$ p 			# print  打印
$ s/old/new/g 	# substitute 替换(g:greedy) /也可以是#,@
$ c				# 对行/范围 替换
----------------------------------------------------------------------------------------
# 匹配
	# 1				# 指定 特定行 第一行
	# 1,5			# 指定 范围 1-5行
	# 1,+5			# 指定 范围 1-6 行
	# 1~2			# 步长2 从第1行开始
	# /pattern/		# 指定 模式

# p 打印
$ sed -n '/pattern/p'	# 打印 匹配行
$ sed -n '/pattern/!p'	# 打印 非匹配行
$ sed -n '1,10p'		# 打印 1-10行
$`sed -n '$p'  			# 打印 最后一行
$ sed -n '1,$p' 		# 打印 1到最后一行
# d 删除
$ sed '/pattern/d'	# 删出 匹配行
$ sed '/pattern/!d'	# 删除 非匹配行
$ sed '1,10d'		# 删除 1-10行
# c 替换
$ sed '1c hello' 	# 替换第一行
# i	插入
$ sed '/pattern/i <txt>'				# 匹配行前 插入txt
# a 追加
$ sed '/pattern/a <txt>'				# 匹配行后 插入txt

# -i 写入文件
$ sed -i 's/hello/world/g' <file>				# 写入文件
$ sed -i.<suffix> 's/hello/world/g' <file>		# 备份到<file>.<suffix>中
# -e 多次编辑 
$ sed -n -e '1,4 p' -e '6,7 p' <file>			# 打印1-4和6-7行
```

- **awk: 列处理** 

```bash
# awk [option] 'pattern{program}' file
# program
	# 逗号 表示字段输出分隔符
	# 有多条脚本命令组成
# [option]
$ -F <separator> 	# 指定 字段分隔符separator
$ -v <val>=val		# 自定义变量或修改一个内部变量
$ -f <file>			# 从文件中读取awk脚本命令 内容如:{print $0}
```

| awk内置变量    | 解释                                     |                |
| :------------- | :--------------------------------------- | -------------- |
| FS             | 输入 字段分隔符(Filed Separator)         | 默认空格" "    |
| OFS            | 输出 字段分隔符(Output Filed Separator)  | 默认空格" "    |
| RS             | 输入 记录分隔符(Record Separator)        | 默认换行"\n"   |
| ORS            | 输出 记录分隔符(Output Record Separator) | 设置输出换行符 |
| NF             | 当前 行的字段数(Number Of Filed)         |                |
| NR             | 匹配行在文件中的行号(Number of Records)  |                |
| FNR            | 多文件时显示各文件的行号                 |                |
| FILENAME       | 当前 文件名                              |                |
| ARGC           | 命令行参数的个数                         |                |
| ARGV           | 命令行参数                               |                |
| $0             | 整行                                     |                |
| $1, $2...$NF   | First, second,...,last field             |                |
| BEGIN{program} | 操作文件前 执行awk program               |                |
| END{program}   | 操作文件后 执行awk program               |                |

**BEGIN和END**

```bash
$ BEGIN          {<initializations>} 	# 执行文件后 要执行的program
$    <pattern 1> {<program actions>} 	# 模式匹配 执行的program
$    <pattern 2> {<program actions>} 
$    ...
$ END            {< final actions >}	# 执行文件后 要执行的program
```

**格式化输出printf**

```bash
# 同C语言的printf, 输出用户名和家目录
awk -F: 'BEGIN {
    printf "%-10s %s\n", "User", "Home"
    printf "%-10s %s\n", "----","----"}
    { printf "%-10s %s\n", $1, $(NF-1) }
' /etc/passwd | head -n 5
```

**定义变量**

```bash
# 自定义变量
$ awk -v var1="Hello" -v var2="Wold" 'END {print var1, var2} ' </dev/null
# 使用shell变量(通过-v传递到自定义变量)
awk -v varName="$PWD" 'END {print varName}' </dev/null
```

**变量关系运算**

```bash
$ <
$ <=
$ ==
$ !=
$ >
$ >=
$ ~		# 正则 匹配
$ !~	# 正则 不匹配

# $1 ~ /regex/		字段匹配 
$ awk '$0 ~ /sh$/' /etc/passwd								# 查找 有shell的用户
# $1 !~ /regex/ 	字段不匹配
$ awk '$0 !~ /sh$/' /etc/passwd								# 查找 无shell的用户
```

**模式匹配**

```bash
# 1. /regex/ 行匹配
$ awk -F: '/^hzh/{print $1, $(NF-1), $NF}' /etc/passwd		# 查找 hzh开头的用户
# 2. !/regex/ 行不匹配
$ awk -F: '!/bin.*sh/{print NR,$1}' /etc/passwd				# 查找 不能登录的用户
```

**范围匹配**

```bash
# 打印 3-10行
$ awk 'NR>=3&&NR<=10{print NR,$1}' /etc/passwd
# 打印 1-5行
$ awk 'NR==1,NR==5' /etc/passwd
# 打印 root-hzh之间的用户
$ awk '/^root/,/^hzh/{print NR,$1}' /etc/passwd
```

**Example:**

```bash
# 打印passwd中的 用户名 家目录 登录shell
$ awk -F":" '{print $1,$6,$NF}' passwd
# 例子: 打印可以登录的用户
awk '
    BEGIN { print "\n>>>Start" }
    !/(login|shutdown)/ { print NR, $0 }
    END { print "<<<END\n" }
' /etc/passwd
```



# 其他

Linux内核的许可证协议是GPL

开源软件概念首次提出与1998.2

社区发行版:Fedora,openEuler

商业发行版:ubuntu

openEuler是Linux社区发行版

- 正式开源于2019.9, 使用MulanPSL V2开源协议
- 正式发布的第一个版本20.03LTS

- 每半年发布一次创新版
- 每2年发布一次LTS版本,LTS的维护周期是4年.

- openEuler20.03 LTS OS内核版本4.19

**许可证:**

- 木兰宽松许可证(MulanPSL V2) 不具有传染性, 可独占
- GPL(GNU Public License) 具有传染性

## etc

```bash
$ /etc/shells		# 可用shell列表
$ /etc/os-release	# 系统信息
$ /etc/sudoers 		# sudo 权限的配置
$ /etc/os-release 	# 操作系统的版本信息
```

`&>` `&|`: 标准输出和标准错误一起

步长为2: echo{1..10..2}

tar和zip既打包又压缩, gzip,sz,bzip只压缩

find /var/weblogs -mtime +30 -delete

file: 查看文件类型

ulimit -a

划分swap分区

parted的使用
