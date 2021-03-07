resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "playground-1"
  region = "nyc3"
  size   = "s-1vcpu-1gb"

  ssh_keys  = data.digitalocean_ssh_keys.keys.ssh_keys.*.fingerprint
  user_data = templatefile("${path.module}/templates/cloud_init.sh", {})
}

output "droplet_ip_addresses" {
  value = digitalocean_droplet.web.ipv4_address
}

data "digitalocean_ssh_keys" "keys" {
  sort {
    key       = "name"
    direction = "asc"
  }
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.5.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~>2.2.0"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

variable "do_token" {
  type = string
}
