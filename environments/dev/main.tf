provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block = "10.0.0.0/16"  # 任意のCIDRブロックを指定
  vpc_name       = "MyVPC"
}

module ec2_sg {
  source = "../../modules/security_group"

  sg_config = {
    name        = "ec2_sg"
    vpc_id      = module.my_vpc.vpc_id
    protocol    = "tcp"
    port        = [22, 80, 443]
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ansible_host" {
  source = "../../modules/ec2"

  ami        = "ami-0fd8f5842685ca887"
  tags       = {
    Name = "AnsibleHost"
  }
  key_name   = "ssh_ec2_instance"
  sg_id      = module.ec2_security_group.sg_id 
}

module "s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "dev-terraform-bucket-name-3498403"
  bucket_acl  = "private"  // または任意のACL設定
  tags        = {
    Environment = "Dev"
  }
}

