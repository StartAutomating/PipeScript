
function Language.WebAssembly {
<#
.SYNOPSIS
    WebAssembly Template Transpiler.
.DESCRIPTION
    Allows PipeScript to generate WebAssembly.    
    Multiline comments blocks like this ```(;{
    };)``` will be treated as blocks of PipeScript.
#>
[ValidatePattern('\.wat$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'WebAssembly'
    $startComment = '\(\;'
$endComment   = '\;\)'
$Whitespace   = '[\s\n\r]{0,}'
$startPattern = "(?<PSStart>${startComment}\{$Whitespace)"
$endPattern   = "(?<PSEnd>$Whitespace\}${endComment}\s{0,})"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.WebAssembly")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


