#!/bin/bash

# Update package lists
apt-get update

# Install required packages
apt-get install -y mysql-client

# Fetch the public IP of the instance using IMDSv2
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)

# Install K3s with the public IP as the TLS SAN and kubeconfig file mode set to 644
curl -sfL https://get.k3s.io | sh -s - \
  --tls-san ${k3s_host} \
  --tls-san $PUBLIC_IP \
  --write-kubeconfig-mode=644

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
curl -s https://ipv4.cloudns.net/api/dynamicURL/?q=ODg3ODIxNjo1NzU4NTQ5NDY6YjllYWRlMDQ2MTFmYjFkOTY3MDg2OWE5YjdiNjhlYjkwZjI2ODU4YjZkYThlNjhiNmE5OGYzM2U3NzkzMTcwYg
