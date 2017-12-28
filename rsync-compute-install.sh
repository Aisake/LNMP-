#!/bin/bash
yum install -y rsync
echo "please enter the rsync password:"
read password
echo "$password" >>/password.pwd
chmod 600 /password.pwd