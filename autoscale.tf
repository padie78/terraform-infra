# Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {
  desired_capacity     = 2
  min_size             = 1
  max_size             = 3
  vpc_zone_identifier  = [aws_subnet.public.id]   # Subnet de la VPC
  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tg.arn]

  health_check_type         = "EC2"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "demo-asg-instance"
    propagate_at_launch = true
  }
}

# Política de escalado por CPU
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment      = 1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 120
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment      = -1
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 120
  autoscaling_group_name  = aws_autoscaling_group.web_asg.name
}

# Alarma CloudWatch para CPU > 80% → escala hacia arriba
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80

  alarm_actions       = [aws_autoscaling_policy.scale_out.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}

# Alarma CloudWatch para CPU < 10% → escala hacia abajo
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 10

  alarm_actions       = [aws_autoscaling_policy.scale_in.arn]
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_asg.name
  }
}
