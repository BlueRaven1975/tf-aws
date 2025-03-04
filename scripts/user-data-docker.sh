#!/bin/bash

# Update package lists
apt-get update

# Install required packages
apt-get install -y docker.io docker-compose-v2 mysql-client

# Allow ubuntu user to run Docker commands
usermod -aG docker ubuntu

# Install Middleware.io host agent
MW_API_KEY=${middleware_api_key} MW_TARGET=https://bivcm.middleware.io:443 bash -c "$(curl -L https://install.middleware.io/scripts/deb-install.sh)"

# Install New Relic infrastructure agent
echo "license_key: ${new_relic_api_key}" | tee -a /etc/newrelic-infra.yml
curl -fsSL https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/newrelic-infra.gpg
echo "deb https://download.newrelic.com/infrastructure_agent/linux/apt/ noble main" | tee -a /etc/apt/sources.list.d/newrelic-infra.list
apt-get update
apt-get install newrelic-infra -y

# Forward logs to New Relic 
tee /etc/newrelic-infra/logging.d/logging.yml > /dev/null <<-EOT
logs:
  - name: auth.log
    file: /var/log/auth.log
    pattern: sshd|sudo
EOT

# Update my DDNS address
curl -fsSL https://ipv4.cloudns.net/api/dynamicURL/?q=${cloudns_api_key}

# Invoke GitHub Actions workflows to deploy applications
curl -fsSL -X POST \
     -H "Accept: application/vnd.github+json" \
     -H "Authorization: Bearer ${github_actions_token}" \
     -H "X-GitHub-Api-Version: 2022-11-28" \
     https://api.github.com/repos/BlueRaven1975/my-apps/dispatches \
     -d '{"event_type":"ec2-created"}'
