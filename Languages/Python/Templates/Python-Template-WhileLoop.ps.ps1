[ValidatePattern("Python")]
param()

Template function WhileLoop.py {
    <#
    .SYNOPSIS
        Template for a Python `while` Loop
    .DESCRIPTION
        Template for a `while` loop in Python.
    .EXAMPLE
        Template.WhileLoop.py -Condition "false" -Body 'print("This never happens")'
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
        if ($Condition -match '^(?>true|false)$') {
            $Condition = $Condition.Substring(0,1).ToUpper() + $Condition.Substring(1).ToLower()
        }
        '' + 
            $(if ($Indent) {(' ' * $Indent)}) +
            (@"
while ${Condition}:
$(' ' * $BodyIndent)$(
    $Body -split "(?>\r\n|\n)" -join ([Environment]::NewLine + $(' ' * $BodyIndent))
)
"@ -split '(?>\r\n|\n)' -join ([Environment]::NewLine + $(' ' * $Indent)))        
    }
}


