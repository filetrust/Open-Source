### This MD contains details on how to create GovUK OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Linux, Ubuntu (64-bit) VM with the follwing hardware specs:
    * 1 CPU,
    * 1 GB RAM
    * 80 GB of Harddisk (set disk Provisioning to be thin provisioned) 


* Set CD/DVD drive is connected at power on and choose the ISO to boot from (live ubuntu server iso)

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)
  
* Finish installation and reboot the VM.

## Installation

- Clone the repo and run configure.sh from /home/glasswall/GW-proxy/OVAs-creation/govuk
  
  ```bash
  git clone https://github.com/k8-proxy/GW-proxy
  cd GW-proxy/OVAs-creation/govuk
  ./configure.sh
  ```

- Download the Gov.uk clone archive `wget -O ~/gov_uk.zip https://glasswall-sow-ova.s3-eu-west-1.amazonaws.com/vms/gov-uk/gov_uk.zip`

- Extract the archive into **`/var/www/html`**, but before that create directory www and html inside 

  ```bash
  sudo apt install -y unzip
  unzip ~/gov_uk.zip
  # This last command will take some time
  ```
- After extracting the archive correctly, delete the archive to save space `rm ~/gov_uk.zip`

- Power off the VM `sudo poweroff` then export the VM to OVA/OVF