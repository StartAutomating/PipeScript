[ValidatePattern("Crystal\s")]
param()
Template function HelloWorld.cr {
    <#
    .SYNOPSIS
        Hello World in Crystal
    .DESCRIPTION
        A Template for Hello World, in Crystal.
    #>
    param(
    # The message to print.  By default, "hello world".
    [vbn()]
    [string]
    $Message = "hello world"
    )
    process {
@"
puts "$message"
"@
    }
}
