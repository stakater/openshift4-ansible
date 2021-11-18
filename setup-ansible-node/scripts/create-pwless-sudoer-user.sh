#!/usr/bin/env bash

user=${1:-ansible}
passwd=${2:-ansible}

adduser $user
echo $passwd | passwd $user --stdin
usermod -a -G wheel $user
echo $user 'ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible
grep -qxF '#includedir /etc/sudoers.d' /etc/sudoers || echo '#includedir /etc/sudoers.d' >> /etc/sudoers

