#!/bin/bash

# For Unix-like operating systems (Linux Distros, Mac OS ...)
# /> chmod +x apply-all.sh
ls -l
# Apply all files (including subdirectories)
kubectl apply -f metrics/metrics.yaml
kubectl apply -f techlanches-namespace.yaml
kubectl apply -f /techlanches-secrets.yaml
kubectl apply -f /hpas/techlanches-api-hpa.yaml
kubectl apply -f /hpas/techlanches-worker-hpa.yaml
kubectl apply -f ./k8s/deployments/techlanches-sql-deployment.yaml
kubectl apply -f ./k8s/deployments/techlanches-api-deployment.yaml
kubectl apply -f ./k8s/deployments/techlanches-worker-deployment.yaml
kubectl apply -f ./k8s/deployments/techlanches-rabbitmq-deployment.yaml
# kubectl apply -f ./deployments/techlanches-ngrok-deployment.yaml
