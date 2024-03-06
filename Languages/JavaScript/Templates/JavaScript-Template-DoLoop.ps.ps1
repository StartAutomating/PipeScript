[ValidatePattern("JavaScript")]
param()

Template function DoLoop.js {
    <#
    .SYNOPSIS
        Template for a JavaScript `do` Loop
    .DESCRIPTION
        Template for a `do` loop in JavaScript.
    .EXAMPLE
        Template.DoLoop.js -Condition "false" -Body "console.log('This happens once')"
    #>    
    param(    
    # The Loop's Condition.
    # This determines if the loop should continue running.
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
        if ($Condition -match '^\$') {
            $Condition = $Condition -replace '^\$'
        }        
        @"
do {
    $Body
} ($Condition)
"@
    }
}


