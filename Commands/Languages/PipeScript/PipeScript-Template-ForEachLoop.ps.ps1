Template function PipeScript.ForEach {
    <#
    .SYNOPSIS
        Template for a PipeScript `foreach` Loop
    .DESCRIPTION
        Template for a `foreach` loop in PipeScript (which is really just a foreach loop in PowerShell)
    .NOTES
        If provided a PowerShell foreach loop's AST as pipeline input, this should produce the same script.
    #>    
    param(
    # The For Loop's Initialization.
    # This initializes the loop.
    [vbn()]    
    [string]
    $Variable,

    # The For Loop's Condition.
    # This determine if the loop should continue running.
    [vbn()]
    [string]
    $Condition,
    
    # The body of the loop
    [vbn()]
    [string]
    $Body,

    # The language keyword that represents a `foreach` loop.  This is usually `foreach`.
    [vbn()]
    [string]
    $ForEachKeyword = 'foreach',

    # The language keyword that separates a variable and condition.  This is usually `in`.
    [vbn()]
    [string]
    $ForEachInKeyword = 'in',

    # The sub expression start sequence. This is usually `(`.
    [vbn()]
    [string]
    $SubExpressionStart = '(',
    
    # The sub expression end sequence. This is usually `)`.
    [vbn()]
    [string]
    $SubExpressionEnd = ')',

    # The start of a block.  This is usually `{`
    [string]
    $BlockStart = '{',

    # The end of a block.  This is usually `}`
    [string]
    $BlockEnd = '}'
    )

    process {
        if ($body -match '^\{') {
            $body = $body -replace '^\s{0,}\{' -replace '\}\s{0,}$'
        }

        @(
            $ForEachKeyword
            $SubExpressionStart
            (
                $Variable,
                    $ForEachInKeyword,
                        $Condition -join ' '
            )
            $SubExpressionEnd
            $BlockStart
            $Body
            $blockEnd
        ) -join ' '            
    }
}

