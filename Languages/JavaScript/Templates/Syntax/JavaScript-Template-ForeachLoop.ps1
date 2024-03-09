[ValidatePattern("JavaScript")]
param()


function Template.ForEachLoop.js {

    <#
    .SYNOPSIS
        Template for a JavaScript `for (..in..)` Loop
    .DESCRIPTION
        Template for a `for (..in..)` loop in JavaScript.
    .EXAMPLE
        Template.ForEachLoop.js "variable" "object" 'statement'           
    #>
    [Alias('Template.ForInLoop.js')]
    param(
    # The For Loop's Initialization.
    # This initializes the loop.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string]
    $Variable,

    # The For Loop's Condition.
    # This determine if the loop should continue running.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Condition,
    
    # The body of the loop
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Body
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        if ($variable -match '^\$') {
            $variable = $variable -replace '^\$'
        }
        if ($Condition -match '^\$') {
            $Condition = $Condition -replace '^\$'
        }        
        @"
for ($variable in $Condition) {
    $Body
}
"@
    }

}



