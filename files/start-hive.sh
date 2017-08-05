#!/bin/bash -xe

hive --service metastore &
hive --service hiveserver2 &
