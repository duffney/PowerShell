$DisplayName = 'WST-ADD-DefaultLogonDomain'
$GPOName = (Get-GPO -Name $DisplayName).DisplayName

if(-not (Test-Path c:\GPOs\$GPOName)){New-Item -ItemType Directory -Path "c:\GPOs\$GPOName"}
Backup-GPO -Name $GPOName -Path "$env:SystemDrive\GPOs\$GPOName" -Verbose

$session = New-PSSession -ComputerName ZDC01 -Credential zephyr\administrator

Copy-Item "C:\GPOs\$GPOName" -Recurse -Destination "C:\GPOs\$GPOName" -TOsession $session -Verbose -Force
 
icm -ScriptBlock {param($GPOName)Import-Module GroupPolicy;Import-GPO -BackupGpoName $GPOName -CreateIfNeeded -Path "c:\GPOs\$GPOname" -TargetName $GPOName} -ArgumentList $GPOName -Verbose
 
 New-GPLink -Name $GPOName -Target 'DC=Zephyr,DC=org' -Verbose

 