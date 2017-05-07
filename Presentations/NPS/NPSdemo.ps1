#region Exploring PowerShell

(Get-Command).count

Get-Command *process*

Get-Help Get-Process -Full

Get-Help Get-Process -Examples

Get-Process -Name PowerShell

Help Update-Help

Update-Help

#endregion

#region Getting Information

Get-CimInstance Win32_OperatingSystem

Get-CimInstance Win32_OperatingSystem | Get-Member

Get-CimInstance Win32_OperatingSystem | Select-Object *

Get-CimInstance Win32_OperatingSystem | Select-Object Caption,InstallDate,ServicePackMajorVersion

Get-WmiObject -class Win32_LogicalDisk

Get-WmiObject -class Win32_LogicalDisk | Where-Object DriveType -eq 3

Get-WmiObject -class Win32_LogicalDisk -Filter "DriveType=3"

(Get-WmiObject -class Win32_LogicalDisk -Filter "DriveType=3").FreeSpace / 1GB

#endregion

#region Making Changes

### Processes
Start-Process NotePad

Get-Process Notepad | Stop-Process

### File System
New-Item -Path $env:SystemDrive\NPS -Name NPS -ItemType Directory

New-Item -Path $env:SystemDrive\NPS -Name NPSfile.txt -ItemType File -Value 'Test File'

Get-Content -Path $env:SystemDrive\NPS\NPSfile.txt

Set-Content -Path $env:SystemDrive\NPS\NPSfile.txt -Value 'New Content'

Get-Content -Path $env:SystemDrive\NPS\NPSfile.txt

### Registry
New-Item -Path HKLM:\Software -Name NPS

Test-Path -Path HKLM:\SOFTWARE\NPS

Get-ItemProperty -Path HKLM:\SOFTWARE\NPS

Set-Item -Path HKLM:\SOFTWARE\NPS -Value 'New Value'

Get-ItemProperty -Path HKLM:\SOFTWARE\NPS

#endregion

#region Introduction to the Scripting Language

### Variables
$var = 'variable'
$number = 1
$numberArray = 1,2,3,4,5,6
$stringArray = 'a','b','c','d'

### Quotation Marks
$singleQuotes = 'Use for text without variables'
$doubleQuotes = "Use when placing a $var in quotes"

### Object Members Variables
$proc = Get-Process | Sort-Object -Descending
$proc | Get-Member
$name = $proc[0].ProcessName
$name.ToUpper()

### Parentheses

### Operators

### If construct

### Foreach loop

#endregion