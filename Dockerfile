FROM    ubuntu:16.04
MAINTAINER    zero "lizhiduo@aliyun.com"

RUN     /bin/echo 'root:123456' |chpasswd
RUN     useradd duo
RUN     /bin/echo 'duo:123456' |chpasswd
RUN     /bin/echo -e "LANG=\"en_US.UTF-8\"" >/etc/default/local
#RUN     apt-get update && apt-get install -y vim
#RUN     apt-get update && apt-get install -y gcc

EXPOSE  22
EXPOSE  80
CMD     /usr/sbin/sshd -D
