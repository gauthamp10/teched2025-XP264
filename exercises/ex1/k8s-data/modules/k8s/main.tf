
data "btp_globalaccount" "this" {}
data "btp_subaccounts" "all" {}

/*
# look up all available subaccounts of a global acount that have a specific label attached
#
locals {
  label_value_string = "${var.runtime_context_workspace}" //"${terraform.workspace}"
  labels_filter = "${var.BTP_SUBACCOUNT}-workspace=${local.label_value_string}"

}
data "btp_subaccounts" "filtered" {
  labels_filter = local.labels_filter
}

output "btp_subaccounts_filtered" {
  value = data.btp_subaccounts.filtered.values 
}
*/

data "btp_subaccount" "context" {
  depends_on = [ data.kubernetes_config_map_v1.kyma_provisioning_info ]

  id = local.kyma_provisioning_info.subaccountID // data.btp_subaccounts.filtered.values[0].id
}


data "btp_subaccount_environment_instances" "all" {
  subaccount_id = data.btp_subaccount.context.id
}


output "btp_subaccount_environment_instances_all" {
  value = [ for env in data.btp_subaccount_environment_instances.all.values: env if env.environment_type == "kyma" ]
}

# https://stackoverflow.com/a/74460150
locals {
  kyma = [ for env in data.btp_subaccount_environment_instances.all.values: env if env.environment_type == "kyma" ]
  dashboard_url = one(local.kyma[*].dashboard_url)
  labels = one(local.kyma[*].labels)
  parameters = one(local.kyma[*].parameters)
  parameters_length = try(length(base64encode(local.parameters)), 0)
}


output "kyma_dashboard_url" {
  value = nonsensitive(local.dashboard_url)
}

data "qrcode_generate" "kyma_dashboard_url_qrcode" {
  text = local.dashboard_url
  error_correction = "H"
  disable_border = true
}
output "kyma_dashboard_url_ascii_qrcode" {
  value = data.qrcode_generate.kyma_dashboard_url_qrcode.ascii
}

resource "qrcode_generate" "kyma_dashboard_url_qrcode" {
  file = "${path.module}/kyma_dashboard_url_qrcode.png"
  sensitive_text = local.dashboard_url

}

data "local_sensitive_file" "kyma_dashboard_url_qrcode" {
  depends_on = [ qrcode_generate.kyma_dashboard_url_qrcode ]
  filename = "${path.module}/kyma_dashboard_url_qrcode.png"
}

output "kyma_dashboard_url_qrcode" {
  description = "kyma_dashboard_url_qrcode in png format"
  value = nonsensitive(data.local_sensitive_file.kyma_dashboard_url_qrcode.content_base64)
}


output "kyma_labels" {
  value = nonsensitive(jsondecode(local.labels))
}


data "qrcode_generate" "kyma_labels_qrcode" {
  sensitive_text = base64encode(local.labels)
  error_correction = "H"
  disable_border = true
}
output "kyma_labels_ascii_qrcode" {
  description = "kyma_labels_ascii_qrcode"
  value = data.qrcode_generate.kyma_labels_qrcode.ascii
}

resource "qrcode_generate" "kyma_labels_qrcode" {
  file = "${path.module}/kyma_labels_qrcode.png"
  sensitive_text = base64encode(local.labels)

}

data "local_sensitive_file" "kyma_labels_qrcode" {
  depends_on = [ qrcode_generate.kyma_labels_qrcode ]
  filename = "${path.module}/kyma_labels_qrcode.png"
}

output "kyma_labels_qrcode" {
  description = "kyma_labels_qrcode in png format"
  value = nonsensitive(data.local_sensitive_file.kyma_labels_qrcode.content_base64)
}


output "kyma_parameters" {
  value = nonsensitive(jsondecode(local.parameters))
}

output "kyma_parameters_length" {
  value = nonsensitive(local.parameters_length)
}

# https://en.wikipedia.org/wiki/QR_code#Information_capacity
#
data "qrcode_generate" "kyma_parameters_ascii_qrcode" {
  sensitive_text = local.parameters_length < 2953 ? base64encode(local.parameters) : format("kyma parameters size of %d bytes too big for QRCoding", local.parameters_length)
  error_correction = "L"
  disable_border = true
}
output "kyma_parameters_ascii_qrcode" {
  description = "kyma_parameters_ascii_qrcode"
  value = data.qrcode_generate.kyma_parameters_ascii_qrcode.ascii
}



data "http" "kubeconfig" {
  
  url = local.labels != null ? jsondecode(local.labels)["KubeconfigURL"] : "https://sap.com"

  lifecycle {
    postcondition {
      condition     = can(regex("kind: Config",self.response_body))
      error_message = "Invalid content of downloaded kubeconfig"
    }
    postcondition {
      condition     = contains([200], self.status_code)
      error_message = self.response_body
    }
  } 

}

# yaml formatted default (oid-based) kyma kubeconfig
locals {
  kyma_kubeconfig = data.http.kubeconfig.response_body
}


data "jq_query" "kubeconfig_sa" {
   data = jsonencode(yamldecode(local.kyma_kubeconfig))
   query = "del(.users[] | .user | .exec) | .users[] |= . + { user: { token: \"${local.default_sa_token}\" } }"
}

locals {
  kubeconfig-sa-json = jsondecode(data.jq_query.kubeconfig_sa.result)
  kubeconfig-sa      = yamlencode(local.kubeconfig-sa-json)
}

output "kubeconfig-sa-json" {
  description = "kubeconfig-sa in json format"
  value       = local.kubeconfig-sa-json
}

output "kubeconfig-sa" {
  description = "kubeconfig-sa in yaml format"
  value       = local.kubeconfig-sa
}
