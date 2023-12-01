function ConvertFrom-CliXml {


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
    [ValidateScript({
    $validTypeList = [System.String],[System.Xml.XmlDocument]
    
    $thisType = $_.GetType()
    $IsTypeOk =
        $(@( foreach ($validType in $validTypeList) {
            if ($_ -as $validType) {
                $true;break
            }
        }))
    
    if (-not $isTypeOk) {
        throw "Unexpected type '$(@($thisType)[0])'.  Must be 'string','xml'."
    }
    return $true
    })]
    
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
 

