# Get list of availability zones
data "aws_availability_zones" "available" {
    state = "available"
}

provider "aws" {
    region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block                     = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

#   tags = {
#     Name = "HRA-VPC"
#   }
  tags = merge(
    var.tags,
    {
      Name = format("%s-VPC", var.name)
    },
  )

}

# Create public subnets
resource "aws_subnet" "public" { #so if preffered is null the number of subnets is = to AZ, could be 3
  count  = var.preferred_number_of_public_subnets == null ? length(data.aws_availability_zones.available.names) : var.preferred_number_of_public_subnets   
  vpc_id = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8 , count.index + 1)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  tags = merge(
    var.tags,
    {
      Name = format("PublicSubnet-%s", count.index + 1) #Inex starts with 0
    } 
  )

}




