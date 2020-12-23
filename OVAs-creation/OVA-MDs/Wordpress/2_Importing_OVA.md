## Wordpress OVA Import

- Download OVA file from [here](https://glasswall-sow-ova.s3.amazonaws.com/vms/wordpress/Glasswall-wordpress.ova?AWSAccessKeyId=AKIA3NUU5XSYVTP3BV6R&Signature=QwJ78so5inpe%2F4iVG8sqUTB5%2B0Q%3D&Expires=1607568331)

- Open VirtualBox/VMware workstation and import downloaded OVA file: glasswall-wordpress.ova

- Start Glasswall wordpress VM
​
- Login (username: **glasswall**, password: **glasswall**)

- By default, Glasswall wordpress VM is web server and use static IP. Network mode is Brigde 
​​​
- Get ethernets interface
```
$ ip a
# get the network interface name for example ens160
```
- Change network IP mapping to your network following command :
```
glasswall@glasswallwordpress:~$ sudo nano /etc/netplan/00-installer-config.yaml
```
- File 00-installer-config.yaml look like : 
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    ens33:
      addresses: [91.109.25.89/27]
      gateway4: 91.109.25.94
      nameservers:
        addresses: [8.8.8.8]
  version: 2
```
- Change ethernets interface `ens33` by your network interface above

- Change `addresses` to your network example `[192.168.1.100/24]`

- Change `gateway` to your Access point/gateway address, example `192.168.1.1`

- `Nameserver` : change to your DNS nameservers or can use `8.8.8.8` as default 

- Press Ctrl- O to save and Ctrl - X to exit

- Apply network change following command :
```
glasswall@glasswallwordpress:~$ sudo netplan apply
```
- Check to make sure network change successful
```
glasswall@glasswallwordpress:~$ ifconfig
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 91.109.25.89  netmask 255.255.255.224  broadcast 91.109.25.95
        inet6 fe80::20c:29ff:feec:366e  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:ec:36:6e  txqueuelen 1000  (Ethernet)
        RX packets 114325  bytes 6960351 (6.9 MB)
        RX errors 0  dropped 921  overruns 0  frame 0
        TX packets 1323  bytes 834981 (834.9 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

#### Here is the video with above instructions to import OVA: [Glasswall wordpress Website OVA](https://youtu.be/NKiSmCmM2Dc)