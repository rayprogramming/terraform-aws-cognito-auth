module "api_gateway" {
  source                                   = "terraform-aws-modules/apigateway-v2/aws"
  version                                  = "~> 1.7"
  name                                     = "${var.project}-${var.env}"
  description                              = "Authentication API"
  protocol_type                            = "HTTP"
  domain_name                              = "${var.project_key}.${data.aws_route53_zone.selected.name}"
  domain_name_certificate_arn              = module.acm.acm_certificate_arn
  default_stage_access_log_destination_arn = module.api_log_group.cloudwatch_log_group_arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "POST /register" = {
      lambda_arn             = module.register_lambda.lambda_function_arn
      payload_format_version = "2.0"
    }
    "POST /confirm" = {
      lambda_arn             = module.confirm_register_lambda.lambda_function_arn
      payload_format_version = "2.0"
    }
  }

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  tags = {
    Name = "${var.project}-${var.env}"
  }
}
