# Linux

## 命令

|        Command        |   Common option    |                           Comment                            |
| :-------------------: | :----------------: | :----------------------------------------------------------: |
| ifconfig,ifup, ifdown |                    |                          查看网络ip                          |
|        history        |   -n(显示近n条)    |                 显示历史使用命令(默认全显示)                 |
|         last          |                    |                       显示历史登录信息                       |
|          top          |                    |                          任务管理器                          |
|         umask         |                    | 查看权限掩码权限掩码，创建文件时文件的实际模式=mode&(~umask) |
|         uname         |         -a         |                       查看系统相关信息                       |
|        strace         | -e signal -p <pid> |              跟踪程序执行，查看调用的系统函数。              |
|          nm           |        -AC         |                      查看变量,函数符号                       |
|        objdump        |        -DS         |                            反汇编                            |
|          ldd          |                    |                        查看依赖动态库                        |
|        netstat        |        -apn        |                                                              |
|         xargs         |                    |                             传参                             |
|        who -r         |    查看运行级别    |                                                              |



## GCC

- **gcc**

```shell
gcc -I 		# 指定include包含文件的搜索目录 	
gcc -g		# 生成调试信息 该程序可以被调试
gcc -w		# 不生成警告信息
gcc -Wall	# 生成所有警告信息
gcc -D 		# 指定宏
gcc -L 		# 指定库的搜索路径 
gcc -l 		# 指定库名(掐头去尾去掉开头的lib和尾部的.a)
gcc -M      # 显示一个源文件所依赖的各种文件
gcc -MM     # 显示一个源文件所依赖的各种文件，但不包括系统的一些头文件
```

**静态链接库**

```shell
$ ar rcs lib<library_name>.a <source1.o> <source2.o> ...
```

**动态链接库**

```shell
$ gcc <source1.c> <source2.c> ...  -shared -fPIC -o <library_name>.so 
```



## 配置

### SSH

- 生成SSH密钥对

```bash
sudo apt-get install openssh-server
ssh-keygen -t rsa -C "your_email@youremail.com"
```

 - -t rsa指定生成RSA算法的密钥对

 - -C用于添加一个注释，一般为你的邮箱地址。

   ​	会在用户主目录下的.ssh文件夹中生成id_rsa和id_rsa.pub两个文件，私钥保持在本地机器上，而公钥则可以被分享给其他人或远程服务器。

用途:
    远程登录：通过将公钥添加到远程服务器的"authorized_keys"文件中，你可以使用私钥进行无密码的SSH连接。

​    文件传输：SCP, SFTP

​    Git版本控制：将公钥添加到Git托管平台，如GitHub、GitLab等，可实现使用SSH协议进行代码仓库的克隆、推送和拉取操作。

- 拷贝公钥

```bash
ssh-copy-id user@remote_host
```

​	将公钥添加到远程主机的authorized_keys文件中，从而实现无密码SSH登录。

​	authorized_keys文件用于存放被信任的远程主机的公钥, 每个公钥应该占据一行，通常以ssh-rsa或ssh-ed25519开头，后面紧跟着一串由SSH密钥生成命令生成的密钥内容。

- 验证

```bash
ssh -T git@gitee.com
```

### 时区

```bash
sudo timedatectl set-timezone Asia/Shanghai
```

### 语言

```bash
sudo apt-get install language-pack-zh-hans
export LANG=zh_CN.utf8 # bash
source ~/.bashrc
```

### vim
[init.vim](./init.vim)

### git

[git](./git/git.md)

### vscode-SSH免密

```bash
sudo apt update
sudo apt install openssh-server
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys # 放入Windows公钥
```

### Zsh

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



# Nginx

## **安装依赖**

- gcc g++编译器
- prece库
- zlib库

## **目录结构**

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

## **编译安装**

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



