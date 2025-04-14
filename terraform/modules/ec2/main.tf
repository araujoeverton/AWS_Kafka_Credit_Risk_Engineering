resource "aws_instance" "main" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [var.ec2_security_group_id]
  key_name      = var.ec2_key_name # Opcional: para acesso SSH

  tags = {
    Name = "${var.environment}-ec2-instance"
  }
}