#Use the AWS Cloud
provider "aws" {
    region = "us-east-1"
}

#Create isolated network in AWS
resource "aws_vpc" "main_vpc" {
    cidr_block = "10.0.0.0/16"  #CIDR block 10.0.0.0/16 means: "I want 65,536 IP addresses to work with 
    tags = { 
      Name = "MainVPC" 
    }
}

###Subnet + Internet Gateway + Routing
#Public Subnet
resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "PublicSubnet"
    }
}

#Internet Gateway (IGW)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "MainIGW"
  }
}

#Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

###Associate Route Table with Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Registering the public key with AWS via Terraform
resource "aws_key_pair" "dev_key"{
  key_name = "devops-key"
  public_key = file(var.public_key_path)  #Adding a variable for the key file

  tags = {
    Name = "DevOpsKey"
  }
}


###SECURITY GROUP
resource "aws_security_group" "web_sg" {
  name = "web_traffic"
  description = "Allow SSH and HTTP access"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP form anywhere"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebServerSecurityGroup"
  }
}


#############
#Creating EC2 Instance
#############
resource "aws_instance" "web" {
  ami = "ami-0c94855ba95c71c99" #Amazon Linux 2(Free tier in us-east-1)
  instance_type = "t2.micro"    #Free Tier eligible
  subnet_id = aws_subnet.public_subnet.id
  key_name = aws_key_pair.dev_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              echo "<h1>Hello From Terraform EC2</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "TerraformWebServer"
  }
}
