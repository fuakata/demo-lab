#!/bin/bash
# Written by Jose Garces
# www.theadhoclab.com

# Set variables to declare LAB specific resources.
# vCenter administrator user name and password, vCenter and ESXi host Fully Qualified Domain Name (FQDN) or IP address.
# Path to OVA/OFV file, destination datastore and target network.
admin="administrator@vsphere.local"
password="<your-esxi-password>"
target="<your-vcsa.domain.local>/LAB/host/<your-esxi.domain.local>"
ova="$HOME/<path-to-ova>/focal-server-cloudimg-amd64.ova"
datastore="datastore"
network="VM Network"

# Assing names, IP addresses, public key and one time password to Ubuntu Cloud Image VM.
vm_name="ubuntu-vm1"
vm_hostname="ubuntu-cloud"
vm_key="<copy-your-public-ssh-key-here>"
vm_password="<your-vm-temp-password>"

clear
echo
echo  "      ____                          __          __  "
echo  "     / __ \___  ____ ___  ____     / /   ____ _/ /_ "
echo  "    / / / / _ \/ __ \`__ \/ __ \   / /   / __ \`/ __ \\"
echo  "   / /_/ /  __/ / / / / / /_/ /  / /___/ /_/ / /_/ /"
echo  "  /_____/\___/_/ /_/ /_/\____/  /_____/\__,_/_.___/ "
echo
echo This script will deploy one Ubuntu Cloud Image as a VM using the OVFTool.
echo
echo Requirements:
echo One up and running VMware ESXi host.
echo VMware vCenter Server Appliance.
echo VMware OVFTool 4.4.3 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo Previously downloaded OVA file from https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.ova Canonical website.
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed instance.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort."
echo
echo

# OVF Tool deployment.
echo Deploying Ubuntu Cloud Image...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${vm_name}" \
    --network="${network}" \
    --datastore="${datastore}" \
    --X:enableHiddenProperties \
    --X:waitForIpv4 \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:hostname="${vm_hostname}" \
    --prop:public-keys="${vm_key}" \
    --prop:password="${vm_password}" \
    ${ova} "vi://${admin}:${password}@${target}"

