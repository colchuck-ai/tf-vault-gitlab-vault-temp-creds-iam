/**
* # tf-vault-gitlab-vault-temp-creds-iam
* 
* The purpose of this module is to create vault resources that allow gitlab cicd pipelines to generate temporary credentials to a gitlab jwt auth backend role within a vault namespace with certain policies attached.
* 
* ## Usage
* 
* See [referencing a GitLab terraform module registry module](https://docs.gitlab.com/ee/user/packages/terraform_module_registry/#reference-a-terraform-module).
* 
* ```tf
* module "gitlab_vault_temp_creds_iam_infra_provisioner_read_write" {
*     source = "gitlab.example.com/engineering/tf-vault-gitlab-vault-temp-creds-iam"
*     version = "1.1.0"
* 
*     gitlab_jwt_auth_backend_path = "gitlab_v2"
*     bound_audiences              = ["https://vault.example.com"]
*     bound_claims_project_id      = var.gitlab_infra_project_id
*     bound_claims_ref_type        = "branch"
*     bound_claims_ref_protected   = var.gitlab_infra_project_ref_protected
*     bound_claims_environment     = var.gitlab_infra_project_environment
*     bound_claims_deployment_tier = var.gitlab_infra_project_deployment_tier
*     policies = [ "allow-provision-infra" ]
*   
*     attributes = [
*       "vault-infra-provisioner",
*       "read-write"
*     ]
*   
*     context = module.this.context
* }
* ```
*/

resource "vault_jwt_auth_backend_role" "main" {
  backend           = var.gitlab_jwt_auth_backend_path
  role_type         = "jwt"
  role_name         = module.this.id
  user_claim        = "user_email"
  bound_claims_type = "glob"
  bound_audiences   = var.bound_audiences
  bound_claims = {
    project_id      = var.bound_claims_project_id
    ref_type        = var.bound_claims_ref_type
    ref             = var.bound_claims_ref
    ref_protected   = var.bound_claims_ref_protected
    environment     = var.bound_claims_environment
    deployment_tier = var.bound_claims_deployment_tier
  }
  token_explicit_max_ttl = 300
  token_policies         = var.policies
}