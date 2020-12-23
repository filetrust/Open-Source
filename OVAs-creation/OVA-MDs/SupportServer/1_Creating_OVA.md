### This MD contains details on how to create Support Server OVA from scratch.

## Starting the VM

1.  Log in to the ESX server

2.  Choose **Create / Register VM**

3.  Choose to **Create a new virtual machine** and click Next

4.  Choose **Name** corresponding to the function e.g. glasswallsolutions.com

5.  Select **Guest OS family** (default Linux)

6.  Select **Guest OS version** (default Ubuntu Linux (64-bit))

7.  Click **Next**.

8.  Choose **Standard** and default datastore and click **Next**.

9.  Do not use more than 1 GB RAM and 16 GB Hard disk space.

10. **SCSI Controller 0** choose **VMware Paravirtual**.

11. Use a single network and a single disk as possible.

12. Remove the USB controller.

13. **CD / DVD Drive 1** - select **Datastore ISO file** with the operating system (recommended Ubuntu 20.x).

14. Click **Next** and **Finish**.

## Install the Operating System in VM

1.  Choose VM and press **Power on.**

2.  After machine bootup chooses **Console** / **Open browser console**.

3.  Install Operating system using the following:

    -   Connect using SSH.

    -   Apt-get update.

    -   English US Language and keyboard.

    -   Configure IPV4 manual.

        -   subnet 91.109.25.64/27.

        -   IP: 91.109.25.x (consult slack to free IP and make IP
            reservation on slack).

        -   gateway: 91.109.25.94.

        -   name servers: 8.8.8.8.

    -   username "glasswall".

    -   Use entire disk

    -   Do not use LVM

    -   use complicated password.

    -   Use the corresponding server name to function for the server.

    -   Install SSH.

    -   Install minimum packages.

4.  Test connection using SSH:

    -   Connect using SSH.

5.  Update operating system:

    -   Connect using SSH.

    -   sudo apt-get update.

## Installation

6.  Install and Configure Software:

-   Install Bind:
```bash
sudo su -
apt-get update
apt-get install -y bind9
systemctl enable named
systemctl restart bind9
```
-   Create Initial Config of Bind vi /etc/bind/named.conf:
```bash
acl All {
        0.0.0.0/0;
        };
// This is the primary configuration file for the BIND DNS server named.
//
// Please read /usr/share/doc/bind9/README.Debian.gz for information on the
// structure of BIND configuration files in Debian, *BEFORE* you customize
// this configuration file.
//
// If you are just adding zones, please do that in /etc/bind/named.conf.local

include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```
-   Create Initial Config of Bind vi /etc/bind/named.conf.local:
```bash
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";

zone "glasstest.com" {
        type master;
        file "/var/lib/bind/glasstest.com.hosts";
        };
```

-   Create Initial Config of Bind vi /etc/bind/named.conf.options:
```bash
options {
        directory "/var/cache/bind";

        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113

        // If your ISP provided one or more IP addresses for stable
        // nameservers, you probably want to use them as forwarders.
        // Uncomment the following block, and insert the addresses replacing
        // the all-0's placeholder.

        // forwarders {
        //      0.0.0.0;
        // };

        //======================================================================                                                            ==
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //======================================================================                                                            ==
        dnssec-validation no;

        listen-on-v6 { any; };
        forwarders {
                8.8.8.8;
                };
        forward first;
};
```

-   Create Initial Config of Bind vi /var/lib/bind/glasstest.com.hosts:
```bash
$ttl 3600
glasstest.com.  IN      SOA     supportserver01. mf.glasstest.com. (
                        1606930094
                        5M
                        600
                        1209600
                        3600 )
glasstest.com.  IN      NS      supportserver01.
first.glasstest.com.    IN      A       1.1.1.1
sec.glasstest.com.      IN      A       1.1.1.1
tt.glasstest.com.       IN      A       1.1.1.1
```
-   Reconfigure resolver:
```bash
systemctl stop systemd-resolved.service
systemctl disable systemd-resolved.service
systemctl restart bind9.service
rm /etc/resolv.conf
```

-   Reconfigure resolver vi /etc/resolv.conf:
```bash
nameserver 127.0.0.1
```

-   Install Webmin:
```bash
sudo su -
apt-get update
apt -y install software-properties-common apt-transport-https wget
wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add -
add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib"
apt -y install webmin
ufw allow 10000/tcp
```

-   Test to login to webmin using operating system credentials - https://IP_ADDRESS:10000

-   Add PKI to Webmin - https://IP_ADDRESS:10000/webmin/edit_mods.cgi?xnavigation=1 chosse Webmin Modules and install module from HTTP or FTP URL:

```bash
http://www.webmin.com/download/modules/certmgr.wbm.gz
```

-   Install Easy-RSA:
```bash
apt -y install easy-rsa
cd /opt
make-cadir easyrsa
cd /opt/easyrsa
./easyrsa init-pki
./easyrsa build-ca nopass
```

-   Install Easy-RSA - for Ubuntu 18.x - if previous doesn't work
```bash
sudo su -
rm -r /opt/easyrsa
cd /opt
curl -L https://github.com/OpenVPN/easy-rsa/releases/download/v3.0.8/EasyRSA-3.0.8.tgz | tar xzvf -
mv EasyRSA* easyrsa
chown root:root -R easyrsa
cd easyrsa
./easyrsa init-pki
./easyrsa build-ca nopass
```


-   Install Guacamole:
```bash
sudo su -
cd ~
apt-get install make gcc g++ libcairo2-dev libjpeg-turbo8-dev libpng-dev libtool-bin libossp-uuid-dev libavcodec-dev libavutil-dev libswscale-dev freerdp2-dev libpango1.0-dev libssh2-1-dev libvncserver-dev libtelnet-dev libssl-dev libvorbis-dev libwebp-dev -y
apt-get install tomcat9 tomcat9-admin tomcat9-common tomcat9-user -y
systemctl start tomcat9
systemctl enable tomcat9
wget https://downloads.apache.org/guacamole/1.2.0/source/guacamole-server-1.2.0.tar.gz
tar -xvzf guacamole-server-1.2.0.tar.gz
cd guacamole-server-1.2.0
./configure --with-init-dir=/etc/init.d
make
make install
ldconfig
systemctl enable guacd
systemctl start guacd
wget https://mirrors.estointernet.in/apache/guacamole/1.2.0/binary/guacamole-1.2.0.war
mkdir /etc/guacamole
mv guacamole-1.2.0.war /etc/guacamole/guacamole.war
ln -s /etc/guacamole/guacamole.war /var/lib/tomcat9/webapps/
```

-   Configure Guacamole vi /etc/guacamole/guacamole.properties:
```bash
guacd-hostname: localhost
guacd-port:    4822
user-mapping:    /etc/guacamole/user-mapping.xml
```

-   Configure Guacamole:
```bash
mkdir /etc/guacamole/{extensions,lib}
echo "GUACAMOLE_HOME=/etc/guacamole" >> /etc/default/tomcat9
echo -n 'your_password' | openssl md5
```

-   Configure Guacamole adding md5 password for user admin from prevoius command, you can also modify servers IP and users that Guacamole can use in meny - vi  /etc/guacamole/user-mapping.xml:

```bash
<user-mapping>
    <authorize
            username="glasswall"
            password="cac932abcf03019cd760951f23c6b079"
            encoding="md5">

        <connection name="Ubuntu20.04-Server">
            <protocol>ssh</protocol>
            <param name="hostname">40.113.40.146</param>
            <param name="port">22</param>
            <param name="username">root</param>
        </connection>
        <connection name="Windows Server">
            <protocol>rdp</protocol>
            <param name="hostname">40.127.163.22</param>
            <param name="port">3389</param>
        </connection>
    </authorize>
</user-mapping>
```

-   Configure Guacamole to use ad-hock connections:

```bash
cd ~
wget "http://apache.org/dyn/closer.cgi?action=download&filename=guacamole/1.2.0/binary/guacamole-auth-quickconnect-1.2.0.tar.gz" -O guacamole-auth-quickconnect-1.2.0.tar.gz
tar xvfz guacamole-auth-quickconnect-1.2.0.tar.gz
mv guacamole-auth-quickconnect-1.2.0/guacamole-auth-quickconnect-1.2.0.jar /etc/guacamole/extensions/
```

-   Restart Guacamole:
```bash
systemctl restart guacd
systemctl restart tomcat9
```

-   Access to Guacamole http://IP_ADDRESS:8080/guacamole/#/:


7.  Test solution

-   Guacamole

    Go to Guacamole http://IP_ADDRESS:8080/guacamole/#/:
	
	Ad hack connection (Enter Connection URI): ssh://IP_ADDRESS/ or rdp://aw:password@40.127.163.22/?security=any&ignore-cert=true 

-   PKI

    Generate Key and Certificate Signing Request (CSR) 2048 bits https://IP_ADDRESS:10000/certmgr/gencsr.cgi?xnavigation=1
	
	Sign the request (use uniq RequestTest01):
	
```bash
sudo su -
cd /opt/easyrsa
./easyrsa import-req /etc/ssl/csr/hostcsr.pem RequestTest01
./easyrsa sign-req server RequestTest01
```

-   Copy key (/etc/ssl/private/hostkey.pem), cert (/opt/easyrsa/pki/issued/RequestTest01.crt) and CA cert (/opt/easyrsa/pki/ca.crt) and delete files for next request

```bash
sudo su -
rm /etc/ssl/csr/hostcsr.pem
rm /etc/ssl/private/hostkey.pem
```


-   DNS

    https://IP_ADDRESS:10000/bind8/?xnavigation=1
	
	After reconfigure DNS always do 
	
```bash
sudo su -
systemctl restart bind9.service
```

    You can test DNS solution by:

```bash
nslookup
server 127.0.0.1
google.com
second.glasstest.com
```

8.  Prepare OVA

-   Delete unnecessary logs and history:
```bash
sudo rm -f /etc/ssh/*.pub
sudo rm -f /etc/ssh/*.key
sudo logrotate --force /etc/logrotate.conf
history -c && history -w

```

-   From ESX console Shut down VM.

-   Choose VM and click **Edit**, under CD/DVD Drive 1 make sure that no any iso is chosen it should be the point to "Host device". Click **Save**.

-   Download and install ovftool.exe tool from
    <https://my.vmware.com/web/vmware/downloads/details?productId=614&downloadGroup=OVFTOOL420>.

-   Export OVA (glasswallsolutions.com is a VM name)

```bash
"C:\Program Files (x86)\VMware\VMware Workstation\OVFTool\ovftool.exe" vi://esxi01.glasswall-icap.com/glasswallsolutions.com glasswallsolutions.com.ova
```
-   Upload exported ova to S3

