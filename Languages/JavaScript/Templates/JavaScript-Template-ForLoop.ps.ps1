Template function ForLoop.js {
    <#
    .SYNOPSIS
        Template for a JavaScript `for` Loop
    .DESCRIPTION
        Template for a `for` loop in JavaScript.
    .EXAMPLE
        Template.ForLoop.js "let step = 0" "step < 5" "step++" 'console.log("walking east one step")'
    .EXAMPLE
        Template.ForLoop.js -Initialization "let step = 0" -Condition "step < 5" -Iterator "step++" -Body '
            console.log("walking east one step")
        '
    #>
    param(
    # The For Loop's Initialization.
    # This initializes the loop.
    [vbn()]
    [Alias('Initializer')]
    [string]
    $Initialization,

    # The For Loop's Condition.
    # This determine if the loop should continue running.
    [vbn()]
    [string]
    $Condition,
    # The For Loop's Iterator, or Afterthought.
    # This occurs after each iteration of the loop
    [vbn()]
    [Alias('Iterator')]
    [string]
    $Afterthought,

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
        if ($Afterthought -match '^\$') {
            $Afterthought = $Afterthought -replace '^\$'
        }
        @"
for ($Initialization;$Condition;$Afterthought) {
    $Body
}
"@
    }
}
