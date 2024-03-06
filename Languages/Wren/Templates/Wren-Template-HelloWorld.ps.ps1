[ValidatePattern("Wren")]
param()

Template function HelloWorld.wren {
    <#
    .SYNOPSIS
        Hello World in Wren
    .DESCRIPTION
        A Template for Hello World, in Wren.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [vbn()]
    [string]
    $Message = "hello world"
    )
    process {
@"
System.print("$message")
"@
    }
}
