#---------------------------------------------------------
# Create sshkey from file
#---------------------------------------------------------
data "ibm_is_ssh_key" "sshkey1" {
  name = "jonhall"
}

data "ibm_is_image" "image" {
  name = "${var.os-image-name}"
}

#---------------------------------------------------------
# Provision Web Servers in Each Zone
#---------------------------------------------------------

resource "ibm_is_instance" "vpc-a-webserver-zone-a" {
  count   = "${var.web-server-count-per-zone}"
  name    = "${format(var.web-server-name-template-zone-a, count.index + 1)}"
  image   = "${data.ibm_is_image.image.id}"
  profile = "${var.webserver-profile}"
  primary_network_interface = {
    subnet          = "${ibm_is_subnet.web-subnet-vpc-a-zone-a.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc-a.id}"
  zone      = "${var.zone-a}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-web.rendered}"
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_instance" "vpc-a-webserver-zone-b" {
  count   = "${var.web-server-count-per-zone}"
  name    = "${format(var.web-server-name-template-zone-b, count.index + 1)}"
  image   = "${data.ibm_is_image.image.id}"
  profile = "${var.webserver-profile}"
  primary_network_interface = {
    subnet          = "${ibm_is_subnet.web-subnet-vpc-a-zone-b.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-webserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc-a.id}"
  zone      = "${var.zone-b}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-web.rendered}"
  resource_group = "${data.ibm_resource_group.group.id}"
}

#---------------------------------------------------------
# Assign floating IPs To Webservers
#---------------------------------------------------------

resource "ibm_is_floating_ip" "vpc-a-webserver-zone1-fip" {
  count   = "${var.web-server-count-per-zone}"
  name    = "${format(var.web-server-name-template-zone-a, count.index + 1)}-${var.zone-a}-fip"
  target  = "${element(ibm_is_instance.vpc-a-webserver-zone-a.*.primary_network_interface.0.id, count.index)}"
}
resource "ibm_is_floating_ip" "vpc-a-webserver-zone2-fip" {
  count   = "${var.web-server-count-per-zone}"
  name    = "${format(var.web-server-name-template-zone-b, count.index + 1)}-${var.zone-b}-fip"
  target  = "${element(ibm_is_instance.vpc-a-webserver-zone-b.*.primary_network_interface.0.id, count.index)}"
}