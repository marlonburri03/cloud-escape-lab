# Glossary and references

## Glossary

| Term | Definition |
|---|---|
| Application Gateway (AGW) | Central layer-7 load balancer and reverse proxy in the hub through which all public traffic reaches the platform |
| Azure Container Apps (ACA) | Fully managed serverless container service running the frontend and backend |
| Azure Container Registry (ACR) | Private registry for container images, pulled by the apps via managed identity |
| Bootstrap stack | One-off IaC stack (`bootstrap/`) that creates the prerequisites for automated operation |
| CC BY-SA 4.0 | Creative Commons Attribution-ShareAlike licence of the tutorial room template |
| CI/CD pipeline | Automated GitLab workflow for lint, plan, build, scan and deploy |
| Container Apps environment | Isolated runtime for several container apps with internal load balancer and VNet integration |
| Definition of Ready / Done | Agreed criteria for when a story may be started and when it is complete |
| EasyAuth | Built-in authentication of Container Apps and App Service that redirects unauthenticated requests to the sign-in page |
| Federated identity credential | Trust between an Azure managed identity and an external subject (e.g. a GitLab environment) for passwordless OIDC sign-in |
| Health probe | Periodic request (e.g. `/healthz`) the gateway uses to check backend availability |
| Infrastructure as Code (IaC) | Describing infrastructure declaratively as versioned code |
| Managed identity | Azure-managed identity that lets a resource access other services without stored credentials |
| Microservice architecture | Application made of independently developed and operated services with defined interfaces |
| Microsoft Entra ID | Microsoft's identity and access management service |
| MVP / MLP / MMP | Minimum viable, lovable and marketable product: the three releases of the project |
| OIDC (OpenID Connect) | Authentication protocol; the pipeline uses short-lived OIDC tokens instead of secrets |
| OpenTofu | Open-source, Terraform-compatible IaC tool |
| Path-based routing | Routing by URL path, e.g. `/` vs. `/tutorial-room/*` |
| Platform stack / theme stack | Shared Azure foundation (`infra/`) vs. per-room resources |
| Private DNS zone | DNS zone linked to the spoke VNet that resolves the internal app host names |
| Proof of concept (PoC) | Demonstration that a concept is technically feasible, not yet a finished product |
| Remote state | IaC state stored centrally in Azure Blob Storage with locking |
| Scrum / sprint | Agile framework with fixed iterations (here two to three weeks) |
| SQLite | File-based database inside the container, used for game state |
| Trivy / Checkov / tflint / pip-audit | Image vulnerability scanner / IaC security scanner / Terraform linter / Python dependency audit |
| WAF | Web Application Firewall (WAFv2 with OWASP Core Rule Set) at the gateway |

## References

- Flask: https://flask.palletsprojects.com/ · APIFlask: https://apiflask.com/ · Flask-SQLAlchemy: https://flask-sqlalchemy.palletsprojects.com/
- Jinja2: https://jinja.palletsprojects.com/ · PyJWT: https://pyjwt.readthedocs.io/ · Introduction to JWT: https://jwt.io/introduction
- RESTful API design: https://restfulapi.net/ · SQLite: https://www.sqlite.org/
- OpenTofu: https://opentofu.org/ · azapi provider: https://registry.terraform.io/providers/Azure/azapi/latest/docs
- Authenticate to Azure using OIDC and Terraform: https://learn.microsoft.com/en-us/azure/developer/terraform/authenticate-to-azure
- Authentication in Azure Container Apps: https://learn.microsoft.com/en-us/azure/container-apps/authentication
- Azure Container Registry: https://learn.microsoft.com/en-us/azure/container-registry/
- Managed identities: https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/overview
- Azure RBAC best practices: https://learn.microsoft.com/en-us/azure/role-based-access-control/best-practices
- Application Gateway: https://learn.microsoft.com/en-us/azure/application-gateway/overview · WAF on Application Gateway: https://learn.microsoft.com/en-us/azure/web-application-firewall/ag/ag-overview
- GitLab OIDC for cloud services: https://docs.gitlab.com/ee/ci/cloud_services/
- Checkov: https://www.checkov.io/ · TFLint: https://github.com/terraform-linters/tflint · Trivy: https://aquasecurity.github.io/trivy/ · pip-audit: https://pypi.org/project/pip-audit/
- Tutorial room template `ma-room-template`: https://gitlab.com/solvista/ma-room-template (CC BY-SA 4.0)
- Design references: Fluent 2 colour (https://fluent2.microsoft.design/color), Tailwind colours (https://tailwindcss.com/docs/customizing-colors), MDN CSS custom properties, web.dev colour scheme
- Cover image generated with Microsoft Copilot (May 2026).
