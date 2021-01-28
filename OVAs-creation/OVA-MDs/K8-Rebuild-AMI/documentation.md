## Pre-requisites
- Get K8-rebuild AMI ID
    - Navigate to [GithubActions](https://github.com/k8-proxy/GW-Releases/actions?query=workflow%3Ak8-rebuild)
    - Select latest succesfull `k8-rebuild` action > Select `build ami` stage
    - Under `Build AMI/OVA` step, at the end you will find latest AMI ID that is deployed to AWS
- Get k8-rebuild OVA URL
    - Navigate to [GithubActions](https://github.com/k8-proxy/GW-Releases/actions?query=workflow%3Ak8-rebuild)
    - Select latest succesfull `icap-server` action > Select `build ami` stage
    - Under `Build AMI/OVA` step, search for `amazon-ebs: Creating AMI` and get folowing string starting with `k8-rebuild-<random_string>`
    - OVA URL will be: `s3://glasswall-sow-ova/vms/filedrop-aws.ova`

## Deployment & Usage of OVA on ESXI
- For deployment, please see [here](https://github.com/k8-proxy/GW-proxy/blob/master/OVAs-creation/OVA-MDs/FileDrop/2_Importing_OVA.md)
- For usage, please see [here](https://github.com/k8-proxy/GW-proxy/blob/master/OVAs-creation/OVA-MDs/FileDrop/3_OVA_Usage.md)

## Deploying & Usage AMI on AWS
- Navigate to AWS > AMIs
- Search for the AMI with specific ID from above
    - AMI should be public in case it is not, left click on specific AMI > Choose `Modify Image Permissions` and set checkbox to `public`
    - AMI can be copied to any specific region by left click on specific AMI > Choose `Copy AMI` and add details to where to copy
    - Once AMI is public and in proper region, we are able to lauch EC2 instance
- Instance can be launch from AMIs or EC2 space
- From AMIs workspace click on specific AMI > Choose `Launch` and follow the step
- Launch EC2 instance
    - Navigate to EC2 > click on `Launch instances`
    - Select AMI with ID from above and follow the steps
- For usage, please see [here](https://github.com/k8-proxy/GW-proxy/blob/master/OVAs-creation/OVA-MDs/FileDrop/3_OVA_Usage.md)


## Deployment & Usage of OVA on VirtualBox
- Import `k8-rebuild.ova` with the (4GB RAM, 1 Cores, and 8 GB disk)
    - to increase disk size, `Ctrl+D` > Pick your K8-Rebuild VM > Properties
    - if size hasn't been updated on the VM, run:
        ```
        sudo growpart /dev/sda1
        sudo resize2fs /dev/sda1
        ```

- For usage, please see [here](https://github.com/k8-proxy/GW-proxy/blob/master/OVAs-creation/OVA-MDs/FileDrop/3_OVA_Usage.md)

