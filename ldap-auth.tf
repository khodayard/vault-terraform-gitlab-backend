data "vault_generic_secret" "bind_user" {
  path        = "secret-path/secret-name"
  provider    = vault.other-vault
}

resource "vault_ldap_auth_backend" "ldap" {
    provider    = vault
    path        = "ldap"
    url         = "ldap://LDAP"
    token_ttl   = 86400
    token_max_ttl = 86400
    userdn      = "OU=Accounts,DC=xx,DC=xxxxx,DC=xx"
    upndomain   = "ad.nublar.de"
    groupdn     = "OU=xxxxxx,OU=Groups,DC=xx,DC=xxxxxx,DC=xx"
    groupfilter = "(&(objectClass=group)(member:1.2.840.113556.1.4.1941:={{.UserDN}}))"
    binddn      = "CN=xxxxxx,OU=xxxxx,OU=Accounts,DC=xx,DC=xxxxx,DC=xx"
    bindpass    = "${data.vault_generic_secret.bind_user.data["password"]}"
}

resource "vault_ldap_auth_backend_user" "user" {
    provider    = vault
    for_each = toset( ["usr1","usr2"] )
    username = "${each.key}"
    policies = ["admin", "default"]
    backend  = vault_ldap_auth_backend.ldap.path
}
