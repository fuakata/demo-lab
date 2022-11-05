#!/bin/bash
# Written by Jose Garces
# www.theadhoclab.com

# Set variables to declare LAB specific resources.
# ESXi user name and password, ESXi host Fully Qualified Domain Name (FQDN) or IP address.
# Path to OVA/OFV file.
admin="root"
password="<your-esxi-password>"
target="<your-esxi-ipaddress>"
ova="$HOME/<path-to-ova>/Nested_ESXi8.0_IA_Appliance_Template_v2.ova"

# Assing names, IP addresses and password to ESXi nested servers.
esxi_hosts=(esxi-n1 esxi-n2 esxi-n3)
esxi_netmask="255.255.255.0"
esxi_gateway="192.168.1.x"
esxi_dns="192.168.1.x"
esxi_domain="<add-your-domain.local>"
esxi_passwd="<add-your-password>"
esxi_datastore="datastore"
esxi_network="VM Network"
esxi_netip="192.168.1"
esxi_hostip="x"

clear
echo
echo  "      ____                          __          __  "
echo  "     / __ \___  ____ ___  ____     / /   ____ _/ /_ "
echo  "    / / / / _ \/ __ \`__ \/ __ \   / /   / __ \`/ __ \\"
echo  "   / /_/ /  __/ / / / / / /_/ /  / /___/ /_/ / /_/ /"
echo  "  /_____/\___/_/ /_/ /_/\____/  /_____/\__,_/_.___/ "
echo
echo This script will deploy the following ESXi hosts using the OVFTool.
echo
for vihost in ${esxi_hosts[@]}
do
  echo "${vihost}.${esxi_domain} with IP address ${esxi_netip}.${esxi_hostip}"
  echo
done
echo
echo Requirements:
echo One up and running VMware ESXi host.
echo VMware OVFTool 4.4.3 downloaded from https://code.vmware.com/web/tool/4.4.0/ovf
echo Previously downloaded Nested ESXi Virtual Appliance file from http://vmwa.re/nestedesxi virtuallyGhetto website.
echo
echo WARNING!
echo This procedure will POWER OFF and DELETE the previous deployed environment.
echo
read -n 1 -s -r -p "Press any key to continue or Control-C to abort"
echo

# OVFTool deployment.
for vihost in ${esxi_hosts[@]}
do
  echo "Deploying ESXi host ${vihost}.${esxi_domain}..."
  ip=$((esxi_hostip++))
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
      --name="${vihost}" \
      --network="${esxi_network}" \
      --datastore="${esxi_datastore}" \
      --X:enableHiddenProperties \
      --X:logFile=ovftool-log.txt \
      --X:logLevel=verbose \
      --X:injectOvfEnv \
      --prop:guestinfo.hostname="${vihost}.${esxi_domain}" \
      --prop:guestinfo.ipaddress="${esxi_netip}.${ip}" \
      --prop:guestinfo.netmask="${esxi_netmask}" \
      --prop:guestinfo.gateway="${esxi_gateway}" \
      --prop:guestinfo.dns="${esxi_dns}" \
      --prop:guestinfo.domain="${esxi_domain}" \
      --prop:guestinfo.password="${esxi_passwd}" \
      ${ova} "vi://${admin}:${password}@${target}/"
done
