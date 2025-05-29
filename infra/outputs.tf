output "static_ip" {
  description = "The Elastic IP assigned to the EC2 instance"
  value       = aws_eip.static_ip.public_ip
}
