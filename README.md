# AWS Event Driven Lambda

This is a sample project to demonstrate how to build an event driven lambda function using AWS Lambda, S3, EventBridge and CloudWatch.

# Table of Contents
- [AWS Event Driven Lambda](#aws-event-driven-lambda)
- [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
    - [Install Dependencies](#install-dependencies)
    - [Configure AWS Credentials](#configure-aws-credentials)
  - [Architecture Overview](#architecture-overview)
  - [Deploy infrastructure](#deploy-infrastructure)
  - [Sources](#sources)


## Prerequisites

### Install Dependencies

**Technologies**: Clojure, Terraform, Jenkins and AWS<br>
**Versions**: Leiningen 2.9.10, Java 19 (Corretto), Terraform v1.5.0, Jenkins 2.263.4

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Jenkins](https://www.jenkins.io/doc/book/installing/)
- [Leiningen](https://leiningen.org/#install)

### Configure AWS Credentials

The AWS provider is used to interact with resources supported by AWS. The provider must be configured with proper credentials before usage. 

The AWS CLI stores sensitive credential information that you specify with aws configure in a local file named credentials, in a folder named .aws in the home directory.

`~/.aws/credentials`

```shell
[default]
aws_access_key_id = <some-access-key>
aws_secret_access_key = <some-secret-access-key>
```

`~/.aws/config`

```shell
[default]
region = us-west-2
output = json
```
> Read more about AWS Configure [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

The Terraform AWS provider can source credentials from the `~/.aws` directory. If no named profile is specified, the default profile is used.

## Architecture Overview

![](resources/diagrams/architecture-overview.png)

## Deploy infrastructure 

Navigate to the `/infrastructure/ias` directory
```shell
# see infrastructure changes
terraform plan 

# deploy changes
terraform apply 
```

## Sources

* [AWS Configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)