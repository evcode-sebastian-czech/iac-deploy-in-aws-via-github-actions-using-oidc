output "github_provider" {
  value = data.aws_iam_openid_connect_provider.github_provider
}

output "github_role" {
  value = data.aws_iam_role.github_role
}

output "github_aws_oidc_role" {
  value = aws_iam_role.github_aws_oidc_role
}

output "github_aws_oidc_policy" {
  value = aws_iam_policy.github_aws_oidc_policy
}