terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

# resource "local_file" "examples" {
#   content  = "foo!"
#   filename = "${local.base_path}/${var.filename-1}.txt"
#   count    = var.count_num
# }

# resource "local_file" "examples1" {
#   content  = "foo!"
#   filename = "${path.module}/${var.filename-2}.txt"
# }

# resource "local_file" "examples2" {
#   content  = "foo!"
#   filename = "${path.module}/${var.filename-3}.txt"
# }
locals {
   environment="prod"
   upper_case=upper(local.environment)
   base_path="${path.module}/configs/${local.upper_case}"
}



resource "local_file" "service_config" {
  filename = "${local.base_path}/service_config.json"
  content  = <<EOT
{
  "environment": "${local.environment}",
  "port": 3306
}
EOT
}
