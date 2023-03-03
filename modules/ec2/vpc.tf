resource "aws_vpc" "dev" {
  cidr_block       = var.cider
  instance_tenancy = "default"

  tags = {
    Name = "dev"
  }
}  


resource "aws_subnet" "dev-public" {
  vpc_id     = aws_vpc.dev.id #"vpc-0323a0343db65046d"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev-public"
  }
}

resource "aws_subnet" "dev-private" {
  vpc_id     = aws_vpc.dev.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "dev-private"
  }
}

resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev.id

  tags = {
    Name = "dev-igw"
  }
}

resource "aws_route_table" "dev-public-rt" {
  vpc_id = aws_vpc.dev.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }




  tags = {
    Name = "dev-public-rt"
  }
}

resource "aws_route_table_association" "dev-pub-ass" {
  subnet_id      = aws_subnet.dev-public.id
  route_table_id = aws_route_table.dev-public-rt.id
}