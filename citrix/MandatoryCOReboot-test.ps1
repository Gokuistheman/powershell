#Starts logging
$d = (get-date -format MMddyyy_HHmmtt) #Gets the date and specifies the format

Start-Transcript -path c:\scripts\log\COManditoryReboot-TEST-$d.txt  -append #Starts a new transcript

$Servers = (Get-Content '\\cifs\isshare$\Citrix Scripts\Reference Files\Test.txt')
Write-Host $Servers
#Remove-Item c:\servertempco.txt
#Write-Host Querying user sessions on $Servername

Add-PSSnapin Citrix.XenApp.Commands
#15 Minute Warning
ForEach ($Server in $Servers)
    {
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'name*'}
            ForEach($Session in $QUERY)
            #write-host $Session
            {
            IF ($Session.sessionid -ne $null)
                {Send-XASessionMessage -ServerName $Server -MessageTitle "ATTENTION!" `
                -MessageBody "A Critical Problem has been detected with this Server, it Will Reboot in 15 Minutes, Please save your work Immediately." `
                -SessionId $Session.SessionId -MessageBoxIcon "error" -ErrorAction "SilentlyContinue"}
            }
     }

#10 Minute Warning
Start-Sleep -Seconds 5

ForEach ($Server in $Servers)
    {
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'name*'}
            ForEach($Session in $QUERY)
            #write-host $Session
            {
            IF ($Session.sessionid -ne $null)
                {Send-XASessionMessage -ServerName $Server -MessageTitle "ATTENTION!" `
                -MessageBody "A Critical Problem has been detected with this Server, it Will Reboot in 10 Minutes, Please save your work Immediately." `
                -SessionId $Session.SessionId -MessageBoxIcon "error" -ErrorAction "SilentlyContinue"}
            }
     }

#Write-Host Second Warning Sent
Start-Sleep -Seconds 5

ForEach ($Server in $Servers)
    {
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'name*'}
            ForEach($Session in $QUERY)
            #write-host $Session
            {
            IF ($Session.sessionid -ne $null)
                {Send-XASessionMessage -ServerName $Server -MessageTitle "ATTENTION! - FINAL WARNING!!!" `
                -MessageBody "A Critical Problem has been detected with this Server, it Will Reboot in 5 Minutes, Please save your work Immediately. This is the Final Warning" `
                -SessionId $Session.SessionId -MessageBoxIcon "error" -ErrorAction "SilentlyContinue"}
            }
     }



#$ErrorActionPreference="SilentlyContinue" #Set default ErrorAction behavior

$pass = Get-Content c:\credential2.txt | ConvertTo-SecureString #Gets credentials as secure string

$credential2 = New-Object System.Management.Automation.PSCredential("yourdomain\username",$pass) #Creates the object to pass credentials

$credential2

Write-Host $d Loading XenServer PS SnapIn... $Server

Add-PSSnapin XenServerPSSnapIn -ErrorAction "SilentlyContinue"

Write-Host $d Connecting to Xen Farm...

Connect-XenServer -Creds $Credential2 -Server coxen2.yourdomain.com -nowarncertificates -SetDefaultSession

Get-XenVM | Where-Object {$_.power_state -notlike "*Run*"} | Select Power_State, name_label


Write-Host Testing Connection...
#Get-XenServer -VM | where { $_.name_label -like $Server } | select name_label
Get-XenVM | where { $_.name_label -like "*$Server*" } | select name_label

foreach($Server in $Servers)
    {
    Write-Host $d Rebooting Server - $Server
    #Invoke-XenServer:VM.HardReboot –VM $Server
    Invoke-XenVM -Name $Server -XenAction HardReboot
    }

Stop-Transcript
