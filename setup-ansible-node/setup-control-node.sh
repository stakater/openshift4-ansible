#!/usr/bin/env bash

source vars.txt

cnode_username=${cnode_username:-"ansible"}
cnode_password=${cnode_password:-"ansible"}
tnode_username=${tnode_username:-"ansible"}
tnode_password=${tnode_password:-"ansible"}
tnode_hostname=${tnode_hostname:-"localhost"}

source ./scripts/install-dependencies.sh
source ./scripts/create-pwless-sudoer-user.sh $cnode_username $cnode_password
source ./scripts/gen-ssh-key.sh $cnode_username
cp ./scripts/copy-ssh-id.sh /home/${cnode_username}/

sudo su - $cnode_username -c "~/copy-ssh-id.sh ${tnode_username} ${tnode_password} ${tnode_hostname}"
source ./scripts/install-python.sh
source ./scripts/install-ansible.sh

echo "Installing K8s module for ansible"
ansible-galaxy collection install community.kubernetes

echo "You can run the following command to verify the setup."
echo "ansible ${tnode_hostname} -m ping -u ${tnode_username}"
echo""
