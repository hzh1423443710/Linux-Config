# 服务搭建

## Nginx

1. **安装依赖:**gcc g++编译器,prece库,zlib库
2. **目录结构**

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

3. 编译安装

```sh
./configure
make -j 4
sudo make install # 默认安装在/usr/local/nginx
cd /usr/local/nginx/sbin && sudo ./nginx
```

> `ps -ef | grep nginx` 查看master进程和worker进程的数量
>
> `sudo vim /usr/local/nginx/conf/nginx` 修改worker进程数量
>
> `sudo ./nginx -h` 查看帮助
>
> `sudo ./nginx -s reload` 不关闭服务,重新加载配置文件
>
> worker进程挂掉一个后, master进程会自动重启一个



## samba

常用命令:smbpasswd,smbclient,smbmount,testparm