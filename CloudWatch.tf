resource "aws_sns_topic" "devops" {
  name = "alarms-topic"
  
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
  
  provisioner "local-exec" {
    when = "destroy"
    command = "aws sns list-subscriptions-by-topic --topic-arn ${self.arn} --output text --query 'Subscriptions[].[SubscriptionArn]' | grep '^arn:' | xargs -rn1 aws sns unsubscribe --subscription-arn"
}
}


resource "aws_cloudwatch_metric_alarm" "app1cpu" {
  alarm_name                = "app1-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app1.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "app1health" {
  alarm_name                = "app1-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app1.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "app2cpu" {
  alarm_name                = "app2-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app2.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "app2health" {
  alarm_name                = "app2-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app2.id}"
  }
}


resource "aws_cloudwatch_metric_alarm" "httpcode_target_5XX_count" {
  alarm_name          = "tgroup-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Average 5XX target group error code count is too high"
  alarm_actions       = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    "TargetGroup"  = aws_lb_target_group.apptg.arn_suffix
    "LoadBalancer" = aws_lb.applb.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "httpcode_lb_5xx_count" {
  alarm_name          = "alb-high5XXCount"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "0"
  treat_missing_data  = "notBreaching"
  alarm_description   = "Average ALB 5XX load balancer error code count is too high"
  alarm_actions       = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    "LoadBalancer" = aws_lb.applb.arn_suffix
  }
}

resource "aws_cloudwatch_metric_alarm" "target_response_time_average" {
  alarm_name          = "alb-tg-highResponseTime"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "50"
  alarm_description   = "Average response time is too high"
  alarm_actions       = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    "TargetGroup"  = aws_lb_target_group.apptg.arn_suffix
    "LoadBalancer" = aws_lb.applb.arn_suffix
  }
}


resource "aws_cloudwatch_metric_alarm" "healthy_host_count" {
  alarm_name          = "alb-healthy-host-count"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "5"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "2"
  alarm_description   = "Healthy Host count"
  alarm_actions       = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    "TargetGroup"  = aws_lb_target_group.apptg.arn_suffix
    "LoadBalancer" = aws_lb.applb.arn_suffix
  }
}