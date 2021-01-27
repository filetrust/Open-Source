## Pre-requisites
- File-drop AMI (from GithubActions)

## Deployment & Usage of OVA on ESXI
- For deployment, please see [here](https://github.com/k8-proxy/GW-proxy/blob/master/OVAs-creation/OVA-MDs/FileDrop/2_Importing_OVA.md)
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

