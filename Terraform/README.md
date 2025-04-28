# Terraform Configuration

This folder contains the complete Infrastructure as Code (IaC) setup for deploying the Intrusion Detection System (IDS) to AWS.  
I used **Terraform** to provision and manage cloud resources across three isolated environments: **Development**, **Staging**, and **Production**.

---

## 📋 Table of Contents

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

## Main Infrastructure 



##  Best Practices Followed

- **Modularization:** Resources are split into reusable modules.
- **Environment Isolation:** Each environment manages its own VPC, ALB, ECS, S3, and IAM resources.
- **Remote State Management:** Centralized state management with locking using S3 and DynamoDB.
- **Security:** IAM roles use the principle of least privilege.
- **Version Control:** Terraform code managed under GitHub, following GitOps principles.
- **CI/CD:** Infrastructure changes automatically deployed with GitHub Actions (manual approvals for staging and prod).

---

#  Final Notes

This Terraform setup was designed for **high reliability**, **security**, **scalability**, and **operational ease**.  
It enables seamless deployment pipelines, disaster recovery via remote state, and structured team collaboration.
