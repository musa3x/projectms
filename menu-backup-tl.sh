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
GREEN() { echo -e "\\033[32;1m${*}\\033[0m"; }
RED() { echo -e "\\033[31;1m${*}\\033[0m"; }

# // Export Banner Status Information
export INFO="[${YELLOW} INFO ${NC}]"

function bckpbot(){
clear
IP=$(curl -sS ipv4.icanhazip.com)
date=$(date +"%Y-%m-%d")
domain=$(cat /etc/xray/domain)
clear
echo -e "[ ${GREEN}INFO${NC} ] Create for database"
read -rp "Enter Token (Create on Botfather): " -e token
read -rp "Enter Chat ID (channel, group, or user ID): " -e id_chat
echo -e "toket=$token" > /root/botapi.conf
echo -e "chat_idc=$id_chat" >> /root/botapi.conf
sleep 1
clear
echo -e "[ ${GREEN}INFO${NC} ] Processing... "
mkdir -p /root/backup
sleep 1

# Backup data
cp -r /root/.acme.sh /root/backup/ &> /dev/null
cp /etc/passwd /root/backup/ &> /dev/null
cp /etc/group /root/backup/ &> /dev/null
cp -r /var/lib/scrz-prem/ /root/backup/scrz-prem &> /dev/null
cp -r /etc/xray /root/backup/xray &> /dev/null
cp -r /etc/nginx/conf.d /root/backup/nginx &> /dev/null
cp -r /home/vps/public_html /root/backup/public_html &> /dev/null
cp -r /etc/cron.d /root/backup/cron.d &> /dev/null
cp /etc/crontab /root/backup/crontab &> /dev/null

# Compress backup
cd /root
zip -r $IP.zip backup > /dev/null 2>&1

# Send to Telegram
curl -s -F chat_id="$id_chat" \
     -F document=@"$IP.zip" \
     -F caption="✅ Backup Success!
📅 Date       : $date
🌐 Domain     : $domain
📡 IP VPS     : $IP" \
     https://api.telegram.org/bot$token/sendDocument > /dev/null

# Tunggu agar update Telegram masuk
sleep 3

# Ambil file_id dari getUpdates terbaru
file_id=$(curl -s "https://api.telegram.org/bot${token}/getUpdates" | jq -r '.result | map(select(.message.document.file_name | endswith(".zip"))) | last | .message.document.file_id')

# Simpan file_id ke file (untuk restore)
if [[ -n "$file_id" && "$file_id" != "null" ]]; then
    echo "$file_id" > /root/file_id.txt
    echo -e "[ ${GREEN}INFO${NC} ] file_id berhasil diambil dan disimpan."
else
    echo -e "[ ${RED}ERROR${NC} ] Gagal mengambil file_id dari getUpdates."
fi

# Hapus file sementara
rm -rf /root/backup &> /dev/null
rm -rf /root/user-backup &> /dev/null
rm -f /root/$NameUser.zip &> /dev/null
rm -f /root/$IP.zip &> /dev/null

echo "✅ Silakan cek channel atau grup Anda untuk file backup."
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

function autobckpbot(){
clear
cat > /etc/cron.d/bckp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /usr/bin/bckp
END
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

echo -e "${BIGreen}Auto Backup Start  Daily 05.00 AM${NC} "
echo -e ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
}

function restore(){
    clear
    echo -e "${INFO} Masukkan token Bot Telegram Anda:"
    read -rp "Token Bot : " token
    echo -e "${INFO} Masukkan Password File ZIP (jika ada, tekan Enter jika tidak ada):"
    read -rp "Password  : " zip_pass

    # Cek file_id tersimpan
    if [[ ! -f /root/file_id.txt ]]; then
        echo -e "${RED}file_id tidak ditemukan! Lakukan backup terlebih dahulu.${NC}"
        exit 1
    fi

    file_id=$(cat /root/file_id.txt)

    echo -e "${INFO} Mendapatkan file_path dari Telegram..."

    # Ambil file_path dari file_id
    file_path=$(curl -s "https://api.telegram.org/bot$token/getFile?file_id=$file_id" | jq -r '.result.file_path')

    if [[ -z "$file_path" || "$file_path" == "null" ]]; then
        echo -e "${RED}Gagal mendapatkan file_path dari Telegram. Periksa token dan file_id.${NC}"
        exit 1
    fi

    echo -e "${INFO} Mengunduh file backup..."
    curl -s -o /root/backup.zip "https://api.telegram.org/file/bot$token/$file_path"

    if [[ ! -f /root/backup.zip ]]; then
        echo -e "${RED}Gagal mengunduh file dari Telegram.${NC}"
        exit 1
    fi

    echo -e "${INFO} Mengekstrak data backup..."
    mkdir -p /root/backup
    unzip -P "$zip_pass" /root/backup.zip -d /root/backup > /dev/null 2>&1

    echo -e "${INFO} Memulai proses restore..."
    cp /root/backup/passwd /etc/ &> /dev/null
    cp /root/backup/group /etc/ &> /dev/null
    cp /root/backup/shadow /etc/ &> /dev/null
    cp /root/backup/gshadow /etc/ &> /dev/null
    cp /root/backup/chap-secrets /etc/ppp/ &> /dev/null
    cp /root/backup/passwd1 /etc/ipsec.d/passwd &> /dev/null
    cp /root/backup/ss.conf /etc/shadowsocks-libev/ss.conf &> /dev/null
    cp -r /root/backup/scrz-prem /var/lib/ &> /dev/null
    cp -r /root/backup/.acme.sh /root/ &> /dev/null
    cp -r /root/backup/xray /etc/ &> /dev/null
    cp -r /root/backup/nginx /etc/nginx/ &> /dev/null
    cp -r /root/backup/public_html /home/vps/ &> /dev/null
    cp /root/backup/crontab /etc/ &> /dev/null
    cp -r /root/backup/cron.d /etc/ &> /dev/null

    echo -e "${INFO} Restore selesai."
    rm -f /root/backup.zip
    rm -rf /root/backup

    read -n 1 -s -r -p "Press any key to back on menu"
    menu
}

clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "       ${BIWhite}${UWhite}Backup / Restore ${NC}"
echo -e ""
echo -e "     ${BICyan}[${BIWhite}1${BICyan}] backup-bot   "
echo -e "     ${BICyan}[${BIWhite}2${BICyan}] Auto Backup   "
echo -e "     ${BICyan}[${BIWhite}3${BICyan}] Restore-Bot   "
echo -e "     ${BICyan}[${BIWhite}4${BICyan}] Manual Restore  "
#echo -e "     ${BICyan}[${BIWhite}4${BICyan}] Check User XRAY     "
echo -e " ${BICyan}└─────────────────────────────────────────────────────┘${NC}"
echo -e "     ${BIYellow}Press x or [ Ctrl+C ] • To-${BIWhite}Exit${NC}"
echo ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; bckpbot ;;
2) clear ; autobckpbot ;;
3) clear ; restore ;;
4) clear ; manualrestore;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
