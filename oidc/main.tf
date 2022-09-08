data "aws_iam_openid_connect_provider" "github_provider" {
  arn = "arn:aws:iam::884522662008:oidc-provider/token.actions.githubusercontent.com"
}

data "aws_iam_role" "github_role" {
  name = "GitHubActionsOIDC"
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
				"Federated": "arn:aws:iam::884522662008:oidc-provider/token.actions.githubusercontent.com"
			},
			"Action": "sts:AssumeRoleWithWebIdentity",
			"Condition": {
				"StringEquals": {
					"token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
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