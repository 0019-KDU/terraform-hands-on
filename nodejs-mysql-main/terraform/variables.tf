variable "ami_id" {
  type        = string
  description = "this is the AMI id"
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "app_name" {
  default = "Nodejs-server"
}

variable "vpc_id" {
  default = "vpc-00"
}
