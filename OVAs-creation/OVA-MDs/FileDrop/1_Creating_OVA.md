### This MD contains details on how to create SOW REST (FileDrop) OVA from scratch.

## Starting the VM

* Access esxi server with valid credentials

* Create a new Linux, Ubuntu (64-bit) VM with minimal hardware specs
    * 1 CPU
    * 1 GB RAM
    * 16 GB of Harddisk (remember to make disk Provisioning to be thin provisioned)) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Set CD/DVD drive is connected at power on and choose the ISO to boot from

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)

* Finish installation and boot the machine with default configuration

## Installation 

* Once you "Power ON" your Machine start with setup. Pay attention to the steps below. 

* In the network configuration, under ens160, edit the IPV4 method to be manual and add the network configuration. Example on image below. This IP addresses are ESXi related and can be obtained from corresponding channel.

  ![Networkconnection](https://user-images.githubusercontent.com/70108899/100768735-82d90280-33fb-11eb-8e1d-f60164fad167.PNG)

* Set the username to be glasswall and set password to agreed password (you can also use `user/secret` in testing purposes)

Once installation is done restart the VM and press enter when it asks to remove the CD

Creating VM on ESXi, video instructions: **https://www.loom.com/share/1b81bef51ea341938bb8dd04a2d62ee9**

- This step can be skipped. Network is already configured as prerequisite. Configure network to use DHCP on ESXi will not work. 
  
  ```bash
  sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
  update-grub
  rm /etc/netplan/*.yml /etc/netplan/*.yaml
  cat > /etc/netplan/network.yaml <<EOF
  network:
    version: 2
    ethernets:
      eth0:
        dhcp4: true
  EOF
  ```

- Install K3s: `curl -sfL https://get.k3s.io | sh -`

- Install helm: `curl -fsSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash -`

- Clone the repo and change your working directory into the kubernetes directory: `git clone https://github.com/k8-proxy/sow-rest && cd sow-rest/kubernetes`

- Create kube config: `sudo ln -s /etc/rancher/k3s/k3s.yaml ~/.kube/config`

- Execute `./deploy.sh`

- Access the filedrop URL: `https://<VM IP>` and just click login (login details are not requiered)

- This VM once shutdown, can now be exported as OVA file.