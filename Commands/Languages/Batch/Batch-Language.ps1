
function Language.Batch {
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
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Batch'
    $startComment = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\{)'
$endComment   = '(?>(?>\:\:|rem)\s{0,}(?:PipeScript)?\s{0,}\})'
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})"
$LinePattern   = "^\s{0,}(?>\:\:|rem)\s{0,}"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Batch")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

