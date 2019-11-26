# Deploying the VPC Infrastructure using Terraform & IBM Cloud Schematics
A typical use case for a Virtual Private Cloud (VPC) is the ability to logically isolate an application running on the public cloud from other applications and environments.  Additionally many
application architectures require different tiers to isolate and secure critical aspects of the application.   An application may also need to leverage different availability zones
to increase the overall resilience of the application.   However, building these required constructs for the network and security across VPC's, Availability Zones, and the individual network subnets
can be tedious to implement manually.   Additionally today's development cycles often require quick turn around and frequent updates driving the need for automation.

### Infrastructure Architecture
![3tier Web App - Infrastructure](/images/infrastructure-architecture.png)

### Application Architecture
![3tuer Web App - Application](/images/application-data-flow.png)

[HashiCorp's Terraform](https://www.terraform.io/) makes defining your cloud infrastructure in code possible.   Using the [IBM Cloud Terraform Provider](https://github.com/IBM-Cloud/terraform-provider-ibm)
simplifies the provisioning and management of infrastructure in the IBM Cloud using Terraform by automating and saving the state of VPCs, security-groups, network acls, subnets, compute resources,
load balancers and VPN endpoints across the desired availability zones within and accross the regions specified.

## vpc-ibm-terraform-provider
This project is currently based on Terraform v0.11.14 and the IBM Cloud Terraform Provider v.0.19.1.
This provider can be found at: [https://github.com/IBM-Cloud/terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

Documentation for the IBM provider can be found at: [https://ibm-cloud.github.io/tf-ibm-docs/v0.19.1/](https://ibm-cloud.github.io/tf-ibm-docs/v0.19.1/)

## Steps to modify sample Terraform Plan

1. [Download and install Terraform for your system](https://www.terraform.io/intro/getting-started/install.html). 

2. [Download the IBM Cloud provider plugin for Terraform](https://github.com/IBM-Bluemix/terraform-provider-ibm/releases).

3. Unzip the release archive to extract the plugin binary (`terraform-provider-ibm_vX.Y.Z`).

4. Move the binary into the Terraform [plugins directory](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins) for the platform.
    - Linux/Unix/OS X: `~/.terraform.d/plugins`

5. Modify [variables.tf](../variables.tf)
    -  to change VPC and Server Names and quantities
    -  Tailor profiles, images, etc as needed 

   
6.  Download RaxakProtectSetup.sh script to be used by Cloud Init during post install.
