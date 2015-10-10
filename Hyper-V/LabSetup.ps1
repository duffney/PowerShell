Get-NetAdapter | Select Name,MacAddress #Select NetAdpter with internet access
New-VMSwitch -NetAdapterName 'Wi-Fi' -Name 'External' #Create External internet providing Hyper-v adapter
New-VMSwitch -SwitchType Internal -Name 'Internal'

Install-ADDSDomain -Credential (Get-Credential manticore\zephyr) -NewDomainName Hydra -ParentDomainName manticore.org -SkipPreChecks -SafeModeAdministratorPassword (($PWD = '')|ConvertTo-SecureString -AsPlainText -Force) -DomainType ChildDomain -NewDomainNetbiosName hydra
