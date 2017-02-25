 [DSCLocalConfigurationManager()]

Configuration LCM_Pull {

    Node Pullv2 {

        Settings {
            ConfigurationMode = 'ApplyAndAutoCorrect'
            RefreshMode = 'Pull'
        }

        ConfigurationRepositoryWeb PullServer {
            ServerURL = 'https://pullv2:8080/PsDscPullserver.svc'
            AllowUnsecureConnection = $false
            RegistrationKey = 'd50ea3d6-8a5d-4066-8876-84c7f939ffb7'
            ConfigurationNames = @('TimeZoneConfig')
        }

        ResourceRepositoryWeb PullServerModules {
            ServerURL = 'https://pullv2:8080/PsDscPullserver.svc'
            AllowUnsecureConnection = $false
            RegistrationKey = 'd50ea3d6-8a5d-4066-8876-84c7f939ffb7'
        }
    }
}

LCM_Pull

Set-DscLocalConfigurationManager -ComputerName pullv2 -Path .\LCM_Pull -Verbose -Force

Update-DscConfiguration -ComputerName pullv2 -Verbose -Wait