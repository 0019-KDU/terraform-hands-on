terraform {
    backend "local" {
        path = "C:/Users/chira/Documents/Custom Office Templates/terraform.tfstate"
      
    }
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.5.2"
    }
  }
}

