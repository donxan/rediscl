#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
myip=$(ifconfig | grep -A1 "eth0: " | awk '/inet/ {print $2}')
mkdir /etc/mongod/
cat > /etc/mongod/config.conf <<EOF
pidfilepath = /var/run/mongodb/configsrv.pid
dbpath = /data/mongodb/config/data
logpath = /data/mongodb/config/log/congigsrv.log
logappend = true
bind_ip = 0.0.0.0
port = 21000
fork = true
configsvr = true
replSet=configs
maxConns=20000
EOF
sed -i "s/0.0.0.0/$myip/g" /etc/mongod/config.conf
mongod -f /etc/mongod/config.conf
