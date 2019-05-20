#!/bin/bash

set -Eeuox pipefail

NAMESPACE=default

helm delete --tls --purge default-daytrader7 || true
sleep 15
helm install --tls \
  --version="1.9.0" \
  --name="default-daytrader7" \
  --namespace="default" \
  --set replicaCount="1" \
  --set image.repository="greyjoy.icp:8500/default/daytrader7" \
  --set image.tag="latest" \
  --set image.pullPolicy="Always" \
  --set-string arch.amd64="3" \
  --set-string arch.ppc64le="0" \
  --set-string arch.s390x="0" \
  --set service.name="daytrader7" \
  --set ssl.enabled="true" \
  --set ingress.enabled="true" \
  --set ingress.path="/" \
  --set ingress.rewriteTarget="/" \
  --set ingress.host="default-daytrader7.greyjoyp.rtp.raleigh.ibm.com" \
  --set resources.constraints.enabled=true \
  --set resources.requests.memory=2048Mi \
  --set resources.limits.memory=2048Mi \
  --set resources.requests.cpu=4000m \
  --set resources.limits.cpu=4000m \
  ibm-charts/ibm-websphere-liberty
  
export NAMESPACE=default
export HELM_RELEASE=default-daytrader7
export ROLE=$(kubectl -n ${NAMESPACE} get role -l release=${HELM_RELEASE} -o=jsonpath='{.items[0].metadata.name}')
kubectl -n ${NAMESPACE} patch role ${ROLE} --type json --patch '[{"op":"add","path":"/rules/0/resources/-","value":"pods"}]'
kubectl -n ${NAMESPACE} get role ${ROLE} -o=yaml