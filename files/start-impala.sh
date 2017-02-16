#!/bin/bash -xe

echo "Creating directories in HDFS for Impala"
sudo -u hdfs hdfs dfs -mkdir -p /user/impala /user/hive /user/dev
sudo -u hdfs hdfs dfs -chmod 755 /user
sudo -u hdfs hdfs dfs -mkdir -p /tmp
sudo -u hdfs hdfs dfs -chmod 777 /tmp
sudo -u hdfs hdfs dfs -chown impala:impala /user/impala /user/hive
sudo -u hdfs hdfs dfs -chown dev:dev /user/dev

sudo /etc/init.d/impala-catalog start
sudo /etc/init.d/impala-state-store start
sudo /etc/init.d/impala-server start

sleep 15
export PYTHON_EGG_CACHE=/home/dev/.python-eggs
mkdir -p "${PYTHON_EGG_CACHE}"
sudo -E -u dev impala-shell -i localhost -q 'select 1'
