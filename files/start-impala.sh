#!/bin/bash -xe

sudo -u hdfs hdfs dfs -mkdir -p /user/impala /user/hive /user/ubuntu
sudo -u hdfs hdfs dfs -chmod 755 /user
sudo -u hdfs hdfs dfs -mkdir -p /tmp
sudo -u hdfs hdfs dfs -chmod 777 /tmp
sudo -u hdfs hdfs dfs -chown impala:impala /user/impala /user/hive
sudo -u hdfs hdfs dfs -chown ubuntu:ubuntu /user/ubuntu

sudo service impala-state-store start
sudo service impala-catalog start
sudo service impala-server start
