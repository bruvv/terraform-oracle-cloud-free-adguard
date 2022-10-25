resource "oci_core_instance" "free_instance0" {
  availability_domain  = data.oci_identity_availability_domain.ad.name
  compartment_id       = var.compartment_ocid
  display_name         = var.display_name
  shape                = var.instance_shape
  preserve_boot_volume = false

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    hostname_label   = var.display_name
  }

  source_details {
    source_type = "image"
    source_id   = var.flex_instance_image_ocid[var.region]
    # Apply this to set the size of the boot volume that is created for this instance.
    # Otherwise, the default boot volume size of the image is used.
    # This should only be specified when source_type is set to "image".
    #boot_volume_size_in_gbs = "60"
  }
  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}


data "oci_core_vnic_attachments" "app_vnics" {
  compartment_id      = var.compartment_ocid
  availability_domain = data.oci_identity_availability_domain.ad.name
  instance_id         = oci_core_instance.free_instance0.id
}

data "oci_core_vnic" "app_vnic" {
  vnic_id = data.oci_core_vnic_attachments.app_vnics.vnic_attachments[0]["vnic_id"]
}

resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.free_instance0]
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "10m"
      host        = data.oci_core_vnic.app_vnic.public_ip_address
      user        = "ubuntu"
      private_key = file(var.ssh_private_key)
    }

    inline = [
      # "ENV DEBIAN_FRONTEND=noninteractive",
      "ssh-keyscan -H github.com >> ~/.ssh/known_hosts",
      "sudo apt -y remove needrestart",
      "sudo apt-add-repository -y ppa:ansible/ansible",
      "sudo apt update",
      "sudo apt full-upgrade -yqq",
      "sudo apt install -yqq software-properties-common gnupg-agent ca-certificates apt-transport-https unzip ansible git curl wget",
      "sudo apt autoremove -yqq",
      "git clone https://github.com/bruvv/ansible-adguard-unbound.git /home/ubuntu/adguard",
      "ansible-galaxy install -r /home/ubuntu/adguard/requirements/ansible-requirements.yml",
      # "ansible-playbook --connection=local --inventory 127.0.0.1, /home/ubuntu/adguard/configure_adguard.yml -e "hostname=adfree.nielsvoorn.nl emailaddress=nvoorn@gmail.com"",
      "echo Done!",
      "sudo /usr/sbin/shutdown -r 1"
    ]
  }
}
