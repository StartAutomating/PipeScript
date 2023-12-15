
function Language.PipeScript {
<#
    .SYNOPSIS
        PipeScript Language Definition
    .DESCRIPTION
        PipeScript Language Definition for itself.

        This is primarily used as an anchor 

    #>

param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # PipeScript files end in ps1.ps1 or .ps.ps1.
    $FilePattern = '\.ps(?:1?)\.ps1$'

    # PipeScript block comments are `<#` `#>`
    $StartComment = '<\#'
    $EndComment   = '\#>'
    $LanguageName = 'PipeScript'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.PipeScript")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


