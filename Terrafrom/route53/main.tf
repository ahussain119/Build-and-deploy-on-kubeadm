variable "domain_name" {}
variable "jenkins_ip_address" {}
variable "docker_ip_address" {}
variable "k8s_ip_address" {}
variable "k8s_slave_ip_address" {}


output "certificate_arn" {
  value = aws_acm_certificate.certificate.arn
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.route53_zone.zone_id
}

output "certificate_validation" {
  value = aws_acm_certificate_validation.domain_validation  
}

data "aws_route53_zone" "route53_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "jenkins_zone_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "jen.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.jenkins_ip_address]
}

resource "aws_route53_record" "docker_zone_record" {
  zone_id = data.aws_route53_zone.route53_zone.zone_id
  name    = "docker.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.docker_ip_address]
}


resource "aws_route53_record" "k8s_zone_record" {
  zone_id    = data.aws_route53_zone.route53_zone.zone_id
  name       = "kube.${var.domain_name}"
  type       = "A"
  ttl        = 300
  records    = [var.k8s_ip_address]
}

resource "aws_route53_record" "k8s_slave_zone_record" {
  zone_id    = data.aws_route53_zone.route53_zone.zone_id
  name       = "www.${var.domain_name}"
  type       = "A"
  ttl        = 300
  records    = [var.k8s_slave_ip_address]
}



resource "aws_acm_certificate" "certificate" {
  depends_on                = [aws_route53_record.jenkins_zone_record, aws_route53_record.docker_zone_record]
  domain_name               = "www.${var.domain_name}"
  subject_alternative_names = ["jen.${var.domain_name}", "docker.${var.domain_name}", "k8s.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "domain_validation" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  depends_on              = [aws_route53_record.validation_record]
  validation_record_fqdns = [for record in aws_route53_record.validation_record : record.fqdn]
}
