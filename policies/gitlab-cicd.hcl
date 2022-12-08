path "vault/ns/ns/*" {
  capabilities = [ "read" ]
}

path "auth/*"
{
  capabilities = ["create", "update"]
}

