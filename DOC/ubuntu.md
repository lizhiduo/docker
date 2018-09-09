# Docker ubuntu初步配置
## 安装vim
> 1. `apt-get install vim`
> 2. 配置vim:`wget -qO- https://raw.github.com/ma6174/vim/master/setup.sh | sh -x`
## 创建新用户
> 1. 新增新用户：`adduser xx` 会在`hmoe`目录下创建用户目录。
> 2. 增加`root`权限:
>> 安装`sudo`：`apt-get install sudo`；然后在 `/etc/sudoers`添加`xxx ALL = NOPASSWD: ALL`
