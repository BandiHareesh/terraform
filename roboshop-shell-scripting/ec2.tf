//resource "aws_spot_instance_request" "cheap_worker" {
//  count                       = length(var.COMPONENTS)
//  ami                         = "ami-0855cab4944392d0a"
//  spot_price                  = "0.0031"
//  instance_type               = "t3.micro"
//  wait_for_fulfillment        = true
//
//  tags                        = {
//    Name                      = element(var.COMPONENTS, count.index)
//  }
//}

resource "aws_instance" "sample" {
  count                       = local.LENGTH
  ami                         = "ami-0855cab4944392d0a"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = ["sg-04bea5344c2dfe413"]
  tags                        = {
    Name                      = element(var.COMPONENTS, count.index )
  }
}

resource "aws_route53_record" "records" {
  count                         = local.LENGTH
  name                          = element(var.COMPONENTS, count.index )
  type                          = "A"
  zone_id                       = "Z020690820L8AJ4UBDKAE"
  ttl                           = 300
  records                       = [element(aws_instance.sample.*.private_ip, count.index )]
}


//to connect and run the shell scripting commands

resource "null_resource" "run-shell-scripting" {
  depends_on                  = [aws_route53_record.records]
  count                       = local.LENGTH
  provisioner "remote-exec" {
    connection {
      host                    = element(aws_instance.sample.*.public_ip, count.index)
      user                    = "centos"
      password                = "DevOps321"
    }
    inline                   = [
      "cd /home/centos",
      "git clone https://github.com/BandiHareesh/shell-scripting.git",
      "cd shell-scripting/roboshop",
      "sudo make ${element(var.COMPONENTS, count.index)}"

    ]
  }
}

locals {
  LENGTH                      = length(var.COMPONENTS)
}