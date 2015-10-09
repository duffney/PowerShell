Get-NetAdapter | Select Name,MacAddress #Select NetAdpter with internet access
New-VMSwitch -NetAdapterName 'Wi-Fi' -Name 'External' #Create External internet providing Hyper-v adapter
New-VMSwitch -SwitchType Internal -Name 'Internal'

