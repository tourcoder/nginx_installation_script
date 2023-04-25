#!/bin/bash

# One-click installation script for nginx
#
# Implemented by Bin Hua <https://bin.tourcoder.com>

red='\e[91m'

# Common
get_latest_release() {
  curl --silent "https://api.github.com/repos/nginx/nginx/tags" | jq -r '.[0].name'              
}

echo `get_latest_release`

clear
echo "-------------------------"
echo "nginx installation script"
echo "-------------------------"

# need root
if [ "$(id -u)" != "0" ]; then
   echo "The script requires root authority to install" 1>&2
   exit 1
fi

if [ `rpm -qa | grep $pretool |wc -l` -ne 0 ];then
	echo -e "nginx is already installed"
	exit 1
fi

echo "start..."

# 安装编译需要到的库
yum install gcc gcc-c++ autoconf automake zlib zlib-devel openssl openssl-devel pcre pcre-devel libxml2-devel -y
# 增加用户
groupadd www
useradd -M -g www www -s /sbin/nologin
# 编译
cd /usr/tmp
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar -zvxf nginx-${nginx_version}.tar.gz
mv nginx-${nginx_version} nginx
cd nginx
# ./configure  
configure_opts=(
--prefix=/usr/local/nginx
--user=www 
--group=www 
--with-http_ssl_module
)
./configure ${configure_opts[@]}
if [[ $? -eq 0 ]]
then
	make && make install
else
	echo "编译失败，请重试"
	exit 1
fi
权限
chown -R www.www /usr/local/nginx/
# 开机启动
echo "/usr/local/nginx/sbin/nginx" >>/etc/rc.local
# 设置执行权限
cd /etc
chmod 755 rc.local
#环境变量与服务
echo "export PATH=$PATH:/usr/local/nginx/sbin" >> /etc/profile
export PATH=$PATH:'/usr/local/nginx/sbin'
source /etc/profile
# 启动
cd /usr/local/nginx/sbin
./nginx

echo "nginx 已经启动"
```

```
#!/usr/bin/env bash

if["$(uname)"=="Darwin"];then

    # Mac OS X 操作系统

elif["$(expr substr $(uname -s) 1 5)"=="Linux"];then

    # GNU/Linux操作系统

elif["$(expr substr $(uname -s) 1 10)"=="MINGW32_NT"];then

    # Windows NT操作系统

fi
