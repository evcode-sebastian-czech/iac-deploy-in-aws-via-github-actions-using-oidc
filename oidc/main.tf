data "tls_certificate" "github" {
  url = var.github_url
}

resource "aws_iam_openid_connect_provider" "github_provider" {
  url             = var.github_url
  client_id_list  = [var.github_aud]
  thumbprint_list = concat([for item in data.tls_certificate.github.certificates : item.sha1_fingerprint], [var.github_thumbprint])
}

resource "aws_iam_role" "github_aws_oidc_role" {
  name = "GitHubActionsAwsOIDCRole"

  assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Principal": {
				"Federated": "${aws_iam_openid_connect_provider.github_provider.arn}"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringLike": {
					"token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:evcode-sebastian-czech/iac-deploy-in-aws-via-github-actions-using-oidc:*"
				}
			}
		}
	]
}
EOF
}

resource "aws_iam_policy" "github_aws_oidc_policy" {
  name        = "GitHubActionsAwsOIDCPolicy"
  description = "Policy allowing to create DynamoDB table by GitHub Actions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "github_aws_oidc_policy_attachment" {
  role       = aws_iam_role.github_aws_oidc_role.name
  policy_arn = aws_iam_policy.github_aws_oidc_policy.arn
}