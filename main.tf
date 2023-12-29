provider "aws" {
  region = "us-east-2"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "http_server_sg"
  }
}

resource "aws_instance" "http_server" {
  ami                    = data.aws_ami.aws_linux_2_latest.id
  key_name               = "administrator"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = data.aws_subnets.default_subnets.ids[0]

//  connection {
//    type        = "ssh"
//    host        = self.public_ip
//    user        = "ec2-user"
//    private_key = file(var.aws_key_pair)
//  }
//
//    provisioner "remote-exec" {
//      inline = [
//        "sudo yum install docker -y",
//        "sudo systemctl enable docker",
//        "sudo systemctl start docker",
////        "sudo docker run -p 80:3000 kstvakin/onboarding-app-devops:25"
//      ]
//    }
}