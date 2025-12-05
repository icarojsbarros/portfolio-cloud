provider "aws" {
  region = "us-east-1"
}

# 1. Busca a imagem do Ubuntu mais recente automaticamente
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]   # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 2. Cria o Firewall (Security Group)
resource "aws_security_group" "web_sg" {
  name        = "web_server_sg_portfolio"
  description = "Liberar HTTP"

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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Cria o Servidor (EC2)
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"    # Free Tier

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # Script que roda quando a instância liga (Instala Docker e sobe um site teste)
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              docker run -d -p 80:80 nginxdemos/hello
              EOF

  tags = {
    Name = "Icarus-DevOps-Project"
  }
}

# 4. Mostra o IP no final
output "public_ip" {
  value = aws_instance.web_server.public_ip
}
