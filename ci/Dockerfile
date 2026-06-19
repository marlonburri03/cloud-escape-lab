FROM mcr.microsoft.com/azure-cli:latest

# Docker CLI
RUN tdnf install -y moby-cli && tdnf clean all

# Trivy
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
