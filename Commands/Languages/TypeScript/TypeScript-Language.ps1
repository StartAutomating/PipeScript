
function Language.TypeScript {
<#
.SYNOPSIS
    TypeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate TypeScript.
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
    This is so that Inline PipeScript can be used with operators, and still be valid TypeScript syntax. 
    The TypeScript Inline Transpiler will consider the following syntax to be empty:
    * ```undefined```
    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.tsx{0,1}')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition =
New-Module {
<#
.SYNOPSIS
    TypeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate TypeScript.
    Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.
    This is so that Inline PipeScript can be used with operators, and still be valid TypeScript syntax. 
    The TypeScript Inline Transpiler will consider the following syntax to be empty:
    * ```undefined```
    * ```null```
    * ```""```
    * ```''```
#>
[ValidatePattern('\.tsx{0,1}')]
param()
    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("undefined", "null", '""', "''" -join '|'))\s{0,}){0,1}"
    # * StartPattern     ```$IgnoredContext + $StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment + $ignoredContext```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language.TypeScript")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

