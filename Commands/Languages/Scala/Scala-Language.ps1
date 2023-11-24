
function Language.Scala {
<#
.SYNOPSIS
    Scala Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Scala.
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
    The Scala Template Transpiler will consider the following syntax to be empty:
    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.(?>scala|sc)$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Scala'
    $startComment = '/\*'
$endComment   = '\*/'
$Whitespace   = '[\s\n\r]{0,}'
$IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
$startPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Scala")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

