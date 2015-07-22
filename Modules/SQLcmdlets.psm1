function Get-DatabaseData {
    [CmdletBinding()]
    param (
        [string]$connectionString,
        [string]$query,
        [switch]$isSQLServer
    )
    if ($isSQLServer) {
        Write-Verbose 'in SQL Server mode'
        $connection = New-Object -TypeName `
            System.Data.SqlClient.SqlConnection
    } else {
        Write-Verbose 'in OleDB mode'
        $connection = New-Object -TypeName `
            System.Data.OleDb.OleDbConnection
    }
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    if ($isSQLServer) {
        $adapter = New-Object -TypeName `
        System.Data.SqlClient.SqlDataAdapter $command
    } else {
        $adapter = New-Object -TypeName `
        System.Data.OleDb.OleDbDataAdapter $command
    }
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
        [string]$query,
        [switch]$isSQLServer
    )
    if ($isSQLServer) {
        Write-Verbose 'in SQL Server mode'
        $connection = New-Object -TypeName `
            System.Data.SqlClient.SqlConnection
    } else {
        Write-Verbose 'in OleDB mode'
        $connection = New-Object -TypeName `
            System.Data.OleDb.OleDbConnection
    }
    $connection.ConnectionString = $connectionString
    $command = $connection.CreateCommand()
    $command.CommandText = $query
    if ($pscmdlet.shouldprocess($query)) {
        $connection.Open()
        $command.ExecuteNonQuery()
        $connection.close()
    }
}
