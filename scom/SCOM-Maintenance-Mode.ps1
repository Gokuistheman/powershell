#Operations Managers - Maintenance Mode Script - Created by Matt Hamende SFC 2014
#Places Group of Servers into Maintenance Mode for Designated Time Interval

Stop-Transcript -ErrorAction SilentlyContinue
Start-Transcript -Path "\\vault\tech3\Scripts\Matt\logs\SCOM-MAINTENANCE.txt" -Append

#type
$TYPE = $ARGS[0]

#group or server name in quotes
$TARGET = $ARGS[1] 

#number of minutes to place in maintenance mode
$MINUTES = $ARGS[2]

#Comment
$COMMENT = $ARGS[3]

#creates timestamp for end of maintenance
$Time = (Get-date).AddMinutes($MINUTES)
$NOW = (Get-Date).ToUniversalTime()

Import-Module OperationsManager

Write-Host $TYPE $TARGET $MINUTES $COMMENT

#checks if Maintenance is for a Group of servers or an Instance (Single Server)
IF($TYPE -eq "group")
    {
    $INSTANCE = Get-SCOMGroup -DisplayName $TARGET
    $INSTANCE.StopMaintenanceMode($NOW)
    Start-SCOMMaintenanceMode -Instance $INSTANCE -EndTime $Time -Comment "$COMMENT" -Reason PlannedApplicationMaintenance
    }
ELSEIF($TYPE -eq "instance")
    {
   
    $INSTANCE = Get-SCOMClassInstance -DisplayName $TARGET
    $INSTANCE.StopMaintenanceMode($NOW)
    Start-SCOMMaintenanceMode -Instance $INSTANCE -EndTime $Time -Comment "$COMMENT" -Reason PlannedApplicationMaintenance 
    }
    ELSE
    {
    Write-Host "Incorrect Parameter - Exiting..."
    Write-Host ""
    Write-Host "Correct Format is - type target minutes comment"
    Write-Host ""
    Write-Host "Example: .\SCOM-Maintenance-Mode.ps1 instance WOHD.SHAMROCKFOODS.com 30 Reboot"
    Write-Host ""
    Write-Host "This would put ""WOHD.SHAMROCKFOODS.com"" into Maintenance Mode for 30 Minutes"
    }
    
    Stop-Transcript