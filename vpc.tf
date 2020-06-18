#---------------------------------------------------------
# Get resource_group id
#---------------------------------------------------------

data "ibm_resource_group" "group" {
  name = "${var.resource_group}"
}

#---------------------------------------------------------
# Create new VPC
#---------------------------------------------------------

resource "ibm_is_vpc" "vpc-a" {
  name                = "${var.vpc-a-name}"
  resource_group      = "${data.ibm_resource_group.group.id}"
  address_prefix_management = "manual"
}


#---------------------------------------------------------
# Create new address prefixes in VPC for Zone 1 & Zone 2
#---------------------------------------------------------
resource "ibm_is_vpc_address_prefix" "prefix1-a-1" {
  name = "vpc-a-zone1-vpc-a-cidr-1"
  vpc  = "${ibm_is_vpc.vpc-a.id}"
  zone = "${var.zone-a}"
  cidr = "${var.address-prefix-vpc-a-zone-a}"
}

resource "ibm_is_vpc_address_prefix" "prefix1-a-2" {
  name = "vpc-a-zone2-vpc-a-cidr-1"
  vpc  = "${ibm_is_vpc.vpc-a.id}"
  zone = "${var.zone-b}"
  cidr = "${var.address-prefix-vpc-a-zone-b}"
}

#---------------------------------------------------------
# Get Public Gateway's for Zone 1 & Zone 2
#---------------------------------------------------------
resource "ibm_is_public_gateway" "pubgw-vpc-a-zone1" {
  name = "${var.vpc-a-name}-${var.zone-a}-pubgw"
  vpc  = "${ibm_is_vpc.vpc-a.id}"
  zone = "${var.zone-a}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

resource "ibm_is_public_gateway" "pubgw-vpc-a-zone2" {
  name = "${var.vpc-a-name}-${var.zone-b}-pubgw"
  vpc  = "${ibm_is_vpc.vpc-a.id}"
  zone = "${var.zone-b}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

#---------------------------------------------------------
## Create Web and DB subnets in Zone 1 & Zone 2
#---------------------------------------------------------
resource "ibm_is_subnet" "web-subnet-vpc-a-zone-a" {
  name            = "${var.vpc-a-name}-${var.zone-a}-webservers"
  vpc             = "${ibm_is_vpc.vpc-a.id}"
  zone            = "${var.zone-a}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-a}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-zone1.id}"
}

resource "ibm_is_subnet" "web-subnet-vpc-a-zone-b" {
  name            = "${var.vpc-a-name}-${var.zone-b}-webservers"
  vpc             = "${ibm_is_vpc.vpc-a.id}"
  zone            = "${var.zone-b}"
  ipv4_cidr_block = "${var.web-subnet-vpc-a-zone-b}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-zone2.id}"
}

resource "ibm_is_subnet" "data-subnet-vpc-a-zone-a" {
  name            = "${var.vpc-a-name}-${var.zone-a}-dbservers"
  vpc             = "${ibm_is_vpc.vpc-a.id}"
  zone            = "${var.zone-a}"
  ipv4_cidr_block = "${var.data-subnet-vpc-a-zone-a}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-zone1.id}"
}

resource "ibm_is_subnet" "data-subnet-vpc-a-zone-b" {
  name            = "${var.vpc-a-name}-${var.zone-b}-dbservers"
  vpc             = "${ibm_is_vpc.vpc-a.id}"
  zone            = "${var.zone-b}"
  ipv4_cidr_block = "${var.data-subnet-vpc-a-zone-b}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-zone2.id}"
}