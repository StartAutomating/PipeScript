[ValidatePattern("(?>Vue|Language)[\s\p{P}]")]
param()


function Language.Vue {
<#
.SYNOPSIS
    Vue PipeScript Language Definition.
.DESCRIPTION
    Allows PipeScript to generate Vue files.

    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.

    JavaScript/CSS comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.vue$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param(
)
    $FilePattern = '\.vue$'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?><\!--|/\*)' # * Start Comments ```<!--```
    $endComment   = '(?>-->|\*/)'   # * End Comments   ```-->```
    $Whitespace   = '[\s\n\r]{0,}'
    # * StartRegex     ```$StartComment + '{' + $Whitespace```
    $StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
    # * EndRegex       ```$whitespace + '}' + $EndComment```
    $EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    $LanguageName = 'Vue'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Vue")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

