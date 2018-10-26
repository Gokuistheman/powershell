forEach($Member in Get-Content c:\text.txt) {Get-ADUser -Filter * -Properties Displayname | Where-Object { $_.Displayname -eq $Member } `
| ft -HideTableHeaders SamAccountName | Out-File -Append c:\csv }
