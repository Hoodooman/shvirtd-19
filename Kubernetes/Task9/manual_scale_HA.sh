#!/bin/bash
set -e

IMAGE_ID="fd8esej4lc19l259kuh0"
PLATFORM="standard-v3"
CORES=2
MEMORY="2GB"
DISK_SIZE=10

yc compute instance create \
  --name master-1 \
  --zone ru-central1-b \
  --platform $PLATFORM \
  --cores $CORES \
  --memory $MEMORY \
  --core-fraction 20 \
  --create-boot-disk type=network-hdd,size=${DISK_SIZE}GB,image-id="$IMAGE_ID" \
  --network-interface subnet-name=k8s-subnet-1,nat-ip-version=ipv4 \
  --preemptible \
  --ssh-key ~/.ssh/shvirtd-19_pvk.pub \
  --metadata serial-port-enable=1
  
yc compute instance create \
  --name master-2 \
  --zone ru-central1-d \
  --platform $PLATFORM \
  --cores $CORES \
  --memory $MEMORY \
  --core-fraction 20 \
  --create-boot-disk type=network-hdd,size=${DISK_SIZE}GB,image-id="$IMAGE_ID" \
  --network-interface subnet-name=k8s-subnet-2,nat-ip-version=ipv4 \
  --preemptible \
  --ssh-key ~/.ssh/shvirtd-19_pvk.pub \
  --metadata serial-port-enable=1