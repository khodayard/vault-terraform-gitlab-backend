resource "vault_mount" "ca" {
 depends_on                = [vault_namespace.sz]
 path                      = "${path}-ca"
 type                      = "pki"
 provider                  = vault.provider-sz
 description               = "xxxxx"
 default_lease_ttl_seconds = local.default_10y_in_sec
 max_lease_ttl_seconds     = local.default_10y_in_sec
}

resource "vault_pki_secret_backend_intermediate_cert_request" "ca" {
 depends_on        = [vault_mount.ca]
 backend           = vault_mount.ca.path
 provider          = vault.provider-sz
 type              = "internal"
 common_name       = "${path}-ca"
 key_type          = "rsa"
 key_bits          = "4096"
 ou                = "Infrastruktur"
 organization      = "xxxxx"
 country           = "xx"
 locality          = "xx"
 province          = "xx"
 street_address    = "xxxxx"
 postal_code       = "xxxx"
}

resource "vault_pki_secret_backend_root_sign_intermediate" "ca_sign_by_project-ca" {
 depends_on           = [vault_pki_secret_backend_intermediate_cert_request.ca]
 backend              = "${var.project}-ca"
 provider             = vault.infra
 csr                  = vault_pki_secret_backend_intermediate_cert_request.ca.csr
 common_name          = "${path}-ca"
 use_csr_values       = true
 format               = "pem"
 max_path_length      = 0
}

resource "vault_pki_secret_backend_intermediate_set_signed" "ca_signed_cert" {
 depends_on   = [vault_pki_secret_backend_root_sign_intermediate.ca_sign_by_project-ca]
 backend      = vault_mount.ca.path
 provider     = vault.provider-sz
 certificate  = <<-EOT
        ${vault_pki_secret_backend_root_sign_intermediate.ca_sign_by_project-ca.certificate}
        ${join("\n", vault_pki_secret_backend_root_sign_intermediate.ca_sign_by_project-ca.ca_chain )} 
    EOT
}

resource "vault_pki_secret_backend_role" "vault-agent" {
 depends_on             = [vault_mount.ca]
 backend                = vault_mount.ca.path
 provider               = vault.provider-sz
 name                   = "vault-agent"
 key_type               = "rsa"
 allowed_uri_sans       = ["*"]
 key_bits               = 4096
 ttl                    = local.default_1y_in_sec
 max_ttl                = local.default_3y_in_sec
 allow_any_name         = true
 enforce_hostnames      = false
 allow_ip_sans          = true
 require_cn             = true
 use_csr_common_name    = true
 use_csr_sans           = true
 ou                     = ["xx"]
 organization           = ["xxxxx"]
 key_usage              = ["DigitalSignature,KeyAgreement,KeyEncipherment"]
 country                = ["xxx"]
 locality               = ["xxxx"]
 province               = ["xxx"]
 street_address         = ["xxxxx"]
 postal_code            = ["xxxxx"]
 allow_localhost        = true
 allow_bare_domains     = true
 allow_subdomains       = true
 allow_glob_domains     = true
 server_flag            = true
 client_flag            = true
 code_signing_flag      = false
 email_protection_flag  = false
 no_store               = true
}
