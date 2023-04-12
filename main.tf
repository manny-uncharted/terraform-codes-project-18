module "VPC" {
  source                              = "./modules/VPC"
  region                              = var.region
  vpc_cidr                            = var.vpc_cidr
  enable_dns_support                  = var.enable_dns_support
  enable_dns_hostnames                = var.enable_dns_hostnames
  enable_classiclink                  = var.enable_classiclink
  enable_classiclink_dns_support      = var.enable_classiclink_dns_support
  preferred_number_of_public_subnets  = var.preferred_number_of_public_subnets
  preferred_number_of_private_subnets = var.preferred_number_of_private_subnets
  name                                = var.name
  tags                                = var.tags
  environment                         = var.environment
  destination_cidr_block              = var.destination_cidr_block

  private_subnets = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}

# Module for Load Balancers, it creates both the external and internal ALB
module "ALB" {
  source              = "./modules/ALB"
  vpc_id              = module.VPC.vpc_id
  public-sg           = module.Security.Ext-ALB-sg
  private-sg          = module.Security.Int-ALB-sg
  public-sbn-1        = module.VPC.public_subnets-1
  public-sbn-2        = module.VPC.public_subnets-2
  private-sbn-1       = module.VPC.private_subnets-1
  private-sbn-2       = module.VPC.private_subnets-2
  load_balancer_type  = var.load_balancer_type
  ip_address_type     = var.ip_address_type
  port                = var.port
  company_name        = var.company_name
  environment         = var.environment
  protocol            = var.protocol
  tags                = var.tags
  path                = var.path
  interval            = var.interval
  timeout             = var.timeout
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  target_type         = var.target_type
  default_action_type = var.default_action_type
  priority            = var.priority
}


# Module for Security Groups
module "Security" {
  source = "./modules/Security"
  vpc_id = module.VPC.vpc_id
}


# Module for Autoscaling Groups and Launch Templates
module "Autoscaling" {
  source           = "./modules/Autoscaling"
  ami-web          = var.ami
  ami-bastion      = var.ami
  ami-nginx        = var.ami
  desired_capacity = 2
  max_size         = 2
  min_size         = 2
  web-sg           = [module.Security.web-sg]
  nginx-sg         = [module.Security.nginx-sg]
  bastion-sg       = [module.Security.bastion-sg]
  wordpress-alb-tg = module.ALB.wordpress-tg
  nginx-alb-tg     = module.ALB.nginx-tg
  tooling-alb-tg   = module.ALB.tooling-tg
  instance_profile = module.VPC.instance_profile
  private_subnets  = [module.VPC.private_subnets-1, module.VPC.private_subnets-2]
  public_subnets   = [module.VPC.public_subnets-1, module.VPC.public_subnets-2]
  keypair          = var.keypair
}

# Module for Elastic Filesystem; this module will creat elastic file system isn the webservers availablity
# zone and allow traffic fro the webservers

module "EFS" {
  source       = "./modules/EFS"
  efs-subnet-1 = module.VPC.private_subnets-1
  efs-subnet-2 = module.VPC.private_subnets-2
  efs-sg       = [module.Security.datalayer-sg]
  account_no   = var.account_no
}

# RDS module; this module will create the RDS instance in the private subnet

module "RDS" {
  source          = "./modules/RDS"
  db-password     = var.master-password
  db-username     = var.master-username
  db-sg           = [module.Security.datalayer-sg]
  private_subnets = [module.VPC.private_subnets-3, module.VPC.private_subnets-4]
}

# The Module creates instances for jenkins, sonarqube abd jfrog
module "compute" {
  source          = "./modules/compute"
  ami-jenkins     = var.ami
  ami-sonar       = var.ami
  ami-jfrog       = var.ami
  subnets-compute = module.VPC.public_subnets-1
  sg-compute      = [module.Security.Ext-ALB-sg]
  keypair         = var.keypair
}