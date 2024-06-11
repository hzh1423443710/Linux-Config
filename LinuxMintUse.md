# Linux Mint

## apt包相关

语言包：language-pack-zh-hans-base language-pack-zh-hans

## vim-plug

[vim插件管理器](https://github.com/junegunn/vim-plug)

## 命令行设置默认终端

```bash
$ gsettings set org.cinnamon.desktop.default-applications.terminal exec gnome-terminal
```

## 路径相关

定位一个资源文件的位置

```bash
$ locate firefox.png 
```

系统自带的背景图片路径

```bash
/usr/share/backgrounds
```

获取文件绝对路径

```bash
$ readlink -f <filename>
$ ln -s "$(readlink -f ./Mint-use.md)" /home/hzh/Desktop/Mint-use.md
```

Typora主题路径

```bash
/home/hzh/.config/Typora/themes/github.css
```

fcitx5用户词典历史主题路径
```bash
# /home/hzh/.local/share/fcitx5/pinyin目录下
/home/hzh/.local/share/fcitx5/pinyin/user.dict
/home/hzh/.local/share/fcitx5/pinyin/user.history
/home/hzh/.local/share/fcitx5/pinyin/themes
```





## desktop文件

- desktop文件显示图标(添加执行权限)

```bash
$ chmod 0755 <name>.desktop
```

- 开始菜单中输入关键字可模糊查找

```bash
# *.desktop文件书写规则中
Keywords=模糊匹配
Keywords=wechat;weixin;
```



## 解压GBK文件

```bash
$ unzip -O GBK <name>.zip
```

## 



## zsh终端选项

```bash
# zsh专有
$ unsetopt <opt>		# 取消设置选项
$ setopt AUTO_CD		# 输入目录名直接进入目录
$ setopt noclobber		# 防止重定向覆盖现有文件, 如无法实现 cat flag > exist_file 
# sh
$ set <+|->o <opt>		# 设置 或 取消设置 一个选项
```

## 添加字体文件使生效

```bash
sudo mv <字体文件> /usr/share/fonts/
fc-cache -f -v
```

## 添加服务单元使生效

```bash
# 1.编写服务单元
sudo vim /etc/systemd/system/<service>.service
# 2.重新加载
systemctl daemon-reload
```



# 1.
$ mv clash-linux-amd64 /usr/local/bin/clash

# 2.手动：将Windows版的yaml配置文件复制 到Linux下$HOME/.config/clash/config.yaml
$ cd $HOME/.config/clash/
$ vim config.yaml 
# 或导入订阅
$ wget -O config.yaml 订阅地址

# 3.配置服务
$ vim /etc/systemd/system/clash.service
[Unit]
Description=Clash - A rule-based tunnel in Go
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/clash -f /home/hzh/.config/clash/config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target

# 4.节点管理
http://clash.razord.top/#/proxies

# 网络设置中配置代理（使用时要打开）
127.0.0.1:7890	# HTTP 代理
127.0.0.1:7890	# HTTPS 代理
127.0.0.1:7891	# Socks 主机
# 终端临时配置
export https_proxy="127.0.0.1:7890"
export http_proxy="127.0.0.1:7890"
