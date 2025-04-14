module "vpc" {
  source = "./modules/vpc"

  aws_region             = var.aws_region
  vpc_cidr               = var.vpc_cidr
  vpc_name               = "${var.environment}-vpc"
  public_subnet_a_cidr   = var.public_subnet_a_cidr
  public_subnet_b_cidr   = var.public_subnet_b_cidr
  private_subnet_a_cidr  = var.private_subnet_a_cidr
  private_subnet_b_cidr  = var.private_subnet_b_cidr
}

module "security_group" {
  source = "./modules/security_group"

  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  ssh_cidr_blocks   = var.ssh_cidr_blocks
  http_cidr_blocks  = var.http_cidr_blocks
  https_cidr_blocks = var.https_cidr_blocks
}

module "ec2" {
  source = "./modules/ec2"

  environment             = var.environment
  ec2_ami                 = var.ec2_ami
  ec2_instance_type       = var.ec2_instance_type
  public_subnet_id        = module.vpc.public_subnet_a_id # Exemplo: usando a subnet A
  ec2_security_group_id   = module.security_group.ec2_security_group_id
  ec2_key_name            = var.ec2_key_name # Opcional
}

module "kafka_msk" {
  source = "./modules/kafka_msk"

  environment             = var.environment
  kafka_cluster_name      = "${var.environment}-kafka"
  kafka_version           = var.kafka_version
  kafka_broker_nodes      = var.kafka_broker_nodes
  kafka_instance_type     = var.kafka_instance_type
  private_subnet_ids      = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
  kafka_security_group_id = module.security_group.kafka_security_group_id
  kafka_configuration_arn = var.kafka_configuration_arn # Opcional
}

module "rds_postgresql" {
  source = "./modules/rds_postgresql"

  environment             = var.environment
  rds_allocated_storage   = var.rds_allocated_storage
  rds_db_name             = var.rds_db_name
  rds_engine_version      = var.rds_engine_version
  rds_instance_class      = var.rds_instance_class
  rds_username            = var.rds_username
  rds_password            = var.rds_password
  private_subnet_ids      = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
  rds_security_group_id   = module.security_group.rds_security_group_id
  rds_multi_az            = var.rds_multi_az
}