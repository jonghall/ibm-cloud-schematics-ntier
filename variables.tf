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

variable "web-server-count" {
  default = 2
}

variable "db-server-count" {
  default = 1
}

variable "web-server-name" {
  default = "webserver-%02d"
}

variable "db-server-name" {
  default = "mysqlserver-%02d"
}

#---------------------------------------------------------
## DEFINE Zones
#---------------------------------------------------------
variable "zone1" {
  default = "us-south-1"
}

variable "zone2" {
  default = "us-south-3"
}

#---------------------------------------------------------
## DEFINE CIDR Blocks to be used in each zone
#---------------------------------------------------------

variable "address-prefix-vpc-a-1" {
  default = "172.21.0.0/21"
}

variable "address-prefix-vpc-a-2" {
  default = "172.21.4.0/21"
}


#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "web-subnet-vpc-a-zone-1" {
  default = "172.21.0.0/24"
}

variable "data-subnet-vpc-a-zone-1" {
  default = "172.21.1.0/24"
}

variable "web-subnet-vpc-a-zone-2" {
  default = "172.21.4.0/24"
}

variable "data-subnet-vpc-a-zone-2" {
  default = "172.21.5.0/24"
}

#---------------------------------------------------------
## DEFINE OS image to be used for compute instances
#---------------------------------------------------------

#image = Centos7
variable "image" {
#  default = "99edcc54-c513-4d46-9f5b-36243a1e50e2"
  default = "cc8debe0-1b30-6e37-2e13-744bfb2a0c11"
}

#---------------------------------------------------------
## DEFINE webapptier compute instance profile & quantity
#---------------------------------------------------------
variable "profile-server" {
  # default = "cx2-2x4"
  default = "cc1-2x4"
}

