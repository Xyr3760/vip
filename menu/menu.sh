#!/bin/bash
MYIP=$(curl -sS ipv4.icanhazip.com)
echo "Checking VPS"
#########################

# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
clear 
echo -e "\033[1;36m╭─────────────────────────────────────────────╮\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;97m\033[45m            XYORUZ TUNNELING              \033[0m\033[1;36m│\033[0m"
echo -e "\033[1;36m╰─────────────────────────────────────────────╯\033[0m"
}


function Service_System_Operating() {
echo -e "\033[1;36m╭─────────────────────────────────────────────╮\033[0m"
echo -e "\033[1;36m│\033[38;5;208m 💻 OS              : $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')     \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m 🖥️ RAM             : $(free -m | awk 'NR==2 {print $2 " MB"}')    \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m 🌆 CITY            : $(cat /etc/xray/city)   \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m 📡 ISP             : $(cat /etc/xray/isp)    \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m 🌐 IP              : $(curl -s ipv4.icanhazip.com)     \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m 🌐 DOMAIN          : $(cat /etc/xray/domain)    \033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m│\033[38;5;208m ⏳ UPTIME          : $(uptime -p | cut -d " " -f 2-10)\033[0m\033[1;36m \033[0m"
echo -e "\033[1;36m╰─────────────────────────────────────────────╯\033[0m"
}


function Service_Status() {
echo -e "\033[1;35m╭─────────────────────────────────────────────────╮\033[0m"
echo -e "\033[1;35m│\033[0m\e[38;5;200m PROXY :\e[0m $status_haproxy  \e[0m│\e[38;5;202m NGINX :\e[0m $status_nginx  \e[0m│\e[38;5;208m SSHWS :\e[0m $status_ws_epro \e[0m│ $status_dropbear  \e[96;1m│\033[0m"
echo -e "\033[1;35m╰─────────────────────────────────────────────────╯\033[0m"
}


echo -e "\033[1;36m╭─────────────────────────────────────────────╮\033[0m"
echo -e " [\e[36m•1\e[0m] SSH & OpenVPN Menu  [\e[36m•5\e[0m] SYSTEM Menu"
echo -e " [\e[36m•2\e[0m] Vmess Menu          [\e[36m•6\e[0m] Status Service"
echo -e " [\e[36m•3\e[0m] Vless Menu          [\e[36m•7\e[0m] Clear RAM Cache"
echo -e " [\e[36m•4\e[0m] Trojan Go Menu      [\e[36m•8\e[0m] Trojan GFW Menu"                  
echo -e "\033[1;36m╰─────────────────────────────────────────────╯\033[0m"
}

echo -e   " Press x or [ Ctrl+C ] • To-Exit-Script"
echo -e   ""
echo -e   ""
read -p " Select menu :  "  opt
echo -e   ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trgo ;;
5) clear ; menu-set ;;
6) clear ; running ;;
7) clear ; clearcache ;;
8) clear ; menu-trojan ;;
x) exit ;;
esac
