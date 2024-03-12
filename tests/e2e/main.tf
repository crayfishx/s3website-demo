terraform {
  required_providers {
    http = {
      source = "hashicorp/http"
      version = "3.4.0"
    }
  }
}

variable "endpoint_url" {
  type = string
}

data "http" "request" {
  url = var.endpoint_url
  method = "GET"
}
