## GCC

- **gcc**

```shell
$ -I                  # 指定include包含文件的搜索目录 	
$ -g                  # 生成调试信息 该程序可以被调试
$ -w                  # 不生成警告信息
$ -Wall               # 生成所有警告信息
$ -D                  # 指定宏
$ -L                  # 指定库的搜索路径 
$ -l                  # 指定库名(去掉开头的lib和尾部的.a)
$ -M                  # 显示一个源文件所依赖的各种文件
$ -MM                 # 显示一个源文件所依赖的各种文件，但不包括系统的一些头文件
$ -static             # 静态链接
$ -shared             # 默认选项，可省略 1.可以生成动态库文件 2.进行动态编译，优先链接动态库
$ -fPIC  	            # 生成使用相对地址的位置无关的目标代码
$ gcc -xc++ -E -v -   # 查看默认include search path
$ g++ -print-search-dirs | grep libraries | tr ':' '\n' # 查看 lib search path
$ ld --verbose | grep SEARCH_DIR | tr -s ' ;' '\n'      # 查看 lib search path
```

**静态链接库**

```shell
# 1.先将 源文件 编译为 目标文件
$ gcc -c test1.c test2.c test3.c
# 2.再使用ar命令将目标文件打包成静态链接库
$ ar rcs libtest.a test1.o test2.o test3.o

# ar命令
$ ar rcs Sllfilename Targetfilelist
  # Sllfilename ：静态库文件名。
  # Targetfilelist ：目标文件列表。
  # r： 替换库中已有的目标文件，或者加入新的目标文件。
  # c： 创建，不管是否存在，都将创建。
  # s： 创建目标文件索引，在创建较大的库时能提高速度。
```

**动态链接库**

```shell
# 1.从 源文件 生成动态链接库。
$ gcc -fPIC -shared test.c -o libtest.so
# 2.从 目标文件 生成动态链接库。
$ gcc -fPIC -c test.c -o test.o
$ gcc -shared test.o -o libtest.so
```

> LD_LIBRARY_PATH为动态库的环境变量(Dynamic Linker Library Path).
>
> 当运行动态库时，若动态库不在缺省文件夹（/lib 和/usr/lib）下，则需要指定环境变量LD_LIBRARY_PATH