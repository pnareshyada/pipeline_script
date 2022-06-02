terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}


provider "aws" {
  region     = "us-east-2"
  access_key = "AKIA25TFYQAKOIEVUKV5"
  secret_key = "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"
}


resource "aws_instance" "ansible_instance" {
  ami                    = "ami-0fa49cc9dc8d62c84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ansisg.id]
  #key_name               = aws_key_pair.ansi_key.id
  count                  = 3


  /* user_data = <<-EOF

  #!/bin/bash
  echo "*** Installing apache2"
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl enable httpd
  sudo systemctl start httpd
 echo "*** Completed Installing apache2"
  EOF           */

  tags = {
    Name = "ansibleec2"
  }

}

resource "aws_security_group" "ansisg" {
  name = "ansib_sg"



  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "terra_sg"
  }

 /* resource "aws_key_pair" "ansikey" {
    key_name   = "ansi_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDypdhyZojSsnXd2Zd4A/bBpOkhZ5M3udHpKQnOF8EEAoto7ThHD2K8c51XJh3iYKE5SoWfqr6KJCF3xaoZEXpyTGAP4UuODcZFOXGZoyw9aBL9NKDBqW8CNb4lUQr8gFyP7qBl+GYG3272C9PC/8GXIQGF/Dv6YgEhGYJDqKHRq3wJ9Mef1Fd5QU1gs/jEe6pb5tc2aOvTKneSgcPaWfsNjp4LQsYtKcn/pU90m/5nSrdbMYtqFjzyrGs85dtdLVzJzG8s70qVstqyzZo6cTda0P1Kyc7uRp8PNEsMn9/ChaGoBfwM2oWyCh+pi0nu921KajkTOfskNxbSsHED4l0RT72VWZXJgoquMZZ9X+p5d//YcuOTh758saeOOBdnurTn3D3WOBJqdUMJ3GXUFFsAPVmjzWdDjWd8olOKs6fM0rQMgMbxbl3cf3v+3QLyXjtUsvluJYGEowEdynzXCcB6/6VnLocRho0HWb8kXu93l1K5kZrX/4ztzpdhRqSB4t0= naresh@LAPTOP-MFOUV5RQ"
  }
*/
}
