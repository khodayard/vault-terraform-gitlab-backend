resource "vault_auth_backend" "userpass" {
  depends_on  = [vault_namespace.sz]
  type        = "userpass"
  path        = "users"
  provider    = vault.project-sz
}

data "vault_generic_secret" "stage-pw" {
  path        = "secret-path/${var.secret}"
  provider    = vault.infra
}

resource "vault_generic_endpoint" "admin" {
  provider             = vault.project-sz
  depends_on           = [vault_auth_backend.userpass]
  for_each             = { u1 = "user1", u2 = "user1", u3 = "user1" }
  path                 = "auth/users/users/something-${each.value}"
  ignore_absent_fields = true
  data_json            = <<EOT
{
  "token_policies": ["nsadmin", "default"],
  "password": "${data.vault_generic_secret.stage-pw.data["something_${each.value}"]}"
}
EOT
}