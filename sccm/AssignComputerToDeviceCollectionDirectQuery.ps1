#Starts the transcript for the action taking place in the script
Start-Transcript "\\cinnamon\adminu$\is\amis1206\My Documents\SCCMTranscripts.txtNew" 

#Imports the SCCM module
Import-Module 'Z:\Program Files\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'

#Changes the directory to the SCCM Site Code
cd AZP:

#Manually change 'All DSRs' to whatever device collection you're targeting
$CollectionName = "SO Express 32bit only"

#Parses through a file line by line - This file should hold the list of computers you are adding to the device collection
#Note: The file location must be local on SCCMAZ
$Computers = Get-Content "C:\SCCM Deployment List.txt"

#Adds the computer to the device collection
Foreach ($Computer in $Computers) 
{Add-CMDeviceCollectionDirectMembershipRule -CollectionName "$CollectionName" -ResourceId (Get-CMDevice -Name $Computer).ResourceID}

Stop-Transcript