
function Language.Lua {
<#
    .SYNOPSIS
        LUA Template Transpiler.
    .DESCRIPTION
        Allows PipeScript to generate LUA.
        Multiline comments like ```--{[[```  ```--}]]``` will be treated as blocks of PipeScript.    
    #>
[ValidatePattern('\.lua$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Lua'
    $startComment = '\-\-\[\[\{'
$endComment   = '--\}\]\]'
$Whitespace   = '[\s\n\r]{0,}'
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Lua")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


