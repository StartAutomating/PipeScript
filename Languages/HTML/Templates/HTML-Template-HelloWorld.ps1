
function Template.HelloWorld.html {

    <#
    .SYNOPSIS
        Hello World in HTML
    .DESCRIPTION
        A Template for Hello World, in HTML.    
    #>
    param(
    # The message to print.  By default, "hello world".
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Message = "hello world"
    )
    process {
@"
<p>
$([Security.SecurityElement]::Escape($message))
</p>
"@
    }

}


