#!/bin/bash

function show_help() {
  echo "Usage: $0 [OPTIONS] clusterName masterNodes workerNodes [TLS_SAN_1 TLS_SAN_2 ...]"
  echo ""
  echo "Arguments:"
  echo "  clusterName   (required) The name you want to give to the k3d cluster."
  echo "  masterNodes   (required) An integer specifying the number of master (server) nodes."
  echo "  workerNodes   (required) An integer specifying the number of worker (agent) nodes."
  echo "  [TLS_SAN_1 ...] (optional) Additional TLS Subject Alternative Names (SANs) for the API server certificate."
  echo ""
  echo "Options:"
  echo "  --help, -h    Show this help message and exit."
  echo ""
  exit 0
}

clusterName="$1"
masterNodes="$2"
workerNodes="$3"

# Check TLS SANS
if [[ "${@:4}" != "" ]]; then
  for tlsSanName in "${@:4}"; do
    tlsSansNameList+=("--k3s-arg --tls-san=$tlsSanName@server:0")
  done
fi

if [[ -z "$clusterName" ]]; then
  echo "$0: Error: ClusterName is required." >&2
  echo ""
  show_help
  exit 1
fi

if [[ -z "$masterNodes" ]]; then
  echo "$0: Error: You need set a number of Master Nodes." >&2
  echo ""
  show_help
  exit 1
fi

if [[ -z "$workerNodes" ]]; then
  echo "$0: Error: You need set a number of Worker Nodes." >&2
  echo ""
  show_help
  exit 1
fi

# Install k3d binary
echo ""
echo "[*] Installing k3d binary in your system..."
echo ""
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

if [[ ${tlsSansNameList[@]} != "" ]]; then
  # Create cluster with TLS SANS (Subject Alternative Names)
  echo ""
  echo "[*] Installing your cluster ${clusterName}..."
  echo ""
  k3d cluster create ${clusterName} --servers ${masterNodes} --agents ${workerNodes} ${tlsSansNameList[@]}
  if [[ $? == 0 ]]; then
    echo ""
    echo "Excelent! Your cluster has been installed successfully!"
    echo ""
  fi
else
  # Create cluster without TLS SANS (Subject Alternative Names)
  echo ""
  echo "[*] Installing your cluster ${clusterName}..."
  echo ""
  k3d cluster create ${clusterName} --servers ${masterNodes} --agents ${workerNodes}
  if [[ $? == 0 ]]; then
    echo ""
    echo "Excelent! Your cluster has been installed successfully!"
    echo ""
  fi
fi

# Show cluster list
echo ""
echo "[*] Showing your new cluster ${clusterName}..."
echo ""
echo "--CLUSTER-LIST---"
k3d cluster list
echo ""
echo "--NODE-LIST---"
k3d node list
echo ""

# Generating your .kube/config
echo ""
echo "# Please copy this content on your .kube/config to use kubectl #"
echo ""
k3d kubeconfig get ${clusterName}
