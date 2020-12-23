## Support Server OVA Import

1.  Log in to the ESX server.

2.  Choose **Create / Register VM**.

3.  Choose **Deploy a virtual machine from OVF or OVA file** and click **Next**.

4.  Choose **Name** corresponding to the function e.g. glasswallsolutions.com and drop OVA file and click **Next**.

5.  Choose **Standard** and default datastore and click **Next**.

6.  Confirm deployments option.

7.  Click **Next** and **Finish** (You can ignore Warning about the
    missing image).

8.  After machine bootup chooses **Console** / **Open browser console**.

9.  Log-in to the machine.

10. isse **sudo vi /etc/netplan/00-installer-config.yaml**and eventually correct network parameters

11. Issue **sudo netplan --debug apply**.

12. Check IP address using **ip a**.