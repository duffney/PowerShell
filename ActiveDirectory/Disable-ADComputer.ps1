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
.PARAMETER Domain
Specifies the domain in which to query for the computer given to the ComputerName parameter. If left blank it will query the domain of the currently logged on user.
.PARAMETER Description
By default this will append to the existing description of the computer object and append any text given to this parameter.
.EXAMPLE
Disable-ADComputer -ComputerName computer1 -DisabledOU 'OU=Computers,OU=Disabled Accounts,DC=domain,DC=com' -Description "CR00001' -Domain domain.forest.com -Verbose -whatif
#>
    [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Medium')]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline=$true)]
        [string[]]$ComputerName,
        [string]$DisabledOU,
        [string]$Domain = (Get-ADDomain).DNSroot,
        [string]$Description,
        [string]$ErrorLog = 'c:\retry.txt'
    )
    BEGIN {
        Write-Verbose "Starting Disable-ADComputer"
    }
    PROCESS {
        foreach($Computer in $ComputerName){
            Try {
                $ComputerInfo = Get-ADComputer -Identity $Computer -Server $Domain -Properties Description
                $Description = $($ComputerInfo.Description) + " "+ $Description

                Write-Verbose "Disabling $Computer"
                
                Set-ADComputer -Identity $Computer -Description $Description -Enabled $false -Server $Domain -Verbose

                Write-Verbose "Moving $Computer to $DisabledOU"

                Move-ADObject -Identity $($ComputerInfo.DistinguishedName) -TargetPath $DisabledOU -Server $Domain -Verbose
                
            }
            Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]{
                Write-Warning "$Computer was not found"
                Write-Output $Computer | Out-File $ErrorLog
            }
            Catch {
                Write-Warning $_.Exception.Message
            }
        }
    }
    END {
        Write-Verbose "Finished"
    }
}
