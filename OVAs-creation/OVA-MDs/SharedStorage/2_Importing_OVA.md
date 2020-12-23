## Shared Storage (TrueNas) OVA Import

- From the controller (or from whatever the machine you have exported the OVA file to), access the esxi server 

- From sidebase choose **Virtual machines**

- Click **Create / Register VM**

- Choose **Deploy a virtual machine from OVF or  OVA file**

- Click **Click to select files or drag/drop** and select the **.ova** file downloaded from the S3 bucket 

- Select desired storage and *optionally* tweak VM configuration

- Wait for the import to finish

- Start the VM and wait until it's fully booted

- TrueNas VM is now ready to be used