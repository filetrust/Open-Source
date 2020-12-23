### This MD contains details on how to create Minio Server Offline OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Ubuntu linux (64-bit) VM with:
  * 1 CPU
  * 1 GB RAM 
  * 16 GB of Harddisk (set disk Provisioning to be thin provisioned) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Also CD/DVD drive is connected at power on and choose ***UBUNTU DESKTOP ISO*** to boot from

  ![image](https://user-images.githubusercontent.com/58347752/101005217-74a8f480-3569-11eb-8e7d-2fa83835c179.png)

* Finish installation and reboot the VM.

## Installation

- Power on VM > Pick settings for VM (language, username & password install openssh, etc.)
- when asked to reboot now > power off VM > Actions > Edit Settings > Remove **CD/DVD Drive 1**
- Now, Power on & let the OS finish setting up, after which you wil be able to login

- run `ip a` and find the name of the first network interface after loopback, which in this case is `ens160`
- `cd /etc/netplan` & run `ls` to check the files available (there should only be 1), so we'll modify it with `sudo vi $name_of_file)` and modify it to be:
    ```
    network:
    version: 2
    renderer: networkd
    ethernets:
        ens160:
        dhcp4: no
        addresses:
            - 91.109.25.79/27
        gateway4: 91.109.25.94
        nameservers:
            addresses: [8.8.8.8]
    ```
- run `sudo netplan apply`
- in the VM, you'll be able to ping the gateway and have access to internet
- install docker by:
    ```
    sudo apt update
    ```
    ```
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
    ```
    ```
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    ```
    ```
    sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
   ```
   ```
    sudo apt update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```
- install minio server by:
    ```
    sudo docker pull minio/minio:latest
    sudo docker run -d --restart=always -p 80:9000 \
  --name minio1 \
  -v /mnt/data:/data \
  -e "MINIO_ACCESS_KEY=user" \
  -e "MINIO_SECRET_KEY=secret_password" \
  minio/minio server /data
  ```


## Exporting OVA

* Shut down the machine 
* Open the controller machine (Or from your local machine, just the controller machine speed the things up)
* Run the following command to export the VM with OVA extension, it will be exported in your current working directory.(esxi server credentials are required)

```bash
ovftool vi://78.159.113.4/Linux-Desktop ./Linux_Desktop.ova 
```
