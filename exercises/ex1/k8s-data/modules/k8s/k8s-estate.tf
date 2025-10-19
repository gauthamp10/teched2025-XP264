# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

data "kubernetes_config_map_v1" "sap-btp-operator-config" {

  metadata {
    name = "sap-btp-operator-config"
    namespace = "kyma-system"
  }
}

locals {
  cluster_id = jsondecode(jsonencode(data.kubernetes_config_map_v1.sap-btp-operator-config.data)).CLUSTER_ID
}

output "cluster_id" {
  value = local.cluster_id
}

output "sap-btp-operator-config" {
  value =  jsondecode(jsonencode(data.kubernetes_config_map_v1.sap-btp-operator-config.data))
}

# kube-system/shoot_info
#
data "kubernetes_config_map_v1" "shoot_info" {

  metadata {
    name = "shoot-info"
    namespace = "kube-system"
  }
}

locals {
  shoot_info_data = jsondecode(jsonencode(data.kubernetes_config_map_v1.shoot_info.data))
  shoot_info_data_egressCIDRs = try(local.shoot_info_data.egressCIDRs, "")
}

output "shoot_info" {
  value =  local.shoot_info_data
}


# kyna-system/kyma-provisioning-info
#
data "kubernetes_config_map_v1" "kyma_provisioning_info" {

  metadata {
    name = "kyma-provisioning-info"
    namespace = "kyma-system"
  }
}

locals {
  kyma_provisioning_info = yamldecode(data.kubernetes_config_map_v1.kyma_provisioning_info.data.details)
  BTP_KYMA_PLAN = "any"
}

output "kyma_provisioning_info" {
  description = "kyma_provisioning_info"
  value =  local.kyma_provisioning_info
}

output "kyma_btp_subaccount_deep_link" {
  description = "kyma_subaccount_deep_link"

  value = local.BTP_KYMA_PLAN == "trial" ? "https://cockpit.hanatrial.ondemand.com/trial/#/globalaccount/${local.kyma_provisioning_info.globalAccountID}/subaccount/${local.kyma_provisioning_info.subaccountID}/subaccountoverview" : "https://emea.cockpit.btp.cloud.sap/cockpit/#/globalaccount/${local.kyma_provisioning_info.globalAccountID}/subaccount/${local.kyma_provisioning_info.subaccountID}/subaccountoverview"
}

# k8s_nodes
data "kubernetes_nodes" "k8s_nodes" {

}

locals {
  k8s_nodes = { for node in data.kubernetes_nodes.k8s_nodes.nodes : node.metadata.0.name => node }
}

# https://registry.terraform.io/providers/massdriver-cloud/jq/latest/docs/data-sources/query
#
data "jq_query" "k8s_nodes" {
  depends_on = [
        data.kubernetes_nodes.k8s_nodes
  ] 
  data =  jsonencode(local.k8s_nodes)
  query = "[ .[].metadata[] | { NAME: .name, ZONE: .labels.\"topology.kubernetes.io/zone\", REGION: .labels.\"topology.kubernetes.io/region\" } ]"
}

# https://registry.terraform.io/providers/massdriver-cloud/jq/latest/docs/data-sources/query#multiple-results
#
output "k8s_zones" { 
// multi-line strings cannot be converted to HCL with jsondecode
/*
<<EOT
{"NAME":"shoot--kyma-stage--c-667f002-cpu-worker-0-z1-7598b-***","REGION":"eu-de-1","ZONE":"eu-de-1d"}
{"NAME":"shoot--kyma-stage--c-667f002-cpu-worker-0-z2-84f4f-***","REGION":"eu-de-1","ZONE":"eu-de-1b"}
{"NAME":"shoot--kyma-stage--c-667f002-cpu-worker-0-z3-84958-***","REGION":"eu-de-1","ZONE":"eu-de-1a"}
EOT
*/
  value = jsondecode(data.jq_query.k8s_nodes.result)
}

/*
k8s_zones = [
  {
    "NAME" = "ip-10-250-0-23.eu-central-1.compute.internal"
    "REGION" = "eu-central-1"
    "ZONE" = "eu-central-1a"
  },
  {
    "NAME" = "ip-10-250-1-32.eu-central-1.compute.internal"
    "REGION" = "eu-central-1"
    "ZONE" = "eu-central-1c"
  },
  {
    "NAME" = "ip-10-250-2-96.eu-central-1.compute.internal"
    "REGION" = "eu-central-1"
    "ZONE" = "eu-central-1b"
  },
]
*/
output "k8s_zones_json" {
  value = data.jq_query.k8s_nodes.result
}

# https://registry.terraform.io/providers/massdriver-cloud/jq/latest/docs/data-sources/query#hcl-compatibility
#
output "k8s_nodes" { 
  value = jsondecode(jsonencode(local.k8s_nodes))
}

output "k8s_nodes_json" {
  value = jsonencode(local.k8s_nodes)
}

output "k8s_nodes_raw" {
  value = local.k8s_nodes
}

# https://www.hashicorp.com/blog/wait-conditions-in-the-kubernetes-provider-for-hashicorp-terraform
#
data "kubernetes_resources" "OpenIDConnect" {
  api_version    = "authentication.gardener.cloud/v1alpha1"
  kind           = "OpenIDConnect"
}

output "OpenIDConnect" {
  value = { for OpenIDConnect in data.kubernetes_resources.OpenIDConnect.objects : OpenIDConnect.metadata.name => OpenIDConnect.spec }
}

# https://gist.github.com/ptesny/2a6fce8d06a027f9e3b86967aeddf984
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/resource#object
#
data "kubernetes_resource" "KymaModules" {
  api_version    = "operator.kyma-project.io/v1beta2"
  kind           = "Kyma"

  metadata {
    name      = "default"
    namespace = "kyma-system"
  }  
} 

locals {
#  value = { for KymaModules in data.kubernetes_resource.KymaModules.object : KymaModules.metadata.name => KymaModules.status.modules }
  KymaModules = data.kubernetes_resource.KymaModules.object.status.modules
}

data "jq_query" "KymaModules" {
  depends_on = [
        data.kubernetes_resource.KymaModules
  ] 
  data =  jsonencode(local.KymaModules)
  query = "[ .[] | { channel, name, version, state, api: .resource.apiVersion, fqdn } ]"
}


output "KymaModules" {
  value =  jsondecode(data.jq_query.KymaModules.result)
}

output "KymaModules_json" {
  value =  jsonencode(local.KymaModules)
}

output "KymaModules_raw" {
  value =  local.KymaModules
}

# https://github.com/hashicorp/terraform-provider-kubernetes/issues/1583
# https://medium.com/@danieljimgarcia/dont-use-the-terraform-kubernetes-manifest-resource-6c7ff4fe629a
# https://discuss.hashicorp.com/t/how-to-put-a-condition-on-a-for-each/55499/2
# https://stackoverflow.com/questions/77119996/how-to-make-terraform-ignore-a-resource-if-another-one-is-not-deployed
#

// kubectl -n istio-system get svc istio-ingressgateway
//
data "kubernetes_service_v1" "Ingress_LoadBalancer" {
  metadata {
    name = "istio-ingressgateway"
    namespace = "istio-system"
  }
}

// kubectl -n istio-system get svc istio-ingressgateway  --kubeconfig kubeconfig_prod_exec.yaml -o json | jq '.status'
//
output "Ingress_LoadBalancer" {

  value = data.kubernetes_service_v1.Ingress_LoadBalancer.status.0.load_balancer.0.ingress

}

#
data "kubernetes_secret_v1" "quovadis-btp" {

  metadata {
    name = "quovadis-btp-token-sa"
    namespace = "quovadis-btp"
  }
}

output "quovadis-btp" {
  value = nonsensitive(data.kubernetes_secret_v1.quovadis-btp.data)
}


data "kubernetes_secret_v1" "default-sa" {

  metadata {
    name = "default-token-sa"
    namespace = "default"
  }
}

locals {
  default_sa_token = try(data.kubernetes_secret_v1.default-sa.data.token, "")
}

output "default_sa_token-sa" {
  value = nonsensitive(local.default_sa_token)
}

output "default-sa" {
  value = nonsensitive(data.kubernetes_secret_v1.default-sa.data)
}