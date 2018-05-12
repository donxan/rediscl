#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
myip=$(ifconfig | grep -A1 "eth0: " | awk '/inet/ {print $2}')
cat > /etc/mongod/shard1.conf <<EOF
pidfilepath = /var/run/mongodb/shard1.pid
dbpath = /data/mongodb/shard1/data
logpath = /data/mongodb/shard1/log/shard1.log
logappend = true
bind_ip = 0.0.0.0
port = 27001
fork = true
#httpinterface=true #打开web监控,3.6已经不提供此功能，启用会报错
#rest=true #3.6已经不提供此功能，启用会报错
replSet=shard1 #副本集名称
shardsvr = true #declare this is a shard db of a cluster;
maxConns=20000 #设置最大连接数
EOF
sed -i "s/0.0.0.0/$myip/"g /etc/mongod/shard1.conf
for s in `seq 2 4`
do
  cp /etc/mongod/shard1.conf /etc/mongod/shard$s.conf
  sed -i "s/shard1/shard$s/"g /etc/mongod/shard$s.conf
  sed -i "s/27001/2700$s/"g /etc/mongod/shard$s.conf
  mongod -f /etc/mongod/shard$s.conf 
done
mongod -f /etc/mongod/shard1.conf 
