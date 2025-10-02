# Exercise 1 - Kyma CLI

In this exercise, we will create...

## Exercise 1.1 Sub Exercise 1 Description

After completing these steps you will have created...

1. Click here.
<br>![](/exercises/ex1/images/01_01_0010.png)

2.	Insert this line of code.
```abap
response->set_text( |Hello World! | ). 
```



## Exercise 1.2 Sub Exercise 2 Description

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

