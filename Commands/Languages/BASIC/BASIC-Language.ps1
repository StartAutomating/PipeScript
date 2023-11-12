
function Language.BASIC {
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
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition =
New-Module {
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
# We start off by declaring a number of regular expressions:
$startComment = '(?>(?<IsSingleLine>(?>''|rem))\s{0,}(?:PipeScript)?\s{0,}\{)'
$endComment   = '(?>(?>''|rem)\s{0,}(?:PipeScript)?\s{0,}\})'        
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})" 
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language.BASIC")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

