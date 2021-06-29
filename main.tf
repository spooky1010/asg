provider "aws" {
  region = "us-east-2"
}

data "aws_subnet_ids" "default" {
    vpc_id = data.aws_vpc.default.id
}
data "aws_vpc" "default" {
default = true
}

resource "aws_security_group" "alb" {
    name = "terraform-alb-security-group"

    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "instance" {
  name = "terraform-instance-security-group"

  ingress {
    from_port          = 8080
    to_port            = 8080
    protocol        = "tcp"
    cidr_blocks        = ["0.0.0.0/0"]
    }
}

#########################################################
# ALB

resource "aws_lb" "alb" {
    name = "terraform-alb"
    load_balancer_type = "application"
    subnets = data.aws_subnet_ids.default.ids
    security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "fixed-response"
        fixed_response {
        content_type = "text/plain"
        message_body = "404"
        status_code = 404
        }
    }
}

resource "aws_lb_listener_rule" "asg-listener_rule" {
    listener_arn    = aws_lb_listener.http.arn
    priority        = 100

    condition {
        field   = "path-pattern"
        values  = ["*"]
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.asg-target-group.arn
    }
}

resource "aws_lb_target_group" "asg-target-group" {
    name = "terraform-aws-lb-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 5
        timeout             = 3
        healthy_threshold   = 5
        unhealthy_threshold = 2
    }
}
#########################################################
# ASG

resource "aws_autoscaling_group" "ec2" {
    launch_configuration = aws_launch_configuration.ec2.name
    vpc_zone_identifier = data.aws_subnet_ids.default.ids

    target_group_arns = [aws_lb_target_group.asg-target-group.arn]
    health_check_type = "ELB"

    min_size = 1
    max_size = 10

    tag {
    key = "Name"
    value = "asg-ec2"
    propagate_at_launch = true
    }
}

resource "aws_launch_configuration" "ec2" {
    image_id = "ami-0721c9af7b9b75114"
    instance_type = "t2.micro"

    security_groups = [aws_security_group.instance.id]
                user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF

    lifecycle {
        create_before_destroy = true
    }
}

#########################################################
# scale rules

resource "aws_autoscaling_policy" "agents-scale-up" {
    name = "agents-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = [aws_autoscaling_group.ec2.name]
}

resource "aws_autoscaling_policy" "agents-scale-down" {
    name = "agents-scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = [aws_autoscaling_group.ec2.name]
}

# scale up

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "cpu-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2.name
  }

  alarm_actions     = [aws_autoscaling_policy.agents-scale-up.arn]
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "mem-util-high-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2.name
  }

  alarm_actions     = [aws_autoscaling_policy.agents-scale-up.arn]
}

# scale down

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "cpu-util-low-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2.name
  }

  alarm_actions     = [aws_autoscaling_policy.agents-scale-down.arn]
}

resource "aws_cloudwatch_metric_alarm" "bat" {
  alarm_name          = "mem-util-low-agents"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ec2.name
  }

  alarm_actions     = [aws_autoscaling_policy.agents-scale-down.arn]
}

#########################################################

output "alb_dns_name" {
    value = aws_lb.alb.dns_name
    description = "Доменное имя ALB"
}
