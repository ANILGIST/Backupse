terraform {
  required_version = ">= 1.2.0"
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.35.0"
    }
  }
}
