terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "ap-southeast-1"
    access_key = "AKIA33N3PSPJ6PRIKHA6"
    secret_key = "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"
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.rsa_4096.private_key_pem
  filename = var.key_name
}

resource "aws_instance" "public_instance" {
  ami           = "ami-069cb3204f7a90763"
  instance_type = "t2.micro"
  key_name = aws_key_pair.key_pair.key_name
  
  tags = {
    Name = "public_instance"
  }
}