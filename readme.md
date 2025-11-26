# AWS Scalable Web App Infrastructure - Terraform

## Overview
This project creates a scalable web application infrastructure in AWS using Terraform.  
It includes a VPC, public subnet, security groups, Auto Scaling Group (ASG) with Launch Template, and a Network Load Balancer (NLB) with health checks.

---

## Base Infrastructure
- **VPC**: 10.0.0.0/16, DNS support enabled.
- **Public Subnet**: 10.0.0.0/20, assigns public IPs.
- **Internet Gateway**: attached to VPC.
- **Route Table**: routes 0.0.0.0/0 via the Internet Gateway.

---

## Security
- **Security Group**:
  - Allows HTTP (80), HTTPS (443), and SSH (22) from anywhere.
  - Denies all other inbound traffic.
  - Egress allowed to all destinations.

---

## Compute
- **Launch Template**:
  - Ubuntu 22.04 LTS
  - Instance type: t3.medium (example)
  - User data script to install Apache/PHP.
- **Auto Scaling Group (ASG)**:
  - Minimum instances: 1
  - Maximum instances: 5
  - Desired instances: 3
  - Associated with the Launch Template
  - Attached to public subnet

### Auto Scaling Policies
- Scale out if CPU > 80%
- Scale in if CPU < 10%
- Health check type: EC2, grace period: 120s

---

## Load Balancer
- **Network Load Balancer (NLB)**
  - Public IP
  - Listeners on TCP port 80
  - Backend target group connected to ASG instances
  - Health check on port 80

---

## Deployment
1. Initialize Terraform:  
```bash
terraform init
