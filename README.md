# Deploy IaC in AWS via GitHub actions using OIDC

Simple repository created to deploy infrastructure using Terraform into AWS cloud by GitHub Action using OpenID Connect. Whole integration between AWS and GitHub was configured using [Configuring OpenID Connect in Amazon Web Services](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) by:
1. adding identity provider in AWS
1. configuring the role and trust policy
1. updating your GitHub Actions workflow by:
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
        role-to-assume: arn:aws:iam::884522662008:role/GitHubActionsOIDC
        role-session-name: GitHubActionsOIDC
        aws-region: us-east-1
    ```