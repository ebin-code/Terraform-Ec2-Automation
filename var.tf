variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
}

variable "key_name" {
  description = "SSH key pair name used to connect to the EC2 instance."
  type        = string
  default     = "mySep22Key"
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "security_group" {
  description = "Name of the security group."
  type        = string
  default     = "jenkins-sgroup-dec-2021"
}

variable "tag_name" {
  description = "Name tag for the EC2 instance."
  type        = string
  default     = "my-ec2-instance"
}

variable "ami_id" {
  description = "AMI ID for the Ubuntu EC2 instance."
  type        = string
  default     = "ami-01a00762f46d584a1"
}

# S3 bucket versioning
variable "versioning" {
  description = "Enable versioning for the S3 bucket."
  type        = bool
  default     = true
}

# S3 bucket prefix
variable "bucket_prefix" {
  description = "Prefix used to generate a unique S3 bucket name."
  type        = string
  default     = "my-s3bucket-"
}

# S3 bucket tags
variable "tags" {
  description = "Tags to assign to the S3 bucket."
  type        = map(string)

  default = {
    environment = "DEV"
    terraform   = "true"
  }
}
