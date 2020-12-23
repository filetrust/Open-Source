## HAProxy ICAP OVA Usage

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