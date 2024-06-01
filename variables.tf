
variable "project-prefix" {
  description = "Project Prefix"
  default     = "cy-a7"
}

// Volume Pool
variable "data-pool-dir" {
  default = "/data"
}

variable "base-image-path" {
 // default     = "/data/images/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  default     = "/data/images/jammy-server-cloudimg-amd64.img"
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
    "test-090" = { ip = "90", memory = "8000", vcpu = 4}
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
    "test-091" = { ip = "91", memory = "6000", vcpu = 3 }
    "test-092" = { ip = "92", memory = "6000", vcpu = 3 }
    "test-093" = { ip = "93", memory = "6000", vcpu = 3 }
    "test-094" = { ip = "94", memory = "6000", vcpu = 3 }
    "test-095" = { ip = "95", memory = "6000", vcpu = 3 }
    "test-096" = { ip = "96", memory = "6000", vcpu = 3 }
  }
}

variable "ssh_username" {
  default     = "cyyoon"
  description = "Default Instance User name"
}

variable "ssh-public-key" {
  type = list(string)
  default = [
    "ssh-rsa #######"
  ]
}

variable "ssh-private-key" {
  default = <<EOF
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC#####
    -----END OPENSSH PRIVATE KEY-----
EOF
}
