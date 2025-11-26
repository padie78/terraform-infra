# Configurar el provider de AWS

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    
  }

  required_version = ">= 1.9.0"
}

provider "aws" {
  region = "eu-central-1"  # Cambiá la región si querés
}
