provider "aws" {
  region  = var.region
  profile = "terraform-user"
}

variable "region" {
  default = "us-east-1"
}

variable "sg_ports_ingress" {
  type        = list(number)
  description = "ingress list port"
  default     = [8200, 8201, 8300, 9200, 9500]
}

variable "sg_ports_egress" {
  type        = list(number)
  description = "egress list port"
  default     = [0]
}

resource "aws_security_group" "http_sg" {
  name        = "http security group"
  description = "Ingress for vault"

  dynamic "ingress" {
    for_each = var.sg_ports_ingress
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports_egress
    iterator = egress
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  tags = {
    Name = "http security group"
  }
}
