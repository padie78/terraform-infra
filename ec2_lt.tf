# -------------------------------
# Data para la AMI Ubuntu 22.04
# -------------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# -------------------------------
# Launch Template
# -------------------------------
resource "aws_launch_template" "web" {
  name_prefix   = "demo-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  key_name = "terraform-infra" # tu keypair SSH

  user_data = filebase64("user-data.sh") # Script de inicialización

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.web_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "demo-asg-instance"
    }
  }
}