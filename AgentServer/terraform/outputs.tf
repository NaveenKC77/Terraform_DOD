output "bastion_host_url" {
  value = aws_instance.bastion_host.public_ip
}

output "agent_server_ip" {
  value = aws_instance.agent_server.private_ip
}


