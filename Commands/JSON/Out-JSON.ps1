[ValidatePattern("JSON")]
param()

function Out-JSON {

    <#
    .SYNOPSIS
        Outputs objects as JSON
    .DESCRIPTION
        Outputs objects in JSON.

        If only one object is outputted, it will not be in a list.
        If multiple objects are outputted, they will be in a list.
    .LINK
        @{
            a = 'b'
        } | Out-JSON
    #>
    [CmdletBinding(PositionalBinding=$false)]
    [Alias('text.json.out')]
    param(
    # The input object.  This will form the majority of the JSON.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $InputObject,
    
    # Any arguments.  These will be appended to the input.
    [Parameter(ValueFromRemainingArguments=$true)]
    [PSObject[]]
    $ArgumentList,
    
    # The depth of the JSON.  By default, this is the FormatEnumerationLimit.
    [int]
    $Depth = $FormatEnumerationLimit
    )

    $inputAndArguments = @( $input ) + $ArgumentList
    if (-not $depth) { 
        $depth = if ($FormatEnumerationLimit) {
            $FormatEnumerationLimit
        } else {
            4        
        }
    }
    if ($inputAndArguments.Length -eq 1) {
        ConvertTo-Json -InputObject $inputAndArguments[0] -Depth $Depth
    } else {
        $inputAndArguments | ConvertTo-Json -Depth $Depth
    }

}

