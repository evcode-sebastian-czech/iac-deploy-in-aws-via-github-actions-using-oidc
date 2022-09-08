variable "region" {
  type    = string
  default = "us-east-1"
}

variable "github_provider_arn" {
  type    = string
  default = "arn:aws:iam::884522662008:oidc-provider/token.actions.githubusercontent.com"
}