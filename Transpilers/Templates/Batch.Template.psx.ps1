<#
.SYNOPSIS
    Batch Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Windows Batch Scripts.

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
[ValidatePattern('\.cmd$')]
param(
# The command information.  This will include the path to the file.
[Parameter(Mandatory,ValueFromPipeline,ParameterSetName='TemplateFile')]
[Management.Automation.CommandInfo]
$CommandInfo,

# If set, will return the information required to dynamically apply this template to any text.
[Parameter(Mandatory,ParameterSetName='TemplateObject')]
[switch]
$AsTemplateObject,

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
    $startRegex = "(?<PSStart>${startComment})"
    $endRegex   = "(?<PSEnd>${endComment})"

    # Create a splat containing arguments to the core inline transpiler
    $Splat      = [Ordered]@{
        StartPattern  = $startRegex
        EndPattern    = $endRegex
         # Using -LinePattern will skip any inline code not starting with :: or rem.
        LinePattern   = "^\s{0,}(?>\:\:|rem)\s{0,}"
    }
}

process {
    # If we have been passed a command
    if ($CommandInfo) {
        # add parameters related to the file.
        $Splat.SourceFile = $commandInfo.Source -as [IO.FileInfo]
        $Splat.SourceText = [IO.File]::ReadAllText($commandInfo.Source)
    }
    
    if ($Parameter) { $splat.Parameter = $Parameter }
    if ($ArgumentList) { $splat.ArgumentList = $ArgumentList }

    # If we are being used within a keyword,
    if ($AsTemplateObject) {
        $splat # output the parameters we would use to evaluate this file.
    } else {
        # Otherwise, call the core template transpiler
        .>PipeScript.Template @Splat # and output the changed file.
    }
}
