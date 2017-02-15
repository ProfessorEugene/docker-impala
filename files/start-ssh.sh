#!/bin/bash -xe

sudo -u dev mkdir -p /home/dev/.ssh
sudo -u dev ssh-keygen -t rsa -q -N "" -f /home/dev/.ssh/id_rsa
sudo -u dev cp /home/dev/.ssh/{id_rsa.pub,authorized_keys}
sudo -u dev chmod 600 /home/dev/.ssh/authorized_keys
