
function Language.Razor {
<#
.SYNOPSIS
    Razor PipeScript Language Definition.    
.DESCRIPTION
    Allows PipeScript to generate Razor.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.

    Razor comment blocks like ```@*{}*@``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.(cshtml|razor)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
)
    $FilePattern = '\.(cshtml|razor)$'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*|\@\*)' 
    $endComment   = '(?>-->|\*/|\*@)'
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartPattern     ```$StartComment + '{' + $Whitespace```
    $startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndPattern       ```$whitespace + '}' + $EndComment```
    $endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    $LanguageName = 'Razor'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Razor")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


