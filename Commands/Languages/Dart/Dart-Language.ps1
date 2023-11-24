
function Language.Dart {
<#
    .SYNOPSIS
        Dart Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Dart.
        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
        The Dart Template Transpiler will consider the following syntax to be empty:
        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.(?>dart)$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Dart'
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
$languageDefinition.pstypenames.add("Language.Dart")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


