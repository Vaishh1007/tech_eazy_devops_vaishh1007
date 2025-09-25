# Assignment 2 – DevOps Internship (TechEazy)

Implementation of **Assignment 2** using **Terraform** and **Bash**.  

---

## 📌 Requirements & Implementation

| Requirement | Implementation |
|-------------|----------------|
| Create two IAM roles | `Assignment2-S3ReadOnly` (list/get), `Assignment2-S3Upload` (create/put) |
| Attach Upload-only role to EC2 | `aws_iam_instance_profile.upload_profile` attached to instance |
| Create private S3 bucket | `aws_s3_bucket.assignment2_bucket` (private, configurable name) |
| Upload EC2 logs | `scripts/user_data.sh` uploads `/var/log/cloud-init.log` → `s3://bucket/logs/system/` |
| Upload app logs | `scripts/user_data.sh` creates `/app/logs/app.log` → `s3://bucket/logs/app/` |
| Lifecycle rule (7 days) | `aws_s3_bucket_lifecycle_configuration.assignment2_lifecycle` |
| Verify with Read-only role | `null_resource.verify_s3_readonly` using `sts assume-role` |

---

# 📂 Project Structure
```
tech_eazy_devops_vaishh1007/
├── scripts/
│ └── user_data.sh
│
├── terraform/
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── terraform.tfvars
│
├── .gitignore
├── README.md
```
---
## 📌 Explanation

- **scripts/** → contains shell scripts used by EC2 instances (bootstrap, log upload).  
- **terraform/** → all Terraform code:
  - **main.tf** → defines AWS resources (IAM roles, S3 bucket, EC2 instance, lifecycle).  
  - **variables.tf** → centralizes input variables with defaults.  
  - **outputs.tf** → defines Terraform outputs for reference.  
  - **terraform.tfvars** → allows user-specific overrides.  
- **README.md** → overview of assignment, requirements, and usage instructions.  
- **PROJECT_STRUCTURE.md** → detailed explanation of repository structure.  
- **.gitignore** → ensures sensitive or generated files are not committed.  

---
✅ This structure keeps code, scripts, and documentation organized and easy to understand.  


---

## ▶️ Usage

```bash
cd terraform

# Initialize providers
terraform init

# Validate syntax
terraform validate

# Review execution plan
terraform plan

# Apply changes
terraform apply
```


✅ All assignment requirements are implemented with Terraform and Bash.