## Minio Server Offline OVA Import

- Download OVA file from S3

- From the controller (or from whatever the machine you have exported the OVA file to), access the ESXi server 

- Register a new VM and choose to be deployed from OVA or OVF file option

- Upload the OVA file and then finish the installation with default configuration

- Wait the upload to be done

- Start Minio Server VM
- Login (username: **glasswall**, password: **Gl@$$wall**)
- In the VM's terminal, run `ip a ` where you will find your main network interface, example `ens160`
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
    where under `addresses` you give your VM an IP from your network, example: `192.168.43.100`, followed by a gateway IP, example `192.168.43.1`
    **Note**: since this is a yaml file, please make sure that you follow the correct indentation 
- run `sudo netplan apply`