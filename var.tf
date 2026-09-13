variable "aws_region" {
  default = "ap-south-1"
}

variable "key_name" {
  default = "ansible"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "security_group" {
  default = "ansible-grp"
}

variable "tag_name" {
  default = "my-ec2-instance"
}

variable "ami_id" {
  description = "Ubuntu AMI in ap-south-1"
  default     = "YOUR_VALID_AMI_ID"
}
