#!/bin/bash
Backup_Dir="/backup"
Host_IP=`hostname -I | awk '{print $2}'`
Date_Info=`date +%F_%w -d "-1day"`

# create backup dir
mkdir -p $Backup_Dir/$Host_IP/

# backup info compress
cd /
tar zcvhf $Backup_Dir/$Host_IP/sys_backup_${Date_Info}.tar.gz var/spool/cron/root /etc/rc.local /server/scripts /etc/sysconfig/iptables

# check data info,create finger file
cd $Backup_Dir
find / -type f -name "*_${Date_Info}.tar.gz" | xargs md5sum >$Backup_Dir/$Host_IP/finger.txt

# push backup data to backup server
rsync -az $Backup_Dir/ rsync_backup@172.16.1.41::backup --password-file=/password.pwd

# delete 7 day ago 
find $Backup_Dir/ -type f -name "*.tar.gz" -mtime +7 | xargs rm -f