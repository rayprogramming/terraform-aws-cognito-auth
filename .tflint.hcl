plugin "aws" {
  enabled = true
  version = "0.13.3"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

config {
  plugin_dir = "~/.tflint.d/plugins"

  module = true
  disabled_by_default = false
}

rule "terraform_unused_declarations" {
  enabled = true
}
rule "aws_instance_previous_type" {
  enabled = false
}
rule "terraform_naming_convention" {
  enabled = true
}
rule "terraform_required_providers" {
  enabled = true
}
rule "terraform_typed_variables" {
  enabled = true
}
rule "terraform_standard_module_structure" {
  enabled = true
}
