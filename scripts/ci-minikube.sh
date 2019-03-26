#!/bin/bash
set -euxo pipefail

wget https://github.com/rancher/k3s/releases/download/v0.2.0/k3s
chmod +x k3s

sudo ./k3s server --docker &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
sudo ./k3s kubectl get node
