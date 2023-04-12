### ----- ALB/main.tf ------ ###
# Create external application load balancer for reverse proxy nginx.
resource "aws_lb" "ext-alb" {
  name     = "Ext-ALB"
  internal = false
  security_groups = [
    var.public-sg
  ]

  subnets = [
    var.public-sbn-1,
    var.public-sbn-2
  ]

  tags = merge(
    var.tags,
    {
      Name = format("%s-ext-alb-%s", var.company_name, var.environment)
    },
  )

  ip_address_type    = var.ip_address_type
  load_balancer_type = var.load_balancer_type
}

# Create target group to point to its targets.
resource "aws_lb_target_group" "nginx-tg" {
  health_check {
    interval            = var.interval # 10
    path                = var.path # "/healthstatus"
    protocol            = var.protocol # "HTTPS"
    timeout             = var.timeout # 5
    healthy_threshold   = var.healthy_threshold # 5
    unhealthy_threshold = var.unhealthy_threshold # 2
  }
  name        = format("%s-nginx-tg-%s", var.company_name, var.environment)
  port        = var.port # 443
  protocol    = var.protocol # "HTTPS"
  target_type = var.target_type # "instance"
  vpc_id      = var.vpc_id
}

# Create listener to redirect traffic to the target group.
resource "aws_lb_listener" "nginx-listener" {
  load_balancer_arn = aws_lb.ext-alb.arn
  port              = var.port # 443
  protocol          = var.protocol # "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.teskers.certificate_arn

  default_action {
    type             = var.default_action_type # "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }
}

#Internal Load Balancers for webservers
resource "aws_lb" "int-alb" {
  name     = "int-alb"
  internal = true
  security_groups = [
    var.private-sg
  ]

  subnets = [
    var.private-sbn-1,
    var.private-sbn-2
  ]

  tags = merge(
    var.tags,
    {
      Name = format("%s-int-alb-%s", var.company_name, var.environment)
    },
  )

  ip_address_type    = var.ip_address_type # "ipv4"
  load_balancer_type = var.load_balancer_type # "application"
}

# --- target group  for wordpress -------
resource "aws_lb_target_group" "wordpress-tg" {
  health_check {
    interval            = var.interval # 10
    path                = var.path # "/healthstatus"
    protocol            = var.protocol # "HTTPS"
    timeout             = var.timeout # 5
    healthy_threshold   = var.healthy_threshold # 5
    unhealthy_threshold = var.unhealthy_threshold # 2
  }

  name        = format("%s-wordpress-tg-%s", var.company_name, var.environment)
  port        = var.port # 443
  protocol    = var.protocol # "HTTPS"
  target_type = var.target_type # "instance"
  vpc_id      = var.vpc_id
}

# --- target group for tooling -------
resource "aws_lb_target_group" "tooling-tg" {
  health_check {
    interval            = var.interval # 10
    path                = var.path # "/healthstatus"
    protocol            = var.protocol # "HTTPS"
    timeout             = var. timeout # 5
    healthy_threshold   = var.healthy_threshold # 5
    unhealthy_threshold = var.unhealthy_threshold # 2
  }

  name        = format("%s-tooling-tg-%s", var.company_name, var.environment)
  port        = var.port # 443
  protocol    = var.protocol # "HTTPS"
  target_type = var.target_type # "instance"
  vpc_id      = var.vpc_id
}

# For this aspect a single listener was created for the wordpress which is default,
# A rule was created to route traffic to tooling when the host header changes
resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.int-alb.arn
  port              = var.port # 443
  protocol          = var.protocol # "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.teskers.certificate_arn

  default_action {
    type             = var.default_action_type # "forward"
    target_group_arn = aws_lb_target_group.wordpress-tg.arn
  }
}

# listener rule for tooling target
resource "aws_lb_listener_rule" "tooling-listener" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = var.priority # 99

  action {
    type             = var.default_action_type # "forward"
    target_group_arn = aws_lb_target_group.tooling-tg.arn
  }

  condition {
    host_header {
      values = ["tooling.teskers.online"]
    }
  }
}