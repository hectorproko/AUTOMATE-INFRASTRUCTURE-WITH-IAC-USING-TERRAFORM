region = "us-east-1"
vpc_cidr = "172.16.0.0/16" 
enable_dns_support = "true" 
enable_dns_hostnames = "true"  
enable_classiclink = "false" 
enable_classiclink_dns_support = "false" 
preferred_number_of_public_subnets = 2

variable tags = {
  Enviroment      = "development" 
  Owner-Email     = "hectore@email.com"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}
