## SOW REST (FileDrop) OVA Import to ESXi


- Download all files from **s3://glasswall-sow-ova/vms/SOW-REST/** (AWS s3 bucket)

- Login to VMware ESXi with a privliged user (i.e: **root**)

- From sidebase choose **Virtual machines**

- Click **Create / Register VM**

- Choose **Deploy a virtual machine from OVF or  OVA file**

- Click **Click to select files or drag/drop** and select the **.ovf**, **.vmdk**, **.nvram** and the **.mf** files downloaded from the S3 bucket 

- Select desired storage and *optionally* tweak VM configuration

- Wait for the import to finish

- login as **`user`** using the password **`secret`**
* Unless your environment does **not** use DHCP for network configuration,  you should have everything running
  
  If DHCP isn't used or for some reason the VM could not fetch automatic network configuration (this is the case for ESXi VM), you will have to:
  
  - Configure network manually, this can be done by modifying `/etc/netplan/01-netcfg.yaml` , for reference, you can use this example:
    
    ```yaml
    network:
      version: 2
        renderer: networkd
        ethernets:
          eth0:
            addresses:
              - 192.168.0.3/24 # Replace this with desired IP address in CIDR format
            gateway4: 192.168.0.1 # Replace this with desired gateway
              nameservers:
                addresses: [8.8.8.8, 1.1.1.1] # Replace DNS servers if needed
    ```
  
  - run: `sudo netplan apply`
  - Restart k3s service by executing `sudo systemctl restart k3s`