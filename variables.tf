#---------------------------------------------------------
# MODIFY VARIABLES AS NEEDED
#---------------------------------------------------------

#---------------------------------------------------------
## DEFINE VPC
#---------------------------------------------------------
variable "vpc-a-name" {
  default = "wordpress-example"
}

variable "resource_group" {
  default = "vpc_sandbox"
}

#---------------------------------------------------------
## DEFINE DNS
#---------------------------------------------------------

variable "glb-hostname" {
  default = "wordpress"
}

variable "domain" {
  default = "hallusa.com"
}

variable "cis_instance_id" {
  default = "crn:v1:bluemix:public:internet-svcs:global:a/7a24585774d8b3c897d0c9b47ac48461:4c780756-df67-40ac-b1fa-65ca07eaebc2::"
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
## DEFINE CIDR Blocks to be used in Zone A & B
#---------------------------------------------------------

variable "address-prefix-vpc-a-zone-a" {
  default = "172.21.0.0/21"
}

variable "address-prefix-vpc-a-zone-b" {
  default = "172.21.8.0/21"
}


#---------------------------------------------------------
## DEFINE subnets for zone a
#---------------------------------------------------------

variable "web-subnet-vpc-a-zone-a" {
  default = "172.21.0.0/24"
}

variable "data-subnet-vpc-a-zone-a" {
  default = "172.21.1.0/24"
}

#---------------------------------------------------------
## DEFINE subnets for zone b
#---------------------------------------------------------
variable "web-subnet-vpc-a-zone-b" {
  default = "172.21.8.0/24"
}

variable "data-subnet-vpc-a-zone-b" {
  default = "172.21.9.0/24"
}

#---------------------------------------------------------
## DEFINE OS image & profile to use for server types
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

variable "web-server-count-per-zone" {
  default = 1
}

variable "web-server-name-template-zone-a" {
  default = "webserver-1%03d"
}

variable "web-server-name-template-zone-b" {
  default = "webserver-2%03d"
}

variable "db-server-master-name" {
  default = "mysql-server-master"
}

variable "db-server-slave-name" {
  default = "mysql-server-slave"
}

variable "db-wordpress-passowrd" {
  default = "passw0rd"
}

variable "db-replication-password" {
  default = "replic8tion"
}

variable "vpc-a-lb-connections" {
  default = 2000
}

variable "web-lb-algorithm" {
  default = "round_robin"
}

variable "cert-crn" {
  default = "crn:v1:bluemix:public:cloudcerts:us-south:a/7a24585774d8b3c897d0c9b47ac48461:d19e0025-0ec8-47fa-92b1-5bb141956bea:certificate:0dcd0751fb248cad11681dfbca1b0e37"
  }
  
variable "raxak-protect-script-location" {
  default = "https://post-provisioning-scripts.s3.us-south.cloud-object-storage.appdomain.cloud/RaxakProtectSetup.sh"
}
