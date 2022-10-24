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
echo This script will deploy one vCenter Server Appliance using OVFTool.
echo
echo Requirements:
echo VMware ESXi host
echo VMware OVFTool 4.4.3 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo VMware vCenter Server Appliance OVA downloaded from https://downloads.vmware.com
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed instance.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort."
echo
echo

# Set variables to declare LAB specific resources.
# ESXi administrator and password, host IP address & path to OVA/OFV file.
ADMIN="root"
PASSWORD="Password123!"
TARGET="192.168.0.x"
OVA="$HOME/<path-to-ova>/VMware-vCenter-Server-Appliance-8.0.0.10000-20519528_OVF10.ova"

# Assign VCSA VM name, VCSA size, host Fully Qualified Domain Name (FQDN) or IP address, IP address networking, SSO user password and root password to VCSA.
VCSA_NAME="vcsa-lab"
VCSA_SIZE="tiny"
VCSA_IP="192.168.0.x"
VCSA_HOSTNAME="<your-host-name-on-DNS>"
VCSA_GW="192.168.0.x"
VCSA_CIDR="24"
VCSA_DNS="192.168.0.x"
VCSA_NTP="pool.ntp.org"
VCSA_SSO_DOMAIN="vsphere.local"
VCSA_SSO_PASSWORD="Password123!"
VCSA_PASSWORD="Password123!"
VCSA_NETWORK="VM Network"
VCSA_DATASTORE="datastore"
VCSA_ALLSTAGES="True"


# OVFTool deployment.
echo
echo Deploying VMware vCenter Server Appliance...
ovftool \
    --powerOffTarget \
    --overwrite \
    --powerOn \
    --X:injectOvfEnv \
    --X:logFile=ovftool-log.txt \
    --X:logLevel=verbose \
    --acceptAllEulas \
    --noSSLVerify \
    --sourceType=OVA \
    --allowExtraConfig \
    --diskMode=thin \
    --name="${VCSA_NAME}" \
    --net:"Network 1"="${VCSA_NETWORK}" \
    --datastore="${VCSA_DATASTORE}" \
    --deploymentOption=${VCSA_SIZE} \
    --prop:guestinfo.cis.deployment.node.type=embedded \
    --prop:guestinfo.cis.appliance.net.addr=${VCSA_IP} \
    --prop:guestinfo.cis.appliance.net.pnid=${VCSA_HOSTNAME} \
    --prop:guestinfo.cis.appliance.net.mode=static \
    --prop:guestinfo.cis.appliance.net.addr.family=ipv4 \
    --prop:guestinfo.cis.appliance.net.prefix=${VCSA_CIDR} \
    --prop:guestinfo.cis.appliance.net.gateway=${VCSA_GW} \
    --prop:guestinfo.cis.appliance.ntp.servers=${VCSA_NTP} \
    --prop:guestinfo.cis.appliance.net.dns.servers=${VCSA_DNS} \
    --prop:guestinfo.cis.vmdir.domain-name=${VCSA_SSO_DOMAIN} \
    --prop:guestinfo.cis.vmdir.password=${VCSA_SSO_PASSWORD} \
    --prop:guestinfo.cis.appliance.root.passwd=${VCSA_PASSWORD} \
    --prop:guestinfo.cis.system.vm0.port=443 \
    --prop:guestinfo.cis.appliance.ssh.enabled=True \
    --prop:guestinfo.cis.ceip_enabled=True \
    --prop:guestinfo.cis.vmdir.first-instance=True \
    --prop:guestinfo.cis.deployment.autoconfig=${VCSA_ALLSTAGES} \
    ${OVA} "vi://${ADMIN}:${PASSWORD}@${TARGET}/"
