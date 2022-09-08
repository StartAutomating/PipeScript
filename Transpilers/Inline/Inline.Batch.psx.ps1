<#
.SYNOPSIS
    Batch PipeScript Transpiler.
.DESCRIPTION
    Transpiles Windows Batch with Inline PipeScript into Batch Scripts.

    Because Batch Scripts only allow single-line comments, this is done using a pair of comment markers.
            

    ```batch    
    :: {

    Uncommented lines between these two points will be ignored

    :: # Commented lines will become PipeScript / PowerShell.
    :: param($message = 'hello world')
    :: "echo $message"

    :: }
    ```
.EXAMPLE
    Invoke-PipeScript {
        $batchScript = '    
    :: {

    Uncommented lines between these two points will be ignored

    :: # Commented lines will become PipeScript / PowerShell.
    :: param($message = "hello world")
    :: "echo $message"

    :: }
    '
    
        [OutputFile('.\HelloWorld.ps1.cmd')]$batchScript
    }

    Invoke-PipeScript .\HelloWorld.ps1.cmd
#>
[ValidateScript({
    $cmdInfo = $_
    if ($cmdInfo.Source -match '\.cmd$') {
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
    $startComment = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\})'    
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $startRegex = "(?<PSStart>${startComment})"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $endRegex   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
        LinePattern   = "^\s{0,}(?>\:\:|rem)\s{0,}"
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
