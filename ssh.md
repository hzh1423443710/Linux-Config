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

## 