[ValidatePattern("(?>Basic|Language)")]
param()

Language function BASIC {
<#
.SYNOPSIS
    BASIC Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Basic, Visual Basic, and Visual Basic Scripts.

    Because Basic only allow single-line comments, this is done using a pair of comment markers.

    A single line comment, followed by a { (or PipeScript { ) begins a block of pipescript.

    A single line comment, followed by a } (or PipeScript } ) ends a block of pipescript.

    Only commented lines within this block will be interpreted as PipeScript.
            
    ```VBScript    
    rem {

    rem # Uncommented lines between these two points will be ignored

    rem # Commented lines will become PipeScript / PowerShell.
    rem param($message = "hello world")
    rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
    rem }
    ```
.EXAMPLE
Invoke-PipeScript {
    $VBScript = '    
rem {

rem # Uncommented lines between these two points will be ignored

rem # Commented lines will become PipeScript / PowerShell.
rem param($message = "hello world")
rem "CreateObject(`"WScript.Shell`").Popup(`"$message`")" 
rem }
'

    [OutputFile('.\HelloWorld.ps1.vbs')]$VBScript
}

Invoke-PipeScript .\HelloWorld.ps1.vbs
#>
[ValidatePattern('\.(?>bas|vbs{0,1})$')]
param(
)
$FilePattern = '\.(?>bas|vbs{0,1})$'

# We start off by declaring a number of regular expressions:
$SingleLineCommentStart = '(?>''|rem)'
$startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)\s{0,}(?:PipeScript)?\s{0,}\{)"
$endComment   = "(?>$SingleLineCommentStart\s{0,}(?:PipeScript)?\s{0,}\})"
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})" 
$LinePattern   = "^\s{0,}$SingleLineCommentStart\s{0,}"

$Compiler = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('dotnet', 'Application'))[0], 'build'  # To compile VB.Net, we'll use dotnet build 

$Runner  = @($ExecutionContext.SessionState.InvokeCommand.GetCommand('dotnet', 'Application'))[0], 'run' # Get the first dotnet, if present
}