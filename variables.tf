variable "display_name" {
  default = "adguard"
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex" # ARM
  # default = "VM.Standard.E2.1.Micro" # X64
}

variable "instance_ocpus" {
  default = 4 # ARM = 4, AMD = 1
}

variable "instance_shape_config_memory_in_gbs" {
  default = 23 #ARM = 24, AMD = 1
}

variable "tenancy_ocid" { # https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
  default = "ocid1.tenancy.oc1..CHANGETHIS"
}

variable "user_ocid" { # https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five
  default = "ocid1.user.oc1..CHANGETHIS"
}

variable "fingerprint" { # https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#four
  default = "11:22:33.........."
}

variable "private_key_path" {
  default = "/Users/username/.ssh/privatekey.pem"
}

variable "region" {
  default = "eu-amsterdam-1"
}

variable "compartment_ocid" {
  default = "ocid1.compartment.oc1..CHANGETHIS"
}

variable "ssh_public_key" {
  default   = "/Users/username/.ssh/id_rsa.pub"
  sensitive = true
}

variable "ssh_private_key" {
  default   = "/Users/username/.ssh/id_rsa"
  sensitive = true
}

variable "flex_instance_image_ocid" {
  # See https://docs.us-phoenix-1.oraclecloud.com/images/
  type = map(string)
  default = {
    # eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaadw6rseqgm33aytx35duudrm6edzp5lhhvutmkxzt45kn4szreraa" # ubuntu
    eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaa526auzq66wvw4m2f4l2jhvlluvjc6njpnzqjtuiq23ghb3u5ymoa" # oracle 9
  }
}
