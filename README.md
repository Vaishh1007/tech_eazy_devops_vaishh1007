# TechEazy DevOps Assignment - Lift & Shift

## Steps

## 1. Clone repo:
```bash
git clone <your-repo-url>
cd tech_eazy_devops_<yourname>
```



## 2. Terraform setup:
```bash
cd terraform
terraform init
terraform apply -auto-approve

```


## 3. Get the public IP:
```bash
terraform output instance_public_ip

```
## 4. Open in browser:
```bash
http://<public-ip>
```

## 5. Destroy resources to save cost:
```bash
terraform destroy -auto-approve
```

## Notes

- Stage selection via `stage` variable (dev or prod)
- Instance auto-shutdown configurable via `shutdown_minutes`
- App runs on port 80 through Nginx reverse proxy
- Java version: OpenJDK 21
- No secrets are stored in the repo
