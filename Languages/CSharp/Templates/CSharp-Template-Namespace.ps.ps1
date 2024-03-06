[ValidatePattern("CSharp")]
param()

Template function Namespace.cs {
    <#
    .SYNOPSIS
        Template for CSharp Namespaces
    .DESCRIPTION
        A Template for a CSharp Namespace Definition
    #>
    param(
    # The namespace.
    [vbn()]
    [string]
    $Namespace,

    # One or more namespace this namespaces will use.
    [vbn()]
    [string[]]
    $Using,

    # The body of the namespace.
    [vbn()]
    [Alias('Members','Member')]
    [string[]]
    $Body
    )

    begin {
        $fixUsings = '^\s{0,}(?:using:\s{0,})?', 'using '
    }
    process {
@"
$(if ($using -and -not $body) {
($using -replace $fixUsings -join [Environment]::NewLine) + [Environment]::NewLine
})namespace $namespace$(if (-not $body) {';'})$(if ($body) {
    @('{'
        $body -join [Environment]::NewLine
    '}') -join [Environment]::NewLine
})
"@
    }    
}
