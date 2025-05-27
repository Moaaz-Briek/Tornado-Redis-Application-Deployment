# Tornado & Redis Application Deployment

A complete infrastructure and application deployment solution using Terraform, Google Cloud Platform (GCP), and Kubernetes for deploying a Tornado web application with Redis backend.

## 📋 Table of Contents

-   [Architecture Overview](#architecture-overview)
-   [Prerequisites](#prerequisites)
-   [Project Structure](#project-structure)
-   [Infrastructure Setup](#infrastructure-setup)
-   [Application Deployment](#application-deployment)
-   [Usage Instructions](#usage-instructions)
-   [Cleanup](#cleanup)

## 🏗️ Architecture Overview

This project creates a secure, scalable infrastructure on Google Cloud Platform consisting of:

-   **VPC Network**: Custom network with management and restricted subnets
-   **GKE Cluster**: Private Kubernetes cluster for application workloads
-   **Management VM**: Bastion host for cluster access and management
-   **Artifact Registry**: Container image repository
-   **Security**: Firewall rules and IAM configurations
-   **Application**: Tornado web server with Redis backend

### Network Architecture

```
┌──────────────────────────────────────────────────────────────┐
│                    Enterprise VPC                            │
│                                                              │
│  ┌─────────────────┐          ┌─────────────────────────────┐│
│  │ Management      │          │ Restricted Subnet           ││
│  │ Subnet          │          │ (192.168.20.0/24)           ││
│  │ (192.168.10.0/24)│         │                             ││
│  │                 │          │  ┌─────────────────────────┐││
│  │ ┌─────────────┐ │          │  │     GKE Cluster         │││
│  │ │Management VM│ │ SSH      │  │   (Private Nodes)       │││
│  │ │             │ │───────▶ │  │                         │ │
│  │ └─────────────┘ │          │  │  ┌─────┐  ┌─────────┐   │││
│  └─────────────────┘          │  │  │Redis│  │Tornado  │   │││
│           │                   │  │  │     │  │App      │   │││
│           │                   │  │  └─────┘  └─────────┘   │││
│           ▼                   │  └─────────────────────────┘││
│      NAT Gateway              └─────────────────────────────┘│
└──────────────────────────────────────────────────────────────┘
```

## 🔧 Prerequisites

### Required tools on your local machine

1. **Google Cloud SDK**

    ```bash
    # Install gcloud CLI
    curl https://sdk.cloud.google.com | bash
    exec -l $SHELL
    gcloud init
    ```

2. **Terraform**

    ```bash
    # Install Terraform (version >= 1.0)
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
    ```

3. **kubectl**

    ```bash
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    ```

4. **Docker**
    ```bash
    # Install Docker
    sudo apt-get update
    sudo apt-get install docker.io
    sudo usermod -aG docker $USER
    ```

### GCP Setup

1. **Set up Authentication**

    ```bash
    gcloud auth login
    ```

2. **Create GCP Project**

    ```bash
    gcloud projects create YOUR_PROJECT_ID
    gcloud config set project YOUR_PROJECT_ID
    ```

3. **Enable Required APIs**

    ```bash
    gcloud services enable compute.googleapis.com
    gcloud services enable container.googleapis.com
    gcloud services enable artifactregistry.googleapis.com
    gcloud services enable iam.googleapis.com
    ```

## 📁 Project Structure

```
├── app/
│   ├── static/                # Static files (CSS, JS, images)
│   ├── template/
│   │   └── index.html         # HTML templates
│   ├── app.py                 # Main Tornado application
│   ├── Dockerfile             # Container image definition
│   ├── requirements.txt       # Python dependencies
│   └── .env                   # Environment variables
├── k8s/
│   ├── redis.yaml            # Redis deployment and service
│   ├── app.yaml              # Tornado app deployment and service
│   └── ingress.yaml          # Ingress configuration
├── terraform/
│   ├── main.tf               # Main Terraform configuration
│   ├── variables.tf          # Variable definitions
│   ├── terraform.tfvars      # Variable values
│   ├── providers.tf          # Provider configuration
│   ├── outputs.tf            # Output definitions
│   └── modules/              # Terraform modules
│       ├── networking/       # VPC and networking resources
│       ├── compute/          # VM instances and service accounts
│       ├── gke/              # GKE cluster configuration
│       ├── registry/         # Artifact Registry
│       └── security/         # Firewall rules and security
```

## 🚀 Infrastructure Setup

### Step 1: Configure Terraform Variables

1. **Edit terraform.tfvars**

    ```bash
    cd terraform
    cp terraform.tfvars.example terraform.tfvars
    ```

2. **Update the configuration**

    ```hcl
    # terraform/terraform.tfvars
    project_id = "your-actual-project-id"
    region     = "us-central1"
    zone       = "us-central1-a"

    # Network Configuration
    vpc_name                   = "vpc"
    management_subnet_cidr     = "192.168.10.0/24"
    restricted_subnet_cidr     = "192.168.20.0/24"

    # VM Configuration
    vm_name                   = "management-vm"
    vm_internal_ip           = "192.168.10.100"

    # GKE Configuration
    cluster_name             = "gke-cluster"
    node_count              = 2

    # Registry Configuration
    repository_name = "docker-repo"
    ```

### Step 2: Deploy Infrastructure

1. **Initialize Terraform**

    ```bash
    cd terraform
    terraform init
    ```

2. **Plan the deployment**

    ```bash
    terraform plan
    ```

3. **Apply the configuration**

    ```bash
    terraform apply
    ```

    Type `yes` when prompted to confirm the deployment.

4. **Verify outputs**
    ```bash
    terraform output
    ```

### Step 3: Access Management VM

1.  **SSH to the Management VM**

    ```bash
    gcloud compute ssh management-vm --zone=us-central1-a
    ```

2.  **Update the system and install tools**

        ```bash
        # Update OS packages
        sudo apt-get update && sudo apt-get upgrade -y

        # Install kubectl
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

        # Install Docker
        sudo apt-get install -y docker.io
        sudo usermod -aG docker $USER
        newgrp docker

        # Install gcloud components

        ## Add the official Google Cloud SDK repo
        echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

        ## Import the Google Cloud GPG Key
        curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -

        ## Update APT and Install the Plugin
        sudo apt-get update
        sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

    ```

    ```

### Step 4: Configure Cluster Access

1. **Get cluster credentials**

    ```bash
    gcloud container clusters get-credentials gke-cluster \
      --zone=us-central1-a \
      --project=YOUR_PROJECT_ID
    ```

2. **Verify cluster access**
    ```bash
    kubectl get nodes
    kubectl get pods --all-namespaces
    ```

## 🐳 Application Deployment

### Step 1: Build and Push Container Image

1. **Configure Docker for Artifact Registry**

    ```bash
    gcloud auth configure-docker us-central1-docker.pkg.dev
    ```

2. **Copy application files to VM**

    ```bash
    # From your local machine
    gcloud compute scp --recurse ./app management-vm: --zone=us-central1-a
    gcloud compute scp --recurse ./k8s management-vm: --zone=us-central1-a
    ```

3. **Build and push the image**

    ```bash
    # On the Management VM
    cd ~/app

    # Build the Docker image
    docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:latest .

    # Push to Artifact Registry
    docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:latest

    #If the previous push command failed, we can bypass and use google cloud build
    gcloud builds submit --tag us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:latest
    ```

### Step 2: Deploy to Kubernetes

1. **Update Kubernetes manifests**

    ```bash
    cd ~/k8s

    # Update the image reference in app.yaml
    sed -i 's/YOUR_PROJECT_ID/your-actual-project-id/g' app.yaml
    ```

2. **Deploy Redis**

    ```bash
    kubectl apply -f redis.yaml
    ```

3. **Deploy the Tornado application**

    ```bash
    kubectl apply -f app.yaml
    ```

4. **Configure ingress (optional)**

    ```bash
    kubectl apply -f ingress.yaml
    ```

5. **Verify deployments**
    ```bash
    kubectl get pods
    kubectl get services
    kubectl get ingress
    ```

### Step 3: Test the Application

1. **Port forward for testing**

    ```bash
    kubectl port-forward service/tornado-app-service 8080:80
    ```

2. **Test from another terminal**
    ```bash
    curl http://localhost:8080
    ```

## Tornado project on the fly

### Access tornado project using our lb ip address

![access tornado project using our lb](./images/picture1.png)

after a minute

![access tornado project using our lb](./images/picture2.png)

## 📖 Usage Instructions

### Daily Operations

1. **Check application status**

    ```bash
    kubectl get pods -l app=tornado-app
    kubectl get pods -l app=redis
    ```

2. **View application logs**

    ```bash
    kubectl logs -l app=tornado-app -f
    kubectl logs -l app=redis -f
    ```

3. **Scale the application**

    ```bash
    kubectl scale deployment tornado-app --replicas=3
    ```

4. **Update the application**

    ```bash
    # Build new image with different tag
    docker build -t us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:v2 .
    docker push us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:v2

    # Update deployment
    kubectl set image deployment/tornado-app tornado-app=us-central1-docker.pkg.dev/YOUR_PROJECT_ID/docker-repo/tornado-app:v2
    ```

### Monitoring and Debugging

1. **Check cluster health**

    ```bash
    kubectl get nodes
    kubectl top nodes
    kubectl top pods
    ```

2. **Debug pod issues**

    ```bash
    kubectl describe pod <pod-name>
    kubectl exec -it <pod-name> -- /bin/bash
    ```

## 🧹 Cleanup

### Remove Kubernetes Resources

```bash
# from management vm
kubectl delete -f k8s/
```

### Destroy Infrastructure

```bash
# from local
cd terraform
terraform destroy
```

Type `yes` when prompted to confirm the destruction.

## 📚 Additional Resources

-   [Google Cloud Documentation](https://cloud.google.com/docs)
-   [Kubernetes Documentation](https://kubernetes.io/docs/)
-   [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
-   [Tornado Documentation](https://tornadoweb.org/)
-   [Redis Documentation](https://redis.io/documentation)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Note**: Remember to replace `YOUR_PROJECT_ID` with your actual Google Cloud Project ID throughout all configurations and commands.
