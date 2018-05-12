#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
for ip in `seq 220 223`
do
  echo 172.16.22.$ip
  rsync -avzP ./mongod.sh root@172.16.22.$ip:/tmp/
  ssh root@172.16.22.$ip "sh /root/mongod.sh" 
done
