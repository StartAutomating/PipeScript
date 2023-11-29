Language function Eiffel {
    <#
    .SYNOPSIS
        Eiffel PipeScript Language Definition.
    .DESCRIPTION
        Allows PipeScript to be used to generate Eiffel.
        
        Because Eiffel only allow single-line comments, this is done using a pair of comment markers.

        -- { or -- PipeScript{  begins a PipeScript block

        -- } or -- }PipeScript  ends a PipeScript block                
    #>
    [ValidatePattern('\.e$')]
    param(
    )

    $FilePattern = '\.e$'

    # We start off by declaring a number of regular expressions:
    $startComment = '(?>(?<IsSingleLine>--)\s{0,}(?:PipeScript)?\s{0,}\{)'
    $endComment   = '(?>--\s{0,}\}\s{0,}(?:PipeScript)?\s{0,})'        
    $StartPattern = "(?<PSStart>${startComment})"
    $EndPattern   = "(?<PSEnd>${endComment})"

    # Using -LinePattern will skip any inline code not starting with --
    $LinePattern   = "^\s{0,}--\s{0,}"
}
