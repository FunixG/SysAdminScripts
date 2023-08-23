#!/bin/bash

# List of VM IP addresses or hostnames
VM_LIST=("vm1_ip_or_hostname" "vm2_ip_or_hostname" "vm3_ip_or_hostname")

# SSH user
SSH_USER="ssh_username"

# Loop through VMs and execute update commands
for VM in "${VM_LIST[@]}"; do
    echo "Updating $VM..."
    ssh "$SSH_USER@$VM" 'sudo apt update && sudo apt upgrade -y'
    echo "$VM updated."
done

echo "All VMs updated."
