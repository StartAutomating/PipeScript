[ValidatePattern("JavaScript")]
param()


function Template.Function.js {

    <#
    .SYNOPSIS
        Template for a JavaScript `function`
    .DESCRIPTION
        Template for a `function` in JavaScript.
    .EXAMPLE
        Template.Function.js -Name "Hello" -Body "return 'hello'"    
    #>
    [Alias('Template.Method.js','Template.Generator.js')]
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
    $Body,

    # If set, the function will be marked as async
    [switch]
    $Async,

    # If set, the function will be marked as static
    [switch]
    $Static,

    # If set, the function will be marked as a generator.
    # This can be implied by calling this with the alias Template.Generator.js
    [switch]
    $Generator
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        
        switch -Regex ($MyInvocation.InvocationName) {
            "generator" {
                $generator = $true
            }            
            "function" {
@"
$(if ($async) { "async "}$(if ($static) {"static "}))function$(if ($generator) { '*'}) $(if ($name) { $name})($($argument -join ',')) {
    $($Body -join (';' + [Environment]::newLine + '    '))
} 
"@
break
            }
            default {
@"
$(if ($async) { "async "}$(if ($static) {"static "})) $(if ($name) { $name})$(if ($generator) { '*'})($($argument -join ',')) {
    $($Body -join (';' + [Environment]::newLine + '    '))
} 
"@
            }
        }
    }

}




