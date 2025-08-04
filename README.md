# Terraform EC2 Web Server

## Description
This Terraform project provisions a public facing EC2 instance on AWS, installs Apache automatically using `user_data`, and serves a sample HTML page

This project provisions:
- A VPC with subnet, IGW, and routing
- A security group for HTTP + SSH
- An EC2 instance that installs Apache
- A basic webpage served on port 80
- Output: EC2 public IP

## Usage

```bash
terraform init
terraform validate
terraform plan
terraform apply
