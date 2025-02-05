# SSH

## SSH

- 生成SSH密钥对

```bash
$ sudo apt-get install openssh-server
$ ssh-keygen -t rsa -C "your_email@youremail.com"
 # -t rsa指定生成RSA算法的密钥对
 # -C 添加一个注释，一般为你的邮箱地址。
```

> ssh-keygen 会在~/.ssh目录下生成id_rsa(私钥)和id_rsa.pub(公钥)

- 用途:
  - 远程登录：将公钥添加到远程服务器的`authorized_keys`文件中,使用私钥进行无密码的SSH连接。
  - 文件传输：SCP, SFTP
  - Git

- 拷贝公钥

```bash
# 将 公钥 添加到远程主机的 authorized_keys 文件中
$ ssh-copy-id user@remote_host
```

> ​	`authorized_keys`文件用于存放被信任的远程主机的公钥, 每个公钥应该占据一行，通常以ssh-rsa或ssh-ed25519开头，后面紧跟着一串由SSH密钥生成命令生成的密钥内容。

- 验证

```bash
ssh -T git@gitee.com
```

## vscode-SSH免密

```bash
sudo apt update
sudo apt install openssh-server
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys # 放入Windows公钥
```



## 允许root登录

- ssh登录到root
- scp拷贝到root

```bash
$ vim /etc/ssh/sshd_config 
# 添加
PermitRootLogin yes
```



## 端口转发

### 本地端口转发

将本地端口转发到远程服务器

任何连接到**本地计算机上指定端口**的应用程序的数据都将被透明安全地转发到**远程服务器上的目标端口**。

```bash
ssh -L local_port:remote_host:remote_port user@remote_server
```

- `local_port`：在本地计算机上要监听的端口号。
- `remote_host`：远程服务器上要连接的目标主机名或IP地址。
- `remote_port`：远程主机上要连接的目标端口号。
- `user`：在远程服务器上使用的用户名。
- `remote_server`：远程服务器的主机名或IP地址。

**Example:**

将本地计算机的 8080 端口转发到远程服务器的 80 端口上

```bash
ssh -L 8080:localhost:80 user@remote_host
```



### 远程端口转发

将远程服务器的端口转发到本地

```bash
ssh -R remote_port:localhost:local_port user@remote_server
```

- `remote_port`：远程服务器上要监听的端口号。
- `localhost`：远程服务器上要连接的目标主机名或IP地址。通常情况下，它是"localhost"，因为您希望从远程服务器本身访问转发的端口。
- `local_port`：本地计算机上要连接的目标端口号。
- `user`：这远程服务器上使用的用户名。
- `remote_server`：远程服务器的主机名或IP地址。

Example:

​	任何连接到远程服务器的8080端口的请求都会被透明地转发到您的本地计算机上的80端口，并且所有的响应也会通过相同的隧道返回

```bash
ssh -R 8080:localhost:80 user@example.com
```

> - 默认情况下，远程端口转发**只允许**从远程服务器的**本地回环地址**（127.0.0.1）进行访问
>
> - 其他地址也能访问被转发的端口:
>
> ​	修改服务器的`/etc/ssh/sshd_config`文件中更改`GatewayPorts`设置为"yes"

