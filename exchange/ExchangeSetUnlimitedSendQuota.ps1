#Matt Hamende - SFC 2014 - ExchangeSetUnlimitedQuota.ps1
#if ran from Exchange Management Shell will set all mailboxdatabases without UNLIMITED quotas to UNLIMITED
$query = Get-StorageGroup | Get-MailboxDatabase | ?{$_.prohibitsendquota -ne "unlimited"}
$query | Set-MailboxDatabase -IssueWarningQuota unlimited -ProhibitSendReceiveQuota unlimited -ProhibitSendQuota unlimited