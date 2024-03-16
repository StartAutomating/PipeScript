[ValidatePattern("Go[\s\p{P}]")]
param()


function Template.HelloWorld.go {

    <#
    .SYNOPSIS
        Hello World in Go
    .DESCRIPTION
        A Template for Hello World, in Go.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
package main

import "fmt"

func main() {
    fmt.Println("$Message")
}
"@
    }

}


