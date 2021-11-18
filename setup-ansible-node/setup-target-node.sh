#!/usr/bin/env bash

source vars.txt

username=${tnode_username:-"ansible"}
password=${tnode_password:-"ansible"}

.scripts/create-pwless-sudoer-user.sh $username $password
.scripts/install-python.sh
