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
echo This script will deploy three ESXi hosts using the OVFTool.
echo
echo Requirements:
echo VMware ESXi host.
echo VMware OVFTool 4.4.1 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo Previously downloaded ESXi OVA file from http://vmwa.re/nestedesxi virtuallyGhetto website.
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed environment.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort"
echo

# Set variables to declare LAB specific resources.
# ESXi user name and password, ESXi host Fully Qualified Domain Name (FQDN) or IP address.
# Path to OVA/OFV file.
ADMIN="root"
PASSWORD="Password123!"
TARGET="<your-esxi-ipaddress>>"
OVA="$HOME/<path-to-ova>/Nested_ESXi7.0u1_Appliance_Template_v1.ova"

# Assing names, IP addresses and password to ESXi servers.
ESXI_NODE1_HOSTNAME="esxi-node-1"
ESXI_NODE2_HOSTNAME="esxi-node-2"
ESXI_NODE3_HOSTNAME="esxi-node-3"
ESXI_NODE1_IP="192.168.1.x"
ESXI_NODE2_IP="192.168.1.x"
ESXI_NODE3_IP="192.168.1.x"
ESXI_NETMASK="255.255.255.0"
ESXI_GATEWAY="192.168.1.x"
ESXI_DNS="192.168.1.x"
ESXI_DOMAIN="<your-domain.local>"
ESXI_PASSWD="Password123!"
ESXI_DATASTORE="datastore"
ESXI_NETWORK="VM Network"

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
    --sourceType=OVA \
    --noSSLVerify \
    --name="${ESXI_NODE1_HOSTNAME}" \
    --network="${ESXI_NETWORK}" \
    --datastore="${ESXI_DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --X:injectOvfEnv \
    --prop:guestinfo.hostname="${ESXI_NODE1_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE1_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}/"

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
    --sourceType=OVA \
    --noSSLVerify \
    --name="${ESXI_NODE2_HOSTNAME}" \
    --network="${ESXI_NETWORK}" \
    --datastore="${ESXI_DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --X:injectOvfEnv \
    --prop:guestinfo.hostname="${ESXI_NODE2_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE2_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}/"

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
    --sourceType=OVA \
    --noSSLVerify \
    --name="${ESXI_NODE3_HOSTNAME}" \
    --network="${ESXI_NETWORK}" \
    --datastore="${ESXI_DATASTORE}" \
    --X:enableHiddenProperties \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --X:injectOvfEnv \
    --prop:guestinfo.hostname="${ESXI_NODE3_HOSTNAME}" \
    --prop:guestinfo.ipaddress="${ESXI_NODE3_IP}" \
    --prop:guestinfo.netmask="${ESXI_NETMASK}" \
    --prop:guestinfo.gateway="${ESXI_GATEWAY}" \
    --prop:guestinfo.dns="${ESXI_DNS}" \
    --prop:guestinfo.domain="${ESXI_DOMAIN}" \
    --prop:guestinfo.password="${ESXI_PASSWD}" \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}/"
