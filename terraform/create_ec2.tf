provider "aws" {
  region = "us-east-1"
}

data "aws_subnets" "get_subnet" {
  filter {
    name   = "vpc-id"
    values = ["vpc-044604d0bfb707142"]
  }
}

# allowing ports 22,5001,8080
resource "aws_security_group" "ssh_access" {
  name        = "allow_ssh_http_jenkins"
  description = "Allow SSH, HTTP (5001) & Jenkins (8080)"
  vpc_id      = "vpc-044604d0bfb707142"

  # Allow SSH 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Allow HTTP 
  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to all (consider restricting if needed)
  }

  # Allow 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # open to all 
  }

  # Allow all out traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# SSH Key Pair
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key"
  public_key = file("~/.ssh/ec2-key.pub")
}

# EC2 Instance
resource "aws_instance" "builder" {
  ami                    = "ami-0f9de6e2d2f067fca" # Ubuntu AMI
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.ec2_key.key_name
  subnet_id              = data.aws_subnets.get_subnet.ids[0] #getting the first public subnets that is available
  vpc_security_group_ids = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true

  tags = {
    Name = "Gal-builder"
  }
}

# outputs as asked
output "ec2_public_ip" {
  value       = aws_instance.builder.public_ip
  description = "Public IP address of the EC2 instance"
}

output "private_key_location" {
  value       = "~/.ssh/ec2-key"
  description = "Location of the private key for SSH access"
  sensitive   = true
}

output "security_group_id" {
  value       = aws_security_group.ssh_access.id
  description = "Security group ID for reference"
}
