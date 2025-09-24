provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "assignment2_bucket" {
  bucket = "vaishh-assignment2-bucket-123"  # Replace with a globally unique name
  acl    = "private"
}

resource "aws_instance" "assignment2_instance" {
  ami           = "ami-0c02fb55956c7d316"  # Example for Mumbai region
  instance_type = "t2.micro"
  key_name      = "your-key-name"          # Replace with your key pair

  tags = {
    Name = "Assignment2-Instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y git",
      "sudo yum install -y docker",
      "sudo systemctl start docker",
      "sudo systemctl enable docker"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/your-key.pem")  # Replace with your key
      host        = self.public_ip
    }
  }
}
