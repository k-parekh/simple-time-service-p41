# Simple Time Service – Application & Infrastructure

This repository contains **two major parts**:

1. **Application** – a containerized FastAPI service that returns the current UTC timestamp
2. **Infrastructure** – Terraform code to provision Azure infrastructure and run the container using **Azure Container Apps**

This README is written for **beginners**, including people with **no prior DevOps or cloud experience**. Follow the steps in order and you will be able to run the app locally, in Docker, and in Azure.

---

## Repository Structure

```
simple-time-service-p41/
├── simple_time_service/
│   ├── Dockerfile
│   ├── README.md
│   ├── docker-compose.yml
│   ├── requirements.txt
│   ├── simple_time_service.py
│   └── test_simple_time_service.py
│
├── terraform/
│   ├── .terraform.lock.hcl
│   ├── README.md
│   ├── backend.tf
│   ├── container_app.tf
│   ├── container_apps_env.tf
│   ├── locals.tf
│   ├── log_analytics.tf
│   ├── networks.tf
│   ├── output.tf
│   ├── provider.tf
│   ├── resource_group.tf
│   ├── terraform.tfvars
│   └── variables.tf
│
├── .gitignore
└── README.md  (this file)
```

---

## Part 1: Application (simple_time_service)

The application is a **FastAPI** service that exposes:

* `/` → returns current UTC timestamp in ISO-8601 format
* `/health` → health check endpoint
* `/favicon.ico` → handled safely (204 response)

### Run Locally (No Docker)

#### 1. Create a virtual environment

```bash
python -m venv venv
source venv/bin/activate   # Linux/macOS
venv\\Scripts\\activate      # Windows
```

#### 2. Install dependencies

```bash
pip install -r requirements.txt
```

#### 3. Run the app

```bash
python simple_time_service.py
```

Open browser:

```
http://localhost:8080
```

---

### Run Tests

```bash
pytest
```

All tests validate:

* Timestamp format
* UTC timezone correctness
* API response behavior

---

### Run Using Docker Compose

Docker-related files are located **inside the `simple_time_service` directory**.

#### 1. Build and run

```bash
cd simple_time_service
docker compose up --build
```

#### 2. Access the app

```
http://localhost:8080
```

#### 3. Stop containers

```bash
docker compose down
```

---

## ️ Part 2: Infrastructure (Terraform)

The `terraform/` directory provisions **Azure infrastructure** and deploys the container using **Azure Container Apps**.

### What Terraform Creates

* Resource Group
* Virtual Network (VNet)

  * Public subnets
  * Private subnets
  * Dedicated delegated subnet for Container Apps (`Microsoft.Web/containerApps`)
* Log Analytics Workspace
* Azure Container Apps Environment (private)
* Azure Container App

The container app:

* Runs **inside private subnets only**
* Is exposed securely using Azure-managed ingress

---

## ️ Terraform Backend (Important)

Terraform **state** is stored remotely using an Azure Storage Account (defined in `backend.tf`).

### Why a backend?

* Prevents state loss
* Enables team collaboration
* Required for production-grade Terraform

### Backend Requirements (Must Exist Before `terraform init`)

You must manually create:

* A **Resource Group**
* A **Storage Account**
* A **Blob Container** (e.g. `tfstate`)

Example (Azure CLI):

```bash
az group create --name tfstate-rg --location eastus

az storage account create \
  --name mystatetf123 \
  --resource-group tfstate-rg \
  --location eastus \
  --sku Standard_LRS

az storage container create \
  --name tfstate \
  --account-name mystatetf123
```

Then update `backend.tf` accordingly.

---

## ️ Deploy Infrastructure

```bash
cd terraform
terraform init
terraform validate
terraform plan
terraform apply
```

After deployment, Terraform outputs the **application URL**.

---

## ️ Common Errors & Solutions

### MissingSubscriptionRegistration: Microsoft.App

Fixed by registering provider:

```bash
az provider register --namespace Microsoft.App
```
---

## Production Best Practices Used

* Non-root Docker user
* Gunicorn + Uvicorn worker
* Private subnets for workloads
* Managed SSL via Azure ingress
* Terraform state backend
* Variable validations
* `for_each` subnet creation
