resource "aws_route53_health_check" "cla-hc" {
  fqdn              = "www.cloudlinuxacademy.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    "Name" = "cla-hc"
  }
}

resource "aws_sns_topic" "devopsnv" {
  name = "alarms-topicnv"
  
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email} --region us-east-1"
  }
  
  provisioner "local-exec" {
    when = "destroy"
    command = "aws sns list-subscriptions-by-topic --topic-arn ${self.arn} --output text --query 'Subscriptions[].[SubscriptionArn]' --region us-east-1 | grep '^arn:' | xargs -rn1 aws sns unsubscribe --subscription-arn"
}
}

resource "aws_cloudwatch_metric_alarm" "cla-hc" {
  alarm_name          = "cla_healthcheck_failed"
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  unit                = "None"

  dimensions = {
    HealthCheckId = aws_route53_health_check.cla-hc.id
  }

  alarm_description         = "This metric monitors cla.com whether the service endpoint is down or not."
  alarm_actions             = [ "${aws_sns_topic.devopsnv.arn}" ]
  insufficient_data_actions = [ "${aws_sns_topic.devopsnv.arn}" ]
  treat_missing_data        = "breaching"
}