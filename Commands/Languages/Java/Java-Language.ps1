
function Language.Java {
<#
    .SYNOPSIS
        Java PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate Java.

        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.

        Multiline comments can be preceeded or followed by 'empty' syntax, which will be ignored.    

        The Java Inline PipeScript Transpiler will consider the following syntax to be empty:

        * ```null```
        * ```""```
        * ```''```
    #>
[ValidatePattern('\.(?>java)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    $FilePattern = '\.(?>java)$'

    # We start off by declaring a number of regular expressions:
    $startComment = '/\*' # * Start Comments ```\*```
    $endComment   = '\*/' # * End Comments   ```/*```
    $Whitespace   = '[\s\n\r]{0,}'
    # * IgnoredContext ```String.empty```, ```null```, blank strings and characters
    $IgnoredContext = "(?<ignore>(?>$("null", '""', "''" -join '|'))\s{0,}){0,1}"
    
    $StartPattern = "(?<PSStart>${IgnoredContext}${startComment}\{$Whitespace)"    
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,}${IgnoredContext})"

    # Java's compiler is "javac" (if found)
    $Compiler = $ExecutionContext.SessionState.InvokeCommand.GetCommand('javac','Application')
    $LanguageName = 'Java'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Java")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

