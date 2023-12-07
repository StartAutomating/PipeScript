
function Template.RegexLiteral.js {

    <#
    .SYNOPSIS
        Template for a JavaScript regex literal
    .DESCRIPTION
        Template for regex literal in JavaScript.
    .EXAMPLE
        Template.RegexLiteral.js -Pattern "\d+" 
    #>
    [Alias('Template.Regex.js')]    
    param(    
    # The pattern.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Expression','RegularExpression','RegEx')]
    [string]
    $Pattern,

    # The regular expression flags
    [Alias('Flags')]
    [ValidateSet("d","hasIndices","g","global","i","ignoreCase","m","multiline","s","dotAll","u","unicode","v","unicodeSets","y","sticky")]
    [string[]]
    $Flag
    )

    process {
$flag = foreach ($FlagString in $Flag) {
    if ($FlagString.Length -gt 1) {
        $valueList = @($MyInvocation.MyCommand.Parameters.Flag.Attributes.ValidValues)
        for ($valueIndex = 0; $valueIndex -lt $valueList.Length; $valueIndex++) {
            if ($FlagString -eq $valueList[$valueList]) {
                $valueList[$valueIndex - 1]
            }
        }
    }
}
@"
/$pattern/$flag
"@
    }

}




