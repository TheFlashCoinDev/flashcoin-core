param(
    [string]$Version = "0.1.0"
)

$root  = "C:\dev\flashcoin"
$build = "$root\build"
$out   = "C:\FlashCoin-Wallet-v$Version"

# 1) Crear carpeta limpia del release
Remove-Item $out -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Path $out | Out-Null

# 2) Copiar el .exe en Release
Copy-Item "$build\bin\Release\FlashCoin-qt.exe" $out

# 3) Correr windeployqt sobre ese exe
& "$build\vcpkg_installed\x64-windows\tools\Qt6\bin\windeployqt.exe" `
   "$out\FlashCoin-qt.exe" --release

# 4) Copiar TODAS las DLLs de vcpkg (qrencode, sqlite, event_*, etc.)
Copy-Item "$build\vcpkg_installed\x64-windows\bin\*.dll" $out -Force

# 5) (Opcional) Crear un ZIP listo para subir al release
Compress-Archive -Path "$out\*" -DestinationPath "C:\FlashCoin-Wallet-v$Version.zip" -Force

Write-Host "Done! Release folder: $out"
Write-Host "ZIP: C:\FlashCoin-Wallet-v$Version.zip"
