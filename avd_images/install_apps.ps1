param(
[string]$STORAGE_ACCESS_KEY,
[string]$STORAGE_ACCOUNT_NAME,
[string]$SHARE_NAME
)

# Schreibe Parameter auf den öffentlichen Desktop (hardcodiert)
$outputFile = "C:\Users\Public\Desktop\fslogix_config.txt"

$content = @"
STORAGE_ACCOUNT_NAME = $STORAGE_ACCOUNT_NAME
SHARE_NAME = $SHARE_NAME
STORAGE_ACCESS_KEY = $STORAGE_ACCESS_KEY
"@

Set-Content -Path $outputFile -Value $content -Encoding UTF8

# install applications
choco install 7zip -y --accept-package-agreements --accept-source-agreements


# Prepare VM for FSLogix
reg add HKLM\SYSTEM\CurrentControlSet\Control\Lsa\Kerberos\Parameters /v CloudKerberosTicketRetrievalEnabled /t REG_DWORD /d 1

net use z: \\$STORAGE_ACCOUNT_NAME.file.core.windows.net\$SHARE_NAME $STORAGE_ACCESS_KEY /user:Azure\$STORAGE_ACCOUNT_NAME

icacls z: /grant "Domain Users:(M)"
icacls z: /grant "Creator Owner:(OI)(CI)(IO)(M)"
icacls z: /remove "Authenticated Users"
icacls z: /remove "Builtin\Users"

$regPath = "HKLM:\SOFTWARE\FSLogix\profiles"
New-ItemProperty -Path $regPath -Name Enabled -PropertyType DWORD -Value 1 -Force
New-ItemProperty -Path $regPath -Name VHDLocations -PropertyType MultiString -Value \\$STORAGE_ACCOUNT_NAME.file.core.windows.net\$SHARE_NAME -Force

