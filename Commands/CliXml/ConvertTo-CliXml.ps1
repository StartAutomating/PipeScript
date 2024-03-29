function ConvertTo-CliXml
{
    <#
    .Synopsis
        Converts PowerShell objects into CliXML
    .Description
        Converts PowerShell objects into CliXML strings or compressed CliXML strings
    .Example
        dir | ConvertTo-Clixml
    .Link
        ConvertFrom-Clixml
    .Link
        Import-Clixml
    .Link
        Export-Clixml
    #>
    [OutputType([string])]
    param(
    # The input object
    [Parameter(Mandatory,Position=0,ValueFromPipeline)]
    [PSObject[]]
    $InputObject,

    # The depth of objects to serialize.
    # By default, this will be the $FormatEnumerationLimit.
    [int]
    $Depth
    )

    # $input is an old part of PowerShell that contains the entire unmodified pipeline input
    # Since this command only needs an end block, this is slightly faster than keeping our own input queue.
    $inputObjects = @($input)

    # If depth was not provided, or was negative
    if ($Depth -le 0) {
        $Depth = # default to the $FormatEnumerationLimit, if present        
            if ($FormatEnumerationLimit) {
                $FormatEnumerationLimit
            } else { 4 } # (otherwise, 4).
    } 
    
    #region Serialize
    switch ($inputObjects.Length) {
        0 { 
            break
        }
        1 {
            # If there was a single item, only serialize that (otherwise we'd be weirding the return)
            [Management.Automation.PSSerializer]::Serialize($inputObjects[0], $depth)
        }
        default {
            [Management.Automation.PSSerializer]::Serialize($inputObjects, $depth)
        }
    }                
    #endregion Serialize
} 
