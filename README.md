# Unified Platform — Full Production Scaffold (AWS EKS)

This scaffold contains Terraform, Kubernetes Helm charts/values, CI/CD GitHub Actions, Dockerized services,
Airflow DAGs, Spark job templates, monitoring dashboards, IAM policies and helper scripts.
It is designed as a comprehensive starting point — **review and adapt before using in production**.

Structure:
- infra/terraform: full terraform to create VPC, EKS, S3, RDS, ECR, IAM roles/policies, and outputs
- k8s/: Helm charts and values for platform components (Redis, MinIO, Strimzi, MLflow, Feast, Prometheus/Grafana, Airflow)
- services/: example microservices with Dockerfiles (producer, consumer, model-server)
- cicd/: GitHub Actions workflows and helper scripts
- pipelines/: Airflow DAGs and Spark job templates for the five projects
- scripts/: helper scripts for bootstrap, helm install, create ECR repos, and kubeconfig
- policies/: IAM policy JSON templates
- monitoring/: Grafana dashboards and Prometheus alerts templates

IMPORTANT:
1. Replace placeholder values (ACCOUNT IDs, REGION, CLUSTER NAME, etc.) before running.
2. Store secrets (DB password, AWS_ROLE, etc.) in GitHub Secrets or AWS Secrets Manager and map them via IRSA.
3. Test in a dev AWS account first.

If you want, I can now run a validator to ensure all files are present and produce a checklist. 
