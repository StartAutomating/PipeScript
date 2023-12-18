
function Language.BrightScript {
<#
    .SYNOPSIS
        BrightScript PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate BrightScript.

        PipeScript can be embedded within comments of BrightScript.

        `'{` marks the start of a PipeScript block
        `'}` marks the end of a PipeScript block
        
    #>
[ValidatePattern('\.brs$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # BrightScript files end in `.brs`.
    $FilePattern  = '\.brs$'

    # BrightScript supports single line comments only.
    $SingleLineCommentStart = "'"
    
    # Any Language can be parsed with a series of regular expresssions.
    # For languages that only support single comments:
    # * The capture group IsSingleLine must be defined.
    # * Whitespace should not be allowed (it makes nested blocks hard to end)
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
    $endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"
    $LanguageName = 'BrightScript'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.BrightScript")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


