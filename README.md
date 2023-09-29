# Linux

# 基本命令

```shell
info:
man: man 1命令 2系统调用 3库函数
```

## 文件操作

- **创建文件** : touch

- **文件拷贝** : cp 

- **文件移动(重命名)** : **mv ** 同一路径 重命名

- **文件删除** : rm,rmdir(删除空目录)

- **文件统计/搜索** :find,grep,wc,locate

```shell
find:					#文件路径查询
format: find + 目录 + 选项(-name,-user,-size) + 文件/用户...
-name:find / -name "stdio.h"	 
-user:find / -user "hzh"
-size:find 目录 -size +20M（+20K）	#：搜索大于20M的文件   +  - =
-size:find 目录 -size +20M -size -50M #搜索大于20M小于50M
-type:find 目录 -type 'l' 		 # 搜索软链接文件
-maxdepth: find 目录 -maxdepth n option ...#指定搜索深度n
-atime:文件访问时间
-mtime:文件属性修改时间
-ctime:文件内容修改时间
```

```shell
grep:					#过滤信息查找,一般通过管道
grep:-n(显示行号)  -i(忽略大小写)
grep:find / -name "stdio.h"	 | grep "stdio"
grep:last | grep "hzh"
```

```shell
wc:					 	#统计 行数,字符数,文件大小
wc:-l(统计行数) -w(统计字符数) -c(文件大小),-m(字符数)
```

- 文件比较: diff

```shell
diff a.cpp b.cpp 	#文件相同不显示任何信息  文件不同...
```



## 文件查看:

- **tree **树状结构显示目录

- **stat** 查看文件属性

- **cat** [-n]  #查看文件内容,-n显示行号,空行也标注

- **tac**  从左到右 从上到下 反向显示

- **nl**  查看文件内容 并 显示行号,空行不标注行号

- **more**

- **less**

- **head**

- **tail**



## 文件压缩

- **zip unzip**

```bash
$ zip name.zip  文件或目录(-r)  # 打包压缩后源文件不会删除
$ unzip name.zip [-d] 指定目录  # 解压缩 压缩包不会删除
```

- **tar -zcvf tar -zxvf**  

```shell
$ tar -zcvf *.tar.gz file/dir........  # 打包压缩后源文件不会删除
$ tar -zxvf  *.tar.gz  [-C](指定目录)   # 解压缩 压缩包不会删除
```

- **gzip gunzip**

```shell
$ gzip file ...        # 自动压缩成*.gz (删除源文件，不打包，各压缩各的)
$ gunzip *.gz ...      # 解压缩后压缩包会自动删除
```

- wget url -o name.tar.gz



## 其他指令

- **history :显示历史使用命令**  ==编号==     

```shell
history 	#显示历史使用命令 附带
!历史命令编号	#执行该编号的命令  如:!2502		#执行编号为历史命令中2502的命令
!!:			#双! 执行上次使用的命令
!-1:		#执行 历史命令中 倒数第一个命令
!-2:		#执行 历史命令中 倒数第二个
```

- 修改主机名 **hostname**

```shell
$ sudo hostname newname
```

|        command        |                            option                            |                           comment                            |
| :-------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| ifconfig,ifup, ifdown |                                                              |                          查看网络ip                          |
|        history        |                        -n(显示近n条)                         |                 显示历史使用命令(默认全显示)                 |
|         last          |                                                              |                       显示历史登录信息                       |
|          top          |                                                              |                          任务管理器                          |
|         umask         |                                                              | 查看权限掩码权限掩码，创建文件时文件的实际模式=mode&(~umask) |
|         uname         |                              -a                              |                       查看系统相关信息                       |
|        strace         |                                                              |              跟踪程序执行，查看调用的系统函数。              |
|          nm           |                                                              |                      查看变量,函数符号                       |
|          ldd          |                                                              |                      查看是否缺少动态库                      |
|   tail -f filename    | 会把 filename 文件里的最尾部的内容显示在屏幕上，并且不断刷新，只要 filename 更新就可以看到最新的文件内容 |                                                              |
|        netstat        |                             -apn                             |                                                              |



# 用户与权限

## 用户与组

>  /etc/passwd	#用户配置文件
>
>  用户名：口令（密码）：用户标识号：组标识号;注释性描述：主目录：登录shell
>
>  /etc/group 	#组配置文件	
>
>  /etc/shadow	#组配置文件		

 ```shell
 id [用户名]   #查看用户信息
 ```

**1.添加用户**

- **useradd**

``` bash
useradd username #添加用户
useradd:-g(指定组) -m(自动创建家目录) -d(指定目录(必须存在))
```

**2.删除用户**

- **userdel**

```shell
$ userdel username   #删除用户
$ userdel -r		  #连通用户主目录一起删除
```

**3.切换用户**

- **su** 

```shell
su	或 su root 或 sudo su	#切换为root
su	username			 #切换为username
```

**4.用户修改**

- usermod

```shell
$ usermod -g groupname username 	#修改用户所属组
$ usermomd -d dir username		#修改用户家目录
```

**5.修改密码**

- passwd

```shell
$ passwd username #修改username的密码
-l	username	#锁住密码
-u	username	#解锁
```

- 添加/删除组

```shell
$ groupadd groupname		#添加组
$ groupdel groupname		#删除组	
$ groupadd -g gid groupname	  #添加组并指定组id
```

- 组修改

```shell
$ groupmod -g GID -n newname oldname #修改组名
```



## 权限

### 文件权限

- **rwx作用到文件**

```
1. [r]:	可以读取，查看
2. [w]:	可以修改，但是不代表可以删除该文件
3. [x]:	可以执行
```

- **rwx作用到目录**

```
1. [r]:	可以读取，		Is查看目录内容
2. [w]:	可以修改，		目录内创建+删除文件,重命名目录
3. [x]:	可以进入该目录,进入目录需要x权限
```

### 修改文件权限

- **chmod u=rwx filename** 

```shell
chmod u=rwx a.txt
```

- **chmod ugo+(-)rwx filename**

```shell
chmod ugo=rw- b.txt 
```

- **chmod u+..,g+..,o-… filename**

```shell
chmod o-rwx b.txt 
```

- **chmod 八进制 777 666 filename**

```shell
chmod 664 a.txt
```

- **chmod a-+rwx 给所有用户**

```shell
chmod a=rw- b.txt
```

### 修改文件所属组,所属主

- chgrp  	组名 文件/目录(-==R递归==)

```shell
sudo chgrp pdd dir -R 
sudo chgrp 1002 dir -R
```

- chown     用户名 文件/目录(==-R递归==) 

```shell
sudo chown hzh 	dir -R
sudo chown 1000 dir -R
```

- chown     用户名**:**组名 文件/目录(==-R==)

```shell
sudo chown hzh:hzh dir -R 	#同时修改 属主 属组
```



# 环境变量

> **env** 		#查看所有环境变量

### 常见环境变量

- **$USER** 用户名

- **$HOME** 用户主目录
- **$HOSTNAME** 主机名
- **LD_LIBRARY_PATH**  c/c++动态库搜索目录

- **$PATH**

- **$SHELL**

### 设置环境变量

- export设置环境变量

```bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt
```

- 设置系统环境变量

- 设置用户环境变量



# 链接

### 	软链接 

类似于Windows的快捷方式

```shell
ln -s 源文件 newfile			#绝对路径, 删除源文件后,软链接不可用
```

### 	硬链接

类似于备份,硬链接/源文件 修改后 ,链接文件的内容都会修改(同步),目录项dentry

```shell
ln 源文件 newfile				#修改newfile 源文件也会被修改  - 源文件删除后,newfile不会被删除,硬链接数-1
```



# 库

- **gcc**

```shell
gcc -I 		# 指定include包含文件的搜索目录 	
gcc -g		# 生成调试信息 该程序可以被调试
gcc -w		# 不生成警告信息
gcc -Wall	# 生成所有警告信息
gcc -D 		# 指定宏
gcc -L 		# 指定库的搜索路径 
gcc -l 		# 指定库名(掐头去尾去掉开头的lib和尾部的.a)
```

### 静态链接库

```shell
ar rcs lib<library_name>.a <source_file_1.o> <source_file_2.o> ... <source_file_n.o>
```

### 动态链接库

```shell
gcc <source_file_1.c> <source_file_2.c> ... <source_file_n.c> -shared -fPIC -o <library_name>.so 
```



# 磁盘管理

> df [-h,-k,-m] [-a] 							   :列出文件系统的整体磁盘使用量 
>
> du [-h,-k,-m] [-a] [-s(不列出子文件)] [-S(每个文件)]:查看文件和目录磁盘使用的空间



# 进程管理

> ps   		# 查看当前运行的进程
>
> ps -aux 	 # 查看所有进程
>
> pstree 	  # 查看进程树
>
> ps ajx | more
>
> ps -A -ostat,ppid,pid,cmd | grep ""
>
> ps -ef       # 显示所有命令，连带命令行
>
> echo $?      # 打印进程退出码
>
> top(1)
>
> ps -eo pid,ppid,sid,pgrp,nlwp,cmd,stat # nlwp 线程数
>
> **setsid:** 创建一个新的会话运行程序 
>
> **nohup:** 运行命令,忽略SIGHUP信号 ignoring input and appending output to 'nohup.out'
>
> **fg:** 将当前终端的后台作业切换到前台运行
>
> **bg:** 将当前终端的暂停作业切换到后台运行
>
> **./a.out &:** 在后台执行
>
> **strace:** 跟踪进程信号 strace -e trace=signal -p `<pid>`

init进程(1号) 接管孤儿进程



# 配置

## 时区

```bash
sudo timedatectl set-timezone Asia/Shanghai
```

## 语言

```bash
sudo apt-get install language-pack-zh-hans
export LANG=zh_CN.utf8 # bash
source ~/.bashrc
```

## vim
[init.vim](./init.vim)

## git免密

```sh
git config --global user.name ""
git config --global user.email ""
```

生成 sshkey

```bash
ssh-keygen -t ed25519 -C "xxxxx@xxxxx.com"  
ssh -T git@gitee.com
```

## 设置默认shell

```bash
chsh [-s 新的Shell路径] 用户名
```

## vscode免密

```bash
sudo apt update
sudo apt install openssh-server
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys # 放入Windows公钥
```

## Zsh

```sh
sudo apt-get install zsh # zsh
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh # on-my-zsht
替换为gitee
# Default settings
REPO=${REPO:-ohmyzsh/ohmyzsh}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
替换为
REPO=${REPO:-mirrors/oh-my-zsh}
REMOTE=${REMOTE:-https://gitee.com/${REPO}.git}
```

```sh
vim ~/.zshrc
# 修改主题
ZSH_THEME="robbyrussell"
# 修改插件
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
source .zshrc
```

```sh
# gitee
git clone https://gitee.com/zjy_1671/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://gitee.com/chenweizhen/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

https://blog.csdn.net/qwe641259875/article/details/107201760

## clangd

```sh
sudo apt update
sudo apt install clangd
```



# Nginx

### **安装依赖**

- gcc g++编译器
- prece库
- zlib库

### **目录结构**

auto/: 编译相关的脚本, configure会用到

​	cc/: 检查编译器的脚本

​	lib/:检查依赖库的脚本

​    os/: 检查操作系统类型的脚本

​	type: 检查平台类型的脚本

CHANGES: 修复的bug, 新增的功能说明

conf/: 默认的配置文件

configure:执行脚本用来生成中间文件

contrib/: 脚本和工具

​	vim/: vim高亮工具

html/: 欢迎界面和错误界面相关的html文件

man/: ngix man手册

src/: nginx源码目录

​	core: 核心代码

​	event: 事件模块相关代码

​    http: http(web服务)模块相关代码

​	mail: 邮件模块相关代码

​	os: 操作系统相关代码

​	stream: 流助力相关代码

objs/: 执行了configure生成的中间文件目录

​	ngx_modules.c:决定了哪些nginx模块会被编译

Makefile: 执行了configure生成的构建脚本

### **编译安装**

```sh
./configure
make -j 4
sudo make install # 默认安装在/usr/local/nginx
cd /usr/local/nginx/sbin && sudo ./nginx
```



`ps -ef | grep nginx` 查看master进程和worker进程的数量

`sudo vim /usr/local/nginx/conf/nginx` 修改worker进程数量

`sudo ./nginx -h` 查看帮助

`sudo ./nginx -s reload` 不关闭服务,重新加载配置文件

worker进程挂掉一个后, master进程会自动重启一个



sudo find / -name "signal.h" | xargs grep in "SIGHUP"
