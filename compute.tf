#---------------------------------------------------------
# Create sshkey from file
#---------------------------------------------------------
data "ibm_is_ssh_key" "sshkey1" {
  name = "jonhall"
}


resource "ibm_is_instance" "vpc-a-client" {
  count   = "${var.server-count}"
  name    = "${format(var.server-name, count.index + 1)}-${var.zone1}"
  image   = "${var.image}"
  profile = "${var.profile-server}"

  primary_network_interface = {
    subnet          = "${ibm_is_subnet.server-subnet-vpc-a-zone1.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-server-securitygroup.id}"]
  }

  vpc       = "${ibm_is_vpc.vpc1.id}"
  zone      = "${var.zone1}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-client.rendered}"
}


#---------------------------------------------------------
# Assign floating IPs
#---------------------------------------------------------

resource "ibm_is_floating_ip" "vpc-a-client-zone1-fip" {
  count   = "${var.server-count}"
  name    = "${format(var.server-name, count.index + 1)}-${var.zone1}-fip"
  target  = "${element(ibm_is_instance.vpc-a-client.*.primary_network_interface.0.id, count.index)}"
}

