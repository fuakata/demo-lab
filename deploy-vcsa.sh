#!/bin/bash
# Written by Jose Garces
# www.theadhoclab.com

# Set variables to declare LAB specific resources.
# ESXi administrator and password, host IP address & path to OVA/OFV file.
admin="root"
password="<your-esxi-password>"
target="<your-esxi-ipaddress>"
ova="$HOME/<path-to-ova>/VMware-vCenter-Server-Appliance-8.0.0.10000-20519528_OVF10.ova"

# Assign VCSA VM name, VCSA size, host Fully Qualified Domain Name (FQDN) or IP address, IP address networking, SSO user password and root password to VCSA.
vcsa_name="vcsa-lab"
vcsa_size="tiny"
vcsa_ip="192.168.0.x"
vcsa_hostname="<your-host-name-on-DNS>"
vcsa_gw="192.168.0.x"
vcsa_cidr="24"
vcsa_dns="192.168.0.x"
vcsa_ntp="pool.ntp.org"
vcsa_sso_domain="vsphere.local"
vcsa_sso_password="Password123!"
vcsa_password="Password123!"
vcsa_network="VM Network"
vcsa_datastore="datastore"
vcsa_allstages="True"

clear
echo
echo  "      ____                          __          __  "
echo  "     / __ \___  ____ ___  ____     / /   ____ _/ /_ "
echo  "    / / / / _ \/ __ \`__ \/ __ \   / /   / __ \`/ __ \\"
echo  "   / /_/ /  __/ / / / / / /_/ /  / /___/ /_/ / /_/ /"
echo  "  /_____/\___/_/ /_/ /_/\____/  /_____/\__,_/_.___/ "
echo
echo This script will deploy one vCenter Server Appliance using OVFTool.
echo
echo Requirements:
echo One up and running VMware ESXi host.
echo VMware OVFTool 4.4.3 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo VMware vCenter Server Appliance OVA downloaded from https://downloads.vmware.com
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed instance.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort."
echo
echo

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
    --name="${vcsa_name}" \
    --net:"Network 1"="${vcsa_network}" \
    --datastore="${vcsa_datastore}" \
    --deploymentOption=${vcsa_size} \
    --prop:guestinfo.cis.deployment.node.type=embedded \
    --prop:guestinfo.cis.appliance.net.addr=${vcsa_ip} \
    --prop:guestinfo.cis.appliance.net.pnid=${vcsa_hostname} \
    --prop:guestinfo.cis.appliance.net.mode=static \
    --prop:guestinfo.cis.appliance.net.addr.family=ipv4 \
    --prop:guestinfo.cis.appliance.net.prefix=${vcsa_cidr} \
    --prop:guestinfo.cis.appliance.net.gateway=${vcsa_gw} \
    --prop:guestinfo.cis.appliance.ntp.servers=${vcsa_ntp} \
    --prop:guestinfo.cis.appliance.net.dns.servers=${vcsa_dns} \
    --prop:guestinfo.cis.vmdir.domain-name=${vcsa_sso_domain} \
    --prop:guestinfo.cis.vmdir.password=${vcsa_sso_password} \
    --prop:guestinfo.cis.appliance.root.passwd=${vcsa_password} \
    --prop:guestinfo.cis.system.vm0.port=443 \
    --prop:guestinfo.cis.appliance.ssh.enabled=True \
    --prop:guestinfo.cis.ceip_enabled=True \
    --prop:guestinfo.cis.vmdir.first-instance=True \
    --prop:guestinfo.cis.deployment.autoconfig=${vcsa_allstages} \
    ${ova} "vi://${admin}:${password}@${target}/"
