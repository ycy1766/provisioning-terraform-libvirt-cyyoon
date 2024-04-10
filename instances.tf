locals {
  combined_instances = merge(var.instances-type-001, var.instances-type-002)
}

locals {
  project_prefix_hash = sha1(var.project-prefix)
  mac_prefix          = substr(local.project_prefix_hash, 0, 4)
}

data "template_file" "cloudinit-kvm-instance" {
  for_each = local.combined_instances
  template = file("${path.module}/templates/cloud-init.yaml")
  vars = {
    # external-network-1-network-addr = var.external-network-1-network-addr
    ssh_username    = var.ssh_username
    ssh_public_key  = join("\n", formatlist("    - %s", var.ssh-public-key))
    ssh_private_key = var.ssh-private-key
  }
}

resource "libvirt_cloudinit_disk" "commoninit" {
  for_each  = local.combined_instances
  name      = "${var.project-prefix}-${each.key}-commoninit.iso"
  user_data = data.template_file.cloudinit-kvm-instance["${each.key}"].rendered
  pool      = libvirt_pool.data-pool.name
}

resource "libvirt_volume" "os-volumes" {
  for_each       = local.combined_instances
  name           = "${var.project-prefix}-${each.key}-os-volumme.qcow2"
  base_volume_id = libvirt_volume.instance-base-image.id
  pool           = libvirt_pool.data-pool.name
  size           = 50 * 1024 * 1024 * 1024 ## 50G
}
resource "libvirt_volume" "additional-volumes-001" {
  for_each = var.instances-type-001
  name     = "${each.key}-additional-volume-001"
  size     = 30 * 1024 * 1024 * 1024 ## 30G
  pool     = libvirt_pool.data-pool.name
}

resource "libvirt_volume" "additional-volumes-002" {
  for_each = var.instances-type-001
  name     = "${each.key}-additional-volume-002"
  size     = 30 * 1024 * 1024 * 1024 ## 30G
  pool     = libvirt_pool.data-pool.name
}

resource "libvirt_domain" "test-instance" {
  for_each = local.combined_instances
  name     = "${var.project-prefix}-${each.key}"
  memory   = each.value.memory
  vcpu     = each.value.vcpu

  cpu {
    mode = "host-passthrough"
  }

  cloudinit = libvirt_cloudinit_disk.commoninit["${each.key}"].id

  disk {
    volume_id = libvirt_volume.os-volumes["${each.key}"].id
  }

  dynamic "disk" {
    for_each = contains(keys(var.instances-type-001), each.key) ? [1] : []
    content {
      volume_id = libvirt_volume.additional-volumes-001[each.key].id
    }
  }
  dynamic "disk" {
    for_each = contains(keys(var.instances-type-001), each.key) ? [1] : []
    content {
      volume_id = libvirt_volume.additional-volumes-002[each.key].id
    }
  }

  network_interface {
    network_id     = libvirt_network.external-network-1.id
    hostname       = "${var.project-prefix}-${each.key}"
    addresses      = ["${var.external-network-1-network-addr}.${each.value.ip}"]
    mac            = "aa:bb:cc:${substr(local.mac_prefix, 0, 2)}:${substr(local.mac_prefix, 2, 2)}:${each.value.ip}"
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.internal-network-1.id
    addresses      = ["${var.internal-network-1-network-addr}.${each.value.ip}"]
    mac            = "aa:bb:cc:${substr(local.mac_prefix, 0, 2)}:${substr(local.mac_prefix, 2, 2)}:${each.value.ip}"
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.internal-network-2.id
    addresses      = ["${var.internal-network-2-network-addr}.${each.value.ip}"]
    mac            = "aa:bb:cc:${substr(local.mac_prefix, 0, 2)}:${substr(local.mac_prefix, 2, 2)}:${each.value.ip}"
    wait_for_lease = true
  }

  network_interface {
    network_id     = libvirt_network.internal-network-3.id
    addresses      = ["${var.internal-network-3-network-addr}.${each.value.ip}"]
    mac            = "aa:bb:cc:${substr(local.mac_prefix, 0, 2)}:${substr(local.mac_prefix, 2, 2)}:${each.value.ip}"
    wait_for_lease = true
  }

  graphics {
    type        = "spice"
    listen_type = "address"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("/root/.ssh/id_rsa")
    host        = "${var.external-network-1-network-addr}.${each.value.ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'test cycy' > /tmp/test.txt"
    ]
  }
}