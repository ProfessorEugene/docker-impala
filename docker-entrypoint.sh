#!/bin/bash -e

# start postgres
sudo service postgresql start

# start hdfs

declare -a hostname=($(hostname -i))

sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hadoop/conf/core-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/impala/conf/core-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hadoop/conf/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/impala/conf/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hive/conf.dist/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hive/conf/hive-site.xml

if [[ ! -e /var/lib/hadoop-hdfs/cache/hdfs/dfs/name/current ]]; then
    sudo service hadoop-hdfs-namenode init
fi

sudo service hadoop-hdfs-namenode start
sudo service hadoop-hdfs-datanode start

# start hive
hive --service metastore &
hive --service hiveserver2 &

# start impala
sudo -u hdfs hdfs dfs -mkdir -p /user/impala /user/hive /user/ubuntu
sudo -u hdfs hdfs dfs -chmod 755 /user
sudo -u hdfs hdfs dfs -mkdir -p /tmp
sudo -u hdfs hdfs dfs -chmod 777 /tmp
sudo -u hdfs hdfs dfs -chown impala:impala /user/impala /user/hive
sudo -u hdfs hdfs dfs -chown ubuntu:ubuntu /user/ubuntu

sudo service impala-state-store start
sudo service impala-catalog start

sudo -u impala /usr/bin/impalad
