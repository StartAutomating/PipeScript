[ValidatePattern("(?>Conf|Language)\s")]
param()

Language function Conf {
    <#
    .SYNOPSIS
        Conf PipeScript Language Definition
    .DESCRIPTION
        Allows PipeScript to generate conf files    
    #>
    [ValidatePattern('\.conf$')]
    param()

    $FilePattern = '\.conf'

    # Conf supports single line comments only.  They start with `;` or `#`
    $SingleLineCommentStart = "[;#]"
    
    # Any Language can be parsed with a series of regular expresssions.
    # For languages that only support single comments:
    # * The capture group IsSingleLine must be defined.
    # * Whitespace should not be allowed (it makes nested blocks hard to end)
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
    $endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"

    # Conf files are a data language
    $DataLanguage = $true
    # and are generally case sensitive.
    $CaseSensitive = $true
}
