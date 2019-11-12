#---------------------------------------------------------
# Create Webapptier Security Group & Rules
#---------------------------------------------------------
resource "ibm_is_security_group" "vpc-a-server-securitygroup" {
  name = "${var.vpc1-name}-server-securitygroup"
  vpc  = "${ibm_is_vpc.vpc1.id}"
}

resource "ibm_is_security_group_rule" "vpc-a-server-securitygroup-rule1" {
  group      = "${ibm_is_security_group.vpc-a-server-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "${var.server-subnet-vpc-a-zone-1}"
}

resource "ibm_is_security_group_rule" "vpc-a-server-securitygroup-rule2" {
  group      = "${ibm_is_security_group.vpc-a-server-securitygroup.id}"
  direction  = "inbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  tcp = {
    port_min = 22
    port_max = 22
  }
  depends_on = ["ibm_is_security_group_rule.vpc-a-server-securitygroup-rule1"]
}


resource "ibm_is_security_group_rule" "vpc-a-server-securitygroup-rule3" {
  group      = "${ibm_is_security_group.vpc-a-server-securitygroup.id}"
  direction  = "outbound"
  ip_version = "ipv4"
  remote     = "0.0.0.0/0"
  depends_on = ["ibm_is_security_group_rule.vpc-a-server-securitygroup-rule2"]
}

#