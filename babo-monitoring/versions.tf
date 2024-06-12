terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 5.0.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.36"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
