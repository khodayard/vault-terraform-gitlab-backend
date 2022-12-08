resource "vault_policy" "vault-csi-policy" {
  depends_on  = [vault_namespace.sz]
  provider    = vault.provider-sz
  name        = "vault-csi"
  policy      = templatefile("${path.module}/policy/kubeauth-${var.project}.hcl", {
    stage = var.stage
  })
}

resource "vault_policy" "nsadmin" {
  depends_on  = [vault_namespace.sz]
  provider    = vault.provider-sz
  name        = "nsadmin"
  policy      = file("${path.module}/policy/nsadmin.hcl")
}
