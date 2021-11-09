using namespace System.Data
using namespace System.Collections.Generic


<#
.SYNOPSIS
 Convert a DataRow object to a hashtable or pscustomobject.

.DESCRIPTION
 Convert a DataRow object to a hashtable or pscustomobject. Attempt to
 efficiently convert by reading the table column names from the first object
 and re-use for each subsequent object.

.PARAMETER InputObject
 The DataRow(s) to convert

.PARAMETER AsObject
 Return PSCustomObject instead of OrderedDictionary

.NOTES
 Works well with SimplySql module.

#>
function ConvertFrom-DataRow {

    [CmdletBinding( DefaultParameterSetName = 'AsHashtable' )]
    [OutputType( [System.Collections.Specialized.OrderedDictionary], ParameterSetName = 'AsHashtable' )]
    [OutputType( [pscustomobject], ParameterSetName = 'AsObject' )]
    param(
    
        [Parameter( Mandatory, Position = 0, ValueFromPipeline = $true )]
        [DataRow[]]
        $InputObject,

        [Parameter( Mandatory, ParameterSetName = 'AsObject' )]
        [switch]
        $AsObject
    
    )

    begin {
    
        [List[string]]$Columns = @()
    
    }

    process {

        foreach ( $DataRow in $InputObject ) {
            
            if ( $Columns.Count -eq 0 ) {

                Write-Verbose 'Getting columns from first row.'

                $Columns.AddRange( [string[]]$DataRow.Table.Columns.ColumnName )

            }

            $ReturnObject = [ordered]@{}
            $Columns | ForEach-Object { $ReturnObject[$_] = $DataRow.$_ }

            if ( $AsObject ) {

                Write-Output ( [pscustomobject]$ReturnObject )

            } else {

                Write-Output ( $ReturnObject )

            }

        }
    
    }

}
