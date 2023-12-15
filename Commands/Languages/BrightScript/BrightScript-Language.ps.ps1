Language function BrightScript {
    <#
    .SYNOPSIS
        BrightScript PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate BrightScript.

        PipeScript can be embedded within comments of BrightScript.

        `'{` marks the start of a PipeScript block
        `'}` marks the end of a PipeScript block
        
    #>
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


}
