#!/usr/bin/bash
export ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
export NODE_IPS=(192.168.122.37 192.168.122.185 192.168.122.7)
export NODE_NAMES=(k8s01 k8s02 k8s03)
export ETCD_ENDPOINTS="https://192.168.122.37:2379,https://192.168.122.185:2379,https://192.168.122.7:2379"
export ETCD_NODES="k8s01=https://192.168.122.185:2380,k8s02=https://192.168.122.185:2380,k8s03=https://192.168.122.7:2380"
export KUBE_APISERVER="https://127.0.0.1:8443"
export IFACE="enp1s0"
export ETCD_DATA_DIR="/data/k8s/etcd/data"
export ETCD_WAL_DIR="/data/k8s/etcd/wal"
export K8S_DIR="/data/k8s/k8s"
export DOCKER_DIR="/data/k8s/docker"
export CONTAINERD_DIR="/data/k8s/containerd"
BOOTSTRAP_TOKEN="41f7e4ba8b7be874fcff18bf5cf41a7c"
SERVICE_CIDR="10.254.0.0/16"
CLUSTER_CIDR="192.168.122.0/24"
export NODE_PORT_RANGE="30000-32767"
export CLUSTER_KUBERNETES_SVC_IP="10.254.0.1"
export CLUSTER_DNS_SVC_IP="10.254.0.2"
export CLUSTER_DNS_DOMAIN="cluster.ezzyads.com"
export PATH=/opt/k8s/bin:$PATH