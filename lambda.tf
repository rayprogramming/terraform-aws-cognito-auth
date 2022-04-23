module "register_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 3.1"
  function_name = "${var.project_key}_register"
  description   = "Auth register"
  handler       = "register.handler"
  runtime       = "nodejs14.x"
  publish       = true
  source_path   = "${path.module}/functions/dist/register.js"
  environment_variables = {
    CLIENT_ID     = aws_cognito_user_pool_client.client.id
    POOL_ID       = aws_cognito_user_pool.user_pool.id
    CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
  }
  tags = {
    Name = "${var.project}-${var.env}"
  }
}
module "confirm_register_lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  version       = "~> 3.1"
  function_name = "${var.project_key}_confirm_register"
  description   = "Auth register confirm"
  handler       = "confirmRegistration.handler"
  runtime       = "nodejs14.x"
  publish       = true
  source_path   = "${path.module}/functions/dist/confirmRegistration.js"
  environment_variables = {
    CLIENT_ID     = aws_cognito_user_pool_client.client.id
    POOL_ID       = aws_cognito_user_pool.user_pool.id
    CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
  }
  tags = {
    Name = "${var.project}-${var.env}"
  }
}
