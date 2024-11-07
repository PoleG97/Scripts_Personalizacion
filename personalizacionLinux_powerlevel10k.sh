#!/bin/bash

# Detectar si el sistema es Debian o Arch basado
if [ -f /etc/debian_version ]; then
    OS="debian"
    echo "Sistema operativo detectado: Debian/Ubuntu"
elif [ -f /etc/arch-release ]; then
    OS="arch"
    echo "Sistema operativo detectado: Arch Linux"
else
    echo "Sistema operativo no soportado por este script."
    exit 1
fi

# Crear carpeta de Descargas si no existe
DOWNLOAD_DIR="$HOME/Downloads"
if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Creando carpeta de Descargas en $DOWNLOAD_DIR..."
    mkdir -p "$DOWNLOAD_DIR"
fi

# Detectar arquitectura
ARCH=$(uname -m)
echo "Arquitectura detectada: $ARCH"

# Descargar e instalar Hack Nerd Font
echo "Instalando Hack Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
wget -qO "$DOWNLOAD_DIR/Hack.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip"
unzip -o "$DOWNLOAD_DIR/Hack.zip" -d "$FONT_DIR"
fc-cache -fv

# Instalar ZSH
echo "Instalando ZSH..."
if [ "$OS" == "debian" ]; then
    sudo apt update && sudo apt install -y zsh git curl wget unzip
elif [ "$OS" == "arch" ]; then
    sudo pacman -Syu --noconfirm zsh git curl wget unzip
fi

# Cambiar el shell por defecto a ZSH
echo "Cambiando el intérprete por defecto a ZSH..."
chsh -s $(which zsh)

# Instalar PowerLevel10k
echo "Instalando tema PowerLevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# TODO : Mejorar esta mierda de la descarga e instalación de LSD y BAT, es una basura, acabaré haciéndolo a mano porque esto petará
# Descargar e instalar lsd
echo "Instalando lsd..."
if [[ "$ARCH" == "x86_64" ]]; then
    LSD_URL="https://github.com/lsd-rs/lsd/releases/latest/download/lsd-0.23.1-x86_64-unknown-linux-musl.tar.gz"
elif [[ "$ARCH" == "i686" ]]; then
    LSD_URL="https://github.com/lsd-rs/lsd/releases/latest/download/lsd-0.23.1-i686-unknown-linux-musl.tar.gz"
else
    echo "Arquitectura no soportada para lsd."
    exit 1
fi
LSD_TMP_DIR=$(mktemp -d)
wget -qO "$LSD_TMP_DIR/lsd.tar.gz" "$LSD_URL"
tar -xzf "$LSD_TMP_DIR/lsd.tar.gz" -C "$LSD_TMP_DIR"
sudo mv "$LSD_TMP_DIR/lsd-0.23.1-x86_64-unknown-linux-musl/lsd" /usr/local/bin/lsd
rm -rf "$LSD_TMP_DIR"

# Descargar e instalar bat desde GitHub releases
echo "Instalando bat..."
if [[ "$ARCH" == "x86_64" ]]; then
    BAT_URL="https://github.com/sharkdp/bat/releases/latest/download/bat-v0.23.0-x86_64-unknown-linux-gnu.tar.gz"
elif [[ "$ARCH" == "i686" ]]; then
    BAT_URL="https://github.com/sharkdp/bat/releases/latest/download/bat-v0.23.0-i686-unknown-linux-gnu.tar.gz"
else
    echo "Arquitectura no soportada para bat."
    exit 1
fi
BAT_TMP_DIR=$(mktemp -d)
wget -qO "$BAT_TMP_DIR/bat.tar.gz" "$BAT_URL"
tar -xzf "$BAT_TMP_DIR/bat.tar.gz" -C "$BAT_TMP_DIR"
sudo mv "$BAT_TMP_DIR/bat-v0.23.0-x86_64-unknown-linux-gnu/bat" /usr/local/bin/bat
rm -rf "$BAT_TMP_DIR"

# Instalar complementos zsh-autosuggestions y zsh-syntax-highlighting
echo "Instalando complementos zsh-autosuggestions y zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# Agregar configuración al .zshrc desde el archivo externo
echo "Agregando configuración al .zshrc desde archivo externo..."
CONFIG_FILE="./zsh_config_content.txt"
if [ -f "$CONFIG_FILE" ]; then
    cat "$CONFIG_FILE" >> ~/.zshrc
else
    echo "Archivo de configuración $CONFIG_FILE no encontrado."
    exit 1
fi

echo "Instalación y configuración completadas. Por favor, reinicia tu terminal para aplicar los cambios."
