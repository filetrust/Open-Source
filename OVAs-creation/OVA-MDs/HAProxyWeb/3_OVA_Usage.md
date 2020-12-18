## HAProxy Web OVA Usage


### Client configuration 

* Add hosts records to your client system hosts file ( i.e **Windows**: C:\Windows\System32\drivers\etc\hosts , **Linux, macOS and  Unix-like:** /etc/hosts ) as follows

```
<Deployed OVA VM IP ADDRESS> glasswallsolutions.com.glasswall-icap.com
```

make sure that tcp ports **80** and **443** are reachable and not blocked by firewall.

### Access the proxied site

* You can access the proxied site by browsing [glasswallsolutions.com.glasswall-icap.com](https://glasswallsolutions.com.glasswall-icap.com).
* Verify that your access is established through the haproxy loadbalancer through the network tab, the Request address should show the Loadbalancer server IP as shown below

![image](https://user-images.githubusercontent.com/58347752/100607205-4500af00-3313-11eb-8f14-b075e74108a7.png)

* In case https://glasswallsolutions.com.glasswall-icap.com is not available, check non-proxied site (comment out values from local hosts file)

---
---