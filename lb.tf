resource "random_pet" "lb_hostname" {}

resource "aws_eip" "lb" {
  domain = "vpc"

  tags = {
    Name = "lb-eip"
  }
}

resource "aws_lb" "nlb" {
  name               = "my-nlb"
  load_balancer_type = "network"
  subnets            = [aws_subnet.public.id]
  ip_address_type    = "ipv4"

  tags = {
    Name = "myNLB"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.main.id

  health_check {
    port     = "80"
    protocol = "TCP"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn   
  }
}
