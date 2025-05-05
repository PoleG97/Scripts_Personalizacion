#!/bin/bash

# Archivo donde se guardarán las extensiones
OUTPUT_FILE="install_extensions.sh"

# Encabezado del script de salida
echo "#!/bin/bash" > $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Listar las extensiones y añadir comandos de instalación al archivo de salida
for uuid in $(gnome-extensions list); do
    echo "Instalando la extensión: $uuid"
    echo "gnome-extensions install $uuid" >> $OUTPUT_FILE
done

# Hacer el script resultante ejecutable
chmod +x $OUTPUT_FILE

echo "Script generado: $OUTPUT_FILE"
