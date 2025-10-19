/* discovery logic */

data "btp_globalaccount" "this" {}
data "btp_subaccounts" "all" {}

# look up all available subaccounts of a global acount that have a specific label attached
#
locals {
  label_value_string = "${var.BTP_SUBACCOUNT}-context"
  labels_filter      = "${var.BTP_SUBACCOUNT}-context=${local.label_value_string}"

}
data "btp_subaccounts" "filtered" {
  labels_filter = local.labels_filter
}

output "btp_subaccounts_filtered" {
  value = data.btp_subaccounts.filtered.values 
}

data "btp_subaccount" "context" {

  id = data.btp_subaccounts.filtered.values[0].id
}


data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.context.id
}

locals {
  faas-app-xp264-049-saas = [ for i, s in data.btp_subaccount_subscriptions.all.values: s if s.app_name == "faas-app-xp264-049-saas" ]
}
output "faas-app-xp264-049-saas" {
  value = local.faas-app-xp264-049-saas
}

locals {

  consumer_tenant_url = "https://emea.cockpit.btp.cloud.sap/cockpit?idp=${var.BTP_CUSTOM_IDP}#/globalaccount/${var.BTP_GLOBAL_ACCOUNT}/subaccount/${data.btp_subaccount.context.id}"
  
}

output "consumer_tenant_url" {
  value = local.consumer_tenant_url
}

/*
data "btp_subaccount_subscription" "faas_xp264_mt" {

  subaccount_id = data.btp_subaccount.context.id
  app_name      = local.faas-app-xp264-049-saas[0]["app_name"]
  plan_name     = local.faas-app-xp264-049-saas[0]["plan_name"]
}


output "faas_xp264_mt_subscription_url" {
  value = one(btp_subaccount_subscription.faas_xp264_mt[*].subscription_url)
}
*/
