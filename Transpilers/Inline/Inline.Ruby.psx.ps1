<#
.SYNOPSIS
    Ruby Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Ruby with Inline PipeScript into Ruby.

    PipeScript can be embedded in a multiline block that starts with ```=begin{``` and ends with } (followed by ```=end```)
#>
[ValidatePattern('\.rb$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
[Management.Automation.CommandInfo]
$CommandInfo,

# A dictionary of parameters.
[Collections.IDictionary]
$Parameter,

# A list of arguments.
[PSObject[]]
$ArgumentList
)

begin {
    # We start off by declaring a number of regular expressions:
    
    $startComment = '(?>[\r\n]{1,3}\s{0,}=begin[\s\r\n]{0,}\{)'
    $endComment   = '(?>}[\r\n]{1,3}\s{0,}=end)'

    $ignoreEach = '[\d\.]+',
        '""',
        "''"

    $IgnoredContext = "(?<ignore>(?>$($ignoreEach -join '|'))\s{0,}){0,1}"
    
    $startRegex = "(?<PSStart>${IgnoredContext}${startComment})"    
    $endRegex   = "(?<PSEnd>${endComment}${IgnoredContext})"
    
    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
    }
}

process {
    # Add parameters related to the file
    $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
    $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }

    # Call the core inline transpiler.
    .>PipeScript.Inline @Splat
}
