# AWS Secure Web Infrastructure (Terraform)
![Terraform](https://img.shields.io/badge/terraform-%237B42BC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

**Project Status:** *Active Development*

This project implements a secure, scalable web infrastructure on AWS using **Terraform** as an Infrastructure as Code (IaC) tool. The goal is to provision a custom Virtual Private Cloud (VPC) with strict security rules, hosting a Dockerized web server.

## Architecture Design

The infrastructure is designed with security-first principles, avoiding default VPCs and using explicit network isolation.

```
graph TD
    User((Internet User)) -->|HTTP: 80| IGW[Internet Gateway]
    IGW -->|Route Table| VPC[AWS VPC 10.0.0.0/16]
    
    subgraph VPC [Virtual Private Cloud]
        subgraph Public_Subnet [Public Subnet 10.0.1.0/24]
            direction TB
            SG[Security Group<br/>(Firewall)]
            EC2[EC2 Instance<br/>t2.micro]
            Docker[Docker Container<br/>Nginx Web Server]
        end
    end

    SG -.->|Allow: 80, 22| EC2
    EC2 --> Docker
```

## Tech Stack
- Cloud Provider: AWS (Amazon Web Services)
- IaC: Terraform v1.5+
- Compute: EC2 (Amazon Linux 2023)
- Containerization: Docker & Nginx
- Scripting: Bash (User Data Provisioning)

## Features (Planned)
- [x] Project Initialization: Provider configuration & state setup.
- [ ] Networking: Custom VPC, Subnets, Internet Gateway.
- [ ] Security: Granular Security Group rules (SSH/HTTP only).
- [ ] Compute: Automated EC2 provisioning with bootstrapping scripts.
- [ ] State Management: S3 Backend for team collaboration.

