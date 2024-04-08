terraform {
  required_providers {
    tanzu-mission-control = {
      source = "vmware/tanzu-mission-control"
      version = "1.4.4"
    }
  }
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

variable "endpoint" {
  description = "endpoint"
  type        = string
}

variable "vmw_cloud_api_token" {
  description = "vmw_cloud_api_token"
  type        = string
}

provider "tanzu-mission-control" {
  endpoint            = var.endpoint            # optionally use TMC_ENDPOINT env var
  vmw_cloud_api_token = var.vmw_cloud_api_token # optionally use VMW_CLOUD_API_TOKEN env var
}

module "custom-policies-templates" {
  source = "./custom_policy_template"

}

module "custom-policies" {
  source = "./custom_policy"
  
}