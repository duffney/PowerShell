$Name = 'SQL01'
$SwitchName = 'LAN'
$HardDiskSize = 32GB
$HDPath = 'C:\Hyper-V\Virtual Machines'+'\'+$Name+'.vhdx'
$Generation = '2'

$VMparams = @{
'NewVHDPath' = 'SQL01'
'NewVHDSizeBytes' = 32GB
'Generation' = '2'
'Name' = 'c:\Hypver-V\Virtual Machines'+'\'+$Name+'.vhdx'
'SwitchName' = 'LAN'
}


New-VM @VMparams
