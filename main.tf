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


#---------------------------------------------------------
# Get Public Gateway's for Zone 1
#---------------------------------------------------------
resource "ibm_is_public_gateway" "pubgw-vpc-a-zone1" {
  name = "${var.vpc1-name}-${var.zone1}-pubgw"
  vpc  = "${ibm_is_vpc.vpc1.id}"
  zone = "${var.zone1}"
  provisioner "local-exec" {
    command = "sleep 60"
    when    = "destroy"
  }
}

#---------------------------------------------------------
## Create Server subnet
#---------------------------------------------------------
resource "ibm_is_subnet" "server-subnet-vpc-a-zone1" {
  name            = "${var.vpc1-name}-${var.zone1}-servers"
  vpc             = "${ibm_is_vpc.vpc1.id}"
  zone            = "${var.zone1}"
  ipv4_cidr_block = "${var.server-subnet-vpc-a-zone-1}"
  public_gateway  = "${ibm_is_public_gateway.pubgw-vpc-a-zone1.id}"

}


