# Creating and activating S3 File Gateway on VMware


## Creating the File gateway VM

Prerequisite 

- Your AWS account should have permission :
   - Download/upload file from S3
   
   - Access to Storage Gateway
   
   - Have built-in role or have permission to create role
 
Following instruction [here](https://aws.amazon.com/blogs/storage/creating-and-activating-aws-file-gateway-on-vmware/) to deploy and active File Gateway

## Usage on Ubuntu

- Install nfs (network file system)
```
sudo apt install nfs-common
```
- Create a local file share folder
```
mkdir ~/<your S3 file share folder>
```
- Mount S3 bucket to local file share folder
```
sudo mount -t nfs -o nolock,hard <your-file-gateway-ip-address>:/<your-bucket-name> <your-local-file-share-folder>

#Example : 
#I deploy file-gateway VM and set IP address is 91.109.25.89
#my S3 bucket name is S3-OVA 
#my local folder /home/glasswall/file-share
# sudo mount -t nfs -o nolock,hard 91.109.25.89:/S3-OVA /home/glasswall/file-share
```