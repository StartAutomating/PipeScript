[ValidatePattern("JavaScript")]
param()

Template function Class.js {
    <#
    .SYNOPSIS
        Template for a JavaScript `class`
    .DESCRIPTION
        Template for a `class` in JavaScript.
    .EXAMPLE
        Template.Class.js -Name "MyClass" -Body "MyMethod() { return 'hello'}"
    #>
    param(    
    # The name of the function.
    [vbn()]
    [string]
    $Name,
    
    # The body of the function.
    [vbn()]
    [Alias('Member','Members')]
    [string[]]
    $Body,

    # If provided, will extend from a base class.
    [Alias('Extends')]
    [string]
    $Extend
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }
        
@"
class $name$(if ($Extend) { " extends $extend"}) {
    $($Body -join (';' + [Environment]::newLine + '    '))
}
"@        
    }
}


