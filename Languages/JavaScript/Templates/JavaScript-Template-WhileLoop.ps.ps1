[ValidatePattern("JavaScript")]
param()

Template function WhileLoop.js {
    <#
    .SYNOPSIS
        Template for a JavaScript `while` Loop
    .DESCRIPTION
        Template for a `while` loop in JavaScript.
    .EXAMPLE
        Template.WhileLoop.js -Condition "false" -Body "console.log('This never happens')"
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
while ($Condition) {
    $Body
} 
"@
    }
}


