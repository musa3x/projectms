BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
NC='\e[0m'
m="\033[0;1;36m"
y="\033[0;1;37m"
yy="\033[0;1;32m"
yl="\033[0;1;33m"
wh="\033[0m"
## Foreground
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'

# // Export Color & Information
export red='\033[0;31m'
export green='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/NevermoreSSH/Blueblue/main/test"
export Server1_URL="raw.githubusercontent.com/NevermoreSSH/Blueblue/main/limit"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther=".geovpn"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

# // Clear
clear
clear && clear && clear
clear;clear;clear
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel5 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
function addhost(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
read -rp "Domain/Host: " -e host
echo ""
if [ -z $host ]; then
echo "????"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -n 1 -s -r -p "Press any key to back on menu"
setting-menu
else
rm -fr /etc/xray/domain
echo "IP=$host" > /var/lib/scrz-prem/ipvps.conf
echo $host > /etc/xray/domain
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo "Dont forget to renew gen-ssl"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
fi
}
function genssl(){
clear
systemctl stop nginx
systemctl stop xray
domain=$(cat /var/lib/scrz-prem/ipvps.conf | cut -d'=' -f2)
Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
if [[ ! -z "$Cek" ]]; then
sleep 1
echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
systemctl stop $Cek
sleep 2
echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
sleep 1
fi
echo -e "[ ${green}INFO${NC} ] Starting renew gen-ssl... " 
sleep 2
/root/.acme.sh/acme.sh --upgrade
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
echo -e "[ ${green}INFO${NC} ] Renew gen-ssl done... " 
sleep 2
echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
sleep 2
echo $domain > /etc/xray/domain
systemctl start nginx
systemctl start xray
echo -e "[ ${green}INFO${NC} ] All finished... " 
sleep 0.5
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}
export sem=$( curl -s https://raw.githubusercontent.com/NevermoreSSH/Blueblue/main/test/versions)
export pak=$( cat /home/.ver)
IPVPS=$(curl -s ipinfo.io/ip )
IPVPS=$(curl -sS ipv4.icanhazip.com)
IPVPS=$(curl -sS ifconfig.me )
ISPVPS=$( curl -s ipinfo.io/org )
daily_usage=$(vnstat -d --oneline | awk -F\; '{print $6}' | sed 's/ //')
monthly_usage=$(vnstat -m --oneline | awk -F\; '{print $11}' | sed 's/ //')
ram_used=$(free -m | grep Mem: | awk '{print $3}')
total_ram=$(free -m | grep Mem: | awk '{print $2}')
ram_usage=$(echo "scale=2; ($ram_used / $total_ram) * 100" | bc | cut -d. -f1)
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# TOTAL ACC XRAYS WS & XTLS
vmess=$(grep -c -E "^#vmsg $user" "/etc/xray/config.json")
vless=$(grep -c -E "^#vlsg $user" "/etc/xray/config.json")
tr=$(grep -c -E "^#trg $user" "/etc/xray/config.json")
ss=$(grep -c -E "^#ssg $user" "/etc/xray/config.json")
ssh="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
systemctl status noobzvpns.service | grep -i 'Active' > /tmp/st-noob.txt
if grep -q "running" /tmp/st-noob.txt && [ "$(awk '{print $3}' /tmp/st-noob.txt)" = "(running)" ]; then
    noob="${green}ON${NC}"
else
    noob="${red}OFF${NC}"
fi
usrnoob=$(noobzvpns --info-all-user > /tmp/noobuser.txt && awk '/Total User\(s\)/ { print $3 }' /tmp/noobuser.txt)
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*/} / ${corediilik:-1}))"
cpu_usage+="%"
cname=$(awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo)
cores=$(awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo)
freq=$(awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo)
clear
echo -e "${BICyan} ┌────────────── »»» Auto Script Panel By Musa ««« ─────────────┐${NC}"
#echo -e "${BICyan} │                  ${BIYellow}${UWhite}»»» Server Informations «««${NC}\t\t\t${BICyan}│"
echo -e "${BICyan} │  ${BICyan}OS Linux        \t${BIWhite}: ${BICyan}"$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-) "${BICyan}\t\t│"
echo -e "${BICyan} │  ${BICyan}Kernel          \t${BIWhite}: ${BICyan}$(uname -r)${NC}\t\t\t${BICyan}│"
echo -e "${BICyan} │  ${BIBlue}CPU Name        \t${BIWhite}:${BIBlue}$cname${NC}\t\t\t\t${BICyan}│"
echo -e "${BICyan} │  ${BIBlue}CPU Info        \t${BIWhite}: ${BIBlue}$cores Cores @ $freq MHz (${cpu_usage}) ${NC}\t\t${BICyan}"
echo -e "${BICyan} │  ${GB}Total RAM       \t${BIWhite}: ${GB}${ram_used}MB / ${total_ram}MB (${ram_usage}%) ${NC} \t\t${BICyan}"
echo -e "${BICyan} │  ${BIGreen}System Uptime   \t${BIWhite}: ${BIRed}$uptime${NC}\t\t\t${BICyan}"
echo -e "${BICyan} │  ${BIGreen}Current Domain  \t${BIWhite}: ${IBGreen}$(cat /etc/xray/domain)${NC}\t\t\t${BICyan}│"
#echo -e "${BICyan} │  ${BICyan}IP-VPS          \t: ${BIGreen}$IPVPS${NC}\t\t${BICyan}│"
echo -e "${BICyan} │  ${BIYellow}Daily Bandwidth \t${BIWhite}: ${BIYellow}$daily_usage ${NC} \t\t\t\t${BICyan}│"
echo -e "${BICyan} │  ${YB}Total Bandwidth \t${BIWhite}: ${YB}$monthly_usage ${NC}\t\t\t\t${BICyan}│"
echo -e "${BICyan} └──────────────────────────────────────────────────────────────┘${NC}"
echo -e "${BIBlue} ┌»»»»»»»»»»»»»»»»»»»»»»${BIGreen} Status Service ${NC}${BIBlue}««««««««««««««««««««««««┐"
#echo -e "| \t\t\t\t\t\t\t\t|"
echo -e "${BIBlue} |    ${BICyan} SSH-WS ${NC}: $ressh "" ${BICyan} NGINX ${NC}: $resngx "" ${BICyan}  XRAY ${NC}: $resv2r "" ${BICyan} TROJAN ${NC}: $resv2r \t${BIBlue}|"
echo -e "${BIBlue} |${BICyan} DROPBEAR ${NC}: $resdbr  " "${BICyan} SSH-WS ${NC}: $ressshws " "${BICyan} NoobzVpn ${NC}: $noob  " ${BICyan}Stunnel ${NC}: $resst "\t${BIBlue}|"
echo -e "${BIBlue} └«««««««««««««««««««««««««««««««««»»»»»»»»»»»»»»»»»»»»»»»»»»»»»┘"
#echo -e " "
echo -e "${BIGreen} ┌───────────────────────── Menu Account ───────────────────────┐${NC}"
#echo -e "${BICyan}                  ${BIYellow}${UWhite}»»» Menu SSH/XRAY «««${NC}\t\t\t\t${BICyan}"
#echo -e " "
echo -e "${BIGreen} |  ${BICyan}[${BIYellow}01${BICyan}] SSH-WS      ${WB}[${GB}${ssh}${WB}]   \t\t${BICyan}[${BIYellow}04${BICyan}] TROJAN      ${WB}[${GB}${tr}${WB}]\t${BIGreen}|" 
echo -e "${BIGreen} |  ${BICyan}[${BIYellow}02${BICyan}] VMESS       ${WB}[${GB}${vmess}${WB}] \t\t${BICyan}[${BIYellow}05${BICyan}] SHADOWSOCKS ${WB}[${GB}${ss}${WB}]\t${BIGreen}|"    
echo -e "${BIGreen} |  ${BICyan}[${BIYellow}03${BICyan}] VLESS       ${WB}[${GB}${vless}${WB}] \t\t${BICyan}[${BIYellow}06${BICyan}] NoobzVpn    ${WB}[${GB}${usrnoob}${WB}]${BIGreen}|"   
echo -e "${BIGreen} └──────────────────────────────────────────────────────────────┘${NC}"
echo -e "${IGreen} ┌────────────────────────── Menu Tool ─────────────────────────┐${NC}"
#echo -e "${BICyan}                  ${BIYellow}${UWhite}»»» Menu Service «««${NC}"
#echo -e " "
echo -e "${IGreen} |  ${BICyan}[${BIYellow}07${BICyan}] ADD HOST/DOMAIN \t\t${BICyan}[${BIYellow}16${BICyan}] TASK MANAGER  \t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}08${BICyan}] RENEW CERT      \t\t${BICyan}[${BIYellow}17${BICyan}] DNS CHANGER  \t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}09${BICyan}] EDIT BANNER     \t\t${BICyan}[${BIYellow}18${BICyan}] TENDANG \t\t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}10${BICyan}] RUNNING STATUS  \t\t${BICyan}[${BIYellow}19${BICyan}] XRAY-CORE MENU \t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}11${BICyan}] SPEEDTEST       \t\t${BICyan}[${BIYellow}20${BICyan}] USER BANDWIDTH \t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}12${BICyan}] CHECK BANDWIDTH \t\t${BICyan}[${BIYellow}21${BICyan}] BACKUP USER \t${IGreen}|" 
echo -e "${IGreen} |  ${BICyan}[${BIYellow}13${BICyan}] LIMIT SPEED     \t\t${BICyan}[${BIYellow}22${BICyan}] RESTORE USER \t${IGreen}|" 
echo -e "${IGreen} |  ${BICyan}[${BIYellow}14${BICyan}] INFO SCRIPT     \t\t${BICyan}[${BIYellow}23${BICyan}] INSTALL SLOWDNS \t${IGreen}|"
echo -e "${IGreen} |  ${BICyan}[${BIYellow}15${BICyan}] CLEAR LOG       \t\t${BICyan}[${BIYellow}24${BICyan}] INSTALL UDPCUSTOM \t${IGreen}|"
#echo -e "${BICyan} ────────────────────────────────────────────────────────────────${NC}"
echo -e "${IGreen} └──────────────────────────────────────────────────────────────┘${NC}"
echo -e "${IYellow} ┌──────────────────────── Menu Server ─────────────────────────┐${NC}"
#echo -e "${BICyan}                 ${BIYellow}${UWhite}»»» Menu Server «««${NC}"
#echo -e " "
echo -e "${IYellow} |  ${BICyan}[${BIYellow}33${BICyan}] EXP FILES ${NC} \t\t\t${BICyan}[${BIYellow}66${BICyan}] RESTART ${NC} \t\t${IYellow}|"    
echo -e "${IYellow} |  ${BICyan}[${BIYellow}44${BICyan}] AUTO REBOOT ${NC} \t\t\t${BICyan}[${BIYellow}77${BICyan}] BACKUP/RESTORE \t${IYellow}|${NC}"    
echo -e "${IYellow} |  ${BICyan}[${BIYellow}55${BICyan}] REBOOT ${NC} \t\t\t${BICyan}[${BIRed}XX${BICyan}]${BIRed} EXIT \t\t${IYellow}|"     
echo -e "${IYellow} └──────────────────────────────────────────────────────────────┘${NC}"
echo
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trojan ;;
5) clear ; menu-ss ;;
6) clear ; menu-noobz ;;
7) clear ; addhost ;;
8) clear ; genssl ;;
9) clear ; nano /etc/issue.net ;; 
10) clear ; running ;;

11) clear ; cek-speed ;;
12) clear ; cek-bandwidth ;;
13) clear ; limit-speed ;;
14) clear ; cat /root/log-install.txt ;;
15) clear ; clearlog ;;
16) clear ; gotop ;;
17) clear ; dns ;;
18) clear ; tendang ;;
19) clear ; wget -q -O /usr/bin/xraychanger "https://raw.githubusercontent.com/NevermoreSSH/Xcore-custompath/main/xraychanger.sh" && chmod +x /usr/bin/xraychanger && xraychanger ;;
20) clear ; cek-trafik ;;
21) clear ; backup ;;
22) clear ; restore ;;
23) clear ; wget https://raw.githubusercontent.com/NevermoreSSH/Vergil/main2/addons/dns2.sh && chmod +x dns2.sh && ./dns2.sh ;;
24) clear ; wget https://raw.githubusercontent.com/musa3x/UDP-Custom/main/udp-custom.sh && bash udp-custom.sh ;;
33) clear ; xp ;;
44) clear ; autoreboot ;;
55) clear ; reboot ;;
66) clear ; restart ;;
77) clear ; menu-backup-tl ;;
0) clear ; menu ;;
xx) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
