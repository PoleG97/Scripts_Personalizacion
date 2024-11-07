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

# TODO : Mejorar esto, debe descargarse el programa aunque no esté en su apt
# Descargar e instalar lsd
echo "Instalando lsd..."
if [ "$OS" == "debian" ]; then
    sudo apt update && apt install lsd -y
elif [ "$OS" == "arch" ]; then
    pacman -S lsd
fi

# Descargar e instalar bat desde GitHub releases
echo "Instalando bat..."
if [ "$OS" == "debian" ]; then
    sudo apt update && apt install bat -y
elif [ "$OS" == "arch" ]; then
    pacman -S bat
fi

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
