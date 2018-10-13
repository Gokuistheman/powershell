$GROUP = $ARGS[0] 
$MINUTES = $ARGS[1]
$INSTANCE = Get-SCOMGroup -DisplayName $GROUP
$Time = (Get-date).AddMinutes($MINUTES)
Start-SCOMMaintenanceMode -Instance $INSTANCE -EndTime $Time -Comment "TEST" -Reason PlannedApplicationMaintenance