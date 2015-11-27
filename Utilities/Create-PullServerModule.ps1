$source = "C:\LabResources\xTimeZone"

$destination = "C:\temp"

$Version = (Get-ChildItem -Path $source -Depth 1).Name
$ResoureName = (Get-ChildItem -Path $source -Depth 1).Parent.Name
$ModuleName = $ResoureName+'_'+$Version

New-Item -Path ($destination+'\'+$ModuleName) -ItemType Directory

Get-ChildItem ($source+'\'+$Version) | Copy-Item -Destination ($destination+'\'+$ModuleName)

$destinationZip = ($destination+'\'+$ModuleName)+'.zip'



 If(Test-path $destinationZip) {Remove-item $destinationZip -Force}

Add-Type -assembly "system.io.compression.filesystem"

[io.compression.zipfile]::CreateFromDirectory(($destination+'\'+$ModuleName), $destinationZip)

Remove-Item -Path ($destination+'\'+$ModuleName) -Force