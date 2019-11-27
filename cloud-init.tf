
data "local_file" "cloud-config-web-txt" {
  filename        = "cloud-config-web.txt"
}

data "local_file" "cloud-config-db-txt" {
  filename        = "cloud-config-db.txt"
}

data "local_file" "raxak-protect-setup-script" {
  filename        = "RaxakProtectSetup.sh"
}

data "template_cloudinit_config" "cloud-init-web" {
  base64_encode   = false
  gzip            = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-config-web-txt.content}"
  }

  part {
     filename      = "RaxakProtectSetup.sh"
     content_type  = "text/x-shellscript"
     content       =  "${data.local_file.raxak-protect-setup-script.content}"
   }
}

data "template_cloudinit_config" "cloud-init-db" {
  base64_encode   = false
  gzip            = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-config-db-txt.content}"
  }

  part {
    filename      = "RaxakProtectSetup.sh"
    content_type  = "text/x-shellscript"
    content       =  "${data.local_file.raxak-protect-setup-script.content}"
  }
}