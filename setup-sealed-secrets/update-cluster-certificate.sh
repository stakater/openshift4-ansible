#!/bin/bash
set +x
set -e

BIN_PATH=/srv/stakater/code/openshift4-ansible/bin
export PATH=$PATH:$BIN_PATH


SEALED_SECRETS_NS="${SEALED_SECRETS_NS:-sealed-secrets}"
SEALED_SECRETS_CONTROLLER="${SEALED_SECRETS_CONTROLLER:-sealed-secrets}"
SECRETS_DIR="${SECRETS_DIR:-/srv/secrets/certs/}"

API_CERT_CHAIN_FILE=${SECRETS_DIR}/api.test-1.cp.udi.no/fullchain.cer
API_CERT_KEY_FILE=${SECRETS_DIR}/api.test-1.cp.udi.no/api.test-1.cp.udi.no.key

INGRESS_CERT_BUNDLE_FILE=${SECRETS_DIR}/openshift/wildcard.apps.test-1.cp.udi.no/certificates/certificates.pem
INGRESS_CERT_FILE=${SECRETS_DIR}/openshift/wildcard.apps.test-1.cp.udi.no/certificates/certificates.pem
INGRESS_CERT_KEY_FILE=${SECRETS_DIR}/openshift/wildcard.apps.test-1.cp.udi.no/wildcard.apps.test-1.cp.udi.no.key.dec

# API Certificates
## Generate Certificate secret
oc create secret tls cluster-api-certificate-default --cert=${API_CERT_CHAIN_FILE} --key=${API_CERT_KEY_FILE} -n openshift-config --dry-run=client -o yaml > ${SECRETS_DIR}/api-custom-cert.yaml

## Seal Certificate
echo "Commit this API TLS Sealed Secret in GitOps repository to patch API certificate:"
kubeseal --controller-name=${SEALED_SECRETS_CONTROLLER} --controller-namespace=${SEALED_SECRETS_NS}  < ${SECRETS_DIR}/api-custom-cert.yaml -o yaml
echo

# INGRESS Certificates
# Generate CUSTOM CA configmap
echo "Commit this CUSTOM CA configmap in GitOps repository to patch CUSTOM CAs:"
oc create configmap custom-ca --from-file=ca-bundle.crt=${INGRESS_CERT_BUNDLE_FILE} -n openshift-config --dry-run=client -o yaml > ${SECRETS_DIR}/ingress-custom-ca.yaml
cat ${SECRETS_DIR}/ingress-custom-ca.yaml 
echo

## Generate Ingress TLS certificate secret
oc create secret tls cluster-ingress-certificate-default --cert=${INGRESS_CERT_FILE} --key=${INGRESS_CERT_KEY_FILE} -n openshift-ingress --dry-run=client -o yaml > ${SECRETS_DIR}/ingress-tls-cert.yaml

## Seal Certificate
echo "Commit this API TLS Sealed Secret in GitOps repository to patch API certificate:"
kubeseal --controller-name=${SEALED_SECRETS_CONTROLLER} --controller-namespace=${SEALED_SECRETS_NS}  < ${SECRETS_DIR}/ingress-tls-cert.yaml -o yaml
echo
