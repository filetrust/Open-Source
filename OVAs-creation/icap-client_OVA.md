# Creating & exporting icap client OVA on VMware ESXI


## Creating the VM

* Access esxi server with valid credentials   [esxi01.glasswall-icap.com](http://esxi01.glasswall-icap.com) 

* Create a new Ubuntu linux (64-bit) VM with minimal hardware specs (1 CPU , 2 GB ram & 10 GB of Harddisk(remember to make disk Provisioning to be thin provisioned  )) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Also CD/DVD drive is connected at power on and choose the ISO to boot from

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)

* Finish installation and boot the machine with default configuration

* Set the username to be root and the agreed password (same password as the controller VM)

Once installation is done restart the VM and press enter when it asks to remove the CD

## Setting up network, enable docker and install git

### Seting network following commands:

- Get list network interface
```
>ip a
# you should get network interface like :
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:50:a3:ec brd ff:ff:ff:ff:ff:ff
    altname eno1
    altname enp11s0
    altname ens192
    inet 91.109.25.89/27 brd 91.109.25.95 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe50:a3ec/64 scope link
       valid_lft forever preferred_lft forever
	   
#So, the network interface is eth0, you should use it for network configuration
```
- Config network IP address
```	   
>cd /etc/netplan
#by default, network config file is 0-installer-config.yaml
>ls
#by default, network config file is 0-installer-config.yaml or something like this
>vi 0-installer-config.yaml
# if your system use dhcp, do not change anything
# if your system use static IP, change the file follow example below:
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses: [91.109.25.89/27]
      gateway4: 91.109.25.94
      nameservers:
        addresses: [8.8.8.8]
  version: 2
#Save and exit vi
```
- Restart network service
```
>sudo netplan apply
>ip a
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 00:0c:29:50:a3:ec brd ff:ff:ff:ff:ff:ff
    altname eno1
    altname enp11s0
    altname ens192
    inet 91.109.25.89/27 brd 91.109.25.95 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::20c:29ff:fe50:a3ec/64 scope link
       valid_lft forever preferred_lft forever
```
### Install docker and install git

- After network configuration, following ![here](https://docs.docker.com/engine/install/ubuntu/) to install docker on ubuntu - this is official instruction

- Install git (if it is not installed)
```
sudo apt install git
```

### Installation

- Clone icap client repo
```
git clone https://github.com/k8-proxy/icap-client-docker.git
#Go to docker folder
cd icap-client-docker/
```
- Install docker icap client
```
docker build -t c-icap-client .
```
- Check docker image is already
```
docker image ls
# should be like:
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
c-icap-client                   latest              7ec35e673ba9        20 hours ago        1.2GB
gcc                             latest              4d3d1ec24e9e        2 weeks ago         1.19GB
glasswallsolutions/k8-centos7   latest              431852dc2eb5        3 weeks ago         419MB
```
- Test docker icap-client 
```
#you should upload any pdf file to your directory ( like /root), I upload file Execute+Java+Script_JS_PDF.pdf for testing
#Make sure have any stable ICAP server, I use ICAP-server 54.77.168.168 for this test
#Run command below:
docker run -v /root:/root --network host c-icap-client -i 54.77.168.168 -p 1344 -s gw_rebuild -f /root/Execute+Java+Script_JS_PDF.pdf -o /root/clean.pdf -v
#check to make sure file clean.pdf is created
ls -l
-rwxr----- 1 root root 383912 Dec  9 15:08 clean.pdf
-rw-r----- 1 root root 386176 Dec  8 10:17 Execute+Java+Script_JS_PDF.pdf
```
## Install BootScriptWizard to change password and network configuration for first time of VM

### TUI Configuration Wizard

Configuration wizard, currently features the following configuration

- Change current user password

- Change network configuration

#### Environment dependencies

**wizard.sh** must be run in an environment that provides the following:

- Operating system is Ubuntu server, with netplan as network configuration manager (which is the default in latest Ubuntu LTS)

- The user must be a sudoer (or **root** ), must be able to execute sudo without a passwor, this can be done as follows
  
  ```bash
  echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
  ```
  
  if your user is not a sudoer, you must run it as root user while replacing **`$USER`** with your username

  You'll have to configure netplan file(s) to replace interfaces names for predictable naming, for example:
  
  ```bash
  cat > /etc/netplan/network.yaml <<EOF
  network:
    version: 2
      renderer: networkd
      ethernets:
        eth0:
  #     ^^^^  Notice the interface naming
          dhcp4: false # You can switch it to true then remove following lines
          addresses:
            - 192.168.0.3/24 # Replace this with desired IP address in CIDR format
          gateway4: 192.168.0.1 # Replace this with desired gateway
            nameservers:
              addresses: [8.8.8.8, 1.1.1.1] # Replace DNS servers if needed
  EOF
  ```
  
  You have to reboot after theses changes to apply

#### Installation

- Clone the repo
  
  ```bash
  git clone https://github.com/k8-proxy/GW-proxy
  ```

- Install the wizard as following
  
  ```bash
  sudo install GW-proxy/automation/scripts/wizard/wizard.sh -T /usr/bin/wizard -m 0755
  ```
### Boot script configuration

- Create initconfig script file
```
sudo nano /usr/bin/initconfig.sh
#!/bin/bash

sleep 10
clear
echo "

InitConfig

"


/usr/bin/wizard.sh

systemctl disable initconfig

reboot
exit
```

- Change initconfig.sh to execute mode 
```
chmod 755 /usr/bin/initconfig.sh
```	
- Create init service
```
sudo nano /etc/systemd/system/initconfig.service
```
- File initconfig.service looke like below :
```
[Unit]
Description=InitConfig

[Service]
Type=oneshot
ExecStart=/usr/bin/openvt -s -w /usr/bin/initconfig.sh

RemainAfterExit=yes
TimeoutSec=0

# Output needs to appear in instance console output
StandardOutput=journal+console

[Install]
WantedBy=cloud-init.target
```
- Reload and enable initconfig
```
systemctl daemon-reload
	
systemctl enable initconfig
```
 
- To reanable First Boot experience you can issue only the last command.

## Remove unnecessary components 

- Delete unnecessary logs, keys and history (every command should be issued double):
```
sudo rm -rf ~/<unnecessary file, folder such as git clone, template ..>
sudo rm -f /etc/ssh/.pub
sudo rm -f /etc/ssh/.key
sudo logrotate --force /etc/logrotate.conf
history -c && history -w
```
### Reset network seting to DHCP mode

- Delete current network setting
```
sudo rm /etc/netplan/*
```
- Create network DHCP config file
```
sudo nano /etc/netplan/00-dhcp-network.yaml
#Edit file as below:
network:
  ethernets:
    ens33:
	  dhcp: true
  version: 2
# Ctrl-O to save and Ctrl-X to exit
```
- Restart network
```
sudo netplan apply
```

## Exporting OVA

* Shut down the machine 
* Open the controller machine (Or from your local machine, just the controller machine speed the things up)
* Run the following command to export the VM with OVA extension (change to corresponding ESXI IP/URL and VM name), it will be exported in your current working directory.

Note: the username and password to be provided here are the initial ESXI server credentials  

```bash
ovftool vi://46.165.225.145/icap-client icap-client.ova
```

## Importing OVA and test icap-client

- Download OVA file from [here](https://glasswall-sow-ova.s3-eu-west-1.amazonaws.com/vms/icap-client/icap_client.ova)

- From the controller (or from whatever the machine you have exported the OVA file to) , access the esxi server 

- Register a new VM and choose to be deployed from OVA or OVF file option

- Upload the OVA file and then finish the installation with default configuration

- Wait the upload to be done and you are good to go.

- By default, you should change password of username glasswall and configure network when VM start, please follow to change it

- Welcome screen

![image](https://user-images.githubusercontent.com/29745336/101893950-09e66180-3bd8-11eb-9cf7-ad36657005c1.PNG)

- Change password screen

![password](https://user-images.githubusercontent.com/29745336/101894045-284c5d00-3bd8-11eb-9a09-f300eb409ac6.PNG)

- Change network screen

![network2](https://user-images.githubusercontent.com/29745336/101894090-3a2e0000-3bd8-11eb-96a2-7aa33a2d99cd.PNG)
​​​
- After the change, system will reboot, you will login with username glasswall/<your password>

- Check docker image is already
```
docker image ls
# should be like:
REPOSITORY                      TAG                 IMAGE ID            CREATED             SIZE
c-icap-client                   latest              7ec35e673ba9        20 hours ago        1.2GB
gcc                             latest              4d3d1ec24e9e        2 weeks ago         1.19GB
glasswallsolutions/k8-centos7   latest              431852dc2eb5        3 weeks ago         419MB
```
- Test docker icap-client 
```
cd ~
#you should upload/use any file in your directory ( like /root), I upload file Execute+Java+Script_JS_PDF.pdf via ssh for testing
#Make sure we have a stable ICAP server, I use ICAP-server 54.77.168.168 for this test
#Run command below:
docker run -v /home/glasswall:/home/glasswall --network host c-icap-client -i 54.77.168.168 -p 1344 -s gw_rebuild -f /home/glasswall/Execute+Java+Script_JS_PDF.pdf -o /home/glasswall/clean.pdf -v
#check to make sure file clean.pdf is created
ls -l
-rwxr----- 1 root root 383912 Dec  9 15:08 clean.pdf
-rw-r----- 1 root root 386176 Dec  8 10:17 Execute+Java+Script_JS_PDF.pdf
```  

