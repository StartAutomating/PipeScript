
function Language.Eiffel {
<#
    .SYNOPSIS
        Eiffel Template Transpiler.
    .DESCRIPTION
        Allows PipeScript to be used to generate Eiffel.
        
        Because Eiffel only allow single-line comments, this is done using a pair of comment markers.
        -- { or -- PipeScript{  begins a PipeScript block
        -- } or -- }PipeScript  ends a PipeScript block                
    #>
[ValidatePattern('\.e$')]
param(
                    
                )
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    $LanguageName = 'Eiffel'
    $startComment = '(?>(?<IsSingleLine>--)\s{0,}(?:PipeScript)?\s{0,}\{)'
$endComment   = '(?>--\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'
$StartPattern = "(?<PSStart>${startComment})"
$EndPattern   = "(?<PSEnd>${endComment})"
$LinePattern   = "^\s{0,}--\s{0,}"
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.Eiffel")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


