<#
.SYNOPSIS
    Python Inline PipeScript Transpiler.
.DESCRIPTION
    Transpiles Python with Inline PipeScript into Python.

    Because Python does not support multiline comment blocks, PipeScript can be written inline inside of multiline string

    PipeScript can be included in a Python string that starts and ends with ```{}```, for example ```"""{}"""```
.Example
    .> {
       $pythonContent = @'
"""{
$msg = "Hello World", "Hey There", "Howdy" | Get-Random
@"
print("$msg")
"@
}"""
'@
        [OutputFile('.\HelloWorld.ps1.py')]$PythonContent
    }

    .> .\HelloWorld.ps1.py
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.py$') {
        return $true
    }
    return $false    
})]
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
    
    $startComment = '(?>"""\{)'
    $endComment   = '(?>\}""")'
    
    $startRegex = "(?<PSStart>${startComment})"    
    $endRegex   = "(?<PSEnd>${endComment})"
    
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
