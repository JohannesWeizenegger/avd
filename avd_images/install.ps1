Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
$env:Path += ";C:\ProgramData\chocolatey\bin"


choco install greenshot -y --accept-package-agreements --accept-source-agreements *> C:\install_greenshot.log

choco install 7zip.install -y --accept-package-agreements --accept-source-agreements *> C:\install_7zip.log


