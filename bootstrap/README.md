# Bootstrap

Erstellt einmalig lokal mit einem Admin-Account (benötigt Entra-ID-Berechtigung zum Erstellen von App Registrations):

```powershell
az login
terraform init
terraform apply
```

## Outputs in infra/ übertragen

Nach dem Apply die Credentials auslesen und in `infra/secrets.auto.tfvars` schreiben (gitignored):

```powershell
@"
entra_client_id     = "$(terraform output -raw entra_client_id)"
entra_client_secret = "$(terraform output -raw entra_client_secret)"
"@ | Out-File -FilePath ..\infra\secrets.auto.tfvars -Encoding utf8
```

Für die GitLab-Pipeline dieselben Werte als **Protected Variables** hinterlegen:
- `TF_VAR_entra_client_id`
- `TF_VAR_entra_client_secret`
