# =========================================================================
# Creating Ssh KeyPair
# =========================================================================
resource "aws_key_pair"  "terraform" {

  key_name = "terraform"
  public_key = file("terraform.pub")
  tags = {
    Name = "terraform"
  }
}


# =========================================================================
# Security Group For Web Communication
# =========================================================================

resource "aws_security_group" "webserver" {
  name        = "webserver"
  description = "Allow inbound 80 traffic"
  

  ingress {
    description      = ""
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

ingress {
    description      = ""
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

	
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "webserver"
	Project = "Zomato"
  }
}

# =========================================================================
# Security Group For Remote Access
# =========================================================================

resource "aws_security_group" "remote" {
  name        = "remote"
  description = "Allow inbound 22 traffic "
 

  ingress {
    description      = ""
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "remote"
	Project = "Zomato"
  }
}

# =========================================================================
# Creating Ec2 Instance webserver
# =========================================================================

resource "aws_instance" "webserver" {
  ami           = "var.ami"
  instance_type = "var.type"
  vpc_security_group_ids = [aws_security_group.webserver.id , aws_security_group.remote.id]

  tags = {
    Name = "webserver"
	Project = "Zomato"
  }
}
