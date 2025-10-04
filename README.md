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
## Lets create a file for declaring the variables.
> Note: The terraform files must be created with .tf extension. 
This is used to declare the variable and pass values to terraform source code.
<pre> vim provider.tf </pre>

## Declare the variables for initialising terraform (for terraform provider file )
<pre>variable "project_name" {
  default = "zomato"
}
variable "project_env" {
  default = "prod"
}
variable "region" {
  default = "ap-south-1"
}
variable "access_key" {
  default = "*******"
}
variable "secret_key" {
  default = "************"
}
</pre>

## Create the provider file
> Note : Terraform relies on plugins called "providers" to interact with remote systems. Terraform configurations must declare which providers they require, so that Terraform can install and use them. I'm using AWS as provider
<pre>vim provider.tf</pre>
<pre>
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
</pre>

## Creating Amazon Virtual Private Cloud.
> Amazon Virtual Private Cloud (VPC) lets you provision a logically isolated section of the Amazon Web Services (AWS) Cloud where you can launch AWS resources, such as Amazon EC2 instances, into a virtual network that you define. You have complete control over your virtual networking environment, including selecting your own IP address range, creating subnets, and configuring route tables and network gateways. A VPC is essentially your private, customizable slice of the AWS network.

The main components of an Amazon VPC are:

- Subnets
: A subnet is a range of IP addresses within your VPC. You launch AWS resources into a specified subnet, which must reside within a single Availability Zone. Subnets can be configured as public (with a route to an Internet Gateway for internet access) or private (isolated from the internet for backend resources like databases). This segregation helps with security and architecture.

- Route Tables
: A route table contains a set of rules, called routes, that are used to determine where network traffic from a subnet or gateway is directed. Every subnet in your VPC must be associated with a route table. Routes dictate how traffic is forwarded within the VPC (e.g., between subnets) and to external destinations (e.g., the internet or a corporate network).

- Internet Gateway (IGW)
: An Internet Gateway is a horizontally scaled, redundant, and highly available VPC component that allows communication between your VPC and the internet. Attaching an IGW to your VPC and configuring routes in a subnet's route table makes that subnet a public subnet, enabling resources within it to connect to the internet.

- Security Groups
: A security group acts as a virtual firewall for your instance (at the instance level) to control inbound and outbound traffic. Security groups are stateful, meaning that if you allow inbound traffic, the response traffic is automatically allowed outbound, regardless of outbound rules.

- Network Access Control Lists (Network ACLs)
: A Network ACL acts as an optional, additional layer of security for your VPC that functions as a firewall for controlling traffic in and out of one or more subnets. Network ACLs are stateless, meaning that separate rules must be created to explicitly allow both inbound and outbound traffic. They support both allow and deny rules.


