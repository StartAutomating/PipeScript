[ValidatePattern("Python")]
param()

Template function DoLoop.py {
    <#
    .SYNOPSIS
        Template for a Python `do` Loop
    .DESCRIPTION
        Template for a `do` loop in Python.
    .NOTES
        There is not a proper `do` loop in Python, so we have to be a little creative.

        This will produce a while loop where the `-InitialCondition` should always be true,
        and the `-Condition` will be checked at the end of each loop.

        If the `Condition` is false, then the loop will break.
    .EXAMPLE
        Template.DoLoop.py -Condition "False" -Body "print('This happens once')"
    #>    
    param(    
    # The Loop's Condition.
    # This determines if the loop should continue running.
    # This defaults to 0 > 1, so that the loop only occurs once
    [vbn()]
    [string]
    $Condition = "False",

    # The Loop's Initial Condition.
    # Since Python does not have a `do` loop, this needs to be any truthy condition for the loop to run.
    [vbn()]
    [string]
    $InitialCondition = 'True',
    
    # The body of the loop
    [vbn()]
    [string]
    $Body,

    # The number of spaces to indent the body.
    # By default, two.
    [vbn()]
    [int]
    $BodyIndent = 2,

    # The number of spaces to indent all code.
    # By default, zero
    [vbn()]
    [int]
    $Indent = 0
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }        
        if ($Condition -match '^\$') {
            $Condition = $Condition -replace '^\$'
        }
        '' + 
            $(if ($Indent) {(' ' * $Indent)}) +
            (@"
while ${InitialCondition}:
$(' ' * $BodyIndent)$(
    $Body -split "(?>\r\n|\n)" -join ([Environment]::NewLine + $(' ' * $BodyIndent))
)
$(' ' * $BodyIndent)$(
    "if not ${Condition}:$(
        [Environment]::NewLine + (' ' * $BodyIndent * 2)
    )break"
)
"@ -split '(?>\r\n|\n)' -join ([Environment]::NewLine + $(' ' * $Indent)))
    }
}


