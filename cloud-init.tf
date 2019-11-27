
data "local_file" "cloud-init-web-text" {
  filename        = "cloud-init-web.cfg"
}

data "local_file" "cloud-init-db-text" {
  filename        = "cloud-init-db.cfg"
}

data "local_file" "script" {
  filename        = "RaxakProtectSetup.sh"
}

data "template_cloudinit_config" "cloud-init-web" {
  base64_encode   = false
  gzip            = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-init-web-text.content}"
  }

  part {
     filename      = "RaxakProtectSetup.sh"
     content_type  = "text/x-shellscript"
     content       =  "${data.local_file.script.content}"
   }
}

data "template_cloudinit_config" "cloud-init-db" {
  base64_encode   = false
  gzip            = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-init-db-text.content}"
  }

  part {
    filename      = "RaxakProtectSetup.sh"
    content_type  = "text/x-shellscript"
    content       =  "${data.local_file.script.content}"
  }
}