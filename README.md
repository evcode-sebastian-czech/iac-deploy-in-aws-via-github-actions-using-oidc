# Deploy IaC in AWS via GitHub actions using OIDC

Simple repository created to deploy infrastructure using Terraform into AWS cloud by GitHub Action using OpenID Connect. Whole integration between AWS and GitHub was configured using [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) by:
1. adding identity provider in AWS
1. configuring the role and trust policy (code for [IAM role and policy configuration is available in oidc subfolder](oidc)):
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Federated": "${var.github_provider_arn}"
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
    ```
2. updating your GitHub Actions workflow by:
    * adding permissions settings:
    ```
    permissions:
    id-token: write
    ```
    * requesting the access token:
    ```
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
            role-to-assume: arn:aws:iam::1234567890:role/GitHubActionsAwsOIDCRole
            role-session-name: github-aws-session
            aws-region: us-east-1
    ```
