Get-ADuser –filter * -properties * | ft name,department

Get-ADUser –Filter * -Properties * | sort –Property Department | ft Name,Department

Get-ADUser –filter {Department –eq “Sales” –or Department –eq “Marketing”} –Properties * | ft –Property Surname,Department,PasswordLastSet
