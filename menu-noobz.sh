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
    echo -e "                 MEMBER SSH               " | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"      
    echo "USERNAME          EXP DATE          STATUS"
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

    # Proses membaca dan menampilkan data
    while read -r expired; do
        # Menyimpan data ke file sementara
        cat /etc/noobzvpns/users.json > /tmp/datalogin.txt
        # Mengambil username
        usr=$(grep -o '"musa"' /tmp/datalogin.txt | tr -d '"')
        # Mengambil tanggal expired
        expired=$(grep -o '"expired":[0-9]*' /tmp/datalogin.txt | cut -d":" -f2)
        # Mengambil tanggal penerbitan
        tgl=$(grep -o '"issued":"[0-9]*"' /tmp/datalogin.txt | cut -d":" -f2 | tr -d '"')
        # Menampilkan data
        printf "%-17s %2s %-17s %2s \n" "$usr" "$expired" "$tgl"
    done < /etc/passwd

    # Menghitung jumlah akun
    JUMLAH=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo "Account number: $JUMLAH user" | lolcat
    echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
}

function renew(){
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "               RENEW  USER                " | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo
read -p "Username : " username
if noobzvpns --info-user "$username" > /dev/null 2>&1; then
    read -p "Tambah (hari) : " tambah
    cat /etc/noobzvpns/users.json | grep -i "$username" > /tmp/datalogin.txt
    cat /tmp/datalogin.txt | grep -o '"expired":[0-9]*' | cut -d":" -f2 > /tmp/dataexp.txt
 #  cat /tmp/datalogin.txt | grep -o '"issued":"[0-9]*"' | cut -d":" -f2 | tr -d '"' > /tmp/datatgl.txt
    tam=$(tambah)
    expire=$(< /tmp/dataexp.txt)
    exp=$((expire + tamb))
    noobzvpns --expired-user $username $exp
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "               RENEW  USER               " | lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
echo -e " nama user : $username"
echo -e " bertambah : $tam hari"
echo -e " Expire dalam  :  $exp hari"
echo -e " Expired  :  $expired hari"
echo -e ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"    
else
clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "              RENEW  USER                "| lolcat
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"  
echo -e ""
echo -e "   Username Doesnt Exist      "
echo -e ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
fi
read -n 1 -s -r -p "Press any key to back on menu"
menu-noobz
}

clear
echo -e "${BIYellow} ┌────────────── ${BIGreen}MENU NoobzVpn ${BIYellow}──────────────┐${NC}"
echo -e ""
echo -e "  ${BICyan}[${BIWhite}1${BICyan}] Add Account   "    
echo -e "  ${BICyan}[${BIWhite}2${BICyan}] Delete Account" 
echo -e "  ${BICyan}[${BIWhite}3${BICyan}] Renew Account  " 
echo -e "  ${BICyan}[${BIWhite}4${BICyan}] list user     "
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
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
