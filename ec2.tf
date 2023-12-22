# creates a ec2 instance for the bastion host in the public az1 subnet
resource "aws_instance" "bastion_host" {
  ami           = "ami-00b8917ae86a424c9"
  instance_type = "t2.micro"
  key_name = "Dev-Key"
  associate_public_ip_address = true
  subnet_id = module.vpc.public_subnet_az1_id
  security_groups = [aws_security_group.ssh_security_group.id]

  tags = {
    Name = "Bastion Host"
  }
}

# creates a ec2 instance for the ansible server in the pivate app az1 subnet
resource "aws_instance" "ansible_server" {
  ami           = "ami-09c4d799acaf4bd22"
  instance_type = "t2.micro"
  key_name = "Dev-Key"
  subnet_id = module.vpc.private_app_subnet_az1_id
  security_groups = [aws_security_group.ansible_security_group.id]

  tags = {
    Name = "Ansible Server"
  }
}

# creates a ec2 instance for the webserver in the pivate app az1 subnet
resource "aws_instance" "webserver_az1" {
  ami           = "ami-00b8917ae86a424c9"
  instance_type = "t2.micro"
  key_name = "Ansible Public Key"
  subnet_id = module.vpc.private_app_subnet_az1_id
  security_groups = [aws_security_group.webserver_security_group.id]

  tags = {
    Name = "Webserver AZ1"
  }
}

# creates a ec2 instance for the webserver in the pivate app az2 subnet
resource "aws_instance" "webserver_az2" {
  ami           = "ami-00b8917ae86a424c9"
  instance_type = "t2.micro"
  key_name = "Ansible Public Key"
  subnet_id = module.vpc.private_app_subnet_az2_id
  security_groups = [aws_security_group.webserver_security_group.id]

  tags = {
    Name = "Webserver AZ2"
  }
}