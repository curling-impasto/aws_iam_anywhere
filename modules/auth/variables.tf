variable "name" {
  type        = string
  description = "Name of the environment"
}

variable "country" {
  type        = string
  description = "Country (C)"
  default = "CY"
}

variable "province" {
  type        = string
  description = "Province (ST)"
}

variable "locality" {
  type        = string
  description = "Locality (L)"
}

variable "organization" {
  type        = string
  description = "Organization (O)"
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