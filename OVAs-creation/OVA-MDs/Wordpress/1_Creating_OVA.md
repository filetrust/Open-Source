### This MD contains details on how to create Wordpress OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Linux, Ubuntu (64-bit) VM with the follwing hardware specs:
    * 1 CPU,
    * 1 GB RAM
    * 16 GB of Harddisk (set disk Provisioning to be thin provisioned) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Also CD/DVD drive is connected at power on and choose the ISO to boot from

  ![image](https://user-images.githubusercontent.com/58347752/100460151-66715900-30cf-11eb-914e-2f802acb5052.png)

* Finish installation and boot the machine with default configuration

* In the network configuration, edit the IPV4 method to be manual and add the network configuration 

  ![Networkconnection](https://user-images.githubusercontent.com/70108899/100768735-82d90280-33fb-11eb-8e1d-f60164fad167.PNG)

* Set the username to be glasswall and the agreed password (same password as the controller VM)

Once installation is done restart the VM and press enter when it asks to remove the CD

## Installation

- To install WordPress, use following command:

```bash
sudo apt update
sudo apt install -y wordpress php libapache2-mod-php mysql-server php-mysql
```
- Start Apache server
```
sudo service apache2 start
sudo service apache2 status
```
- Create Apache site for WordPress. Create `/etc/apache2/sites-available/wordpress.conf` with following lines:

```bash
cat >> /etc/apache2/sites-available/wordpress.conf << EOF
Alias /blog /usr/share/wordpress
<Directory /usr/share/wordpress>
    Options FollowSymLinks
    AllowOverride Limit Options FileInfo
    DirectoryIndex index.php
    Order allow,deny
    Allow from all
</Directory>
<Directory /usr/share/wordpress/wp-content>
    Options FollowSymLinks
    Order allow,deny
    Allow from all
</Directory>

EOF
```
- Enable this site, URL rewriting and reload apache2 :
```bash
sudo a2ensite wordpress
sudo a2enmod rewrite
sudo service apache2 reload
```
- Create MySQL database to config wordpress:
```
$ sudo mysql -u root
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.7.20-0ubuntu0.16.04.1 (Ubuntu)

Copyright (c) 2000, 2017, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE wordpress;
Query OK, 1 row affected (0,00 sec)

mysql> mysql> CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '<your-password>'; 
Query OK, 1 row affected (0,00 sec)

mysql> GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP,ALTER
    -> ON wordpress.*
    -> TO wordpress@localhost;
Query OK, 1 row affected (0,00 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 1 row affected (0,00 sec)

mysql> quit
Bye
```
- Configure WordPress to use this database -> Open /etc/wordpress/config-localhost.php and write:
```
cat >> /etc/wordpress/config-localhost.php << EOF
<?php
define('DB_NAME', 'wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', '<your-password>');
define('DB_HOST', 'localhost');
define('DB_COLLATE', 'utf8_general_ci');
define('WP_CONTENT_DIR', '/usr/share/wordpress/wp-content');
?>
EOF
```
- Enable MySQL with `sudo service mysql start`

- Link your local config as default config
```
sudo ln -s /etc/wordpress/config-localhost.php /etc/wordpress/config-default.php
```
- Get VM IP address
```
$ ifconfig
```

## Client configuration

- Open `<your VM IP>/blog` in your browser. You will be asked for title of your new site, username, password and address e-mail. Fill in all details as you like. Remember your username/password and install Wordpress.

![image](https://user-images.githubusercontent.com/29745336/100712334-308ce700-33e5-11eb-8117-08aaf43e338c.png)

 You can now login under `<your VM IP>/blog/wp-login.php`, or by clicking `Log In` button after installation. In Dashboard, you will see bunch of icons and options. Don’t worry, it’s easy!
 
 ![image](https://user-images.githubusercontent.com/29745336/100712645-a729e480-33e5-11eb-9866-dee90d2e627d.png)
 
 ## Change IP address link to hostname
 
 - Back to VM console and update the configuration
 ```
 cd /etc/apache2/sites-available/
 ls
 # you will see list configuration like this :
 000-default.conf  backup_wordpress.conf  default-ssl.conf  wordpress.conf
 ```
 - Edit file `000-default.conf` by command `sudo nano 000-default.conf`. Uncomment and change 3 lines below :
 ```
        ServerName www.example.local
        ServerAdmin webmaster@localhost
        DocumentRoot /usr/share/wordpress
 ```

- Open `<your VM IP>/blog/wp-admin` in your browser, go to `Settings -> General`
![image](https://user-images.githubusercontent.com/29745336/100713901-9a0df500-33e7-11eb-9409-24f3ea2a2e4c.png)

- Change `WordPress Address (URL)` to `http://example.local` and `Site Address (URL)` to `http://example.local` , save the change

 - Reload apache server 
 ```
 sudo service apache2 reload
 ```

- Add hosts records to your client system hosts file ( i.e **Windows**: C:\Windows\System32\drivers\etc\hosts , **Linux, macOS and  Unix-like:** /etc/hosts ) as follows

```
<VM IP ADDRESS> example.local www.example.local
```
- Open `http://example.local` again and make sure we are in wordpress welcome site


## Exporting OVA

* Shut down the machine 
* Open the controller machine (Or from your local machine, just the controller machine speed the things up)
* Run the following command to export the VM with OVA extension (change to corresponding ESXI IP/URL and VM name), it will be exported in your current working directory.

Note: the username and password to be provided here are the initial ESXI server credentials  

```bash
ovftool vi://46.165.225.145/glasswall-wordpress ./glasswall-wordpress.ova
```