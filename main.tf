#---------------------------------------------------------
# Get resource_group id
#---------------------------------------------------------

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

#---------------------------------------------------------
# Create new VPC
#---------------------------------------------------------

resource "ibm_is_vpc" "vpc1" {
  name                = "${var.vpc1-name}"
  resource_group      = "${data.ibm_resource_group.group.id}"
}


#---------------------------------------------------------
# Create new address prefixes in VPC
#---------------------------------------------------------
resource "ibm_is_vpc_address_prefix" "prefix1-a-1" {
  name = "vpc-a-zone1-vpc-a-cidr-1"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  cidr = "${var.address-prefix-vpc-a-1}"
  provisioner "local-exec" {
    command = "sleep 120"
    when    = "destroy"
  }
}
resource "ibm_is_vpc_address_prefix" "prefix1-a-2" {
  name = "vpc-a-zone1-vpc-a-cidr-1"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  cidr = "${var.address-prefix-vpc-a-2}"
  provisioner "local-exec" {
    command = "sleep 120"
    when    = "destroy"
  }
}


#---------------------------------------------------------
# Get Public Gateway's for Zone 1
#---------------------------------------------------------
resource "ibm_is_public_gateway" "pubgw-vpc-a-web-zone1" {
  name = "${var.vpc1-name}-${var.zone1}-web-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

resource "ibm_is_public_gateway" "pubgw-vpc-a-web-zone2" {
  name = "${var.vpc1-name}-${var.zone2}-web-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

resource "ibm_is_public_gateway" "pubgw-vpc-a-db-zone1" {
  name = "${var.vpc1-name}-${var.zone1}-db-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

resource "ibm_is_public_gateway" "pubgw-vpc-a-db-zone2" {
  name = "${var.vpc1-name}-${var.zone2}-db-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone2}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

#---------------------------------------------------------
## Create Server subnet
#---------------------------------------------------------
resource "ibm_is_subnet" "web-subnet-vpc-a-zone1" {
  name            = "${var.vpc1-name}-${var.zone1}-webservers"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-1}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-web-zone1.id}"

}

resource "ibm_is_subnet" "web-subnet-vpc-a-zone2" {
  name            = "${var.vpc1-name}-${var.zone2}-webbservers"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-2}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-web-zone2.id}"
}

resource "ibm_is_subnet" "data-subnet-vpc-a-zone1" {
  name            = "${var.vpc1-name}-${var.zone1}-dbservers"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-1}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-db-zone1.id}"
}

resource "ibm_is_subnet" "data-subnet-vpc-a-zone2" {
  name            = "${var.vpc1-name}-${var.zone2}-dbservers"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone2}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-2}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-db-zone2.id}"
}