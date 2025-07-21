variable "existing_network_id" {
  description = "ID of existing network to reuse (optional)"
  type        = string
  default     = null
}

variable "env_name" {
  type        = string
  description = "Environment name used as prefix for resources"  
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    zone = string
    cidr = string
  }))
  default = []
}