Template function HelloWorld.rb {
    <#
    .SYNOPSIS
        Hello World in Ruby
    .DESCRIPTION
        A Template for Hello World, in Ruby.    
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
