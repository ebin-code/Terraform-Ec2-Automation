# 🚀 Terraform AWS EC2 Infrastructure Automation

This project demonstrates how to use **Terraform** to automate the provisioning of AWS infrastructure using **Infrastructure as Code (IaC)**.

Instead of manually creating AWS resources through the AWS Management Console, Terraform is used to create and manage the complete infrastructure in a consistent, repeatable, and automated way.

---

## 🏗️ Architecture

```text
                         AWS Cloud
                            │
                            ▼
                    ┌───────────────┐
                    │      VPC      │
                    │ 172.16.0.0/16 │
                    └───────┬───────┘
                            │
                            ▼
                  ┌──────────────────┐
                  │  Public Subnet   │
                  │ 172.16.1.0/24    │
                  └────────┬─────────┘
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
       Internet Gateway           Route Table
              │                         │
              └────────────┬────────────┘
                           │
                           ▼
                    ┌───────────────┐
                    │ Security Group│
                    │ SSH - 22      │
                    │ Jenkins - 8080│
                    └───────┬───────┘
                            │
                            ▼
                    ┌───────────────┐
                    │  EC2 Instance │
                    │   t2.micro    │
                    └───────────────┘
```

---

## 🛠️ Technologies Used

* **Terraform**
* **AWS EC2**
* **AWS VPC**
* **AWS Subnet**
* **AWS Internet Gateway**
* **AWS Route Table**
* **AWS Security Group**
* **Ubuntu Linux**
* **Infrastructure as Code (IaC)**

---

# 📋 Prerequisites

Before starting, make sure you have:

* AWS account
* AWS CLI configured
* Ubuntu/Linux system
* Terraform installed
* AWS EC2 Key Pair
* Valid Ubuntu AMI ID

---

# 🔧 Install Terraform on Ubuntu

## 1. Create Terraform working directory

```bash
sudo mkdir -p /opt/terraform
cd /opt/terraform
```

## 2. Download Terraform

Example using Terraform 1.5.4:

```bash
sudo wget https://releases.hashicorp.com/terraform/1.5.4/terraform_1.5.4_linux_amd64.zip
```

> **Note:** Terraform 1.5.4 is an older release. For a new environment, use a currently supported Terraform version.

## 3. Install unzip

```bash
sudo apt update
sudo apt install unzip -y
```

## 4. Extract Terraform

```bash
sudo unzip terraform_1.5.4_linux_amd64.zip
```

## 5. Move Terraform binary

```bash
sudo mv /opt/terraform/terraform /usr/local/bin/
```

## 6. Verify installation

```bash
terraform version
```

Example:

```text
Terraform v1.5.4
on linux_amd64
```

Check the Terraform location:

```bash
which terraform
```

Expected:

```text
/usr/local/bin/terraform
```

---

# 📁 Project Structure

```text
terraform-aws-ec2/
│
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
└── README.md
```

---

# ⚙️ Terraform Configuration

## `variables.tf`

```hcl
variable "aws_region" {
  default = "ap-south-1"
}

variable "key_name" {
  default = "ansible"
}

variable "instance_type" {
  default = "t3.micro"
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
```

> Replace `YOUR_VALID_AMI_ID` with a valid Ubuntu AMI available in the `ap-south-1` region.

---

# 🏗️ `main.tf`

```hcl
provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

# Create public subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags = {
    Name = "jenkins-public-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "jenkins-igw"
  }
}

# Create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "jenkins-public-route-table"
  }
}

# Associate route table with subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Create security group
resource "aws_security_group" "jenkins_sg_2022" {
  name        = var.security_group
  description = "Security group for Jenkins"
  vpc_id      = aws_vpc.main.id

  # Jenkins
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

# Create EC2 instance
resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  key_name      = var.key_name
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  vpc_security_group_ids = [
    aws_security_group.jenkins_sg_2022.id
  ]

  tags = {
    Name = var.tag_name
  }
}
```

---

# 🚀 Terraform Deployment

Navigate to your Terraform project directory:

```bash
cd terraform-aws-ec2
```

## 1. Initialize Terraform

```bash
terraform init
```

Terraform downloads the required AWS provider and initializes the working directory.

---

## 2. Format Terraform configuration

```bash
terraform fmt
```

---

## 3. Validate configuration

```bash
terraform validate
```

Expected output:

```text
Success! The configuration is valid.
```

---

## 4. Create execution plan

```bash
terraform plan
```

Review the resources Terraform plans to create.

---

## 5. Create AWS infrastructure

```bash
terraform apply
```

Type:

```text
yes
```

Terraform will create:

```text
VPC
 ↓
Public Subnet
 ↓
Internet Gateway
 ↓
Route Table
 ↓
Security Group
 ↓
EC2 Instance
```

---

# 🔍 Verify AWS Resources

After Terraform completes, verify the resources from AWS Console or AWS CLI.

Check EC2:

```bash
aws ec2 describe-instances
```

Check VPC:

```bash
aws ec2 describe-vpcs
```

Check subnets:

```bash
aws ec2 describe-subnets
```

Check security groups:

```bash
aws ec2 describe-security-groups
```

---

# 🔐 Connect to EC2

Once the instance is running, obtain its public IP address.

Then connect using SSH:

```bash
ssh -i your-key.pem ubuntu@<PUBLIC-IP>
```

Example:

```bash
ssh -i ansible.pem ubuntu@<PUBLIC-IP>
```

---

# 🧹 Destroy Infrastructure

When the lab is complete, destroy the resources to avoid unnecessary AWS charges:

```bash
terraform destroy
```

Type:

```text
yes
```

Terraform will remove the infrastructure it created.

---

# 🔄 Terraform Workflow

```text
Write Terraform Code
        │
        ▼
 terraform init
        │
        ▼
terraform fmt
        │
        ▼
terraform validate
        │
        ▼
 terraform plan
        │
        ▼
terraform apply
        │
        ▼
 AWS Infrastructure
        │
        ▼
terraform destroy
```

---

# 🎯 What I Learned

Through this project, I practiced:

* Infrastructure as Code using Terraform
* AWS provider configuration
* Terraform variables
* AWS VPC creation
* Public subnet configuration
* Internet Gateway configuration
* Route table configuration
* Security Group configuration
* EC2 provisioning
* Terraform initialization
* Terraform validation
* Terraform planning
* Terraform apply and destroy
* Automating AWS infrastructure without using the AWS Console

---

# 🚀 Future Improvements

This project can be extended by adding:

* Terraform `outputs.tf`
* Terraform `terraform.tfvars`
* IAM roles
* NAT Gateway
* Private subnet
* Multiple availability zones
* Application Load Balancer
* Auto Scaling Group
* Remote Terraform state using S3
* DynamoDB state locking
* Terraform modules
* Jenkins CI/CD pipeline
* AWS EKS provisioning
* Terraform + Ansible integration

---

# 👨‍💻 DevOps Learning Journey

This project is part of my hands-on learning journey in:

```text
Linux
  ↓
Git & GitHub
  ↓
AWS
  ↓
Ansible
  ↓
Terraform
  ↓
Docker
  ↓
Jenkins
  ↓
SonarQube
  ↓
Kubernetes
  ↓
Prometheus & Grafana
  ↓
CI/CD & Cloud DevOps
```

---

## ⭐ Project Highlights

**Infrastructure:** AWS Cloud
**Automation:** Terraform
**Compute:** EC2
**Networking:** VPC, Subnet, Internet Gateway, Route Table
**Security:** Security Group
**Operating System:** Ubuntu Linux
**Region:** AWS `ap-south-1`
**Instance:** `t2.micro`

---

## 📌 Important Security Note

For production environments, avoid opening SSH and Jenkins to the entire internet:

```hcl
cidr_blocks = ["0.0.0.0/0"]
```

Instead, restrict access to trusted IP addresses or use a VPN/bastion architecture.

Also, do **not** commit AWS credentials, private keys, or Terraform state files containing sensitive information to GitHub.

Consider adding:

```text
.terraform/
*.tfstate
*.tfstate.*
*.pem
terraform.tfvars
```

to your `.gitignore` where appropriate.
