
function Language.XAML {
<#
.SYNOPSIS
    XAML Language Definition.
.DESCRIPTION
    Allows PipeScript to generate XAML.
    Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
    Executed output will be converted to XAML
#>
[ValidatePattern('\.xaml$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'XAML'
    $startComment = '<\!--'
$endComment   = '-->'
$Whitespace   = '[\s\n\r]{0,}'
$startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.XAML")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


