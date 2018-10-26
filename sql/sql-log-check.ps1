$Date = Get-Date -Format yyyy-MM-dd
$Query = Select-String -path "\\<server.name>\c$\Program Files\Microsoft SQL Server\MSSQL\LOG\ErrorLog" -pattern fail | Select-Object line | `
Select-String -Patter $Date #| ft line
If ($Query -like '*fail*') {Send-MailMessage -From "sqlnotify@yourcompany.com" `
-To "email@yourcompany.com, sqlnotify@yourcompany.com" -Subject "SQL Server Logs <server.name>" `
-body "Here are the logs of the failed SQL back up for <server.name>:

$Query" -smtpServer email-server.yourcompany.com}
Else {Send-MailMessage -From "sqlnotify@yourcompany.com" `
-To "email@yourcompany.com" -Subject "SQL Server Logs <server.name>" `
-body "SQL BackUps were successful" -smtpServer email-server.yourcompany.com}

$Date = Get-Date -Format yyyy-MM-dd
$Query = Select-String -path "\\d2650ae\c$\Program Files\Microsoft SQL Server\MSSQL\LOG\ErrorLog" -pattern fail | Select-Object line | `
Select-String -Patter $Date #| ft line
If ($Query -like '*fail*') {Send-MailMessage -From "sqlnotify@yourcompany.com" `
-To "email@yourcompany.com, sqlnotify@yourcompany.com" -Subject "SQL Server Logs <server.name>" `
-body "Here are the logs of the failed SQL back up for <server.name>:

$Query" -smtpServer email-server.yourcompany.com}
Else {Send-MailMessage -From "sqlnotify@yourcompany.com" `
-To "email@yourcompany.com" -Subject "SQL Server Logs <server.name>" `
-body "SQL BackUps were successful" -smtpServer email-server.yourcompany.com}
