#!/bin/bash

# stop firewall

service iptables stop
chkconfig iptables off

# ntpdate

ntpdate pool.ntp.org

# install environment

yum -y install gcc automake autoconf libtool make
yum install gcc gcc-c++

# make source directory

if [ ! -d "/usr/local/src/" ]
   then
    mkdir -p /usr/local/src
fi
cd /usr/loacl/src
pwd

# install pcre

cd /usr/local/src/
wget -t0  ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.41.tar.gz
tar xf pcre-8.41.tar.gz
cd pcre-8.41
./configure
make && make install
if [ $? -ne 0 ]
   then 
    echo "pcre install failed"
else
   echo "pcre install success"
fi

# install zlib

cd /usr/local/src/
wget -t0 http://zlib.net/zlib-1.2.11.tar.gz
tar xf zlib-1.2.11.tar.gz
cd zlib-1.2.11
./configure
make && make install

if [ $? -ne 0 ]
   then
    echo "zlib install failed"
else
   echo "zlib install success"
fi

# install ssl

cd /usr/local/src/
wget -t0 https://www.openssl.org/source/openssl-1.1.0f.tar.gz
tar xf openssl-1.1.0f.tar.gz

# add user

useradd -s /sbin/nologin -M www

# install nginx

mkdir -p /application/nginx
cd /usr/local/src/
wget -t0 http://nginx.org/download/nginx-1.11.13.tar.gz
tar xf nginx-1.11.13.tar.gz
cd nginx-1.11.13

./configure --prefix=/application/nginx/ --error-log-path=/application/nginx/error.log --http-log-path=/application/nginx/access.log --user=www --group=www --with-http_ssl_module --with-pcre=/usr/local/src/pcre-8.41 --with-zlib=/usr/local/src/zlib-1.2.11 --with-openssl=/usr/local/src/openssl-1.1.0f

make && make install

# start nginx

/application/nginx/sbin/nginx

