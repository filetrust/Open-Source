### This MD contains details on how to create HAProxy Web OVA from scratch.

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

* Switch to root user and execute the following commands 

```bash
sudo su -
```

```bash
apt update
```

```bash
apt upgrade -y
```

```bash
apt install -y haproxy
```

* Edit Haproxy configuration file by appending the following to it.

```bash
cat >> /etc/haproxy/haproxy.cfg << EOF
frontend http-glasswall
        bind *:80
        option tcplog
        mode tcp
        default_backend http-nodes        
backend http-nodes
        mode tcp
        balance roundrobin
        server web01 54.78.209.23:80 check

frontend https-glasswall
        bind *:443
        option tcplog
        mode tcp
        default_backend https-nodes       
backend https-nodes
        mode tcp
        balance roundrobin
        option ssl-hello-chk
        server web01 54.78.209.23:443 check
          
#Haproxy monitoring Webui(optional) configuration, access it <Haproxy IP>:32700
listen stats
bind :32700
stats enable
stats uri /
stats hide-version
stats auth username:password

EOF

```

```bash
systemctl restart haproxy.service
```

* Make sure haproxy is active and running

```bash
systemctl status haproxy.service
```
## Exporting OVA

* Shut down the machine 
* Open the controller machine (Or from your local machine, just the controller machine speed the things up)
* Run the following command to export the VM with OVA extension, it will be exported in your current working directory.

Note: the username and password to be provided here are the initial ESXI server credentials  

```bash
ovftool vi://46.165.225.145/HAProxy-WEB ./HAProxy-WEB.ova
```

![image](https://user-images.githubusercontent.com/58347752/100608447-15eb3d00-3315-11eb-90b9-788e0d59a0e6.png)