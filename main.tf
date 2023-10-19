resource "aws_instance" "ec2-instance" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro" 
    key_name = "mykey"
    vpc_security_group_ids = [aws_security_group.mySg.id]
    user_data = templatefile("./install.sh", {})
    tags = {
    Name = "terraform-jenkins"
    }
}

resource "aws_security_group" "mySg" {
  name        = "jenkins-sg"
  description = "allow inboundd traffic"

  ingress = [
    for port in [22, 80, 443, 8080] : {
        description = "allow inbound traffic"
        from_port = port
        to_port = port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        prefix_list_ids = []
        security_groups = []
        self = false
        }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my-sg"
  }
}