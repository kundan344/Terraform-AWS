resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,8080,9000,3000"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}


resource "aws_instance" "Jenkins" {
  ami                    = "ami-0862be96e41dcbf74"
  instance_type          = "t2.large"
  key_name               = "ruchykeyohio"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  user_data              = templatefile("./install_Jenkins.sh", {})

  tags = {
    Name = "Jenkins-Server"
  }
  root_block_device {
    volume_size = 30
  }
}

resource "aws_instance" "Sonar" {
  ami                    = "ami-0862be96e41dcbf74"
  instance_type          = "t2.medium"
  key_name               = "ruchykeyohio"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]


  tags = {
    Name = "Sonar-Server"
  }
  root_block_device {
    volume_size = 30
  }
}