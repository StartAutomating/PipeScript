Template function ForEachLoop.js {
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
    [vbn()]    
    [string]
    $Variable,

    # The For Loop's Condition.
    # This determine if the loop should continue running.
    [vbn()]
    [string]
    $Condition,
    
    # The body of the loop
    [vbn()]
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

