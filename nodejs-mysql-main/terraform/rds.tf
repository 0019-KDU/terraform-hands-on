resource "aws_db_instance" "tf_rds_instance" {
  allocated_storage      = 10
  db_name                = "chiradev"
  identifier             = "nodejs-rds-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "123456dev"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.tf_rds_sg.id]
}

resource "aws_security_group" "tf_rds_sg" {
  vpc_id      = "vpc-0fddca886228ad8e6" # default VPC
  name        = "allow_mysql"
  description = "Allow MySQL traffic"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["103.21.166.26/32"]              # local IP address
    security_groups = [aws_security_group.tf_ec2_sg.id] # Allow traffic from EC2 security group
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

locals {
  rds_endpoint = element(split(":", aws_db_instance.tf_rds_instance.endpoint), 0)
}

# outputs
output "rds_instance_endpoint" {
  value = local.rds_endpoint
}
output "rds_db_name" {
  value = aws_db_instance.tf_rds_instance.db_name
}
output "rds_username" {
  value = aws_db_instance.tf_rds_instance.username
}
output "rds_pass" {
  value     = aws_db_instance.tf_rds_instance.password
  sensitive = true
}
