terraform {
  required_version = ">= 1.5.0"
}

variable "project_name" {
  description = "Name used to identify this cloud portfolio project."
  type        = string
  default     = "aws-cloud-portfolio"
}

locals {
  project_name = var.project_name
  environment  = "development"
}

output "project_name" {
  description = "The name of this project."
  value       = local.project_name
}

output "environment" {
  description = "The environment associated with this configuration."
  value       = local.environment
}
