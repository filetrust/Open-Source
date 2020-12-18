## GovUK Offline OVA Import to ESXi

- Download **s3://glasswall-sow-ova/vms/gov-uk/GovUK.ova** (AWS S3 bucket), you can download it [here](https://glasswall-sow-ova.s3-eu-west-1.amazonaws.com/vms/gov-uk/GovUK.ova)

- Login to VMware ESXi with a privliged user (i.e: **root**)

- From sidebase choose **Virtual machines**

- Click **Create / Register VM**

- Choose **Deploy a virtual machine from OVF or  OVA file**

- Click **Click to select files or drag/drop** and select the **.ova** file downloaded from the S3 bucket 

- Select desired storage and *optionally* tweak VM configuration

- Wait for the import to finish

- Start the VM and wait until it's fully booted

- login as **`glasswall`** using the password **`Gl@$$wall`**

* Unless your environment does **not** use DHCP for network configuration,  you should have everything running, you can get your VM ip by running `ip addr show`
  
  If DHCP isn't used or for some reason the VM could not fetch automatic network configuration, you will have to:
  
  - Configure network manually, this can be done by modifying `/etc/netplan/network.yaml` , for reference, you can use this example:
    
    ```yaml
    network:
      version: 2
        ethernets:
          eth0:
            addresses:
              - 192.168.0.3/24 # Replace this with desired IP address in CIDR format
            gateway4: 192.168.0.1 # Replace this with desired gateway
            nameservers:
              addresses: [8.8.8.8, 1.1.1.1] # Replace DNS servers if needed
    ```

- Run `sudo netplan apply` to apply new network configuration

- Edit the local computer hosts file (C:\Windows\System32\drivers\etc\hosts on WIN, /etc/hosts on MAC and Linux), append the following to the end of the file, replace the placeholder with the VM ip address
  
  ```
  <VM IP ADDRESS> www.gov.uk assets.publishing.service.gov.uk www.gov.uk.local assets.publishing.service.gov.uk.local
  ```