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




## Day 15 — AWS Infrastructure Deployment Verification

### Infrastructure deployed
- AWS S3 bucket
- S3 versioning and encryption
- S3 Block Public Access
- S3 ownership controls
- CloudFront distribution
- CloudFront Origin Access Control (OAC)
- Restrictive S3 bucket policy

### Security configuration
- S3 public access blocked.
- S3 encryption enabled using AES-256.
- Bucket versioning enabled.
- CloudFront uses signed requests through OAC.
- Bucket policy grants CloudFront s3:GetObject access.
- No public bucket access is granted.

### Deployment verification
- AWS account and region verified.
- S3 bucket existence verified.
- CloudFront distribution status checked.
- OAC configuration checked.
- Terraform configuration validated.
- Terraform plan reviewed.

### Next milestone
Upload website files to the private S3 bucket and test delivery through CloudFront.


## Day 16 — Website Deployment to Amazon S3

### Deployment objective
Upload the static website files to the private Amazon S3 bucket.

### Files deployed
- index.html
- styles.css

### Deployment method
AWS CLI using the `aws s3 sync` command.

### S3 destination
aws-cloud-portfolio-058264072079-website

### Verification
- Confirmed AWS account and region.
- Previewed upload using --dryrun.
- Uploaded website files to S3.
- Verified uploaded objects using aws s3 ls.
- Inspected object metadata using head-object.

### Security
- S3 Block Public Access remains enabled.
- No public-read ACL was applied.
- CloudFront OAC remains the authorised access mechanism.

### Next milestone
Test website delivery through the CloudFront distribution.


## Day 17 — CloudFront Website Delivery Testing

### Objective
Verify that the static website is accessible through CloudFront.

### Website endpoint
https://dxlisw2u97auo.cloudfront.net

### Tests performed
- Homepage HTTP response checked.
- HTML content retrieval tested.
- CSS delivery tested.
- CloudFront distribution status verified.
- Default root object verified.
- Direct anonymous S3 object access tested.

### Security verification
- S3 bucket remains private.
- CloudFront accesses S3 through Origin Access Control.
- Direct anonymous S3 access is denied.

### Troubleshooting knowledge
- HTTP status codes.
- CloudFront caching.
- S3 AccessDenied errors.
- Browser Developer Tools and Network inspection.

### Next milestone
Study CloudFront error handling and understand how to diagnose website delivery failures.

## Day 18 — CloudFront Error Handling and Troubleshooting

### Objective
Investigate HTTP responses and understand how CloudFront delivers content from a private S3 bucket.

### Tests performed

1. Checked the CloudFront homepage response using `curl.exe -I`.
2. Requested a deliberately missing file using `curl.exe -i`.
3. Verified that `index.html` and `styles.css` exist in the S3 bucket.
4. Tested a missing S3 object using `aws s3api head-object`.
5. Verified the CloudFront distribution status and default root object.
6. Used `curl.exe -v` to inspect connection and response details.

### Key concepts learned

- HTTP 200 indicates a successful request.
- HTTP 403 indicates that access was denied.
- HTTP 404 indicates that a resource was not found.
- HTTP 503 indicates that a service is temporarily unavailable.
- A private S3 bucket may return 403 for a missing object when the requester cannot list the bucket.
- CloudFront uses Origin Access Control (OAC) to securely retrieve content from the private S3 bucket.
- CloudFront caching can affect how quickly website changes become visible.

### My test results

- Homepage HTTP status: [Insert actual result]
- Missing CloudFront file HTTP status: [Insert actual result]
- S3 index.html object check: [Success/Failure]
- S3 styles.css object check: [Success/Failure]
- Missing S3 object check: [Expected failure/Other]
- CloudFront distribution status: [Insert actual result]

### Security observation

The S3 bucket remains private. I did not enable public access or weaken the bucket policy to troubleshoot website delivery.

### Conclusion

I practised diagnosing website delivery issues by checking HTTP response codes, CloudFront distribution status, S3 object existence and connection details. I now understand why an HTTP error should be investigated before changing infrastructure permissions.


## Day 19 — CloudFront Caching and Invalidation

### Objective
Understand how CloudFront caches website content and how to refresh cached objects after website updates.

### Activities completed

1. Checked CloudFront homepage and CSS response headers.
2. Inspected the CloudFront default cache behaviour and cache policy.
3. Learned about cache hits, cache misses and TTL.
4. Added a harmless comment to the website CSS file.
5. Uploaded the updated CSS file to the private S3 bucket.
6. Created a CloudFront invalidation for `/styles.css`.
7. Checked the invalidation status until it completed.
8. Verified that CloudFront delivered the updated CSS file.

### Key concepts learned

- Caching stores copies of website content at CloudFront edge locations.
- A cache hit means CloudFront can serve a valid cached copy.
- A cache miss means CloudFront needs to retrieve the content from its origin.
- TTL determines how long content can remain fresh in the cache.
- CloudFront invalidation removes specified cached objects.
- Invalidation does not delete the original S3 objects.
- Targeted invalidations are preferable to invalidating the entire distribution unnecessarily.

### Test results

- CloudFront homepage response: [HTTP/1.1 200 OK]
- CSS response: [HTTP/1.1 200 OK]
- Cache policy inspected: [Yes]
- CSS uploaded to S3: [Success]
- Invalidation created: [Success]
- Invalidation status: [Completed]
- Updated CSS verified through CloudFront: [Yes]

### Security observation

The S3 bucket remains private. CloudFront continues to access S3 through Origin Access Control (OAC). No public bucket access was enabled.

### Conclusion

I learned how CloudFront caching improves website delivery and how invalidation can be used to make updated content available to visitors. I also practised using AWS CLI to create and verify invalidation requests.



## Day 20 — GitHub Actions and Continuous Integration

### Objective
Introduced GitHub Actions and created an automated Terraform validation workflow.

### Workflow
Created `.github/workflows/terraform-check.yml`.

The workflow runs when:
- Code is pushed to the main branch.
- A pull request targets the main branch.
- The workflow is manually started.

### Automated checks
1. Checkout repository.
2. Set up Terraform.
3. Check Terraform formatting.
4. Initialize Terraform without a remote backend.
5. Validate Terraform configuration.

### Security
The workflow does not require AWS credentials because it performs static Terraform validation only. It does not deploy or modify AWS resources.

### Result
Record the workflow run result:
- [ ] Successful
- [ ] Failed — troubleshooting required


## Day 21 — Secure AWS Authentication with GitHub OIDC

### Objective
Configured GitHub Actions to authenticate with AWS securely using OpenID Connect.

### IAM configuration
- Created or verified the GitHub OIDC identity provider.
- Created CloudPortfolioGitHubActionsRole.
- Restricted the trust policy to the aws-cloud-portfolio repository's main branch.
- Attached CloudPortfolioWebsiteDeploymentPolicy.

### Permissions granted
- S3 ListBucket
- S3 PutObject
- S3 DeleteObject
- CloudFront CreateInvalidation

### Security
- No long-term AWS access keys stored in GitHub.
- Role access restricted through the OIDC trust policy.
- Permissions limited to the project S3 bucket and CloudFront distribution.

### Result
- [ ] OIDC provider verified or created.
- [ ] IAM role created.
- [ ] Trust policy restricted to repository and branch.
- [ ] Deployment permissions attached.
- [ ] Configuration reviewed.

