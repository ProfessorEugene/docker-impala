#!/bin/bash

rm -rf /.ssh
echo "Generating an SSH key for the dev user"
mkdir -p /.ssh
ssh-keygen -t rsa -q -N "" -f /.ssh/id_rsa
cp /.ssh/{id_rsa.pub,authorized_keys}
chmod 600 /.ssh/authorized_keys
