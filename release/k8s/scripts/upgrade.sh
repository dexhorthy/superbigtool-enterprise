#!/bin/bash

NS='{{ ConfigOption "namespace" }}'

docker load docker/api.tar
docker tag quay.io/superbigtool/api:2.1.0 {{ ConfigOption "private_registry_api" }}:2.1.0
docker push {{ ConfigOption "private_registry_api" }}:2.1.0

kubectl replace secret generic postgres \
  --from-literal=POSTGRES_USER={{ ConfigOption "postgres_user" }} \
  --from-literal=POSTGRES_PASSWORD={{ ConfigOption "postgres_password" }} \
  --from-literal=POSTGRES_HOST={{ ConfigOption "postgres_host" }} \
  --from-literal=POSTGRES_PORT={{ ConfigOption "postgres_port" }}

kubectl replace secret generic jwt \
  --from-literal=HMAC_SECRET={{ ConfigOption "hmac_secret" }}

kubectl apply --namespace "$NS" -f ./k8s/


echo "

SuperBigTool has been upgraded to version {{ Releases "version"}}.

You can run

   kubectl --namespace \"$NS\" get service api


To get the API address.
"
