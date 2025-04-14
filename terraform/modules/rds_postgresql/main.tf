resource "aws_db_subnet_group" "main" {
  name_prefix = "${var.environment}-rds-subnet-group-"
  subnet_ids  = var.private_subnet_ids

  tags = {
    Name = "${var.environment}-rds-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage    = var.rds_allocated_storage
  db_name              = var.rds_db_name
  engine               = "postgres"
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  username             = var.rds_username
  password             = var.rds_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  multi_az             = var.rds_multi_az
  skip_final_snapshot  = true # Para demonstração, evite snapshots finais

  tags = {
    Name = "${var.environment}-rds-instance"
  }
}