variable "region" {
  type    = string
  default = "us-east-1"
}

variable "github_url" {
  type    = string
  default = "https://token.actions.githubusercontent.com"
}

variable "github_aud" {
  type    = string
  default = "sts.amazonaws.com"
}

variable "github_thumbprint" {
  type    = string
  default = "6938fd4d98bab03faadb97b34396831e3780aea1"
}
