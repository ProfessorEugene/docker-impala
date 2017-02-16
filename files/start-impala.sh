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

export PYTHON_EGG_CACHE=/home/dev/.python-eggs
mkdir -p "${PYTHON_EGG_CACHE}"

chars="/-\|"

start=$(date +%s)

while ! sudo -E -u dev impala-shell -i impala -q 'select 1'; do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    echo -en "${chars:$i:1}" "\r"
  done
done

stop=$(date +%s)

echo "Impala took $(($stop - $start)) seconds to become queryable"
