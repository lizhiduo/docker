# qemu arm9
实验环境：ubuntu16.04
## qemu安装
>  安装qemu:`sudo apt-get install qemu`

## kernel
> 1. 下载 kernel(3.16) : `wget https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.16.tar.xz`
> 2. 解压：`xz -d xx.tar.xz`;`tar xvf xx.tar`
> 3. 配置编译kernel:
>> * 安装交叉编译工具链：`sudo apt-get install gcc-4.7-arm-linux-gnueabi`,关于交叉编译器版本，最好使用4.7,其它版本可能会导致编译不过；建立软连接：`ln -s /usr/bin/arm-linux-gnueabi-gcc-4.7 /usr/bin/arm-linux-gnueabi-gcc`; 安装bc:`sudo apt-get install bc`
>> *  配置编译：
```
>> make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm vexpress_defconfig
>> make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm menuconfig
>> make CROSS_COMPILE=arm-linux-gnueabi- ARCH=arm -j8
```
## 制作initrd
```
/*hello.c*/  
#include <stdio.h>  

void main()  
{  
    printf("Hello World\n");  
    printf("Hello World\n");  
    printf("Hello World\n");  
　　/*强制刷新输出，不然可能打印不出来*/  
    fflush(stdout);  
    while(1);  
}  
```
静态编译：
`arm-linux-gnueabi-gcc -static hello.c -o hello`
制作成cpio  
`echo helloworld | cpio -o --format=newc > rootfs.img（find . | cpio -o -Hnewc | gzip -9 > ../rootfs.img）`
运行：
`qemu-system-arm -M vexpress-a9 -m 512M -kernel linux-3.16/arch/arm/boot/zImage -initrd rootfs.img  -nographic -append "console=ttyAMA0   rdinit=hello"`
## busybox编译
> 下载busybox：`wget http://www.busybox.net/downloads/busybox-1.26.0.tar.bz2`
> 解压：`tar xvzf busybox-1.26.0.tar.bz2`
> 配置编译：
> ```
make defconfig
make CROSS_COMPILE=arm-linux-gnueabi- menuconfig
make CROSS_COMPILE=arm-linux-gnueabi-
make CROSS_COMPILE=arm-linux-gnueabi- install
```
## 创建根文件系统镜像
> 创建根文件目录：
`mkdir  rootfs`
`mkdir bin dev etc lib proc sbin sys usr mnt tmp`
> 创建配置文件:
> ```
cd  etc(rootfs下的etc)
mkdir init.d
touch init.d/rcS fstab profile
```
>> rcS:
>> 修改文件权限：chmod +x rcS
>> ```
>> #!/bin/sh
/bin/mount -a
/bin/mount -t tmpfs mdev /dev
mdev -s
```
>> fstab:
>> ```
>> proc        /proc    proc    defaults    0    0
sysfs           /sys    sysfs   defaults    0   0
```
>> profile:
>> ```
>> #/etc/profile: system-wide .profile file for the Bourne shells
>>
>> echo
echo -n "Processing /etc/profile... "
echo "Done"
echo
```

> 创建设备文件:
> ```
cd rootfs
sudo mknod -m 666 dev/console c 5 1
sudo mknod -m 666 dev/null c 1 3
```
> 安装busybox:
> * 进入busybox根目录：`cd cd busybox-1.26.0`
> * 修改`.config`安装目录`CONFIG_PREFIX="../rootfs/"`
> * 执行`make CROSS_COMPILE=arm-linux-gnueabi- install`

> 制作cpio镜像：
> 执行如下命令：`cd rootfs && find . | cpio -o -Hnewc | gzip -9 > ../rootfs.img`

> 制作ext3格式镜像：
> 1. 生成32M大小的镜像
 `dd if=/dev/zero of=rootfs.ext3 bs=1M count=32`
> 2. 格式化成ext3文件系统
`mkfs.ext3 rootfs.ext3`
> 3.  将文件拷贝到镜像中
> ```
> mkdir tmpfs
sudo mount -t ext3 rootfs.ext3 tmpfs/ -o loop
sudo cp -r rootfs/*  tmpfs/
sudo umount tmpfs
```

> 运行：
> * 运行cpio:
> `qemu-system-arm -M vexpress-a9 -m 512M -kernel linux-3.16/arch/arm/boot/zImage -initrd rootfs.img  -nographic -append "console=ttyAMA0 rdinit=sbin/init"`
> * 运行ext3:
> `qemu-system-arm -M vexpress-a9 -m 512M -kernel linux-3.16/arch/arm/boot/zImage -nographic -append "root=/dev/mmcblk0 console=ttyAMA0" -sd ./rootfs.ext3`
