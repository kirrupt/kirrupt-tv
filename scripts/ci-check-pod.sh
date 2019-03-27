#!/bin/bash
set -euxo pipefail

k3s kubectl get pods | grep $1 | grep Running
