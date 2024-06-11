

## 下载

[Clash介绍](https://clash.wiki/)

[Linux下载网站](https://downloads.clash.wiki/ClashPremium) [Windows下载网站](https://downloads.clash.wiki/clash_for_windows_pkg)

## Linux配置

```bash
# 1.
$ mv clash-linux-amd64 /usr/local/bin/clash

# 2.手动导入 将Windows版的yaml配置文件复制 到Linux下$HOME/.config/clash/config.yaml
$ cd $HOME/.config/clash/
$ vim config.yaml 
# 或自动导入订阅(如果支持)
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

# 4.节点管理网站
http://clash.razord.top/#/proxies

# 网络设置中配置代理（使用时要打开）
127.0.0.1:7890	# HTTP 代理
127.0.0.1:7890	# HTTPS 代理
127.0.0.1:7891	# Socks 主机
# 终端临时配置
export https_proxy="127.0.0.1:7890"
export http_proxy="127.0.0.1:7890"
```
