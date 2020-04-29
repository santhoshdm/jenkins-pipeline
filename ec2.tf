resource "aws_instance" "app1" {
  instance_type = "t2.micro"
  ami           = "ami-032cf0cbfd6553e4e"
  key_name      = "aws"

  tags = {
    "type" = "terraform-test-instance"
	"Name" = "APP-Servers"
  }
}

resource "aws_security_group" "sg" {
  name= "Allow_Tomcat"
  description= "Allow Tomcat port inbound"
  ingress {
    description = "Tomcat from Internet"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "SSH from Ansible"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    "type" = "terraform-test-security-group"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.sg.id
  network_interface_id = aws_instance.app1.primary_network_interface_id
}