#!/usr/bin/env bash

source vars.txt

username=${tnode_username:-"ansible"}
password=${tnode_password:-"ansible"}

source ./scripts/create-pwless-sudoer-user.sh $username $password
source ./scripts/install-python.sh
