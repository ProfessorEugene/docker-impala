#!/bin/bash -xe
/start-ssh.sh
/start-hdfs.sh
/start-impala.sh
echo "Impala is Started, Enjoy!"
