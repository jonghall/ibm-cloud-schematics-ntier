data "template_cloudinit_config" "cloud-init-client" {
  base64_encode = false
  gzip          = false

  part {
    content = <<EOF
#cloud-config
package_update: true
package_upgrade: true

packages:
- acl
- ntp
- htop
- git
- unzip
- supervisor
- iperf3
- mtr
- net-tools
- traceroute
- tcpdump

power_state:
 mode: reboot
 message: Rebooting server now.
 timeout: 30
 condition: True

runcmd:

EOF
  }
}