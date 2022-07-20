<#
.SYNOPSIS
    Rust Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Rust with Inline PipeScript into Rust.

    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.rs$') {
        return $true
    }
    return $false    
})]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline)]
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
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endRegex   = "(?<PSEnd>$Whitespace\}${endComment})"
    
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
