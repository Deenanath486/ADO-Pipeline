# Production Multi-Stage Azure DevOps CI/CD Pipelines 🔄☁️

[![Azure DevOps](https://img.shields.io/badge/Azure_DevOps-Pipelines_YAML-0078D7?style=flat&logo=azure-devops&logoColor=white)](https://azure.microsoft.com/en-us/products/devops/)
[![Terraform](https://img.shields.io/badge/IaC-Terraform_1.5+-844FBA?style=flat&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Multi-Stage](https://img.shields.io/badge/Workflow-Multi--Stage_Approval_Gate-success)](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/stages)
[![Environment](https://img.shields.io/badge/Environments-Dev_%7C_Prod-blue)](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments)

Enterprise-grade **Azure DevOps (ADO) Multi-Stage YAML Pipelines** automating Terraform delivery across multiple environments (**Development** and **Production**). Built with modular template reusability, artifact publishing, and manual environment approval gates.

---

## 🏗️ Multi-Stage Pipeline Architecture

```text
 ┌────────────────────────────────────────────────────────────────────────────────────────┐
 │                      AZURE DEVOPS MULTI-STAGE YAML PIPELINE                            │
 └────────────────────────────────────────────────────────────────────────────────────────┘
          │
          ▼
   [ Trigger: Git Push / PR to main ]
          │
          ▼
   ┌──────────────────────────────────────────────────────┐
   │ STAGE 1: Lint & Validate                             │
   │  • Terraform fmt -check                              │
   │  • Terraform init (Validation backend)               │
   │  • Terraform validate                                │
   └──────────────────────────┬───────────────────────────┘
                              │
                              ▼
   ┌──────────────────────────────────────────────────────┐
   │ STAGE 2: Plan (Dev Environment)                      │
   │  • Terraform init (Dev Remote State)                 │
   │  • Terraform plan -out=dev.tfplan                    │
   │  • Publish Build Artifact: tfplan-dev                │
   └──────────────────────────┬───────────────────────────┘
                              │
                              ▼ (Only on main branch merge)
   ┌──────────────────────────────────────────────────────┐
   │ STAGE 3: Apply (Dev Environment)                     │
   │  • Download Build Artifact: tfplan-dev               │
   │  • Terraform apply dev.tfplan                        │
   └──────────────────────────┬───────────────────────────┘
                              │
                              ▼
   ┌──────────────────────────────────────────────────────┐
   │ STAGE 4: Plan (Prod Environment)                     │
   │  • Terraform init (Prod Remote State)                │
   │  • Terraform plan -out=prod.tfplan                   │
   │  • Publish Build Artifact: tfplan-prod               │
   └──────────────────────────┬───────────────────────────┘
                              │
                              ▼
   ┌──────────────────────────────────────────────────────┐
   │ [ ENVIRONMENT APPROVAL GATE: PRODUCTION ]            │
   │  ⏳ Awaits Lead / CAB Approval in Azure DevOps Portal │
   └──────────────────────────┬───────────────────────────┘
                              │ (Approved)
                              ▼
   ┌──────────────────────────────────────────────────────┐
   │ STAGE 5: Apply (Prod Environment)                    │
   │  • Download Build Artifact: tfplan-prod              │
   │  • Terraform apply prod.tfplan                       │
   └──────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```text
.
├── azure-pipelines.yml             # Main Multi-Stage Pipeline orchestration
├── pipelines/
│   └── templates/                  # Reusable modular pipeline templates
│       ├── terraform-plan.yml      # Standardized Init + Plan + Artifact Publish
│       └── terraform-apply.yml     # Standardized Download + Apply
├── environments/
│   ├── dev/                        # Development Environment
│   │   ├── providers.tf            # Remote state backend configuration
│   │   ├── variables.tf            # Dev variables (CIDRs, Skus)
│   │   └── main.tf                 # Dev Resource Group, VNet, Subnets
│   └── prod/                       # Production Environment
│       ├── providers.tf            # Remote state backend configuration
│       ├── variables.tf            # Prod variables
│       └── main.tf                 # Prod Resource Group, VNet, Subnets
├── .gitignore                      # Ignores local state and caches
└── README.md
```

---

## ⚙️ Prerequisites & Setup Guide

### 1. Azure Service Connection (Azure DevOps)
Create an Azure Resource Manager Service Connection in Project Settings:
- **Type**: `Azure Resource Manager`
- **Authentication**: `Workload Identity federation` (Recommended) or `Service Principal (automatic)`
- **Name**: `azure-service-connection` (Matches variable in `azure-pipelines.yml`).

### 2. Remote State Storage Account
Create the centralized state storage account in Azure:
```bash
az group create --name rg-terraform-state-mgmt --location centralindia
az storage account create --name sttfstateenterpriseprod --resource-group rg-terraform-state-mgmt --sku Standard_LRS --encryption-services blob
az storage container create --name tfstate --account-name sttfstateenterpriseprod
```

### 3. Setup Approval Gates (Production Environment)
1. Go to **Azure DevOps** ➔ **Pipelines** ➔ **Environments**.
2. Create environment `production`.
3. Click **Approvals and checks** ➔ **Approvals**.
4. Add your Lead DevOps / CAB Approver group.

---

## 🔒 Security Best Practices Implemented

1. **State Isolation**: Separate state files (`dev.terraform.tfstate` and `prod.terraform.tfstate`) in encrypted blob storage.
2. **Immutable Plans**: Apply stages strictly consume the pre-generated `tfplan` artifact produced during the Plan stage.
3. **Branch Protection**: Apply stages only execute upon merging into the protected `main` branch.
4. **Environment Isolation**: Production deployments require designated human approval gates before executing changes.

---

## 👨‍💻 Author

**Deenanath Yadav**  
*DevOps & Azure Cloud Engineer*  
- **LinkedIn**: [linkedin.com/in/deenanath-yadav-495110146](https://www.linkedin.com/in/deenanath-yadav-495110146)  
- **Email**: [deenanathyadav106@gmail.com](mailto:deenanathyadav106@gmail.com)
