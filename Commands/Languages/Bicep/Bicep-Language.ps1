
function Language.Bicep {
<#
    .SYNOPSIS
        Bicep Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Bicep templates.
        Multiline comments blocks like ```/*{}*/``` will be treated as blocks of PipeScript.
        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
        * ```''```
        * ```{}```
    #>
[ValidatePattern('\.bicep$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Bicep'
    $startComment = '/\*'
$endComment   = '\*/'
$Whitespace   = '[\s\n\r]{0,}'
$IgnoredContext = "(?<ignore>(?>$("''", "\{\}" -join '|'))\s{0,}){0,1}"
$StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
$EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Bicep")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


