# Create key pairs
resource "aws_key_pair" "terraform-key-pair" {
  key_name   = "key-pair-consle"
  public_key = file("terraform-key-pair-console.pub")
}

# VPC & Security Group
resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {
  name        = "security-grup-terraform-auto"
  description = "its been created from terraform"
  vpc_id      = aws_default_vpc.default.id # interpolation
  
  # Inbound rule
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "auto_security_grup"
  }
}
# EC2
resource "aws_instance" "terraform_ec2_instance" {
  key_name         = aws_key_pair.terraform-key-pair.key_name
  security_groups  = [aws_security_group.my_security_group.name]
  instance_type    = "t2.micro"
  ami              = "ami-084568db4383264d4"

  root_block_device {
    volume_size = 15
    volume_type = "gp3"
  }

  tags ={
    name= "ec2_instance_terraform"
} 