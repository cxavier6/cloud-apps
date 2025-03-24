# cloud-apps
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-3069DE?style=for-the-badge&logo=kubernetes&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?&style=for-the-badge&logo=redis&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Github](https://img.shields.io/badge/Github%20Actions-282a2e?style=for-the-badge&logo=githubactions&logoColor=367cfe)
![ArgoCD](https://img.shields.io/badge/Argo%20CD-1e0b3e?style=for-the-badge&logo=argo&logoColor=#d16044)
![Grafana](https://img.shields.io/badge/grafana-%23F46800.svg?style=for-the-badge&logo=grafana&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-000000?style=for-the-badge&logo=prometheus&labelColor=000000)

## Requirements

- Terraform
- AWS CLI
- Docker
- kubectl
- kustomize

## Infrastructure Setup

#### 1. Run Terraform
To setup the infrastructure with Terraform run the following commands inside the `/infra` folder:

```bash
terraform plan -out=tmp/infra
terraform apply "tmp/infra
```
#### 2. Configure kubeconfig
Update kube config file:

```bash
aws eks update-kubeconfig --name cloud-apps --region us-east-1
```
Confirm all infrastructure resources are created by Terraform, then proceed to the next steps.

#### 3. Build and Push Docker Images
Run the following commands inside the `/apps` folder to build and push docker images to ECR:
```bash
chmod +x push-to-ecr
./push-to-ecr.sh
```

#### 4. Configure ACM Certificate
Configure the load balancer's ACM certificate arns for the ingresses, in the `/k8s-manifests/ingress` folder in the `master` branch:

_Note: or create a new branch and create a PR to be approved and merged in the master branch to apply the arn update._ 
```bash
alb.ingress.kubernetes.io/certificate-arn: [certificate_arn output value from terraform]
```

#### 5. Deploy Kubernetes manifests
To deploy kubernetes manifests, run the following command in the root folder to apply the `kustomization.yaml` file:

_Note: if running for the first time the images tag (newTag variable) in the kustomization.yaml file should be v1.0 for both applications._ 
```bash
kubectl apply -k .
```
These manifests will create the applications' resources (deployment, svc), nginx and the nginx configuration file as a configmap that will be mounted in the nginx deployment, ArgoCD application that contains all these resources to be synced and ingress for all 
endpoints + the Application Load Balancer (ALB).

#### 6. Configure DNS (Route53)
Update/create the following Route53 records with the `applications-alb` ALB DNS name in the `camila-devops.site` hosted zone:
- `node.camila-devops.site`
- `python.camila-devops.site`
- `grafana.camila-devops.site`
- `argocd.camila-devops.site`

After these steps, the infrastructure will be ready, and the applications will be running at the URLs stated above.

#### 7. ArgoCD and Grafana Access Credentials

To get password for the ArgoCD and Grafana services run the following commands:
```bash
# Get Grafana password 
kubectl get secret prometheus-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d

# Get ArgoCD password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
```
For both of them the username is `admin`.


## Applications

For local testing run the docker-compose file in the `/apps` folder with `docker-compose up` command.

#### Node.js App

Uses Express and Redis for cache. 

Routes:
- `/text` - Returns static text (10s cache)
- `/time` - Returns current time (10s cache)

#### Python App

Uses FastAPI and Redis for cache. 

Routes:
- `/text` - Returns static text (60s cache)
- `/time` - Returns current time (60s cache)

#### NGINX

NGINX is used as reverse proxy in the EKS cluster to distribute traffic for each application service as requested. It also adds a `/health` path for ALB healthchecks.


## CI/CD Pipeline (Github Actions + ArgoCD)

#### Workflow

**Trigger**: Pushes to master branch in `/apps` folder.

**Actions**:

- Updates `kustomization.yaml` with new image tags.

- ArgoCD auto-syncs changes from `master` branch.

**Behavior**:

- Application pods updated automatically via image tag changes.

- Other Resources (services, Ingress...): Require manual edits in `master` branch → ArgoCD syncs.

###

## Infrastructure Diagram

![cloud-apps drawio (1)](https://github.com/user-attachments/assets/c1380c4b-d809-4806-bcc8-d102a21fecb0)


