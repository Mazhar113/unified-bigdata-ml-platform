data "aws_availability_zones" "available" {}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "${var.cluster_name}-vpc", Owner = var.owner_tag }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = { Name = "${var.cluster_name}-igw" }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = { Name = "${var.cluster_name}-public-${count.index}", Owner = var.owner_tag }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false
  tags = { Name = "${var.cluster_name}-private-${count.index}", Owner = var.owner_tag }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route { cidr_block = "0.0.0.0/0", gateway_id = aws_internet_gateway.igw.id }
  tags = { Name = "${var.cluster_name}-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.28"
  subnet_ids      = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  vpc_id          = aws_vpc.this.id
  manage_aws_auth = true
  node_groups = {
    on_demand = {
      desired_capacity = 2
      min_capacity = 1
      max_capacity = 3
      instance_type = "t3.medium"
    }
  }
  tags = { Owner = var.owner_tag }
}

resource "random_id" "bucket_hex" { byte_length = 4 }

resource "aws_s3_bucket" "datalake" {
  bucket = "${var.cluster_name}-datalake-${random_id.bucket_hex.hex}"
  acl    = "private"
  versioning { enabled = true }
  server_side_encryption_configuration {
    rule { apply_server_side_encryption_by_default { sse_algorithm = "AES256" } }
  }
  tags = { Name = "${var.cluster_name}-datalake" }
}

resource "aws_ecr_repository" "repos" {
  name = "${var.cluster_name}-repos"
  image_tag_mutability = "MUTABLE"
  tags = { Owner = var.owner_tag }
}

resource "aws_db_subnet_group" "mlflow" {
  name = "${var.cluster_name}-dbsubnet"
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "mlflow" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = "db.t3.micro"
  name                 = "mlflowdb"
  username             = "mlflow"
  password             = random_password.db.result
  db_subnet_group_name = aws_db_subnet_group.mlflow.name
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [module.eks.cluster_security_group_id]
  tags = { Name = "${var.cluster_name}-mlflowdb" }
}

resource "random_password" "db" { length = 16, special = true }

output "kubeconfig" { value = module.eks.kubeconfig, sensitive = true }
output "s3_bucket" { value = aws_s3_bucket.datalake.bucket }
output "ecr_repo" { value = aws_ecr_repository.repos.repository_url }
output "mlflow_db_endpoint" { value = aws_db_instance.mlflow.address }
