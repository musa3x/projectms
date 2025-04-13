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

function bckpbot() {
    clear
    if [[ ! -f /root/botapi.conf ]]; then
        echo -e "${RED}Bot API belum dikonfigurasi. Jalankan 'setbotapi' dulu.${NC}"
        sleep 2
        menu
    fi

    source /root/botapi.conf
    IP=$(curl -sS ipv4.icanhazip.com)
    date=$(date +"%Y-%m-%d")
    domain=$(cat /etc/xray/domain)
    
    echo -e "[ ${GREEN}INFO${NC} ] Memproses backup..."
    mkdir -p /root/backup

    cp -r /root/.acme.sh /root/backup/ &>/dev/null
    cp /etc/passwd /root/backup/ &>/dev/null
    cp /etc/group /root/backup/ &>/dev/null
    cp -r /var/lib/scrz-prem/ /root/backup/scrz-prem &>/dev/null
    cp -r /etc/xray /root/backup/xray &>/dev/null
    cp -r /etc/nginx/conf.d /root/backup/nginx &>/dev/null
    cp -r /home/vps/public_html /root/backup/public_html &>/dev/null
    cp -r /etc/cron.d /root/backup/cron.d &>/dev/null
    cp /etc/crontab /root/backup/crontab &>/dev/null
    cd /root
    zip -r $IP.zip backup &>/dev/null

    curl -F chat_id="$chat_id" -F document=@"$IP.zip" -F caption="Backup Data
Domain : $domain
Date   : $date
IP     : $IP" "https://api.telegram.org/bot$token/sendDocument" &>/dev/null

    rm -fr /root/backup /root/user-backup /root/$IP.zip &>/dev/null

    echo -e "${INFO} Backup berhasil dikirim ke Telegram."
    read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
    menu-backup-tl
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
menu-backup-tl
}

function restore() {
    clear
    if [[ ! -f /root/botapi.conf ]]; then
        echo -e "${RED}Bot API belum dikonfigurasi. Jalankan 'setbotapi' dulu.${NC}"
        sleep 2
        menu
    fi

    source /root/botapi.conf
    echo -e "${INFO} Mengambil file terbaru dari Telegram..."

    updates=$(curl -s "https://api.telegram.org/bot$token/getUpdates")
    file_id=$(echo "$updates" | jq -r '.result | reverse | map(select(.message.document != null and .message.chat.id == '"$chat_id"'))[0].message.document.file_id')

    if [[ -z "$file_id" || "$file_id" == "null" ]]; then
        echo -e "${RED}Gagal mendapatkan file_id terbaru. Pastikan ada backup terkirim.${NC}"
        exit 1
    fi

    file_path=$(curl -s "https://api.telegram.org/bot$token/getFile?file_id=$file_id" | jq -r '.result.file_path')
    if [[ -z "$file_path" || "$file_path" == "null" ]]; then
        echo -e "${RED}Gagal mendapatkan file_path.${NC}"
        exit 1
    fi

    echo -e "${INFO} Mengunduh file..."
    curl -s -o /root/backup.zip "https://api.telegram.org/file/bot$token/$file_path"

    echo -e "${INFO} Masukkan password ZIP (jika ada):"
    read -rp "Password : " zip_pass
    mkdir -p /root/backup
    unzip -P "$zip_pass" /root/backup.zip -d /root/backup &>/dev/null

echo -e "${INFO} Memulai proses restore data..."
echo -e "${INFO} Restore file: /etc/passwd"
cp /root/backup/passwd /etc/ &>/dev/null
echo -e "${INFO} Restore file: /etc/group"
cp /root/backup/group /etc/ &>/dev/null
echo -e "${INFO} Restore file: /etc/shadow"
cp /root/backup/shadow /etc/ &>/dev/null
echo -e "${INFO} Restore file: /etc/gshadow"
cp /root/backup/gshadow /etc/ &>/dev/null
echo -e "${INFO} Restore file: /etc/ppp/chap-secrets"
cp /root/backup/chap-secrets /etc/ppp/ &>/dev/null
echo -e "${INFO} Restore file: /etc/ipsec.d/passwd"
cp /root/backup/passwd1 /etc/ipsec.d/passwd &>/dev/null
echo -e "${INFO} Restore file: /etc/shadowsocks-libev/ss.conf"
cp /root/backup/ss.conf /etc/shadowsocks-libev/ss.conf &>/dev/null
echo -e "${INFO} Restore folder: /var/lib/scrz-prem"
cp -r /root/backup/scrz-prem /var/lib/ &>/dev/null
echo -e "${INFO} Restore folder: /root/.acme.sh"
cp -r /root/backup/.acme.sh /root/ &>/dev/null
echo -e "${INFO} Restore folder: /etc/xray"
cp -r /root/backup/xray /etc/ &>/dev/null
echo -e "${INFO} Restore folder: /etc/nginx"
cp -r /root/backup/nginx /etc/nginx/ &>/dev/null
echo -e "${INFO} Restore folder: /home/vps/public_html"
cp -r /root/backup/public_html /home/vps/ &>/dev/null
echo -e "${INFO} Restore file: /etc/crontab"
cp /root/backup/crontab /etc/ &>/dev/null
echo -e "${INFO} Restore folder: /etc/cron.d"
cp -r /root/backup/cron.d /etc/ &>/dev/null
    rm -f /root/backup.zip
    rm -rf /root/backup

    echo -e "${GREEN}Restore selesai.${NC}"
curl -s -X POST "https://api.telegram.org/bot$token/sendMessage" \
    -d chat_id="$chat_id" \
    -d text="✅ *Restore Berhasil*
🗓️ Tanggal : $(date +"%Y-%m-%d %H:%M:%S")
📂 VPS IP : $(curl -s ipv4.icanhazip.com)
📁 Status : Data berhasil direstore!" \
    -d parse_mode="Markdown" > /dev/null

    read -n 1 -s -r -p "Tekan tombol apa saja untuk kembali ke menu"
    menu-backup-tl
}

function setbotapi() {
    clear
    echo -e "${INFO} Masukkan Token Bot Telegram Anda:"
    read -rp "Token : " token
    echo -e "${INFO} Masukkan Chat ID (bisa user ID, channel, atau grup):"
    read -rp "Chat ID: " chat_id

    cat > /root/botapi.conf <<-EOF
token=$token
chat_id=$chat_id
EOF

    echo -e "${GREEN}Data berhasil disimpan ke /root/botapi.conf${NC}"
    sleep 2
    menu-backup-tl
}

function viewbotapi() {
    clear
    if [[ -f /root/botapi.conf ]]; then
        echo -e "${INFO} Menampilkan konfigurasi Bot Telegram yang tersimpan:"
        source /root/botapi.conf
        echo -e "Token    : ${token}"
        echo -e "Chat ID  : ${chat_id}"
    else
        echo -e "${RED}Belum ada konfigurasi bot yang tersimpan.${NC}"
    fi

    echo ""
    read -n 1 -s -r -p "Tekan sembarang tombol untuk kembali ke menu"
    menu-backup-tl
}

clear
echo -e "${BICyan} ┌─────────────────────────────────────────────────────┐${NC}"
echo -e "       ${BIWhite}${UWhite}Backup / Restore ${NC}"
echo -e ""
echo -e "     ${BICyan}[${BIWhite}1${BICyan}] Backup-bot   "
echo -e "     ${BICyan}[${BIWhite}2${BICyan}] Auto Backup   "
echo -e "     ${BICyan}[${BIWhite}3${BICyan}] Restore-Bot   "
echo -e "     ${BICyan}[${BIWhite}4${BICyan}] Manual Restore  "
echo -e "     ${BICyan}[${BIWhite}5${BICyan}] Set Token  "
echo -e "     ${BICyan}[${BIWhite}6${BICyan}] lihat Token  "
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
5) clear ; setbotapi;;
6) clear ; viewbotapi;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac
