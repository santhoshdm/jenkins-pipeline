data "aws_route53_zone" "cloud" {
  name         = "awsdemocloudlinuxacademy.com."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.cloud.zone_id}"
  name    = "www.${data.aws_route53_zone.cloud.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.applb.dns_name}"]
}