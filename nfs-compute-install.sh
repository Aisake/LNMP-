#!/bin/bash
yum install -y nfs-utils nfs4-acl-tools portmap
/etc/init.d/rpcbind start
service nfs start
showmount -e 10.0.0.31
mount -t nfs 10.0.0.31:/web /var/html/www
mount
echo "/var/html/www 10.0.0.31:/web" >>/etc/fstab