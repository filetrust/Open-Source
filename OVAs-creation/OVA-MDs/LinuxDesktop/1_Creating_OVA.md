### This MD contains details on how to create Linux Desktop OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Ubuntu linux (64-bit) VM with:
  * 2 CPU
  * 4 GB ram 
  * 32 GB of Harddisk (set disk Provisioning to be thin provisioned) 

  ![image](https://user-images.githubusercontent.com/58347752/101004090-23006a00-3569-11eb-9052-1f5a9d3dbb99.png)

* Also CD/DVD drive is connected at power on and choose ***UBUNTU DESKTOP ISO*** to boot from

  ![image](https://user-images.githubusercontent.com/58347752/101005217-74a8f480-3569-11eb-8e7d-2fa83835c179.png)

* Finish installation and reboot the VM.

## Installation

* Power on created VM.

* Select to install ubuntu and continue with all default configuration.

* Set the username to be `glasswall` and password to `Gl@$$wall`

* Once installation is done restart the VM and press enter when it asks to remove the CD.

* Once Ubuntu Desktop interface appears, login and open Network settings (Go to Power button in the upper right corner, select Settings and choose Network from the left side bar)

* Edit Wired connection (click on settings button next to "Connected - 10000Mb/s")
  * go to IPV4 tab
  * set IPV4 method to be ***Manual*** 
  * add a valid IP address from the provided list, along with netmask and gateway
  * set the the DNS to be manual (set to off automatic button) and add the following ***8.8.8.8***  (Please refer to this step again if you want to change any network configurations in later stages)

  ![image](https://user-images.githubusercontent.com/58347752/101046373-a9c53f00-3589-11eb-8aea-c4e263d0c2ff.png)

* Open the terminal and use the following commands to apply network configuration changes

  ```bash
  nmcli connection down Wired\ connection\ 1
  nmcli connection up Wired\ connection\ 1
  ip a # verify correct address for ens160
  ```

* Install prerequisites 

  ```bash
  sudo apt update
  sudo apt upgrade -y
  sudo apt install -y vim ssh c-icap net-tools open-vm-tools
  sudo apt update && sudo apt upgrade
  ```

  
* Allow Remote desktop connection 

  ```bash
  sudo apt-get install xrdp -y
  sudo systemctl enable --now xrdp
  sudo ufw allow from any to any port 3389 proto tcp
  ```

* OPTIONAL (in case you want to access Linux Desktop VM remotely)

  Install ***Nomachine*** - a remote desktop tool that's more reliable than Remote Desktop

  ​From Firefox visit the following link https://www.nomachine.com/download/download&id=2 and click on download and then from terminal run the following

  ```bash
  cd /home/glasswall/Downloads
  sudo dpkg -i nomachine_6.12.3_7_amd64.deb
  ```
  
  ​Now from any remote client that has nomachine installed on it you can access this VM using the configured IP and the username and password.


* Download and install ovftool from This [link](https://download2.vmware.com/software/vmtools/1105/VMware-ovftool-4.4.0-15722219-lin.x86_64.bundle?HashKey=0ae0062f8101b853e7c677c183820f4a&params=%7B%22custnumber%22%3A%22dEBkaHdlamUqZQ%3D%3D%22%2C%22sourcefilesize%22%3A%2238.57+MB%22%2C%22dlgcode%22%3A%22OVFTOOL440%22%2C%22languagecode%22%3A%22en%22%2C%22source%22%3A%22BETA%22%2C%22downloadtype%22%3A%22manual%22%2C%22eula%22%3A%22N%22%2C%22downloaduuid%22%3A%226a50c45a-8320-489a-89cd-caba573f7462%22%2C%22purchased%22%3A%22N%22%2C%22dlgtype%22%3A%22Drivers+%26+Tools%22%2C%22productversion%22%3A%224.4.0%22%7D&AuthKey=1607006924_f313c8fb4e891f142ef8ac5a6180cd63) (you will may need login credentials)

  ```bash
  cd /home/glasswall/Downloads
  sudo chmod 755 VMware*
  #The following command must be used through a terminal opened withen the graphical user interface (A pop up window will be shown)
  ./VMware*
  ```

* Install this certificate into the client machine and mark it as a trusted root certificate from browsers point of view. As you will need to copy/paste, you should ssh via putty or local cmd to VM in order to create certificate.pem

  ```bash
  cd /home/glasswall/Desktop
  cat >> certificate.pem << EOF
  -----BEGIN CERTIFICATE-----
  MIIDvjCCAqagAwIBAgIIa3VJt1eLgRYwDQYJKoZIhvcNAQELBQAwZTELMAkGA1UE
  BhMCVUsxDjAMBgNVBAgTBUVzc2V4MRcwFQYDVQQKEw5HVyBEZXZlbG9wbWVudDEU
  MBIGA1UECxMLRGV2ZWxvcG1lbnQxFzAVBgNVBAMTDkdXIERldmVsb3BtZW50MB4X
  DTIwMDkwODA5MTkwMFoXDTMwMDkwODA5MTkwMFowZTELMAkGA1UEBhMCVUsxDjAM
  BgNVBAgTBUVzc2V4MRcwFQYDVQQKEw5HVyBEZXZlbG9wbWVudDEUMBIGA1UECxML
  RGV2ZWxvcG1lbnQxFzAVBgNVBAMTDkdXIERldmVsb3BtZW50MIIBIjANBgkqhkiG
  9w0BAQEFAAOCAQ8AMIIBCgKCAQEAmKobrHfirIHK9VxqZ2ezA+dT0c03stu1TPjY
  PYUwFZrwyejjWU8S3GREjSXO76dntRPr8tetzJShzMQikt55VcnAcZCcdzd1QK23
  H/vlnncIwkqzCPIuV76FfzleT+rVFrl4MS03LY4j4uwrinEkjl/wvIXv64fyl0Cl
  8ACvRcuunBapoUDkSdW1v1v2n6jiyF+Ob+xvczbiaRC/dITm00x81WQKGL66A/8C
  QdSknLH6vcj91Sg5aUvNEB4wXhBctY73HOsV3j8qo379LdXxJwt1B1Y4WaWI3rS5
  fEck7XmhW5OGvHEW4GJvh7/AjE7GoFYKB4n51oeDZfdafTdfsQIDAQABo3IwcDAP
  BgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBShDr/9+fHtWRQv+ww/3xuYmkGfWTAL
  BgNVHQ8EBAMCAQYwEQYJYIZIAYb4QgEBBAQDAgAHMB4GCWCGSAGG+EIBDQQRFg94
  Y2EgY2VydGlmaWNhdGUwDQYJKoZIhvcNAQELBQADggEBAHMdmsVvWp4unMF2h0H6
  +RX+npWFLvjSmrQiLSWjmPykZQZhXeEtMU1pRP53z/BUKjxcozIDe+/rrp9jLA+3
  gg5gUML5l/XuH/7ad0JBp9cu+G10hFK69hWID36jpzPPrAHdMc2rFETGpXuYw85b
  8q3mJ95psrccQiGM/Jgr1sU+Mwz5f7Jpkg0nLWcmA/ORkBidWsK5ZWusfL7tglQE
  y/S0g2yAG+SPbb54bH+N6c3gcHuBdlcGu5WW3ZHad0f2hLRMK/UaPbT1igcrxxur
  AIB35OlLRDs3BUdmx+YD/DAqxITHVne7nEEstq84lK6VYBFBUzUQ6M50N6COrYBR
  21w=
  -----END CERTIFICATE-----
  
  EOF
  ```

* Then Open firefox, From the menu choose ***Preferences*** and search for ***certificates*** and press of ***View certificates*** 

* From the ***Authorities** tab, Import the created file on your desktop ***certificate.pem*** and make sure to trust it

![image](https://user-images.githubusercontent.com/58347752/101023030-de7dca00-357a-11eb-8335-78de7f89aee1.png)

![image](https://user-images.githubusercontent.com/58347752/101023218-21d83880-357b-11eb-9059-1911dd0b410d.png)

* Then open firefox again, From the menu choose ***Preferences*** and search for ***home page*** then set the home page to be https://github.com/k8-proxy/ESXI-setup-server/wiki
  ![image](https://user-images.githubusercontent.com/58347752/101022000-6ebb0f80-3579-11eb-964f-fccd2afea757.png)


## Exporting OVA

* Shut down the machine 
* Open the controller machine (Or from your local machine, just the controller machine speed the things up)
* Run the following command to export the VM with OVA extension, it will be exported in your current working directory.(esxi server credentials are required)

```bash
ovftool vi://78.159.113.4/Linux-Desktop ./Linux_Desktop.ova 
```
