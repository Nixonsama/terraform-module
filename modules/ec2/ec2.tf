
resource "aws_security_group" "web-sg" {
  name        = "web"
  description = "Allow http and ssh"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description      = "ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}


resource "aws_key_pair" "web_key" {
  key_name   = "web_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "key_pair_local" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "web_key.pem"
}




resource "aws_instance" "web" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.dev-public.id
  key_name = aws_key_pair.web_key.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("${path.module}/adduser.sh")

  tags  = {
    Name = "web"
  }
  
}


resource "aws_instance" "ansible" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.dev-public.id
  key_name = aws_key_pair.web_key.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("${path.module}/ansible.sh")

  tags  = {
    Name = "ansible"
  }
  
}


resource "aws_instance" "db" {
  ami = var.ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.dev-public.id
  key_name = aws_key_pair.web_key.id
  vpc_security_group_ids = [aws_security_group.web-sg.id]
  user_data = file("${path.module}/adduser.sh")

  tags  = {
    Name = "db"
  }
  
}


output "web-public-ip" {
  description = "web public ipv4"
  value = aws_instance.web.public_ip
}

output "ansible-public-ip" {
  description = "ansible public ipv4"
  value = aws_instance.ansible.public_ip
}

output "db-public-ip" {
  description = "db public ipv4"
  value = aws_instance.db.public_ip
}
