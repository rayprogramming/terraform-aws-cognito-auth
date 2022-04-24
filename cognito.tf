resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.project}-${var.env}"
  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "client" {
  name                  = "${var.project}_${var.env}"
  user_pool_id          = aws_cognito_user_pool.user_pool.id
  access_token_validity = 60
  id_token_validity     = 60
  explicit_auth_flows = [
    "ALLOW_ADMIN_USER_PASSWORD_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  read_attributes = [
    "address",
    "birthdate",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phonenumber_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  write_attributes = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  # (11 unchanged attributes hidden)

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

}

resource "aws_ssm_parameter" "users_client_id" {
  name        = "/${var.project}/${var.env}/client_id"
  description = "Cognito Client Id for managing users"
  type        = "String"
  value       = aws_cognito_user_pool_client.client.id
}

resource "aws_ssm_parameter" "users_pool_id" {
  name        = "/${var.project}/${var.env}/pool_id"
  description = "Cognito Pool Id for managing users"
  type        = "String"
  value       = aws_cognito_user_pool.user_pool.id
}

resource "aws_ssm_parameter" "users_client_secret" {
  name        = "/${var.project}/${var.env}/client_secret"
  description = "Cognito Client Secret for managing users"
  type        = "SecureString"
  value       = aws_cognito_user_pool_client.client.client_secret
}
