 #Restarts Biztalk Service Remotely.
 
 #Array of Servers
 $SERVERS = @("BT10PROD1",
              "BT10PROD2")
CLS
#Main Exeuction Loop
Foreach($SERVER in $SERVERS)
    {
    Write-Host $SERVER
    #Queries WMI and Restarts Service
    Get-WmiObject -ComputerName $SERVER Win32_Service | Where-Object { $_.name -like 'BTSsvc*' -and $_.startmode -like 'Auto' -and $_.state -eq 'running'} | Restart-Service -Force
    Write-Host "Service Restarted"
    Write-Host "------------------"
    }