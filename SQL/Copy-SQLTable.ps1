function Copy-SQLTable {

[CmdletBinding()]

Param(

[string]$TableName,

[string]$SourceServer,

[string]$SourceDataBase,

[string]$TargetDatabase,

[string]$TargetServer
)


$SourceConnectionString = "server=$SourceServer;database=$SourceDataBase;trusted_connection=true"
$TargetConnectionString = "server=$TargetServer;database=$TargetDatabase;trusted_connection=true"

$Data = Get-DatabaseData -connectionString $SourceConnectionString -query "Select * from $TableName" -isSQLServer
$Data = $Data[1..($Data.Count)]

$Columns = (Get-DatabaseData -connectionString $SourceConnectionString -query "SELECT COLUMN_NAME FROM $SourceDataBase.information_schema.columns WHERE  table_name = '$TableName' ORDER  BY ORDINAL_POSITION" -isSQLServer).Column_Name

    foreach ($c in $Columns){$InsertColumns += $c+','}

$InsertColumns=$InsertColumns.Trim(',')

    Foreach ($Value in $Data) {

            $array = $Value.ItemArray
            foreach ($a in $array){
                $values += "'"+$a+"'"+','
            }
            $Values = $Values.Trim(',')
            $query = "Insert Into $TableName ($InsertColumns) Values ($Values)"
            $Values = $null


        Invoke-DatabaseQuery -connectionString $TargetConnectionString -query $query -isSQLServer
    }
}

Copy-SQLTable