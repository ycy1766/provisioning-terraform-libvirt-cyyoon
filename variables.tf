
variable "project-prefix" {
  description = "Project Prefix"
  default     = "cy-a7"
}

// Volume Pool
variable "data-pool-dir" {
  default = "/data"
}

variable "base-image-path" {
  default     = "/data/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  description = "Path/URL for Cloud Qcow2 Image"
}

// Netowk 
variable "internal-network-1-network-addr" {
  default     = "10.91.1"
  description = "NONE Mode Network"
}

variable "internal-network-2-network-addr" {
  default     = "10.92.1"
  description = "NONE Mode Network"
}

variable "internal-network-3-network-addr" {
  default     = "10.93.1"
  description = "NONE Mode Network"
}

variable "external-network-1-network-addr" {
  default     = "172.16.12"
  description = "NAT Mode Network"
}

// Type 1 Instance: "Additional volumes are mounted for configurations like SDS, such as Ceph."
variable "instances-type-001" {
  description = "Type 1 instances configuration including host IP, memory, and vCPU."
  type = map(object({
    ip     = string
    memory = string
    vcpu   = number
  }))
  default = {
    "test-011" = { ip = "11", memory = "2048", vcpu = 2 }
    "test-012" = { ip = "12", memory = "2048", vcpu = 2 }
  }
}

// Type 2 Instances: "Only OS volumes"
variable "instances-type-002" {
  description = "Type 2 instances configuration including host IP, memory, and vCPU."
  type = map(object({
    ip     = string
    memory = string
    vcpu   = number
  }))
  default = {
    "test-031" = { ip = "31", memory = "4096", vcpu = 4 }
    "test-032" = { ip = "32", memory = "4096", vcpu = 4 }
  }
}

variable "ssh_username" {
  default     = "cyyoon"
  description = "Default Instance User name"
}

variable "ssh-public-key" {
  type = list(string)
  default = [
    "ssh-rsa EDITME root@EDITME"
  ]
}

variable "ssh-private-key" {
  default = <<EOF
    -----BEGIN RSA PRIVATE KEY-----
    EDITMEEDITMEEDITMEEDITMEEDITMEEDITMEEDITMEEDITMEEDITMEEDITMEEDITME
    -----END RSA PRIVATE KEY-----
EOF
}
