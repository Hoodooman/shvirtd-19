variable "env_name" {
  type        = string
  description = "Environment name used as prefix for resources"  
}

variable "zone" {
  type        = string
  description = "Availability zone where the subnet will be created"  
}

variable "cidr" {
  type        = string
  default     = "10.10.0.0/24"
  description = "CIDR block for the subnet"  
}
