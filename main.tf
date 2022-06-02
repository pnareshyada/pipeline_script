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
  region  = "us-east-2"
  access_key="AKIA25TFYQAKOIEVUKV5"
  secret_key="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"
}


resource "aws_instance" "ec2" {
  ami             = "ami-0fa49cc9dc8d62c84" 
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  count                  

  user_data = <<-EOF

  #!/bin/bash
  echo "*** Installing apache2"
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl enable httpd
  sudo systemctl start httpd
 echo "*** Completed Installing apache2"
  EOF
  
    tags = {
    Name = "terraec2"
  }

}

resource "aws_security_group" "sg1" {
  name        = "teraform_sg"
  
  

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




}









