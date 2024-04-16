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

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
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
export Server_URL="raw.githubusercontent.com/musa3x/sshwstrvray/main/test"
export Server1_URL="raw.githubusercontent.com/musa3x/sshwstrvray/main/limit"
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

# // Validate Result ( 1 )
touch

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
cyan='\x1b[96m'
white='\x1b[37m'
bold='\033[1m'
off='\x1b[m'

clear
echo -e ""
echo -e "${cyan}======================================${off}"
echo -e        "           BANDWITH MONITOR " | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""
echo -e "${BIWhite} 1  ${green}⸩ View Total Bandwidth Remaining${off}"
echo -e "${BIWhite} 2  ${green}⸩ Usage Table Every 5 Minutes${off}"
echo -e "${BIWhite} 3  ${green}⸩ Hourly Usage Table${off}"
echo -e "${BIWhite} 4  ${green}⸩ Daily Usage Table${off}"
echo -e "${BIWhite} 5  ${green}⸩ Monthly Usage Table${off}"
echo -e "${BIWhite} 6  ${green}⸩ Annual Usage Table${off}"
echo -e "${BIWhite} 7  ${green}⸩ Highest Usage Table${off}"
echo -e "${BIWhite} 8  ${green}⸩ Hourly Usage Statistics${off}"
echo -e "${BIWhite} 9  ${green}⸩ View Current Active Usage${off}"
echo -e "${BIWhite} 10 ${green}⸩ View Current Active Usage Traffic [5s]${off}"
echo -e "${BIWhite} x  ${green}⸩ Menu${off}"
echo -e "${off}"
echo -e "${cyan}======================================${off}"
echo -e "${green}"
read -p "[#]  Masukkan Pilihan :  " noo
echo -e "${off}"

case $noo in
1)
echo -e "${cyan}======================================${off}"
echo -e "    TOTAL SERVER BANDWITH REMAINING" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

2)
echo -e "${cyan}======================================${off}"
echo -e "    BANDWITH USAGE EVERY 5 MINUTES" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -5

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

3)
echo -e "${cyan}======================================${off}"
echo -e "    HOURLY BANDWITH USAGE" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -h

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

4)
echo -e "${cyan}======================================${off}"
echo -e "   DAILY BANDWITH USAGE" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -d

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

5)
echo -e "${cyan}======================================${off}"
echo -e "   BANDWITH USAGE EVERY MONTH" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -m

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

6)
echo -e "${cyan}======================================${off}"
echo -e "   BANDWITH USAGE EVERY YEAR" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -y

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

7)
echo -e "${cyan}======================================${off}"
echo -e "    HIGHEST BANDWITH USAGE" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -t

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

8)
echo -e "${cyan}======================================${off}"
echo -e " HOURLY USED BANDWITH GRAPH" | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -hg

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

9)
echo -e "${cyan}======================================${off}"
echo -e "  LIVE CURRENT BANDWITH USAGE" | lolcat
echo -e "${cyan}======================================${off}"
echo -e " ${green}CTRL+C Untuk Berhenti!${off}"
echo -e ""

vnstat -l

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

10)
echo -e "${cyan}======================================${off}"
echo -e "   LIVE TRAFFIC USING BANDWITH " | lolcat
echo -e "${cyan}======================================${off}"
echo -e ""

vnstat -tr

echo -e ""
echo -e "${cyan}======================================${off}"
echo -e "$baris2" | lolcat
;;

x)
sleep 1
menu
;;

*)
sleep 1
echo -e "${red}Nomor Yang Anda Masukkan Salah!${off}"
;;
esac
read -n 1 -s -r -p "Press any key to back on menu"

menu
