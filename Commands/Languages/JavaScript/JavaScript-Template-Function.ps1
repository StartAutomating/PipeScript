
function Template.Function.js {

    <#
    .SYNOPSIS
        Template for a JavaScript `function`
    .DESCRIPTION
        Template for a `function` in JavaScript.
    .EXAMPLE
        Template.Function.js -Name "Hello" -Body "return 'hello'"
    #>
    [Alias('Template.ForInLoop.js')]
    param(    
    # The name of the function.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Arguments','Parameter','Parameters')]
    [string[]]
    $Argument,
    
    # The body of the function.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Body
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }                        
        @"
function $(if ($name) { $name})($argument) {
    $($Body -join (';' + [Environment]::newLine + '    '))
} 
"@
    }

}



