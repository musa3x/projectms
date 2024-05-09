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
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

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


clear

function tambah(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "              TAMBAH PENGGUNA" | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo ""
read -p "Masukkan Nama Pengguna: " nama
read -p "Masukkan password: " pass
read -p "Masa Aktif(hari) : " exp
noobzvpns --add-user $nama $pass
noobzvpns --expired-user $nama $exp
echo "User $nama berhasil di tambahkan."
echo "nama : $nama ; password : $pass ; masa aktif : $exp ."

read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}

function del(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "              DELETE USER" | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo ""
read -p "Username SSH to Delete : " Pengguna

if noobzvpns --info-user "$Pengguna" > /dev/null 2>&1; then
    # Jika ditemukan, hapus pengguna
    noobzvpns --remove-user "$Pengguna"
    echo "User $Pengguna telah di hapus."
else
    # Jika tidak ditemukan, cetak pesan kesalahan
    echo "User $username tidak ditemukan mohon cek kembali ejaan anda."
fi

read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz

}
function member(){
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "            LIST MEMBER NoobzVpn               " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    echo -e "   NAMA           EXPIRE         STATUS  " | lolcat
    echo -e "\033[0;34m-------------------------------------------\033[0m" 
   # noobzvpns --info-all-user
    noobzvpns --info-all-user > /tmp/noobuser.txt
    awk '/^\+/ { user=$2; sta=$4; }/-expired/ {act=$2; printf " %-10s\t%s\t%s\n", user, act, sta }' /tmp/noobuser.txt | lolcat
    echo -e "\033[0;34m-------------------------------------------\033[0m" 
    awk '/Total User\(s\)/ { print $0 }' /tmp/noobuser.txt | lolcat
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}
function blockusr(){
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                BLOCK PENGGUNA              " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    read -p "Nama user : " Pengguna
    cat /etc/noobzvpns/users.json | jq -r ".$Pengguna" > /tmp/datalogin.txt
    if [ $(wc -c < /tmp/datalogin.txt) -gt 10 ]; then
    noobzvpns --block-user $Pengguna
    echo "block $Pengguna berhasil."
    else
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                BLOCK PENGGUNA              " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    echo "            USER TIDAK DITEMUKAN" | lolcat
    fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}
function unblock(){
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                UNBLOCK PENGGUNA               " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    read -p "Nama user : " Pengguna
     cat /etc/noobzvpns/users.json | jq -r ".$Pengguna" > /tmp/datalogin.txt
    if [ $(wc -c < /tmp/datalogin.txt) -gt 10 ]; then
    noobzvpns --unblock-user $Pengguna
    echo "Unblock $Pengguna berhasil."
    else
    clear 
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                UNBLOCK PENGGUNA               " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    echo "            USER TIDAK DITEMUKAN" | lolcat
    fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}
function ubahpw(){
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                 UBAH PASSWORD             " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    read -p "Nama user : " Pengguna
    cat /etc/noobzvpns/users.json | jq -r ".$Pengguna" > /tmp/datalogin.txt
    if [ $(wc -c < /tmp/datalogin.txt) -gt 10 ]; then
    read -p "Password Baru : " pwbaru
    noobzvpns --password-user $Pengguna $pwbaru
    echo "Ubah Password $Pengguna menjadi $pwbaru berhasil."
    else
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "              UBAH PASSWORD                "| lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
    echo -e ""
    echo -e "  DATA USER TIDAK DITEMUKAN     "| lolcat
    echo -e ""
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}

function ubahuser(){
    clear
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "                UBAH NAMA PENGGUNA              " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" 
    read -p "Nama user : " Pengguna
    cat /etc/noobzvpns/users.json | jq -r ".$Pengguna" > /tmp/datalogin.txt
    if [ $(wc -c < /tmp/datalogin.txt) -gt 10 ]; then
    read -p "Nama User Baru : " userbaru
    noobzvpns --rename-user $Pengguna $userbaru
    echo "Ubah user $Pengguna Menjadi $userbaru berhasil."
    else
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "              UBAH NAMA PENGGUNA               "| lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
    echo -e ""
    echo -e "  DATA PENGGUNA TIDAK DITEMUKAN     "| lolcat
    echo -e ""
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}

function renew(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "             PERPANJANG MASA AKTIF USER                " | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo
read -p "Username : " username
cat /etc/noobzvpns/users.json | jq -r ".$username" > /tmp/datalogin.txt
if [ $(wc -c < /tmp/datalogin.txt) -gt 10 ]; then
    read -p "Tambah (hari) : " hari
  #  cat /etc/noobzvpns/users.json | grep -i "$username" > /tmp/datalogin.txt
    cat /tmp/datalogin.txt | jq '.expired' > /tmp/dataexp.txt
 #  cat /tmp/datalogin.txt | grep -o '"issued":"[0-9]*"' | cut -d":" -f2 | tr -d '"' > /tmp/datatgl.txt
    expire=`cat /tmp/dataexp.txt`
    exp=$((expire + hari))
    noobzvpns --expired-user $username $exp
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "               TAMBAH MASA AKTIF               " | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
echo -e " nama user : $username"
echo -e " bertambah : $hari hari"
echo -e " Expire Menjadi  :  $exp hari"
echo -e ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"    
else
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "              TAMBAH MASA AKTIF                "| lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
echo -e "   DATA PENGGUNA TIDAK DITEMUKAN     "
echo -e ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}

clear
echo -e "${BIYellow} ┌────────────── ${BIGreen}MENU NoobzVpn ${BIYellow}──────────────┐${NC}"
echo -e ""
echo -e "  ${BICyan}[${BIWhite}1${BICyan}] Add Account   \t${BICyan}[${BIWhite}5${BICyan}] ubah password    "    
echo -e "  ${BICyan}[${BIWhite}2${BICyan}] Delete Account \t${BICyan}[${BIWhite}6${BICyan}] ubah username   " 
echo -e "  ${BICyan}[${BIWhite}3${BICyan}] Renew Account  \t${BICyan}[${BIWhite}7${BICyan}] Block User  " 
echo -e "  ${BICyan}[${BIWhite}4${BICyan}] list user     \t${BICyan}[${BIWhite}8${BICyan}] Unblock User   "
echo -e " ${BIYellow}└──────────────────────────────────────┘${NC}"
echo -e "     ${BIYellow}Tekan x atau [ Ctrl+C ] • ${BIWhite}untuk Keluar${NC}"
echo -e "     ${BIBlue}Tekan Enter untuk kembali ke • ${BIWhite}menu utama ${NC}"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; tambah ;;
2) clear ; del ;;
3) clear ; renew;;
4) clear ; member ;;
5) clear ; ubahpw ;;
6) clear ; ubahuser ;;
7) clear ; blockusr;;
8) clear ; unblock ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
