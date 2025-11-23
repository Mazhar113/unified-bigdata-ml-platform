#!/usr/bin/env bash
set -euo pipefail
AWS_REGION="${AWS_REGION:-us-east-1}"
BUCKET="$1"
DYNAMO_TABLE="$2"
KMS_KEY_ID="${3:-}"
echo "Region: ${AWS_REGION}"
echo "Bucket: ${BUCKET}"
echo "DynamoDB table: ${DYNAMO_TABLE}"
[ -n "${KMS_KEY_ID}" ] && echo "Using KMS key: ${KMS_KEY_ID}" || echo "Using SSE-S3 (AWS-managed encryption)"
aws configure set region "${AWS_REGION}"
if aws s3api head-bucket --bucket "${BUCKET}" 2>/dev/null; then
  echo "Bucket ${BUCKET} already exists"
else
  echo "Creating bucket ${BUCKET}..."
  if [ "${AWS_REGION}" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "${BUCKET}" --region "${AWS_REGION}"
  else
    aws s3api create-bucket --bucket "${BUCKET}" --create-bucket-configuration LocationConstraint="${AWS_REGION}" --region "${AWS_REGION}"
  fi
fi
aws s3api put-public-access-block --bucket "${BUCKET}" --public-access-block-configuration '{
  "BlockPublicAcls": true,
  "IgnorePublicAcls": true,
  "BlockPublicPolicy": true,
  "RestrictPublicBuckets": true
}'
aws s3api put-bucket-versioning --bucket "${BUCKET}" --versioning-configuration Status=Enabled
if [ -n "${KMS_KEY_ID}" ]; then
  echo "Enabling SSE-KMS with key ${KMS_KEY_ID}..."
  aws s3api put-bucket-encryption --bucket "${BUCKET}" --server-side-encryption-configuration "{
    "Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "aws:kms", "KMSMasterKeyID": "${KMS_KEY_ID}"}}]
  }"
else
  echo "Enabling SSE-S3 (AES256) default encryption..."
  aws s3api put-bucket-encryption --bucket "${BUCKET}" --server-side-encryption-configuration '{
    "Rules": [{ "ApplyServerSideEncryptionByDefault": { "SSEAlgorithm": "AES256" } }]
  }'
fi
aws s3api put-bucket-lifecycle-configuration --bucket "${BUCKET}" --lifecycle-configuration '{
  "Rules": [
    {
      "ID": "tf-state-archive",
      "Prefix": "",
      "Status": "Enabled",
      "Transitions": [
        {
          "Days": 90,
          "StorageClass": "GLACIER"
        }
      ],
      "NoncurrentVersionExpiration": {
        "NoncurrentDays": 365
      }
    }
  ]
}'
if aws dynamodb describe-table --table-name "${DYNAMO_TABLE}" --region "${AWS_REGION}" >/dev/null 2>&1; then
  echo "DynamoDB table ${DYNAMO_TABLE} already exists"
else
  echo "Creating DynamoDB table ${DYNAMO_TABLE}..."
  aws dynamodb create-table     --table-name "${DYNAMO_TABLE}"     --attribute-definitions AttributeName=LockID,AttributeType=S     --key-schema AttributeName=LockID,KeyType=HASH     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5     --region "${AWS_REGION}"
  echo "Waiting for table to become ACTIVE..."
  aws dynamodb wait table-exists --table-name "${DYNAMO_TABLE}" --region "${AWS_REGION}"
fi
echo "Backend bootstrap complete.
Now update infra/terraform/backend.tf bucket/key/dynamodb_table entries and run:
  terraform init
If migrating an existing local state, follow migration steps in the README."
