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


#---------------------------------------------------------
## DEFINE Zones
#---------------------------------------------------------
variable "zone-a" {
  default = "us-south-1"
}

variable "zone-b" {
  default = "us-south-3"
}

#---------------------------------------------------------
## DEFINE CIDR Blocks to be used in each zone
#---------------------------------------------------------

variable "address-prefix-vpc-a-zone-a" {
  default = "172.21.0.0/22"
}

variable "address-prefix-vpc-a-zone-b" {
  default = "172.21.4.0/22"
}


#---------------------------------------------------------
## DEFINE subnets for zone 1
#---------------------------------------------------------

variable "web-subnet-vpc-a-zone-a" {
  default = "172.21.0.0/24"
}

variable "data-subnet-vpc-a-zone-a" {
  default = "172.21.1.0/24"
}

variable "web-subnet-vpc-a-zone-b" {
  default = "172.21.4.0/24"
}

variable "data-subnet-vpc-a-zone-b" {
  default = "172.21.5.0/24"
}

#---------------------------------------------------------
## DEFINE OS image to be used for compute instances
#---------------------------------------------------------

#image = Centos7
variable "os-image-name" {
  default = "ibm-centos-7-0-64"
}

variable "webserver-profile" {
  default = "cx2-2x4"
}

variable "dbserver-profile" {
  default = "cx2-2x4"
}

variable "web-server-count" {
  default = 1
}

variable "db-server-count" {
  default = 1
}

variable "web-server-name-template" {
  default = "webserver-%02d"
}

variable "db-server-name-template" {
  default = "mysqlserver-%02d"
}

