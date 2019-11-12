#---------------------------------------------------------
# MODIFY VARIABLES AS NEEDED
#---------------------------------------------------------

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------
variable "vpc1-name" {
  default = "raxak-test"
}

variable "resource_group" {
  default = "default"
}

variable "server-count" {
  default = 2
}

variable "server-name" {
  default = "test-server-%02d"
}

#---------------------------------------------------------
## DEFINE Zones
#---------------------------------------------------------
variable "zone1" {
  default = "us-south-1"
}

#---------------------------------------------------------
## DEFINE CIDR Blocks to be used in each zone
#---------------------------------------------------------

variable "address-prefix-vpc-a-1" {
  default = "172.21.0.0/21"
}


#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "server-subnet-vpc-a-zone-1" {
  default = "172.21.0.0/24"
}


#---------------------------------------------------------
## DEFINE OS image to be used for compute instances
#---------------------------------------------------------

#image = Centos7
variable "image" {
  default = "99edcc54-c513-4d46-9f5b-36243a1e50e2"
}

#---------------------------------------------------------
## DEFINE webapptier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-server" {
  default = "cx2-2x4"
}

