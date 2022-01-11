#!/bin/bash
set +x

help()
{
   echo "No arguments supplied!"
   echo "Usage: $0 <path to write secret keys>"
   exit 1 # Exit script after printing help
}

if [ $# -eq 0 ]
  then
    help
fi

dir_path=$1


if [[ ! -d "$dir_path" ]]
then
   mkdir -p "$dir_path"
fi


# Begin script in case all parameters are correct
export PRIVATEKEY="mytls.key"
export PUBLICKEY="mytls.crt"
export NAMESPACE="sealed-secrets"
export SECRETNAME="sealed-secrets-key"

openssl req -x509 -nodes -newkey rsa:4096 -keyout "$dir_path/$PRIVATEKEY" -out "$dir_path/$PUBLICKEY" -subj "/CN=sealed-secret/O=sealed-secret"

oc -n "$NAMESPACE" create secret tls "$SECRETNAME" --cert="$dir_path/$PUBLICKEY" --key="$dir_path/$PRIVATEKEY"
oc -n "$NAMESPACE" label secret "$SECRETNAME" sealedsecrets.bitnami.com/sealed-secrets-key=active


oc -n "$NAMESPACE" delete po -l app.kubernetes.io/name=sealed-secrets
