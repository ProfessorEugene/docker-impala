#!/bin/bash



if ! sudo -u hdfs hadoop fs -ls /user/impala 2> /dev/null; then
	echo "Creating directories in HDFS for Impala"
	sudo -u hdfs hadoop fs -mkdir /user
	sudo -u hdfs hadoop fs -chmod 755 /user
	sudo -u hdfs hadoop fs -mkdir /user/impala
	sudo -u hdfs hadoop fs -mkdir /user/hive
	sudo -u hdfs hadoop fs -mkdir /user/dev
	sudo -u hdfs hadoop fs -mkdir /tmp
	sudo -u hdfs hadoop fs -chmod 777 /tmp
	sudo -u hdfs hadoop fs -chown dev:dev /user/impala
	sudo -u hdfs hadoop fs -chown dev:dev /user/hive
	sudo -u hdfs hadoop fs -chown dev:dev /user/dev
fi

sudo /etc/init.d/impala-catalog start
sudo /etc/init.d/impala-state-store start
sudo /etc/init.d/impala-server start
