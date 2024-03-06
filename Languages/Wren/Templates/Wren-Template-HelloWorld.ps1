
function Template.HelloWorld.wren {

    <#
    .SYNOPSIS
        Hello World in Wren
    .DESCRIPTION
        A Template for Hello World, in Wren.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
System.print("$message")
"@
    }

}


