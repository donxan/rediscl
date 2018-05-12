#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
for ip in `seq 220 223`
do
  echo 172.16.22.$ip
  rsync -avzP ./shard.sh root@172.16.22.$ip:/root/
  ssh root@172.16.22.$ip "sh /root/shard.sh" 
done
