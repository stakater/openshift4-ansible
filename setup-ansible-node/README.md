This directory containes a bunch of bash scripts to prepare node for setting up ansible control and target node.

Three main files are as follows:
1 - setup-target-node.sh
2 - setup-control-node.sh
3 - vars.txt

vars.txt contains the variables, their description is as follows:
	- cnode_username: username of the control node that will be used as ansible_user (default: ansible)
	- cnode_password: password of the ansible_user on control node (default: ansible)
	- tnode_username: username of the target node ansible_user (default: ansible)
	- tnode_password: password of the ansible_user on target node (default: ansible)
	- tnode_hostname: hostname or ip of the target node to copy ssh key to (default: ansible) 

setup-target-node.sh reads variables from vars.txt and prepares the node for being managed by ansible it involves the following steps:

	- Create user (username: tnode_username, password: tnode_password)
	- Adds the user in wheel group.
	- Gives the user passwordless sudo access.
	- Install dependencies (Python3)
	- Creates an alias of /usr/bin/python3 as python.

setup-control-node.sh reads variables from vars.txt and prepares the node for managing ansible target nodes. It does the following steps:

	- Create user (username: cnode_username, password: cnode_password)
        - Adds the user in wheel group.
        - Gives the user passwordless sudo access.
	- Generate ssh keys (as user cnode_username)
	- Copy ssh public key to the target node <tnode_username>@<tnode_hostname>
	- Install Packages (Python3, Ansible)


For creating a single node (control + target), vars.txt needs to be populated with the proper values. An example is given below:

vars.txt
--------

cnode_username=ansible
cnode_password=password
tnode_username=ansible
tnode_password=password
tnode_hostname=localhost

run 'setup-control-node.sh' to setup the node.

To confirm proper setup:
	- switch to <cnode_username> 'su - ansible'
	- run ansible ad-hoc command 'ansible localhost -m ping -u ansible'

Response should be as follows.

localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
