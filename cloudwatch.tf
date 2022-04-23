module "api_log_group" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
  version = "~> 3.0"

  name              = "${var.project}-${var.env}"
  retention_in_days = 120
}
