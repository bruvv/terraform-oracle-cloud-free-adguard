# [DEFAULT]
# user=ocid1.user.oc1..aaaaaaaat2bnwgnhxxizf4oj6d55fqsjshiqieio377jni3v5bculllcwv4a
# fingerprint=c1:e7:aa:f2:9c:39:d6:fd:f4:db:90:1a:02:0d:3a:5a
# tenancy=ocid1.tenancy.oc1..aaaaaaaauenn7ge7uzbipso22xrtnzjzqhja437yfse5cltcs2wcv3xa36cq
# region=eu-amsterdam-1
# key_file=<path to your private keyfile> # TODO


terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  private_key_path = var.private_key_path
  fingerprint      = var.fingerprint
  region           = var.region
}
