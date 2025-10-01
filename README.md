# Assignment 3 – DevOps Internship (TechEazy)

Implementation of **Assignment 3** using **Terraform** and **GitHub Actions** for automated provisioning, deployment, and validation.  

---

## 📌 Requirements & Implementation

| Requirement | Implementation |
|-------------|----------------|
| Extend infra from Assignment 1 & 2 | Reused and enhanced Terraform configs (EC2, IAM roles, S3 with lifecycle). |
| Stage parameter (Dev/Prod) | Added `stage` variable in `variables.tf`. Bucket names and resource names include stage suffix. |
| Automate via CI/CD | Created GitHub Actions workflow (`.github/workflows/deploy.yml`) triggered on push to `main` or tags `deploy-*`. |
| Provision EC2 instance | Terraform `aws_instance.assignment3_instance` with IAM instance profile. |
| Install & configure app | `scripts/user_data.sh` installs Docker, Git, AWS CLI, creates `/app/logs`, and sets up shutdown log upload service. |
| Upload logs to S3 | `upload-logs.sh` pushes system logs and app logs into bucket under `/logs/system` and `/logs/app`. |
| Lifecycle rule for logs | `aws_s3_bucket_lifecycle_configuration` removes logs after 7 days. |
| Health check after deploy | Workflow includes step to poll EC2 public IP and check port 80. |

---

## 📂 Project Structure
```
tech_eazy_devops_vaishh1007/
├── .github/
│ └── workflows/
│ └── deploy.yml # GitHub Actions workflow
│
├── scripts/
│ └── user_data.sh # EC2 bootstrap + log upload script
│
├── terraform/
│ ├── main.tf # Terraform resources
│ ├── variables.tf # Input variables (region, AMI, stage, etc.)
│ ├── outputs.tf # Outputs (e.g., EC2 public IP)
│ └── terraform.tfvars # Variable overrides (optional)
│
├── .gitignore
├── README.md # Documentation (this file)
└── PROJECT_STRUCTURE.md
```
---

## ▶️ Usage

### Local Terraform (optional)

```bash
cd terraform
```

### Initialize
```bash
terraform init
```

### Validate configuration
```bash
terraform validate
```
### Preview plan
```bash
terraform plan -var="stage=dev"
```
## GitHub Actions (CI/CD)
## Workflow triggers on:

- Push to main

- Tags matching deploy-* (e.g., deploy-dev, deploy-prod)

### Steps performed:

1. Checkout code.

2. Run terraform init, terraform validate, and terraform plan.

3. Deploy resources (if enabled).

4. Run health check against EC2 instance.

---
## ⚙️ Tools Used
- Terraform – Infrastructure as Code

- AWS CLI – CLI interactions for logs upload

- GitHub Actions – CI/CD automation

- Bash – Bootstrap and log handling scripts
---
✅ This project implements all Assignment 3 requirements with Terraform, GitHub Actions, and Bash scripting.

---