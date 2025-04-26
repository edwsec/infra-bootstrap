# k3d Cluster Creator <0xF0><0x9F><0x9B><0x8E>️

[![Bash Shell Script](https://img.shields.io/badge/language-Bash-brightgreen.svg)](https://www.gnu.org/software/bash/)
[![k3d](https://img.shields.io/badge/tool-k3d-blue.svg)](https://k3d.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

🚀 Quickly spin up a k3d cluster with optional TLS SANs! This script simplifies the process of creating a local Kubernetes cluster using k3d.

## ✨ Features

* Easy k3d cluster creation.
* Specifies the number of master and worker nodes.
* Supports adding multiple TLS Subject Alternative Names (SANs) for the API server certificate.
* Automatic k3d binary installation (if not already present).
* Prints helpful output during the cluster creation process.
* Displays the created cluster and node list.
* Provides instructions to configure your `kubectl` using the generated kubeconfig.

## 🛠️ Usage

```bash
./k3d_install_with_tls_sans.sh [OPTIONS] clusterName masterNodes workerNodes [TLS_SAN_1 TLS_SAN_2 ...]
