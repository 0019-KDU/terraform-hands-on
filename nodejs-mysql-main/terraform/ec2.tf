resource "aws_instance" "tf_ec2_instance" {
  ami                         = var.ami_id # Ubuntu Image
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tf_ec2_sg.id]
  key_name                    = "terraform-demo"
  depends_on                  = [aws_s3_object.tf_s3_object]

  user_data = <<-EOF
    #!/bin/bash

    # Update package lists
    sudo apt update -y

    # Install dependencies
    sudo apt install -y nodejs npm git

    # Clone the repository
    git clone https://github.com/verma-kunal/nodejs-mysql.git /home/ubuntu/nodejs-mysql
    cd /home/ubuntu/nodejs-mysql

    # Set environment variables
    echo "DB_HOST=${replace(local.rds_endpoint, "\"", "\\\"")}" | sudo tee .env
    echo "DB_USER=${replace(aws_db_instance.tf_rds_instance.username, "\"", "\\\"")}" | sudo tee -a .env
    echo "DB_PASS=${replace(aws_db_instance.tf_rds_instance.password, "\"", "\\\"")}" | sudo tee -a .env
    echo "DB_NAME=${replace(aws_db_instance.tf_rds_instance.db_name, "\"", "\\\"")}" | sudo tee -a .env
    echo "TABLE_NAME=users" | sudo tee -a .env
    echo "PORT=3000" | sudo tee -a .env

    # Set correct permissions for .env
    sudo chmod 600 .env

    # Install Node.js dependencies
    sudo npm install

    # Start the Node.js application
    sudo npm start &
  EOF

  user_data_replace_on_change = true

  tags = {
    Name = var.app_name
  }
}


# Security group for EC2 instance
resource "aws_security_group" "tf_ec2_sg" {
  name        = "nodejs-server-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = "vpc-0fddca886228ad8e6" # default VPC

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow from all IPs
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP"
    from_port   = 3000 # for nodejs app
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security group for EC2 instance (using terraform module)
# module "tf_ec2_module" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.2.0"
#   vpc_id  = "" # default VPC
#   name    = "ec2-security-group"

#   ingress_cidr_blocks = [
#     {
#       from_port   = 3000
#       to_port     = 3000
#       protocol    = "tcp"
#       description = "for nodejs app"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "https-443-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },
#     {
#       rule        = "ssh-tcp"
#       cidr_blocks = "0.0.0.0/0"
#     },

#   ]
#   egress_rules = ["all-all"]
# }

# output
output "ec2_public_ip" {
  value = aws_instance.tf_ec2_instance.public_ip
}
