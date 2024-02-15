#!/bin/bash

### Quiero que me generes script en bash para automatizar mi despliegue de mi personalización en un entorno debian. Mi personalización requiere lo siguiente
### 
### - instalar en la fuente "hack nerd font"
### - Preguntarme si tengo debian o arch
### - Detectar el tipo de tipo el paquetes que puedo instalar en él "amd64", "arm64", "i686"... en mi sistema (teniendo en cuenta también si es arch o debian para saber que extensión de paquetes debe tener en cuenta)
### - Con ello determinado, quiero que se descarguen los paquetes más recientes de los programas "lsd" (https://github.com/lsd-rs/lsd/releases) y "bat" (https://github.com/sharkdp/bat/releases)
### - Instalar esos programas en el sistema teniedno en cuenta si he elegido arch o debian en los primeros pasos
### - descargar zhs si es necesario
### - cambiar la shell que esté por defecto a zsh 
### - instalar ohmyposh


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
  if [[ <span class="math-inline">\(command \-v lsb\_release\) \]\]; then
SO\=</span>(lsb_release -si)
    ARQUITECTURA=$(lsb_release -sc)
  elif [[ <span class="math-inline">\(command \-v uname\) \]\]; then
SO\=</span>(uname -s)
    ARQUITECTURA=$(uname -m)
  fi

  if [[ $SO == "Debian" ]]; then
    EXT_PAQUETES=".deb"
  elif [[ $SO == "Arch" ]]; then
    EXT_PAQUETES=".pkg.tar.zst"
  fi

  echo "Sistema operativo: $SO"
  echo "Arquitectura: $ARQUITECTURA"
  echo "Extensión de paquetes: <span class="math-inline">EXT\_PAQUETES"
\}
\# Función para descargar e instalar LSD
function instalar\_lsd\(\) \{
echo "Descargando e instalando LSD\.\.\."
VERSION\_LSD\=</span>(curl -s https://api.github.com/repos/lsd-rs/lsd/releases/latest | jq -r '.tag_name')
  URL_DESCARGA_LSD="https://github.com/lsd-rs/lsd/releases/download/$VERSION_LSD/lsd-$VERSION_LSD-$ARQUITECTURA$EXT_PAQUETES"
  wget <span class="math-inline">URL\_DESCARGA\_LSD \-O /tmp/lsd
sudo install /tmp/lsd /usr/local/bin/lsd
rm /tmp/lsd
echo "LSD instalado correctamente\."
\}
\# Función para descargar e instalar BAT
function instalar\_bat\(\) \{
echo "Descargando e instalando BAT\.\.\."
VERSION\_BAT\=</span>(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | jq -r '.tag_name')
  URL_DESCARGA_BAT="https://github.com/sharkdp/bat/releases/download/$VERSION_BAT/bat-$VERSION_BAT-$ARQUITECTURA$EXT_PAQUETES"
  wget <span class="math-inline">URL\_DESCARGA\_BAT \-O /tmp/bat
sudo install /tmp/bat /usr/local/bin/bat
rm /tmp/bat
echo "BAT instalado correctamente\."
\}
\# Función para instalar zsh y oh\-my\-zsh
function instalar\_zsh\_ohmyzsh\(\) \{
echo "Instalando zsh y <0\>oh\-my\-zsh\.\.\."
sudo apt install zsh
sh \-c "</span>(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "zsh y oh-my-zsh instalados correctamente."
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

# Descargar e instalar zsh y oh-my-zsh
instalar_zsh_ohmyzsh

# Cambiar la shell por defecto a zsh
cambiar_shell_zsh

echo "Personalización completada correctamente."
