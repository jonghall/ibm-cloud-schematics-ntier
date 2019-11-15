
data "local_file" "cloud-init-text" {
  filename        = "cloud-init.txt"
}

#data "local_file" "script" {
#  filename        = "RaxakProtectSetup.sh"
#}

data "template_cloudinit_config" "cloud-init-client" {
  base64_encode   = false
  gzip            = false

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.local_file.cloud-init-text.content}"
  }

#  part {
#    filename      = "RaxakProtectSetup.sh"
#    content_type  = "text/x-shellscript"
#    content       =  "${data.local_file.script.content}"
#  }
}
