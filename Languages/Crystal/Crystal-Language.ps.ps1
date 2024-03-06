[ValidatePattern("(?>Crystal|Language)\s")]
param()

Language function Crystal {
    <#
    .SYNOPSIS
        Crystal PipeScript language definition
    .DESCRIPTION
        Defines the Crystal language within PipeScript.

        This allows Crystal to be generated with PipeScript.

        It also allows PipeScript to Implicitly Interpret Crystal.
    .LINK
        https://crystal-lang.org/
    #>
    [ValidatePattern('\.cr$')]
    param()

    $FilePattern = '\.cr$'

    $SingleLineCommentStart = '\#'
    # Any Language can be parsed with a series of regular expresssions.
    # For languages that only support single comments:
    # * The capture group IsSingleLine must be defined.
    # * Whitespace should not be allowed (it makes nested blocks hard to end)
    $startComment = "(?>(?<IsSingleLine>$SingleLineCommentStart)(?>PipeScript|PS)?\{)"
    $endComment   = "(?>$SingleLineCommentStart(?:PipeScript)?\})"

    # To support templates, a language has to declare `$StartPattern` and `$EndPattern`:
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"

    # A language can also declare a `$LinePattern`.  If it does, any inline code that does not match this pattern will be skipped.
    # Using -LinePattern will skip any inline code not starting with #

    # Note:  Parameter blocks cannot begin on the same line as the opening brace
    $LinePattern   = "^\s{0,}$SingleLineCommentStart\s{0,}"
}
