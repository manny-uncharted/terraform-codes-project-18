### ------ Root/variables.tf ------ ###

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_classiclink" {
  default = "false"
}

variable "enable_classiclink_dns_support" {
  default = "false"
}

variable "preferred_number_of_public_subnets" {
  type        = number
  description = "Number of public subnets to create. If not specified, all available AZs will be used."
}

variable "preferred_number_of_private_subnets" {
  # default = 4
  type        = number
  description = "Number of private subnets to create. If not specified, all available AZs will be used."
}

variable "name" {
  description = "Name to be used on all the resources as identifier."
  type        = string
  default     = "ACS"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "environment" {
  description = "Environment where resources are being created."
  type        = string
  default     = "dev"
}

variable "destination_cidr_block" {
  description = "The CIDR block to allow access to the VPC."
  type        = string
  default     = "0.0.0.0/0"
}

### ----- Autoscaling module ----- ###

variable "ami" {
  type        = string
  description = "AMI-ID to use for our launch templates"
}

variable "keypair" {
  type        = string
  description = "Keypair to use for our launch templates"
}




variable "account_no" {
  type        = string
  description = "AWS Account Number"
}

variable "master-username" {
  type        = string
  description = "Master username for RDS"
}

variable "master-password" {
  type        = string
  description = "Master password for RDS"
}

#### --- for ALB module --- ####
variable "port" {
  type        = number
  description = "The port number"
  default     = 443
}

variable "protocol" {
  type        = string
  description = "The protocol type"
  default     = "HTTPS"
}

variable "company_name" {
  type        = string
  description = "The company name"
}

variable "interval" {
  type        = number
  description = "The interval for health check"
  default     = 10
}

variable "path" {
  type        = string
  description = "The path for health check"
  default     = "/healthstatus"
}

variable "timeout" {
  type        = number
  description = "The timeout for health check"
  default     = 5
}

variable "healthy_threshold" {
  type        = number
  description = "The healthy threshold for health check"
  default     = 5
}

variable "unhealthy_threshold" {
  type        = number
  description = "The unhealthy threshold for health check"
  default     = 2
}

variable "target_type" {
  type        = string
  description = "The target type"
  default     = "instance"
}

variable "default_action_type" {
  type        = string
  description = "The default action type"
  default     = "forward"
}

variable "priority" {
  type        = number
  description = "The priority for the rule"
  default     = 99
}

variable "ip_address_type" {
  type        = string
  description = "IP address for the ALB"
  default     = "ipv4"

}

variable "load_balancer_type" {
  type        = string
  description = "the type of Load Balancer"
  default     = "application"
}