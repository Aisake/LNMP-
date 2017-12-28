#!/bin/bash
echo "Please input the rsync username:"
read username
echo "Please input the rsync username password:"
read password
echo "Please input the allow ip address:"
read allowip
echo "Please input the path you want to rsync:"
read rsyncpath
echo "==========================input all completed========================"
echo "==========================install rsync========================"
syslog facility = local3
syslog facility = local3
yum -y install rsync
useradd $username
mkdir /etc/rsyncd
cat >/etc/rsyncd.conf<<EOF
# Minimal configuration file for rsync daemon
# See rsync(1) and rsyncd.conf(5) man pages for help

# This line is required by the /etc/init.d/rsyncd script
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
port = 873
#address = $serverip
#uid = nobody
#gid = nobody
uid = rsync_backup
gid = rsync_backup

use chroot = no
read only = false

#limit access to private LANs
#hosts allow=$allowip
#hosts deny=*

max connections = 200
motd file = /etc/rsyncd/rsyncd.motd

#This will give you a separate log file
log file = /var/log/rsync.log

#This will log every file transferred - up to 85,000+ per user, per sync
#transfer logging = yes
ignore errors
log format = %t %a %m %f %b
syslog facility = local3
timeout = 300
secrets file = /etc/rsyncd/rsyncd.secrets
list=false

[backup]
path = $rsyncpath
auth users = $username
EOF
echo "$username:$password" > /etc/rsyncd/rsyncd.secrets
chmod 600 /etc/rsyncd/rsyncd.secrets
cat >/etc/rsyncd/rsyncd.motd<<EOF
+++++++++++++++++++++++++++
+         rsync           +
+++++++++++++++++++++++++++
EOF
/usr/bin/rsync --daemon
echo "/usr/bin/rsync --daemon" >>/etc/rc.d/rc.local
ps -aux | grep rsync