# Terraform AWS EC2 Web Server

## Project Overview

This project provisions a fully functional web server on AWS using **Terraform**, adhering to Infrastructure-as-Code (IaC) principles. It automates the deployment of a public EC2 instance running Apache, served from a custom VPC with properly configured networking, security, and provisioning.

> Ideal for DevOps learners building AWS, networking, and Terraform skills  

---

## Features

-  **Custom AWS VPC**: With a public subnet, route table, and Internet Gateway
-  **Security Group**: Allows HTTP (`port 80`) and SSH (`port 22`) access
- ☁ **EC2 Instance**: Amazon Linux 2 (Free Tier) with Apache (`httpd`) auto-installed
- ⚙ **User Data Script**: Installs Apache and serves a sample HTML page at boot
-  **SSH Key Pair**: Secure login using a generated private key
-  **Terraform Outputs**: Public IP displayed automatically after deploy
-  **GitHub Repo**: Version-controlled Infrastructure as Code

---

## Infrastructure Architecture

                      ┌────────────────────────┐
                      │        Internet        │
                      └────────────┬───────────┘
                                   │
                        ┌──────────▼───────────┐
                        │   Internet Gateway   │
                        └──────────┬───────────┘
                                   │
                      ┌────────────▼────────────┐
                      │         Route Table     │
                      │  0.0.0.0/0 → IGW Route  │
                      └────────────┬────────────┘
                                   │
            ┌──────────────────────▼──────────────────────┐
            │                  VPC                        │
            │              10.0.0.0/16                    │
            │                                             │
            │   ┌──────────────────────────────────────┐  │
            │   │             Public Subnet            │  │
            │   │             10.0.1.0/24              │  │
            │   │                                      │  │
            │   │   ┌──────────────────────────────┐   │  │
            │   │   │        EC2 Instance          │   │  │
            │   │   │ - Amazon Linux 2             │   │  │
            │   │   │ - Apache (httpd)             │   │  │
            │   │   │ - SSH via Key Pair           │   │  │
            │   │   │ - User data (auto setup)     │   │  │
            │   │   └──────────────────────────────┘   │  │
            │   └──────────────────────────────────────┘  │
            └─────────────────────────────────────────────┘



---

##  Usage

### 📁 1. Clone the repository

```bash
git clone https://github.com/Summer-ay/tf-ec2-webserver.git
cd tf-ec2-webserver
```

### 2. Generate an SSH key pair (if not done already)

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/devops-key
```

###  3. Apply Terraform config
```bash
terraform init
terraform plan
terraform apply
```

###  4. Access the server

    Visit http://<EC2-public-IP> 
   Displays:  Hello From Terraform EC2
    
    
### 5. SSH into the server:
```
ssh -i ~/.ssh/devops-key ec2-user@<EC2-public-IP>

