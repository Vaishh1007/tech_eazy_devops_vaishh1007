# 🚀 TechEazy DevOps – Assignment 2

This is the **second assignment** for TechEazy DevOps internship.  
It extends the automation from **Assignment 1 (EC2 + app deployment)** by adding **IAM Roles, S3 bucket, and log archival**.  

---

## ✅ What’s New in Assignment 2
1. **IAM Roles**
   - **Role A (ReadOnly)** → Can only list objects in S3.  
   - **Role B (WriteOnly)** → Can create bucket + upload logs, but cannot read/download.  
   - EC2 instance runs with **Role B** (via Instance Profile).  

2. **Private S3 Bucket**
   - Bucket name is passed as a Terraform variable `bucket_name`.  
   - If no name is given → deployment fails.  

3. **Log Uploads**
   - **System logs**: `/var/log/cloud-init.log` → `s3://<bucket>/system/`  
   - **App logs**: `/home/ubuntu/app.log` → `s3://<bucket>/app/logs/`  

4. **Lifecycle Rule**
   - Logs auto-delete after **7 days**.  

5. **Verification**
   - Role A used to verify bucket contents (can **list files** but not download).  

---

## ⚡ How to Deploy

1. Clone repo and go to terraform folder:  
   ```bash
   cd terraform
2. Initialize Terraform:

```bash

terraform init
```
3. Apply with bucket name (must be unique in AWS):

```bash

terraform apply -var="bucket_name=techeazy-logs-yourname"
```
4. Get EC2 Public IP:

```bash

terraform output instance_public_ip
```
5. Access application in browser:
```bash
http://<public-ip>:8080
```
## 📂 Verify Logs in S3
1. SSH into EC2 and check app log:

```bash

cat /home/ubuntu/app.log
```
2. Confirm logs in S3 bucket:

```bash

aws s3 ls s3://techeazy-logs-yourname/app/logs/
aws s3 ls s3://techeazy-logs-yourname/system/
```
3. Test Role A (ReadOnly):

```bash

# Should work
aws s3 ls s3://techeazy-logs-yourname/

# Should fail
aws s3 cp s3://techeazy-logs-yourname/app/logs/app.log .
```
## 🛑 Cleanup

To destroy resources and avoid charges:

```bash

terraform destroy -var="bucket_name=techeazy-logs-yourname" -auto-approve
```
## 🎯 Summary
✅ Added IAM Roles (ReadOnly + WriteOnly).

✅ EC2 uploads system & app logs to S3.

✅ Logs expire after 7 days.

✅ Verified with restricted IAM role access.
