#
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.16.1"
    }
    jq = {
      source  = "massdriver-cloud/jq"
    }
    http-full = {
      source = "salrashid123/http-full"
      version = "1.3.1"
    }        
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }  
    kubectl = {
      source  = "alekc/kubectl"
    }
    qrcode = {
      source = "jackivanov/qrcode"
    }
  }
}