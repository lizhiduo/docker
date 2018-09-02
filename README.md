# docker
--------------------------------
参考：[docker入门到实践](https://legacy.gitbook.com/book/yeasy/docker_practice/details)  
声明：内容主要来源宋老师博客 本文只为做个学习记录
## 什么是docker
> docker就是虚拟出操作系统，让应用之间彼此隔离。而像我们常用的VmWare和Virtualbox是虚拟出机器。  
>其区别在于，docker让两个进程觉得自己拥有自己的根文件系统以及各种系统资源等。而VM和Vbox则是让两个进程觉得自己运行在不同的机器上。所以docker达到了虚拟机的效果，但是又没有虚拟机的开销，仅仅是虚拟应用运行的环境。
## 什么是虚拟化
> 虚拟化的技术分为两种，一种虚拟一个新世界，一种是虚拟一个气氛。
> vBox和VM这种就是虚拟一个新世界。就像虚拟人生的游戏，在游戏的世界我们可以是一个和现实世界完全不相同的人。游戏给我们虚拟了一个全新的世界。
> docker属于虚拟气氛。就像公司的LINUX部门，以前只有3个人，然后一个manager。后来有30个人，然后就有内核组、驱动组、应用组，然后就有好几个manager。这种组类似名称空间，每一个单独的空间的manager都觉得自己是manager。docker就是这样的名称空间让各自在同样的LINUX平台上面，装到你自己的容器里面。
## 安装配置
> 1. 安装docker：`sudo apt-get update && apt-get install docker docker.io`
> 2. 用户配置将当前用户添加到docker用户组：`sudo usermod -aG docker $USER`
> 3. 重启docker服务：`sudo systemctl restart docker.service / sudo service docker restart`
> 4. 测试：执行`docker`
## docker三大核心概念
> 1. 镜像：类似虚拟机的镜像、用俗话说就是安装文件。
> 2. 容器：类似一个轻量级的沙箱，容器是从镜像创建应用运行实例，可以将其启动、开始、停止、删除、而这些容器都是相互隔离、互不可见的。<u>镜像和容器就像程序和进程的关系</u>,一个image也可以运行多份container。
> 3. 类似代码仓库，是Docker集中存放镜像文件的场所。
## 初体验
> 1. 运行官网的hello-world镜像：
  执行`docker run hello-world`，成功运行后，执行`docker images`可以看到镜像列表。
> 2. 删除镜像（删除镜像需要先删除容器）：
>> 查询容器/删除：
`docker ps -a`
`docker rm NAMES`
>> 查询/删除镜像：
`docker images`
`docker rmi ID`

> 3. 创建镜像
当我们从docker镜像仓库中下载的镜像不能满足我们的需求时，我们可以通过以下两种方式对镜像进行更改。
>>1. 使用 Dockerfile 指令来创建一个新的镜像
>>> 创建Dockerfile文件:  
```
FROM    ubuntu:16.04
MAINTAINER    Fisher "fisher@sudops.com"
RUN     /bin/echo 'root:123456' |chpasswd  
RUN     useradd duo  
RUN     /bin/echo 'duo:123456' |chpasswd
//RUN     apt-get update && apt-get install -y vim  
RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" >/etc/default/local
EXPOSE  22  
EXPOSE  80
CMD     /usr/sbin/sshd -D
```  
>> 执行`docker build -t duo/ubuntu:16.04 .`构建镜像。构建成功后，执行`docker images`可以查看镜像列表。执行`docker run -t -i duo/ubuntu:16.0 /bin/bash`可以运行镜像。
>>2. 从已经创建的容器中更新镜像，并且提交这个镜像
>>> 基于步骤1中的ubunt镜像做增量，运行镜像在容器中执行`apt-get update && apt-get install gcc`安装编译器（vim也一样可以在容器中安装，也可以像步骤1中，构建镜像时候添加命令安装）。
>>> commit增量镜像，先执行`exit`退出容器，然后执行`docker commit -m="add gcc" -a="lizhiduo" e218edb10161 duo/ubuntu:v2`。
参数说明：
>>>> - -m:提交的描述信息
>>>> - -a:指定镜像作者
>>>> - e218edb10161:容器ID
>>>> - duo/ubuntu:v2:指定要创建的目标镜像名
>>> 执行`docker images`可以查看新镜像，执行`docker run -ti duo/ubuntu:16.0 bash`运行新镜像。
