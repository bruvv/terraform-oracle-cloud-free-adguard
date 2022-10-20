/* Instances */

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

  #   source_details {
  #     source_type = "image"
  #     source_id   = lookup(data.oci_core_images.images.images[0], "id")
  #   }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
    # ssh_authorized_keys = (var.ssh_public_key != "") ? var.ssh_public_key : tls_private_key.compute_ssh_key.public_key_openssh
  }
  #   provisioner "remote-exec" {
  #     inline = ["sudo apt update", "sudo apt full-upgrade", "sudo apt install python3 -y", "echo Done!"]

  # connection {
  #   host        = data.oci_core_vnic.app_vnic.private_ip_address
  #   type        = "ssh"
  #   user        = "root"
  #   private_key = file(var.pvt_key)
  # }
  #   }

  #   provisioner "local-exec" {
  #     command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${data.oci_core_vnic.app_vnic.private_ip_address},' --private-key ${var.pvt_key} -e 'pub_key=${var.pub_key}' apache-install.yml"
  #   }
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

# first update apt
resource "null_resource" "remote-exec" {
  depends_on = [oci_core_instance.free_instance0]

  # do stuff
  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "5m"
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
      # "ansible-playbook --connection=local --inventory 127.0.0.1,  /home/ubuntu/adguard/configure_adguard.yml -e "hostname=adguard.website.com emailaddress=here@email.com"",
      "echo Done!",
      "sudo /usr/sbin/shutdown -r 1"
    ]
  }
}
# # See https://docs.oracle.com/iaas/images/
# data "oci_core_images" "images" {
#   compartment_id           = var.compartment_ocid
#   operating_system         = "Oracle Linux"
#   operating_system_version = "8"
#   shape                    = var.instance_shape
#   sort_by                  = "TIMECREATED"
#   sort_order               = "DESC"
# }


# data "oci_database_autonomous_databases" "autonomous_databases" {
#   #Required
#   compartment_id = var.compartment_ocid

#   #Optional
#   db_workload  = "OLTP"
#   is_free_tier = "true"
# }

# resource "oci_database_autonomous_database" "autonomous_database" {
#   #Required
#   admin_password           = "alwaysfree1"
#   compartment_id           = var.compartment_ocid
#   cpu_core_count           = "1"
#   data_storage_size_in_tbs = "1"
#   db_name                  = "adb"

#   #Optional
#   db_workload  = "OLTP"
#   display_name = "autonomous_database"

#   freeform_tags = {
#     "Department" = "Finance"
#   }

#   is_auto_scaling_enabled = "false"
#   license_model           = "LICENSE_INCLUDED"
#   is_free_tier            = "true"
# }

