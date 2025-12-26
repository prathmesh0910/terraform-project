module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jenkins-vpc"
  cidr = var.vpc_cidr

  azs                     = data.aws_availability_zones.azs.names
  public_subnets          = var.public_subnets
  map_public_ip_on_launch = true

  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}


module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jenkins-terraform"
  description = "SG for jenkisn and terraform"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "jenkins-terraform "
  }
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "jenkins-terraform"
  ami                         = "ami-0ecb62995f68bb549"
  instance_type               = "t2.micro"
  key_name                    = "s3keypair"
  monitoring                  = true
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [module.sg.security_group_id]
  associate_public_ip_address = true

  user_data         = file("jenkins_userdata.sh")
  availability_zone = data.aws_availability_zones.azs.names[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
