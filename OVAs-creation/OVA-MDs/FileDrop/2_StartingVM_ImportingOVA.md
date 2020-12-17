## SOW REST (FileDrop) OVA Import

## Starting the VM

* Access esxi  server with valid credentials

* Create a new Linux, Ubuntu (64-bit) VM with minimal hardware specs
    * 1 CPU
    * 1 GB RAM
    * 16 GB of Harddisk (remember to make disk Provisioning to be thin provisioned)) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Set CD/DVD drive is connected at power on and choose the ISO to boot from

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)

* Finish installation and boot the machine with default configuration

* Once you "Power ON" your Machine start with setup. Pay attention to the steps below. 

* In the network configuration, under ens160, edit the IPV4 method to be manual and add the network configuration. Example on image below. This IP addresses are ESXi related and can be obtained from corresponding channel.

  ![Networkconnection](https://user-images.githubusercontent.com/70108899/100768735-82d90280-33fb-11eb-8e1d-f60164fad167.PNG)

* Set the username to be glasswall and set password to agreed password (you can also use `user/secret` in testing purposes)

Once installation is done restart the VM and press enter when it asks to remove the CD

Creating VM on ESXi, video instructions: **https://www.loom.com/share/1b81bef51ea341938bb8dd04a2d62ee9**

## Importing OVA to ESXI

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
