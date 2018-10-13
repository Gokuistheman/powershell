$CSV = Import-Csv "\\userdata\isshare$\helpdesk\Projects and Tasks\2014\Rob Ahrensdorf\CSV Test - Shamrock New Mexico Customers Email Addresses Sept 2013.csv"

foreach( $Contact in $CSV)
{Write-Host $Contact| ft 
New-ADUser PStest -AccountPassword Rock2013 -Description "PS Test User" -Path "OU=TEST,DC=SHAMROCKFOODS,DC=COM"
Add-DistributionGroupMember -Identity "AZ Street Sales" -Member $Contact.ExternalEmailAddress
}
