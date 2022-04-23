module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 3.0"

  domain_name = "${var.project_key}.${data.aws_route53_zone.selected.name}"
  zone_id     = var.zone_id

  wait_for_validation = true

  tags = {
    Name = "${var.project_key}.${data.aws_route53_zone.selected.name}"
    Env  = var.env
  }
}
