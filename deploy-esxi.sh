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
echo This script will deploy three ESXi hosts on nested LAB using the OVFTool.
echo
echo Requirements:
echo VMware ESXi host.
echo VMware vCenter Server Appliance.
echo VMware OVFTool 4.4.1 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo Previously downloaded ESXi OVA file from http://vmwa.re/nestedesxi virtuallyGhetto website.
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed environment.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort"
echo
echo

# Set variables to declare LAB specific resources.
# vCenter administrator user name.
ADMIN="administrator@vsphere.local"
# vCenter administrator password.
PASSWORD="Password123!"
# vCenter and ESXi host Fully Qualified Domain Name (FQDN) or IP address.
TARGET="vcsa.mylab.local/LAB/host/esxi.mylab.local"
# Path to OVA/OVF file.
OVA="$HOME/path/to/ova/Nested_ESXi7.0u1_Appliance_Template_v1.ova"
# Destination datastore to copy VM.
DATASTORE="datastore"
# Target network assign to VM.
NETWORK="VM Network"
# Name assing to VM.
ESXI_NODE1_HOSTNAME="esxi-node-1"
ESXI_NODE2_HOSTNAME="esxi-node-2"
ESXI_NODE3_HOSTNAME="esxi-node-3"
# Name assing to VM.
ESXI_NODE1_IP="192.168.1.x"
ESXI_NODE2_IP="192.168.1.x"
ESXI_NODE3_IP="192.168.1.x"
# Name assing to VM.
ESXI_NETMASK="255.255.255.0"
# Name assing to VM.
ESXI_GATEWAY="192.168.1.x"
# Name assing to VM.
ESXI_DNS="192.168.1.x"
# Name assing to VM.
ESXI_DOMAIN="mylab.local"
# Password assing to the ESXi.
ESXI_PASSWD="Password123!"

# OVFTool deployment.
echo
echo Deploying first ESXi host...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${ESXI_NODE1_HOSTNAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:guestinfo.hostname="${ESXI_NODE1_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE1_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"

echo
echo Deploying second ESXi host...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${ESXI_NODE2_HOSTNAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:guestinfo.hostname="${ESXI_NODE2_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE2_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"

echo
echo Deploying third ESXi host...
ovftool \
    --acceptAllEulas \
    --allowExtraConfig \
    --ipProtocol=IPv4 \
    --diskMode=thin \
    --overwrite \
    --powerOffTarget \
    --powerOn \
    --name="${ESXI_NODE3_HOSTNAME}" \
    --network="${NETWORK}" \
    --datastore="${DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --prop:guestinfo.hostname="${ESXI_NODE3_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE3_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}"
