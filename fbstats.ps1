$database=$args[0]
$statname=$args[1]
$command='C:\Program Files\Firebird\Firebird_4_0\isql.exe'
$dbpath="$database"
$sqlfile="statsquery.sql"
"select MON`$$statname from mon`$io_stats mios, mon`$database mdb WHERE mios.mon`$stat_id = mdb.mon`$stat_id AND mdb.MON`$DATABASE_NAME='$database';" |Out-File -Encoding ascii -FilePath "$sqlfile"
$output = cmd /c $command -U sysdba -q -i $sqlfile $dbpath 2`>`&1

$obj = $output | Where-Object {
    $_ -match '^\s+(\d+)\s+'
} | ForEach-Object {
    New-Object -Type PSObject -Property @{
        'value'           = $matches[1]
    }
}
Write-Host $obj.value