#Creating Hash table
  $hash=@{
                    Computername=$cs.Name
                    Workgroup=$cs.WorkGroup
                    AdminPassword=$aps
                    Model=$cs.Model
                    Manufacturer=$cs.Manufacturer
                }
#Adding lines to hash table
$os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer
$hash.Add("Version",$os.Version)
$hash.Add("ServicePackMajorVersion",$os.ServicePackMajorVersion)
