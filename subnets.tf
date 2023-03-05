resource "aws_subnet" "create-subnet" {
  for_each = var.subnets
  vpc_id = data.aws_vpc.vpc.id

  availability_zone = each.value.availability_zone
  cidr_block = each.value.cidr_block

}


# creating a internet_gateway that will be connected to dina-main-public-subnet

resource "aws_internet_gateway" "gw" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Name = "dina-gw"
  }
}


resource "aws_route_table" "public-RT" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "dina-public-RT"
  }
}


# associate the route table to the subnet "dina-public-subnet"

resource "aws_route_table_association" "RT_assoc" {

  subnet_id =  aws_subnet.create-subnet["public-subnet"].id
  route_table_id = aws_route_table.public-RT.id
}