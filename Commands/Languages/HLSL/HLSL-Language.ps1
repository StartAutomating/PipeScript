
function Language.HLSL {
<#
    .SYNOPSIS
        HLSL Language Definition.
    .DESCRIPTION
        Allows PipeScript to generate HLSL.
        Multiline comments with /*{}*/ will be treated as blocks of PipeScript.
    #>
[ValidatePattern('\.hlsl$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'HLSL'
    $startComment = '/\*'
$endComment   = '\*/'
$Whitespace   = '[\s\n\r]{0,}'
$StartPattern = "(?<PSStart>${startComment}\{$Whitespace)"
$EndPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.HLSL")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}

