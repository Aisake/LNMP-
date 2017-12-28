#!/bin/bash

#Backup_Dir=`find /backup -name "172.16.1.*" -type d`

# check-info
#cd ${Backup_Dir}
md5sum -c $(find /backup -type f -name "finger.txt") >/backup/check-info.txt

# send mail
mail -s "check_info" behuman@vip.qq.com < /backup/check-info.txt

# delete 180 day ago
find /backup -type f -mtime +180 ! -name "*_1.tar.gz" | xargs rm -f