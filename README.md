# Origin Access Identity

Custom AWS CloudFormation resource to obtain an origin access identity (OAI).
An OAI is a security principal that a CloudFront distribution assumes to
authorize operation of an S3 origin.

An OAI cannot be provisioned through the console nor through CloudFormation.
This resource manages the lifecyce of an OAI provisioned via CloudFormation.


