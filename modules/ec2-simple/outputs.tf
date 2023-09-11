output "id" {
  description = "The ID of the instance"
  value = try(
    aws_instance.this[0].id,
    null,
  )
}

output "arn" {
  description = "The ARN of the instance"
  value = try(
    aws_instance.this[0].arn,
    null,
  )
}

output "instance_state" {
  description = "The state of the instance"
  value = try(
    aws_instance.this[0].instance_state,
    null,
  )
}

output "password_data" {
  description = "Base-64 encoded encrypted password data for the instance"
  value = try(
    aws_instance.this[0].password_data,
    null,
  )
}

output "private_dns" {
  description = "The private DNS name assigned to the instance"
  value = try(
    aws_instance.this[0].private_dns,
    null,
  )
}

output "public_dns" {
  description = "The public DNS name assigned to the instance"
  value = try(
    aws_instance.this[0].public_dns,
    null,
  )
}

output "public_ip" {
  description = "The public IP address assigned to the instance, if applicable"
  value = try(
    aws_instance.this[0].public_ip,
    null,
  )
}

output "private_ip" {
  description = "The private IP address assigned to the instance"
  value = try(
    aws_instance.this[0].private_ip,
    null,
  )
}

output "ami" {
  description = "AMI ID that was used to create the instance"
  value = try(
    aws_instance.this[0].ami,
    null,
  )
}

output "availability_zone" {
  description = "The availability zone of the created instance"
  value = try(
    aws_instance.this[0].availability_zone,
    null,
  )
}