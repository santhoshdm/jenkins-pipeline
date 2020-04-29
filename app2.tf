resource "aws_instance" "app2" {
  instance_type = "t2.micro"
  ami           = "ami-078951bcd843f606a"
  key_name      = "aws"
  vpc_security_group_ids = [aws_security_group.sg.id]
  
  tags = {
    "type" = "terraform-test-instance"
	"Name" = "APP-Servers"
  }
}