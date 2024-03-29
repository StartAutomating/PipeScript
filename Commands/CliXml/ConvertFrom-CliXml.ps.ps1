function ConvertFrom-CliXml
{
    <#
    .Synopsis
        Converts CliXml into PowerShell objects
    .Description
        Converts CliXml strings or compressed CliXml strings into PowerShell objects
    .Example
        dir | ConvertTo-Clixml | ConvertFrom-Clixml
    .Link
        ConvertTo-Clixml
    .Link
        Import-Clixml
    .Link
        Export-Clixml
    #>
    [OutputType([string])]
    param(
    # The input object.
    # This is expected to be a CliXML string or XML object
    [Parameter(Mandatory,Position,ValueFromPipeline)]
    [ValidateTypes(TypeName={[string], [xml]})]
    [PSObject]
    $InputObject
    )

    process {                
        $inputAsXml = $InputObject -as [xml]
        [Management.Automation.PSSerializer]::Deserialize($(
            if ($inputAsXml) {
                $inputAsXml.OuterXml
            } else {
                $InputObject
            }
        ))
    }
} 
 
