
function Language.Haxe {
<#
    .SYNOPSIS
        Haxe Template Transpiler.
    .DESCRIPTION
        Allows PipeScript to generate Haxe.
        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
        The Haxe Inline Transpiler will consider the following syntax to be empty:
        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.hx$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Haxe'
    $startComment = '/\*'
$endComment   = '\*/'
$Whitespace   = '[\s\n\r]{0,}'
$IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
$StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
$EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Haxe")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

