variable "cluster_name" {
  description = "Name MySQL cluster"
  type        = string
}

variable "network_id" {
  description = "Cluster Network ID"
  type        = string
}

variable "ha" {
  description = "Creates 2 hosts if true"
  type        = bool
  default     = false
}