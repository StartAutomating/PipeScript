
function Language.PHP {
<#
.SYNOPSIS
    PHP Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate PHP.
    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
    JavaScript/CSS/PHP comment blocks like ```/*{}*/``` will also be treated as blocks of PipeScript.
#>
[ValidatePattern('\.php$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'PHP'
    $startComment = '(?><\!--|/\*)'
$endComment   = '(?>-->|\*/)'
$Whitespace   = '[\s\n\r]{0,}'
$startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.PHP")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


