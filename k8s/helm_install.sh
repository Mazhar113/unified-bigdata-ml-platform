#!/bin/bash
set -e
# usage: ./helm_install.sh <s3_bucket> <mlflow_db_endpoint> <db_password>
S3_BUCKET=$1
MLFLOW_DB=$2
DB_PASS=$3
echo "Installing helm charts..."
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add minio https://charts.min.io/
helm repo add strimzi https://strimzi.io/charts/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Redis
helm install redis bitnami/redis -f k8s/manifests/redis-values.yaml --namespace unified --create-namespace

# MinIO
helm install minio minio/minio -f k8s/manifests/minio-values.yaml --namespace unified

# Strimzi operator
helm install strimzi-kafka strimzi/strimzi-kafka-operator --namespace kafka --create-namespace

# Apply Strimzi Kafka cluster CR
kubectl apply -f k8s/manifests/strimzi-cluster.yaml -n kafka

# MLflow (we assume a chart exists or use a deployment manifest)
kubectl apply -f k8s/manifests/mlflow-deployment.yaml -n unified

# Feast helm (simplified)
helm install feast-ingest k8s/charts/feast --namespace feast --create-namespace -f k8s/manifests/feast-values.yaml
