# vault-terraform-gitlab-backend

This is to:
  - manage Hashicorp Vault
  - with Terraform, 
  - with use of Gitlab HTTP Terraform Backend
  - but with local terraform commands

Man muss nur "variable.tf" in jede Ordner anpassen und durchfuhren.

Benötigte env_var:

Für Vault Provider:

    export VAULT_TOKEN=
    export VAULT_SKIP_VERIFY=true
    export VAULT_ADDR=
    export TF_HTTP_USERNAME=
    export TF_HTTP_PASSWORD=

Für HTTP GitLab Backend:

    export PROJECT_ID= kann von gitlab repo gelesen werden
    export STATE_PATH= willkürlich, aber SEHR WICHTIG: sicher stellen, dass STATE_PATH in Gitlab nicht überschrieben wird. Unter Repo -> Infrastructure -> Terraform sichtbar.
    export TF_HTTP_ADDRESS=https://GITLAB/api/v4/projects/$PROJECT_ID/terraform/state/$STATE_PATH
    export TF_HTTP_LOCK_ADDRESS=https://GITLAB/api/v4/projects/$PROJECT_ID/terraform/state/$STATE_PATH/lock
    export TF_HTTP_UNLOCK_ADDRESS=https://GITLAB/api/v4/projects/$PROJECT_ID/terraform/state/$STATE_PATH/lock

***Stageäbhängische Variable sind alle in `bash.env` definiert. Man muss nur dieses Befehl durchführen:***

    source bash.env

Clone Repo aus GitLAb

Kopieren von TF Files aus dem alten Stage ins neue Verzeichnis

Variable anpassen


Um terraform init fürs erste Mal durchzuführen gehen wir wie folgt vor:

    terraform init

Um terraform bei Änderungen durchzuführen gehen wir wie folgt vor:

    terraform init -reconfigure
Um eine bestehende StateDatei ins Gitlab zu migrieren:

    backend.tf und bzw. oder bash.env anpassen: SEHR WICHTIG: sicher stellen, dass STATE_PATH in Gitlab nicht überschrieben wird. Unter Repo -> Infrastructure -> Terraform sichtbar.
    terraform init -migrate-state


Alte State-Files löschen:

    rm -f terraform.tfstate*

Git stage, commit und push:

    git add .
    git commit -m "Inhalt"
    git push

Ref:

Terraform Doku: 
https://developer.hashicorp.com/terraform/language/settings/backends/http

Gitlab Doku: 
https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html
