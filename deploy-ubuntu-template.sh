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
echo This script will deploy one Ubuntu Cloud Image as a VM template on nested LAB using the OVFTool.
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
# vCenter administrator user name.
ADMIN="administrator@vsphere.local"
# vCenter administrator password.
PASSWORD='Password123!'
# vCenter and ESXi host Fully Qualified Domain Name (FQDN) or IP address.
TARGET="vcsa.mylab.local/LAB/host/esxi.myhome.local"
# Path to OVA/OVF file.
OVA="$HOME/path/to/ova/focal-server-cloudimg-amd64.ova"
# Destination datastore to copy VM template.
DATASTORE="datastore"
# Target network assign to VM template.
NETWORK="VM Network"
# Name assing to VM template.
VM_NAME="ubuntu-focal-20.04-template"
# Hostname assign to VM template.
VM_HOSTNAME="ubuntu-cloud"
# Destination folder to copy VM template.
VM_FOLDER="Templates"
# Public key for VM template.
VM_KEY="ssh-rsaAAAAB3NzaC1yc2EAAAADAQABAAACAQDsVlBiFo1gdjA/wctJULb6O+t0GKtTMdKwOgSL+Nx84LAJicr1O61W3wpkHhUyCZ+9LtBEFc41hgrLrbpWBvhW6eLoA76HNgB0md3q44Dw9ZCVYWsp4WxaounSbOeaO4v2XAdnQv3u7pr7m9HG3zoiJhHaTgYhAP7Qv0mG3RENayynbDVofJXJdwtsZXTFQLnxN6vZrG6rAdwx9PHkGN4O+rxAH0IwcI+xOMxFpO2DNLevtfM2nga7UOvjiOCyCSb/othIi4PAwZPaSNkdjWNvueEkLLspFhJ1Q91I7acre/QooN+ifDkfG6XGcaDKUHis5FUq2vtNEfQT2Hx+7rInxcBMBfOD9Z2e+HLnwpUtTdRU2DtCBsN8PMU5iyj2ClcB3a1wE7AzKYXmq1TlckyesxZUeCq1Y8yxmXfgoDvjyyN31AnXIhyduLXpLpVINvtRWlM4XB6jWC+kNieiuoLsAeJkeCsGdpNkmdVhsBTWVDfJ3MuoY5mrXd7LeFLIsKTUWk1J6Q2jQ+PmB3o9HeesC0VSj7GElndWNqSbSNy7e/D48XwydqsesrKaZcs4HIc8zkEYbaibYvE6NbFMo0BYVFK/+6ip2tcAAF0iNpUx30ox3paIoaURByb26SGZXTTy/IDREYAtCah5OWE8KrlePpwTYogqm5WCFAQPvgfT7Q==pepe.garces@gmail.com"
# One time password assign to VM template.
VM_PASSWORD="Password123!"

# OVF Tool deployment.
echo Deploying Ubuntu Cloud Image...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --importAsTemplate \
    --vmFolder="${VM_FOLDER}" \
    --name="${VM_NAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:waitForIpv4 \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:hostname="${VM_HOSTNAME}" \
    --prop:public-keys="${VM_KEY}" \
    --prop:password="${VM_PASSWORD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"

