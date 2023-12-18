Template function InvokeMethod.js {
    <#
    .SYNOPSIS
        Template for a JavaScript method invocation
    .DESCRIPTION
        Template for invocing a method in JavaScript.
    .EXAMPLE
        Template.InvokeMethod.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    .EXAMPLE
        "doSomething()" |Template.InvokeMethod.js -Name "then" -Argument "(result)=>doSomethingElse(result)"
    #>    
    param(        
    # The name of the method.
    [vbn()]
    [string]
    $Name,
    
    # The input object (this allows piping this to become chaining methods)
    [vfp()]
    [PSObject]
    $InputObject,

    # The arguments to the method
    [vbn()]
    [Alias('Arguments','Parameter','Parameters')]
    [string[]]
    $Argument,    
    
    # If set, the method return will be awaited (this will only work in an async function)
    [switch]
    $Await
    )

    process {                                
        "$(if ($await) { "await"}) $(if ($inputObject -is [string]) { $InputObject })$(if ($name) { $name -replace "^\.{0,1}", "." })($($argument -join ','))"
    }
}