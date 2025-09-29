/*
output "public_ip" {
  value = aws_eip.web.public_ip
}
*/
output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}

output "server_id" {
  value = aws_instance.web.id
}

output "securitygroup_id" {
  value = aws_security_group.web.id
}