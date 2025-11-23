#!/bin/bash
# Create ECR repo if not exists
AWS_REGION=${AWS_REGION:-us-east-1}
REPO_NAME=${1:-unified-platform-repos}
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
aws ecr describe-repositories --region $AWS_REGION --repository-names $REPO_NAME >/dev/null 2>&1 ||   aws ecr create-repository --repository-name $REPO_NAME --region $AWS_REGION
echo "ECR repo: ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
