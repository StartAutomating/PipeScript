Signal function Out {
    <#
    .SYNOPSIS
        Outputs a Signal
    .DESCRIPTION
        Outputs a Signal with whatever name, arguments, input, and command.

        A signal is a PowerShell event.
    .EXAMPLE
        Out-Signal "hello"
    .EXAMPLE
        Set-Alias MySignal Out-Signal
        MySignal
    #>
    [Alias('Out-Signal','Out.Signal')]
    param()

    process {
        New-Event -SourceIdentifier $MyInvocation.InvocationName -MessageData ([PSCustomObject][Ordered]@{
            Arguments = $args
            Input     = $input
            Command   = $MyCommandAst
        })
    }
}