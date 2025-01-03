# Detailed VPC and Application Server Infrastructure Setup for the DOD Project

## VPC Configuration

### VPC

* Type: Private

* CIDR Block: 10.0.0.0/16

* This Virtual Private Cloud (VPC) forms the foundational network layer for the entire project, enabling controlled access and segmentation of resources.

### Subnets

#### Public Subnets:

* Count: 2

* CIDR Blocks:

* 10.0.0.8/1

* 10.0.0.8/2

* Purpose: These subnets are exposed to the internet and host resources such as the bastion host, load balancer, and NAT Gateway.

#### Private Subnets:

* Count: 2

* CIDR Blocks:

    * 10.0.0.8/3

    * 10.0.0.8/4

* Purpose: These subnets are isolated from direct internet access, hosting private servers and application resources.

### Internet Gateway (IGW)

* Count: 1

* Purpose: Enables connectivity between the VPC and external networks for public-facing resources.

### NAT Gateway and Elastic IP

#### Elastic IP:

* Count: 1

* Purpose: Provides a static public IP address for the NAT Gateway.

#### NAT Gateway:

* Deployment Location: First public subnet.

* Purpose: Allows private subnets to securely access external resources, such as downloading packages or updates, through the Internet Gateway.

### Routing Tables

#### Public Routes:

* Association: Public subnets.

* Route Configuration: Routes traffic to the Internet Gateway for external connectivity.

#### Private Routes:

* Association: Private subnets.

* Route Configuration: Routes traffic to the NAT Gateway, which then connects to the Internet Gateway for secure external access.

## Application Server Infrastructure

### Bastion Host

* Location: First public subnet.

* Purpose: Acts as a secure jump server to provide SSH access to private instances within the VPC.

* Configuration:

    * Hosted in the public subnet to allow controlled external access.

    * Secured using security groups to restrict SSH access to specific IP ranges.

### Agent Server

* Type: Private Instance

* Purpose:

    * Listens for Bitbucket webhook triggers upon code merges to the main branch.

    * Pulls the latest codebase from Bitbucket.

    * Runs composer install to resolve dependencies.

    * Packages the application as a zip archive.

    * Uploads the zip archive to an Amazon S3 bucket for deployment.

* Access: Managed via the Bastion Host.
### Setup Server

* Type: Private Instance

* Purpose:

    * Acts as a reference instance for the private servers in the Auto Scaling Group (ASG).

    * Retrieves the application package from S3 and deploys it using an Apache server.

    * Configured to create a Custom AMI after deployment.

    * This AMI is used as the base for the launch template of the Auto Scaling Group.

### Application Servers

#### Load Balancer:

* Location: Public subnet.

* Type: Internet-facing.

* Purpose: Distributes incoming requests to the target group.

#### Target Group:

* Association: Connects the Load Balancer to the Auto Scaling Group.

* Purpose: Ensures traffic is routed to healthy application instances.

#### Auto Scaling Group (ASG):

* Location: Private subnets.

* Purpose: Hosts application servers that:

    * Serve requests routed from the Load Balancer.

    * Scale dynamically based on traffic and performance metrics.

* Configuration:

    * Uses the Custom AMI created by the Setup Server.

    * Ensures redundancy and high availability by spanning multiple private subnets.

## Deployment Workflow

* Code is merged to the main branch in Bitbucket.

* Agent Server pulls the latest code and prepares the application package.

* Application package is uploaded to S3.

* Setup Server retrieves the package, deploys it, and creates a Custom AMI.

* Auto Scaling Group uses the AMI to launch new application servers as needed.

* Load Balancer routes incoming traffic to healthy application servers in the ASG.

**This setup ensures a highly secure, scalable, and fault-tolerant infrastructure for the DOD project, leveraging AWS best practices and Terraform for resource provisioning.**