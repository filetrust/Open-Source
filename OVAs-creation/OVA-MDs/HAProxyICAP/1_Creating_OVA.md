### This MD contains details on how to create HAProxy ICAP OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Linux, Ubuntu (64-bit) VM with the follwing hardware specs:
    * 1 CPU,
    * 1 GB RAM
    * 16 GB of Harddisk (set disk Provisioning to be thin provisioned) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Also CD/DVD drive is connected at power on and choose the ISO to boot from

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)

* Finish installation and boot the machine with default configuration

* In the network configuration, edit the IPV4 method to be manual and add the network configuration 

  ![Networkconnection](https://user-images.githubusercontent.com/70108899/100768735-82d90280-33fb-11eb-8e1d-f60164fad167.PNG)

* Set the username to be glasswall and the agreed password (same password as the controller VM)

Once installation is done restart the VM and press enter when it asks to remove the CD


## Installation

* Following the steps in this documentation we will install HAProxy to work as a load balancer for ICAP server

  https://github.com/k8-proxy/gp-load-balancer/blob/main/haproxy-icap.md

* Clone this repository and run the script for auto install

```bash
cd
git clone https://github.com/k8-proxy/gp-load-balancer
sudo su -
#Please replace the placeholder with your username
cd /home/<username>/gp-load-balancer
./haproxy.sh
```

* Make sure haproxy is active and running

```bash
systemctl status haproxy.service
```

* To confirm functionality telnet your localhost on port 1344 & press 'Enter' multi times as follow

  ```bash
  telnet localhost 1344
  ```

* It should print the following indicating server : C-ICAP/0.5.6

  ```
  Trying 127.0.0.1...
  Connected to localhost.
  Escape character is '^]'.
                  
  
  ICAP/1.0 400 Bad request
  Server: C-ICAP/0.5.6
  Connection: close
  
  Connection closed by foreign host.
  ```

Or for manual installation or for extra configuration manipulation other than the default ones, please follow the manual steps in the link provided above