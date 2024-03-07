[ValidatePattern("(?>G-?Code|Language)[\s\p{P}]")]
param()


function Language.GCode {
<#
    .SYNOPSIS
        GCode PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate GCode.

        PipeScript can be embedded within comments of GCode.

        `'{` marks the start of a PipeScript block
        `'}` marks the end of a PipeScript block
        
    #>
[ValidatePattern('\.(?>gx|gcode|nc)$')]
param()
$this = $myInvocation.MyCommand
if (-not $this.Self) {
$languageDefinition = New-Module {
    param()

    # GCode files end in `.gx`, `.gcode`, or `.nc`
    $FilePattern  = '\.(?>gx|gcode|nc)$'

    # GCode supports single line comments only.  They start with `;`
    $SingleLineCommentStart = ";"
    
    # Any Language can be parsed with a series of regular expresssions.
    # For languages that only support single comments:
    # * The capture group IsSingleLine must be defined.
    # * Whitespace should not be allowed (it makes nested blocks hard to end)
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
    $endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"
    $LanguageName = 'GCode'
    Export-ModuleMember -Variable * -Function * -Alias *
} -AsCustomObject
$languageDefinition.pstypenames.clear()
$languageDefinition.pstypenames.add("Language")
$languageDefinition.pstypenames.add("Language.GCode")
$this.psobject.properties.add([PSNoteProperty]::new('Self',$languageDefinition))
}
$this.Self
}


