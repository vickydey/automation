# Create Instance in public subnet using VPC 

module "levelup-vpc" {
    source      = "./module/vpc"

    ENVIRONMENT = var.ENVIRONMENT
    AWS_REGION  = var.AWS_REGION
}

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name      = "levelup_key"
  public_key    = file(var.public_key_path)
}

#Secutiry Group for public Instances
resource "aws_security_group" "allow-ssh" {
  vpc_id      = module.levelup-vpc.my_vpc_id
  name        = "allow-ssh-${var.ENVIRONMENT}"
  description = "security group that allows ssh traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENVIRONMENT
  }
}

# Create Instance Group in public subnet
resource "aws_instance" "my-instance" {
  count         = 4
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = module.levelup-vpc.public_subnet1_id
  availability_zone = "${var.AWS_REGION}a"


  #["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}","${var.vpc_public_subnet3}"]
  # the security group
  vpc_security_group_ids = [aws_security_group.allow-ssh.id]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
  }
}


# Create Instance in private subnet using VPC 


#Secutiry Group for private Instances
resource "aws_security_group" "allow-PS" {
  vpc_id      = module.levelup-vpc.my_vpc_id
  name        = "allow-PS-${var.ENVIRONMENT}"
  description = "security group that allows Public subnet port"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.101.0/24"]
  }

    
  tags = {
    Name         = "allow-PS"
    Environmnent = var.ENVIRONMENT
  }
}

# Create Instance Group in private subnet
resource "aws_instance" "my-instance1" {
  count         = 4
  ami           = lookup(var.AMIS, var.AWS_REGION)
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = module.levelup-vpc.private_subnet1_id
  availability_zone = "${var.AWS_REGION}a"


  #["${var.vpc_public_subnet1}", "${var.vpc_public_subnet2}","${var.vpc_public_subnet3}"]
  # the security group
  vpc_security_group_ids = [aws_security_group.allow-PS.id]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  tags = {
    Name         = "instance1-${var.ENVIRONMENT}"
    Environmnent = var.ENVIRONMENT
  }
}
