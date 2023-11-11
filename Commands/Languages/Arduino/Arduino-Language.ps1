
function Language.Arduino {
<#
.SYNOPSIS
    Arduino Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Arduino files.
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
    The C++ Inline Transpiler will consider the following syntax to be empty:
    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.(?>ino)$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition =
New-Module {
<#
.SYNOPSIS
    Arduino Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate Arduino files.
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
    The C++ Inline Transpiler will consider the following syntax to be empty:
    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.(?>ino)$')]
param()
# Any Language can be parsed with a series of regular expresssions.
$startComment = '/\*' # * Start Comments ```\*```
$endComment   = '\*/' # * End Comments   ```/*```
$Whitespace   = '[\s\n\r]{0,}'
# * IgnoredContext ```String.empty```, ```null```, blank strings and characters
$IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
# To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
$StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language.Arduino")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

