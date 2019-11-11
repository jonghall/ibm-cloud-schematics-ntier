#Validate ipsec throughput

This project is currently based on Terraform v0.11.14 and the IBM Cloud Terraform Provider v.0.17.4.
This provider can be found at: [https://github.com/IBM-Cloud/terraform-provider-ibm](https://github.com/IBM-Cloud/terraform-provider-ibm)

## Assumptions

- Two VPC's in same zone, gateway and test clients in same subnet in each VPC, two c2-8x16 and two gateways C2-8x16 instances all with 16 Gpbs
- floating-ips for ease of executing test
- default security group with ssh open
- Ansible to deloy and run throughput tests
- delete (destroy) deletes all objects associated

Documentation for the IBM provider can be found at: [https://ibm-cloud.github.io/tf-ibm-docs/v0.17.4/](https://ibm-cloud.github.io/tf-ibm-docs/v0.17.4/)

## Steps to modify sample Terraform Plan

1. [Download and install Terraform for your system](https://www.terraform.io/intro/getting-started/install.html). 

2. [Download the IBM Cloud provider plugin for Terraform](https://github.com/IBM-Bluemix/terraform-provider-ibm/releases).

3. Unzip the release archive to extract the plugin binary (`terraform-provider-ibm_vX.Y.Z`).

4. Move the binary into the Terraform [plugins directory](https://www.terraform.io/docs/configuration/providers.html#third-party-plugins) for the platform.
    - Linux/Unix/OS X: `~/.terraform.d/plugins`
    - Windows: `%APPDATA%\terraform.d\plugins`

6. (optional) Modify [variables.tf](variables.tf) as needed.
    
7. Issue the following Terraform commands to execute the plan

    - To initialize Terraform and the IBM Cloud provider in the current directory.  You must also export environment variables for
    the desired region and generation you wish to provision the VPC in, and provide your API key.
    
    ```shell
    export IC_REGION="us-south"
    export IC_GENERATION="2"
    export IC_API_KEY="api_key"
    terraform init
    ```
    
    - To review the plan for the configuration defined (no resources actually provisioned) 
    
    ```shell
    terraform plan
    ```
    
    - To execute and start building the configuration defined in the plan (provisions resources)
    
    ```shell
    terraform apply
    ```
    
    - After testing throughput, and when complete to delete / destroy the VPC and all related resources
    
    ````shell
    terraform destroy
    ````

## Steps to setup routing for Gateway

    ```
6. Setup routes for Gateway  (CLI DOESN"T WORK CURRENTLY SO USE PYTHON SCRIPT WITH REST API)

```
    ./vpc-route.py -v ipsec-vpc-a  --action add --zone us-south-1 --nexthop 172.21.0.4 --destination 172.22.0.0/21
    Route Add Succesfull
    Destination = 172.22.0.0/21, Next Hop = 172.21.0.4, Zone = us-south-1
    
    ./vpc-route.py -v ipsec-vpc-b  --action add --zone us-south-1 --nexthop 172.22.0.5 --destination 172.21.0.0/21 
    Route Add Succesfull
    Destination = 172.21.0.0/21, Next Hop = 172.22.0.5, Zone = us-south-1

```

7.  List routes

```
    ./vpc-route.py -v ipsec-vpc-b  --action list                                                                  
    ID = r006-aaee3711-4800-4eb9-b3e3-02a4ce7370f5, Destination = 172.21.0.0/21, Next Hop = 172.22.0.5, Zone = us-south-1
    ./vpc-route.py -v ipsec-vpc-a  --action list
    ID = r006-2137d3e3-7ea0-4484-acc1-773d7cbed117, Destination = 172.22.0.0/21, Next Hop = 172.21.0.4, Zone = us-south-1
```


6. Sample output 
