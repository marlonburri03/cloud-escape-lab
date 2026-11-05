# Bootstrap

One-off stack that creates the prerequisites for automated delivery: the remote state backend, the managed identity used by the pipeline via OIDC, and the Entra ID app registration for EasyAuth. Run it locally with an account that may create app registrations.

Set your values in `terraform.tfvars` (tenant, subscription, your object ID, GitLab project path), then:

```powershell
az login
tofu init     # or: terraform init
tofu apply
```

## Hand the outputs to `infra/`

Write the credentials to `infra/secrets.auto.tfvars` (git-ignored):

```powershell
@"
entra_client_id     = "$(tofu output -raw entra_client_id)"
entra_client_secret = "$(tofu output -raw entra_client_secret)"
"@ | Out-File -FilePath ..\infra\secrets.auto.tfvars -Encoding utf8
```

Store the same values as protected CI/CD variables for the pipeline:

- `TF_VAR_entra_client_id`
- `TF_VAR_entra_client_secret`
