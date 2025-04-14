output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = [module.vpc.public_subnet_a_id, module.vpc.public_subnet_b_id]
}

output "private_subnet_ids" {
  value = [module.vpc.private_subnet_a_id, module.vpc.private_subnet_b_id]
}

output "ec2_instance_public_ip" {
  value = module.ec2.public_ip
}

output "kafka_brokers" {
  value = module.kafka_msk.bootstrap_brokers_tls
}

output "rds_endpoint" {
  value = module.rds_postgresql.address
}