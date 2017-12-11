#!/bin/bash

NS='{{ ConfigOption "namespace" }}'

docker load docker/api.tar
docker tag quay.io/superbigtool/api:2.1.0 {{ ConfigOption "private_registry_api" }}:2.1.0
docker push {{ ConfigOption "private_registry_api" }}:2.1.0

kubectl create secret generic postgres \
  --from-literal=POSTGRES_USER={{ ConfigOption "postgres_user" }} \
  --from-literal=POSTGRES_PASSWORD={{ ConfigOption "postgres_password" }} \
  --from-literal=POSTGRES_HOST={{ ConfigOption "postgres_host" }} \
  --from-literal=POSTGRES_PORT={{ ConfigOption "postgres_port" }}

kubectl create secret generic jwt \
  --from-literal=HMAC_SECRET={{ ConfigOption "hmac_secret" }}

kubectl create namespace "$NS"
kubectl apply --namespace "$NS" -f ./k8s/

kubectl patch --namespace "$NS" deployment api -p '{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {"name": "api", "image": "{{ ConfigOption "private_registry_api" }}:2.1.0"}
        ]
      }
    }
  }
}'

echo "

SuperBigTool has been deployed to the cluster.

You can run

   kubectl --namespace \"$NS\" get service api


To get the API address.

"
