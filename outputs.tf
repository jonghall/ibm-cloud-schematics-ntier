
output "web-server-ips" {
  value = [
    "${ibm_is_instance.vpc-a-webserver-zone-a.*.primary_network_interface.0.primary_ipv4_address}", "${ibm_is_instance.vpc-a-webserver-zone-b.*.primary_network_interface.0.primary_ipv4_address}"]
}

output "web-server-fips" {
  value = ["${ibm_is_floating_ip.vpc-a-webserver-zone1-fip.*.address}", "${ibm_is_floating_ip.vpc-a-webserver-zone2-fip.*.address}"]
}

output "master_db_ip" {
  value = "${ibm_is_instance.vpc-a-dbserver-zone-a.0.primary_network_interface.0.primary_ipv4_address}"
}

output "master_db_fip" {
  value = "${ibm_is_floating_ip.vpc-a-dbserver-zone1-fip.0.address}"
}


output "slave_db" {
  value = "${ibm_is_instance.vpc-a-dbserver-zone-b.0.primary_network_interface.0.primary_ipv4_address}"
}

output "slave_db_fip" {
  value = "${ibm_is_floating_ip.vpc-a-dbserver-zone2-fip.0.address}"
}

output "FQDN" {
  value = "${var.glb-hostname}.${var.domain}"
}
