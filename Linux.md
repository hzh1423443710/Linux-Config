# Linux

## 用户和权限

**相关配置文件**

1. `/etc/passwd`：用户帐号信息文件
2. `/etc/shadow`：用户帐号信息加密文件
3. /etc/gshadow：用户组信息加密文件
4. `/etc/group`：组信息文件
5. `/etc/default/useradd`：定义`useradd`命令的默认设置，包括新建用户时的一些默认配置，如默认的Shell、默认的用户组等
6. `/etc/login.defs`：系统广义设置文件.系的登录定义文件，用于定义用户登录的行为和限制条件，如密码策略、登录超时等.
7. `/etc/skel`：默认的初始配置文件目录,其中存放着系统创建新用户时所使用的默认配置文件和目录结构。当创建新用户时，系统会将`/etc/skel`目录中的内容复制到新用户的家目录中

### 用户和组

useradd, userdel

自动创建的目录:`/home/user`,`/var/spool/mail/user`,`/var/mail/user`

```bash
$ useradd -g <gid> <user>    # 创建用户 并指定gid和主组
$ useradd -G <group> <user>    # 创建用户 并指定附加组

$ userdel -r                 # 连带删除 创建的目录
```

- passwd

```bash
$ passwd -S <user>     # 查看用户密码状态(--status)
```

- usermod

```bash
$ usermod -s /sbin/nologin <username>    # 指定 禁用登录shell
$ usermod -G <group>... <user>            # 设置 用户的附加组
$ usermod -g <gid> <user>                # 修改 用户组id和主组
```

- gpasswd

```bash
$ gpasswd -a <user> <group>                # 添加 用户到组
$ gpasswd -d <user> <group>                # 从组中删除用户
$ gpasswd -M <user0,user1,...> <group>    # 设置 组的成员列表(--member)

$ newgrp <grp>            # 切换用户组
```

### mode权限位

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
$ chmod u+s <exe-file>                        # 给可执行文件添加SetUID权限

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

### ACL

访问控制列表(Access Control List)

```bash
$ chacl getfacl setacl
$ getfacl -e <file>					# 查看 所有有效权限

# -m (--modify)
$ setfacl -m <u:user:rwx> <file>   	# 设置 file对用户 user0 的权限为rwx
$ setfacl -m <g:group:rwx> <file>	# 设置 file对群组  group 的权限为rwx

# -x (--remove) 删除 指定<用户>或<群组>的ACL权限
$ setfacl -x <u:user> <file>        # 删除 file对user的ACL

# -b (--remove-all) 删除 所有的acl权限
$ setfacl -b <file>

# d (--default) 设置 目录的默认ACL权限
$ setfacl -m <d:u:user:rw> <dir>    # dir目录下新建的文件 user都有rw权限

# -R 递归设置ACL权限
$ setfacl -m <u:user:rx> -R <dir>

# -k 删除默认ACL权限
$ setfacl -k <file>                    # 删除 设置的默认ACL权限

# m 设置ACL中的mask
$ setfacl -m <m:rwx> <file>            # 设置 文件file的mask为rwx 
```

###### 

## 软件管理

### rpm

- 相关参数

```bash
# 安装(包全名)
-ivh <rpm>        # 安装.install verbose 显示进度

# 卸载(包名)
-evh <rpm>      # 卸载(erase)
--nodeps        # 不检测依赖
--prefix        # 指定安装路径
--test			# 测试安装 只检测依赖不实际安装
--allmatche 	# 存在多个版本,批量卸载

# 升级(包全名)
-Uvh <rpm>		# 更新/安装(无需旧版本)
-Fvh <rpm>		# 只更新(需有旧版本)

# 查询(指定包名)
-q <pkgname>	# 查询 软件包是否安装
-qa             # 查看 所有已安装的软件包(all)
-qp <rpm>       # 查询 未安装的信息
-qf <file>		# 查询 文件属于哪个包(file)
-qi <pkgname>	# 查看 详细信息(info)
-qR <pkgname>	# 查询 依赖
-ql <pkgname>	# 查询 已安装软件包中包含的所有文件及各自安装路径(list)
-qc <pkgname>	# 查看 已安装软件包配套的配置文件(config)
-qd <pkgname>	# 查看 已安装软件包配套的帮助文档(doc)
```

- 构建rpm包

```bash
$ dnf install rpm-build    # 安装rpm-build
$ rpmbuild [OPTIONS] <specfile>
$ -ba	# source and binary packages from <specfile>
$ -bb	# binary package only from <specfile>
$ -bs	# source package only from <specfile>
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



### dnf

- 全局配置文件`/etc/dnf/dnf.conf`
  
  - "main"部分保存着DNF的全局设置。
  
  - "repository"部分保存着软件源的设置，可以有零个或多个"repository"。

> ​    配置repository部分有两种方式，一种是直接配置`/etc/dnf/dnf.conf`文件中的“repository”部分，另外一种是配置`/etc/yum.repos.d`目录下的.repo文件。

```bash
# 全局配置
[main]                         
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True    # 
skip_if_unavailable=False

# repository
[repoid]    # 软件仓库（repository）的ID号 不能重复
name=		# 描述
baseurl=    # ftp:// 或 file:// 或 http:// 或 本地软件源
enabled=    # enable=0 则表示此容器不生效
gpgcheck=	# 如果为 1 则表示 RPM 的数字证书生效；如果为 0 则表示 RPM 的数字证书不生效。
gpgkey=  	# 数字证书的公钥文件保存位置
```

- 管理软件包

```bash
# 检查更新
$ dnf check-update

# 查询
$ dnf list [--all]              # 列出 所有的软件包
$ dnf list --installed          # 列出 已安装的软件包
$ dnf list <pkgname>            # 列出 特定的RPM包信息

$ dnf info <pkgname>			# 显示 RPM包信息
$ dnf search <keyword>          # 搜索软件包

# 安装
$ dnf install -y <pkgname>
# 升级
$ dnf -y update [pkgname]        # 升级 所有包或pkgname
# 卸载
$ dnf remove <pkgname>

$ dnf repolist [all|enabled|disabled]   # 查看已配置的软件仓库
$ dnf clean all                         # 清理缓存
$ dnf makecache                         # 创建缓存 查看repo是否配置成功
$ dnf provides <file>                   # 查询file是哪个包提供的(绝对路径)
$ dnf repoquery --list <pkgname>        # 等价于 rpm -ql <pkgname>        

# 下载
$ dnf download <pkg>            	# 只下载不安装
$ dnf download --resolve <pkg>    	# 同时下载未安装的依赖
$ dnf install --downloadonly <pkg> --downloaddir=./
```

- 管理软件包组

```bash
$ dnf groups summary            	# 列出 系统中所有已安装软件包组、可用的组、可用的环境组的数量
$ dnf group list                	# 列出 所有软件包组和它们的组ID
$ dnf group info group_name        	# 显示 软件包组信息
$ dnf group install group_name    	# 安装 软件包组
$ dnf group update group_name    	# 升级 软件包组
$ dnf group remove group_name    	# 卸载 软件包组
```

- 创建本地软件源仓库

```bash
$ dnf install createrepo
$ createrepo <dir>                 # 将dir作为本地仓库目录,生成元数据信息
```

- 添加、启用和禁用软件源

```bash
# 安装config-manager
$ yum -y install yum-utils                        # yum
$ dnf install 'dnf-command(config-manager)'        # dnf

# 添加软件源
$ yum-config-manager --add-repo <url>            
  # 在/etc/yum.repos.d/目录下生成对应的repo文件
$ dnf config-manager --add-repo repository_url

# 查询repo id
$ dnf repolist                                    
# 启用软件源
$ dnf config-manager --set-enable <repo id>        # 或    --enable <name> 
# 禁用软件源
$ dnf config-manager --set-disable repository    # 或 --disable <name>
```

######  

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
$ df -HT        # 查看 T(filesystem)和partition, H:1M=1000K h:1M=1024
$ df -H <dir>    # 查看 目录所在分区

# du (disk used)
$ du -sh <file> # 查看 文件或目录占用的磁盘空间
$ du -ah <file> # 统计子目录

# 查看或设置ext文件系统的卷标LABLE
$ e2lable <dev> [label] 

$ lsblk -f        	# 查看块设备及文件系统
$ blkid            	# 查看块设备UUID TYPE LABLE
```

**磁盘分区:**

```bash
# 重新读取分区表信息
$ partprobe

# 只MBR分区
$ fdisk -l         # 查看 硬盘和分区

# 支持MBR,GPT分区
$ parted  
$ parted [<dev> -l] # 列出所有设备的分区
# 子命令
 $ select <dev>			# 选择设备
 $ print
 $ mklable/mktable		# 创建 分区表 gpt msdos
 $ rm <NUM>				# 删除 分区
 $ mkpart <name> <fs> <start> <end>    			# 创建 gpt分区
 $ mkpart <primary/extended> <fs> <start> <end>	# 创建 msdos分区
```

**磁盘分区标签:**

```bash
$ wipefs <devfile>		# 查看磁盘上的文件系统签名 DEVICE TYPE UUID LABLE
$ wipefs -a <devfile>	# 擦除
```

### 格式化

```bash
$ fsck [opt] <dev>        # 检测和修复文件系统
# 格式化磁盘 写入文件系统
$ mkfs -t <dev>
$ mkfs.* <dev>
```

### 挂载

**临时挂载mount**

```bash
# 查看所有挂载的信息
$ mount
$ -v    # verbose
$ -t    # 挂载时指定文件系统, 要与mkfs指定的相同 不写会自动检测
$ -a	# 检查并挂载/etc/fstab中的条目

# 1.使用设备名挂载
$ mount <dev> <mountpoint>
# 2.使用UUID挂载
$ mount -U <uuid> <mountpoint>
$ mount UUID="" <mountpoint>
# 3.使用LABEL挂载
$ mount -L <label> <mountpoint>
$ mount LABEL="" <mountpoint>

$ umount     # 取消挂载
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

### swap

```bash
$ mkswap    # 格式化swap分区
$ swapon    # 启动swap分区
$ swapoff	# 关闭swap分区
```



### LVM逻辑卷

`dnf install lvm2`

- 物理存储介质（The physical media）：指系统的物理存储设备，如硬盘，系统中为/dev/hda、/dev/sda等等，是存储系统最低层的存储单元。

- 物理卷（Physical Volume，PV）：指硬盘分区或从逻辑上与磁盘分区具有同样功能的设备(如RAID)，是LVM的基本存储逻辑块。物理卷包括一个特殊的标签，该标签默认存放在第二个 512 字节扇区，但也可以将标签放在最开始的四个扇区之一。该标签包含物理卷的随机唯一识别符（UUID），记录块设备的大小和LVM元数据在设备中的存储位置。

- 卷组（Volume Group，VG）：由物理卷组成，屏蔽了底层物理卷细节。可在卷组上创建一个或多个逻辑卷且不用考虑具体的物理卷信息。

- 逻辑卷（Logical Volume，LV）：卷组不能直接用，需要划分成逻辑卷才能使用。逻辑卷可以格式化成不同的文件系统，挂载后直接使用。

- 物理块（Physical Extent，PE）：物理卷以大小相等的“块”为单位存储，块的大小与卷组中逻辑卷块的大小相同。

- 逻辑块（Logical Extent，LE）：逻辑卷以“块”为单位存储，在一卷组中的所有逻辑卷的块大小是相同的。

#### 管理物理卷

- 物理卷(pv) 
  
  ```bash
  $ pvs			# 显示简略信息
  $ pvdispaly		# 显示详细信息
  $ pvcreate		# create a phycial volume
  $ pvchange
  	-x <y|n>	# 是否允许分配PE
  $ pvscan
  $ pvremove
  ```
  
- 卷组(vg) 
  
  ```bash
  $ vgs			# 显示简略信息
  $ vgdisplay		# 显示详细信息
  $ vgscan
  $ vgcreate		# create a volume group
  	-l			# 卷组上允许创建的最大逻辑卷数。
  	-p			# 卷组中允许添加的最大物理卷数。
  	-s <size>	# 指定 卷组上的物理卷的PE大小(默认4MB)
  $ vgchange
  $ vgextend <vg> <pvname >	# 添加 物理卷
  $ vgreduce <vg> <pvname >	# 收缩 卷组
  ```
  
- 逻辑卷(lv)
  
  ```bash
  $ lvs             	# 显示简略信息
  $ lvdisplay        	# 显示详细信息
  $ lvscan        	# 扫描所有的逻辑卷并显示状态,设备路径,大小
  $ lvcreate        	# create a logical volume
  	-L		# 指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  	-l		# 指定逻辑卷的大小（LE数）。
  	-n		# 指定要创建的逻辑卷名称。
  	-s		# 创建快照。
  
  $ lvextend -L 10G <lv>        # 扩容
  $ lvresize
  	-L	[+|-]<size>	# 指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  	-l	[+|-]<cnt>	# 指定逻辑卷的大小（LE数）。
  	-f				# 强制调整逻辑卷大小，不需要用户确认。
  $ lvreduce			# 收缩
  $ lvextend 			# 拓展
  $ lvremove <lvname>
  ```
  
  > ​	逻辑卷对应的设备文件保存在卷组目录下，例如：在卷组vg1上创建一个逻辑卷lv1，则此逻辑卷对应的设备文件为/dev/vg1/lv1
  
  - 逻辑卷缩容顺序:
  
    ```bash
    resize2fs: 缩容先缩容文件系统
    ```
  

###### 

## 系统和服务管理

为了减少系统启动时间，systemd的目标是：

- 尽可能启动更少的进程。
- 尽可能将更多进程并行启动。

```bash
$ systemctl list-unit-files                    # 列出 所有的单元文件
```

### 管理系统服务

```bash
$ systemctl list-units --type service		# 列出 当前正在运行的服务
$ systemctl list-units --type service --all	# 显示 所有的服务(包括未运行的服务)
$ systemctl status <service>                # 查看 服务状态

$ systemctl is-active name.service
$ systemctl is-enabled name.service


$ systemctl start   <service>                # 启动 服务
$ systemctl stop    <service>                # 停止 服务

$ systemctl restart <service>                # 重启 服务
$ systemctl reload  <service>                # 重新加载 配置文件

$ systemctl enable  <service>                # 开启 开机自启
$ systemctl disable <service>                # 关闭 开机自启
```

### service Unit

```bash
$ vim /lib/systemd/system/nginx.service
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

### Target和运行级别

systemd用目标（target）替代了运行级别

| 运行级别         | systemd目标（target）                                   | 描述                            |
|:------------ |:--------------------------------------------------- |:----------------------------- |
| 0            | runlevel0.target，poweroff.target                    | 关闭系统。                         |
| 1, s, single | runlevel1.target，rescue.target                      | 单用户模式。                        |
| 2, 4         | runlevel2.target，runlevel4.target，multi-user.target | 用户定义/域特定运行级别。默认等同于3。          |
| 3            | runlevel3.target，multi-user.target                  | 多用户，非图形化。用户可以通过多个控制台或网络登录。    |
| 5            | runlevel5.target，graphical.target                   | 多用户，图形化。通常为所有运行级别3的服务外加图形化登录。 |
| 6            | runlevel6.target，reboot.target                      | 重启系统。                         |
| emergency    | emergency.target                                    | 紧急Shell                       |

```bash
$ systemctl get-default					# 查看 系统默认启动目标
$ systemctl list-units --type=target    # 查看 当前系统所有的启动目标
$ systemctl set-default name.target		# 改变 系统默认目标
$ systemctl isolate name.target			# 改变 当前系统的目标
$ systemctl rescue						# 改变 当前系统为救援模式
$ systemctl emergency					# 改变 当前系统为紧急模式
```

### 关闭、暂停和休眠系统

| Linux常用管理命令 | systemctl命令        | 描述   |
|:----------- |:------------------ |:---- |
| halt        | systemctl halt     | 关闭系统 |
| poweroff    | systemctl poweroff | 关闭电源 |
| reboot      | systemctl reboot   | 重启   |

###### 

## 进程管理

### 进程状态

| 状态  | 含义                               |
|:---:|:--------------------------------:|
| D   | 不可中断的休眠状态(通常是I/O的进程)，可以处理信号，有 延迟 |
| R   | 可执行状态&运行状态(在运行队列里的状态)            |
| S   | 可中断的休眠状态之中（等待某事件完成），可以处理信号       |
| T   | 停止或被追踪（被作业控制信号所停止）               |
| Z   | 僵尸进程                             |
| X   | 死掉的进程                            |
| <   | 高优先级的进程                          |
| N   | 低优先级的进程                          |
| L   | 有些页被锁进内存                         |
| s   | Session leader（进程的领导者），在它下面有子进程  |
| t   | 追踪期间被调试器所停止                      |
| +   | 位于前台的进程组                         |

> 1号进程(init/systemd) 接管孤儿进程

### 相关命令

- ps

| 选项  | 描述                    |
|:--- |:--------------------- |
| -e  | 显示所有进程。               |
| -f  | 全格式。                  |
| -h  | 不显示标题。                |
| -l  | 使用长格式。                |
| -w  | 宽行输出。                 |
| -a  | 显示终端上的所有进程，包括其他用户的进程。 |
| -r  | 只显示正在运行的进程。           |
| -x  | 显示没有控制终端的进程。          |

```bash
$ ps                                           	# 查看 当前终端运行的进程
$ ps -aux                                      	# 列出 所有进程
$ ps -ef										# 显示所有命令,连带命令行
$ ps -eo pid,ppid,sid,pgrp,nlwp,cmd,stat		# 格式化输出
```

- 其他

```bash
$ pstree				# 查看 进程树
$ top					# 动态显示

$ kill -KILL -<pgrp>	# 发给进程组
$ setsid				# 创建一个新的会话
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

| 优先级（PRI）范围 | **描述** |
| ---------- | ------ |
| 0—99       | 实时进程   |
| 100—139    | 非实时进程  |

```bash
$ ps -l    # 长格式输出
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN  TTY          TIME CMD
0 S     0    7249    7248  0  80   0 -  6069 do_wai pts/2    00:00:00 bash
0 S     0    7315    7249  0  80   0 - 62884 futex_ pts/2    00:00:03 fish
4 R     0    9814    7315  0  80   0 -  6504 -      pts/2    00:00:00 ps
# 调整nice值
$ nice [-n niceness] cmd    # niceness [-19,20]
$ renice [-n nicene] -p <pid> | -g <pgrp> | -u <user>
```



### 调度启动进程

atd, crond 后台守护进程

#### at

在指定时间执行一个任务

用户执行权限配置文件:`/etc/at.allow` `/etc/at.deny`

任务搜索目录(at创建的任务文件存储目录): `/var/spool/at` 

> - 系统中有at.allow文件: 只有at.allow中的用户才可以使用at命令
> - at.allow和at.deny有共同用户, at.allow优先级更高
> - 系统中无at.allow文件: 除了at.deny中的用户都可以使用at命令
> - 2个文件都不存在: 只有root才可以使用at命令

```bash
$ at [选项] [时间]
$ -m  				# 任务执行完成后向用户发送E-mail
$ -c <num>			# 查询 任务内容(/var/spool/at下的任务文件)
$ -t				# 指定 执行时间
$ -q <a-z>			# 队列 优先级a-z从低到高
$ -d                # 等价于atrm
$ -l                # 等价于 atq
$ -f <file>			# 执行脚本

$ atrm <num>...		# 删除 作业队列中的任务
$ atq				# 查看 当前待执行的一次性计划任务
```

Example:

```bash
$ at 4:30pm
$ at 16:30
$ at 16:30 today
$ at now+4 hours
$ at now+ 240 minutes
$ at 16:30 7.6.19
$ at 16:30 6/7/19
$ at 16:30 Jun 7
```



#### crontab

周期性运行一批程序（cron）

crond 进程每分钟都会搜索`/var/spool/cron`,`/etc/crontab`中是否有要执行的任务,如果有,则会自动执行该任务

用户执行权限配置文件:`/etc/cron.allow` `/etc/cron.deny`

crond任务搜索目录:`/var/spool/cron/`

系统级别配置任务:`/etc/crontab`

日志文件:`/var/log/cron`

**用户任务调度**

普通用户可以配置的任务, 以当前身份去执行

```bash
$ crontab    # 创建(编辑)、查看、删除用户的周期性计划任务
  $ -u			# 设置 某个用户的cron服务(root)
  $ -l			# 列出 某个用户cron服务的详细内容
  $ -r			# 删除 某个用户的cron服务
  $ -e			# 编辑 某个用户的cron服务
```

**系统任务调度**

crontab文件, root用户可以配置任何任务, 以任意用户身份去执行该任务

```bash
# crontab 文件格式
# 分(0-59) 时(0-23) 日(1-31) 月(1-12) 周(0-6)
minute   hour   day   month   week  [user] command/script 

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

###### 

## 网络管理

### nmcli

管理和配置 NetworkManager守护进程 控制的网络连接

nmcli: 使用命令行配置由NetworkManager管理网络连接

nmtui: 使用文本交互配置由NetworkManager管理网络连接

- 网卡连接和路由的配置目录: `/etc/sysconfig/network-scripts/`
- 网络连接配置文件: `ifcfg-<id>`
- 路由配置文件:`route-<NAME>`

​    手动修改ifcfg不会立即生效，修改文件后（以ifcfg-enp3s0为例），需要在root权限下执行**nmcli con reload;nmcli con up enp3s0**命令以重新加载配置文件并激活连接才生效。

​    nmcli命令配置的网络配置可以立即生效且系统重启后配置也不会丢失

```bash
$ nmcli [OPTIONS] OBJECT { COMMAND | help }]
OBJECT: 
    connection, device, general
OPTIONS:
    -p --pretty			# 输出得好看
$ nmcli general status	# 显示NetworkManager状态
```



**ifcfg文件**

| **参数**             | **说明**                        |
| ------------------ | ----------------------------- |
| **TYPE**           | 配置文件接口类型                      |
| **BOOTPROTO**      | 系统启动地址协议(dncp,none)           |
| **ONBOOT**         | 系统启动时是否激活                     |
| **IPADDR**         | IP 地址                         |
| **NETMASK**        | 子网掩码                          |
| **GATEWAY**        | 网关地址                          |
| **BROADCAST**      | 广播地址                          |
| **HWADDR/MACADDR** | MAC 地址，只需设置其中一个，同时设置时不能相互冲突   |
| **PEERDNS**        | 是否指定 DNS，如果使用 DHCP 协议，默认为 yes |
| **DNS{1, 2}**      | DNS 地址                        |
| **USERCTL**        | 用户权限控制                        |
| **NAME**           | 网络连接名称                        |
| **DEVICE**         | 物理接口名称                        |

| **Nmcli con modify**                | **Ifcfg-\***                        | **目的**          |
|:----------------------------------- |:----------------------------------- |:--------------- |
| **ipv4.method** manual              | **BOOTPROTO=**none或者static          | 静态指定ipv4的地址     |
| **ipv4.method** auto                | **BOOTPROTO=**dhcp                  | 动态获取ipv4的地址     |
| **ipv4.addresses**  ip地址/掩码长度       | **IPADDR=**x.x.x.x  **PREFIX=**掩码长度 | 设置静态ip地址及掩码长度   |
| **ipv4.gateway**  x.x.x.x           | **GATEWAY=**x.x.x.x                 | 设置网关地址          |
| **ipv4.dns**      x.x.x.x           | **DNS1=**x.x.x.x                    | 设置dns地址         |
| **autoconnect**  (yes\|no)          | **ONBOOT=**(yes\|no)                | 设置是否自动连接        |
| **connection.id** ensxx             | **NAME=**ensxx                      | 配置网络连接名         |
| **connection.interface-name** ensxx | **DEVICE=**ensxx                    | 配置网络连接所绑定的网络接口名 |



**配置ip**

```bash
# 连接
$ nmcli connection show [--active]		# 显示 连接(所有/活跃) NAME字段代表连接ID
$ nmcli connection show <NAME>			# 显示 连接的详细信息 
$ nmcli connection reload <NAME>		# 重新 加载连接的配置文件

# 设备
$ nmcli device status					# 显示 设备状态
$ nmcli device show [dev]				# 显示 设备信息
$ nmcli device disconnect <dev>			# 断开 在dev上的连接
$ nmcli device reapply <dev>			# 重新 应用网络设备 使配置生效

# con-name:连接名 type:连接类型 ifname:物理网卡
# 添加 动态ip
$ nmcli connection add con-name <NAME> type <Ethernet> ifname <ens33>
# 添加 静态ip
$ nmcli con add type <Ethernet> con-name <NAME> ifname <ens33> ip4 <ip>/<24> gw4 <gw>

# 启动 关闭 连接
$ nmcli connection up <con>
$ nmcli connection down <con>
# 删除 连接
$ nmcli connection delete <con>

# 修改 连接
$ nmcli con mod net-static ipv4.dns "*.*.*.* *.*.*.*"    # 设置两个 IPv4 DNS 服务器地址
$ nmcli con mod [+|-]ipv4.addresses <ip>/<24>             # 添加或删除ipv4
```



**添加Wi-Fi连接**

```bash
# 方法1，通过网络接口连接Wi-Fi (连接到由SSID或BSSID指定的wifi网络)
$ nmcli device wifi connect "$SSID" password "$PASSWORD" ifname "$IFNAME"  
$ nmcli --ask device wifi connect "$SSID" 
# 方法2，通过配置文件连接Wi-Fi
  # 1.查看可用 Wi-Fi 访问点
  $ nmcli dev wifi list        
  # 2.静态 IP 配置
  $ nmcli con add con-name <NAME> ifname <wlan0> type <wifi> ssid <SSID> 
ip4 <ip>/<prefix> gw4 <ip>
  # 3.设定 WPA2 密码
  $ nmcli con modify <NAME> wifi-sec.key-mgmt <wpa-psk>
  $ nmcli con modify <NAME> wifi-sec.psk <answer>
  # 4.更改 Wi-Fi 状态
  $ nmcli radio wifi [ on | off ]
```



**配置路由**

主机路由: 指定网络的一台主机

网络路由: 指定网络

```bash
# 查看NetworkManager配置下的路由表
$ nmcli device show ens33 | grep ROUTE
$ route -n
$ ip route show

# nmcli 添加|删除静态路由
$ nmcli connection modify <NAME> [+|-]ipv4.routes "192.168.77.0/24 192.168.72.2"
# 激活连接以生效配置
$ nmcli con up <NAME>    
```

### ip

使用ip命令配置的网络配置可以**立即生效**但系统**重启后配置会丢失**

```bash
$ ip addr show [dev]
# 配置静态IP地址
$ ip addr add <ip>/<prefix> dev <ens33>

# 配置静态路由
$ ip route
$ ip route [ add | del | change | append | replace ] destination-address
# 添加主机路由
$ ip route add 192.168.2.1 via 10.0.0.1 [dev interface-name]
# 添加网络路由
$ ip route add 192.168.2.0/24 via 10.0.0.1 [dev interface-name]


# route 命令配置路由
# 添加/删除 路由(主机路由 网络路由)
$ route {add|del} {-net|-host} <dst> netmask <mask> [<gw> gateway] dev <dev>
# 添加 一条到192.168.77.0网络, 下一跳(gw)为192.168.72.2的由, 从网卡ens33发送
$ route add -net 192.168.77.0 netmask 255.255.255.0 gw 192.168.72.2 dev ens33
# 删除 到192.168.77.0网络, 下一跳(gw)为192.168.72.2的路由, 从网卡ens33发送
$ route del -net 192.168.77.0 netmask 255.255.255.0 dev ens33
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
Server:        114.114.115.115			# DNS ip地址
Address:    114.114.115.115#53        	# DNS ip和端口

Non-authoritative answer:            	# 非权威答案
Name:    cn.bing.com                    # 域名
Address: 202.89.233.100                	# 域名的ip地址
Name:    cn.bing.com
Address: 202.89.233.101
```

### 主机名

hostname有三种类型：static、transient和pretty。

- static：静态主机名，可由用户自行设置，并保存在/`etc/hostname`文件中。
- transient：动态主机名，由内核维护，初始是 static 主机名，默认值为“localhost”。可由DHCP或mDNS在运行时更改。
- pretty：灵活主机名，允许使用自由形式（包括特殊/空白字符）进行设置。

> ​    如果--static或--transient与--pretty选项一同使用时，则会将static和transient主机名简化为pretty主机名格式，使用“-”替换空格，并删除特殊字符。

```bash
# hostnamectl配置主机名
$ hostnamectl status                        	# 查看查看所有主机名
$ hostnamectl set-hostname name [option...]		# 设定所有主机名
    # option可以是--pretty、--static、--transient中的一个或多个选项
# 清除特定主机名
$ hostnamectl set-hostname "" [option...]
# 远程更改主机名
$ hostnamectl set-hostname -H [username]@hostname <new_hostname>

# 使用nmcli配置主机名
$ nmcli general hostname                    # 查询static主机名
$ nmcli general hostname <new_hostname>		# 设置静态主机名
```



### 主机解析

本地域名解析配置文件: `/etc/hosts`

格式: `ip<TAB>domain1.com domain2.com ...`

```bash
# 格式
$ ip<TAB>domain.com
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
39.156.66.18    www.baidu.com    baidu.com
39.156.66.14    www.baidu.com    baidu.com
# 注释取消 某条记录
```

> **可以删除当前网络连接的DNS进行测试**

###### 

## 文本处理

### 正则

| 通配符    | 描述                                                      | 拓展正则      |
|:------ |:------------------------------------------------------- |:---------:|
| `[]`   | 匹配[]中的任意一字符, [a-z] [A-Z] [0-9]                          |           |
| `()`   | 标记 子表达式 起止位置                                            | √         |
| `*`    | 匹配 前面的子表达式 零或多次                                         |           |
| `+`    | 匹配 前面的子表达式 一或多次                                         | √         |
| `?`    | 匹配 前面的子表达式 零或一次                                         | √         |
| `\`    | 转义字符                                                    |           |
| `.`    | 匹配除 `\n`（换行）外的任意单个字符                                    |           |
| `{}`   | `{n}` 表示匹配前面子表达式 n 次;`{n,}` 匹配至少 n 次;`{n,m}` 匹配 n 至 m 次 |           |
| `      | `                                                       | 表明前后两项二选一 |
| `$`    | 匹配 字符串的结尾                                               |           |
| `^`    | 匹配 字符串的开头,                                              |           |
| [^abc] | 匹配 除abc的所有字符                                            |           |
| \s     | 表示 任意多个空白字符（包括空格和\t 没有\n)                               | √         |
| \S     | 表示 不是空白的字符                                              | √         |
| \w     | 表示 [0-9A-Za-z_]                                         | √         |
| \b     | 表示单词的结束(\b并不占据位置进行匹配，它只检测接下来的字符是否为\w)                   | √         |
| \W     | 和\w相反, 表示`[^0-9A-Za-z]`                                 | √         |

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
$ ls /bin | grep -n "^man\|man$"    # 以man开头 或 以man结尾
$ ls /bin | grep -E "^$"            # 匹配空行
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
$ -r        # --reverse
$ -u		# --unique
$ -o <file>	# --output
$ -n		# --numeric-sort
$ -R        # --random-sort
$ -f        # --ignore-case
```

- **uniq: 去重**

```bash
 -c			# 显示 重复次数
 -i			# 忽略 大小写
```

- **cut: 列处理**

```bash
$ cut -d<delimiter> -f<n1,n2> <file>
$ -d		# 分隔符
$ -f<n1,n2> # n1到n2列
```

- **grep,egrep: 行过滤**

```bash
-E        	# 拓展正则
-i			# 忽略大小写
-n			# 显示行号
-R			# 递归
-v        	# 反转匹配(invert-match)
-c       	# 打印 匹配的个数
-l        	# 列出 匹配的文件名
```

- **sed: 单行或多行处理 从标准输入或文件中读取内存缓冲区, 对每一行做处理**

```bash
$ sed [options] command [input-file]
# [选项]
$ -n            # 取消默认全文打印,只显示命令操作行
$ -i            # 写入文件,不用-i修改的是内存缓冲区
$ -e            # 多次编辑 不需要管道符
$ -r/E			# 支持拓展正则(|不需要转义)
# sed command
$ a             # append 指定行后 追加 一行/多行
$ i				# insert 指定行前 插入 一行/多行
$ d             # delete 删除 一行/范围删除 
$ p             # print  打印
$ s/old/new/g	# substitute 替换(g:greedy) /也可以是#,@
$ c				# 对行/范围 替换
----------------------------------------------------------------------------------------
# 匹配
    # 1                	# 指定 特定行 第一行
    # 1,5				# 指定 范围 1-5行
    # 1,+5            	# 指定 范围 1-6 行
    # 1~2            	# 步长2 从第1行开始
    # /pattern/        	# 指定 模式

# p 打印
$ sed -n '/pattern/p'    	# 打印 匹配行
$ sed -n '/pattern/!p'    	# 打印 非匹配行
$ sed -n '1,10p'			# 打印 1-10行
$`sed -n '$p'              # 打印 最后一行
$ sed -n '1,$p'         	# 打印 1到最后一行
# d 删除
$ sed '/pattern/d'    	# 删出 匹配行
$ sed '/pattern/!d'		# 删除 非匹配行
$ sed '1,10d'        	# 删除 1-10行
# c 替换
$ sed '1c hello'     	# 替换第一行
# i    插入
$ sed '/pattern/i <txt>'                # 匹配行前 插入txt
# a 追加
$ sed '/pattern/a <txt>'                # 匹配行后 插入txt

# -i 写入文件
$ sed -i 's/hello/world/g' <file>				# 写入文件
$ sed -i.<suffix> 's/hello/world/g' <file>      # 备份到<file>.<suffix>中
# -e 多次编辑 
$ sed -n -e '1,4 p' -e '6,7 p' <file>            # 打印1-4和6-7行
```

- **awk: 列处理** 

```bash
# awk [option] 'pattern{program}' file
# program
    # 逗号 表示字段输出分隔符
    # 有多条脚本命令组成
# [option]
$ -F <separator>     	# 指定 字段分隔符separator
$ -v <val>=val        	# 自定义变量或修改一个内部变量
$ -f <file>            	# 从文件中读取awk脚本命令 内容如:{print $0}
```

| awk内置变量        | 解释                                |          |
|:-------------- |:--------------------------------- | -------- |
| FS             | 输入 字段分隔符(Filed Separator)         | 默认空格" "  |
| OFS            | 输出 字段分隔符(Output Filed Separator)  | 默认空格" "  |
| RS             | 输入 记录分隔符(Record Separator)        | 默认换行"\n" |
| ORS            | 输出 记录分隔符(Output Record Separator) | 设置输出换行符  |
| NF             | 当前 行的字段数(Number Of Filed)         |          |
| NR             | 匹配行在文件中的行号(Number of Records)     |          |
| FNR            | 多文件时显示各文件的行号                      |          |
| FILENAME       | 当前 文件名                            |          |
| ARGC           | 命令行参数的个数                          |          |
| ARGV           | 命令行参数                             |          |
| $0             | 整行                                |          |
| $1, $2...$NF   | First, second,...,last field      |          |
| BEGIN{program} | 操作文件前 执行awk program               |          |
| END{program}   | 操作文件后 执行awk program               |          |

**BEGIN和END**

```bash
$ BEGIN          {<initializations>}     # 执行文件后 要执行的program
$    <pattern 1> {<program actions>}     # 模式匹配 执行的program
$    <pattern 2> {<program actions>} 
$    ...
$ END            {< final actions >}    # 执行文件后 要执行的program
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
$ ~        # 正则 匹配
$ !~    # 正则 不匹配

# $1 ~ /regex/      字段匹配 
$ awk '$0 ~ /sh$/' /etc/passwd		# 查找 有shell的用户
# $1 !~ /regex/     字段不匹配
$ awk '$0 !~ /sh$/' /etc/passwd		# 查找 无shell的用户
```

**模式匹配**

```bash
# 1. /regex/ 行匹配
$ awk -F: '/^hzh/{print $1, $(NF-1), $NF}' /etc/passwd	# 查找 hzh开头的用户
# 2. !/regex/ 行不匹配
$ awk -F: '!/bin.*sh/{print NR,$1}' /etc/passwd			# 查找 不能登录的用户
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

###### 

## 语言环境

​    通过`localectl`修改系统的语言环境，对应的参数设置保存在/etc/locale.conf文件中。这些参数会在系统启动过程中被systemd的守护进程读取。修改后需要重新登录或者在root权限下执行`source /etc/locale.conf`命令刷新配置文件，使修改生效。

### localectl

```bash
$ localectl status				# 显示当前语言环境设置

$ localectl list-locales        # 列出可用的语言环境
$ localectl set-locale LANG=<>  # 设置语言环境

$ localectl list-keymaps        # 列出可用的键盘布局
$ localectl set-keymap <>		# 设置键盘布局
```

### datetimectl

NTP网络时间协议(Network Time Protocol)

```bash
$ timedatectl                            	# 显示日期和时间

$ dnf install ntp && systemctl status ntpd
$ timedatectl set-ntp <BOOL>            	# 启动或关闭网络时间同步

$ timedatectl set-time 'YYYY-MM-DD'			# 修改日期
$ timedatectl set-time 'HH:MM:SS'        	# 修改时间

$ timedatectl list-timezones            	# 显示当前可用时区
$ timedatectl set-timezone <time_zone>    	# 修改时区
```

### date

```bash
$ date						# 显示本地时间
$ date --utc                # 显示UTC时间
$ date +"format"            # 格式化输出
$ date +"%Y-%m-%d %H:%M"    # 2023-11-26 00:06
$ date --set HH:MM:SS
$ date --set YYYY-MM-DD
  # %Y 年份（比如1970、1996等）
  # %m 月份（01～12）
  # %d 按月计的日期（01～31）
  # %H 小时，24小时制（00~23）
  # %M 分（00～59）
  # %S 秒（00～59)
  # %D 日期（mm/dd/yy）
  # %y 年份的最后两个数字（1999则是99）

```

### hwlock

Linux 将时钟分为：

- 系统时钟 (System Clock) ：当前Linux Kernel中的时钟。
- 硬件时钟 RTC：主板上由电池供电的主板硬件时钟

当Linux启动时，会读取硬件时钟，并根据硬件时间来设置系统时间。

设置硬件时钟RTC (Real Time Clock)

```bash
$ hwclock                    # 显示当前硬件的日期和时间
$ hwclock --set --date "dd mm yyyy HH:MM"
```

###### 

## etc配置文件

```bash
$ /etc/shells        	# 可用shell列表
$ /etc/sudoers			# sudo 权限的配置
$ /etc/os-release    	# 系统信息
```



# 命令

| Command | Common option      | Comment                               |
|:-------:|:------------------:|:-------------------------------------:|
| history | -n(显示近n条)          | 显示历史使用命令(默认全显示)                       |
| last    |                    | 显示历史登录信息                              |
| top     |                    | 任务管理器                                 |
| umask   |                    | 查看权限掩码权限掩码，创建文件时文件的实际模式=mode&(~umask) |
| uname   | -a                 | 查看系统相关信息                              |
| ulimit  | -a                 |                                       |
| strace  | -e signal -p <pid> | 跟踪程序执行，查看调用的系统函数。                     |
| nm      | -AC                | 查看变量,函数符号                             |
| objdump | -DS                | 反汇编                                   |
| ldd     |                    | 查看依赖动态库                               |
| netstat | -apn               |                                       |
| xargs   |                    | 传参                                    |
| who     | -r,-a              | 查看用户登录                                |
| file    |                    | 查看文件类型                                |
| type    |                    |                                       |
| whatis  |                    |                                       |
| strings |                    | 打印文件中的可打印字符串                          |

## tar

归档压缩

```bash
$ tar
  -c --create
  -x --extract             # extract files from an archive
  -t --list                # list the contents of an archive
  -v --verbose
  -f --file=ARCHIVE
Compression:
  -j --bzip2
  -J --xz
  -z --gzip
  -Z --compress
```

> tar和zip既打包又压缩, gzip,xz,bzip只压缩

## PS1

提示符(Prompt String)

```bash
$ \u：当前用户的用户名。
$ \h：当前主机的主机名。
$ \w：当前工作目录的绝对路径。
$ \n：换行符。
$ \t：当前时间的24小时制，格式为“小时：分钟：秒”。
$ \e：ASCII转义字符。
$ \033：与\e相同的ASCII转义字符。
$ [：开始一个非打印字符序列，例如终端颜色代码。
$ ]：结束一个非打印字符序列。
```

###### 

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

`&>` `&|`: 标准输出和标准错误一起

步长为2: echo{1..10..2}



find /var/weblogs -mtime +30 -delete

划分swap分区

parted的使用

- 执行一个脚本必须要有rx权限
  
  

## GCC GDB

[GCC GDB](./gcc_gdb.md)

## vim

[init.vim](./init.vim)

## git

[git](./git/git.md)

## Shell

[shell脚本,zsh配置](./zsh.md)

## 部署服务

[部署服务](./deploy_service.md)



