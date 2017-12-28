#!/bin/bash
yum install -y nfs-utils nfs4-acl-tools portmap
cat >>/etc/exports/<<EOF
/web 10.0.0.8(rw,no_root_squash,sync)
EOF
exportfs -r
echo "portmap:ALL" >>/etc/hosts.deny
echo "portmap:10.0.0.8" >>/etc/hosts.allow
/etc/init.d/rpcbind start
service nfs start
showmount -e localhost