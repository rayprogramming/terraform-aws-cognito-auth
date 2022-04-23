resource "null_resource" "build" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOF
      cd ${path.module}/ &&\
      mkdir -p ./node_install &&\
      cd ./node_install &&\
      curl https://nodejs.org/download/release/v14.18.1/node-v14.18.1-linux-x64.tar.gz | tar xz --strip-components=1 &&\
      export PATH="$PWD/bin:$PATH" &&\
      cd ../functions &&\
      npm install &&\
      npm run build
    EOF
  }
}
module "register_lambda" {
  depends_on    = [null_resource.build]
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
  depends_on    = [null_resource.build]
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
