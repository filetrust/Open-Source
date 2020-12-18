## Minio Server Offline OVA Usage

- Login into the VM that has Minio Server Offline OVA imported: (`glasswall/Gl@$$wall`)
- Check the VM ip address by running `ip a`
- In your local hosts file (win: C:\Windows\System32\drivers\etc, on MAC/Linux: /etc/hosts), add:
    ```
    <VM IP_ADDRESS> minio.server
    ```
    **Example:** `192.168.66.128 minio.server`
- From your local, open any browser and access [minio.server](http://minio.server)
- Login to Minio Server (username: **user**, password: **secret_password**)

---
---