variable "environment" {
  type        = string
  default     = "prod"
  description = "Deployment environment"
}

variable "location" {
  type        = string
  default     = "centralindia"
  description = "Target Azure Region"
}

variable "workload_name" {
  type        = string
  default     = "enterprise-app"
  description = "Name of workload"
}
