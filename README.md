Automating the Deployment of EKS Clusters Using Ansible
This project automates the deployment of an Amazon Elastic Kubernetes Service (EKS) cluster using Ansible. The automation includes deploying Nginx with a custom HTML ConfigMap and exposing it via a Load Balancer for easy access.

Table of Contents
Introduction
Prerequisites
Project Setup
Ansible Playbook Details
Running the Playbook
Verifying the Deployment
Cleaning Up Resources
Conclusion


Introduction
In today’s DevOps ecosystem, automation plays a key role in maintaining scalable, repeatable, and reliable infrastructure. This project showcases how to automate the deployment of an Amazon Elastic Kubernetes Service (EKS) cluster using Ansible.

In this project, we:

Create an EKS cluster using eksctl.
Deploy a Nginx web server.
Expose Nginx via a Kubernetes service with a LoadBalancer.
The process also includes serving a custom HTML page using Kubernetes ConfigMaps.

Prerequisites
Before running this project, ensure you have the following installed and configured:

AWS CLI: Set up with the necessary credentials to interact with your AWS account.
eksctl: To create and manage EKS clusters.
Ansible: For automation of the EKS deployment process.
kubectl: To manage the Kubernetes clusters.
AWS EC2 Key Pair: Required for SSH access to the EC2 nodes.
Run the following commands to set up the EC2 key pair:

bash
Copy code
aws ec2 create-key-pair --key-name my-ec2-keypair --query 'KeyMaterial' --output text > my-ec2-keypair.pem
chmod 400 my-ec2-keypair.pem
aws ec2 describe-key-pairs --region us-east-1 ``` # Optional, to use an existing key pair.


### Project Setup
```To get started, clone the project repository and navigate to the Ansible directory:

bash
Copy code
git clone https://github.com/susan-creator/aws-eks.git
cd aws-eks/ansible
Ansible Playbook Details
The main playbook file is create_eks_nginx.yml. It performs the following actions:

Creates an EKS Cluster:
Provisions an EKS cluster using eksctl with the provided configuration details.
Updates kubeconfig:
Ensures that kubectl is set up to interact with the EKS cluster.
Deploys Nginx:
Sets up an Nginx web server on the EKS cluster, serving a custom HTML page using a Kubernetes ConfigMap.
Exposes Nginx via a LoadBalancer:
Exposes Nginx using a Kubernetes LoadBalancer service, making it publicly accessible.
Here's a sample excerpt of the playbook:

yaml
Copy code
---
- name: Setup EKS Cluster and Deploy Nginx with Load Balancer
  hosts: localhost
  connection: local
  vars:
    cluster_name: demo
    region: us-east-1
    node_group_name: eks-node-group
    node_instance_type: t3.medium
    desired_capacity: 2
    min_size: 1
    max_size: 3
    eks_version: "1.30"
    key_name: eks-key-pair
  tasks:
    - name: Create an EKS cluster
      shell: |
        eksctl create cluster \
        --name {{ cluster_name }} \
        --version {{ eks_version }} \
        --region {{ region }} \
        --nodegroup-name {{ node_group_name }} \
        --node-type {{ node_instance_type }} \
        --nodes {{ desired_capacity }} \
        --nodes-min {{ min_size }} \
        --nodes-max {{ max_size }} \
        --managed \
        --ssh-access \
        --ssh-public-key {{ key_name }}
...
For full details, refer to the create_eks_nginx.yml playbook in the project.

Running the Playbook
To deploy the EKS cluster and Nginx, use the following command:

bash
Copy code
ansible-playbook -i host.ini, create_eks_nginx.yml
This command executes the tasks in the playbook, creating the EKS cluster and deploying Nginx with a custom web page.

Verifying the Deployment
Once the playbook finishes executing, retrieve the external IP of the Nginx service:

bash
Copy code
kubectl get svc nginx-service -o jsonpath="{.status.loadBalancer.ingress[0].hostname}"
Copy the external IP or DNS name and paste it into your browser. You should see a custom HTML page with the content:

html
Copy code
<h1>Hello from Suni</h1>
<p>At Suni we train Cloud and DevOps Engineers.</p>
Cleaning Up Resources
To avoid unnecessary charges, clean up the resources after testing by deleting the EKS cluster:

bash
Copy code
eksctl delete cluster --name=demo --region=us-east-1
This command will remove all resources related to the EKS cluster, including EC2 instances, VPC, and associated resources.

Conclusion
This project demonstrates how to automate the deployment of an EKS cluster using Ansible. By utilizing Ansible, you can simplify and speed up infrastructure provisioning, ensuring consistency and scalability in your deployments.

For more details, visit the project repository.

