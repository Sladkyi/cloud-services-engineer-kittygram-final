#!/bin/bash
set -euo pipefail

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo bash setup-vm-stability.sh"
  exit 1
fi

if [ ! -f /swapfile ]; then
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  grep -q '/swapfile' /etc/fstab || echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<'EOF'
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
systemctl restart docker

cat > /usr/local/bin/kittygram-healthcheck.sh <<'EOF'
#!/bin/bash
set -euo pipefail
COMPOSE_FILE="/home/yc-user/kittygram/docker-compose.production.yml"
if [ ! -f "$COMPOSE_FILE" ]; then
  exit 0
fi
if ! curl -fsS --max-time 10 http://127.0.0.1:9000/ >/dev/null; then
  cd /home/yc-user/kittygram
  docker compose -f docker-compose.production.yml up -d --remove-orphans
fi
EOF
chmod 0755 /usr/local/bin/kittygram-healthcheck.sh

cat > /etc/cron.d/kittygram-maintenance <<'EOF'
0 3 * * 0 root docker system prune -af --filter "until=168h"
*/5 * * * * root /usr/local/bin/kittygram-healthcheck.sh
EOF

echo "VM stability setup complete."
