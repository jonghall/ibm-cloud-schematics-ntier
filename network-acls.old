resource "ibm_is_network_acl" "webapptier_acl" {
  name = "${var.vpc-a-name}-webapptier-acl"
  vpc = "${ibm_is_vpc.vpc-a.id}"
  rules {
      name      = "${var.vpc-a-name}-webapptier-icmp-all"
      direction = "inbound"
      action    = "allow"
      source    = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      icmp = {
        type = "0"
        code = "0"
      }
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-udp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      udp = {
        port_min = "1024"
        port_max = "65535"
      }
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-tcp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-within-vpc"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.address-prefix-vpc-a-zone-a}"
      destination = "${var.address-prefix-vpc-a-zone-b}"
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-web-http-traffic-a"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "${var.address-prefix-vpc-a-zone-a}"
      tcp = {
        port_min = "80"
        port_max = "80"
      }
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-web-http-traffic-b"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "${var.address-prefix-vpc-a-zone-b}"
      tcp = {
        port_min = "80"
        port_max = "80"
      }
    }
    rules {
      name        = "${var.vpc-a-name}-webapptier-allow-all-egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
}

resource "ibm_is_network_acl" "dbtier_acl" {
  name = "${var.vpc-a-name}-dbtier-acl"
  vpc = "${ibm_is_vpc.vpc-a.id}"
  rules {
      name      = "${var.vpc-a-name}-dbtier-icmp-all"
      direction = "inbound"
      action    = "allow"
      source    = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      icmp = {
        type = "0"
        code = "0"
      }
  }
  rules {
      name        = "${var.vpc-a-name}-dbtier-udp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      udp = {
        port_min = "1024"
        port_max = "65535"
      }
  }
  rules {
      name        = "${var.vpc-a-name}-dbtier-tcp-user-ports"
      direction   = "inbound"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      tcp = {
        port_min = "1024"
        port_max = "65535"
      }
  }
  rules {
      name        = "${var.vpc-a-name}-dbtier-within-vpc"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.address-prefix-vpc-a-zone-b}"
      destination = "${var.address-prefix-vpc-a-zone-b}"
    }
  rules {
      name        = "${var.vpc-a-name}-dbtier-within-vpc"
      direction   = "inbound"
      action      = "allow"
      source      = "${var.address-prefix-vpc-a-zone-b}"
      destination = "${var.address-prefix-vpc-a-zone-b}"
    }
  rules {
    name        = "${var.vpc-a-name}-dbtier-allow-all-egress"
    action      = "allow"
    source      = "0.0.0.0/0"
    destination = "0.0.0.0/0"
    direction   = "outbound"
  }
}