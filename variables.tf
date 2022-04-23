variable "project" {
  description = "Project Name; used for tagging and naming"
  default     = "Auth"
  type        = string
}

variable "env" {
  default     = "dev"
  description = "Environment; used for tagging and naming"
  type        = string
}

variable "project_key" {
  default     = "auth"
  description = "This will be used for subdomains and naming"
  type        = string
}
variable "zone_id" {
  description = "The zone id used to create subdomains"
  type        = string
}
