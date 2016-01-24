Configuration DSCLabUp {
    
    param (
        [string[]]$NodeName,        
        [string]$MachineName
        )
    
    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource –ModuleName xPSDesiredStateConfiguration
    Import-DscResource -Module cNetworking
    Import-DscResource -Module xNetworking
    Import-DscResource -module xDHCpServer
    Import-DscResource -Module xComputerManagement
    Import-DscResource -Module xTimeZone
    
    Node $AllNodes.Where{$_.Role -eq "DomainController"}.Nodename  {
        
        LocalConfigurationManager            
        {            
            ActionAfterReboot = 'ContinueConfiguration'            
            ConfigurationMode = 'ApplyAndAutoCorrect'            
            RebootNodeIfNeeded = $true            
        }        

        xComputer NewName {
            Name = $Node.MachineName
        }

        xTimeZone SystemTimeZone {
            TimeZone = 'Central Standard Time'
            IsSingleInstance = 'Yes'
        }

        xIPAddress NewIPAddress
        {
            IPAddress      = $Node.IPAddress
            InterfaceAlias = "Ethernet"
            SubnetMask     = 24
            AddressFamily  = "IPV4"
 
        }

        xDefaultGatewayAddress NewDefaultGateway
        {
            AddressFamily = 'IPv4'
            InterfaceAlias = 'Ethernet'
            Address = $Node.DefaultGateway
            DependsOn = '[xIPAddress]NewIpAddress'

        }

        cDNSServerAddress DnsServerAddress
        {
            Address        = $Node.DNSIPAddress
            InterfaceAlias = 'Ethernet'
            AddressFamily  = 'IPV4'
        }        
        
        WindowsFeature ADDSTools            
        {             
            Ensure = "Present"             
            Name = "RSAT-ADDS"             
        }   
    }
}

$ConfigData = @{             
    AllNodes = @(             
        @{             
            Nodename = 'Localhost'          
            Role = "DomainController"
            MachineName = 'ZDC01'
            IPAddress = '192.168.2.2'
            DefaultGateway = '192.168.2.1'
            DNSIPAddress = '127.0.0.1'
        }
                      
    )             
}   

# Save ConfigurationData in a file with .psd1 file extension

DSCLabUp -ConfigurationData $ConfigData -verbose

Set-DscLocalConfigurationManager -Path .\DSCLabUp -Verbose -Force
Start-DscConfiguration -ComputerName localhost -wait -force -Verbose -Path .\DSCLabUp
