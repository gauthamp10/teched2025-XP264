# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/labels

data "kubernetes_resources" "gateways" {
  api_version    = "networking.istio.io/v1beta1"
  kind           = "Gateway"
  namespace      = "azure-dns"
}

output "all_gateways" {
  //value = length(data.kubernetes_resources.gateways.objects) != 0 ? data.kubernetes_resources.gateways.objects : null
  //value = { for gateway in data.kubernetes_resources.gateways.objects : gateway.name => gateway.spec }
  value = { for i, gateway in data.kubernetes_resources.gateways.objects : i => gateway.spec }
}

locals {
  dns_namespaces = ["azure-dns", "gcloud-dns", "aws-route53-dns"]
}

data "kubernetes_resources" "dnsproviders" {
  for_each       = toset(local.dns_namespaces)
  api_version    = "dns.gardener.cloud/v1alpha1"
  kind           = "DNSProvider"
  namespace      = each.value
}

  
output "all_dnsproviders" {

  value = [ for namespace, dnsprovider in data.kubernetes_resources.dnsproviders:  { for provider in dnsprovider.objects : format("[%s]--%s", namespace,provider.metadata.name) => provider.spec.domains } ]

}

data "kubernetes_resources" "dnsentries" {
  for_each       = toset(local.dns_namespaces)
  api_version    = "dns.gardener.cloud/v1alpha1"
  kind           = "DNSEntry"
  namespace      = each.value
}

  
output "all_dnsentries" {

  value = [ for namespace, dnsentry in data.kubernetes_resources.dnsentries:  { for entry in dnsentry.objects : format("[%s]--%s", namespace, entry.metadata.name) => entry.spec } ]

}

data "kubernetes_resources" "certificates" {
  api_version    = "cert.gardener.cloud/v1alpha1"
  kind           = "Certificate"
  namespace      = "istio-system"
}

output "all_certificates" {
  value = { for certificate in data.kubernetes_resources.certificates.objects : certificate.metadata.name => certificate.spec }
}
