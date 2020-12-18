## GovUK offline OVA Usage

### GovUK OVA (OVF + VMDK) is hosting a clone of `www.gov.uk` website.
### This hosting clone has the html of www.gov.uk recursively scraped + all files linked in www.gov.uk in assets.publishing.service.gov.uk.
### This is all packed inside gov_uk.zip.


* Download ca.pem from the VM home folder, this can be done by running `scp`  from your client computer as in the following example, replace the placeholder IP with the VM IP
  
  ```bash
  scp glasswall@<VM IP ADDRESS>:/home/glasswall/ca.pem .
  ```

* Open firefox, From the menu choose ***Preferences*** and search for ***certificates*** and press of ***View certificates*** 

* From the ***Authorities*** tab, Import the created file on your desktop ***ca.pem*** and make sure to trust it

![image](https://user-images.githubusercontent.com/58347752/101023030-de7dca00-357a-11eb-8335-78de7f89aee1.png)

![image](https://user-images.githubusercontent.com/58347752/101023218-21d83880-357b-11eb-9059-1911dd0b410d.png)

* Try to access gov uk website: **https://www.gov.uk**

---
---