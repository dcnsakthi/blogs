param (
    [string] $csvFile = 'C:\Workspace\temp\Information_Schema.csv',
    [string] $schemaPrefix = 'DTL',  # You can change this to 'STG', 'DTL', or 'DTL_REP' as needed
    [string] $tablePrefix = 'DTL_REP',  # You can change this to 'DTL' or 'DTL_REP' as needed
    [string] $additionalColumns = 'CRDT [datetimeoffset](7) NOT NULL,|BRDT [datetimeoffset](7) NOT NULL'  # Comma-separated list of additional columns and data types (e.g., "column1 int, column2 varchar(255)")
)

# Load the CSV file into a PowerShell variable
$data = Import-Csv $csvFile

# Initialize a variable to store the CREATE TABLE statement
$createTableStatement = ""
$tableGroups =""

# Group the data by TABLE_NAME
$tableGroups = $data | Group-Object TABLE_NAME

# Iterate through the groups
foreach ($group in $tableGroups) {
    # Iterate through the groups
    $additionalColumnDefinitions = ""
    $columnDefinition = ""
    $primaryKeyColumns = @()
    $columnName = ""
    $tableName = $group.Name
    $tableData = $group.Group
    # Extract the domain value from the first row in the group
    $domain = $tableData[0].DOMAIN

    # Initialize the CREATE TABLE statement for the current table with the schema prefix and domain
    $fullTableName = "$schemaPrefix.$tablePrefix" + "_$domain" + "_$tableName"
    $createTableStatement += "CREATE TABLE $fullTableName (`n"

    # Iterate through the rows of the group
    foreach ($row in $tableData) {
        $columnName = $row.COLUMN_NAME
        $dataType = $row.DATA_TYPE
        $characterMaxLength = $row.CHARACTER_MAXIMUM_LENGTH
        $isNullable = $row.IS_NULLABLE
        $isPrimaryKey = $row.IS_PRIMARY_KEY

        # Exclude $characterMaxLength for certain datatypes
        if ($dataType -notmatch '^(nvarchar|varchar|char|nchar|text|ntext|int|decimal|numeric)') {
            $columnDefinition = "    $columnName $dataType"
        } else {
            if ($dataType -in ('nvarchar', 'varchar', 'char', 'nchar', 'text', 'ntext')) {
                if ($characterMaxLength -eq -1) {
                    $columnDefinition = "    $columnName $dataType(MAX)"
                } else {
                    $columnDefinition = "    $columnName $dataType($characterMaxLength)"
                }
            } else {
                $columnDefinition = "    $columnName $dataType"
            }
        }

        if ($isPrimaryKey -eq 'Y' -and $columnName -notin $primaryKeyColumns) {
            $primaryKeyColumns += $columnName
            $columnDefinition += " NOT NULL"
        }
        elseif ($isNullable -eq 'YES') {
            $columnDefinition += " NULL"
        }
        else {
            $columnDefinition += " NOT NULL"
        }

        # Add the column definition to the CREATE TABLE statement
        $createTableStatement += $columnDefinition

        # Add a comma at the end of the line unless it's the last column
        if ($row -ne $tableData[-1]) {
            $createTableStatement += ","
        }
        if ($row -eq $tableData[-1] -and $additionalColumns -ne '') {
            $createTableStatement += ","
        }
        
        $createTableStatement += "`n"
    }

    # Append the additional columns and data types to the CREATE TABLE statement
    if ($additionalColumns -ne '') {
        $additionalColumnDefinitions = $additionalColumns -split '\|' | ForEach-Object {"    $_`n" }
        $createTableStatement += $additionalColumnDefinitions
    }

    # Add the "WITH DISTRIBUTION" and "CLUSTERED INDEX" clauses based on the schema
    if ($schemaPrefix -eq 'STG') {
        $createTableStatement += ")`nWITH`n(`n    DISTRIBUTION=ROUND_ROBIN,`n    HEAP`n);`n"
    }
    elseif ($schemaPrefix -eq 'DTL') {
        $createTableStatement += ")`nWITH`n(`n    DISTRIBUTION=HASH($($primaryKeyColumns -join ', '))," +
                               "`n    CLUSTERED INDEX ($($primaryKeyColumns -join ', '))`n);`n"
    }
    elseif ($schemaPrefix -eq 'DTL_REP') {
        $createTableStatement += ")`nWITH`n(`n    DISTRIBUTION=ROUND_ROBIN," +
                               "`n    CLUSTERED INDEX ($($primaryKeyColumns -join ', '))`n);`n"
    }

    # Close the CREATE TABLE statement for the current table
    $createTableStatement += "`n"
}

# Print or save the CREATE TABLE statement
Write-Host $createTableStatement
