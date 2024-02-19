
function Language.C {
<#
    .SYNOPSIS
        PipeScript C Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate C files.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.

        The C will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.c$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
    )

    $FilePattern = '\.c$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartRegex     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    $LanguageName = 'C'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.C")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

