#!/bin/bash

# Función para instalar Hack Nerd Font
function instalar_hack_nerd_font() {
 echo "Instalando Hack Nerd Font..."
 mkdir -p ~/.fonts
 wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O ~/.fonts/Hack.zip
 unzip ~/.fonts/Hack.zip -d ~/.fonts
 fc-cache -f
 echo "Hack Nerd Font instalado correctamente."
}

# Función para detectar el tipo de arquitectura y sistema operativo
function detectar_arquitectura_so() {
 if [[ $(command -v lsb_release) ]]; then
  SO=$(lsb_release -si)
  ARQUITECTURA=$(lsb_release -sc)
 elif [[ $(command -v uname) ]]; then
  SO=$(uname -s)
  ARQUITECTURA=$(uname -m)
 fi

 if [[ $SO == "Debian" ]]; then
  EXT_PAQUETES=".deb"
 elif [[ $SO == "Arch" ]]; then
  EXT_PAQUETES=".pkg.tar.zst"
 fi

 echo "Sistema operativo: $SO"
 echo "Arquitectura: $ARQUITECTURA"
 echo "Extensión de paquetes: $EXT_PAQUETES"
}

# Función para descargar e instalar LSD
function instalar_lsd() {
 echo "Descargando e instalando LSD..."
 VERSION_LSD=$(curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
 URL_DESCARGA_LSD="https://github.com/Peltoche/lsd/releases/download/$VERSION_LSD/lsd-$VERSION_LSD-$ARQUITECTURA$EXT_PAQUETES"
 wget $URL_DESCARGA_LSD -O /tmp/lsd
 sudo install /tmp/lsd /usr/local/bin/lsd
 rm /tmp/lsd
 echo "LSD instalado correctamente."
}

# Función para descargar e instalar BAT
function instalar_bat() {
 echo "Descargando e instalando BAT..."
 VERSION_BAT=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
 URL_DESCARGA_BAT="https://github.com/sharkdp/bat/releases/download/$VERSION_BAT/bat-$VERSION_BAT-$ARQUITECTURA$EXT_PAQUETES"
 wget $URL_DESCARGA_BAT -O /tmp/bat
 sudo install /tmp/bat /usr/local/bin/bat
 rm /tmp/bat
 echo "BAT instalado correctamente."
}

# Función para instalar zsh
function instalar_zsh() {
 echo "Instalando zsh..."
 sudo apt install zsh
 echo "zsh instalado correctamente."
}

function instalar_ohmyposh() {
  echo "Instalando Oh My Posh..."

  # Obtener la variable $PATH del usuario
  path_usuario=$PATH

  # Encontrar el primer directorio en el que el usuario puede ejecutar archivos .sh
  directorio_instalacion=$(echo $path_usuario | tr ':' '\n' | while read dir; do if [ -w "$dir" ]; then echo "$dir"; break; fi; done)

  # Si no se encontró ningún directorio con permisos de escritura, usar el directorio home
  if [ -z "$directorio_instalacion" ]; then
    directorio_instalacion="$HOME"
  fi

  # Descargar e instalar Oh My Posh
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$directorio_instalacion"

  # Agregar la configuración de Oh My Posh al archivo .zshrc
  echo 'eval "$(oh-my-posh init zsh)"' >> ~/.zshrc

  # Reiniciar la shell zsh para que se apliquen los cambios
  exec zsh

  echo "Oh My Posh instalado correctamente."
}


# Función para cambiar la shell por defecto a zsh
function cambiar_shell_zsh() {
 echo "Cambiando la shell por defecto a zsh..."
 chsh -s $(which zsh)
 echo "Shell por defecto cambiada a zsh correctamente."
}

# Inicio del script

# Preguntar si tiene Debian o Arch
echo "¿Qué sistema operativo tienes? (Debian/Arch)"
read so

# Instalar Hack Nerd Font
instalar_hack_nerd_font

# Detectar el tipo de arquitectura y sistema operativo
detectar_arquitectura_so

# Si es Debian, instalar lsd y bat con apt
if [[ $SO == "Debian" ]]; then
 sudo apt install lsd bat
else
 # Si es Arch, instalar lsd y bat con pacman
 sudo pacman -S lsd bat
fi

# Descargar e instalar zsh
instalar_zsh

# Cambiar la shell por defecto a zsh
cambiar_shell_zsh

# Instalar ohmyposh
instalar_ohmyposh

echo "Personalización completada correctamente."
