break

##Import SQLcmdlet Module & configure connection string
Import-Module SQLcmdlets
$ConnectionString = "server=SQL01\SQLEXPRESS;database=OmahaPSUG;trusted_connection=true"

#Get data from SQL with PowerShell
Get-DatabaseData -connectionString $ConnectionString -query "Select * from OmahaPSUG_Computers" -isSQLServer

Get-DatabaseData -connectionString $ConnectionString -query "Select Name from OmahaPSUG_Computers" -isSQLServer

#Create object with SQL data
$ComputerData = Get-DatabaseData -connectionString $ConnectionString -query "Select * from OmahaPSUG_Computers" -isSQLServer

#Problem Returns number of quries found
$ComputerData
$ComputerData = $ComputerData[1..$ComputerData.Length]

#Take action on data from SQL
Get-Service -ComputerName $ComputerData.Name -Name ADWS

Foreach ($Computer in $ComputerData){
    #Write-Output $Computer
    Get-ADComputer -Identity $Computer.DistinguishedName -Properties Location | select Name,Location
    Set-ADComputer -Identity $Computer.DistinguishedName -Location 'Omaha' -Verbose
    Get-ADComputer -Identity $Computer.DistinguishedName -Properties Location | select Name,Location
}

##Insert data to SQL
$Computer = Get-ADComputer -Identity SQL01 -Properties LastLogonDate,OperatingSystem,Description

$query = "Insert Into OmahaPSUG_Computers (SamAccountName,Name,SID,DistinguishedName,Domain,LastLogonDate,Description,OperatingSystem)
Values ('$($Computer.SamAccountName)','$($Computer.Name)','$($Computer.SID)','$($Computer.DistinguishedName)','Manticore.org','$($Computer.LastLogonDate)','$($Computer.Description)','$($Computer.OperatingSystem)')"

Invoke-DatabaseQuery -connectionString $ConnectionString -query $query -isSQLServer

#Insert Loop
$Users = Get-ADUser -Filter * -Properties mail,LastLogonDate,Description,CanonicalName

foreach ($User in $Users){

    $Domain = $User.CanonicalName.Split('/')
    $Domain = $Domain[0]

    $query = "Insert Into OmahaPSUG_Users (SamAccountName,UserPrincipalName,SID,Mail,DistinguishedName,Domain,LastLogonDate,Description)
    Values ('$($User.SamAccountName)','$($User.UserPrincipalName)','$($User.SID)','$($Computer.Mail)','$($User.DistinguishedName)','$Domain','$($User.LastLogonDate)','$($User.Description)')"

    Invoke-DatabaseQuery -connectionString $ConnectionString -query $query -isSQLServer

}

#View SQL management studio visable data (No Mail populated)

#Get & Update SQL data

$UserPrincipalNames = (Get-DatabaseData -connectionString $ConnectionString -query "Select UserPrincipalName from OmahaPSUG_Users Where UserPrincipalName <> ' '" -isSQLServer).UserPrincipalName

Foreach ($UserPrincipalName in $UserPrincipalNames){

    $UpdateQuery = "Update OmahaPSUG_Users SET Mail = '$($UserPrincipalName)' where UserPrincipalName = '$($UserPrincipalName)'"

    Invoke-DatabaseQuery -connectionString $ConnectionString -query $UpdateQuery -isSQLServer

}
