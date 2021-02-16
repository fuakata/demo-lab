#!/bin/bash
# Written by Jose Garces
# www.theadhoclab.com

clear
echo  " ____  _____ __  __  ___    _        _    ____"
echo  "|  _ \| ____|  \/  |/ _ \  | |      / \  | __ )"
echo  "| | | |  _| | |\/| | | | | | |     / _ \ |  _ \\"
echo  "| |_| | |___| |  | | |_| | | |___ / ___ \| |_) |"
echo  "|____/|_____|_|  |_|\___/  |_____/_/   \_\____/"
echo
echo
echo This script will deploy one Ubuntu Cloud Image as a VM on nested LAB using the OVFTool.
echo
echo Requirements:
echo VMware ESXi host.
echo VMware vCenter Server Appliance.
echo VMware OVFTool 4.4.1 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo Previously downloaded OVA file from https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova Canonical website.
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed instance.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort."
echo
echo

# Set variables to declare LAB specific resources.
# vCenter administrator user name and password, vCenter and ESXi host Fully Qualified Domain Name (FQDN) or IP address.
# Path to OVA/OFV file, destination datastore and target network.
ADMIN="administrator@vsphere.local"
PASSWORD='Password123!'
TARGET="vcsa.mylab.local/LAB/host/esxi.mylab.local"
OVA="$HOME/path/to/ova/focal-server-cloudimg-amd64.ova"
DATASTORE="datastore"
NETWORK="VM Network"

# Assing names, IP addresses, public key and one time password to Ubuntu Cloud Image VM.
VM_NAME="ubuntu-vm1"
VM_HOSTNAME="ubuntu-cloud"
VM_KEY="copy-your-public-ssh-key-here"
VM_PASSWORD="Password123!"

# OVF Tool deployment.
echo
echo Deploying Ubuntu Cloud Image...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${VM_NAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:enableHiddenProperties \
    --X:waitForIpv4 \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:hostname="${VM_HOSTNAME}" \
    --prop:public-keys="${VM_KEY}" \
    --prop:password="${VM_PASSWORD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"

