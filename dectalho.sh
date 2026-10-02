#!/bin/bash

options=(
    "DECTALHO-FIREFOX"
    "DECTALHO-CHROME"
    "Funcionalidade"
    "Sair"
)

selected=0

# =========================
# CORES
# =========================
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'

draw_menu() {
clear
echo -e "${GREEN}"
cat << "EOF"

█████   ███████  █████  ███████   ███   ██      ██   ██  █████ 
██  ██  ██      ██   ██   ███    ██ ██  ██      ██   ██ ██   ██
██   ██ █████   ██        ███   ███████ ██      ███████ ██   ██
██  ██  ██      ██   ██   ███   ██   ██ ██      ██   ██ ██   ██
█████   ███████  █████    ███   ██   ██ ███████ ██   ██  █████

         GERADOR DE ATALHOS PARA APLICATIVOS WEB
EOF
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}      MENU ${NC} "
echo
    for i in "${!options[@]}"; do
        if [ "$i" -eq "$selected" ]; then
            echo "➜ ${options[$i]}"
        else
            echo "  ${options[$i]}"
        fi
    done
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

while true; do
    draw_menu

    read -rsn1 key

    if [[ $key == $'\x1b' ]]; then
        read -rsn2 key

        case $key in
            "[A")
                ((selected--))
                [ $selected -lt 0 ] && selected=$((${#options[@]} - 1))
                ;;
            "[B")
                ((selected++))
                [ $selected -ge ${#options[@]} ] && selected=0
                ;;
        esac

    elif [[ $key == "" ]]; then
        break
    fi
done

clear

case "${options[$selected]}" in

    "DECTALHO-FIREFOX")
        echo "Executando DECTALHO-FIREFOX..."
        chmod +x ./dectalho-linux/criar-atalho-firefox.sh && ./dectalho-linux/criar-atalho-firefox.sh
        ;;

    "DECTALHO-CHROME")
        echo "Executando DECTALHO-CHROME..."
        chmod +x ./dectalho-linux/chrome/criar-atalho-app.sh && ./dectalho-linux/chrome/criar-atalho-app.sh
        ;;

    "Funcionalidade")
        echo "Funcionalidade..."
        echo ""
        echo "https://github.com/davserv/DecTalho"
        echo ""
        ;;

    "Sair")
        exit 0
        ;;
esac