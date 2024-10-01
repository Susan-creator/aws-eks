# Prerequistes 
### Install AWS CLI
## Install EKSCTL

# Step One: Create a hosts.ini file
## Add the following content: 
[local]
localhost ansible_connection=local

# Create an eC2 Key Pair
aws ec2 create-key-pair --key-name my-ec2-keypair --query 'KeyMaterial' --output text > my-ec2-keypair.pem
chmod 400 my-ec2-keypair.pem
aws ec2 describe-key-pairs --region us-east-1 # Only if you want to use an existing one. 

# Step One: Write your Ansible Playbook
## Add content as desired

# Step Two: Run the Playbook
ansible-playbook -i hosts.ini create_eks_nginx.yml
