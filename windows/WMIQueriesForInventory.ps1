﻿$COMPUTERS = Import-Csv '\\cifs\share\WindowsServerList.csv'
$SPECS = $null
$ErrorActionPreference = "SilentlyContinue"

ForEach($COMPUTER in $COMPUTERS){
$COMPUTER = $COMPUTER.name
$COMPUTER
#$COMPUTER = Read-Host "Computer Name"
$TEST = Test-Connection $COMPUTER -Count 1
Start-Sleep -Seconds 1

IF($TEST -ne $null)
    {
    $CS = Get-WmiObject -ComputerName $COMPUTER -Class Win32_ComputerSystem | Select Name,Manufacturer,Model,@{Expression={ $_.TotalPhysicalMemory /1GB -as [int]};Label="Memory"},numberofprocessors,numberoflogicalprocessors
    $OS = Get-WmiObject -ComputerName $COMPUTER -Class Win32_OperatingSystem | select caption,OSArchitecture, ServicePackMajorVersion, ServicePackMinorVersion, SerialNumber
    $PROC = Get-WmiObject -ComputerName $COMPUTER -Class Win32_Processor | select -First 1 | select MaxClockSpeed
    $Storage = (((Get-WmiObject -ComputerName $COMPUTER Win32_DiskDrive).size) | Measure-Object -Sum).Sum /1GB -as [int]
   
    $SPECS = New-Object psobject
    $SPECS | Add-Member -NotePropertyName Name -NotePropertyValue $COMPUTER
    $SPECS | Add-Member -NotePropertyName Manufacturer -NotePropertyValue $CS.Manufacturer
    $SPECS | Add-Member -NotePropertyName Model -NotePropertyValue $CS.Model
    $SPECS | Add-Member -NotePropertyName 'OS Version' -NotePropertyValue $OS.caption
    $SPECS | Add-Member -NotePropertyName Cores -NotePropertyValue $CS.NumberOfProcessors
    $SPECS | Add-Member -NotePropertyName Threads -NotePropertyValue $CS.NumberOfLogicalProcessors
    $SPECS | Add-Member -NotePropertyName 'Architecture' -NotePropertyValue $OS.OSArchitecture
    $SPECS | Add-Member -NotePropertyName 'CPU Freq(Ghz)' -NotePropertyValue $PROC.MaxClockSpeed
    $SPECS | Add-Member -NotePropertyName 'Memory(GB)' -NotePropertyValue $CS.Memory
    $SPECS | Add-Member -NotePropertyName 'Storage(GB)' -NotePropertyValue $Storage
    $SPECS | Add-Member -NotePropertyName 'Serial Number' -NotePropertyValue $OS.SerialNumber
    $SPECS | Add-Member -NotePropertyName 'Service Pack Major Version' -NotePropertyValue $OS.ServicePackMajorVersion
    $SPECS | Add-Member -NotePropertyName 'Service Pack Minor Version' -NotePropertyValue $OS.ServicePackMinorVersion
    $SPECS | ft -AutoSize
    $SPECS | Export-Csv '\\cifs\share\WindowsServerInfov2.csv' -Append
    echo $SPECS
    }
    ELSE
    {
    Write-Host Connection Failed
    }


}
