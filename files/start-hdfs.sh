#!/bin/bash -xe

declare -a hostname=($(hostname -i))
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hadoop/conf/core-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/impala/conf/core-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hadoop/conf/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/impala/conf/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hive/conf.dist/hive-site.xml
sudo sed -i "s/__HOSTNAME__/${hostname[0]}/" /etc/hive/conf/hive-site.xml
if [[ ! -e /var/lib/hadoop-hdfs/cache/hdfs/dfs/name/current ]]; then
	sudo /etc/init.d/hadoop-hdfs-namenode init
fi
sudo /etc/init.d/hadoop-hdfs-namenode start
sudo /etc/init.d/hadoop-hdfs-datanode start
hive --service metastore &
