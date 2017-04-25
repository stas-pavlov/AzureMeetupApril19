# Quick demo to deploy Kubernetes cluster, Deis Workflow and publich you first app on Azure

I have created this demo to showcase ASC+Kubernetes+Deis simple scenario at Moscow Azure Meetup, April 19
https://github.com/evangelism/AzureMeetupApril19 

Here I forked the repo to continue to develop demos (and remove PPT :) )

## Kubernetes with ACS and Deis simple deployment scripts 
**createk8s.sh** - bash script with parameters to create Kubertentes cluster at Azure Container Services  
**createdeis.sh** - bash script with parameters to create Deis Workflow on created Kuberntetes cluster (use the same prameters as **createk8s.sh**)

Change the following parameters to use for your test:


| Purpose        | Parameter           |Current value in scripts|
| :------------ |:--------------|:-------------|
| Azure Resource Group name   | AZURE_RG_NAME |stas-k8s-rg |
| Azure DC Location      | AZURE_DC_LOCATION |southcentralus | 
| Azure Container Service name |AZURE_SERVICE_NAME |stas-k8s-acs |
|Azure DNS Prefix for Azure Container Service|AZURE_DNS_PREFIX| stas-k8s |
|Azure Storage Account name for DEIS usage|AZURE_SA_NAME |stask8sdeisstorage |

### You need have installed the following utils to use this scripts

Before run the scripts you need to perform login to your Azure subscripion with Azure CLI using the following command:
```bash
az login
```

Don't forgert to mark the scripts as executable:
```bash
sudo chmod +x createk8s.sh
sudo chmod +x createdeis.sh
```

 Azure CLI 2.0  
**az** - https://docs.microsoft.com/en-us/cli/azure/install-azure-cli  

Kubernetes command-line tool  
**kubectl** - https://kubernetes.io/docs/tasks/kubectl/install/  

Helm is a tool for managing Kubernetes charts. Charts are packages of pre-configured Kubernetes resources  
**helm** - https://github.com/kubernetes/helm/blob/master/docs/install.md  

The Deis command-line interface (CLI)  
**deis** - http://docs.deis.io/en/latest/using_deis/install-client/  

### Test Deis installation

To test the deployment you need to find a right hostname to use with deis CLI.  
Execute the following command to find EXTERNAL IP of your Kubernetes cluster:  
```bash
kubectl --namespace=deis get service deis-router
```
You results will look like this one:
<pre>
 NAME          CLUSTER-IP    EXTERNAL-IP    PORT(S)                                                    AGE
 deis-router   10.0.113.22   1.1.1.1        80:31912/TCP,443:31642/TCP,2222:31239/TCP,9090:32507/TCP   5m
 </pre>
Use EXTERNAL-IP value to build the hostname to access Deis. It will be:  
<pre>
deis.EXTERNAL-IP.nip.io
</pre>
For example, for the output above it is:
<pre>
 deis.1.1.1.1.nip.io
</pre>
To deploy your first app you need to register on Deis using following command:
```bash
deis register http://deis.EXTERNAL-IP.nip.io 
```
Example output:  
<pre>
stas@ubuntuserver:~$ deis register http://deis.1.1.1.1.nip.io
username: admin
password:
password (confirm):
email: myemail@mycompany.com
Registered admin
Logged in as admin
Configuration file written to /home/stas/.deis/client.json
</pre>
As the first registered user you will receive adminstrative priveleges.  
Check that you set all right executing following command:
```bash
deis whoami
```
Example output: 
<pre>
 stas@ubuntuserver:~$ deis whoami
 You are admin at http://deis.1.1.1.1.nip.io
 </pre>
 And finally add your ssh pub key to Deis:
```bash
 deis keys:add ~/.ssh/id_rsa.pub
```
Great! So now your ready to deploy your first app to Deis.

To test Deis installation you can use the follwing guides:  
For Applications - https://deis.com/docs/workflow/quickstart/deploy-an-app/  
For Containers - https://deis.com/docs/workflow/applications/using-dockerfiles/

Or you can use prepared **testdeis.sh** script. 
Don't forgert to mark the scripts as executable:
```bash
sudo chmod +x testdeis.sh
```
After the script execution **my-first-deis-app** was created. You can check it by using the following command:
```bash
curl http://my-first-deis-app.deis.EXTERNAL-IP.nip.io  
```
where EXTERNAL-IP is the EXTERNAL-IP of deis-router you detected before.  
Example output:
<pre>
stas@ubuntuserver:~/example-go$ curl http://my-first-deis-app.deis.1.1.1.1.nip.io
Powered by Deis
Release v2 on my-first-deis-app-web-4229391613-ps87f
</pre>