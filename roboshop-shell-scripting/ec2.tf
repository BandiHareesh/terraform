resource "aws_spot_instance_request" "cheap_worker" {
  count                     = local.LENGTH
  ami                       = "ami-0855cab4944392d0a"
  spot_price                = "0.0034"
  instance_type             = "t3.micro"
  wait_for_fulfillment      = true
  tags                      = {
    Name                    = element(var.COMPONENTS, count.index)
  }
}
