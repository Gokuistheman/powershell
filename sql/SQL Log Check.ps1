$Date = Get-Date -Format yyyy-MM-dd
$Query = Select-String -path "\\d2650aa\c$\Program Files\Microsoft SQL Server\MSSQL\LOG\ErrorLog" -pattern fail | Select-Object line | `
Select-String -Patter $Date #| ft line
If ($Query -like '*fail*') {Send-MailMessage -From "sqlnotify@shamrockfoods.com" `
-To "ISTech3@shamrockfoods.com, sqlnotify@shamrockfoods.com" -Subject "SQL Server Logs D2650AA" `
-body "Here are the logs of the failed SQL back up for D2650AA:

$Query" -smtpServer oa.shamrockfoods.com}
Else {Send-MailMessage -From "sqlnotify@shamrockfoods.com" `
-To "ISTech3@shamrockfoods.com" -Subject "SQL Server Logs D2650AA" `
-body "SQL BackUps were successful" -smtpServer oa.shamrockfoods.com}

$Date = Get-Date -Format yyyy-MM-dd
$Query = Select-String -path "\\d2650ae\c$\Program Files\Microsoft SQL Server\MSSQL\LOG\ErrorLog" -pattern fail | Select-Object line | `
Select-String -Patter $Date #| ft line
If ($Query -like '*fail*') {Send-MailMessage -From "sqlnotify@shamrockfoods.com" `
-To "ISTech3@shamrockfoods.com, sqlnotify@shamrockfoods.com" -Subject "SQL Server Logs D2650AE" `
-body "Here are the logs of the failed SQL back up for D2650AE:

$Query" -smtpServer oa.shamrockfoods.com}
Else {Send-MailMessage -From "sqlnotify@shamrockfoods.com" `
-To "ISTech3@shamrockfoods.com" -Subject "SQL Server Logs D2650AE" `
-body "SQL BackUps were successful" -smtpServer oa.shamrockfoods.com}