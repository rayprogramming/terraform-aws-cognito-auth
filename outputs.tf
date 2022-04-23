output "api_endpoint" {
  description = "The API subdomain resource for authenticating users"
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}
