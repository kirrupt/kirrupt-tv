#!/bin/bash
set -euxo pipefail

# start Docker
dockerd  --host=unix:///var/run/docker.sock --host=tcp://0.0.0.0:2375 --storage-driver=overlay2 &

# start K3s
k3s server -docker &

# wait for kube config file
while [ ! -f /etc/rancher/k3s/k3s.yaml ]
do
    sleep 1
done

# Kube config is written to /etc/rancher/k3s/k3s.yaml
k3s kubectl get node
