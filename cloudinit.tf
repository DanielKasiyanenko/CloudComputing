provider "proxmox" {
  pm_api_url = "https://192.168.76.20:8006/api2/json"
  pm_user    = "root@pam"
  pm_password = "XXXXX"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "cloudinit-talos-node" {
    target_node = "proxmox"
    desc = "Cloudinit Ubuntu"
    count = 1  
    onboot = true
    clone = "23.04-non-KVM"
    agent = 0
    os_type = "cloud-init"
    cores = 2
    sockets = 2
    numa = true
    vcpus = 0
    cpu = "host"
    memory = 4096
    name = "talos-node-01"
    cloudinit_cdrom_storage = "nvme"
    scsihw = "virtio-scsi-single"
    bootdisk = "scsi0"

    disks {
        scsi {
            scsi0 {
                disk {
                    storage = "nvme"
                    size = 12
                }
            }
        }
    }

    ipconfig0 = "ip=192.168.76.101/24,gw=192.168.76.1"
    ciuser = "ubuntu"
    nameserver = "192.168.76.21"
    sshkeys = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKfn+iQH2HnuXIa67zBzEUfrg4mfH9meVy/CWuzODj2G8K6xWXUx9YTzchqr2xjXxLDQcDC+RDwVY0cAiWZ/OrXd6H8QEkSSEuAc/exWvVmLQGr3e41Ff9BUslqayGEPwFP6fndCWK8FthiwYUUGM5sODLZl4DFcqtgICRzuEcNcRQZFpq/h5NzCYmdPWMrAuQLfF/fW2VRD5gnqaDkgW+pdw+1umut5ey6C4fCPA9/7vkSesDc2RafA3gRkBmO1IxBVhzgl7OLl84iFnl1dEUcrdSCoaRL2AHC36EDvhF5M/Zlv5hebITzc9f7cF88k/rsx2ZnlSOeIHD31/lRhWL root@proxmox-dell
EOF
}