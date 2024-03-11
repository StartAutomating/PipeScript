<#
.SYNOPSIS
    Finds metadata for a module
.DESCRIPTION
    Finds metadata for a module.

    This searches the `.PrivateData` and `.PrivateData.PSData` for keywords, and returns the values.
.NOTES
    If the value points to a `[Hashtable]`, it will return a `[PSCustomObject]` with the keys sorted.
    If the value points to a file, it will attempt to load it or return the file object.
    If the value is a string, it will return the string as a `[PSObject]`.
.EXAMPLE
    (Get-Module PipeScript).FindExtensions((Get-Module PipeScript | Split-Path))
#>
param()

$unrolledArgs = $args | . { process { $_ }}
$thisRoot = $this | Split-Path

foreach ($place in $this.PrivateData, $this.PrivateData.PSData) {
    foreach ($potentialName in $unrolledArgs) {        
        if (-not $place.$potentialName) { continue }
        $somethingThere = $place.$potentialName
        if ($somethingThere -as [hashtable[]]) {
            foreach ($hashtable in $somethingThere) {
                $propertyBag = [Ordered]@{}
                foreach ($sortedKeyValue in $hashtable.GetEnumerator() | Sort-Object Key) {
                    $propertyBag[$sortedKeyValue.Key]= $sortedKeyValue.Value
                }
                [PSCustomObject]$propertyBag
            }
        } 
        elseif (Test-Path (Join-Path $ThisRoot "$somethingThere")) {
            $fileItem = Get-Item -LiteralPath (Join-Path $ThisRoot "$somethingThere")
            $importer = @(
                $ExecutionContext.SessionState.InvokeCommand.GetCommands(
                    "Import-$($fileItem.Extension)",
                    'Alias,Function,Cmdlet', $true
                )
            )[0]
            if ($importer) {
                & $importer $fileItem.FullName
            } else {
                $fileItem
            }
        }
        elseif ($somethingThere) {
            [PSObject]::new($somethingThere)
        }
    }
}
