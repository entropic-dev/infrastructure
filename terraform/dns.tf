resource "aws_route53_zone" "root" {
  name          = "entropic.dev"
  comment       = "pkgs"
  force_destroy = false
}

resource "aws_route53_record" "root_a" {
  zone_id = "${aws_route53_zone.root.zone_id}"
  name    = "entropic.dev"
  type    = "A"
  ttl     = "3600"
  records = ["${aws_instance.entropic_dev.public_ip}"]
}

resource "aws_route53_record" "discourse" {
  zone_id = "${aws_route53_zone.root.zone_id}"
  name    = "discourse.entropic.dev"
  type    = "A"
  ttl     = "3600"
  records = ["${aws_instance.discourse.public_ip}"]
}

resource "aws_route53_record" "registry" {
  zone_id = "${aws_route53_zone.root.zone_id}"
  name    = "registry.entropic.dev"
  type    = "CNAME"
  ttl     = "86400"
  records = ["entropic.dev"]
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.root.zone_id}"
  name    = "www.entropic.dev"
  type    = "CNAME"
  ttl     = "86400"
  records = ["entropic-dev.github.io"]
}
