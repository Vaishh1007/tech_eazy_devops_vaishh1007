provider "aws" {
  region = var.region
}

# Get Latest Ubuntu 22.04 AMI (safe filter)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = file("${path.module}/../scripts/user_data.sh")

  tags = {
    Name = "tech-eazy-devops-instance"
    Stage = var.stage
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}
