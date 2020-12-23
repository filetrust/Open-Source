### This MD contains details on how to create ICAP Server OVA from scratch.

## Starting the VM

1. Create the VM

Go to Datastores

Click on datastore1 then browse

Create a folder with the vm name you want to create

Go to the folder called Ubuntu-Server-Template and copy the files Ubuntu-Server-Template.vmx, Ubuntu-Server-Template-000001.vmdk to the folder you just created

Go back to the folder you created, right click on the vmx file you copied and click on register VM

You will see the vm registered on VM inventory, rename the VM to the vm name you want to you and start it.

When you will start the vm it will ask you to choose either "I copied it" or "I moved it", answer with "I copied it" and the vm will start


2. Assign a public IP

Get a free public address from the pool

Open the console of the VM you just created

Create a file called /etc/netplan/01-netcfg.yaml

Put the content bellow (replacing the first ip with the one you got from the pool)
Leave the additionnal ip (192.168.99.37) unchanged. That is the ip on which kubernetes cluster will run. Doing it allow us to move from one platform to another without issues.

```
network:
  version: 2
  renderer: networkd
  ethernets:
    ens160:
      dhcp4: no
      addresses:
        - 91.109.25.77/27
        - 192.168.99.37/24
      gateway4: 91.109.25.94
      nameservers:
          addresses: [8.8.8.8]
```

Run the command : netplan apply

Now you should be able to connect to your vm remotely

#### Install kubernetes and setup the ova content

Rancher is a container management platform built for organizations that deploy containers in production. Rancher makes it easy to run Kubernetes everywhere, meet IT requirements, and empower DevOps teams.

#### Create a VM by cloning an existing vm

* Install docker

To install docker on the new vm, just follow the instructions : https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04

### Installation steps to deploy K8s cluster on the VM

1. Deploy rancher server using docker

```
docker run -d --restart=unless-stopped \
  -p 8080:80 -p 8443:443 \
  --privileged \
  rancher/rancher:latest
```

Once the docker is running, it takes few minutes to initialize the server. Once the server is started, access the rancher UI on https://<host or IP>:8443


2. Create a K8s cluster.

Go to Clusters in rancher UI.

Click on Add cluster.

Select From Existing Nodes (Custom)

Give it a name, leave the default fields and click on Next. On that windows select etcd, control plane, worker and click on advanced settings, then on Node Internal IP address enter the ip : 192.168.99.37 (This is fundamental otherwise the server will not start on another platform)

Copy the docker command provided by rancher

Run it on your VM created

After few minutes your cluster will be up. You will see on rancher UI that the cluster is ready


3. Test the cluster deployment:

Select and open the cluster to be tested. On the right top, click on "Kubeconfig File" and copy the config file data.

Create a local file called `kubeconfig` and paste the copied data.

Use this file to connect to the cluster by running below commands. Please note, in the below command the `KUBECONFIG` variable should be set to the path of `kubeconfig` file created in the previous step. It is easy to connect to the cluster, if the file is merged with `~/.kube/config` or if the file is placed in `stable-src` directory which will be created in the next step so that the file can be used to deploy the helm chart.

  ```
  export KUBECONFIG=kubeconfig
  kubectl get nodes
  kubectl get all --all-namespaces
  ``` 

4. Deploy kubectl client on the vm so we can manage it from the vm itself

Follow this procedure for that - https://kubernetes.io/docs/tasks/tools/install-kubectl/

5. As glasswall user, copy the kubeconfig to the vm, to the file /home/glasswall/.kube/config
once that is copied, you should be able to run kubectl command from the vm. THis is usefull for debugging purposes when the over is deployed somewhere.

### Icap server
Follow the procedure here to setup the icap server : https://github.com/k8-proxy/icap-infrastructure/blob/k8-develop/README-Rancher.md#adaptation-cluster and make sure the pods and running

### Service configuration
Create a service which will be used to receive incoming traffic, the service should be of type external IP. Bellow is the manifest to use.
(make sure to update the external IP)

```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: adaptation
  name: icap-svc
  namespace: icap-adaptation
spec:
  externalIPs:
  - 91.109.25.77
  ports:
  - name: port-1
    nodePort: 30638
    port: 1344
    protocol: TCP
    targetPort: 1344
  - name: port-2
    nodePort: 32583
    port: 1345
    protocol: TCP
    targetPort: 1345
  selector:
    app: adaptation
  type: LoadBalancer
  ```

## Exporting OVA

* Shutdown the VM
* Run the command bellow from a workstation where ovftool is installed :
  ```
  ovftool vi://46.165.225.145/<vm_name> ./<vm_name>.ova