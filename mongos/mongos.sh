#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
myip=$(ifconfig | grep -A1 "eth0: " | awk '/inet/ {print $2}')
cat > /etc/mongod/mongos.conf <<EOF
pidfilepath = /var/run/mongodb/mongos.pid
logpath = /data/mongodb/mongos/log/mongos.log
logappend = true
bind_ip = 0.0.0.0
port = 20000
fork = true
configdb = configs/172.16.22.220:21000,172.16.22.221:21000,172.16.22.222:21000,172.16.22.223:21000 #监听的配置服务器,只能有1个或者4个，configs为配置服务器的副本集名字
maxConns=20000 #设置最大连接数
EOF

sed -i "s/0.0.0.0/$myip/"g /etc/mongod/mongos.conf
mongos -f /etc/mongod/mongos.conf
