# Terraform Project: Cloud Infrastructure & State Management with AWS

This project demonstrates a complete **Infrastructure as Code (IaC)** workflow using **Terraform** for provisioning and managing AWS resources, with proper **remote state management using S3**. The infrastructure was designed to support a scalable application architecture, including network setup, Beanstalk deployment, Bastion host, and backend services like RDS, RabbitMQ, and Memcached.

The entire infrastructure was broken down into **modular Terraform files**, following best practices for readability and reusability. This project was implemented with guidance from a **Udemy DevOps course**, especially for application artifacts and Beanstalk deployment strategies.

---

## Technologies Used

- **Terraform**
- **AWS Services**:
  - VPC, Subnets, Internet Gateway
  - EC2, RDS, Elastic Beanstalk
  - S3 (for remote backend state)
  - Security Groups
  - IAM, Key Pairs
  - Memcached & RabbitMQ
  - Bastion Host with Provisioners

---

## Steps

### 1. **AWS CLI Setup & Credential Configuration**

- Ran `aws configure` on Git Bash to set up access credentials.
- Provided AWS Access Key, Secret Key, region, and default output format.
- This ensured Terraform could authenticate with AWS for provisioning.

---

### 2. **S3 Bucket for Remote State Management**

- Created an **S3 bucket** to securely store the **Terraform state file**.
- Configured `backend.tf` to use this S3 bucket as the **remote backend**.
- This prevents local state file issues and allows collaborative and safe IaC usage.

---

### 3. **Project Initialization: Key Files**

Created modular `.tf` files for each resource group:

- `providers.tf` and `vars.tf` to define AWS provider and input variables.
- `keypairs.tf` to define the SSH key pair used to access EC2 instances.

---

### 4. **VPC and Networking Setup**

- Wrote `vpc.tf` to define:
  - Custom VPC
  - Public and Private Subnets
  - Internet Gateway
  - Routing Tables
- Applied best practices for CIDR allocation and subnet isolation.

---

### 5. **Security Groups**

- Defined multiple security groups in `secgroup.tf`:
  - Web (Nginx/Load Balancer)
  - App (Tomcat)
  - Database (MySQL/RDS)
  - RabbitMQ
  - Memcached
  - Bastion Host access

Each group was carefully configured for ingress/egress rules to isolate layers and expose only what’s needed.

---

### 6. **Backend Services Setup**

- Created RDS, RabbitMQ, and Memcached configurations to simulate a real backend architecture.
- Ensured dependencies and port access were tightly controlled via SGs.

---

### 7. **Elastic Beanstalk Application & Environment**

- Defined `bean-app.tf` and `bean-env.tf`:
  - Beanstalk Application Resource
  - Beanstalk Environment with proper solution stack (Tomcat on Amazon Linux)
- Linked the Beanstalk environment to the application artifact generated from the Maven build.

---

### 8. **Artifact Deployment**

- Used the provided project artifact from the **Udemy course**.
- Ran `mvn install` to package the app.
- Uploaded the `.war` file artifact to Beanstalk for deployment.
- This enabled automated deployment of the app directly after provisioning.

---

### 9. **Bastion Host Setup with Template and Provisioners**

- Created `bastion-host.tf` to launch a Bastion Host instance inside the public subnet.
- Included a `template_file` block that rendered a custom **`dbdeploy.sh`** file.
  - This file initialized the database after RDS setup.

- Used **`file` provisioner** to copy the `dbdeploy.sh` from the local machine into the Bastion Host.
- Then used **`remote-exec` provisioner** to:
  - SSH into the host
  - Execute the `dbdeploy.sh` script
  - Populate the RDS database with required schema

This provided a seamless flow from provisioning to DB initialization.

---

### 10. **Testing the Final Setup**

- Once provisioning completed, the Elastic Beanstalk environment was live.
- Accessed the app via the Beanstalk endpoint and verified:
  - Database connection
  - Application functionality
  - Network configurations and service access
- The infrastructure was modular, reusable, and easy to tear down or modify.

---

## Lessons Learned

This project helped me understand and apply:

- **Terraform modularity and remote state management**
- Best practices in **AWS infrastructure provisioning**
- Using **provisioners** with **templates** to automate remote scripts
- Managing complex environments using **Elastic Beanstalk**
- Real-world application of **VPC isolation**, **security groups**, and **Bastion host access**
- Integrating DevOps concepts from a Udemy course into practical workflows

---

## Credits

This project was built with support and guidance from a **Udemy DevOps course**, which provided:

- Sample application artifact and `.war` packaging
- Beanstalk deployment strategy
- `dbdeploy.sh` structure for initial database seeding

Special thanks to the course instructor for providing clear guidance and examples, which I adapted and expanded to create this fully working cloud infrastructure.
