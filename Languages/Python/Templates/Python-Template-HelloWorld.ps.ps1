[ValidatePattern("Python")]
param()

Template function HelloWorld.py {
    <#
    .SYNOPSIS
        Hello World in Python
    .DESCRIPTION
        A Template for Hello World, in Python.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [vbn()]
    [string]
    $Message = "hello world"
    )
    process {
@"
print("$message")
"@
    }
}
