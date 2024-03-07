[ValidatePattern("(?>PowerShell|Language)")]
param()


function Language.PowerShell {
<#
    .SYNOPSIS
        PowerShell PipeScript Language Definition
    .DESCRIPTION
        PipeScript Language Definition for PowerShell.

        Unlike most other languages, this does not allow for the templating of PowerShell (use PipeScript for that).

        This language definition is used to help identify PowerShell files and provide functionality that improves PowerShell.
    #>
[ValidatePattern("\.ps1$")]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # PowerShell files end in .ps1
    $FilePattern = '\.ps1$'

    # PowerShell block comments are `<#` `#>`:
    $StartComment = '<\#'
    $EndComment   = '\#>'
    $LanguageName = 'PowerShell'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.PowerShell")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


