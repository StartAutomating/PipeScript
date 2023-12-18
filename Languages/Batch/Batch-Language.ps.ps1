Language function Batch {
<#
.SYNOPSIS
    Batch Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Windows Batch Scripts.

    Because Batch Scripts only allow single-line comments, this is done using a pair of comment markers.
            

    ```batch    
    :: {

    :: Uncommented lines between these two points will be ignored

    :: # Commented lines will become PipeScript / PowerShell.
    :: param($message = 'hello world')
    :: "echo $message"

    :: }
    ```
.EXAMPLE
Invoke-PipeScript {
    $batchScript = '    
:: {

:: # Uncommented lines between these two points will be ignored

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
)

# Batch files are named .cmd
$FilePattern = '\.cmd$'

# We start off by declaring a number of regular expressions:
$startComment = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\{)'
$endComment   = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\})'        
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})"

# Using -LinePattern will skip any inline code not starting with :: or rem.
$LinePattern   = "^\s{0,}(?>\:\:|rem)\s{0,}"

# If we're on windows, we can run cmd as the batch interpreter
$interpreter   = if ($IsWindows) {
    @($ExecutionContext.SessionState.InvokeCommand.GetCommand('cmd', 'Application'))[0], "/c"
}
 
}