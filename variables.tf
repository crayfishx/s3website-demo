variable "region" {
  type = string
  default = "eu-west-1"
}

variable "sitename" {
  type = string
  default = "spaceliftdemo"
  validation {
    condition = can(regex("^[a-zA-Z0-9_]*$", var.sitename))
    error_message = "Sitename can only contain alphanumeric and underscores"
  }
}

variable "environment" {
  type = string
  default = "dev"
  validation {
    condition = contains(["dev", "test", "qa", "prod"], var.environment)
    error_message = "Invalid environment ${var.environment}"
  }
}
