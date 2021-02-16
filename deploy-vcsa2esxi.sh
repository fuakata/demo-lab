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
echo This script will deploy one vCenter Server Appliance on nested LAB using OVFTool.
echo
echo Requirements:
echo VMware ESXi host
echo VMware OVFTool 4.4.1 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo VMware vCenter Server Appliance OVA downloaded from https://downloads.vmware.com
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed instance.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort."
echo
echo

# Set variables to declare LAB specific resources.
# ESXi administrator and password, host IP address.
# Path to OVA/OFV file, destination datastore and target network.
ADMIN="root"
PASSWORD="Password123!"
TARGET="192.168.1.x"
OVA="$HOME/path/to/ova/VMware-vCenter-Server-Appliance-7.0.1.00100-17004997_OVF10.ova"
DATASTORE="datastore"
NETWORK="VM Network"

# Assign name, IP address networking, SSO user password and root password to VCSA.
VCSA_NAME="vcsa"
VCSA_IP_FAMLIY="ipv4"
VCSA_IP_MODE="dhcp"
VCSA_GATEWAY="192.168.1.x"
VCSA_DNS="192.168.1.x"
VCSA_PASSWD="Password123!"
VCSA_ROOT_PASSWD="Password123!"

# OVFTool deployment.
echo
echo Deploying VMware vCenter Server Appliance...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${VCSA_NAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:enableHiddenProperties \
    --X:waitForIpv4 \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:guestinfo.cis.appliance.net.addr.family="${VCSA_IP_FAMILY}" \
    --prop:guestinfo.cis.appliance.net.mode="${VCSA_IP_MODE}" \
    --prop:guestinfo.cis.appliance.net.gateway="${VCSA_GATEWAY}" \
    --prop:guestinfo.cis.appliance.net.dns.servers="${VCSA_DNS}" \
    --prop:guestinfo.cis.vmdir.password="${VCSA_PASSWD}" \
    --prop:guestinfo.cis.appliance.root.passwd="${VCSA_ROOT_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"
