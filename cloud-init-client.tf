
data "template_file" "cloud-init-config" {
  template = "${file("cloud-init.txt")}"
}

data "template_file" "script" {
  template = "${file("RaxakProtectSetup.sh")}"
}

data "template_cloudinit_config" "cloud-init-client" {
  base64_encode = true
  gzip          = true

  part {
    filename      = "init.cfg"
    content_type  = "text/cloud-config"
    content       = "${data.template_file.cloud-init-config.rendered}"
  }

  part {
    filename      = "RaxakProtectSetup.sh"
    content_type  = "text/shellscript"
    content       =  "${data.template_file.script.rendered}"
  }
}
