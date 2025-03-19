# NAT Gateway requires an Elastic IP address to be associated with it.
resource "aws_eip" "this" {
  domain   = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.vpc.nat_gateway_name}-eip"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.publics[0].id

  tags = merge(
    var.tags,
    {
      Name = var.vpc.nat_gateway_name
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.this]
}