#---------------------------------------------------------
# Create sshkey from file
#---------------------------------------------------------
data "ibm_is_ssh_key" "sshkey1" {
  name = "jonhall"
}

resource "ibm_is_instance" "vpc-a-webserver-zone-1" {
  count   = "${var.web-server-count}"
  name    = "${format(var.web-server-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-server}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.web-subnet-vpc-a-zone1.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-web.rendered}"
}

resource "ibm_is_instance" "vpc-a-dbserver-zone-1" {
  count   = "${var.db-server-count}"
  name    = "${format(var.db-server-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-server}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.data-subnet-vpc-a-zone1.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-db.rendered}"
}

resource "ibm_is_instance" "vpc-a-webserver-zone-2" {
  count   = "${var.web-server-count}"
  name    = "${format(var.web-server-name, count.index + 1)}-${var.zone2}"
  image   = "${var.image}"
  profile = "${var.profile-server}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.web-subnet-vpc-a-zone2.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone2}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-web.rendered}"
}

resource "ibm_is_instance" "vpc-a-dbserver-zone-2" {
  count   = "${var.db-server-count}"
  name    = "${format(var.db-server-name, count.index + 1)}-${var.zone2}"
  image   = "${var.image}"
  profile = "${var.profile-server}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.data-subnet-vpc-a-zone2.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone2}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-db.rendered}"
}


#---------------------------------------------------------
# Assign floating IPs
#---------------------------------------------------------

resource "ibm_is_floating_ip" "vpc-a-webserver-zone1-fip" {
  count   = "${var.web-server-count}"
  name    = "${format(var.web-server-name, count.index + 1)}-${var.zone1}-fip"
  target  = "${element(ibm_is_instance.vpc-a-webserver-zone-1.*.primary_network_interface.0.id, count.index)}"
}

resource "ibm_is_floating_ip" "vpc-a-dbserver-zone1-fip" {
  count   = "${var.db-server-count}"
  name    = "${format(var.db-server-name, count.index + 1)}-${var.zone1}-fip"
  target  = "${element(ibm_is_instance.vpc-a-dbserver-zone-1.*.primary_network_interface.0.id, count.index)}"
}

resource "ibm_is_floating_ip" "vpc-a-webserver-zone2-fip" {
  count   = "${var.web-server-count}"
  name    = "${format(var.web-server-name, count.index + 1)}-${var.zone2}-fip"
  target  = "${element(ibm_is_instance.vpc-a-webserver-zone-2.*.primary_network_interface.0.id, count.index)}"
}

resource "ibm_is_floating_ip" "vpc-a-dbserver-zone2-fip" {
  count   = "${var.web-server-count}"
  name    = "${format(var.db-server-name, count.index + 1)}-${var.zone2}-fip"
  target  = "${element(ibm_is_instance.vpc-a-dbserver-zone-2.*.primary_network_interface.0.id, count.index)}"
}