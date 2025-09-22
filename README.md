# TechEazy DevOps Assignment

This repo contains Terraform + scripts to deploy the sample app on AWS EC2.

## Steps

1. Clone this repo  
   ```bash
   git clone https://github.com/yourname/tech_eazy_devops_yourname.git
   cd tech_eazy_devops_yourname/terraform
2. Initialize Terraform

```bash
terraform init
```
3. Deploy EC2 instance

```bash
terraform apply -auto-approve

```

4. Get Public IP
```bash
terraform output instance_public_ip

```
5. Access the app at
```bash
http://<public-ip>:8080
```
6. Destroy when done

```bash

terraform destroy -auto-approve
```
