## Proxy Rebuild OVA Usage

- Login into the VM that has Proxy Rebuild OVA imported
- Check the VM ip address by running `ip a`
- Download ca.pem from VM via `scp glasswall@<VM_IP>:/vmware-scripts/proxy-rebuild/ca.pem <local/directory>`
- On your local machine, open firefox, from the menu choose ***Preferences*** and search for ***certificates*** and press of ***View certificates*** 
- From the ***Authorities*** tab, Import the created file on your desktop ***ca.pem*** and make sure to trust it

![image](https://user-images.githubusercontent.com/58347752/101023030-de7dca00-357a-11eb-8335-78de7f89aee1.png)

![image](https://user-images.githubusercontent.com/58347752/101023218-21d83880-357b-11eb-9059-1911dd0b410d.png)

- Add below line to the system's hosts file ( C:\Windows\System32\drivers\etc\hosts on Windows , /etc/hosts on Linux ) for example:
  ```
  <vm_ip_address> glasswallsolutions.com www.glasswallsolutions.com example.local www.example.local gov.uk www.gov.uk assets.publishing.service.gov.uk owasp.org www.owasp.org
  ```
- Open any browser and access [www.glasswallsolutions.com](https://www.glasswallsolutions.com) after adding the IP address of this server to this DNS in hosts file.

---
---