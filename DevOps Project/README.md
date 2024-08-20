# DevOps Bootcamp Capstone Project

![snip1](https://github.com/user-attachments/assets/b11dc189-68fc-4b56-a985-02ab65cc1b3b)

## Overview
The goal of this DevOps Bootcamp Capstone Project is to establish a robust and automated CI/CD pipeline for deploying applications to a Kubernetes cluster on AWS. To achieve this, you will construct a comprehensive AWS infrastructure using Terraform, set up an EKS cluster for container orchestration, and deploy an EC2 instance to host Jenkins, your CI/CD server.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Kubernetes**: For container orchestration.
- **Helm**: To manage Kubernetes applications.
- **Docker**: To build and manage container images.
- **AWS CLI**: To interact with AWS services from the command line.
- **Terraform**: For provisioning infrastructure as code.
- **Ansible**: To automate software provisioning, configuration management, and application deployment.

## Running the Initialization Script

To initialize the full process, run the following Bash script:

```bash
./Full-Process.sh
```

## Deploy Nexus Kubernetes Files

Navigate to the Nexus files and run the following command to deploy:

```bash
kubectl apply -f .
```

## Deploy Helm Chart for NGINX Controller and Ingress

To install the NGINX ingress controller, run the following commands:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx
```

## Deploy the Application Helm Chart

To deploy your application using Helm, navigate outside the `sprints-app` folder and run:

```bash
helm install sprints-app ./sprints-app
```

## Configure Jenkins

Access Jenkins via the Load Balancer URL. Configure Jenkins and install the necessary plugins to run the project.

### Installing Plugins

1. **Access Jenkins Dashboard:**
   - Navigate to your Jenkins dashboard using your browser.

2. **Install GitHub Plugin:**
   - Go to `Manage Jenkins` > `Manage Plugins`.
   - Select the `Available` tab.
   - In the search box, type `GitHub Plugin`.
   - Check the box next to `GitHub Plugin`.

3. **Install Docker Plugin:**
   - Still in `Manage Plugins`, search for `Docker Plugin`.
   - Check the box next to `Docker Plugin`.

### GitHub Plugin Configuration

1. **Configure GitHub Server:**
   - Go to `Manage Jenkins` > `Configure System`.
   - Scroll down to the `GitHub` section and click `Add GitHub Server`.
   - Enter a `Name` for the GitHub Server.
   - Click `Add`, then select `Jenkins` from the drop-down to add your credentials.
   - Use a `GitHub Personal Access Token` as credentials for authenticating with GitHub. You can generate this token in your GitHub account under `Settings` > `Developer settings` > `Personal access tokens`.
   - Save your configuration.

2. **Webhook Setup:**
   - Navigate to your GitHub repository.
   - Go to `Settings` > `Webhooks`.
   - Click `Add webhook`.
   - Set the `Payload URL` to `http://<your-jenkins-url>/github-webhook/` and choose `application/json` as the content type.
   - Select the events you want to trigger Jenkins builds (e.g., push, pull request).

---



