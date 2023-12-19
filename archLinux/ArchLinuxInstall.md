## 1.Pre-installation

### 启动到 live 环境

禁用安全启动:Arch Linux 安装镜像不支持 UEFI 安全启动（Secure Boot）功能

### 设置字体

```bash
$ setfont /usr/share/kbd/consolefonts/ter-* # 数字越大字体越大 b代表加粗
```



### 验证引导模式

```bash
$ ls /sys/firmware/efi/efivars
```

> **如果命令结果显示了目录且没有报告错误，则系统是以 UEFI 模式引导。如果目录不存在，则系统可能是BIOS模式**

### 连接到互联网

#### wifi连接

```bash
$ rfkill list # 检查wifi功能是否锁定
$ rfkill unlock wifi

$ ip link # 查看网卡
$ ip link set <wlan> up

$ iwctl	
 $ station <wlan> scan
 $ station <wlan> get-networks
 $ station <wlan> connect <name>
```



### 更新系统时间

```bash
$ timedatectl set-ntp true	# 启用 ntp自动同步时间
$ timedatectl status		# 查看 当前系统的日期、时间和时区设置
```

### 磁盘分区

- EFI 系统分区——用于存储 UEFI 固件所需的文件。
- ROOT – 用于安装发行版本身。
- SWAP – 用作内存交换分区。

```bash
$ fdisk -l
$ cfdisk	# 为基于 UEFI 的系统选择 gpt
```

**对于 UEFI 与 GPT 分区表的磁盘分区方案:**

|  挂载点   |            分区             |        分区类型         |
| :-------: | :-------------------------: | :---------------------: |
| /mnt/boot | */dev/efi_system_partition* |      EFI 系统分区       |
|  [SWAP]   |    */dev/swap_partition*    |  Linux swap (交换空间)  |
|   /mnt    |    */dev/root_partition*    | Linux x86-64 根目录 (/) |

**对于传统 BIOS 与 MBR 分区表的磁盘分区方案:**

|  挂载点  |         分区          |       分区类型        |
| :------: | :-------------------: | :-------------------: |
| `[SWAP]` | */dev/swap_partition* | Linux swap (交换空间) |
|  `/mnt`  | */dev/root_partition* |         Linux         |

### 格式化分区

```bash
$ mkfs.fat -F32 /dev/efi_system_partition
$ mkfs.ext4 /dev/root_partition
$ mkswap /dev/*swap_partition
```

### 挂载分区

```bash
$ mount /dev/root_partition /mnt
$ mount /dev/efi_system_partition /mnt/boot
$ swapon /dev/swap_partition
```



## 2.Installation

### 配置国内源

[archlinux | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/archlinux/)

编辑 `/etc/pacman.d/mirrorlist`，在文件的最顶端添加：

```bash
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch
```

```bash
$ pacman -Syyu
```

[archlinuxcn | 镜像站使用帮助 | 清华大学开源软件镜像站 | Tsinghua Open Source Mirror](https://mirrors.tuna.tsinghua.edu.cn/help/archlinuxcn/)

使用方法：在 `/etc/pacman.conf` 文件末尾添加以下两行：

```bash
[archlinuxcn]
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
```

```bash
$ pacman -Sy archlinuxcn-keyring
```

> 若签名错误在 [archlinuxcn] 后添加 SigLevel = Optional TrustAll 

安装yay

```bash
$ pacman -Sy yay
```



### 安装必需的软件包

在安装盘挂载点 /mnt 目录下安装基本软件包

```bash
$ pacstrap /mnt base base-devel linux linux-firmware sudo vim networkmanager openssh man-db man-pages fish git 
```



## 3.Configure the system

### 生成fstab

`genfstab` 程序可以检测给定挂载点以下的所有当前挂载(用 `-U` 或 `-L` 选项设置 UUID 或卷标):

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

然后运行 hwclock 以生成 `/etc/adjtime`：

```bash
$ hwclock --systohc
```

### 本地化

```bash
$ vim /etc/locale.gen	
$ locale-gen			# 读取 /etc/locale.gen 文件并生成相应地语言环境
$ vim /etc/locale.conf	# LANG=zh_CN.UTF8 全局配置
$ vim /home/hzh/.bashrc # 修改用户的LANG=zh_CN.UTF8
```

> **本地tty不能显示中文(中文会变成方块) 远程pts可以正常显示中文**

### 网络配置

```bash
$ pacman -S networkmanager wireless_tools
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
# 1.
$ pacman -S grub efibootmgr os-prober
# 2.生成/boot/EFI/GRUB/grubx64.efi 和 /boot/grub/
$ grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
# 3.生成 GRUB 配置文件
$ grub-mkconfig -o /boot/grub/grub.cfg
```

> 双系统需要修改 `/etc/default/grub`(grub软件自带) 中的 `GRUB_DISABLE_OS_PROBER=false`

### 重启

```bash
$ exit				# 退出 chroot 环境
$ umount -R /mnt	# 手动卸载被挂载的分区
$ reboot
```



## 4.Post-installation

### tty字体

```bash
$ pacman -S terminus-font
# 临时设置
$ setfont /usr/share/kbd/consolefonts/ter-v28b.psf.gz
# 持久化设置
echo "FONT=ter-v28b" >> /etc/vconsole.conf
```

### 关闭终端响铃

```bash
# vim /etc/inputrc 
set bell-style none # 取消 注释
```



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
# lightdm
$ pacman -S lightdm lightdm-gtk-greeter	# 显示管理器
$ systemctl enable lightdm				# 自启动
$ pacman -S network-manager-applet		# 网络管理器 托盘+编辑器
```

4. 安装 KDE

```bash
$ pacman -S plasma 						# kde-applications挑软件
$ systemctl enable sddm

$ dolphin 
```



### 声音

```bash
$ pacman -S pavucontrol pulseaudio
$ pacman -S alsa-utils
```

### 中文

[中文本地化 - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/中文本地化)

- 中文字体

```bash
$ pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
```

- 中文输入法

```bash
# 1.输入法框架 中文引擎 wiki词库 主题
$ pacman -S fcitx5-im fcitx5-chinese-addons fcitx5-pinyin-zhwiki fcitx5-material-color
$ yay -S fcitx5-pinyin-sougou	# 搜狗词库
# 2.安装 fcitx5-input-support (AUR) 
# 或者编辑 /etc/environment 并添加以下几行
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
GLFW_IM_MODULE=ibus
```

- 显示中文

[xprofile - Arch Linux 中文维基 (archlinuxcn.org)](https://wiki.archlinuxcn.org/wiki/Xprofile)

```bash
# vim ~/.xprofile
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
```



### pacman/yay

[Arch Linux - Package Search](https://archlinux.org/packages/)

[AUR (zh_CN) - 软件包 (archlinux.org)](https://aur.archlinux.org/packages)

```bash
$ pacman -S							# 安装
$ pacman -Rsn 						# 移除 包 并删除依赖 不保存其配置文件
$ pacman -Syu						# 升级
$ pacman -Ss <pkg>					# 搜索 软件包
$ pacman -Qs <pkg>					# 查询 软件包是否安装
$ pacman -Qo <path>					# 查询 文件属于哪个包
$ pacman -Si <pkg>					# 查看 包信息
```



### 虚拟机

```bash
$ open-vm-tools
```

