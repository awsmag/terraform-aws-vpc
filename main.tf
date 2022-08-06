# Data
data "aws_availability_zones" "availableAZ" {}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.namespace
    Namespace = var.namespace
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internetgateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.namespace}-InternetGateway"
    Namespace = var.namespace
  }

  depends_on = [aws_vpc.vpc]
}

# Public Subnet
resource "aws_subnet" "publicsubnet" {
  count                   = 3
  cidr_block              = tolist(var.public_subnet_cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.availableAZ.names[count.index]

  tags = {
    Name = "${var.namespace}-publicsubnet-${count.index + 1}"
    AZ   = data.aws_availability_zones.availableAZ.names[count.index]
    Namespace = var.namespace
  }

  depends_on = [aws_vpc.vpc]
}

# Private Subnet
resource "aws_subnet" "privatesubnet" {
  count             = 3
  cidr_block        = tolist(var.private_subnet_cidr)[count.index]
  vpc_id            = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.availableAZ.names[count.index]

  tags = {
    Name = "${var.namespace}-privatesubnet-${count.index + 1}"
    AZ   = data.aws_availability_zones.availableAZ.names[count.index]
    Namespace = var.namespace
  }

  depends_on = [aws_vpc.vpc]
}

# Elastic IP
resource "aws_eip" "elasticIPs" {
  count = 3
  vpc   = true

  tags = {
    Name = "elasticIP-${count.index + 1}"
    Namespace = var.namespace
  }

  depends_on = [aws_internet_gateway.internetgateway]
}

# NAT Gateway
resource "aws_nat_gateway" "natgateway" {
  count         = 3
  allocation_id = aws_eip.elasticIPs[count.index].id
  subnet_id     = aws_subnet.publicsubnet[count.index].id

  tags = {
    Name = "${var.namespace}-NATGateway-${count.index + 1}"
    AZ   = data.aws_availability_zones.availableAZ.names[count.index]
    Namespace = var.namespace
  }

  depends_on = [aws_internet_gateway.internetgateway]
}

# Route Table for Public Routes
resource "aws_route_table" "publicroutetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internetgateway.id
  }

  tags = {
    Name = "${var.namespace}-publicroutetable"
    Namespace = var.namespace
  }

  depends_on = [aws_internet_gateway.internetgateway]
}

# Route Table for Private Routes
resource "aws_route_table" "privateroutetable" {
  count  = 3
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgateway[count.index].id
  }

  tags = {
    Name = "${var.namespace}-privateroutetable-${count.index + 1}"
    AZ   = data.aws_availability_zones.availableAZ.names[count.index]
    Namespace = var.namespace
  }

  depends_on = [aws_nat_gateway.natgateway]
}

# Route Table Association - Public Routes
resource "aws_route_table_association" "routeTableAssociationPublicRoute" {
  count          = 3
  route_table_id = aws_route_table.publicroutetable.id
  subnet_id      = aws_subnet.publicsubnet[count.index].id

  depends_on = [aws_subnet.publicsubnet, aws_route_table.publicroutetable]
}

# Route Table Association - Private Routes
resource "aws_route_table_association" "routeTableAssociationPrivateRoute" {
  count          = 3
  route_table_id = aws_route_table.privateroutetable[count.index].id
  subnet_id      = aws_subnet.privatesubnet[count.index].id

  depends_on = [aws_subnet.privatesubnet, aws_route_table.privateroutetable]
}
