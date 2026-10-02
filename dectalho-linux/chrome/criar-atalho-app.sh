#!/usr/bin/env bash
# criar-atalho-app.sh - cria atalho "modo aplicativo" no Linux (Chromium/Chrome/Edge/Brave/Vivaldi)
# Uso: ./criar-atalho-app.sh "Nome" "URL" [icone.png] [navegador]

set -euo pipefail

# ---------- modo interativo se nao passar argumentos ----------
if [ $# -lt 2 ]; then
    read -rp "Nome do atalho: " NOME
    read -rp "Endereco do site: " URL
else
    NOME="$1"; URL="$2"
fi
ICONO="${3:-}"
NAVEGADOR="${4:-auto}"

# ---------- valida URL ----------
[[ "$URL" =~ ^https?:// ]] || URL="https://$URL"

# ---------- detecta navegador (Firefox nao suporta --app) ----------
ENCONTRADO=""
if [ "$NAVEGADOR" = "auto" ]; then
    for b in google-chrome-stable google-chrome microsoft-edge microsoft-edge-stable \
             brave-browser brave chromium chromium-browser vivaldi-stable vivaldi; do
        if command -v "$b" >/dev/null 2>&1; then ENCONTRADO="$b"; break; fi
    done
else
    command -v "$NAVEGADOR" >/dev/null 2>&1 && ENCONTRADO="$NAVEGADOR"
fi
if [ -z "$ENCONTRADO" ]; then
    echo "ERRO: nenhum navegador Chromium encontrado (Chrome, Edge, Brave, Chromium ou Vivaldi)."
    exit 1
fi

# ---------- nome do arquivo (slug) ----------
SLUG=$(echo "$NOME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_-]/-/g; s/-\+/-/g; s/^-//; s/-$//')

# ---------- pasta de icones do usuario ----------
ICO_DIR="$HOME/.local/share/icons/atalhos-app"
mkdir -p "$ICO_DIR"
ICO_PATH="$ICO_DIR/$SLUG.png"

# ---------- funcoes de icone ----------
eh_imagem() {
    [ -s "$1" ] || return 1
    head -c4 "$1" | od -An -tx1 | grep -qE "00 00 01 00|89 50 4e 47" && return 0
    return 1
}

obter_favicon() {
    local dominio tmp
    dominio=$(echo "$URL" | sed -E 's#^[a-zA-Z]+://##; s#[/:].*##')
    tmp=$(mktemp)
    for u in "$URL/favicon.ico" \
             "https://icons.duckduckgo.com/ip3/$dominio.ico" \
             "https://www.google.com/s2/favicons?domain=$dominio&sz=64"; do
        curl -fsSL --max-time 10 "$u" -o "$tmp" 2>/dev/null || continue
        if eh_imagem "$tmp"; then mv "$tmp" "$ICO_PATH"; return 0; fi
    done
    rm -f "$tmp"
    return 1
}

# ---------- obtem o icone ----------
TEM_ICONE=0
if [ -n "$ICONO" ]; then
    if [[ "$ICONO" =~ ^https?:// ]]; then
        curl -fsSL --max-time 15 "$ICONO" -o "$ICO_PATH" && TEM_ICONE=1
    elif [ -f "$ICONO" ]; then
        cp "$ICONO" "$ICO_PATH" && TEM_ICONE=1
    fi
else
    obter_favicon && TEM_ICONE=1
fi

if [ "$TEM_ICONE" -eq 0 ]; then
    echo "Aviso: icone nao encontrado - usando o padrao do navegador."
    ICO_PATH="$ENCONTRADO"
fi

# ---------- cria o .desktop ----------
APPS_DIR="$HOME/.local/share/applications"
mkdir -p "$APPS_DIR"

cat > "$APPS_DIR/$SLUG.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$NOME
Comment=Modo aplicativo: $URL
Exec=$ENCONTRADO --class="$SLUG" --app="$URL"
Icon=$ICO_PATH
Terminal=false
Categories=Network;
StartupWMClass=$SLUG
EOF
chmod +x "$APPS_DIR/$SLUG.desktop"

# ---------- copia para a Area de Trabalho (se existir) ----------
DESKTOP_DIR=""
command -v xdg-user-dir >/dev/null 2>&1 && DESKTOP_DIR=$(xdg-user-dir DESKTOP 2>/dev/null || true)
[ -z "$DESKTOP_DIR" ] && [ -d "$HOME/Desktop" ] && DESKTOP_DIR="$HOME/Desktop"

if [ -n "$DESKTOP_DIR" ] && [ -d "$DESKTOP_DIR" ]; then
    cp "$APPS_DIR/$SLUG.desktop" "$DESKTOP_DIR/"
    chmod +x "$DESKTOP_DIR/$SLUG.desktop"
    # GNOME: marca como confiavel para nao pedir "Permitir iniciar"
    command -v gio >/dev/null 2>&1 && \
        gio set "$DESKTOP_DIR/$SLUG.desktop" metadata::trusted true 2>/dev/null || true
fi

update-desktop-database "$APPS_DIR" 2>/dev/null || true

echo "Atalho '$NOME' criado!"
echo "  Navegador: $ENCONTRADO"
echo "  Menu de aplicativos: $APPS_DIR/$SLUG.desktop"
[ -n "$DESKTOP_DIR" ] && [ -d "$DESKTOP_DIR" ] && echo "  Area de trabalho: $DESKTOP_DIR/$SLUG.desktop"
[ "$TEM_ICONE" -eq 1 ] && echo "  Icone: $ICO_PATH"