function ConvertTo-DSCPullArchive
{
<#
.Synopsis
   Converts PowerShell Modules to compressed .zip files.
.DESCRIPTION
   Converts PowerShell Modules to compressed .zip files
   used by Desired State Configuraiton pull servers.
.EXAMPLE
    ConvertTo-DSCPullArchive -Source "C:\LabResources\xTimeZone" -destination 'c:\temp'
.EXAMPLE
   Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $Source,
        $destination
    )

    Begin
    {
        $Version = (Get-ChildItem -Path $source -Depth 1).Name
        $ResoureName = (Get-ChildItem -Path $source -Depth 1).Parent.Name
        $ModuleName = $ResoureName+'_'+$Version
        $destinationZip = ($destination+'\'+$ModuleName)+'.zip'
    }
    Process
    {
        New-Item -Path ($destination+'\'+$ModuleName) -ItemType Directory
        Get-ChildItem ($source+'\'+$Version) | Copy-Item -Destination ($destination+'\'+$ModuleName)
        
        If(Test-path $destinationZip) {Remove-item $destinationZip -Force}
        Add-Type -assembly "system.io.compression.filesystem"
        [io.compression.zipfile]::CreateFromDirectory(($destination+'\'+$ModuleName), $destinationZip)
        New-DscCheckSum -ConfigurationPath $destinationZip -OutPath $destination -Verbose -Force
    }
    End
    {
        Remove-Item -Path ($destination+'\'+$ModuleName) -Confirm:$false -Recurse
    }
}