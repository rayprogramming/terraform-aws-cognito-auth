# videoStreamer-users
This is the terraform users module for my video streaming application

# TODO
* Finish login functionality
* Add password refresh
* look into mfa
* Figure out how to better leverage env's for stages

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.8 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.11 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.11 |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.1.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 3.0 |
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | terraform-aws-modules/apigateway-v2/aws | ~> 1.7 |
| <a name="module_api_log_group"></a> [api\_log\_group](#module\_api\_log\_group) | terraform-aws-modules/cloudwatch/aws//modules/log-group | ~> 3.0 |
| <a name="module_lambdas"></a> [lambdas](#module\_lambdas) | terraform-aws-modules/lambda/aws | ~> 3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_pool.user_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_ssm_parameter.users_client_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.users_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.users_pool_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [null_resource.build](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | Environment; used for tagging and naming | `string` | `"dev"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project Name; used for tagging and naming | `string` | `"Auth"` | no |
| <a name="input_project_key"></a> [project\_key](#input\_project\_key) | This will be used for subdomains and naming | `string` | `"auth"` | no |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | The zone id used to create subdomains | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The API subdomain resource for authenticating users |
<!-- END_TF_DOCS -->
