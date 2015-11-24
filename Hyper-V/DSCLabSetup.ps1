$Name = 'ZDC01'
$SwitchName = 'Internal'
$HardDiskSize = 32GB
$HDPath = 'F:\Hyper-V\Virtual Hard Disks'+'\'+$Name+'.vhdx'
$Generation = '2'
$ISO_Path = 'D:\ISOs\10514.0.150808-1529.TH2_RELEASE_SERVER_OEMRET_X64FRE_EN-US.ISO'

New-VM -Name $Name -SwitchName $SwitchName `
-NewVHDSizeBytes $HardDiskSize `
-NewVHDPath $HDPath -Generation $Generation -MemoryStartupBytes 1024MB

Add-VMDvdDrive -VMName $Name -Path $ISO_Path


$MyDVD = Get-VMDvdDrive $Name
$MyHD = Get-VMHardDiskDrive $Name
$MyNIC = Get-VMNetworkAdapter $Name

Set-VMFirmware $Name -BootOrder $MyDVD,$MyHD,$MyNIC
Set-VMMemory $Name -DynamicMemoryEnabled $false
break

#Image Server

Save-Module -Name 'xNetworking','xDHCPServer','xComputerManagement','xActiveDirectory','xPSDesiredStateConfiguration','xTimeZone' -Path 'C:\LabResources'
#Create .iso

$LabResourcePath = 'C:\LabResources\LabResources.iso'
Set-VMDvdDrive -VMName $Name -Path $LabResourcePath

Invoke-Command -VMName $Name -ScriptBlock {Copy-Item -Path D:\* -Recurse -Destination "$env:ProgramFiles\WindowsPowerShell\Modules" -Force}

#Rename HDC01 and restart
$Name = 'HDC01'
$SwitchName = 'Internal'
$HardDiskSize = 32GB
$HDPath = 'F:\Hyper-V\Virtual Hard Disks'+'\'+$Name+'.vhdx'
$Generation = '2'
$ISO_Path = 'D:\ISOs\10514.0.150808-1529.TH2_RELEASE_SERVER_OEMRET_X64FRE_EN-US.ISO'

New-VM -Name $Name -SwitchName $SwitchName `
-NewVHDSizeBytes $HardDiskSize `
-NewVHDPath $HDPath -Generation $Generation -MemoryStartupBytes 1024MB

Add-VMDvdDrive -VMName $Name -Path $ISO_Path


$MyDVD = Get-VMDvdDrive $Name
$MyHD = Get-VMHardDiskDrive $Name
$MyNIC = Get-VMNetworkAdapter $Name

Set-VMFirmware $Name -BootOrder $MyDVD,$MyHD,$MyNIC
Set-VMMemory $Name -DynamicMemoryEnabled $false