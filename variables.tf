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

variable "tenancy_ocid" {
  default = "ocid1.tenancy.oc1..CHANGETHIS"
}

variable "user_ocid" {
  default = "ocid1.user.oc1..CHANGETHIS"
}

variable "fingerprint" {
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
    eu-amsterdam-1 = "ocid1.image.oc1.eu-amsterdam-1.aaaaaaaadw6rseqgm33aytx35duudrm6edzp5lhhvutmkxzt45kn4szreraa"
    # us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaa6hooptnlbfwr5lwemqjbu3uqidntrlhnt45yihfj222zahe7p3wq"
    # us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaa6tp7lhyrcokdtf7vrbmxyp2pctgg4uxvt4jz4vc47qoc2ec4anha"
    # eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaadvi77prh3vjijhwe5xbd6kjg3n5ndxjcpod6om6qaiqeu3csof7a"
    # uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaw5gvriwzjhzt2tnylrfnpanz5ndztyrv3zpwhlzxdbkqsjfkwxaq"
  }
}