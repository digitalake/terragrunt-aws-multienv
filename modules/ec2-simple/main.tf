resource "aws_instance" "this" {

    count = var.create ? 1 : 0
    ami = var.ami
    instance_type = var.instance_type
    
    user_data                   = var.user_data
    user_data_base64            = var.user_data_base64
    user_data_replace_on_change = var.user_data_replace_on_change

    availability_zone = var.availability_zone
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.vpc_security_group_ids

    key_name = var.key_name
    monitoring = var.monitoring
    get_password_data = var.get_password_data

    associate_public_ip_address = var.associate_public_ip_address
    private_ip = var.private_ip
    ebs_optimized = var.ebs_optimized

    tags = merge({ "Name" = var.name}, var.instance_tags)

}   