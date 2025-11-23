Create these GitHub Secrets in the repository settings before running CI/CD:
- AWS_ROLE_TO_ASSUME: IAM role ARN that GitHub Actions can assume
- ECR_REGISTRY: <account-id>.dkr.ecr.<region>.amazonaws.com/<repo>
- EKS_CLUSTER_NAME: cluster name as created by Terraform
- AWS_REGION: region (e.g., us-east-1)
