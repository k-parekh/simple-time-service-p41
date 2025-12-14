# Simple Time Service

This repository contains the full-stack setup for `Simple Time Service`, including the Python container application and Terraform code to deploy it to Azure.

## Project Structure

```
root/
├── simple_time_service/       # Python microservice application
│   ├── simple_time_service.py # FastAPI application code
│   ├── requirements.txt       # Python dependencies
│   ├── test_simple_time_service.py # Pytest test cases
│   ├── Dockerfile             # Docker image definition
│   ├── docker-compose.yml     # Docker Compose for local multi-container testing
│   └── README.md              # Application-specific README
├── terraform/                 # Terraform infrastructure code
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── provider.tf
│   ├── networks.tf
│   ├── container_apps.tf
│   └── locals.tf
└── README.md                  # Root README (this file)
```

## Application Overview

`SimpleTimeService` is a Python FastAPI-based microservice that:

* Returns the current timestamp in UTC.
* Returns the IP address of the client making the request.
* Provides a `/favicon.ico` endpoint with proper handling.

The service is containerized using Docker for portability.

## Prerequisites

* Python 3.11+
* Docker & Docker Compose
* Terraform 1.5+
* Azure CLI (for deploying to Azure)
* Git

## Local Setup (Python Service)

1. **Clone the repository**

```
git clone <repo-url>
cd root/simple_time_service
```

2. **Install Python dependencies**

```
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows
pip install -r requirements.txt
```

3. **Run the application locally**

```
uvicorn simple_time_service:app --host 0.0.0.0 --port 8080
```

Open [http://127.0.0.1:8080/](http://127.0.0.1:8080/) in your browser or use `curl`.

4. **Run tests**

```
pytest -v
```

## Local Docker Setup

1. **Build the Docker image**

```
docker build -t simpletimeservice:latest .
```

2. **Run the container**

```
docker run -d -p 8080:8080 simpletimeservice:latest
```

3. **Using Docker Compose**

```
cd simple_time_service
docker-compose up --build
```

Access the service at [http://127.0.0.1:8080/](http://127.0.0.1:8080/).

## Terraform Deployment

1. Navigate to the `terraform` folder

```
cd terraform
```

2. Initialize Terraform

```
terraform init
```

3. Plan the deployment

```
terraform plan
```

4. Apply the deployment

```
terraform apply
```

5. Once deployed, access the `container_app_url` from Terraform outputs.

## Notes

* Local development uses Docker and Docker Compose.
* Terraform provisions all Azure resources required for hosting the container.
* Ensure you have sufficient permissions in Azure for provider registration and resource creation.
* The container app runs in a private subnet with a managed environment and logs to Log Analytics.

## References

* [FastAPI Documentation](https://fastapi.tiangolo.com/)
* [Docker Documentation](https://docs.docker.com/)
* [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Azure Container Apps](https://learn.microsoft.com/en-us/azure/container-apps/)
