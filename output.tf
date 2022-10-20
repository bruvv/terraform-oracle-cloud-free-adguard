# Output the private and public IPs of the instance

# output "instance_private_ips" {
#   value = [oci_core_instance.free_instance0.private_ip]
# }

output "instance_public_ip" {
  #   value = [oci_core_instance.free_instance0.public_ip]
  value = "ssh ubuntu@${data.oci_core_vnic.app_vnic.public_ip_address}"
}
output "instance_private_ip" {
  #   value = [oci_core_instance.free_instance0.public_ip]
  value = data.oci_core_vnic.app_vnic.private_ip_address
}

# output "lb_public_ip" {
#   value = [oci_load_balancer_load_balancer.free_load_balancer.ip_address_details]
# }

# Output the boot volume IDs of the instance
# output "boot_volume_ids" {
#   value = [oci_core_instance.test_instance.*.boot_volume_id]
# }

# Output all the devices for all instances
# output "instance_devices" {
#   value = [data.oci_core_instance_devices.test_instance_devices.*.devices]
# }

# Output the chap secret information for ISCSI volume attachments. This can be used to output
# CHAP information for ISCSI volume attachments that have "use_chap" set to true.
#output "IscsiVolumeAttachmentChapUsernames" {
#  value = [oci_core_volume_attachment.test_block_attach.*.chap_username]
#}
#
#output "IscsiVolumeAttachmentChapSecrets" {
#  value = [oci_core_volume_attachment.test_block_attach.*.chap_secret]
#}

# output "silver_policy_id" {
#   value = data.oci_core_volume_backup_policies.test_predefined_volume_backup_policies.volume_backup_policies[0].id
# }

/*
output "attachment_instance_id" {
  value = data.oci_core_boot_volume_attachments.test_boot_volume_attachments.*.instance_id
}
*/


# output "app" {
#   value = "http://${data.oci_core_vnic.app_vnic.public_ip_address}"
# }