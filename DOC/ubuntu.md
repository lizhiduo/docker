# Docker ubuntu初步配置
## 安装vim
> 1. `apt-get install vim`
> 2. 配置vim:`wget -qO- https://raw.github.com/ma6174/vim/master/setup.sh | sh -x`
## 创建新用户
> 1. 新增新用户：`adduser xx` 会在`hmoe`目录下创建用户目录。
> 2. 增加`root`权限:
>> 安装`sudo`：`apt-get install sudo`；然后在 `/etc/sudoers`添加`xxx ALL = NOPASSWD: ALL`

# NSF

> 1. 安装：`sudo apt-get install nfs-kernel-server`
>
> 2. 配置nfs根目录，在`/etc/exports`文件中添加如下内容：
>
>    ```
>    /home/lizd/work1/rootfs *(rw,sync,no_root_squash,no_subtree_check)
>    ```
>
> 3. 重启相关服务：
>
>    ```
>    /etc/init.d/rpcbind  restart
>    /etc/init.d/nfs-kernel-server  restart
>    ```

# tftpd

> 1. 安装：`sudo apt-get install tftp-hpa tftpd-hpa xinetd`
>
> 2. 配置（ /etc/default/tftpd-hpa）：
>
>    ```
>    TFTP_USERNAME="tftp"
>    TFTP_DIRECTORY="/home/lizd/tftpboot"
>    TFTP_ADDRESS="0.0.0.0:69"
>    TFTP_OPTIONS="-l -c -s"
>    ```
>
> 3. 重启：`sudo /etc/init.d/tftpd-hpa restart`