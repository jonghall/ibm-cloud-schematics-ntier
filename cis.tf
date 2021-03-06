#################################################
# Identify CIS /Cloudflare Instance
#################################################

data "ibm_cis_domain" "cis_instance_domain" {
  domain = "${var.domain}"
  cis_id = "${var.cis_instance_id}"
}

#setup healthcheck for nginx
resource "ibm_cis_healthcheck" "root" {
  cis_id         = "${var.cis_instance_id}"
  description    = "Websiteroot"
  expected_body  = ""
  expected_codes = "200"
  path           = "/nginx_status"
}

# Create Pool (of one) with VPC LBaaS instances using URL
resource "ibm_cis_origin_pool" "vpc-a-lbaas-web" {
  cis_id        = "${var.cis_instance_id}"
  name          = "${var.vpc-a-name}-originpool-lbaas-web01"
  check_regions = ["ENAM"]

  monitor = "${ibm_cis_healthcheck.root.id}"

  origins = {
    name    = "${var.vpc-a-name}-lbaas-web01"
    address = "${ibm_is_lb.vpc-a-web-lb.hostname}"
    enabled = true
  }
  description = "${var.vpc-a-name}-lbaas-web01"
  enabled     = true
}

# GLB name - name advertised by DNS for the website: prefix + domain.  Enable DDOS proxy
resource "ibm_cis_global_load_balancer" "glb" {
  cis_id           = "${var.cis_instance_id}"
  domain_id        = "${data.ibm_cis_domain.cis_instance_domain.id}"
  name             = "${var.glb-hostname}.${var.domain}"
  fallback_pool_id = "${ibm_cis_origin_pool.vpc-a-lbaas-web.id}"
  default_pool_ids = ["${ibm_cis_origin_pool.vpc-a-lbaas-web.id}"]
  session_affinity = "cookie"
  description      = "Global Loadbalancer for ${var.glb-hostname}.${var.domain}"
  proxied          = true
}
