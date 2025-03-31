resource "aws_vpc" "ids-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = var.vpc_name
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "ids_igw" {
  vpc_id = aws_vpc.ids-vpc.id

  tags = {
    Name        = "${var.vpc_name}-igw"
    Environment = var.environment
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.ids-vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-Public Subnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.ids-vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.environment}-Private Subnet-${count.index + 1}"
  }
}

# Public Route Table (Routes outbound traffic to IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ids-vpc.id

  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.ids_igw.id
  }

  tags = {
    Name = "${var.environment}-Public Route Table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.ids-vpc.id

  tags = {
    Name = "${var.environment}-Private Route Table"
  }
}

#PUBLIC ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#PRIVATE ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}