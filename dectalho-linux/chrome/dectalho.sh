#!/bin/bash
set -e

clear

GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

echo -e "${GREEN}"
cat << "BANNER"

█████   ███████  █████  ███████   ███   ██      ██   ██  █████ 
██  ██  ██      ██   ██   ███    ██ ██  ██      ██   ██ ██   ██
██   ██ █████   ██        ███   ███████ ██      ███████ ██   ██
██  ██  ██      ██   ██   ███   ██   ██ ██      ██   ██ ██   ██
█████   ███████  █████    ███   ██   ██ ███████ ██   ██  █████

         GERADOR DE ATALHOS PARA APLICATIVOS WEB

BANNER

echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo

read -p "NOME DO ATALHO : " nomes
echo
read -p "ENDERECO DO SITE: " urls

echo
echo "Gerando..."
clear

chmod +x criar-atalho-app.sh
./criar-atalho-app.sh "$nomes" "$urls" "" app