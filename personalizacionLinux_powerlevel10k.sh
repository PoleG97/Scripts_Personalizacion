#!/bin/bash

# Función para instalar Hack Nerd Font
function instalar_hack_nerd_font() {
  echo "Instalando Hack Nerd Font..."
  mkdir -p ~/.fonts
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -O ~/.fonts/Hack.zip
  unzip -o ~/.fonts/Hack.zip -d ~/.fonts
  fc-cache -f
  echo "Hack Nerd Font instalado correctamente."
}

# Función para detectar el tipo de arquitectura y sistema operativo
function detectar_arquitectura_so() {
  if [[ $(command -v lsb_release) ]]; then
    SO=$(lsb_release -si)
    ARQUITECTURA=$(uname -m)
  elif [[ $(command -v uname) ]]; then
    SO=$(uname -s)
    ARQUITECTURA=$(uname -m)
  fi

  if [[ $SO == "Debian" ]]; then
    EXT_PAQUETES=".deb"
  elif [[ $SO == "Arch" ]]; then
    EXT_PAQUETES=".pkg.tar.zst"
  else
    echo "Sistema operativo no soportado."
    exit 1
  fi

  echo "Sistema operativo: $SO"
  echo "Arquitectura: $ARQUITECTURA"
  echo "Extensión de paquetes: $EXT_PAQUETES"
}

# Función para encontrar el directorio de descargas
function encontrar_directorio_descargas() {
  if [[ -d "$HOME/Descargas" ]]; then
    DIRECTORIO_DESCARGAS="$HOME/Descargas"
  elif [[ -d "$HOME/Downloads" ]]; then
    DIRECTORIO_DESCARGAS="$HOME/Downloads"
  else
    echo "No se encontró el directorio de descargas. Creando $HOME/Descargas."
    mkdir -p "$HOME/Descargas"
    DIRECTORIO_DESCARGAS="$HOME/Descargas"
  fi
  echo "Directorio de descargas: $DIRECTORIO_DESCARGAS"
}

# Función para descargar e instalar LSD
function instalar_lsd() {
  echo "Descargando e instalando LSD..."
  VERSION_LSD=$(curl -s https://api.github.com/repos/Peltoche/lsd/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  URL_DESCARGA_LSD="https://github.com/Peltoche/lsd/releases/download/$VERSION_LSD/lsd-$VERSION_LSD-$ARQUITECTURA$EXT_PAQUETES"
  wget $URL_DESCARGA_LSD -O "$DIRECTORIO_DESCARGAS/lsd$EXT_PAQUETES"
  sudo dpkg -i "$DIRECTORIO_DESCARGAS/lsd$EXT_PAQUETES"
  rm "$DIRECTORIO_DESCARGAS/lsd$EXT_PAQUETES"
  echo "LSD instalado correctamente."
}

# Función para descargar e instalar BAT
function instalar_bat() {
  echo "Descargando e instalando BAT..."
  VERSION_BAT=$(curl -s https://api.github.com/repos/sharkdp/bat/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  URL_DESCARGA_BAT="https://github.com/sharkdp/bat/releases/download/$VERSION_BAT/bat-$VERSION_BAT-$ARQUITECTURA$EXT_PAQUETES"
  wget $URL_DESCARGA_BAT -O "$DIRECTORIO_DESCARGAS/bat$EXT_PAQUETES"
  sudo dpkg -i "$DIRECTORIO_DESCARGAS/bat$EXT_PAQUETES"
  rm "$DIRECTORIO_DESCARGAS/bat$EXT_PAQUETES"
  echo "BAT instalado correctamente."
}

# Función para instalar zsh
function instalar_zsh() {
  echo "Instalando zsh..."
  if [[ $SO == "Debian" ]]; then
    sudo apt update
    sudo apt install -y zsh
  elif [[ $SO == "Arch" ]]; then
    sudo pacman -Syu --noconfirm zsh
  fi
  echo "zsh instalado correctamente."
}

# Función para instalar oh-my-zsh
function instalar_oh_my_zsh() {
  echo "Instalando Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  echo "Oh My Zsh instalado correctamente."
}

# Función para instalar el tema powerlevel10k
function instalar_powerlevel10k() {
  echo "Instalando tema Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
  echo "Tema Powerlevel10k instalado correctamente."
}

# Función para cambiar la shell por defecto a zsh
function cambiar_shell_zsh() {
  echo "Cambiando la shell por defecto a zsh..."
  chsh -s $(which zsh)
  echo "Shell por defecto cambiada a zsh correctamente. Reinicia tu terminal para aplicar los cambios."
}

# Función para instalar plugins de zsh
function instalar_plugins_zsh() {
  echo "Instalando plugins de zsh..."
  ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

  # Instalar zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

  # Instalar zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

  # Agregar los plugins al archivo .zshrc
  sed -i "/plugins=(git/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting)" ~/.zshrc

  echo "Plugins de zsh instalados correctamente."
}

# Función para agregar alias y configuración al archivo .zshrc
function agregar_alias_configuracion_plugins() {
  local zshrc_file="$HOME/.zshrc"
  {
    echo "# Alias"
    echo "alias ll='lsd -lh --group-dirs=first'"
    echo "alias la='lsd -a --group-dirs=first'"
    echo "alias l='lsd --group-dirs=first'"
    echo "alias lla='lsd -lha --group-dirs=first'"
    echo "alias ls='lsd --group-dirs=first'"
    echo "alias cat='bat'"
    echo "alias catNonum='bat --style=plain'"
  } >> "$zshrc_file"

  echo "Alias y configuración de plugins agregados a $zshrc_file"
}

##############################################################

# Inicio del script

# Preguntar si tiene Debian o Arch
echo "¿Qué sistema operativo tienes? (Debian/Arch)"
read SO
SO=$(echo $SO | tr '[:upper:]' '[:lower:]')

# Instalar Hack Nerd Font
instalar_hack_nerd_font

# Detectar el tipo de arquitectura y sistema operativo
detectar_arquitectura_so

# Encontrar el directorio de descargas
encontrar_directorio_descargas

# Descargar e instalar LSD y BAT
instalar_lsd
instalar_bat

# Descargar e instalar zsh
instalar_zsh

# Instalar Oh My Zsh
instalar_oh_my_zsh

# Instalar tema powerlevel10k
instalar_powerlevel10k

# Cambiar la shell por defecto a zsh
cambiar_shell_zsh

# Instalar plugins de zsh
instalar_plugins_zsh

# Agregar alias y configuración al zshrc
agregar_alias_configuracion_plugins

exit

echo "Personalización completada correctamente. Reinicia tu terminal para aplicar todos los cambios."