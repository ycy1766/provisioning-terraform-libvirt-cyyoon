resource "libvirt_network" "internal-network-1" {
  name      = "${var.project-prefix}-network1"
  mode      = "none"
  mtu       = 9000
  bridge    = "${var.project-prefix}-virbr1"
  addresses = ["${var.internal-network-1-network-addr}.0/24"]
}

resource "libvirt_network" "internal-network-2" {
  name      = "${var.project-prefix}-network2"
  mode      = "none"
  mtu       = 9000
  bridge    = "${var.project-prefix}-virbr2"
  addresses = ["${var.internal-network-2-network-addr}.0/24"]
}

resource "libvirt_network" "internal-network-3" {
  name      = "${var.project-prefix}-network3"
  mode      = "none"
  mtu       = 9000
  bridge    = "${var.project-prefix}-virbr3"
  addresses = ["${var.internal-network-3-network-addr}.0/24"]
}

resource "libvirt_network" "external-network-1" {
  name      = "${var.project-prefix}-network4"
  mode      = "nat"
  bridge    = "${var.project-prefix}-virbr4"
  addresses = ["${var.external-network-1-network-addr}.0/24"]
  dns {
    enabled = true
  }
}


