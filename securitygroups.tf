#---------------------------------------------------------
# Create Webapptier Security Group & Rules
#---------------------------------------------------------
resource "ibm_is_security_group" "vpc-a-webserver-securitygroup" {
  name = "${var.vpc1-name}-webserver-securitygroup"
  vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule1" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.web-subnet-vpc-a-zone-1}"
}

resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule2" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.web-subnet-vpc-a-zone-2}"
}


resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule3" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule4" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  tcp = {
    port_min = 80
    port_max = 80
  }
}

resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule5" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  tcp = {
    port_min = 443
    port_max = 443
  }
}

resource "ibm_is_security_group_rule" "vpc-a-webserver-securitygroup-rule6" {
  group      = "${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"
  direction  = "outbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
}

#---------------------------------------------------------
# Create dbtier Security Group & Rules
#---------------------------------------------------------
resource "ibm_is_security_group" "vpc-a-dbserver-securitygroup" {
  name = "${var.vpc1-name}-dbserver-securitygroup"
  vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule1" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.data-subnet-vpc-a-zone-1}"
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule2" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.data-subnet-vpc-a-zone-2}"
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule3" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  tcp = {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule4" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.web-subnet-vpc-a-zone-1}"
  tcp = {
    port_min = 3309
    port_max = 3309
  }
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule5" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.web-subnet-vpc-a-zone-2}"
  tcp = {
    port_min = 3309
    port_max = 3309
  }
}

resource "ibm_is_security_group_rule" "vpc-a-dbserver-securitygroup-rule6" {
  group      = "${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"
  direction  = "outbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
}
