## Pre-installation

### 启动到 live 环境

### 验证引导模式

```bash
$ ls /sys/firmware/efi/efivars
```

> **如果命令结果显示了目录且没有报告错误，则系统是以 UEFI 模式引导。如果目录不存在，则系统可能是BIOS模式**

### 连接到互联网

### 更新系统时间

```bash
$ timedatectl set-ntp true	# 启用ntp自动同步时间
$ timedatectl status		# 查看当前系统的日期、时间和时区设置
```

### 磁盘分区

- EFI 系统分区——用于存储 UEFI 固件所需的文件。
- ROOT – 用于安装发行版本身。
- SWAP – 用作内存交换分区。

```bash
$ fdisk -l
$ cfdisk	# 为基于 UEFI 的系统选择 gpt
```

|    挂载点     |           分区            |        分区类型         |
| :-----------: | :-----------------------: | :---------------------: |
| /mnt/boot/efi | /dev/efi_system_partition |      EFI 系统分区       |
|    [SWAP]     |   /dev/*swap_partition*   |  Linux swap (交换空间)  |
|     /mnt      |    /dev/root_partition    | Linux x86-64 根目录 (/) |

### 格式化分区

```bash
$ mkfs.fat -F32 /dev/sda1	# EFI 系统分区[EFI System]
$ mkfs.ext4 /dev/sda2		# root分区
$ mkswap /dev/sda3			# 交换分区
```

### 挂载分区

```bash
$ mount /dev/sda2 /mnt
$ mount /dev/efi_system_partition /mnt/boot
$ swapon /dev/sda3
```



## Installation

### 配置国内源

[archlinux | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/archlinux/)

[archlinuxcn | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/archlinuxcn/)



### 安装必需的软件包

```bash
$ pacstrap /mnt base base-devel linux linux-firmware sudo vim networkmanager 
$ pacstrap /mnt man-db man-pages git 
```



## Configure the system

### 生成fstab

`genfstab` 程序可以检测给定挂载点以下的所有当前挂载

```bash
$ genfstab -U /mnt >> /mnt/etc/fstab
```

### chroot到新安装的系统

```bash
$ arch-chroot /mnt
```

### 设置时区

```bash
$ ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
```

### 本地化

```bash
$ vim /etc/locale.gen	
$ locale-gen			# 读取 /etc/locale.gen 文件并生成相应地语言环境
$ vim /etc/locale.conf	# LANG=zh_CN.UTF8 全局配置
$ vim /home/hzh/.bashrc # 修改用户的LANG=zh_CN.UTF8
```

> **本地tty不能显示中文(中文会变成方块)**
>
> **远程pts可以正常显示中文**

### 网络配置

```bash
$ pacman -S networkmanager openssh
$ systemctl enable NetworkManager
$ systemctl enable sshd
# 修改主机名
$ vim /etc/hostname
```

### 设置 root 密码

```bash
$ passwd
$ useradd -m -G wheel hzh	# 添加用户
$ passwd hzh
$ vim /etc/sudoers			# 取消注释组权限 # %wheel ALL=(ALL) ALL
```

### 安装 Microcode

```bash
$ pacman -S amd-ucode
$ pacman -S intel-ucode
```

### 安装引导程序

​	为了启动 Arch Linux，必须配置一个与 Linux 兼容的引导加载程序。引导加载程序负责在初始化启动进程之前，加载好内核和 initial ramdisk

```bash
$ pacman -S grub efibootmgr
$ grub-install --target=x86_64-efi --bootloader-id=grub	# 在新挂载的 EFI 系统分区中安装 GRUB
$ grub-mkconfig -o /boot/grub/grub.cfg					# 生成 GRUB 配置文件
```

> `grub-install`会自动寻找可用的EFI系统分区并将GRUB引导加载程序安装到该分区中
>
> 如果与其他操作系统一起安装，还需要 `os-prober` 包

### 重新启动计算机

```bash
$ exit				# 退出 chroot 环境
$ umount -R /mnt	# 手动卸载被挂载的分区
$ reboot
```



## Pre-installation

### 桌面环境

1. 要在系统上运行带有图形用户界面的程序，需要安装 X Window System 实现。最常见的是 Xorg。

```bash
$ pacman -S xorg-server
```

2. 安装图形驱动程序(可选)

```bash
$ pacman -S nvidia nvidia-utils
$ pacman -S xf86-video-amdgpu
$ pacman -S xf86-video-intel
```

3. 安装 xfce4

```bash
$ pacman -S xfce4 xfce4-goodies
```

```bash
# lightdm
$ pacman -S lightdm lightdm-gtk-greeter	# 显示管理器
$ systemctl enable lightdm				# 自启动
$ pacman -S network-manager-applet		# 网络管理器 托盘+编辑器
```

> 除了装lightdm,还需要一个greeter[LightDM - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/LightDM)



### 声音

```bash
$ pacman -S pavucontrol pulseaudio
```

### 中文本地化

[中文本地化 - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/中文本地化)

- 中文字体

```bash
$ pacman -S wqy-microhei		# 中文字体
$ pacman -S noto-fonts-cjk		# 更丰富
```

- 中文输入法

```bash
$ pacman -S fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool	# 输入法框架
$ pacman -S fcitx5-chinese-addons							# 中文引擎
$ pacman -S fcitx5-pinyin-zhwiki							# 词库
$ pacman -S fcitx5-breeze 									# breeze主题
fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-breeze
```

- 显示中文

[xprofile - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/Xprofile)

```bash
# vim ~/.xprofile
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

export GTK_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"
```



### pacman/yay

[Arch Linux - Package Search](https://archlinux.org/packages/)

[AUR (zh_CN) - 软件包 (archlinux.org)](https://aur.archlinux.org/packages)

```bash
$ pacman -S							# 安装
$ pacman -Rsn 						# 同事删除依赖 不保存其配置文件
$ pacman -Syu						# 升级
$ pacman -Ss rust					# 搜索软件包
$ pacman -Qs rust					# 查询软件包是否安装

$ pacman -Sy yay					# 从 Arch Linux CN 源安装yay
$ pacman -Sy archlinuxcn-keyring	# 导入 GPG key
```

