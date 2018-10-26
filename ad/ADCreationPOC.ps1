$CSV = Import-Csv "\\cifs\share\stuffs"

foreach( $Contact in $CSV)
{Write-Host $Contact| ft 
New-ADUser <username> -AccountPassword <pass> -Description "Test User" -Path "OU=TEST,DC=YOURDOMAIN,DC=COM"
Add-DistributionGroupMember -Identity "Sales" -Member $Contact.ExternalEmailAddress
}
