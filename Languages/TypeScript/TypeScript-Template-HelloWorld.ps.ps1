Template function HelloWorld.ts {
    <#
    .SYNOPSIS
        Hello World in TypeScript
    .DESCRIPTION
        A Template for Hello World, in TypeScript.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [vbn()]
    [string]
    $Message = "hello world"
    )
    process {
@"
let message: string =  '$($Message -replace "'","''")';
console.log(message);
"@
    }
}
