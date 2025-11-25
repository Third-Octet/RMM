# --- Variables ---
$ZipUrl = "https://github.com/Third-Octet/RMM/raw/refs/heads/main/brandon-grotesque-font-family-1762524917-0.zip"   # CHANGE THIS
$TempZip = "$env:TEMP\fonts.zip"
$ExtractPath = "$env:TEMP\fonts_extracted"
$FontsPath = "C:\Windows\Fonts"

# --- Download ZIP ---
Write-Host "Downloading font ZIP..."
Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing

# --- Extract ZIP ---
Write-Host "Extracting ZIP..."
if (Test-Path $ExtractPath) {
    Remove-Item $ExtractPath -Recurse -Force
}
Expand-Archive -Path $TempZip -DestinationPath $ExtractPath

# --- Install Fonts ---
Write-Host "Installing fonts..."
Get-ChildItem -Path $ExtractPath -Recurse -Include *.ttf, *.otf | ForEach-Object {
    $FontFile = $_.FullName
    $FontName = $_.Name
    Write-Host "Installing $FontName..."

    Copy-Item -Path $FontFile -Destination $FontsPath -Force

    # Add registry entry so Windows registers the font
    $RegPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    New-ItemProperty -Path $RegPath -Name $FontName -Value $FontName -PropertyType String -Force | Out-Null
}

Write-Host "Refreshing font cache..."
$null = Add-Type -AssemblyName System.Drawing

# --- Cleanup ---
