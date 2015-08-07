Get-ADuser –filter * -properties * | ft name,department

Get-ADUser –Filter * -Properties * | sort –Property Department | ft Name,Department

Get-ADUser –filter {Department –eq “Sales” –or Department –eq “Marketing”} –Properties * | ft –Property Surname,Department,PasswordLastSet

Get-ADComputer –filter * | % {Get-hotfix –computername $PSItem.Name}

Get-ADComputer –filter * | % {Invoke-command $PSitem.Name –scriptblock { get-hotfix}}

Get-ADGroupMember -Identity 'domain controllers' | % {Get-ADComputer $PSItem.Name -Properties OperatingSystem} | select Name,OperatingSystem

help about_active*
