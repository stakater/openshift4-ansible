#!/usr/bin/env bash

sudo yum install expect -y

if [ ! -f /etc/redhat-release ]; then
  sudo yum install epel-release -y
fi


