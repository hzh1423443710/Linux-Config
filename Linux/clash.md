

# Linux配置Clash

## 下载

[Clash介绍](https://clash.wiki/)

[Linux下载网站](https://downloads.clash.wiki/ClashPremium) [Windows下载网站](https://downloads.clash.wiki/clash_for_windows_pkg) [Clash Verge官网下载 - Github/教程/Android推荐 - Clash Verge](https://clashverge.net/)

## 安装

```bash
$ mv clash-linux-amd64 /usr/local/bin/clash
```

## 订阅配置

```bash
# 2.手动导入 将Windows版的yaml配置文件复制 到Linux下$HOME/.config/clash/config.yaml
$ scp .\clash-verge.yaml hzh@Arch:/home/hzh/.config/clash
$ scp .\Country.mmdb hzh@Arch:/home/hzh/.config/clash
# 或自动导入订阅(如果支持)
$ wget -O config.yaml 订阅地址
```

## 配置服务

`vim /etc/systemd/system/clash.service`

```ini
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
```

## 网络设置(GUI)

```bash
# 网络设置中配置代理（使用时要打开）
127.0.0.1:7890	# HTTP 代理
127.0.0.1:7890	# HTTPS 代理
127.0.0.1:7891	# Socks 主机
```

## 临时设置(Terminal)

```bash
export https_proxy="127.0.0.1:7890"
export http_proxy="127.0.0.1:7890"
```

## 查看/切换代理

图形化界面：

- 浏览器访问 http://clash.razord.top/#/proxies
- 安装clash客户端

非图形化界面

1. curl url

```bash
# config.yaml中确保有以下
external-controller: 127.0.0.1:9090	
# 1.终端访问
# 查看所有代理组和节点信息
curl -X GET http://127.0.0.1:9090/proxies
# 查看指定代理组的信息及当前代理节点
curl -X GET http://127.0.0.1:9090/proxies/XFX
# 切换代理节点 为代理组XFX下的...
curl -X PUT http://127.0.0.1:9090/proxies/XFX -d '{"name":"公网|日本|1x"}'		
curl -X GET http://127.0.0.1:9090/configs			# 查看 Clash 的配置信息
	
# 2.vscode端口转发[9091]方便浏览器访问
http://127.0.0.1:9091/proxies 					   # 同上

# 3.验证
curl https://google.com/
```

2. download [clashcli_linux_amd64](https://github.com/shunf4/clashcli/tree/master)

```bash
# 选择代理组和代理节点
$ ./clashcli_linux_amd64
# 默认 <CLASH_SCHEME> <CLASH_ADDR> <CLASH_PORT> http://127.0.0.1:9090
# 取决于config.yaml
external-controller: 127.0.0.1:9090
```

