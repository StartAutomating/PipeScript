
function Signal.Nothing {


    <#
    .SYNOPSIS
        Outputs Nothing
    .DESCRIPTION
        Outputs nothing, unless debugging or verbose.  
        
        If debugging, signals a PowerShell event with the .Arguments, .Input, and .Invocation
    .EXAMPLE
        1..1mb | Signal.Nothing
    .EXAMPLE
        1..1kb | null
    #>
    [Alias('null','nil','Signal.Null','Out-Nothing')]
    param()
    
    if (($DebugPreference -ne 'continue') -or 
        ($VerbosePreference -ne 'continue')) {
        $null = New-Event -SourceIdentifier $MyInvocation.InvocationName -MessageData ([PSCustomObject][Ordered]@{
            Arguments  = $args
            Input      = @($input)
            Invocation = $MyInvocation
        })
    }


}

