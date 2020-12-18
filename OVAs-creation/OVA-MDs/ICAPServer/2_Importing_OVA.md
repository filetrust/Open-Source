## ICAP Server OVA Import

From VMWare esxi console or VMware workstation, just do
1. File import and browse ICAP Server OVA (downloaded from S3 bucket)

2. Start the VM and log in as glasswall user

3. Run the configuration scripts and health checks as explained bellow
```
cd vmware-scripts/icap-server

## Pull up to date files from repository
git pull origin main

## Configure network interface
sudo ./01-network-setup.sh <ip_address/nn> <gateway_address> (example : sudo ./01-network-setup.sh 78.159.113.47/26 78.159.113.62 )

## Configure kubernetes service
./02-k8s-patch.sh

## Run health check
./03-service-health.sh
```