#---------------------------------------------------------
# Provision Master & Salve Databaseserver
#---------------------------------------------------------

resource "ibm_is_volume" "vpc-a-dbserver-zone-a-data-volume" {
  name     = "${var.db-server-name}-master-data-volume"
  profile  = "10iops-tier"
  zone     = "${var.zone-a}"
  capacity = 100
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_volume" "vpc-a-dbserver-zone-b-data-volume" {
  name     = "${var.db-server-name}-slave-data-volume"
  profile  = "10iops-tier"
  zone     = "${var.zone-b}"
  capacity = 100
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_instance" "vpc-a-dbserver-zone-a" {
  name    = "${var.db-server-name}-master"
  image   = "${data.ibm_is_image.image.id}"
  profile = "${var.dbserver-profile}"
  primary_network_interface = {
    subnet          = "${ibm_is_subnet.data-subnet-vpc-a-zone-a.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"]
  }
  vpc  = "${ibm_is_vpc.vpc-a.id}"
  zone = "${var.zone-a}"
  keys = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-db.rendered}"
  volumes = ["${ibm_is_volume.vpc-a-dbserver-zone-a-data-volume.id}"]
  resource_group = "${data.ibm_resource_group.group.id}"
}

resource "ibm_is_instance" "vpc-a-dbserver-zone-b" {
  name    = "${var.db-server-name}-slave"
  image   = "${data.ibm_is_image.image.id}"
  profile = "${var.dbserver-profile}"
  primary_network_interface = {
    subnet          = "${ibm_is_subnet.data-subnet-vpc-a-zone-b.id}"
    security_groups = ["${ibm_is_security_group.vpc-a-dbserver-securitygroup.id}"]
  }
  vpc       = "${ibm_is_vpc.vpc-a.id}"
  zone      = "${var.zone-b}"
  keys      = ["${data.ibm_is_ssh_key.sshkey1.id}"]
  user_data = "${data.template_cloudinit_config.cloud-init-db.rendered}"
  volumes   = ["${ibm_is_volume.vpc-a-dbserver-zone-b-data-volume.id}"]
  resource_group = "${data.ibm_resource_group.group.id}"
}

#---------------------------------------------------------
# Assign floating IPs To DbServers
#---------------------------------------------------------
resource "ibm_is_floating_ip" "vpc-a-dbserver-zone1-fip" {
  name    = "${var.db-server-name}-${var.zone-a}-fip"
  target  = "${element(ibm_is_instance.vpc-a-dbserver-zone-a.*.primary_network_interface.0.id, count.index)}"
}

resource "ibm_is_floating_ip" "vpc-a-dbserver-zone2-fip" {
  name    = "${var.db-server-name}-${var.zone-b}-fip"
  target  = "${element(ibm_is_instance.vpc-a-dbserver-zone-b.*.primary_network_interface.0.id, count.index)}"
}