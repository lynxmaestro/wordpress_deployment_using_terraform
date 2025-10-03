# Deploying sample wordpress website using Terraform.
Terraform is a tool for building infrastructure with various technologies including Amazon AWS, Microsoft Azure, Google Cloud, and vSphere. Here is a simple document on how to use Terraform to build an aws infrastructure and deploy a sample wordpress website.

## Features
- Easy to customise with just a quick look with terrafrom code
- AWS informations are defined using tfvars file and can easily changed
- Project name is appended to the resources that are creating which will make easier to identify the resources.

## Terraform Installation
- Create an IAM user on your AWS console that have access to create the required resources.
- Create a dedicated directory where you can create terraform configuration files.
- Download Terrafom, click here [Terraform](https://developer.hashicorp.com/terraform).
- Install Terraform, click here [Terraform installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli?in=terraform%2Faws-get-started)

  Use the following command to install Terraform.
  ```
  wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip
  unzip terraform_0.15.3_linux_amd64.zip 
  ls -l
  -rwxr-xr-x 1 root root 79991413 May  6 18:03 terraform  <<=======
  -rw-r--r-- 1 root root 32743141 May  6 18:50 terraform_0.15.3_linux_amd64.zip
  mv terraform /usr/bin/
  which terraform 
  /usr/bin/terraform
  ```
