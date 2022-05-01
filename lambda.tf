locals {
  functions = {
    confirm_register = {
      file        = "confirmRegistration"
      description = "Auth register confirm"
      environment_variables = {
        CLIENT_ID     = aws_cognito_user_pool_client.client.id
        POOL_ID       = aws_cognito_user_pool.user_pool.id
        CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
      }
    }
    "register" = {
      file        = "register"
      description = "Auth register"
      environment_variables = {
        CLIENT_ID     = aws_cognito_user_pool_client.client.id
        POOL_ID       = aws_cognito_user_pool.user_pool.id
        CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
      }
    }
    "login" = {
      file        = "login"
      description = "Login function"
      environment_variables = {
        CLIENT_ID     = aws_cognito_user_pool_client.client.id
        POOL_ID       = aws_cognito_user_pool.user_pool.id
        CLIENT_SECRET = aws_cognito_user_pool_client.client.client_secret
      }
    }
    "home_page" = {
      file        = "home"
      description = "Home Page function"
    }
  }
}
resource "null_resource" "build" {
  triggers = {
    always = timestamp()
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
moved {
  from = module.register_lambda
  to   = module.lambdas["register"]
}
moved {
  from = module.confirm_register_lambda
  to   = module.lambdas["confirm_register"]
}

module "lambdas" {
  for_each              = local.functions
  depends_on            = [null_resource.build]
  source                = "terraform-aws-modules/lambda/aws"
  version               = "~> 3.1"
  function_name         = "${var.project_key}_${each.key}"
  description           = each.value.description
  handler               = "${each.value.file}.handler"
  runtime               = "nodejs14.x"
  publish               = true
  source_path           = "${path.module}/functions/dist/${each.value.file}.js"
  tracing_mode          = "Active"
  environment_variables = try(each.value.environment_variables, {})
  tags = {
    Name = "${var.project}-${var.env}"
  }
}
