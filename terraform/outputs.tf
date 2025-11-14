output "ec2_public_ip" {
  value = aws_instance.app.public_ip
}

output "grafana_url" {
  value = "http://${aws_instance.app.public_ip}:3000"
}

output "prometheus_url" {
  value = "http://${aws_instance.app.public_ip}:9090"
}

output "cadvisor_url" {
  value = "http://${aws_instance.app.public_ip}:8081"
}

output "node_exporter_url" {
  value = "http://${aws_instance.app.public_ip}:9100/metrics"
}

output "nagios_url" {
  value = "http://${aws_instance.app.public_ip}/nagios"
}
