#Starts logging
$d = (get-date -format MMddyyy_HHmmtt) #Gets the date and specifies the format

Start-Transcript -path c:\scripts\log\COManditoryReboot-$d.txt  -append #Starts a new transcript

$Servers = (Get-Content '\\cifs\isshare$\Citrix Scripts\Reference Files\Test.txt')
Write-Host $Servers
#Remove-Item c:\servertempco.txt
#Write-Host Querying user sessions on $Servername

Add-PSSnapin Citrix.XenApp.Commands
#15 Minute Warning
ForEach ($Server in $Servers)
    {
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'yourcompany*'}
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
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'yourcompany*'}
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
        $QUERY = Get-XASession -ServerName $Server | where { $_.AccountName -like 'yourcompany*'}
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
#This grabs the password from the secure strings created above
$pass = Get-Content c:\credential.txt | ConvertTo-SecureString #Gets credentials as secure string

#Creates the PowerShell object to pass the credential
$credential = New-Object System.Management.Automation.PSCredential("yourcompany\admin-account",$pass) #Creates the object to pass credentials

#Echo the credentials
$credential

Write-Host $d Loading XenServer PS SnapIn... $Server

#Add the PS-Snapin to ensure it is available to connect to the Xen Server
Add-PSSnapin XenServerPSSnapIn -ErrorAction "SilentlyContinue"

Write-Host $d Connecting to Xen Farm...

#Connect to the master pool with necessary credentials
Connect-XenServer -Creds $Credential -Server master.yourcompany.com -nowarncertificates -SetDefaultSession

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
