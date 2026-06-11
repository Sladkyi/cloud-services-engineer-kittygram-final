#!/bin/bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo bash install-github-runner.sh <runner-token>"
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "Usage: sudo bash install-github-runner.sh <runner-registration-token>"
  echo "Get token: GitHub repo -> Settings -> Actions -> Runners -> New self-hosted runner"
  exit 1
fi

RUNNER_TOKEN="$1"
RUNNER_USER="${SUDO_USER:-yc-user}"
RUNNER_HOME="/home/${RUNNER_USER}/actions-runner"
REPO_URL="https://github.com/Sladkyi/cloud-services-engineer-kittygram-final"

apt-get update -y
apt-get install -y curl jq libicu-dev

mkdir -p "${RUNNER_HOME}"
cd "${RUNNER_HOME}"

RUNNER_VERSION="$(curl -fsSL https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name | sed 's/^v//')"
curl -fsSL -o actions-runner-linux-x64.tar.gz \
  "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"
tar xzf actions-runner-linux-x64.tar.gz
rm -f actions-runner-linux-x64.tar.gz

chown -R "${RUNNER_USER}:${RUNNER_USER}" "${RUNNER_HOME}"

sudo -u "${RUNNER_USER}" ./config.sh \
  --url "${REPO_URL}" \
  --token "${RUNNER_TOKEN}" \
  --name "kittygram-vm" \
  --labels "self-hosted,linux" \
  --unattended \
  --replace

./svc.sh install "${RUNNER_USER}"
./svc.sh start

echo "GitHub Actions runner installed and started."
