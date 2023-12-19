# Shell

## Zsh + Zim

安装 zsh 

```sh
sudo apt install zsh
sudo pacman install zsh
```

安装 [Zim]([Home | Zim: Modular, customizable, and blazing fast Zsh framework (zimfw.sh)](https://zimfw.sh/))

- Zim是一个Zsh配置框架，它捆绑了一个插件管理器zimfw、有用的module和各种各样的theme，而不影响速度。

```sh
# 1.修改默认shell为zsh
# 2.cat install.zsh | zsh
wget -nv -O - https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
```

- 安装 zim 的 module

1. 添加模块到`~/.zimrc` 中, 如`zmodule sorin` 主题
2. 执行 `zimfw install` 安装



## Shell

> shell脚本第一行:#!/bin/bash 告诉bash使用bash解释脚本,而不是shell

let

expr

### 变量

```bash
#!/bin/bash
# 定义变量(不能有空格)
a=1

# 算术运算
echo $[2**10]
echo $((2**5))
let "b = 3**3"

# 执行shell命令
echo $(which echo)      
echo `which echo`

# 访问变量
echo $SHELL
echo ${SHELL}

# 命令行参数$
echo $$         # 当前进程ID
echo "$0"       # $num 访问第几个命令行参数
echo "argc = $#"# 命令行参数个数
echo "$@"       # 命令行参数列表
echo "$*"       # 所有命令行参数的字符串
```

**变量修饰**

- `readonly` :修饰变量只读不可修改
- `unset` :将变量置为空
- `declarer -i` :修饰变量为整数,否则它为字符串

**内部变量**

- `$#` :传递给shell脚本的参数数量

- `$*` :参数内容

- `$@` :

- `$1,$2,$3..` :第几个参数

- `$?` :上一个命令的退出码,成功为0

- `$0` :当前进程名称

- `$$` :当前进程号

- `env`:输出环境变量

  > shell里可以直接使用bash的环境变量，bash中定义一个新的环境变量，shell脚本中也可以得到

**变量判断**

- `{num:-val}`

> ​	如果num存在，整个表达式的值为num，否则为val，并且清空val

- {num:=val}

> ​	如果num存在，整个表达式的值为num，否则为val，并且把val赋值给num



### 字符串操作

- `${#str}` :字符串**长度**

- `${str:n:m}` :从str的第n个字符**提取**m个（不会修改str）
- `${str/old/new}` 和 `${str//old/new}`:替换str的第一个 替换str的每一个



## 判断语句

检查条件是否成立

`test + condition + ...` 或者 `[ condition + ]` 

> 第二种写法condition两侧一定要加空格



**文件判断**

- `-e` :判断文件是否存在
- `-d` :判断是否为目录
- `-f` :普通文件
- `-r` :可读
- `-w  ` :可写
- `-x` :可执行



**字符串判断**

**比较必须加双引号**，否则可能会出错

- `-z` :(zero)空串

- `-n` :(not zero)不是空串

- `==` :相等) 

- `!=` :不等

> test -z "$str0"
>
> test -n "$str0"



**数值判断**

|          | 英文单词      | 条件 |
| -------- | ------------- | ---- |
| 相等     | equal         | -eq  |
| 不相等   | not equal     | -ne  |
| 大于     | greater than  | -gt  |
| 大于等于 | greater equal | -ge  |
| 小于     | less          | -l   |
| 小于等于 | less than     | -lt  |



**逻辑判断**

- `!`  :逻辑非
- `-a` :and逻辑与

- `-o` :or逻辑或
- `||` :或
- `&&` :且



## 控制语句

`read` : read num

`read -p`:read -p "please a number:" num

### if

**if-elif-else-fi**

```bash
echo "if else 语句"
read -p "Please a fileName:" fileName

if [ -e "$fileName" ];then
    echo "$fileName is exists"
else
    echo "$fileName is not exists"
fi

echo -e "\nif elif 语句"
read -p "Please a number:" num

if [ $num -eq 0 ];then
    echo "$num euqal 0"
elif [ $num -lt 0 ];then
    echo "$num less than 0"
else
    echo "$num greater than 0"
fi
```



### case

**case-esac**

```shell
read -p "Please a score:" score

rank=`expr $score / 10` #运算符格式 必须有空格

case $rank in
    0|1|2|3|4|5) #匹配多个case
        echo "You are D, 0 <= $score < 60"
        ;;
    6|7)
        echo "You are C, 60 <= $score < 80"
        ;;
    8)
        echo "You are B, 80 <= $score < 90"
        ;;
    9)
        echo "You are A, 90 <= $score < 100"
        ;;
    *)
        if [ $score == 100 ];then
            echo "You are a perfect score"
        else
            echo "Please a corret score."
        fi
        ;;
esac
```



### for

初值不可以定义变量

写法1:

```sh
echo "1加到100"
declare -i sum=0
for((i=0;i<=100;++i))
do
    sum+=$i
done
```

写法2:

```sh
declare -i sum=0
for i in 1 2 3 4 5 6
do
    sum+=$i
done
```



### while

example1:

```shell
declare -i i=0
while [ $i -le 10 ]
do
    echo "i = $i"
    let i++ #使用bash 的let命令
done
```

example2:

重复获取 知道 获取一个存在的文件名

```shell
declare -i i=0
while [ $i -le 10 ]
do
    echo "i = $i"
    let i++
done
```

example3:

无限循环

```shell
#while true
while :
do
    echo "无限循环"
    `sleep 1`
done
```



### until

直到condition为true时停止

example4:

```shell
declare -i i=0
echo "i=5时退出"
until [ $i -eq 5 ]
do
    echo "now,i = $i"
    `sleep 1`
    let i++
done
```

## 函数

参数返回：

​	可以显示加：return 返回，如果不加，将以最后一条命令运行结果，作为返回值。 return后跟数值n(0-255)

example1:

```shell
function fun1() {
    echo "This a function"
    return 100
}

fun1        #调用函数
echo $?     #函数返回值
ret=$(fun1) #接受函数输出内容
echo "ret = "$ret
#输出
This a function
100
ret = This a function
```

example2:

接受函数参数

```shell
function add() {
    echo "参数个数:$#个"
    declare -i sum=0
    for i in $*
    do
        sum+=$i
    done
    echo $sum
}

ret=$( add 1 2 3 4 5 6 7 8 9 10 )
echo "1+..+10 = $ret"
```
