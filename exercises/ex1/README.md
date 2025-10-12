# Exercise 1 - Get your hands dirty with kyma CLI

Quoting after [Kyma CLI | SAP Help](https://help.sap.com/docs/btp/sap-business-technology-platform/kyma-cli):  

> Kyma CLI is an essential tool for application developers who want to get started quickly and efficiently with SAP BTP, Kyma runtime. Designed to streamline workflows, it simplifies complex tasks, enabling developers to deploy and manage applications easily.


```
kyma version
Kyma-CLI Version: 3.2.0
```

```
kyma -h     
Use this command to manage Kyma modules and resources on a cluster.

Usage:
  kyma [command]

Available Commands:
  alpha       Groups command prototypes for which the API may still change
  app         Manages applications on the Kubernetes cluster
  completion  Generate the autocompletion script for the specified shell
  function    A set of commands for managing Functions
  help        Help about any command
  module      Manages Kyma modules
  version     Displays the version of Kyma CLI

Flags:
  -h, --help                    Help for the command
      --kubeconfig string       Path to the Kyma kubeconfig file
      --show-extensions-error   Prints a possible error when fetching extensions fails
      --skip-extensions         Skip fetching extensions from the target Kyma environment

Use "kyma [command] --help" for more information about a command.
```

Please get familair with the available commands 

## Exercise 1.1 - Fire-fighter access to your kyma cluster

After completing these steps you will have created...

Option 1. 

  * Download the OIDC kubeconfig from the kyma dashboard. 
  This method requires a kubectl oidc plugin installed and connot be performed from a headless context


  * Create a permenent or temporary service account based kubeconfig 
```
kyma alpha kubeconfig generate --serviceaccount kyma-cli-sa --clusterrole cluster-admin --namespace default --permanent  --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml


kyma alpha kubeconfig generate --serviceaccount kyma-cli-sa --clusterrole cluster-admin --namespace default --time 1h  --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUQ1ekNDQWsrZ0F3SUJBZ0lSQUt3bWpnd1VwQTQ5Rkw2Mkp3Zm56Y2d3RFFZSktvWklodmNOQVFFTEJRQXcKRFRFTE1Ba0dBM2ovNzZqWjdXei9BQU9PT2pjUzZVUnRRY0tSellIckRlZlVGdVJXUEVxWkRXTmxBPT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    server: https://api.a896778.kyma.ondemand.com
  name: garden-kyma--a896778-external
contexts:
- context:
    cluster: garden-kyma--a896778-external
    namespace: default
    user: kyma-cli-sa
  name: garden-kyma--a896778-external
current-context: garden-kyma--a896778-external
kind: Config
preferences: {}
users:
- name: kyma-cli-sa
  user:
    token: eyJhbGciOiJSUzI1NiIsImtpZCI6IlRvQlNSVXRhekVNQWpLaE11SF9Ga0lrUUlCTG5ZQUV3dk9wc3Z5czJZR2MifQ.***
```


```
kyma alpha kubeconfig generate --serviceaccount kyma-cli-sa --clusterrole cluster-admin --namespace default --permanent  --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml > ~/.kube/kubeconfig--a896778.yaml


kyma alpha kubeconfig generate --serviceaccount xp264-000-sa  --namespace xp264-000 --permanent  --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml
```

  * read-only access in a given namespace

```
kyma alpha kubeconfig generate --serviceaccount kyma-cli-view-sa  --namespace default --permanent --clusterrole view --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml
```

  * cluster-wide read-only access

```
kyma alpha kubeconfig generate --serviceaccount kyma-cli-view-sa  --namespace default --permanent --clusterrole view --cluster-wide --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml


kyma alpha kubeconfig generate --serviceaccount xp264-000-sa  --namespace xp264-000 --permanent --clusterrole view --cluster-wide --kubeconfig ~/.kube/kubeconfig--garden-kyma--a896778-external.yaml
```  

1. Click here.
<br>![](/exercises/ex1/images/01_01_0010.png)

2.	Insert this line of code.
```abap
response->set_text( |Hello World! | ). 
```



## Exercise 1.2 Getting acquainted with your kyma cluster



```
kyma alpha diagnose -f json | jq '.metadata'
{
  "globalAccountID": "4c526f8b-cca9-4837-8b43-87824e3a4d10",
  "subaccountID": "5524c764-8893-4530-8eb8-feb9e6110f16",
  "clusterID": "eef5b822-8f8f-4d08-af05-f26aafe252b8",
  "clusterDomain": "a416537.stage.kyma.ondemand.com",
  "region": "uksouth",
  "shootName": "a416537",
  "provider": "azure",
  "kubernetesVersion": "1.33.3",
  "natGatewayIPs": [
    "172.167.242.76,",
    "172.187.130.162,",
    "172.187.211.228"
  ],
  "gardenerExtensions": [
    "shoot-auditlog-service",
    "shoot-cert-service",
    "shoot-dns-service",
    "shoot-lakom-service",
    "shoot-networking-filter",
    "shoot-networking-problemdetector",
    "shoot-oidc-service"
  ],
  "kubeAPIServer": "https://api.a416537.stage.kyma.ondemand.com"
}
```

```
kyma alpha diagnose -f json | jq '.nodes[] | tojson'

"{\"machineInfo\":{\"name\":\"shoot--kyma-stage--a416537-cpu-worker-0-z1-69d94-hd29q\",\"architecture\":\"amd64\",\"kernelVersion\":\"6.12.47-cloud-amd64\",\"osImage\":\"Garden Linux 1877.4\",\"containerRuntime\":\"containerd://2.1.4\",\"kubeletVersion\":\"v1.33.3\",\"operatingSystem\":\"linux\"},\"capacity\":{\"cpu\":\"4\",\"memory\":\"16384092Ki\",\"eph
```

After completing these steps you will have...

1.	Enter this code.
```
apiVersion: gateway.kyma-project.io/v2
kind: APIRule
metadata:

  name: httpbin-xp264-050
  namespace: xp264-050

spec:
  gateway: kyma-system/kyma-gateway
  hosts:
    - httpbin-xp264-050
  rules:
    - methods:
        - GET
        - POST
        - PUT
        - DELETE
        - PATCH
      noAuth: true
      path: /*
  service:
    name: httpbin-xp264-050
    namespace: xp264-050
    port: 80
  timeout: 300

```

duplicate it to

```
apiVersion: gateway.kyma-project.io/v2
kind: APIRule
metadata:

  name: httpbin-xp264-050-aws-route53-dns
  namespace: xp264-050

spec:
  gateway: aws-route53-dns/quovadis-aws-route53-dns-gateway
  hosts:
    - httpbin-xp264-050.btp-quovadis-d726db6d.quovadis.kyma.dev.sap
  rules:
    - methods:
        - GET
        - POST
        - PUT
        - DELETE
        - PATCH
      noAuth: true
      path: /*
  service:
    name: httpbin-xp264-050
    namespace: xp264-050
    port: 80
  timeout: 300


```

2.	Click here.
<br>![](/exercises/ex1/images/01_02_0010.png)


## Summary

You've now ...

Continue to - [Exercise 2 - Exercise 2 Description](../ex2/README.md)

