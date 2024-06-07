# Cloud Resource Management with ServiceNow, Terraform, Packer, Ansible and HashiCorp Vault

Managing cloud infrastructure efficiently and securely is critical for modern enterprises. This blog post presents an integrated architecture leveraging ServiceNow, Terraform, Packer, Ansible, and HashiCorp Vault to automate and streamline the provisioning, configuration, and management of cloud resources. By introducing Vault, we can centralize and secure the management of sensitive data, reducing complexity and enhancing security.

## Overview of the Architecture

This architecture integrates ServiceNow for user interface, workflow automation, and approval processes. It uses Terraform for infrastructure provisioning, Packer for creating pre-configured images, Ansible for dynamic configuration, and HashiCorp Vault for managing secrets and certificates. The entire process is integrated through ServiceNow workflows, ensuring seamless and automated management of cloud resources.

### Components

1. ServiceNow: Frontend for resource requests, workflow engine for approvals and process initiation, CMDB for tracking assets and configurations, and managing the creation and maintenance of Packer images.

1. Terraform: Infrastructure as Code (IaC) tool for provisioning cloud resources, code stored in a Git repository.

1. Packer: Tool for creating pre-configured machine images, images stored in the appropriate image repository (e.g., AWS AMIs), managed via ServiceNow.

1. Ansible: Configuration management tool for setting up and configuring resources, playbooks stored in a Git repository.
   - Introducing Ansible and Terraform is straightforward because all the code is stored in a repository like GitHub, GitLab, or Azure DevOps. There is no requirement to install any additional application, therefore not introducing any additional complexity.

1. HashiCorp Vault: Secure storage for secrets and sensitive data, providing dynamic secrets management and certificate issuance.
   - Introducing HashiCorp Vault into this architecture is optional but important for efficiently managing access and control security. Although HashiCorp Vault needs to be installed, which introduces additional complexity, a highly available HashiCorp Vault can be deployed using a combination of Terraform, Ansible, or Packer and deployed into the cloud quite easily.

1.  Git Repository: Central storage for Terraform, Packer, and Ansible code.
Another important concept to introduce into the architecture is the management of the Terraform and Ansible scripts in the version control system. A well-thought-out and proper release management or version control process is key to ensuring proper management of these scripts for creating and updating cloud resources. I recommend a simple Gitflow approach, which I will provide in a separate blog. 

## Detailed Architecture and Workflow

### Step-by-Step Process
1. Resource Request:

   - Users submit resource requests through the ServiceNow Service Catalog.
1. Approval Workflow:

   - ServiceNow workflow initiates the approval process.
   - Approval notifications are sent to the appropriate stakeholders.

1. Packer Image Creation and Maintenance:

   - ServiceNow triggers a workflow to create or update Packer images.
   - Packer scripts stored in a Git repository are executed to build and maintain images.
1. Provision Initiation:

   - Once approved, ServiceNow triggers a workflow to initiate the provisioning process.
   - ServiceNow calls a script to execute the Terraform code.
1. Terraform Provisioning:

   - The Terraform script provisions the necessary cloud resources using pre-configured images created by Packer.
   - Terraform integrates with HashiCorp Vault to retrieve necessary secrets and credentials dynamically.
1. Ansible Configuration:

   - After provisioning, ServiceNow triggers an Ansible playbook to configure the resources.
   - Ansible playbooks integrate with HashiCorp Vault to retrieve dynamic secrets and certificates needed for configuration.
1. CMDB Update:

   - Ansible or Terraform updates the ServiceNow CMDB with the new resource details.
   - The CMDB reflects the current state of all managed resources.

### Detailed Steps in ServiceNow
#### ServiceNow Request and Approval Process
1. Creating a Service Catalog Item:

   - Go to Service Catalog -> Catalog Definitions -> Maintain Items.
   - Click New to create a new catalog item.
   - Name: Provision AWS EC2 Instance
   - Category: Select an appropriate category (e.g., Cloud Services).
   - Workflow: Select the workflow that will handle the provisioning.
1. Designing the Service Catalog Form:

   - Add variables to capture necessary information (e.g., instance type, region, AMI ID).
### Example Workflow Script to Call Terraform
1. Creating a Workflow:

   - Go to Workflow -> Workflow Editor.
   - Click New to create a new workflow.
   - Name: Provision AWS EC2 Instance
   - Table: Select sc_req_item (Service Catalog Request Item).
1. Adding Workflow Activities:

   - Add activities for approval, provisioning, and CMDB updates.
1. Script to Trigger Terraform: [servicenow.js](https://github.com/kingting/servicenow/blob/main/servicenow.js)
<!-- servicenow.js-start -->
```javascript
// File: servicenow.js
var gitRepo = "https://github.com/your-repo/terraform-scripts.git";
var terraformScriptPath = "path/to/terraform/script";
var terraformCommand = "terraform apply -auto-approve";

// Clone the Git repository
var gitClone = new GlideScriptedGit("your-git-username", "your-git-token");
gitClone.cloneRepo(gitRepo, "/tmp/terraform");

// Execute the Terraform script
var terraform = new GlideScriptedTerraform();
terraform.execute(terraformScriptPath, terraformCommand);
```
<!-- servicenow.js-end -->

### Managing Packer Images with ServiceNow
1. Creating a Service Catalog Item for Packer:

   - Go to Service Catalog -> Catalog Definitions -> Maintain Items.
   - Click New to create a new catalog item.
   - Name: Create/Update Packer Image
   - Category: Select an appropriate category (e.g., Image Management).
   - Workflow: Select the workflow that will handle the Packer image creation.
1. Designing the Service Catalog Form:

   - Add variables to capture necessary information (e.g., base AMI ID, image name, security hardening options).
1. Creating the Workflow:

   - Go to Workflow -> Workflow Editor.
   - Click New to create a new workflow.
   - Name: Packer Image Creation Workflow
   - Table: Select sc_req_item.
1. Adding Workflow Activities:

   - Add activities for approval, image creation, and CMDB updates.

1. Script to Trigger Packer: [packer.js](https://github.com/kingting/servicenow/blob/main/packer.js)

<!-- packer.js-start -->
```javascript
//File: packer.js

var gitRepo = "https://github.com/your-repo/packer-scripts.git";
var packerScriptPath = "path/to/packer/template.json";
var packerCommand = "packer build " + packerScriptPath;

// Clone the Git repository
var gitClone = new GlideScriptedGit("your-git-username", "your-git-token");
gitClone.cloneRepo(gitRepo, "/tmp/packer");

// Execute the Packer script
var packer = new GlideScriptedPacker();
packer.execute(packerCommand);
```
<!-- packer.js-end -->

### Example Packer Template with Security Hardening
Packer Template File (secure-packer-template.json):

<!-- secure-packer-template.json-start -->
```json
{
  "builders": [
    {
      "type": "amazon-ebs",
      "access_key": "your-access-key",
      "secret_key": "your-secret-key",
      "region": "us-east-1",
      "source_ami": "ami-0abcdef1234567890",
      "instance_type": "t2.micro",
      "ssh_username": "ec2-user",
      "ami_name": "secure-ami-{{timestamp}}"
    }
  ],
  "provisioners": [
    {
      "type": "shell",
      "inline": [
        "sudo yum update -y",
        "sudo yum install -y nginx",
        "sudo systemctl enable nginx",
        "sudo systemctl start nginx",
        "sudo yum install -y fail2ban",
        "sudo systemctl enable fail2ban",
        "sudo systemctl start fail2ban",
        "sudo yum install -y iptables",
        "sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT",
        "sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT",
        "sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT",
        "sudo iptables -A INPUT -j DROP",
        "sudo iptables-save | sudo tee /etc/sysconfig/iptables"
      ]
    },
    {
      "type": "ansible",
      "playbook_file": "playbooks/harden.yml"
    }
  ]
}
```
<!-- secure-packer-template.json-end -->

Ansible Playbook for Additional Hardening (playbooks/harden.yml):
```yaml
---
- name: Harden server
  hosts: all
  become: yes

  tasks:
    - name: Disable root login
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^PermitRootLogin'
        line: 'PermitRootLogin no'
        state: present

    - name: Disable password authentication
      lineinfile:
        path: /etc/ssh/sshd_config
        regexp: '^PasswordAuthentication'
        line: 'PasswordAuthentication no'
        state: present

    - name: Install and configure auditd
      yum:
        name: audit
        state: present
    - name: Enable auditd service
      service:
        name: auditd
        state: started
        enabled: yes

    - name: Setup audit rules
      copy:
        dest: /etc/audit/rules.d/audit.rules
        content: |
          -w /etc/passwd -p wa -k passwd_changes
          -w /etc/shadow -p wa -k shadow_changes
          -w /etc/sudoers -p wa -k sudoers_changes
    - name: Restart SSH service
      service:
        name: sshd
        state: restarted
```
#### Building the Image

```
packer build secure-packer-template.json
```
### Terraform Scripts for Cloud Resource Deployment
#### Example Terraform Configuration with Vault Integration
Terraform Configuration File (main.tf):
```hcl
provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "https://vault.yourdomain.com"
}

data "vault_generic_secret" "aws_credentials" {
  path = "aws/creds/terraform"
}

resource "aws_instance" "web" {
  ami           = "ami-0abcdef1234567890"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServerInstance"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 80 &
              EOF

  provisioner "remote-exec" {
    inline = [
      "aws configure set aws_access_key_id ${data.vault_generic_secret.aws_credentials.data.access_key}",
      "aws configure set aws_secret_access_key ${data.vault_generic_secret.aws_credentials.data.secret_key}"
    ]
  }
}
```
## Integrating Terrascan and Terratest into the CI/CD Pipeline
To ensure the robustness and security of your Terraform scripts, you can integrate Terrascan for static code analysis and Terratest for infrastructure testing. Here’s how you can do it.

### CI/CD Pipeline with Terrascan and Terratest
#### Step 1: Setting Up the Repository
1. Create a Git Repository: Store your Terraform scripts in a Git repository (e.g., GitHub, GitLab, Bitbucket).
#### Step 2: Implementing a CI/CD Pipeline with Terrascan and Terratest
1. GitHub Actions Example (.github/workflows/terraform.yml):
```yaml
name: Terraform CI/CD

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  terrascan:
    name: 'Terrascan'
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Go
      uses: actions/setup-go@v2
      with:
        go-version: '^1.15'

    - name: Install Terrascan
      run: |
        go get github.com/accurics/terrascan
        terrascan init

    - name: Run Terrascan
      run: terrascan scan -d .

  terraform:
    name: 'Terraform'
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_version: 0.14.7

    - name: Terraform Init
      run: terraform init

    - name: Terraform Validate
      run: terraform validate

    - name: Terraform Plan
      run: terraform plan

    - name: Terraform Apply
      if: github.event_name == 'push'
      run: terraform apply -auto-approve

  terratest:
    name: 'Terratest'
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup Go
      uses: actions/setup-go@v2
      with:
        go-version: '^1.15'

    - name: Install Terratest dependencies
      run: go get -v ./...

    - name: Run Terratest
      run: go test -v -timeout 30m
```
2. GitLab CI/CD Example (.gitlab-ci.yml):

```yaml
stages:
  - scan
  - validate
  - plan
  - test
  - apply

variables:
  TF_VERSION: 0.14.7
  TF_IMAGE: hashicorp/terraform:$TF_VERSION
  GO_VERSION: 1.15

before_script:
  - apk add --no-cache curl jq python3 py3-pip
  - pip3 install awscli
  - curl "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip" -o terraform.zip
  - unzip terraform.zip
  - mv terraform /usr/local/bin/

scan:
  stage: scan
  image: golang:$GO_VERSION
  script:
    - go get github.com/accurics/terrascan
    - terrascan init
    - terrascan scan -d .

validate:
  stage: validate
  image: $TF_IMAGE
  script:
    - terraform init
    - terraform validate

plan:
  stage: plan
  image: $TF_IMAGE
  script:
    - terraform init
    - terraform plan
  artifacts:
    paths:
      - planfile

test:
  stage: test
  image: golang:$GO_VERSION
  script:
    - go get -v ./...
    - go test -v -timeout 30m

apply:
  stage: apply
  image: $TF_IMAGE
  script:
    - terraform init
    - terraform apply -auto-approve
  when: manual
```
### Example Terratest Code
Create a test file (e.g., test/terraform_test.go) to define your Terratest tests.

#### Terratest Example (test/terraform_test.go):

```go
package test

import (
    "fmt"
    "testing"

    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/gruntwork-io/terratest/modules/random"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformAwsInstance(t *testing.T) {
    t.Parallel()

    // Generate a random AWS region
    awsRegion := aws.GetRandomRegion(t, nil, []string{"us-east-1", "us-east-2", "us-west-1", "us-west-2"})

    terraformOptions := &terraform.Options{
        // The path to where your Terraform code is located
        TerraformDir: "../",

        // Variables to pass to our Terraform code using -var options
        Vars: map[string]interface{}{
            "aws_region": awsRegion,
        },

        // Environment variables to set when running Terraform
        EnvVars: map[string]string{
            "AWS_DEFAULT_REGION": awsRegion,
        },
    }

    // Run `terraform init` and `terraform apply`. Fail the test if there are any errors.
    defer terraform.Destroy(t, terraformOptions)
    terraform.InitAndApply(t, terraformOptions)

    // Run `terraform output` to get the value of an output variable
    instanceID := terraform.Output(t, terraformOptions, "instance_id")

    // Assert that the instance ID is not empty
    assert.NotEmpty(t, instanceID)

    // Verify that the instance is running
    instance := aws.GetInstanceDetails(t, awsRegion, instanceID)
    assert.Equal(t, "running", *instance.State.Name)

    fmt.Println("Test passed!")
}
```
## Best Practices for Cloud Resource Management
1. Version Control:
   - Store all Infrastructure as Code (IaC) scripts in a version-controlled repository.
1. Automated Testing:
   - Implement automated testing for Terraform scripts to validate changes before applying them.
1. Secret Management:
   - Use HashiCorp Vault to manage and secure secrets and sensitive data.
1. Security Hardening:
   - Use Packer to create pre-configured images with security hardening measures.
1. Continuous Monitoring:
   - Implement continuous monitoring and logging for all cloud resources.
## Conclusion
Implementing this enhanced architecture will streamline your cloud resource management, enhance compliance, and provide real-time updates to the CMDB. By leveraging the strengths of ServiceNow, Terraform, Packer, Ansible, and HashiCorp Vault, you can create a cohesive and efficient workflow that ensures secure and efficient cloud operations. Integrating Terrascan and Terratest into the CI/CD pipeline ensures that your infrastructure code is robust and secure before deployment.

In a future blog, I will discuss in detail how to set up and manage HashiCorp Vault, including deploying a highly available setup using Terraform, Ansible, and Packer. Additionally, I will provide a separate blog on managing Terraform and Ansible scripts in version control systems with a simple Gitflow approach to ensure proper release management and version control
