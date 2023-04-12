### ------ ALB/variables.tf ------ ###

# The security froup for external loadbalancer
variable "public-sg" {
  description = "Security group for external load balancer"
}

# The public subnet froup for external loadbalancer
variable "public-sbn-1" {
  description = "Public subnets to deploy external ALB"
}

variable "public-sbn-2" {
  description = "Public subnets to deploy external  ALB"
}

variable "vpc_id" {
  type        = string
  description = "The vpc ID"
}

variable "private-sg" {
  description = "Security group for Internal Load Balance"
}

variable "private-sbn-1" {
  description = "Private subnets to deploy Internal ALB"
}
variable "private-sbn-2" {
  description = "Private subnets to deploy Internal ALB"
}

variable "ip_address_type" {
  type        = string
  description = "IP address for the ALB"
  default = "ipv4"

}

variable "load_balancer_type" {
  type        = string
  description = "the type of Load Balancer"
  default = "application"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}


variable "environment" {
  type        = string
  description = "The environment name"
  default = "dev"
}

variable "port" {
  type        = number
  description = "The port number"
  default = 443
}

variable "protocol" {
  type        = string
  description = "The protocol type"
  default = "HTTPS"
}

variable "company_name" {
  type        = string
  description = "The company name"
}

variable "interval" {
  type        = number
  description = "The interval for health check"
  default = 10
}

variable "path" {
  type        = string
  description = "The path for health check"
  default = "/healthstatus"
}

variable "timeout" {
  type        = number
  description = "The timeout for health check"
  default = 5
}

variable "healthy_threshold" {
  type        = number
  description = "The healthy threshold for health check"
  default = 5
}

variable "unhealthy_threshold" {
  type        = number
  description = "The unhealthy threshold for health check"
  default = 2
}

variable target_type {
  type        = string
  description = "The target type"
  default = "instance"
}

variable "default_action_type" {
  type        = string
  description = "The default action type"
  default = "forward"
}

variable "priority" {
  type        = number
  description = "The priority for the rule"
  default = 99
}