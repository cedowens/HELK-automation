terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}

variable "do_token" {}
variable "pvt_key" {}

provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_ssh_key" "keyname" {
  name = "keyname"
}

resource "digitalocean_droplet" "myc2-1" {
    image = "ubuntu-20-04-x64"
    name = "myc2-1"
    region = "sfo3"
    size = "s-4vcpu-8gb-amd"
    private_networking = true
    ssh_keys = [
      data.digitalocean_ssh_key.keyname.id
    ]

connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key) 
    timeout = "2m"
  }

provisioner "file" {
	source = "0098-all-filter.conf"
	destination = "/root/0098-all-filter.conf"
}

provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y && sudo apt-get upgrade -y",
      "sudo git clone https://github.com/Cyb3rWard0g/HELK",
      "sudo cd HELK/dockersudo && sudo chmod +x helk_install.sh",
      "sudo mv /root/0098-all-filter.conf /root/HELK/docker/helk-logstash/pipeline/0098-all-filter.conf"
    ]
  }
}


resource "digitalocean_firewall" "myc2-1" {
        name = "myc2rule"
        droplet_ids = [digitalocean_droplet.myc2-1.id]

	inbound_rule {
		protocol	= "tcp"
		port_range 	= "22"
		source_addresses = ["127.0.0.1"]
	}
	
	inbound_rule {
		protocol	= "tcp"
		port_range	= "all"
		source_addresses = ["10.0.0.0"]
	}
	
	inbound_rule {
		protocol	= "udp"
		port_range 	= "5044"
		source_addresses = ["10.0.0.0"]
	}

	outbound_rule {
		protocol	= "tcp"
		port_range	= "all"
		destination_addresses = ["0.0.0.0/0", "::/0"]
	}

}
