$Name = Read-Host
$SwitchName = 'Internal'
$HardDiskSize = 32GB
$HDPath = 'C:\Hyper-V\Virtual Hard Disks'+'\'+$Name+'.vhdx'
$Generation = '2'
$ISO_Path = 'C:\Hyper-V\ISO\WindowsServer2016TechnicalPreview4.ISO'

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

#New-NetIPAddress –InterfaceIndex 12 –IPAddress -192.0.2.2 –PrefixLength 24 –DefaultGateway -192.0.2.1
#Get-NetFirewallProfile | Set-NetFirewallProfile -Enabled false #disable firewall