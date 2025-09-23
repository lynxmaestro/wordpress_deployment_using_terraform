# wordpress_deployment_using_terraform
Creating a wordpress site using terraform
## Building the Infrastructure.

- Creating VPC.
  
This Terraform code creates a basic AWS Virtual Private Cloud (VPC):

It defines the size of your private network using the cidr_block variable, determining your IP address range.

The VPC will use default tenancy and have DNS hostnames enabled, letting resources inside your VPC be easily named and reached.

Tags are added to help organize and identify your VPC based on your project and environment values, making management and cost tracking easier.
~~~
resource "aws_vpc" "main" {
  cidr_block           = var.main_network
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name    = "${var.project_name}-${var.project_env}-vpc"
    project = var.project_name
    env     = var.project_env
  }
}
~~~
- Internet Gateway creation
  
```
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-${var.project_env}-igw"
    project = var.project_name
    env     = var.project_env
  }
}
```
This code creates an AWS Internet Gateway and attaches it to your VPC.

An Internet Gateway acts as a bridge between your cloud network (VPC) and the wider internet, allowing resources like servers in public subnets to send and receive data from outside AWS.

The vpc_id makes sure the gateway is connected to your VPC, enabling internet access for anything inside it that has a public IP address.

Without this resource, anything inside our VPC would be completely isolated from the internet. This gateway is essential for hosting websites or services that need public access.


- Creating Public subnet using count.

 This Terraform block automatically creates three public subnets in your AWS VPC.
 The count = 3 command tells Terraform to repeat this resource three times, so you get one public subnet in each of three different availability zones.
 Each subnet receives a unique portion of your main network, making sure the IP ranges don’t overlap and are spread out for high availability.
 The map_public_ip_on_launch = true setting automatically gives any new server (EC2 instance) in these subnets a public IP address, so it can communicate directly  with the internet.

  ```
  resource "aws_subnet" "public1" {
  count                   = 3
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.main_network, 3, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project_name}-${var.project_env}-public-${count.index + 1}"
    project = var.project_name
    env     = var.project_env
  }
}
  ```

- Creating Private subnet using count.

```
  resource "aws_subnet" "private" {
  count             = 3
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.main_network, 3, "${count.index + 3}")
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-private-${count.index + 1}"
    project = var.project_name
    env     = var.project_env
  }
}
```

- Creating NAT Gateway based on condition
  - Here nat gateway created based on the variable, If the variables value is true then only this resource creation will happen.
```
resource "aws_nat_gateway" "nat" {
  count         = var.enable_nat_gw == true ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public1[1].id
  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}
```

- Creating an elastic ip address.
   - Elastic IP address is created based on the variable value. If the value of enable_nat_gw which is created as type boolean is "true" then only this resource       is created.
  ```
  resource "aws_eip" "nat" {
  count  = var.enable_nat_gw == true ? 1 : 0
  domain = "vpc"
   }
  ```

  
