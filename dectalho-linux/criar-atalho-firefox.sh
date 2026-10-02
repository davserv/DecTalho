#!/usr/bin/env bash
# Uso: ./criar-atalho-firefox.sh "Nome" "URL" [icone.png] [janela|app|kiosk]

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

set -euo pipefail

if [ $# -ge 2 ]; then
    NOME="$1"; URL="$2"; ICONO="${3:-}"; MODO="${4:-janela}"
else
    read -rp "NOME DO ATALHO: " NOME
    read -rp "ENDEREÇO DO SITE: " URL
    read -rp "ÍCONE (CAMINHO/URL, VAZIO=AUTOMÁTICO): " ICONO
    read -rp "MODO [JANELA/APP/KIOSK] (ENTER=JANELA): " MODO
fi
MODO="${MODO:-janela}"
case "$MODO" in janela|app|kiosk) ;; *) MODO=janela ;; esac
[[ "$URL" =~ ^https?:// ]] || URL="https://$URL"

# --- localiza o Firefox ---
FF=""
for b in firefox firefox-esr firefox-bin; do
    command -v "$b" >/dev/null 2>&1 && { FF="$b"; break; }
done
if [ -z "$FF" ] && command -v flatpak >/dev/null 2>&1 && \
   flatpak info org.mozilla.firefox >/dev/null 2>&1; then
    FF="flatpak run org.mozilla.firefox"
fi
[ -z "$FF" ] && { echo "ERRO: Firefox nao encontrado."; exit 1; }

SLUG=$(echo "$NOME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g; s/-\+/-/g; s/^-//; s/-$//')
PERFIL="app-$SLUG"

# --- icone (favicon automatico se nao passar um) ---
ICO_DIR="$HOME/.local/share/icons/atalhos-app"; mkdir -p "$ICO_DIR"
ICO_PATH="$ICO_DIR/$SLUG.png"
eh_imagem() { [ -s "$1" ] && head -c4 "$1" | od -An -tx1 | grep -qE "00 00 01 00|89 50 4e 47"; }
TEM_ICONE=0
if [ -n "$ICONO" ]; then
    if [[ "$ICONO" =~ ^https?:// ]]; then
        curl -fsSL --max-time 15 "$ICONO" -o "$ICO_PATH" 2>/dev/null && eh_imagem "$ICO_PATH" && TEM_ICONE=1
    elif [ -f "$ICONO" ] && eh_imagem "$ICONO"; then
        cp "$ICONO" "$ICO_PATH"; TEM_ICONE=1
    fi
else
    DOMINIO=$(echo "$URL" | sed -E 's#^[a-zA-Z]+://##; s#[/:].*##')
    TMP=$(mktemp)
    for u in "$URL/favicon.ico" \
             "https://icons.duckduckgo.com/ip3/$DOMINIO.ico" \
             "https://www.google.com/s2/favicons?domain=$DOMINIO&sz=64"; do
        if curl -fsSL --max-time 10 "$u" -o "$TMP" 2>/dev/null && eh_imagem "$TMP"; then
            mv "$TMP" "$ICO_PATH"; TEM_ICONE=1; break
        fi
    done
    rm -f "$TMP"
fi
[ "$TEM_ICONE" -eq 0 ] && rm -f "$ICO_PATH" && echo "Aviso: icone nao encontrado - usando o do Firefox."

# --- perfil dedicado (cria so se nao existir) ---
EXISTE=0
for ROOT in "$HOME/.mozilla/firefox" \
            "$HOME/snap/firefox/common/.mozilla/firefox" \
            "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"; do
    grep -qs "Name=$PERFIL" "$ROOT/profiles.ini" && { EXISTE=1; break; }
done
[ "$EXISTE" -eq 0 ] && $FF -CreateProfile "$PERFIL" >/dev/null 2>&1 || true

PDIR=""
for ROOT in "$HOME/.mozilla/firefox" \
            "$HOME/snap/firefox/common/.mozilla/firefox" \
            "$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"; do
    [ -f "$ROOT/profiles.ini" ] || continue
    P=$(awk -F= -v p="$PERFIL" '/^\[/{n=0} /^Name=/{n=($0=="Name="p)} n&&/^Path=/{print $2; exit}' "$ROOT/profiles.ini")
    if [ -n "$P" ]; then
        case "$P" in /*) PDIR="$P" ;; *) PDIR="$ROOT/$P" ;; esac
        break
    fi
done

# --- preferencias do perfil (sempre) + esconder barras (modo app) ---
if [ -n "$PDIR" ] && [ -d "$PDIR" ]; then
    cat > "$PDIR/user.js" <<'EOF'
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.warnOnQuit", false);
user_pref("datareporting.policy.firstRunURL", "");
EOF
    if [ "$MODO" = "app" ]; then
        mkdir -p "$PDIR/chrome"
        cat > "$PDIR/chrome/userChrome.css" <<'EOF'
#TabsToolbar, #toolbar-menubar, #PersonalToolbar, #nav-bar { visibility: collapse !important; }
EOF
    fi
fi

# --- cria o .desktop ---
APPS_DIR="$HOME/.local/share/applications"; mkdir -p "$APPS_DIR"
KIOSK=""; [ "$MODO" = "kiosk" ] && KIOSK="--kiosk"
ICON_ENTRY="$FF"; [ "$TEM_ICONE" -eq 1 ] && ICON_ENTRY="$ICO_PATH"

cat > "$APPS_DIR/$SLUG.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$NOME
Comment=Firefox: $URL
Exec=$FF -P "$PERFIL" $KIOSK "$URL"
Icon=$ICON_ENTRY
Terminal=false
Categories=Network;
EOF
chmod +x "$APPS_DIR/$SLUG.desktop"

DESKTOP_DIR=""
command -v xdg-user-dir >/dev/null 2>&1 && DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || true)
[ -z "$DESKTOP_DIR" ] && [ -d "$HOME/Desktop" ] && DESKTOP_DIR="$HOME/Desktop"
if [ -n "$DESKTOP_DIR" ] && [ -d "$DESKTOP_DIR" ]; then
    cp "$APPS_DIR/$SLUG.desktop" "$DESKTOP_DIR/"
    chmod +x "$DESKTOP_DIR/$SLUG.desktop"
    command -v gio >/dev/null 2>&1 && gio set "$DESKTOP_DIR/$SLUG.desktop" metadata::trusted true 2>/dev/null || true
fi
update-desktop-database "$APPS_DIR" 2>/dev/null || true

echo "Atalho '$NOME' criado! (modo: $MODO | perfil: $PERFIL)"