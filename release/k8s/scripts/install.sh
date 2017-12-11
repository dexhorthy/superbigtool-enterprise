#!/bin/bash

NS='{{ ConfigOption "namespace" }}'

kubectl create secret generic postgres \
  --from-literal=POSTGRES_USER={{ ConfigOption "postgres_user" }} \
  --from-literal=POSTGRES_PASSWORD={{ ConfigOption "postgres_password" }} \
  --from-literal=POSTGRES_HOST={{ ConfigOption "postgres_host" }} \
  --from-literal=POSTGRES_PORT={{ ConfigOption "postgres_port" }}


kubectl create secret generic jwt \
  --from-literal=HMAC_SECRET={{ ConfigOption "hmac_secret" }}

kubectl create namespace "$NS"
kubectl apply --namespace "$NS" -f ./k8s/

echo "

SuperBigTool has been deployed to the cluster.

You can run

   kubectl --namespace \"$NS\" get service api


To get the API address.

"
