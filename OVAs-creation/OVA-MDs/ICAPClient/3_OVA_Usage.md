## ICAP Client OVA Usage

- Access VM with deployed ICAP Client OVA

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

---
---