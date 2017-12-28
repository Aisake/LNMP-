#!/bin/bash

# user add

useradd nginx

# check&install environment

##pkg_list=`cat pkg_list.txt`

pkg_list="curl openssl libpng freetype libxslt libjpeg"

#for i in ${pkg_list}
#do
#  yum info $i &>/dev/null
#  if (( $? == 1 ))
#     then
#        yum install $i-devel
#
#        if (( $? == 1 ))
#          then
#           echo "package $i install failed"
#          else
#           echo "package $i install success"
#        fi
#  else
#     echo -e "\033[31m package $i was already installed \033[0m"
#  fi
#done

for i in ${pkg_list}
do
    yum install $i-devel -y
done

cd /usr/local/src
wget ftp://91.121.203.120/libxml2/libxml2-2.9.5.tar.gz
tar xf libxml2-2.9.5.tar.gz
cd libxml2-2.9.5
./configure
make && make install

cd /usr/local/src
wget ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/attic/libmcrypt/libmcrypt-2.5.7.tar.gz
tar xf libmcrypt-2.5.7.tar.gz
cd libmcrypt-2.5.7
./configure
make && make install

echo '/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64'>>/etc/ld.so.conf && ldconfig -v


# download php

cd /usr/local/src
wget http://cn2.php.net/distributions/php-5.6.31.tar.gz
tar xf php-5.6.31.tar.gz

# install php

cd php-5.6.31
./configure --prefix=/application/php-5.6.31 --enable-mysqlnd --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --enable-xml --disable-rpath --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --enable-mbregex --enable-fpm --enable-mbstring --with-mcrypt --with-gd --with-gettext --enable-gd-native-ttf --with-openssl --with-mhash --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --enable-short-tags --enable-static --with-xsl --with-fpm-user=www --with-fpm-group=www --enable-opcache=no  --enable-ftp
make && make install 

# edit nginx.conf

sed -i '64 r sed.txt' /application/nginx/conf/nginx.conf
sed -i 's#index  index.html index.htm#index  index.html index.htm index.php#g' /application/nginx/conf/nginx.conf

# copy ini

cd /usr/local/src/php-5.6.31
cp php.ini-production /application/php-5.6.31/lib/php.ini
cd /application/php-5.6.31/etc/
cp php-fpm.conf.default php-fpm.conf

sed -i 's#user = www#user = nginx#g' php-fpm.conf
sed -i 's#group = www#group = nginx#g' php-fpm.conf


# start php & reload nginx

/application/php-5.6.31/sbin/php-fpm
/application/nginx/sbin/nginx -s reload
