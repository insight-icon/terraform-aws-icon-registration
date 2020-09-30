output "public_ip" {
  value = var.public_ip == "" ? join("", aws_eip.this.*.public_ip) : var.public_ip
}

output "details_endpoint" {
  value = local.static_endpoint
}

output "details_content" {
  value = module.registration.details_content
}

output "registration_json" {
  value = module.registration.registration_json
}

output "network_name" {
  value = var.network_name
}

output "operator_wallet_path" {
  value = module.registration.operator_wallet_path
}

output "operator_password" {
  value = module.registration.operator_password
  //  sensitive = true
}
