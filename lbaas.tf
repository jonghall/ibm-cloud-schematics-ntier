#----------------------------------------------------------
# Create WebAppTier Load Balancer in zone 1 & Zone 2 of VPC
#----------------------------------------------------------

resource "ibm_is_lb" "vpc-a-web-lb" {
  name = "${var.vpc-a-name}-web-lb01"
  subnets = ["${ibm_is_subnet.web-subnet-vpc-a-zone1.id}", "${ibm_is_subnet.web-subnet-vpc-a-zone2.id}"]
}

resource "ibm_is_lb_listener" "webapptier-lb-listener" {
  lb           = "${ibm_is_lb.vpc-a-web-lb.id}"
  default_pool = "${element(split("/", ibm_is_lb_pool.webapptier-lb-pool.id),1)}"
  port         = "80"
  protocol     = "http"
}

resource "ibm_is_lb_pool" "webapptier-lb-pool" {
  lb                 = "${ibm_is_lb.vpc-a-web-lb.id}"
  name               = "${var.vpc-a-name}-webapptier-lb-pool1"
  protocol           = "http"
  algorithm          = "${var.web-lb-algorithm}"
  health_delay       = "5"
  health_retries     = "2"
  health_timeout     = "2"
  health_type        = "http"
  health_monitor_url = "/"
}

#---------------------------------------------------------
# Add web from zone 1 and zone 2 to pool
#---------------------------------------------------------
resource "ibm_is_lb_pool_member" "vpc-a-webapp-lb-pool-member-zone-a" {
  count          = "${ibm_is_instance.vpc-a-webserver-zone-1.count}"
  lb             = "${ibm_is_lb.vpc-a-web-lb.id}"
  pool           = "${element(split("/", ibm_is_lb_pool.webapptier-lb-pool.id),1)}"
  port           = "80"
  target_address = "${element(ibm_is_instance.vpc-a-webserver-zone-1.*.primary_network_interface.0.primary_ipv4_address,count.index)}"
}

resource "ibm_is_lb_pool_member" "vpc-a-webapp-lb-pool-member-zone-b" {
  count          = "${ibm_is_instance.vpc-a-webserver-zone-2.count}"
  lb             = "${ibm_is_lb.vpc-a-web-lb.id}"
  pool           = "${element(split("/", ibm_is_lb_pool.webapptier-lb-pool.id),1)}"
  port           = "80"
  target_address = "${element(ibm_is_instance.vpc-a-webserver-zone-2.*.primary_network_interface.0.primary_ipv4_address,count.index)}"
}
