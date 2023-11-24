
function Language.CPlusPlus {
<#
    .SYNOPSIS
        C/C++ Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate C, C++, Header or Swig files.
        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
        The C++ Inline Transpiler will consider the following syntax to be empty:
        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.(?>c|cpp|h|swig)$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'CPlusPlus'
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
$languageDefinition.pstypenames.add("Language.CPlusPlus")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

