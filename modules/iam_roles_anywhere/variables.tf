variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "name" {
  type        = string
  description = "Name of the trust anchor to create"
  default     = "Amdocs-Internal-CA"
}

variable "organizational_unit" {
  type        = string
  description = "Organizational Unit (OU)"
}

variable "common_name" {
  type        = string
  description = "Common Name (CN)"
}

variable "region" {
  type        = string
  description = "Region"
}
