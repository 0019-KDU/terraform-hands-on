resource "aws_instance" "tf_ec2_instance" {
  ami           = "ami-04b4f1a9cf54c11d0" #ubuntu image
  instance_type = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.tf_ec2_sg.id]
  key_name = "terraform-demo"
  depends_on = [aws_s3_object.tf_s3_object]

  tags = {
    Name = "NodeJS-Server"
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