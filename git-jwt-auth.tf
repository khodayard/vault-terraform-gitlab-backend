resource "vault_jwt_auth_backend" "gitlab" {
#    description         = "GitLab"
    path                = "gitlab"
    jwks_url            = "https://GITLAB/-/jwks"
    bound_issuer        = "GITLAB"
}

resource "vault_jwt_auth_backend_role" "gitlab" {
  backend            = vault_jwt_auth_backend.gitlab.path
  role_name          = "gitlab"
  role_type          = "jwt"
  token_policies     = ["gitlab-cicd"]
  user_claim         = "user_login"
  bound_claims_type  = "glob"
  token_ttl          = "3600"
  token_max_ttl      = "3600"
  token_explicit_max_ttl = "3600"
  bound_claims       = {
       "project_path": "project-groupe-in-gitlab/*",
       "ref_protected": "true",
       "ref_type": "branch"
  }
}