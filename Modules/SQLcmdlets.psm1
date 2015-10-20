function Get-DatabaseData {
<#
.SYNOPSIS
Executes a query statement against a SQL database table.
.DESCRIPTION
Executes a SQL query statement against a SQL database to retreive information specified by the
query parameter.
.PARAMETER connectionString

.PARAMETER query
.EXAMPLE
Disable-ADComputer -Identity computer1 -PSCredential domain\user -Description "CR00002" -verbose
#>
    [CmdletBinding()]
    param (
        [string]$connectionString,
        [string]$query
    )

    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection
    
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    $adapter = New-Object -TypeName System.Data.SqlClient.SqlDataAdapter $command

    $dataset = New-Object -TypeName System.Data.DataSet
    $adapter.Fill($dataset)
    $dataset.Tables[0]
    $connection.close()
}

function Invoke-DatabaseQuery {
    [CmdletBinding(SupportsShouldProcess=$True,
                   ConfirmImpact='Low')]
    param (
        [string]$connectionString,
        [string]$query
    )

    $connection = New-Object -TypeName System.Data.SqlClient.SqlConnection

    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    if ($pscmdlet.shouldprocess($query)) {
        $connection.Open()
        $command.ExecuteNonQuery()
        $connection.close()
    }
}
