# Terraform Configuration

This folder contains the complete Infrastructure as Code (IaC) setup for deploying the Intrusion Detection System (IDS) to AWS.  
I used **Terraform** to provision and manage cloud resources across three isolated environments: **Development**, **Staging**, and **Production**.

---

##  Table of Contents

- [Directory Structure](#Directory-Structure)
- [Modules](#modules)
- [Environment Setup](#environment-setup)
- [Backend Configuration (State Management)](#backend-configuration-state-management)
- [Deployment Workflow](#deployment-workflow)
- [Code Quality and Validation](#code-quality-and-validation)
- [Best Practices Followed](#best-practices-followed)

---

## Directory-Structure

```
Terraform/
├── backend/
│   ├── main.tf
│   ├── provider.tf
│   ├── variables.tf
│   └── terraform.tfvars
├── terraform/
│   ├── Environments/
│   │   ├── Development/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   ├── outputs.tf
│   │   │   ├── backend.tf
│   │   │   ├── terraform.tfvars.tf
│   │   ├── Staging/
│   │   └── Production/
│   └── Modules/
│       ├── ALB/
│       ├── ECS/
│       ├── ECR/
│       └── VPC/
└── README.md
```

---
## Requirements

- AWS account credentials configured (via AWS CLI or environment variables).
- Terraform installed (v1.0+).

# Remote Backend Configuration

This folder contains the Terraform configuration for setting up the **remote backend** required for managing the state files of the Intrusion Detection System (IDS) project.

### Why Remote Backend?

Using a remote backend ensures:

- Centralized state storage.
- Team collaboration with locking to prevent simultaneous changes.
- Safer operations (no risk of local file loss).

**Note:** Future improvements will be made where only S3 would be used as it now supports native state locking.

## Setup Instructions

Now we are going to provision the S3 and DynamoDB resources. 

### **Step 1:** Navigate to the backend directory
Assuming you're are in the project's root directory, go into the terraform backend directory by running the following in the termainal.
```bash
cd Terraform/backend
```
### **Step 2:** Update the S3 bucket name
In AWS, each S3 buckets name must be unique, not just within your account, but globally. Hence you must choose a unique name for your S3 bucket.

Open `terraform.tfvars` file and edit the `backend_bucket`, using a unique bucket name. For example:
```hcl
backend-bucket = "your-unique-terraform-state-bucket"
```

### **Step 3:** Initilize terraform
Now run the following commands:
```bash
terraform init
```
Terraform init initializes the backend and downloads the required providers.

### **Step 4:** Plan and Review Changes
Next:
```bash
terraform plan
```
terraform plan simulates what changes to be made such as resources to be created or destroyed without actually making them, giving a detailed preview.

### **Step 5:** Apply the Configuration
```bash
terraform apply -auto-approve
```
Creates the backend infrastructure in AWS.

**Now your remote backend configuration is complete**

# Main Infrastructure 

This folder contains the complete Infrastructure as Code (IaC) setup for deploying the Intrusion Detection System (IDS) to AWS using Terraform.

## Environment Overview

Each environment (`Development`, `Staging`, `Production`) has:

- `main.tf`: Imports modules and wires resources together.
- `terraform.tfvars`: Defines environment-specific values like VPC CIDRs, subnet CIDRs, cluster names, etc.
- `variables.tfvars`

Example `terraform.tfvars`:

```hcl
vpc_cidr = "10.0.0.0/16"
ecs_cluster_name = "ids-cluster-dev"
```
**Note: You can leave the default values as they are unless you wish to use a different naming convention.** 

## Environment setup

**NOTE: Perform the following steps for each Environment**

### **Step 1:** Navigate to the Environment directory 

Navigate into the `Environments` directory and then select the environment you wish to deploy (we'll be using the `Development` environment)

```bash
cd Terraform/terraform/Environments/Development
```

### **Step 2:** Update the State resources
In the previous steps, the name of the S3 bucket was changed. Now we're going to update the backend configuration of this environment to use the S3 bucket.

Open `main.tf` file and edit the `bucket` variable, using the bucket name you selected in the backend configuration. As such:
```hcl
bucket = "your-unique-terraform-state-bucket"
```


---
**WE WILL NOT BE MANUALLY PROVISIONING THE ENVIRONMENT RESOURCES, THAT WILL BE HANDLED BY THE CI/CD PIPELINE**

##  Best Practices Followed
- **Modularization:** Resources are split into reusable modules.
- **Environment Isolation:** Each environment manages its own VPC, ALB, ECS, S3, and IAM resources.
- **Remote State Management:** Centralized state management with locking using S3 and DynamoDB.
- **Version Control:** Terraform code managed under GitHub, following GitOps principles.
- **CI/CD:** Infrastructure changes automatically deployed with GitHub Actions (manual approvals for staging and prod).

---

#  Final Notes

This Terraform setup was designed for **high reliability**, **security**, **scalability**, and **operational ease**.  
It enables seamless deployment pipelines, disaster recovery via remote state, and structured team collaboration.
