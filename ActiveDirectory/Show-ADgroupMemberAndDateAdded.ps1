$username = "user1"
$userobj  = Get-ADUser $username

Get-ADUser $userobj.DistinguishedName -Properties memberOf |
 Select-Object -ExpandProperty memberOf |
 ForEach-Object {
    Get-ADReplicationAttributeMetadata $_ -Server COV1ADV01 -ShowAllLinkedValues | 
      Where-Object {$_.AttributeName -eq 'member' -and 
      $_.AttributeValue -eq $userobj.DistinguishedName} |
      Select-Object FirstOriginatingCreateTime, Object, AttributeValue
    } | Sort-Object FirstOriginatingCreateTime -Descending | Out-GridView
    
    #source http://blogs.technet.com/b/ashleymcglone/archive/2014/10/29/microsoft-virtual-academy-using-powershell-for-active-directory.aspx
