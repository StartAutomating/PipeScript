[ValidatePattern("JavaScript")]
param()


function Template.HelloWorld.js {

    <#
    .SYNOPSIS
        Hello World in JavaScript
    .DESCRIPTION
        A Template for Hello World, in JavaScript.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
console.log("$message")
"@
    }

}


