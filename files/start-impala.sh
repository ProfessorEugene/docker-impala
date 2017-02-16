#!/bin/bash -xe

echo "Creating directories in HDFS for Impala"
sudo -u hdfs hdfs dfs -mkdir -p /user/impala /user/hive /user/ubuntu
sudo -u hdfs hdfs dfs -chmod 755 /user
sudo -u hdfs hdfs dfs -mkdir -p /tmp
sudo -u hdfs hdfs dfs -chmod 777 /tmp
sudo -u hdfs hdfs dfs -chown impala:impala /user/impala /user/hive
sudo -u hdfs hdfs dfs -chown ubuntu:ubuntu /user/ubuntu

sudo /etc/init.d/impala-catalog start
sudo /etc/init.d/impala-state-store start
sudo /etc/init.d/impala-server start
