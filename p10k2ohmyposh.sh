#!/bin/bash

# === FUNCIONES ===
detectar_os() {
  if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
  else
    echo "No se puede determinar el sistema operativo."
    exit 1
  fi
}

backup_archivo() {
  local archivo=$1
  local backup_dir="$HOME/.config/ohmyposh_backups"
  mkdir -p "$backup_dir"
  local backup_file="$backup_dir/$(basename "$archivo").bak"
  local i=1
  while [ -f "$backup_file" ]; do
    backup_file="$backup_dir/$(basename "$archivo").bak.$i"
    i=$((i+1))
  done
  cp "$archivo" "$backup_file"
  echo "✅ Backup de $archivo guardado como $backup_file"
}

comentar_p10k_zshrc() {
  local archivo="$HOME/.zshrc"
  echo "⚙️ Comentando configuraciones de Powerlevel10k en .zshrc..."

  sed -i.bak '/p10k-instant-prompt/ s/^/#/' "$archivo"
  sed -i '/powerlevel10k\.zsh-theme/ s/^/#/' "$archivo"

  rm -f ~/.cache/p10k-instant-prompt-*.zsh

  echo "✅ Comentarios aplicados y instant prompt eliminado si existía."
}

# === INICIO ===

clear
echo "💻 Script de personalización de terminal con Oh My Posh"
echo

# Comprobar el sistema operativo
detectar_os

# Preguntar sobre el shell
read -rp "¿Estás usando Zsh? (y/n): " usa_zsh
usa_zsh=${usa_zsh,,}

if [[ "$usa_zsh" == "y" ]]; then
  SHELLRC="$HOME/.zshrc"

  # Comprobación de Powerlevel10k
  read -rp "¿Tienes instalado Powerlevel10k? (y/n): " tiene_p10k
  tiene_p10k=${tiene_p10k,,}

  if [[ "$tiene_p10k" == "y" ]]; then
    echo "🔍 Buscando configuración de Powerlevel10k en $SHELLRC..."
    backup_archivo "$SHELLRC"
    comentar_p10k_zshrc
  fi

else
  SHELLRC="$HOME/.bashrc"
fi

# Crear backup del archivo shell RC
backup_archivo "$SHELLRC"

# Instalar Oh My Posh
echo "📦 Instalando Oh My Posh..."
if ! command -v oh-my-posh &>/dev/null; then
  sudo apt update && sudo apt install -y wget unzip
  wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O oh-my-posh
  sudo mv oh-my-posh /usr/local/bin/oh-my-posh
  sudo chmod +x /usr/local/bin/oh-my-posh
fi

# Descargar tema
echo "🎨 Descargando tema Gruvbox..."
mkdir -p ~/.poshthemes
wget -q https://github.com/JanDeDobbeleer/oh-my-posh/raw/main/themes/gruvbox.omp.json -O ~/.poshthemes/gruvbox.omp.json
chmod u+rw ~/.poshthemes/gruvbox.omp.json

# Añadir configuración al shell
if ! grep -q 'oh-my-posh init zsh' "$SHELLRC"; then
  echo 'eval "$(oh-my-posh init zsh --config ~/.poshthemes/gruvbox.omp.json)"' >> "$SHELLRC"
  echo "✅ Añadida la línea de configuración a $SHELLRC"
else
  echo "⚠️ Ya existe configuración de Oh My Posh en $SHELLRC"
fi

echo -e "\n✅ Instalación completada. Reinicia tu terminal o ejecuta: \033[1msource $SHELLRC\033[0m"
