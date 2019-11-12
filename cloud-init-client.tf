
data "local_file" "cloud-init-text" {
  filename        = "cloud-init.txt"
}

data "local_file" "script" {
  filename        = "RaxakProtectSetup.sh"
}

data "template_cloudinit_config" "cloud-init-client" {
  base64_encode   = true
  gzip            = true

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-init-text.content_base64}"
  }

  part {
    filename      = "RaxakProtectSetup.sh"
    content_type  = "text/x-shellscript"
    content       =  "${data.local_file.script.content_base64}"
  }
}
