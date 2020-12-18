## Proxy Rebuild OVA Import

- Download the OVA from [here](https://glasswall-sow-ova.s3.amazonaws.com/vms/proxy-rebuild/proxy-rebuild.ova?AWSAccessKeyId=AKIA3NUU5XSYVTP3BV6R&Signature=dtziT6Pbep9%2BmXosxGFo%2BBNnNkI%3D&Expires=1607594681
)
- Open VMware > Open A Virtual Machine > Pick downloaded OVA file

- Be aware of the following errors:
![image](https://user-images.githubusercontent.com/70108899/101050857-1ee24580-3585-11eb-90e3-6701379b769a.png)

![image (1)](https://user-images.githubusercontent.com/70108899/101050996-489b6c80-3585-11eb-9865-f0204f00fa47.png)
- Before starting the VM, 
    - make sure a network adapter is attached to the VM
- Start Proxy Rebuild VM
- Login (username: glasswall, password: )
- Go to `~/vmware-scripts/proxy-rebuild` folder and update git repo:
  ```
  cd ~/vmware-scripts/proxy-rebuild && git pull origin main
  ```
- Run below command after updating it with the IP address of the VM and gateway IP address of our choice.
  ```
  sudo ./01-network-setup.sh <ip_address/nn> <gateway_address>  (example : sudo ./01-network-setup.sh 78.159.113.48/26 78.159.113.62 )
  ```
- Run `02-setup-proxy.sh` to upgrade the helm release with the ICAP server IP address that needs to be used by the proxy. When prompted, pass the IP addresses of offline gov.uk and wordpress websites, or hit Enter to use defaults.
  ```
  ./02-setup-proxy.sh <ICAP server IP> (example: ./02-setup-proxy.sh 78.159.113.47)
  ```