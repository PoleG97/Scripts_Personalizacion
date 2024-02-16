# Descargar e instalar KiCAD
$kicadVersion = "6.0.1"
$kicadUrl = "https://kicad.org/downloads/windows/" + $kicadVersion + "/kicad-x86_64-" + $kicadVersion + "-win64.exe"
$kicadInstallerPath = "$env:TEMP\kicad-installer.exe"

# Descargar el instalador de KiCAD
Invoke-WebRequest -Uri $kicadUrl -OutFile $kicadInstallerPath

# Ejecutar el instalador de KiCAD
Start-Process -FilePath $kicadInstallerPath -Wait

# Verificar si VSCode está instalado
$vscodePath = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\code.exe" -Name Path

# Si no está instalado, descargar e instalar VSCode
if ($vscodePath -eq $null) {
    $vscodeUrl = "https://code.visualstudio.com/sha/download/stable/VSCode-win32-x64.exe"
    $vscodeInstallerPath = "$env:TEMP\vscode-installer.exe"

    # Descargar el instalador de VSCode
    Invoke-WebRequest -Uri $vscodeUrl -OutFile $vscodeInstallerPath

    # Ejecutar el instalador de VSCode
    Start-Process -FilePath $vscodeInstallerPath -Wait
}

# Instalar la fuente Hack Nerd Font
$fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/Hack.zip"
$fontPath = "$env:UserProfile\AppData\Local\Fonts\Hack Nerd Font.ttf"

# Descargar la fuente Hack Nerd Font
Invoke-WebRequest -Uri $fontUrl -OutFile $fontPath

# Registrar la fuente en el sistema
Add-Type -AssemblyName PresentationCore
[System.Windows.Media.Fonts]::RegisterFontFile($fontPath)

# Mostrar mensaje de éxito
Write-Host "Tu ambiente de trabajo ha sido configurado correctamente!"
