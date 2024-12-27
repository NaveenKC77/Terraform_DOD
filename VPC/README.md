# VPC Module for the DOD Project

## Specifications

### VPC
* Private VPC with CIDR BLOCK : 10.0.0.0/16

### Subnets
* 2 Public Subnets with CIDR BLOCK : 10.0.0.8/1 ,10.0.0.8/2
* 2 Private Subnets with CIDR BLOCK : 10.0.0.8/3 ,10.0.0.8/4

### Internet Gateway
* 1 gateway for the vpc to connect to external network

### NAT Gateway and Elastic IP
* 1 Elastic AP associated with NAT Gateway , that allows private subnets to connect to external resources via Internet Gateway
* NAT Gateway deployed in first of the two public subnet

### Public routes
* Public subnets connected to Internet gateway via Route tables.

### Private routes
* Public subnets routed using nat gateway that connects to internet gateway

