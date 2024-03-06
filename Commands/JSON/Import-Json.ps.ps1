[ValidatePattern("JSON")]
param()

function Import-Json
{
    <#
    .SYNOPSIS
        Imports json
    .DESCRIPTION
        Imports json files and outputs PowerShell objects    
    .PARAMETER LiteralPath
        Specifies the path to the XML files.
        Unlike Path , the value of the LiteralPath parameter is used exactly as it's typed.
        No characters are interpreted as wildcards.
        If the path includes escape characters, enclose it in single quotation marks.
        Single quotation marks tell PowerShell not to interpret any characters as escape sequences.
    .PARAMETER Path
        Specifies the path to the XML files.
    .PARAMETER First
        Gets only the specified number of objects. Enter the number of objects to get.
    .PARAMETER Skip 
        Ignores the specified number of objects and then gets the remaining objects. Enter the number of objects to skip.
    #>
    [Inherit("Import-Clixml",Abstract,ExcludeParameter='IncludeTotalCount')]
    [CmdletBinding(SupportsPaging)]
    param(
    # The delimiter between objects.
    # If a delimiter is provided, the content will be split by this delimeter.
    [vbn()]
    [string]
    $Delimiter
    )

    process {
        $FileSplat = [Ordered]@{}
    
        if ($path) { $FileSplat['Path'] = $path}
        elseif ($literalPath) { $FileSplat['LiteralPath'] = $path = $literalPath }

        $fileContent = Get-Content @FileSplat -Raw
        if (-not $fileContent) { return }
        
        if ($Delimiter) {
            foreach ($delimitedSegment in 
                $fileContent -split "(?<=[\]\}])$([Regex]::Escape($Delimiter))(?=[\[\{])"
            ) {
                try {
                    $delimitedSegment | ConvertFrom-Json
                } catch {
                    Write-Error "'$($path)': $($_.Exception.Message)" -TargetObject $delimitedSegment                                    
                }
            }
        } else {
            try {
                $fileContent | ConvertFrom-Json
            } catch {
                Write-Error "'$($path)': $($_.Exception.Message)" -TargetObject $fileContent
                return                
            }
        }
    }
}
