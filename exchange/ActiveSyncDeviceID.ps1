CLS
"Device ID Update"
""
"Enter the SAMID of the user whose mailbox you wish to update"
""
$user = Read-Host -Prompt "enter username"

CLS
"User Information"
$casmailbox = Get-CASMailbox -Identity $user
$casmailbox | ft Displayname,samaccountname,activesyncmailboxpolicy,activesyncenabled,Activesyncalloweddeviceids,whenchanged -AutoSize
""
"Current Device Relationships"
$ActiveSync = Get-ActiveSyncDeviceStatistics -Mailbox $user 
$ActiveSync | ft identity,deviceid,devicephonenumber,devicemodel,devicetype,deviceos,deviceimei,devicefriendlyname,lastsuccesssync -AutoSize
"most recently synced device"
$ActiveSync | sort lastsuccesssync -Descending | select -First 1 | ft identity,deviceid,devicephonenumber,devicemodel,devicetype,deviceos,deviceimei,devicefriendlyname,lastsuccesssync -AutoSize
$ActiveSync
$DEVICEID = Read-Host -Prompt "Enter Authorized Device ID"

$casmailbox | Set-CASMailbox -ActiveSyncAllowedDeviceIDs $DEVICEID
"setting ID..."
Start-Sleep -Seconds 5

$casmailbox = Get-CASMailbox -Identity $user
$casmailbox | ft Displayname,samaccountname,activesyncmailboxpolicy,activesyncenabled,Activesyncalloweddeviceids,whenchanged -AutoSize

