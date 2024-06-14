/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {try(
  org_id                              = try(data.terraform_remote_state.bootstrap.outputs.common_config.org_id,"")
  billing_account                     = try(data.terraform_remote_state.bootstrap.outputs.common_config.billing_account,"") 
  project_prefix                      = try(data.terraform_remote_state.bootstrap.outputs.common_config.project_prefix,"") 
  projects_backend_bucket             = try(data.terraform_remote_state.bootstrap.outputs.projects_gcs_bucket_tfstate,"")
  perimeter_name                      = try(data.terraform_remote_state.network_env.outputs.restricted_service_perimeter_name,"") 
  base_network_self_link              = try(data.terraform_remote_state.network_env.outputs.base_network_self_link,"")
  base_subnets_self_links             = try(data.terraform_remote_state.network_env.outputs.base_subnets_self_links,"") 
  # restricted_network_self_link        try(= data.terraform_remote_state.network_env.outputs.restricted_network_self_link != null ? data.terraform_remote_state.network_env.outputs.restricted_network_self_link : ""
  restricted_network_self_link        = try(data.terraform_remote_state.network_env.outputs.restricted_network_self_link,"") 
  base_host_project_id                = try(data.terraform_remote_state.network_env.outputs.base_host_project_id,"") 
  restricted_host_project_id          = try(data.terraform_remote_state.network_env.outputs.restricted_host_project_id,"") 
  restricted_subnets_self_links       = try(data.terraform_remote_state.network_env.outputs.restricted_subnets_self_links,"")
  access_context_manager_policy_id    = try(data.terraform_remote_state.network_env.outputs.access_context_manager_policy_id,"") 
  env_folder_name                     = try(data.terraform_remote_state.environments_env.outputs.env_folder,"") 
// Mro: disable for now
  app_infra_pipeline_service_accounts = try(data.terraform_remote_state.business_unit_shared.outputs.terraform_service_accounts, {})
  enable_cloudbuild_deploy            = try(data.terraform_remote_state.business_unit_shared.outputs.enable_cloudbuild_deploy, false) 
}

data "terraform_remote_state" "bootstrap" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/bootstrap/state"
  }
}

data "terraform_remote_state" "network_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/networks/${var.env}"
  }
}

data "terraform_remote_state" "environments_env" {
  backend = "gcs"

  config = {
    bucket = var.remote_state_bucket
    prefix = "terraform/environments/${var.env}"
  }
}

data "terraform_remote_state" "business_unit_shared" {
  backend = "gcs"

  config = {
    bucket = local.projects_backend_bucket
    prefix = "terraform/projects/${var.business_unit}/shared"
  }
}
