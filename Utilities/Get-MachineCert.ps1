#requires -version 4.0
#requires -module PKI
#Author Jeff Hicks
#get machine cert thumbprint and export cert
Function Export-MachineCert {

[cmdletbinding()]
Param(
[ValidateNotNullorEmpty()]
[string]$computername = $env:COMPUTERNAME,
[ValidateScript({Test-Path $_})]
[string]$Path="C:\Certs"

)

Try {
    #assumes a single certificate so sort on NotAfter
    Write-Verbose "Querying $computername for Machine certificates"
    $cert = invoke-command { 
     #get server authentication certs that have not expired
     dir Cert:\LocalMachine\my | 
     where {$_.EnhancedKeyUsageList.FriendlyName -contains "Server Authentication" -AND $_.notAfter -gt (Get-Date) } |
     Sort NotAfter -Descending | Select -first 1
     } -computername $computername -ErrorAction Stop
     write-verbose ($cert | out-string)
}
Catch {
    Throw $_
}

if ($cert) {

   #verify and export
   if (Test-Certificate $cert) {
    
    $exportPath  = Join-path -Path $Path -ChildPath "$computername.cer"
    Write-Verbose "Exporting certificate for $($cert.subject.trim()) to $exportpath"
    [pscustomobject]@{
     Computername = $cert.Subject.Substring(3)
     Thumbprint = $cert.Thumbprint
     Path = Export-Certificate -Cert $cert -FilePath $exportPath
    }
    
    } #if Test OK $cert
else {
        Write-Warning "Failed to verify or find a certificate"
 }
} #if $cert
} #Export-MachineCert

Function Get-MachineCertThumbnail {

[cmdletbinding()]
Param(
[ValidateNotNullorEmpty()]
[string]$computername = $env:COMPUTERNAME
)

Try {
    #assumes a single certificate so sort on NotAfter
    Write-Verbose "Querying $computername for Machine certificates"
    $cert = invoke-command { 
     #get server authentication certs that have not expired
     dir Cert:\LocalMachine\my | 
     where {$_.EnhancedKeyUsageList.FriendlyName -contains "Server Authentication" -AND $_.notAfter -gt (Get-Date) } |
     Sort NotAfter -Descending | Select -first 1
     } -computername $computername -ErrorAction Stop

}
Catch {
    Throw $_
}

If ($cert) {
  write-verbose ($cert | out-string)
  [pscustomobject]@{
     Computername = $cert.Subject.Substring(3)
     Thumbprint = $cert.Thumbprint
     Verified = Test-Certificate $cert 
    }
}

} #Get-MachineCertThumbnail