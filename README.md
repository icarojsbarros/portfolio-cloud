# Automated Cloud Infrastructure Deployment with Terraform & GitHub Actions

## Project Overview
This project demonstrates an **Infrastructure as Code (IaC)** pipeline designed to deploy a containerized application on AWS. It showcases the automation of cloud resource provisioning, network security configuration, and application deployment using industry-standard DevOps tools.

**Goal:** To simulate a real-world scenario where infrastructure is versioned, auditable, and immutable.

---

## 🏗 Architecture

The project provisions a Linux server (Ubuntu) on AWS, configures a firewall (Security Group), and automatically bootstraps a Docker container running Nginx.

```mermaid
graph TD;
    User((Internet User)) -->|HTTP:80| FW[AWS Security Group];
    subgraph AWS ["AWS Cloud (us-east-1)"]
        FW -->|Allow| EC2[EC2 Instance (t3.micro)];
        subgraph Instance ["EC2 Instance"]
            Docker[Docker Engine] -->|Runs| App[Nginx Container];
        end
    end
