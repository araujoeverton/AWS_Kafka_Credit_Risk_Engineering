resource "aws_msk_cluster" "main" {
  cluster_name           = var.kafka_cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.kafka_broker_nodes

  broker_node_group_info {
    client_subnets = var.private_subnet_ids
    instance_type  = var.kafka_instance_type
    security_groups = [var.kafka_security_group_id]
  }

  client_authentication {
    unauthenticated = {
      enabled = true # Para simplificar, sem autenticação
    }
  }

  configuration_info { # Opcional: para configurações personalizadas
    version = var.kafka_configuration_arn
  }

  tags = {
    Name = "${var.environment}-kafka-cluster"
  }
}