# Day 5 — AWS Hosting Architecture Plan

## Project Goal

Deploy the portfolio website using AWS, Terraform, and GitHub Actions.

## Planned Architecture

1. GitHub stores the website source code.
2. Terraform defines and manages the AWS infrastructure.
3. Amazon S3 stores the static website files.
4. Amazon CloudFront serves the website to visitors.
5. CloudFront Origin Access Control (OAC) allows access to the private S3 origin.
6. GitHub Actions automates deployment after code changes.
7. AWS IAM and OpenID Connect (OIDC) provide scoped authentication for GitHub Actions.

## Security Decisions

- Keep the S3 origin private.
- Use least-privilege IAM permissions.
- Prefer OIDC over long-lived AWS access keys.
- Never commit credentials, secrets, or Terraform state files.
- Review all infrastructure changes before applying them.

## Cost Management

- Review AWS pricing before creating resources.
- Check available billing alerts and budgets.
- Avoid optional resources that are not needed for the initial project.
- Monitor usage and remove resources when they are no longer required.
- Confirm current pricing and free-tier eligibility rather than assuming services are free.

## Planned Implementation Order

1. Review prerequisites and AWS costs.
2. Write and validate Terraform configuration.
3. Create the required AWS resources.
4. Upload and test the website.
5. Configure secure GitHub Actions deployment.
6. Test the deployment and document the results.

## Current Status

This is a proposed design. The AWS resources have not yet been created or tested as part of this plan.
