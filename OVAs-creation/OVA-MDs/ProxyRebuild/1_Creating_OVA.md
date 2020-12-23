### This MD contains details on how to create Proxy Rebuild OVA from scratch.

## Starting the VM

* Access ESXi server with valid credentials 

* Create a new Ubuntu linux (64-bit) VM with:
  * 1 CPU
  * 1 GB RAM 
  * 16 GB of Harddisk (set disk Provisioning to be thin provisioned) 

  ![image](https://user-images.githubusercontent.com/58347752/100459771-b0a60a80-30ce-11eb-959e-018d88a8cf2b.png)

* Also CD/DVD drive is connected at power on and choose ***UBUNTU DESKTOP ISO*** to boot from

  ![image](https://user-images.githubusercontent.com/58347752/101005217-74a8f480-3569-11eb-8e7d-2fa83835c179.png)

* Finish installation and reboot the VM.

* Once you "Power ON" your Machine start with setup. Pay attention to the steps below. 

* In the network configuration, under ens160, edit the IPV4 method to be manual and add the network configuration. Example on image below. This IP addresses are ESXi related and can be obtained from corresponding channel.

  ![Networkconnection](https://user-images.githubusercontent.com/70108899/100768735-82d90280-33fb-11eb-8e1d-f60164fad167.PNG)

* Set the username to be glasswall and the agreed password (same password as the controller VM)

Once installation is done restart the VM and press enter when it asks to remove the CD

## Installation

- In order to start the installation ssh to VM via putty (working directly from ESXi console will not give ability for copy/paste or similar acrions)

- Install docker by:
    ```
    sudo apt update

    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    
    sudo apt update
    
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    ```
- Install rancher by:
    ```
    docker run -d --restart=unless-stopped -p 8080:80 -p 8443:443 --privileged rancher/rancher:latest
  ```

- To access rancher, in your loaclhost machine's browser, you can navigate to the VM's IP (type `ip a` in case you are not sure what it is) or in this case, `https://<VM IP>:8443`, and setup the credentials with (username: , password: ).

- If you in any instance encount with "Network connection issues" try reloading.

- Give the rancher url as `https://172.17.0.1:8443` so that the IP of the rancher server remains the same when VMs are created using the OVA and doesn't depend on the public IP of the vm. If you experience some issues with reloading after the change, just type agian initial URL, `https://<VM IP>:8443` and continue with the setup.

- Create a new cluster in the rancher by going to "Add cluster" and selecting the option of "Existing Nodes". 

- Give some name to the cluster and on the bottom of the page click "NEXT".

- In the next page, select etcd, controlplane and worker. Click on "Show advanced options" in right corner to give the public IP of the node as 172.17.0.1 and run the command given by rancher on the VM. And on Rancher UI click "DONE"

    Command example: 

    `sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.5.3 --server https://172.17.0.1:8443 --token x87g9k76cmh5r5htlzp6cvwckhkt9hb7dl8gs6r7d5fcpjgfqz7sqm --ca-checksum 192fb5f7702a308654d8060bafd47cf89d44490e54086d52ce4db8bb75db7039 --address 172.17.0.1 --etcd --controlplane --worker`


- It takes 10-15 minutes until all containers are up and the cluster is healthy. In case you get "refused to connect" site will reload itself.

![image](https://user-images.githubusercontent.com/70108899/100937725-bbf49e00-34f3-11eb-92b0-9a25ef3e7a99.png)

- Once the cluster is healthy and active, select the cluster and click on Kubeconfig File. Copy the content of Kubeconfig and paste in `~/.kube/config` file of the VM. 

- Install kubectl and helm by running:
    ```
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

    chmod +x ./kubectl

    sudo mv ./kubectl /usr/local/bin/kubectl

    curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -

    sudo apt-get install apt-transport-https --yes

    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

    sudo apt-get update

    sudo apt-get install helm -y
    ```

- Test the connectivity to the kubernets cluster by running `kubectl get nodes`

- Clone the proxy-rebuild repository (https://github.com/k8-proxy/s-k8-proxy-rebuild.git)

- Clone the vmware-scripts repository (https://github.com/k8-proxy/vmware-scripts.git) and navigate to vmware-scripts/proxy-rebuild folder.

- Run `02-setup-proxy.sh` script to deploy the proxy rebuild helm chart by passing the IP address of ICAP server as argument. When prompted pass the IP addresses of offline gov.uk and wordpress websites, and hit Enter to use defaults.
  ```
  ./02-setup-proxy.sh <ICAP server IP> (example: ./02-setup-proxy.sh 78.159.113.47)
  ```

## Exporting OVA
- shut down the machine
- Open the controller machine (Or from your local machine, just the controller machine speed the things up) and run 
    ```
    ovftool vi://46.165.225.145/proxy-rebuild ./proxy-rebuild.ova
    ```
- Or click **Export** button under the **actions** of the VM to export and download the OVF and vmdk
