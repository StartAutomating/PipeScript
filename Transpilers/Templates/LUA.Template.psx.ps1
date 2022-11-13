<#
.SYNOPSIS
    LUA Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles LUA with Inline PipeScript into LUA.

    Multiline comments like ```--{[[```  ```--}]]``` will be treated as blocks of PipeScript.    
#>
[ValidatePattern('\.lua$')]
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
    $startComment = '\-\-\[\[\{' # * Start Comments ```--[[{```
    $endComment   = '--\}\]\]'   # * End Comments   ```--}]]```
    $Whitespace   = '[\s\n\r]{0,}'        
    $startRegex = "(?<PSStart>${startComment})"    
    $endRegex   = "(?<PSEnd>${endComment}\s{0,})"

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
