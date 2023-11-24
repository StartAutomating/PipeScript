
function Language.ATOM {
<#
    .SYNOPSIS
        ATOM Language Definition
    .DESCRIPTION
        Defines ATOM within PipeScript.
        This allows ATOM to be templated.
        
        Multiline comments blocks like this ```<!--{}-->``` will be treated as blocks of PipeScript.
    #>
[ValidatePattern('\.atom$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'ATOM'
    $startComment = '<\!--'
$endComment   = '-->'
$Whitespace   = '[\s\n\r]{0,}'
$StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
$EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.ATOM")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

