### -------- ALB/output.tf -------- ###

output "alb_dns_name" {
  value = aws_lb.ext-alb.dns_name
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.nginx-tg.arn
}

output "wordpress-tg" {
  description = "The target group for wordpress"
  value = aws_lb_target_group.wordpress-tg.arn
}

output "tooling-tg" {
  description = "The target group for tooling"
  value = aws_lb_target_group.tooling-tg.arn
}

output "nginx-tg" {
  description = "The target group for nginx"
  value = aws_lb_target_group.nginx-tg.arn
}