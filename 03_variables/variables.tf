variable "filename-1" {
  description = "value this is example "
   default = "example" 
   type = string
}

variable "filename-2" {
  description = "value this is example2"
  default = "example2" 
  type = string
}

variable "filename-3" {
  description = "value this is example3"
  default = "example3" 
  type = string
}

variable "count_num" {
  type = number
  default = 1
}

# locals {
#   base_path="${path.module}/files"
# }

# locals {
#    environment="dev"
#    upper_case=upper(local.environment)
#    base_path="${path.module}/config/${local.upper_case}"
# }

output "filename-1" {
  value = var.filename-1
  sensitive = true
  
}