#!/bin/bash -xe

sudo -u ubuntu rm -rf /home/ubuntu/.ssh
sudo -u ubuntu mkdir -p /home/ubuntu/.ssh
sudo -u ubuntu ssh-keygen -t rsa -q -N "" -f /home/ubuntu/.ssh/id_rsa
sudo -u ubuntu cp /home/ubuntu/.ssh/{id_rsa.pub,authorized_keys}
sudo -u ubuntu chmod 600 /home/ubuntu/.ssh/authorized_keys
