function Disable-ADComputer {
<#
.SYNOPSIS
Disables Computers and moves them to the specified OU.
.DESCRIPTION
Take string or object input for computers then disables each one and moves to the specified ou
then outputs errors to a log file.
.PARAMETER COMPUTERNAME
Name of computer or computers
.PARAMETER DisabledOU
Specifies the Distinguished Name of the OU the device will be moved to.
.EXAMPLE
Disable-ADComputer -ComputerName computer1 -DisabledOU 'OU=Computers,OU=Disabled Accounts,DC=domain,DC=com' -Verbose
#>
    [CmdletBinding()]
    param(
        [string[]]$ComputerName,
        [string]$DisabledOU,
        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN {
        Write-Verbose "Starting Disable-ADComputer"
    }
    PROCESS {
        foreach($Computer in $ComputerName){
            Try {
                Write-Verbose "Disabling $Computer"
                Set-ADComputer -Identity $Computer -Enabled $false

                Write-Verbose "Moving $Computer to $DisabledOU"
                $DistinguishedName = (Get-ADComputer -Identity $Computer).DistinguishedName
                Move-ADObject -Identity $DistinguishedName -TargetPath $DisabledOU -Verbose
            }
            Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
                Write-Warning "$Computer was not found"
                Write-Output $Computer | Out-File $ErrorLog
            }
        }
    }
    END {
        Write-Verbose "Finished"
    }
}
