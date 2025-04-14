variable "aws_region" {
  type    = string
  default = "us-east-1" # Defina sua região da AWS
}

variable "environment" {
  type    = string
  default = "dev" # Ambiente (dev, prod, etc.)
}

# VPC Variables
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "main-vpc"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "private_subnet_a_cidr" {
  type    = string
  default = "10.0.11.0/24"
}

variable "private_subnet_b_cidr" {
  type    = string
  default = "10.0.12.0/24"
}

# Security Group Variables
variable "ssh_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"] # Restrinja para seu IP em produção
}

variable "http_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "https_cidr_blocks" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# EC2 Variables
variable "ec2_ami" {
  type    = string
  default = "ami-xxxxxxxxxxxxxxxxx" # Substitua pela AMI desejada
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_key_name" {
  type    = string
  default = "" # Opcional: nome da sua chave SSH
}

# Kafka MSK Variables
variable "kafka_version" {
  type    = string
  default = "3.5.1"
}

variable "kafka_broker_nodes" {
  type    = number
  default = 2
}

variable "kafka_instance_type" {
  type    = string
  default = "kafka.t3.small"
}

variable "kafka_configuration_arn" {
  type    = string
  default = "" # Opcional: ARN da configuração do Kafka
}

# RDS PostgreSQL Variables
variable "rds_allocated_storage" {
  type    = number
  default = 20
}

variable "rds_db_name" {
  type    = string
  default = "mydb"
}

variable "rds_engine_version" {
  type    = string
  default = "15.6"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_username" {
  type    = string
  default = "admin"
  sensitive = true
}

variable "rds_password" {
  type    = string
  default = "yoursecurepassword"
  sensitive = true
}

variable "rds_multi_az" {
  type    = bool
  default = false
}