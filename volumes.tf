resource "libvirt_pool" "data-pool" {
  name = "${var.project-prefix}-pool"
  type = "dir"
  path = "${var.data-pool-dir}/${var.project-prefix}"
}

resource "libvirt_volume" "instance-base-image" {
  name   = "instance-base-image.qcow2"
  source = var.base-image-path
  pool   = libvirt_pool.data-pool.name
}