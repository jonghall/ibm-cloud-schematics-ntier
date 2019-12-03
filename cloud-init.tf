#################################################
# Define Cloud-init scripts to run on provisioning
#################################################
data "local_file" "cloud-config-web-txt" {
  filename        = "cloud-config-web.txt"
}

data "local_file" "cloud-config-db-txt" {
  filename        = "cloud-config-db.txt"
}

data "local_file" "raxak-protect-setup-script" {
  filename        = "RaxakProtectSetup.sh"
}

data "template_file" "web-bootstrap-yaml" {
   template = "${file("${path.module}/ansible/web-bootstrap.tpl")}"
   vars = {
     domain = "${var.domain}"
     glb-hostname =  "${var.glb-hostname}"
     db_wordpress_password = "${var.db-wordpress-passowrd}"
     db_master_ip = "${ibm_is_instance.vpc-a-dbserver-zone-a.0.primary_network_interface.0.primary_ipv4_address}"
     db_slave_ip = "${ibm_is_instance.vpc-a-dbserver-zone-b.0.primary_network_interface.0.primary_ipv4_address}"
   }
}

data "template_file" "replication-master-yaml" {
   template = "${file("${path.module}/ansible/db-master-bootstrap.tpl")}"
   vars = {
     db_replication_password = "${var.db-replication-password}"
     db_wordpress_password = "${var.db-wordpress-passowrd}"
     db_master_ip = "${ibm_is_instance.vpc-a-dbserver-zone-a.0.primary_network_interface.0.primary_ipv4_address}"
     db_slave_ip = "${ibm_is_instance.vpc-a-dbserver-zone-b.0.primary_network_interface.0.primary_ipv4_address}"
   }
}

data "template_file" "replication-slave-yaml" {
   template = "${file("${path.module}/ansible/db-slave-bootstrap.tpl")}"
   vars = {
     db_replication_password = "${var.db-replication-password}"
     db_wordpress_password = "${var.db-wordpress-passowrd}"
     db_master_ip = "${ibm_is_instance.vpc-a-dbserver-zone-a.0.primary_network_interface.0.primary_ipv4_address}"
     db_slave_ip = "${ibm_is_instance.vpc-a-dbserver-zone-b.0.primary_network_interface.0.primary_ipv4_address}"
   }
}

data "template_cloudinit_config" "cloud-init-web" {
  gzip            = false
  base64_encode   = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-config-web-txt.content}"
  }

  part {
     content_type  = "text/x-include-url"
     content       =  "${var.raxak-protect-script-location}"
   }

  part {
    filename       = "configweb.yaml"
    content_type  = "text/x-shellscript"
    content       = "${data.template_file.web-bootstrap-yaml.rendered}"
  }
}

data "template_cloudinit_config" "cloud-init-db-master" {
  gzip            = false
  base64_encode   = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-config-db-txt.content}"
  }

  part {
     content_type  = "text/x-include-url"
     content       =  "${var.raxak-protect-script-location}"
   }

  part {
    filename       = "configdb.yaml"
    content_type  = "text/x-shellscript"
    content       = "${data.template_file.replication-master-yaml.rendered}"
  }
}

data "template_cloudinit_config" "cloud-init-db-slave" {
  gzip            = false
  base64_encode   = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-config-db-txt.content}"
  }

  part {
     content_type  = "text/x-include-url"
     content       =  "${var.raxak-protect-script-location}"
   }

  part {
    filename       = "configdb.yaml"
    content_type  = "text/x-shellscript"
    content       = "${data.template_file.replication-slave-yaml.rendered}"
  }
}