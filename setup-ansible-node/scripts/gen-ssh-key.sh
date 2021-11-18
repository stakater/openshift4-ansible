#!/usr/bin/env bash

username=${1:-$USER}

sudo su - $username -c 'FILE=$HOME/.ssh/id_rsa.pub; if [ ! -f "$FILE" ]; then ssh-keygen -b 2048 -t rsa -f $HOME/.ssh/id_rsa -q -N ""; fi'

