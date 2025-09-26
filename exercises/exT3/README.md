# Exercise T - Use Transparent Proxy Kyma Module

In this exercise, you will consume remote systems defined as destinations managed centrally in SAP BTP Destination service in a unified and virtually transparent way, powered by Transparent Proxy module, seamlessly integrated with other modules and services of SAP BTP Connectivity.

For simplicity and illustration purposeses, you'd be starting cURL Pod and use the well-known cURL tool to technially connect and perform requests to the target systems.

## Exercise T.1 Run a cURL Pod Included in the Istio Service Mesh

Using a single command, you will run a Kubernetes Pod hosting a preconfigured environment allowing direct usage of cURL. To be able to access remote systems securely exposed via Transparent Proxy, the Kuberenetes Pod must be included in the Istio Service Mesh.

1. Execute the following command in the terminal
```
kubectl run -n quovadis-btp --labels=sidecar.istio.io/inject=true -it --rm --image=curlimages/curl curly -- /bin/sh
All commands and output from this session will be recorded in container logs, including credentials and sensitive information passed through the command prompt.
If you don't see a command prompt, try pressing enter.
~ $ 

```

## Exercise T.2 Connect to remote systems defined as destinations using the dynamic "gateway" Destination CR

1. Execute the following command in the terminal

Request Command:
```
~ $ curl gateway/headers -H "X-Destination-Name: cis-httpbin"
```
2. Observe the Request Metadata and Headers:
```
* Host gateway:80 was resolved.
* IPv6: (none)
* IPv4: 10.108.54.200
*   Trying 10.108.54.200:80...
* Established connection to gateway (10.108.54.200 port 80) from 10.96.0.237 port 44764 
* using HTTP/1.x
> GET /headers HTTP/1.1
> Host: gateway
> User-Agent: curl/8.16.0
> Accept: */*
> X-Destination-Name: cis-httpbin
> 
* Request completely sent off
```
3. Observe the Response Headers
```
< HTTP/1.1 200 OK
< date: Fri, 26 Sep 2025 09:28:16 GMT
< content-type: application/json
< content-length: 3565
< server: envoy
< access-control-allow-origin: *
< access-control-allow-credentials: true
< x-envoy-upstream-service-time: 2096
```
4. Observe the Response Message
```
{
  "headers": {
    "Accept": "*/*", 
    "Authorization": "Bearer <token-value-intentionally-ommitted>", 
    "Host": "httpbin.org", 
    "Traceparent": "00-26d28049be3d58486d420c1b190608ec-183b81a653374960-00", 
    "Tracestate": "", 
    "User-Agent": "curl/8.16.0", 
    "X-Amzn-Trace-Id": "Root=1-68d65c7f-27975d18755a705a4693c61b", 
    "X-Envoy-Attempt-Count": "1"
  }
}
```

## Exercise T.3 Connect to a remote system defined as destination using the dedicated (static) "mys4" Destination CR

<b>TBD !!!</b>

## Summary

You've now consumed remote systems defined as destinations in Destination service in the context of the account in use by Transparent Proxy based on the applied configuration.

Continue to - [Exercise N - Excercise N ](../exN/README.md)
