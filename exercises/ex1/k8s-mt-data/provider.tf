//
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
    }
    jq = {
      source  = "massdriver-cloud/jq"
    }
    http-full = {
      source = "salrashid123/http-full"
    }     
    qrcode = {
      source = "jackivanov/qrcode"
      //version = "1.0.0"
    }
  }
}

provider "jq" {}
provider "http-full" {}

# https://registry.terraform.io/providers/jackivanov/qrcode/latest/docs
#
provider "qrcode" {
  # Configuration options
}

provider "btp" {
  globalaccount  = var.BTP_GLOBAL_ACCOUNT
  cli_server_url = var.BTP_BACKEND_URL
  idp            = var.BTP_CUSTOM_IDP
}