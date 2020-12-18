## HAProxy ICAP OVA Import

- From the controller (or from whatever the machine you have exported the OVA file to), access the esxi server 

- From sidebase choose **Virtual machines**

- Click **Create / Register VM**

- Choose **Deploy a virtual machine from OVF or  OVA file**

- Click **Click to select files or drag/drop** and select the **.ova** file downloaded from the S3 bucket 

- Select desired storage and *optionally* tweak VM configuration

- Wait for the import to finish

- Start the VM and wait until it's fully booted

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