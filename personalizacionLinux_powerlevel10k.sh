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

# Detectar arquitectura
ARCH=$(uname -m)
echo "Arquitectura detectada: $ARCH"

# Instalar ZSH
echo "Instalando ZSH..."
if [ "$OS" == "debian" ]; then
    sudo apt update && sudo apt install -y zsh git curl
elif [ "$OS" == "arch" ]; then
    sudo pacman -Syu --noconfirm zsh git curl
fi

# Cambiar el shell por defecto a ZSH
echo "Cambiando el intérprete por defecto a ZSH..."
chsh -s $(which zsh)

# Instalar PowerLevel10k
echo "Instalando tema PowerLevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
echo 'source ~/.powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# Instalar lsd
echo "Instalando lsd..."
LSD_URL="https://github.com/lsd-rs/lsd/releases/latest/download/lsd-musl_${ARCH}.tar.gz"
LSD_TMP_DIR=$(mktemp -d)
curl -sL $LSD_URL -o $LSD_TMP_DIR/lsd.tar.gz
tar -xzf $LSD_TMP_DIR/lsd.tar.gz -C $LSD_TMP_DIR
sudo mv $LSD_TMP_DIR/lsd /usr/local/bin/lsd
rm -rf $LSD_TMP_DIR

# Instalar bat
echo "Instalando bat..."
if [ "$OS" == "debian" ]; then
    sudo apt install -y bat
elif [ "$OS" == "arch" ]; then
    sudo pacman -S --noconfirm bat
fi

# Instalar complementos zsh-autosuggestions y zsh-syntax-highlighting
echo "Instalando complementos zsh-autosuggestions y zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# Agregar configuración al .zshrc desde el archivo externo
echo "Agregando configuración al .zshrc desde archivo externo..."
CONFIG_FILE="./ajustes_usuario.txt"
if [ -f "$CONFIG_FILE" ]; then
    cat "$CONFIG_FILE" >> ~/.zshrc
else
    echo "Archivo de configuración $CONFIG_FILE no encontrado."
    exit 1
fi

echo "Instalación y configuración completadas. Por favor, reinicia tu terminal para aplicar los cambios."
