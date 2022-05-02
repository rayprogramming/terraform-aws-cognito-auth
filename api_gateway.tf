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
      lambda_arn             = module.lambdas["register"].lambda_function_arn
      payload_format_version = "2.0"
    }
    "POST /confirm" = {
      lambda_arn             = module.lambdas["confirm_register"].lambda_function_arn
      payload_format_version = "2.0"
    }
    "POST /login" = {
      lambda_arn             = module.lambdas["login"].lambda_function_arn
      payload_format_version = "2.0"
    }
    "GET /" = {
      lambda_arn             = module.lambdas["home_page"].lambda_function_arn
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

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~>2.0.0" # https://github.com/terraform-aws-modules/terraform-aws-route53/issues/59

  zone_id = data.aws_route53_zone.selected.zone_id

  records = [
    {
      name = var.project_key
      type = "A"
      alias = {
        name    = module.api_gateway.apigatewayv2_domain_name_configuration[0].target_domain_name
        zone_id = module.api_gateway.apigatewayv2_domain_name_configuration[0].hosted_zone_id
      }
    }
  ]
}
