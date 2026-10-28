variable "gitlab_jwt_auth_backend_path" {
  type        = string
  description = "path for the jwt auth backend configured for gitlab authentication"
}

variable "bound_audiences" {
  type        = list(string)
  description = "Bound audiences for the role"
  default     = null
}

variable "bound_claims_project_id" {
  type        = string
  description = "GitLab project id for the bound claims"
}

variable "bound_claims_ref_type" {
  type        = string
  description = "Git ref type. Options are: branch, tag"
  validation {
    condition     = can(regex("^(branch|tag)$", var.bound_claims_ref_type))
    error_message = "Invalid ref type. Valid options are: branch, tag, *"
  }
}

variable "bound_claims_ref" {
  type        = string
  description = "Git reference. Usually a branch name or tag name"
  default     = "*"
}

variable "bound_claims_ref_protected" {
  type        = bool
  nullable    = true
  default     = null
  description = "true if the Git ref is protected, false otherwise, null for don't care."
}

variable "bound_claims_environment" {
  type        = string
  description = "If the job deploys to an environment, you can set a bound claim on the environment name. If the job doesn't deploy to an environment, you can't create a bound claim on the environment, and should provide `null`. Examples of valid non-null bound claims on environments include: `prod/aws/us-east-1`, `test/vault/global`, `test/*`, `prod/*`, `*`"
  default     = null
  validation {
    condition     = var.bound_claims_environment == null || can(regex("^((test|prod)([a-zA-Z0-9\\/-]+))*\\*?$", var.bound_claims_environment))
    error_message = "Invalid environment. Must be null or match regex: ^((test|prod)([a-zA-Z0-9\\/-]+))*\\*?$"
  }
}

variable "bound_claims_deployment_tier" {
  type        = string
  description = "If the job deploys to an environment, and the environment is associated with a deployment tier, you can set a bound claim on the deployment tier name. If the job doesn't deploy to an environmne that is associated with a deployment tier, you can't create a bound claim on the deployment tier, and should provide `null`. Options include: `testing`, `production`, `*`"
  default     = null
  validation {
    condition     = var.bound_claims_deployment_tier == null || can(regex("^(testing|production|\\*)$", var.bound_claims_deployment_tier))
    error_message = "Invalid deployment tier. Valid options are: null, testing, production, *"
  }
}

variable "policies" {
  type        = list(string)
  description = "a list of policy names to attach to the role"
  default     = []
}