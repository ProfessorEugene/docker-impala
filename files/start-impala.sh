#!/bin/bash

if ! sudo -u hdfs hadoop fs -ls /user/impala 2> /dev/null; then
	echo "Creating directories in HDFS for Impala"
	sudo -u hdfs hdfs dfs -mkdir /user
	sudo -u hdfs hdfs dfs -chmod 755 /user
	sudo -u hdfs hdfs dfs -mkdir /user/impala
	sudo -u hdfs hdfs dfs -mkdir /user/hive
	sudo -u hdfs hdfs dfs -mkdir /user/dev
	sudo -u hdfs hdfs dfs -mkdir /tmp
	sudo -u hdfs hdfs dfs -chmod 777 /tmp
	sudo -u hdfs hdfs dfs -chown impala:impala /user/impala
	sudo -u hdfs hdfs dfs -chown impala:impala /user/hive
	sudo -u hdfs hdfs dfs -chown dev:dev /user/dev
fi

sudo /etc/init.d/impala-catalog start
sudo /etc/init.d/impala-state-store start
sudo /etc/init.d/impala-server start
