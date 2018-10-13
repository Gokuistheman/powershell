$serial = Get-WmiObject win32_BIOS | Select SerialNumber

$serial = $serial.SerialNumber
Write-Host "$Serial"

Rename-Computer $Serial